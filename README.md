# ChromeCord

ChromeCord runs a remote Chrome browser through noVNC. The browser now opens Xbox Cloud Gaming by default; set `CLOUD_URL` to change the destination.

## Local Docker

```bash
docker-compose up --build
```

Open `http://localhost:8080/vnc.html` and enter the password printed in the container logs or supplied with `VNC_PASSWORD`.

## Important deployment limitation

GitHub Pages only hosts static files. It cannot run the Docker container or act as a browser proxy. Run the container on a separate HTTPS-capable host, then configure `xcloud/index.html` with that noVNC URL.

Do not expose VNC port 5900 directly to the internet. Use HTTPS, a strong VNC password, and host authentication.
