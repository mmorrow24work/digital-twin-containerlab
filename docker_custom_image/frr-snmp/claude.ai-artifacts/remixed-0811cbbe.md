# FRR with SNMP and AgentX Protocol Support Setup Guide

## Overview
This guide walks you through creating an FRR image with SNMP and AgentX protocol support using the official FRRouting Docker image as base, enabling network monitoring and management capabilities.

## Prerequisites
- Docker installed on your system
- Basic understanding of FRR and SNMP concepts
- Root/sudo access for configuration

## Step 1: Create Dockerfile Using Official FRR Image

```dockerfile
# Use official FRR image as base (already compiled with --enable-snmp)
FROM frrouting/frr:v7.5.1

# Switch to root to install packages
USER root

# Install SNMP daemon and related packages (Alpine packages)
RUN apk add --no-cache \
    net-snmp \
    net-snmp-tools \
    net-snmp-dev \
    procps \
    bash

# Create SNMP directories and set permissions (Alpine specific)
RUN mkdir -p /etc/snmp /var/lib/net-snmp /var/log/snmp && \
    addgroup -S snmp 2>/dev/null || true && \
    adduser -S -G snmp -s /bin/false snmp 2>/dev/null || true && \
    chown -R snmp:snmp /var/lib/net-snmp /var/log/snmp 2>/dev/null || true && \
    chmod 755 /etc/snmp

# Copy configuration files
COPY configs/snmp/ /etc/snmp/
COPY configs/frr/ /etc/frr/
COPY start-frr-snmp.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start-frr-snmp.sh

# Set proper permissions for FRR configs
RUN chown -R frr:frr /etc/frr && \
    chmod 640 /etc/frr/*.conf

# Expose SNMP and FRR management ports
EXPOSE 161/udp 2601 2605

# Use custom start script (override FRR entrypoint)
ENTRYPOINT ["/usr/local/bin/start-frr-snmp.sh"]
```

## Step 2: Configuration Overview

The setup requires configuring three key components:

1. **SNMP Master Agent** (`/etc/snmp/snmpd.conf`)
   - Must include `master agentx` directive
   - Configure AgentX socket and permissions
   - Set community strings and access control

2. **FRR Daemons** (`/etc/frr/daemons` and individual configs)
   - Enable desired routing daemons
   - Add `agentx` command to each daemon configuration

3. **FRR Main Configuration** (`/etc/frr/frr.conf`)
   - Include global `agentx` directive
   - Configure routing protocols as needed

## Step 3: Key Configuration Requirements

### SNMP Configuration Requirements:
- `master agentx` - Enables master agent mode
- `agentXSocket tcp:localhost:705` - AgentX communication socket
- `agentXPerms 0660 0550` - Proper permissions for FRR access (Alpine)
- Community strings for read/write access from any IP address
- `rocommunity public` - Read-only access from any IP
- `rwcommunity private` - Read-write access from any IP (use with caution)
- `sysName` - Automatically uses container hostname (no hardcoding needed)
- `trap2sink PC2 public` - Send SNMPv2c traps to PC2 with 'public' community
- `trapcommunity public` - Community string for outgoing traps
- `authtrapenable 1` - Enable authentication failure traps

### FRR Configuration Requirements:
- `agentx` command in global configuration
- Individual daemons must be enabled in `/etc/frr/daemons`
- Each daemon can have `agentx` in its individual config file

## Step 4: Startup Sequence Importance

**Critical**: The SNMP master agent (`snmpd`) must be started **before** any FRR daemons. FRR daemons acting as AgentX subagents need to connect to the master agent on startup.

Startup order:
1. Start SNMP daemon (`snmpd`)
2. Wait for SNMP daemon to initialize
3. Start FRR daemons
4. Verify AgentX connections

## Step 5: Create Startup Script

Create `start-frr-snmp.sh`:

