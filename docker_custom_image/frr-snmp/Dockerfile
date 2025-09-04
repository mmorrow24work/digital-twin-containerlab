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
