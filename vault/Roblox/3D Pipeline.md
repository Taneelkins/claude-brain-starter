#Roblox

# 🧊 3D Pipeline

> How models get made and into the game with Claude. The step-by-step contract is the [[3D Asset]] workflow; this note is the tools and the hard-won rules. Worked example: `examples/3d-lantern/`. Back to [[Roblox]]

## Tools
| Tool | What Claude does with it | Setup |
|---|---|---|
| **Blender + MCP** | builds and edits the open scene live, looks at the viewport, renders | `install.sh` registers the `blender` MCP server and installs the add-on. In Blender, the add-on's server starts with Blender (if not: N panel → MCP for Blender → Start) |
| **Blender headless** | runs saved build/export scripts with no window | `Blender --background --python script.py` |
| **Studio bridge** | `export_to_blender` (Studio → Blender 1:1), `upload_asset`, `insert_asset` | [[Studio Bridge]] |
| **AI 3D generation** (Claude Design 3D, Meshy) | you generate from Claude's brief + refs; Claude cleans up, textures, rigs, imports | your accounts |
| **Substance 3D Painter** (optional) | PBR texturing driven by a one-shot startup script | `tools/3d/substance_job.py` |

## Pick the route by the game's art style
| Style | Route |
|---|---|
| Blocky / flat low-poly | Claude builds it in Blender from box data (`tools/3d/blender_build_template.py`), flat palette + baked AO |
| Sculpted / realistic characters and creatures | Brief → **AI generation** (Claude Design 3D / Meshy) → Claude retopo, UVs, Substance, rig, import. **Never code-built**: scripted meshes look like primitives |
| Hard-surface props, weapons, buildings | Blender driven by Claude, renders checked after every step |
| Existing / store / AI meshes | Blender clean-up: decimate, UV, pivot, scale, export |

## Roblox facts
- **1 stud = 1 Blender unit.** Export **GLB, Y-up, transforms applied** (`tools/3d/blender_export_roblox.py`). Blender (x, y, z) = Roblox (x, −z, y).
- **R15 character:** arm ≈ 1×1 stud cross-section, hand ≈ 0.3 stud. Hands are **closed fists** (no finger rig); no separate finger pieces on gear.
- **One MeshPart = one SurfaceAppearance**, so body, eyes, teeth share one UV atlas. Glow = emissive mask in the atlas (EmissiveStrength/Tint).
- Textures upload as **PNG** (Open Cloud rejects GLBs with JPEG textures). New uploads show untextured for ~1 min (moderation).
- Judge colours **in the game's lighting**, not Blender's. Each place's lighting shifts tones. In Blender renders use the **Standard** view transform: AgX/Filmic wash bright emissives out to cream.

## Rules that came from mistakes
- **Every stage has a build script** (`build_<asset>.py`) next to its `.blend`: it rebuilds the model from scratch. Variants and skins come from the script, never from hand-edited copies.
- **Scripts that clear the scene refuse to run in any other open file** (check `bpy.data.filepath`). One wiped a different open scene once.
- First render shows the asset **next to existing game assets**, not alone. Report the tri budget.
- Compare against the reference images side by side every checkpoint, never from memory.
- **AI meshes have shattered UVs and bad normals:** bake onto fresh UVs; keep a Blender-baked normal map; don't touch normals after baking.
- Substance opens projects in legacy colour mode: colour fills fail, so use small solid-colour PNGs as fill sources (the job script does this).
