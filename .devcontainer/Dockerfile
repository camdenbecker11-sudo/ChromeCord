# Lightweight container to run Xvfb + x11vnc + noVNC + Chromium

FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    wget ca-certificates git python3 python3-pip xvfb x11vnc fluxbox \
    chromium-browser fonts-liberation dbus-x11 --no-install-recommends && \
    pip3 install websockify && \
    git clone https://github.com/novnc/noVNC.git /opt/noVNC && \
    git clone https://github.com/novnc/websockify /opt/noVNC/utils/websockify-src && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy start script
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

EXPOSE 8080 5900

CMD ["/usr/local/bin/start.sh"]
