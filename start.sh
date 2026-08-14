#!/bin/bash
set -e

# start virtual framebuffer
Xvfb :99 -screen 0 1280x800x24 &

export DISPLAY=:99

# start a lightweight window manager
fluxbox &

# start x11vnc to expose the X11 display
x11vnc -display :99 -forever -nopw -shared -bg -listen 0.0.0.0 -rfbport 5900

# start websockify/noVNC (serves VNC over WebSocket on port 8080)
# websockify installed via pip provides the websockify executable
if [ -d "/opt/noVNC" ]; then
  WEB_DIR=/opt/noVNC
else
  WEB_DIR=/usr/share/novnc
fi

# If websockify binary is available in PATH use it, otherwise try the bundled one
if command -v websockify >/dev/null 2>&1; then
  websockify --web "$WEB_DIR" 8080 localhost:5900 &
else
  python3 /opt/noVNC/utils/websockify/run 8080 --web "$WEB_DIR" localhost:5900 &
fi

# start Chromium at Discord in kiosk mode
chromium-browser --no-sandbox --disable-dev-shm-usage --disable-gpu --no-first-run --user-data-dir=/data/profile --kiosk "https://discord.com/app" &

# wait (keep container running)
wait
