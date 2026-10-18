#Workflows

# 🧊 3D Asset

> A model from brief to in-game, one approved stage at a time. Shape: **Pipeline**. Back to [[Workflows]]

## Inputs
| Load | From | Scope |
|---|---|---|
| The look + build method | [[Style Bible]] | this game's section |
| The ask | [[Asset Brief Template]] filled in + reference images | full |
| Tools, routes, Roblox facts | [[3D Pipeline]] | full |
| Studio rules | [[Studio Safety]] | at stage 05 |

## Stages (outputs in the game's `Work/<date> <asset>/<NN Stage>/`)
1. **01 Brief:** the filled template, refs (each with a job), and the route from [[3D Pipeline]]. **Checkpoint:** brief OK'd.
2. **02 Blockout:** grey shapes at real stud size; front / side / ¾ renders next to an existing game asset for scale. **Checkpoint:** silhouette.
3. **03 Detail:** secondary shapes, bevels or the style's slabs; renders. **Checkpoint.**
4. **04 Materials:** palette from the Style Bible (flat + baked AO, or Substance PBR); renders. **Checkpoint.**
5. **05 Import:** export GLB (`tools/3d/blender_export_roblox.py`), `upload_asset` → `insert_asset`, pivot at the base, one SurfaceAppearance per MeshPart, in-game screenshot in the game's lighting.

Show every checkpoint on a page (an Artifact) with the renders side by side with the refs.

**Method:** iterate live through Blender MCP; before each checkpoint save `build_<asset>.py` (rebuilds this stage from scratch, from `tools/3d/blender_build_template.py`) plus the `.blend`.

## Audit (before every checkpoint)
- [ ] Compared side by side with the refs, not from memory.
- [ ] Route matches the style: nothing code-built for a realistic character or creature.
- [ ] Shown next to existing game assets; tri budget reported.
- [ ] Wearables: R15 scale, closed fists, no finger pieces.
- [ ] Parts named, transforms applied, origin at the base.
- [ ] Build script saved and it refuses to run in any other open `.blend`.
- [ ] Nothing floats; no two faces share a plane (z-fighting).
- [ ] Colours checked in the game's lighting before locking.
- [ ] Anything players walk into: narrowest gap ≥ 2 studs at torso height, walk-tested by a client-driven walk (never server `MoveTo`).
- [ ] Each reference has a job (silhouette / mood / method / colour), and a ref from another game names what is NOT copied. A new ref means re-checking the brief before the next stage.
- [ ] Lineups: one row, long lens, labels; never a prop far behind (perspective shrinks it). The signature creature is measured against the tallest existing one.
- [ ] Colours locked only after a **real-window capture in the game's lighting, in direct sun** (built-in `screen_capture` skips colour grading; shade lies). Pale colours side by side merge at 30–50 studs: check them as a pair.
- [ ] Checked at play distance (~30 studs) as well as close up. Distance tests put each distance in its own lane, not one sight line.
- [ ] Baked atlas: each colour tile averages ≥ ~85% of its palette colour (heavy AO crushes it), and tiles are grouped by tone so mipmaps don't turn them grey.
- [ ] After every change, re-check the signature features (eyes, teeth, horns): new pieces can bury old ones.
- [ ] The caption names which way it faces; every pose render has feet on the ground and the head clear.
- [ ] Feedback "stubby / generic" = change the shape language (proportion, asymmetry, silhouette), not the scale. "Too small / not scary" on a signature feature = make it the biggest read at play distance.
- [ ] No accidental faces (two dark straps on a pale bag read as eyes); accents contrast in value with what they sit on.
- [ ] Glow: emission = colour map × tint, so the glowing areas of the colour map must be saturated; confirm every texture has finished loading before capturing (unloaded = white).
- [ ] New image ids: wait for `Approved` before Studio loads them. An id loaded while still reviewing stays white all session.
- [ ] Moving parts that fold away: measure the space they stow into at 01; it caps their size.
- [ ] Studio models are stored as a Model with a PrimaryPart, never a bare MeshPart.

**If it moves:** at 05, write `06 Handoff/animation-prompt.md`, a ready-to-paste first message for an [[Animation]] chat (rig path, segment names, behaviour and timings, clearance notes).
**Variants:** two good looks that share the rig and clearances become variants from one build script. A look that moves a clearance is a separate asset.