```bash
#!/bin/bash
# start-frr-snmp.sh

set -e

echo "Starting FRR with SNMP and AgentX support..."

# Function to check if service is running
check_service() {
    local service=$1
    local max_attempts=30
    local attempt=0
    
    while [ $attempt -lt $max_attempts ]; do
        if pgrep -f $service > /dev/null; then
            echo "$service is running"
            return 0
        fi
        sleep 1
        attempt=$((attempt + 1))
    done
    
    echo "ERROR: $service failed to start"
    return 1
}

# Start SNMP daemon first (must be running before FRR daemons for AgentX)
echo "Starting SNMP master agent..."
snmpd -f -Lo -c /etc/snmp/snmpd.conf &
SNMPD_PID=$!

# Wait for SNMP daemon to initialize
sleep 3

# Verify SNMP daemon is running
if ! check_service snmpd; then
    echo "SNMP daemon failed to start, exiting..."
    exit 1
fi

# Start FRR daemons using the frrinit script directly
echo "Starting FRR daemons..."
/bin/bash /usr/lib/frr/frrinit.sh start

# Wait for FRR to initialize
sleep 5

# Verify key FRR services are running
echo "Verifying FRR services..."
check_service zebra
if grep -q "bgpd=yes" /etc/frr/daemons; then
    check_service bgpd
fi
if grep -q "ospfd=yes" /etc/frr/daemons; then
    check_service ospfd
fi

# Verify AgentX connection
echo "Checking AgentX connectivity..."
sleep 2
if timeout 10 vtysh -c "show agentx" > /dev/null 2>&1; then
    echo "AgentX is properly connected"
else
    echo "WARNING: AgentX connection may have issues - this is normal if no routing protocols are configured"
fi

echo "All services started successfully!"
echo "SNMP Agent listening on UDP port 161"
echo "FRR VTY shell available on TCP port 2601"

# Keep container running and show logs
tail -f /dev/null
```

## Step 6: Build the Docker Image

