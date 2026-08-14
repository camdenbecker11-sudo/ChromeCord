#!/bin/bash
set -e

# Ensure profile dir exists
mkdir -p /data/profile

# start virtual framebuffer
Xvfb :99 -screen 0 1280x800x24 &

export DISPLAY=:99

# start a lightweight window manager
fluxbox &

# Configure VNC password: use $VNC_PASSWORD if provided, otherwise generate one and print it
VNC_PASS_FILE=/etc/x11vnc.pass
if [ -n "$VNC_PASSWORD" ]; then
  mkdir -p $(dirname "$VNC_PASS_FILE")
  x11vnc -storepasswd "$VNC_PASSWORD" "$VNC_PASS_FILE"
  echo "Using provided VNC password (from VNC_PASSWORD env)."
else
  # generate a random password and store it
  GENERATED_PASS=$(python3 -c "import secrets; print(secrets.token_urlsafe(12))")
  mkdir -p $(dirname "$VNC_PASS_FILE")
  x11vnc -storepasswd "$GENERATED_PASS" "$VNC_PASS_FILE"
  echo "Generated VNC password: $GENERATED_PASS"
fi

# start x11vnc to expose the X11 display with password protection
x11vnc -display :99 -forever -rfbauth "$VNC_PASS_FILE" -shared -bg -listen 0.0.0.0 -rfbport 5900

# start websockify/noVNC (serves VNC over WebSocket on port 8080)
if [ -d "/opt/noVNC" ]; then
  WEB_DIR=/opt/noVNC
else
  WEB_DIR=/usr/share/novnc
fi

if command -v websockify >/dev/null 2>&1; then
  websockify --web "$WEB_DIR" 8080 localhost:5900 &
else
  python3 /opt/noVNC/utils/websockify/run 8080 --web "$WEB_DIR" localhost:5900 &
fi

# start Google Chrome at Discord in kiosk mode. Use a dedicated user-data dir for persistence.
CHROME_BIN=google-chrome
$CHROME_BIN --no-sandbox --disable-dev-shm-usage --disable-gpu --no-first-run --user-data-dir=/data/profile --kiosk "https://discord.com/app" &

# wait (keep container running)
wait
