# Worked examples

Two pieces of an example night game ("Lanternlight"), each taken through the kit's pipeline so you can see what every stage produces and what the audits catch. Open `index.html` for the illustrated walkthrough.

| Example | Workflow | What's in the folder |
|---|---|---|
| `3d-lantern/` | 3D Asset | `01 Brief.md`, renders for `02 Blockout` / `03 Detail` / `04 Materials` (incl. the rejected ones), `boxes.json`, `build_lantern.py` (rebuilds every stage), `render_frame.py` (the game-frame render), `05 In Game/rebuild_from_parts.luau` |
| `ui-hud/` | UI Screen | `01 Spec.md`, three 1920×1080 mocks in `02 Preview/`, their screenshots + measurements in `shots/`, the Fusion build in `03 Build/HudController.luau` |

Not done in these examples (no test place was open): the in-game stages (lantern rebuilt from Parts under real lighting; HUD screenshot next to its preview). Both are written up as the next step.

Re-run them:
```bash
Blender --background --python examples/3d-lantern/build_lantern.py -- materials "/tmp/lantern"
```
```bash
node tools/ui/measure.mjs "examples/ui-hud/02 Preview/A Brass Plaque.html" --png /tmp/a.png
```
