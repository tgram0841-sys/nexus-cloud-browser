# Use a highly optimized, lightweight Firefox container
FROM jlesage/firefox:latest

# Render routes traffic to a specific port. We set the web UI to port 10000.
ENV WEB_PORT=10000
EXPOSE 10000

# Remove VNC password for instant access (You can set a password here later for security)
ENV VNC_PASSWORD=""

# Keep the browser open in the background even if you close all tabs
ENV KEEP_APP_RUNNING=1

# Optimize resolution for cloud streaming
ENV DISPLAY_WIDTH=1280
ENV DISPLAY_HEIGHT=720

# Enable Dark Mode UI for the container environment
ENV DARK_MODE=1
