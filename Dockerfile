FROM jlesage/firefox:latest

# Use the exact variable names required by the jlesage base image
ENV WEB_LISTENING_PORT=10000
ENV VNC_LISTENING_PORT=5900

# Apply the TigerVNC anti-blacklisting configuration
RUN mkdir -p /etc/tigervnc && \
    echo "BlacklistThreshold=0" >> /etc/tigervnc/vncserver-config-defaults && \
    echo "BlacklistTimeout=0" >> /etc/tigervnc/vncserver-config-defaults && \
    find /etc/services.d -type f -name "run" -exec sed -i 's/Xvnc/Xvnc -BlacklistThreshold 0 -BlacklistTimeout 0/g' {} + || true

# Expose the web port for Render's routing
EXPOSE 10000

# Start the built-in init system
ENTRYPOINT ["/init"]