```bash
# Create project directory
mkdir frr-snmp-image
cd frr-snmp-image

# Create directory structure
mkdir -p configs/frr
mkdir -p configs/snmp

# Create the Dockerfile
cat > Dockerfile << 'EOF'
# Use official FRR image as base (already compiled with --enable-snmp)
FROM frrouting/frr:v7.5.1

# Switch to root to install packages
USER root

# Install SNMP daemon and related packages (Alpine packages)
RUN apk add --no-cache \
    net-snmp \
    net-snmp-tools \
    net-snmp-dev \
    procps \
    bash

# Create SNMP directories and set permissions (Alpine specific)
RUN mkdir -p /etc/snmp /var/lib/net-snmp /var/log/snmp && \
    addgroup -S snmp 2>/dev/null || true && \
    adduser -S -G snmp -s /bin/false snmp 2>/dev/null || true && \
    chown -R snmp:snmp /var/lib/net-snmp /var/log/snmp 2>/dev/null || true && \
    chmod 755 /etc/snmp

# Copy configuration files
COPY configs/snmp/ /etc/snmp/
COPY configs/frr/ /etc/frr/
COPY start-frr-snmp.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start-frr-snmp.sh

# Set proper permissions for FRR configs
RUN chown -R frr:frr /etc/frr && \
    chmod 640 /etc/frr/*.conf

# Expose SNMP and FRR management ports
EXPOSE 161/udp 2601 2605

# Use custom start script (override FRR entrypoint)
ENTRYPOINT ["/usr/local/bin/start-frr-snmp.sh"]
EOF

# Create SNMP configuration
cat > configs/snmp/snmpd.conf << 'EOF'
# Master AgentX configuration - REQUIRED for FRR AgentX support
master agentx

# AgentX socket configuration
agentXSocket tcp:localhost:705
agentXTimeout 1
agentXRetries 5

# Basic SNMP configuration - ALLOW ACCESS FROM ANY IP
rocommunity public
rwcommunity private

# System information
sysLocation "FRR Docker Container"
sysContact "admin@example.com"
# sysName will automatically use the container hostname

# SNMP Trap Configuration - Send traps to PC2
# SNMPv2c traps to PC2 (replace with actual IP if needed)
trap2sink PC2 public
trap2sink PC2:162 public

# Alternative: Send to specific IP address
# trap2sink 192.168.1.100 public
# trap2sink 192.168.1.100:162 public

# SNMPv1 traps (optional, for legacy systems)
# trapsink PC2 public

# Trap community string
trapcommunity public

# Enable various trap types
authtrapenable 1
# linkUpDownNotifications yes

# Access control (allow access from any IP address)
# Allow read-only access from any IP with 'public' community
com2sec readonly default public

# Allow read-write access from any IP with 'private' community  
com2sec readwrite default private

# Map security names to groups
group MyROGroup v1 readonly
group MyROGroup v2c readonly
group MyRWGroup v1 readwrite
group MyRWGroup v2c readwrite

# Define views
view all included .1 80
view system included .1.3.6.1.2.1.1

# Grant access
access MyROGroup "" any noauth exact all none none
access MyRWGroup "" any noauth exact all all none

# Logging
logTimestamp yes

# AgentX permissions - allow FRR user to connect
# Note: Alpine might handle this differently, so we'll be permissive
agentXPerms 0660 0550

# Security note: This configuration allows SNMP access from any IP
# For production use, restrict access to specific networks:
# rocommunity public 192.168.1.0/24
# rwcommunity private 10.0.0.0/8

# To modify trap destination:
# Replace "PC2" with actual hostname or IP address of your trap receiver
# Example: trap2sink 192.168.1.50 public
EOF

# Create FRR daemon configuration
cat > configs/frr/daemons << 'EOF'
# This file tells the frr package which daemons to start.
zebra=yes
bgpd=yes
ospfd=yes
ospf6d=no
ripd=no
ripngd=no
isisd=no
pimd=no
ldpd=no
nhrpd=no
eigrpd=no
babeld=no
sharpd=no
pbrd=no
bfdd=no
fabricd=no
vrrpd=no
pathd=no

zebra_options="  --daemon -A 127.0.0.1"
bgpd_options="   --daemon -A 127.0.0.1"
ospfd_options="  --daemon -A 127.0.0.1"
ospf6d_options=" --daemon -A ::1"
ripd_options="   --daemon -A 127.0.0.1"
ripngd_options=" --daemon -A ::1"
isisd_options="  --daemon -A 127.0.0.1"
pimd_options="   --daemon -A 127.0.0.1"
ldpd_options="   --daemon -A 127.0.0.1"
nhrpd_options="  --daemon -A 127.0.0.1"
eigrpd_options=" --daemon -A 127.0.0.1"
babeld_options=" --daemon -A 127.0.0.1"
sharpd_options=" --daemon -A 127.0.0.1"
pbrd_options="   --daemon -A 127.0.0.1"
bfdd_options="   --daemon -A 127.0.0.1"
fabricd_options="--daemon -A 127.0.0.1"
vrrpd_options="  --daemon -A 127.0.0.1"

vtysh_enable=yes
zebra_wrap=no
bgpd_wrap=no
ospfd_wrap=no
ospf6d_wrap=no
ripd_wrap=no
ripngd_wrap=no
isisd_wrap=no
pimd_wrap=no
ldpd_wrap=no
nhrpd_wrap=no
eigrpd_wrap=no
babeld_wrap=no
sharpd_wrap=no
pbrd_wrap=no
bfdd_wrap=no
fabricd_wrap=no
vrrpd_wrap=no
EOF

# Create main FRR configuration with AgentX enabled
cat > configs/frr/frr.conf << 'EOF'
frr version 7.5.1
frr defaults traditional
! hostname will be set automatically to container hostname
log syslog informational
!
# Enable AgentX for SNMP - THIS IS CRITICAL
agentx
!
# Sample interface configuration
interface lo
 ip address 127.0.0.1/8
!
# Sample BGP configuration
router bgp 65001
 bgp router-id 1.1.1.1
 bgp log-neighbor-changes
 ! Add neighbors as needed
 ! neighbor 192.168.1.1 remote-as 65002
!
# Sample OSPF configuration  
router ospf
 ospf router-id 1.1.1.1
 log-adjacency-changes
 ! Add networks as needed
 ! network 192.168.1.0/24 area 0
!
line vty
!
EOF

# Create startup script
cat > start-frr-snmp.sh << 'EOF'
#!/bin/bash
# start-frr-snmp.sh

set -e

echo "Starting FRR with SNMP and AgentX support..."

# Function to check if service is running
check_service() {
    local service=$1
    local max_attempts=30
    local attempt=0
    
    while [ $attempt -lt $max_attempts ]; do
        if pgrep -f $service > /dev/null; then
            echo "$service is running"
            return 0
        fi
        sleep 1
        attempt=$((attempt + 1))
    done
    
    echo "ERROR: $service failed to start"
    return 1
}

# Start SNMP daemon first (must be running before FRR daemons for AgentX)
echo "Starting SNMP master agent..."
snmpd -f -Lo -c /etc/snmp/snmpd.conf &
SNMPD_PID=$!

# Wait for SNMP daemon to initialize
sleep 3

# Verify SNMP daemon is running
if ! check_service snmpd; then
    echo "SNMP daemon failed to start, exiting..."
    exit 1
fi

# Start FRR daemons using the frrinit script directly
echo "Starting FRR daemons..."
/bin/bash /usr/lib/frr/frrinit.sh start

# Wait for FRR to initialize
sleep 5

# Verify key FRR services are running
echo "Verifying FRR services..."
check_service zebra
if grep -q "bgpd=yes" /etc/frr/daemons; then
    check_service bgpd
fi
if grep -q "ospfd=yes" /etc/frr/daemons; then
    check_service ospfd
fi

# Verify AgentX connection
echo "Checking AgentX connectivity..."
sleep 2
if timeout 10 vtysh -c "show agentx" > /dev/null 2>&1; then
    echo "AgentX is properly connected"
else
    echo "WARNING: AgentX connection may have issues - this is normal if no routing protocols are configured"
fi

echo "All services started successfully!"
echo "SNMP Agent listening on UDP port 161"
echo "FRR VTY shell available on TCP port 2601"

# Keep container running and show logs
tail -f /dev/null
EOF

# Make startup script executable
chmod +x start-frr-snmp.sh

# Build the image
docker build -t frr-snmp:v7.5.1 .
```

