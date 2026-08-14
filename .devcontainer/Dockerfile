# Lightweight container to run Xvfb + x11vnc + noVNC + Google Chrome

FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    wget ca-certificates git python3 python3-pip xvfb x11vnc fluxbox dbus-x11 \
    fonts-liberation libxss1 libasound2 --no-install-recommends && \
    # Install Google Chrome (fallback when chromium-browser packages aren't available)
    wget -q -O /tmp/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt-get install -y /tmp/chrome.deb && rm /tmp/chrome.deb && \
    # Install websockify (provides websockify executable) and cleanup
    pip3 install --no-cache-dir websockify && \
    # Clone noVNC (web client)
    git clone https://github.com/novnc/noVNC.git /opt/noVNC && \
    git clone https://github.com/novnc/websockify /opt/noVNC/utils/websockify-src && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create a profile dir for persistent Chrome data
RUN mkdir -p /data/profile && chown root:root /data/profile

# Copy start script
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

EXPOSE 8080 5900

CMD ["/usr/local/bin/start.sh"]
