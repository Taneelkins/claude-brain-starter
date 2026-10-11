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
- [ ] Anything players walk into: narrowest gap ≥ 2 studs at torso height, walk-tested.
