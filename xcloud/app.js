const CLOUD_GAMING_URL = "https://www.xbox.com/play";
const portalUrl = (window.CHROMECORD_PORTAL_URL || "").trim();
const launchButton = document.querySelector("#launchButton");
const portalButton = document.querySelector("#portalButton");
const portalFrame = document.querySelector("#portalFrame");
const portalNotice = document.querySelector("#portalNotice");
const fullscreenButton = document.querySelector("#fullscreenButton");
const installButton = document.querySelector("#installButton");
const controllerStatus = document.querySelector("#controllerStatus");
const connectionStatus = document.querySelector("#connectionStatus");

let deferredInstallPrompt = null;

launchButton.addEventListener("click", () => window.open(CLOUD_GAMING_URL, "_blank", "noopener,noreferrer"));
portalButton.addEventListener("click", () => {
  if (!portalUrl) return;
  portalFrame.src = portalUrl.endsWith("/") ? `${portalUrl}vnc.html` : `${portalUrl}/vnc.html`;
  portalFrame.classList.remove("hidden");
  portalNotice.classList.add("hidden");
  portalFrame.scrollIntoView({ behavior: "smooth" });
});
fullscreenButton.addEventListener("click", async () => {
  try { document.fullscreenElement ? await document.exitFullscreen() : await document.documentElement.requestFullscreen(); } catch {}
});
window.addEventListener("beforeinstallprompt", event => { event.preventDefault(); deferredInstallPrompt = event; installButton.classList.remove("hidden"); });
installButton.addEventListener("click", async () => {
  if (!deferredInstallPrompt) return;
  deferredInstallPrompt.prompt();
  await deferredInstallPrompt.userChoice;
  deferredInstallPrompt = null;
  installButton.classList.add("hidden");
});
function updateConnectionStatus() { connectionStatus.textContent = navigator.onLine ? "Online" : "Offline — cloud gaming is unavailable."; }
function updateControllerStatus() {
  if (!navigator.getGamepads) { controllerStatus.textContent = "Gamepad API is unavailable."; return; }
  const connected = [...navigator.getGamepads()].filter(Boolean).filter(gamepad => gamepad.connected);
  controllerStatus.textContent = connected.length ? `${connected.length} controller connected` : "No controller detected";
}
window.addEventListener("gamepadconnected", updateControllerStatus);
window.addEventListener("gamepaddisconnected", updateControllerStatus);
window.addEventListener("online", updateConnectionStatus);
window.addEventListener("offline", updateConnectionStatus);
if (!portalUrl) portalButton.classList.add("hidden");
if ("serviceWorker" in navigator) window.addEventListener("load", () => navigator.serviceWorker.register("./service-worker.js"));
updateConnectionStatus();
updateControllerStatus();