## Important Notes

**Key Success Factors:**
1. **ENTRYPOINT vs CMD**: The Dockerfile uses `ENTRYPOINT` to override the base image's startup
2. **Direct FRR initialization**: Uses `/bin/bash /usr/lib/frr/frrinit.sh start` instead of docker-start to avoid circular calls  
3. **Proper startup order**: SNMP daemon starts before FRR daemons for AgentX connectivity
4. **Container persistence**: Uses `tail -f /dev/null` to keep container running
5. **Dynamic hostname**: SNMP sysName automatically reflects container hostname
6. **SNMP trap support**: Configured to send traps to PC2 for network monitoring

**SNMP Trap Configuration:**
- Traps are sent to **PC2** on port **162** using **SNMPv2c**
- Trap community string is **"public"**
- Both hostname and IP address formats are supported
- Authentication failure traps are enabled

## Step 7: Run the Container

```bash
# Run with host networking (recommended for routing)
docker run -d \
  --name frr-snmp-router \
  --privileged \
  --network host \
  --restart unless-stopped \
  -v frr-logs:/var/log/frr \
  frr-snmp:v7.5.1

# Run with custom hostname (affects SNMP sysName)
docker run -d \
  --name frr-snmp-router \
  --hostname my-custom-router \
  --privileged \
  --network host \
  --restart unless-stopped \
  -v frr-logs:/var/log/frr \
  frr-snmp:v7.5.1

# Alternative: Run with custom network and port mapping
docker run -d \
  --name frr-snmp-router \
  --privileged \
  -p 161:161/udp \
  -p 2601:2601 \
  -p 2605:2605 \
  --restart unless-stopped \
  frr-snmp:v7.5.1

# Run interactively for testing and configuration
docker run -it \
  --name frr-snmp-test \
  --privileged \
  --network host \
  frr-snmp:v7.5.1 /bin/bash

# Check container logs
docker logs -f frr-snmp-router

# Access FRR shell
docker exec -it frr-snmp-router vtysh
```

