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
