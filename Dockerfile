FROM jlesage/firefox:latest

# Use the numeric system ID for root to bypass cloud builder name-resolution errors
USER 0

# Match the port your cloud environment expects
ENV WEB_PORT=10000
ENV VNC_PORT=5900

# Disable TigerVNC blacklisting so health-check pings don't crash the browser display
RUN mkdir -p /etc/tigervnc && \
    echo "BlacklistThreshold=0" >> /etc/tigervnc/vncserver-config-defaults && \
    echo "BlacklistTimeout=0" >> /etc/tigervnc/vncserver-config-defaults && \
    find /etc/services.d -type f -name "run" -exec sed -i 's/Xvnc/Xvnc -BlacklistThreshold 0 -BlacklistTimeout 0/g' {} + || true

# Expose the web port for cloud traffic routing
EXPOSE 10000

# Start the built-in init system (which safely manages session persistence and user privileges)
ENTRYPOINT ["/init"]
