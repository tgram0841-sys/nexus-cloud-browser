FROM jlesage/firefox:latest

# Set the Web UI port to match the environment's expected port (from your logs: 10000)
# This prevents the cloud provider from scanning/hitting the raw VNC port by mistake.
ENV WEB_PORT=10000
ENV VNC_PORT=5900

# Fix the Xvnc "127.0.0.1 Blacklisted" issue.
# This forces the VNC server to never blacklist IPs, even if health checkers ping it with HTTP traffic.
USER root
RUN mkdir -p /etc/tigervnc && \
    echo "BlacklistThreshold=0" >> /etc/tigervnc/vncserver-config-defaults && \
    echo "BlacklistTimeout=0" >> /etc/tigervnc/vncserver-config-defaults && \
    # Patch the s6-overlay startup scripts used by jlesage images to include the flags directly
    find /etc/services.d -type f -name "run" -exec sed -i 's/Xvnc/Xvnc -BlacklistThreshold 0 -BlacklistTimeout 0/g' {} + || true

# (Optional) If you have a custom startup script (e.g., start.sh), copy it here.
# COPY start.sh /start.sh
# RUN chmod +x /start.sh

# Expose the web port so the cloud platform routes HTTP traffic correctly
EXPOSE 10000

# Start the default jlesage init system
ENTRYPOINT ["/init"]
