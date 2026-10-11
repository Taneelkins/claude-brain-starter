#!/usr/bin/env node
// Measure a 1920x1080 HTML UI mock so it can be rebuilt 1:1 in Roblox, and screenshot it.
//   node measure.mjs <mock.html | http://...> [--png out.png] [--json]
// Prints Position/Size as UDim2.fromOffset in the 1920x1080 design canvas (the framework's
// UIController canvas) plus font, size and colours for every data-rbx element.
// Drives Brave/Chrome/Chromium/Edge over the DevTools protocol (Node 22+, nothing to install).
import { spawn } from "node:child_process";
import { existsSync, mkdtempSync, writeFileSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import { join, resolve } from "node:path";
import { pathToFileURL } from "node:url";

const Browsers = [
  "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser",
  "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
  "/Applications/Chromium.app/Contents/MacOS/Chromium",
  "/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge",
  "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe",
  "/usr/bin/google-chrome", "/usr/bin/chromium",
];
const Args = process.argv.slice(2);
if (!Args[0]) { console.log("usage: node measure.mjs <mock.html> [--png out.png] [--json]"); process.exit(1); }
const Target = /^https?:/.test(Args[0]) ? Args[0] : pathToFileURL(resolve(Args[0])).href;
const Png = Args.includes("--png") ? resolve(Args[Args.indexOf("--png") + 1]) : null;
const Exe = Browsers.find(existsSync);
if (!Exe) { console.error("No Chromium-based browser found (Brave, Chrome, Chromium or Edge)."); process.exit(1); }

const Profile = mkdtempSync(join(tmpdir(), "measure-"));
const Port = 9300 + Math.floor(Math.random() * 500);
const Proc = spawn(Exe, ["--headless=new", `--remote-debugging-port=${Port}`, `--user-data-dir=${Profile}`,
  "--window-size=1920,1080", "--hide-scrollbars", "--allow-file-access-from-files", "about:blank"], { stdio: "ignore" });
const Done = (code) => { Proc.kill(); setTimeout(() => { try { rmSync(Profile, { recursive: true, force: true }); } catch {} process.exit(code); }, 300); };
setTimeout(() => { console.error("timed out"); Done(1); }, 60000);

const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
let Info;
for (let i = 0; i < 100 && !Info; i++) {
  try { Info = await (await fetch(`http://127.0.0.1:${Port}/json/list`)).json(); } catch { await sleep(150); }
}
const PageInfo = Info.find((t) => t.type === "page");
const Ws = new WebSocket(PageInfo.webSocketDebuggerUrl);
await new Promise((r) => Ws.addEventListener("open", r));
let Id = 0; const Waiting = new Map();
Ws.addEventListener("message", (e) => { const m = JSON.parse(e.data); if (m.id && Waiting.has(m.id)) { Waiting.get(m.id)(m); Waiting.delete(m.id); } });
const send = (method, params = {}) => new Promise((r) => { const id = ++Id; Waiting.set(id, r); Ws.send(JSON.stringify({ id, method, params })); });

await send("Emulation.setDeviceMetricsOverride", { width: 1920, height: 1080, deviceScaleFactor: 1, mobile: false });
await send("Page.enable");
await send("Page.navigate", { url: Target });
let Rects = null;
for (let i = 0; i < 60 && !Rects; i++) {
  await sleep(250);
  const r = await send("Runtime.evaluate", { expression: "document.getElementById('rbx-rects')?.textContent || ''", returnByValue: true });
  if (r.result?.result?.value) Rects = JSON.parse(r.result.result.value);
}
if (Png) {
  const shot = await send("Page.captureScreenshot", { format: "png", clip: { x: 0, y: 0, width: 1920, height: 1080, scale: 1 } });
  writeFileSync(Png, Buffer.from(shot.result.data, "base64"));
  console.log("screenshot ->", Png);
}
if (!Rects) { console.error("No measurements found: add tools/ui/measure-snippet.html to the end of the page."); Done(1); }
else {
  const rgb = (css) => {
    const n = (css || "").match(/[\d.]+/g); if (!n || n.length < 3) return css;
    const [r, g, b] = n.slice(0, 3).map((v) => Math.round(+v)); const a = n[3] !== undefined ? +n[3] : 1;
    return `Color3.fromRGB(${r}, ${g}, ${b})` + (a < 1 ? ` (BackgroundTransparency ${(1 - a).toFixed(2)})` : "");
  };
  for (const e of Rects) {
    let line = `${e.name.padEnd(14)} Position = UDim2.fromOffset(${e.x}, ${e.y})   Size = UDim2.fromOffset(${e.w}, ${e.h})`;
    if (e.text) line += `\n${"".padEnd(14)} "${e.text}"  ${e.font} ${e.weight}  ${e.size}px  spacing ${e.spacing}  ${rgb(e.color)}`;
    if (!/rgba\(0, 0, 0, 0\)|transparent/.test(e.background)) line += `\n${"".padEnd(14)} fill ${rgb(e.background)}  corner ${e.radius}`;
    if (e.stroke) line += `\n${"".padEnd(14)} stroke ${e.stroke}`;
    console.log(line);
  }
  if (Args.includes("--json")) console.log(JSON.stringify(Rects, null, 1));
  Done(0);
}