**Note:** The SNMP sysName (OID 1.3.6.1.2.1.1.5.0) will automatically reflect the container's hostname. Use `--hostname` parameter to set a custom name, otherwise Docker will generate a random hostname.

## Step 8: Verify SNMP and AgentX Configuration

### Test SNMP connectivity and traps:
```bash
# From host system - test basic SNMP system information
snmpget -v2c -c public localhost 1.3.6.1.2.1.1.1.0

# Test SNMP system name (should return the container hostname)
snmpget -v2c -c public localhost 1.3.6.1.2.1.1.5.0

# Get container hostname for comparison
docker exec frr-snmp-router hostname

# Test from remote IP (replace with actual container/host IP)
snmpget -v2c -c public <CONTAINER_IP> 1.3.6.1.2.1.1.5.0

# Test read-write access with private community
snmpset -v2c -c private localhost 1.3.6.1.2.1.1.6.0 s "New Location"

# Test SNMP walk of system tree
snmpwalk -v2c -c public localhost 1.3.6.1.2.1.1

# Test FRR specific MIBs (if available)
snmpwalk -v2c -c public localhost 1.3.6.1.4.1.3317

# Test AgentX subagent connectivity
snmpwalk -v2c -c public localhost 1.3.6.1.2.1.14  # OSPF MIB
snmpwalk -v2c -c public localhost 1.3.6.1.2.1.15  # BGP MIB

# Test SNMP trap functionality
# Send a test trap from the container
docker exec frr-snmp-router snmptrap -v2c -c public localhost '' 1.3.6.1.4.1.8072.2.3.0.1 1.3.6.1.4.1.8072.2.3.2.1 s "Test trap from FRR container"

# Monitor for traps on PC2 (if snmptrapd is running on PC2)
# On PC2, run: sudo snmptrapd -f -Lo

# Verify trap configuration
docker exec frr-snmp-router snmpwalk -v2c -c public localhost 1.3.6.1.6.3.1.1.3.0  # snmpTrapOID

# Find container IP for remote testing
docker inspect frr-snmp-router | grep IPAddress
```

**Expected successful output:**
```bash
# System name query should return the actual container hostname:
# (hostname will vary based on Docker's generated name or your --name parameter)
SNMPv2-MIB::sysName.0 = STRING: "a938b01869dc"  # or your custom container name

# Compare with actual container hostname:
docker exec frr-snmp-router hostname
# Should match: a938b01869dc

# Process check should show snmpd running:
docker exec frr-snmp-router ps aux | grep snmpd
root           7  0.0  0.1   8800  6484 ?        S    10:01   0:00 snmpd -f -Lo -c /etc/snmp/snmpd.conf

# Test trap should send successfully (no error output)
# On PC2 with snmptrapd running, you should see:
# 2025-09-02 10:15:23 localhost [UDP: [127.0.0.1]:xxxxx->[PC2]:162]:
# DISMAN-EVENT-MIB::sysUpTimeInstance = Timeticks: (12345) 2:03:45.00
# SNMPv2-MIB::snmpTrapOID.0 = OID: NET-SNMP-EXAMPLES-MIB::netSnmpExampleHeartbeatNotification
# NET-SNMP-EXAMPLES-MIB::netSnmpExampleHeartbeatRate = STRING: "Test trap from FRR container"
```

