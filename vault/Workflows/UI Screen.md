#Workflows

# 🖥️ UI Screen

> A screen from idea to in-game, matching an approved preview. Shape: **Pipeline**. Back to [[Workflows]]

## Inputs
| Load | From | Scope |
|---|---|---|
| The game's UI language | [[Style Bible]] (UI line) + `UI/Theme.luau` | full |
| How screens are built | [[Roblox Framework]] (UI rules) | full |
| Studio rules | [[Studio Safety]] | from stage 03 |

## Stages (outputs in `Work/<date> <screen>/<NN Stage>/`)
1. **01 Spec:** what the screen does, which real data it shows, its states (empty, loading, locked, error), which controller owns it.
2. **02 Preview:** an animated HTML mock at 1920×1080, published as an Artifact. Show 2–3 real directions, not recolours. **Checkpoint:** pick one.
3. **03 Build:** `UIController.Mount` + Fusion components, numbers taken 1:1 from the preview, colours/fonts from `Theme`, data from `DataController.Observe`.
4. **04 Compare:** in-game screenshot next to the preview; tune until they read the same; click every control in a playtest.

## Audit
- [ ] Real data or honest empty states; no made-up content.
- [ ] No generic "AI app" gloss (glossy gradients, emoji, glow wallpaper) unless the Style Bible asks for it.
- [ ] Everything animates the way the preview did (hover, press, open/close).
- [ ] Custom-font text uses the `Text` component.
- [ ] Clicked through in a playtest; client log clean.
