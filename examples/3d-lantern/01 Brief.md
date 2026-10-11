# 01 Brief: Lantern

```
Asset:        Standing floor lantern (the game's main light source and collectible marker)
Game:         Lanternlight (example) → blocky, cosy, night; warm light against cold blue
Refs:         none attached in this example (a real brief attaches 2–3 images and says
              what to take from each: silhouette / colour / detail)
Size:         2 × ~4 × 2 studs (stands on the ground, about chest height on an R15)
Tri budget:   under 500 (it's placed dozens of times along paths)
Camera:       close to mid: players walk right past it
Use:          static prop, lit at night (PointLight inside)
Must-have:    glowing amber panes with a cross bar; a brass carry handle
Avoid:        smooth/realistic shapes (the style is blocky); floating parts; a blob of light with no frame
```

**Route** ([3D Pipeline](../../vault/Roblox/3D%20Pipeline.md)): blocky style → Claude builds it in Blender from box data (`build_lantern.py`), flat palette, Neon/emissive panes. No AI generation needed.
