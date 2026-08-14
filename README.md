# ChromeCord - Discord in Chrome via noVNC

This branch adds a Codespaces devcontainer and supporting files to run a full Google Chrome browser inside a container and expose it via noVNC (VNC-over-WebSocket). The goal is to open Discord (https://discord.com/app) inside Chrome and view/control it from a Chrome tab using noVNC.

Files added/updated:
- .devcontainer/Dockerfile - container image with Xvfb, x11vnc, noVNC, websockify, and Google Chrome
- .devcontainer/devcontainer.json - Codespaces/devcontainer configuration
- start.sh - entrypoint that starts Xvfb, fluxbox, x11vnc (with password), websockify, and Chrome
- docker-compose.yml - optional local testing

Quick start (Codespaces)
1. Open the repo in Codespaces on the feature/discord-portal-novnc branch.
2. Codespaces will build the devcontainer. Once running, forward port 8080 (the devcontainer config marks 8080 to open in preview).
3. Open the forwarded port in your browser; the noVNC page should appear and prompt to connect to the VNC session.

VNC password
- The container will use the VNC password provided in the VNC_PASSWORD environment variable if set.
- If VNC_PASSWORD is not set, the container will generate a random password on startup and print it in the container logs. Check the Codespaces/devcontainer logs or docker container logs to find the generated password.

Quick start (local Docker)
1. Build and run locally:
   docker-compose up --build
2. In your browser, open: http://localhost:8080/vnc.html
   - Use the VNC password printed by the container (or set VNC_PASSWORD in docker-compose or via environment) to connect.

Notes / troubleshooting
- The Dockerfile installs Google Chrome via the official .deb to avoid chromium packaging inconsistencies.
- Resource sizing: give the Codespace or Docker container at least ~2–4GB RAM and increase shm (I set shm_size: "1gb" in docker-compose; increase if needed).
- Security: noVNC is protected using the VNC password (x11vnc -rfbauth). If you need stronger authentication or TLS, add a reverse-proxy in front of the noVNC port.

Next steps I can take for you
- Open a PR (already created: https://github.com/camdenbecker11-sudo/ChromeCord/pull/1) and, if you want, merge it.
- Add GitHub Actions to build and publish a container image.
- Add a small wrapper page that embeds the noVNC client in a simple authenticated web UI.

If you want me to merge the PR now, say "merge it" and I'll proceed.