# Base image for Firefox application container
FROM jlesage/firefox:latest

# 1. Disable TigerVNC Blacklisting completely to prevent readiness probes from locking out localhost
RUN mkdir -p /etc/tigervnc && \
    echo "BlacklistThreshold=0" >> /etc/tigervnc/vncserver-config-defaults && \
    echo "BlacklistTimeout=0" >> /etc/tigervnc/vncserver-config-defaults

# 2. Add custom Xvnc extra parameters to enforce no blacklisting via command flags
ENV VNC_EXTRA_OPTS="-BlacklistThreshold 0 -BlacklistTimeout 0"

# 3. Expose standard container ports
# 5800: Web GUI (HTTP/noVNC) - TARGET FOR HEALTH CHECKS
# 5900: Raw VNC Port (RFB Protocol)
EXPOSE 5800 5900

# 4. Optional: Configure container healthcheck to target the HTTP web interface instead of raw VNC
HEALTHCHECK --interval=10s --timeout=5s --start-period=15s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://127.0.0.1:5800/ || exit 1