**SNMP Trap Configuration Notes:**
- Traps are configured to be sent to **PC2** on default port **162**
- Change `PC2` to the actual IP address or hostname of your trap receiver
- Ensure PC2 has an SNMP trap daemon (snmptrapd) running to receive traps
- Trap community string is set to "public"

**To customize trap destination:**
```bash
# Edit the snmpd.conf file and replace PC2 with your target:
# trap2sink 192.168.1.100 public     # Send to specific IP
# trap2sink myserver.domain.com public  # Send to hostname
```

**Security Warning:** This configuration allows SNMP access from any IP address. For production environments, restrict access to specific networks by modifying the community strings in `snmpd.conf`:
```bash
# Example: Restrict to specific networks
rocommunity public 192.168.1.0/24
rwcommunity private 10.0.0.0/8
```

### Check AgentX status inside container:
```bash
# Access the container
docker exec -it frr-snmp-router bash

# Connect to FRR VTY shell and check AgentX
vtysh -c "show agentx"

# Check individual daemon configurations
vtysh -c "show running-config" | grep -i agentx

# Verify SNMP master agent is listening (Alpine)
netstat -ulnp | grep :161
```

### Verify FRR daemon configuration:
```bash
# Connect to FRR shell
docker exec -it frr-snmp-router vtysh

# Inside vtysh:
show running-config
show agentx
show ip ospf neighbor
show ip bgp summary
show interface brief
```

### Test AgentX communication:
```bash
# From inside container, test AgentX socket
ss -tlnp | grep :705

# Check SNMP daemon logs for AgentX connections
docker exec frr-snmp-router grep -i agentx /var/log/messages 2>/dev/null || echo "No AgentX logs found"

# Verify FRR daemons connected to AgentX
docker exec frr-snmp-router snmpwalk -v2c -c public localhost 1.3.6.1.4.1
```

## Step 9: Troubleshooting

### Common issues and solutions:

1. **AgentX connection failed**
   ```bash
   # Ensure SNMP daemon started before FRR
   docker logs frr-snmp-router | grep -i "snmp"
   
   # Check if AgentX socket is available
   docker exec frr-snmp-router ss -tlnp | grep :705
   
   # Restart container with proper order
   docker restart frr-snmp-router
   ```

2. **SNMP queries timeout or fail from remote IPs**
   ```bash
   # Check if SNMP daemon is listening on all interfaces
   docker exec frr-snmp-router netstat -ulnp | grep :161
   
   # Should show: 0.0.0.0:161 (not just 127.0.0.1:161)
   
   # Test from inside container first
   docker exec frr-snmp-router snmpget -v2c -c public localhost 1.3.6.1.2.1.1.1.0
   
   # Check host firewall (if running with --network host)
   sudo ufw status
   sudo iptables -L | grep 161
   
   # If using port mapping, ensure UDP 161 is mapped
   docker run -d --name frr-snmp-router --privileged -p 161:161/udp frr-snmp:v7.5.1
   
   # Test community strings from different source IPs
   snmpget -v2c -c public <CONTAINER_IP> 1.3.6.1.2.1.1.1.0
   snmpset -v2c -c private <CONTAINER_IP> 1.3.6.1.2.1.1.6.0 s "Test Location"
   ```

3. **SNMP traps not being received on PC2**
   ```bash
   # Verify trap configuration in container
   docker exec frr-snmp-router grep -i trap /etc/snmp/snmpd.conf
   
   # Test trap sending manually
   docker exec frr-snmp-router snmptrap -v2c -c public PC2 '' 1.3.6.1.4.1.8072.2.3.0.1
   
   # Check if PC2 can be reached from container
   docker exec frr-snmp-router ping -c 3 PC2
   docker exec frr-snmp-router nslookup PC2
   
   # Verify PC2 is listening for SNMP traps (on PC2)
   sudo netstat -ulnp | grep :162
   
   # Start trap daemon on PC2 if not running
   sudo snmptrapd -f -Lo
   
   # Check for firewall blocking on PC2
   sudo ufw status | grep 162
   sudo iptables -L | grep 162
   
   # Test with IP address instead of hostname
   # Edit snmpd.conf: trap2sink 192.168.1.100 public
   docker restart frr-snmp-router
   
   # Monitor SNMP logs for trap sending errors
   docker logs frr-snmp-router | grep -i trap
   ```

