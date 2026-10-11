# 3D tools

Helpers Claude uses in the [3D Asset workflow](../vault/Workflows/3D%20Asset.md). Copy them into the asset's stage folder (`Work/<date> <asset>/<NN Stage>/`) and edit there.

| File | What it does | Run |
|---|---|---|
| `blender_build_template.py` | Rebuilds one asset from data (boxes, palette), saves the `.blend`, prints tri count and lowest point. **Refuses to run inside any other open `.blend`.** | live: `exec(open(path).read())` through Blender MCP · headless: `Blender --background --python build_<asset>.py` |
| `blender_export_roblox.py` | Exports a collection as a Roblox-ready GLB (Y-up, 1 unit = 1 stud) + `parts.json` (centre / size / pivot of each part in Roblox coordinates, for rigging) | `Blender <asset>.blend --background --python blender_export_roblox.py -- <Collection> [out_dir]` |
| `substance_job.py` | One-shot Substance 3D Painter job: new project → bake → base + grime + edge-wear layers → Roblox PBR PNGs → `.spp`, then deletes itself | write `substance_job.json` + copy both into Painter's `python/startup/`, open Painter, watch `<Out>/job_log.txt` (instructions at the top of the file) |

Then `upload_asset` (Studio bridge) → `insert_asset`. One MeshPart takes one SurfaceAppearance, so give a mesh one material / texture set before Substance if it'll be one MeshPart.

All three were run for real on a test crate (Blender 5.2, Substance Painter 12) before shipping.

Blender on Mac (Steam install): `~/Library/Application Support/Steam/steamapps/common/Blender/Blender.app/Contents/MacOS/Blender`. Normal install: `/Applications/Blender.app/Contents/MacOS/Blender`.
