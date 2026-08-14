# ChromeCord - Discord in Chrome via noVNC

This branch adds a Codespaces devcontainer and supporting files to run a full Chromium browser inside a container and expose it via noVNC (VNC-over-WebSocket). The goal is to open Discord (https://discord.com/app) inside Chromium and view/control it from a Chrome tab using noVNC.

Files added:
- .devcontainer/Dockerfile - container image with Xvfb, x11vnc, noVNC, websockify, and Chromium
- .devcontainer/devcontainer.json - Codespaces/devcontainer configuration
- start.sh - entrypoint that starts Xvfb, fluxbox, x11vnc, websockify, and Chromium
- docker-compose.yml - optional local testing
- README.md - usage instructions

Notes:
- For Codespaces: open the Codespace, forward port 8080 (the devcontainer is configured to open a preview automatically for 8080). The noVNC page will be served on port 8080.
- For local Docker: build with docker-compose and visit http://localhost:8080/vnc.html (or the noVNC index) to access the Chromium session.

Security: This setup does not add authentication to noVNC by default. In Codespaces the port is private to your Codespace until forwarded; if you need public access add a password or a reverse-proxy with TLS/auth.