3. **FRR daemons not connecting to AgentX**
   ```bash
   # Check if AgentX is enabled in FRR config
   docker exec frr-snmp-router vtysh -c "show running-config" | grep agentx
   
   # Enable AgentX in specific daemon
   docker exec -it frr-snmp-router vtysh
   configure terminal
   agentx
   end
   write memory
   ```

4. **Permission denied errors**
   ```bash
   # Check FRR configuration file permissions
   docker exec frr-snmp-router ls -la /etc/frr/
   
   # Fix permissions if needed
   docker exec frr-snmp-router chown -R frr:frr /etc/frr
   docker exec frr-snmp-router chmod 640 /etc/frr/*.conf
   ```

5. **Container fails to start or SNMP doesn't work**
   ```bash
   # Check container logs for startup messages
   docker logs frr-snmp-router
   
   # Check if both SNMP and FRR processes are running
   docker exec frr-snmp-router ps aux | grep snmpd
   docker exec frr-snmp-router ps aux | grep zebra
   
   # Test SNMP connectivity from inside container
   docker exec frr-snmp-router snmpget -v2c -c public localhost 1.3.6.1.2.1.1.5.0
   
   # If issues persist, run interactively to debug
   docker run -it --privileged --name debug-frr frr-snmp:v7.5.1 /bin/bash
   
   # Inside interactive container, manually run the startup sequence:
   snmpd -f -Lo -c /etc/snmp/snmpd.conf &
   sleep 3
   /bin/bash /usr/lib/frr/frrinit.sh start
   ```

### Useful debugging commands:

```bash
# Check all running processes in container
docker exec frr-snmp-router ps aux

# Monitor Alpine system logs (different from Debian)
docker exec frr-snmp-router dmesg | tail -20

# Test AgentX connectivity from inside container
docker exec frr-snmp-router snmpwalk -v2c -c public localhost 1.3.6.1.2.1.1

# Check FRR daemon status
docker exec frr-snmp-router vtysh -c "show version"
docker exec frr-snmp-router vtysh -c "show daemons"

# Verify network interfaces
docker exec frr-snmp-router ip addr show
```

### Performance optimization:

1. **Reduce SNMP query timeouts**
   ```bash
   # Add to snmpd.conf
   agentXTimeout 5
   agentXRetries 3
   ```

2. **Enable SNMP caching**
   ```bash
   # Add to snmpd.conf  
   cacheTimeout 300
   ```

3. **Secure SNMP access for production**
   ```bash
   # Restrict community access in snmpd.conf to specific networks
   rocommunity public 192.168.1.0/24
   rwcommunity private 10.0.0.0/8
   
   # Or restrict to specific management servers
   rocommunity public 192.168.1.100
   rwcommunity private 192.168.1.101
   
   # Use SNMPv3 for enhanced security (add to snmpd.conf)
   createUser myuser MD5 mypassword DES
   rouser myuser
   ```

## Quick Test from Scratch

Here's a complete test sequence to verify everything works including SNMP traps:

