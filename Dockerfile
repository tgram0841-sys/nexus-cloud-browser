FROM jlesage/firefox:latest

# Match the port Render expects
ENV WEB_PORT=10000
ENV VNC_PORT=5900

# Apply the TigerVNC anti-blacklisting configuration directly
# (Notice we have completely removed the USER directive to bypass Render's builder bug)
RUN mkdir -p /etc/tigervnc && \
    echo "BlacklistThreshold=0" >> /etc/tigervnc/vncserver-config-defaults && \
    echo "BlacklistTimeout=0" >> /etc/tigervnc/vncserver-config-defaults && \
    find /etc/services.d -type f -name "run" -exec sed -i 's/Xvnc/Xvnc -BlacklistThreshold 0 -BlacklistTimeout 0/g' {} + || true

# Expose the web port for cloud traffic routing
EXPOSE 10000

# Start the built-in init system
ENTRYPOINT ["/init"]
