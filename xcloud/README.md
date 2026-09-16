# ChromeCord Cloud Gaming

The published `xcloud/` site is a static Chromebook launcher. It can open the official Xbox Cloud Gaming site directly and can optionally display the ChromeCord noVNC browser portal.

## Direct browser launch

Use **Open Xbox Cloud Gaming**. This opens `https://www.xbox.com/play` in a new Chrome tab. Sign in there; this project never receives Microsoft credentials.

## Remote browser/proxy mode

A GitHub Pages site cannot run Docker, Chrome, Xvfb, noVNC, or a proxy. Those services must run on a separate HTTPS host (a VPS, Codespace, or your own server). The container now starts Chrome at Xbox Cloud Gaming by default.

1. Deploy the repository's container on a host that supports Docker.
2. Expose noVNC port `8080` through HTTPS, for example `https://gaming.example.com/`.
3. Set `window.CHROMECORD_PORTAL_URL` in `index.html` to that HTTPS base URL.
4. Republish GitHub Pages.

The launcher will then show an **Open ChromeCord Browser** button and embed `/vnc.html` from that host. Keep the noVNC password enabled and protect the host with authentication/TLS. Do not expose port 5900 publicly.

If the remote host sends restrictive `frame-ancestors` headers, the iframe may be blocked; use the button to open the portal in a new tab instead.