```bash
# 1. Build and run the container
mkdir frr-snmp-test && cd frr-snmp-test
# (Follow Step 6 build instructions above)
docker build -t frr-snmp:v7.5.1 .

# Run with a custom hostname for easier testing
docker run -d --name frr-snmp-router --hostname my-frr-router --privileged --network host frr-snmp:v7.5.1

# Or run with Docker's auto-generated hostname
# docker run -d --name frr-snmp-router --privileged --network host frr-snmp:v7.5.1

# 2. Verify services are running
docker logs frr-snmp-router
docker exec frr-snmp-router ps aux | grep -E "(snmpd|zebra|bgpd)"

# 3. Check container hostname
docker exec frr-snmp-router hostname

# 4. Test SNMP from localhost (sysName should match hostname)
docker exec frr-snmp-router snmpget -v2c -c public localhost 1.3.6.1.2.1.1.5.0

# 5. Test SNMP from host system
snmpget -v2c -c public localhost 1.3.6.1.2.1.1.5.0

# 6. Verify sysName matches container hostname
echo "Container hostname:"
docker exec frr-snmp-router hostname
echo "SNMP sysName:"
snmpget -v2c -c public localhost 1.3.6.1.2.1.1.5.0

# 7. Test read-write access
snmpset -v2c -c private localhost 1.3.6.1.2.1.1.6.0 s "Testing RW Access"
snmpget -v2c -c public localhost 1.3.6.1.2.1.1.6.0

# 8. Test SNMP trap functionality
# First, start trap receiver on PC2 (if available):
# On PC2: sudo snmptrapd -f -Lo

# Send a test trap from the container
docker exec frr-snmp-router snmptrap -v2c -c public PC2 '' 1.3.6.1.4.1.8072.2.3.0.1 1.3.6.1.4.1.8072.2.3.2.1 s "Test trap from FRR"

# 9. Verify trap configuration
docker exec frr-snmp-router grep -E "trap2sink|trapcommunity" /etc/snmp/snmpd.conf

# 10. Test network connectivity to trap destination
docker exec frr-snmp-router ping -c 3 PC2 || echo "PC2 not reachable - check network or replace with IP"

# 11. Test AgentX functionality
docker exec frr-snmp-router vtysh -c "show agentx"

# 12. Clean up
docker stop frr-snmp-router && docker rm frr-snmp-router
```

**Expected Results:**
- Container hostname and SNMP sysName should match exactly
- `snmpget` queries should return proper SNMP responses  
- `snmpset` commands should successfully modify values
- SNMP traps should be sent to PC2 (verify with snmptrapd on PC2)
- AgentX should show connected subagents

**Example Output:**
```bash
# If container hostname is "my-frr-router":
Container hostname:
my-frr-router

SNMP sysName:
SNMPv2-MIB::sysName.0 = STRING: "my-frr-router"

# Trap configuration verification:
trap2sink PC2 public
trap2sink PC2:162 public
trapcommunity public

# On PC2 with snmptrapd running, trap should appear as:
2025-09-02 10:15:23 <HOST> [UDP: [x.x.x.x]:xxxxx->[PC2]:162]:
DISMAN-EVENT-MIB::sysUpTimeInstance = Timeticks: (12345) 2:03:45.00
SNMPv2-MIB::snmpTrapOID.0 = OID: NET-SNMP-EXAMPLES-MIB::netSnmpExampleHeartbeatNotification
NET-SNMP-EXAMPLES-MIB::netSnmpExampleHeartbeatRate = STRING: "Test trap from FRR"
```

**Important Notes for SNMP Traps:**
- Replace "PC2" in snmpd.conf with actual IP/hostname of your trap receiver
- Ensure PC2 has snmptrapd running: `sudo snmptrapd -f -Lo`
- Check network connectivity between container and PC2
- Default trap port is UDP 162
- Trap community string is "public" (can be changed in snmpd.conf)

This completes the comprehensive setup guide for FRR with SNMP and AgentX support using the official FRRouting Docker image. The key points are:

- **Master AgentX directive** in `/etc/snmp/snmpd.conf`
- **AgentX command** enabled in each FRR daemon configuration
- **Proper startup order**: SNMP daemon must start before FRR daemons
- **Official FRR image**: Already compiled with `--enable-snmp` option
- **Alpine Linux compatibility**: Uses correct package names and paths
- **Dynamic hostname support**: sysName automatically reflects container hostname
- **SNMP trap support**: Sends traps to PC2 for network event monitoring

The setup provides full SNMP monitoring capabilities for your FRR routing infrastructure with AgentX protocol support and trap notification to network management systems.
