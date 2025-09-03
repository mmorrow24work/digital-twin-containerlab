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
- Community strings for read/write access

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

# Basic SNMP configuration
rocommunity public localhost
rocommunity public 127.0.0.1
rwcommunity private localhost

# System information
sysLocation "FRR Docker Container"
sysContact "admin@example.com"
sysName "frr-snmp-router"

# Access control (simplified for Alpine net-snmp)
# Allow read-only access from localhost with 'public' community
com2sec readonly localhost public
com2sec readonly 127.0.0.1 public

# Allow read-write access from localhost with 'private' community  
com2sec readwrite localhost private
com2sec readwrite 127.0.0.1 private

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
hostname frr-snmp-router
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

## Step 8: Verify SNMP and AgentX Configuration

### Test SNMP connectivity:
```bash
# From host system - test basic SNMP system information
snmpget -v2c -c public localhost 1.3.6.1.2.1.1.1.0

# Test SNMP system name (should return "frr-snmp-router")
snmpget -v2c -c public localhost 1.3.6.1.2.1.1.5.0

# Test SNMP walk of system tree
snmpwalk -v2c -c public localhost 1.3.6.1.2.1.1

# Test FRR specific MIBs (if available)
snmpwalk -v2c -c public localhost 1.3.6.1.4.1.3317

# Test AgentX subagent connectivity
snmpwalk -v2c -c public localhost 1.3.6.1.2.1.14  # OSPF MIB
snmpwalk -v2c -c public localhost 1.3.6.1.2.1.15  # BGP MIB
```

**Expected successful output:**
```bash
# System name query should return:
SNMPv2-MIB::sysName.0 = STRING: "frr-snmp-router"

# Process check should show snmpd running:
docker exec frr-snmp-router ps aux | grep snmpd
root           7  0.0  0.1   8800  6484 ?        S    10:01   0:00 snmpd -f -Lo -c /etc/snmp/snmpd.conf
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

2. **SNMP queries timeout**
   ```bash
   # Check firewall settings on host
   sudo ufw status
   
   # Verify SNMP daemon is listening (Alpine)
   docker exec frr-snmp-router netstat -ulnp | grep :161
   
   # Test from container first (Alpine net-snmp)
   docker exec frr-snmp-router snmpget -v2c -c public localhost 1.3.6.1.2.1.1.1.0
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

3. **Limit SNMP access**
   ```bash
   # Restrict community access in snmpd.conf
   rocommunity public 127.0.0.1
   rocommunity public [specific-management-IP]
   ```

This completes the comprehensive setup guide for FRR with SNMP and AgentX support using the official FRRouting Docker image. The key points are:

- **Master AgentX directive** in `/etc/snmp/snmpd.conf`
- **AgentX command** enabled in each FRR daemon configuration
- **Proper startup order**: SNMP daemon must start before FRR daemons
- **Official FRR image**: Already compiled with `--enable-snmp` option
- **Alpine Linux compatibility**: Uses correct package names and paths

The setup provides full SNMP monitoring capabilities for your FRR routing infrastructure.
