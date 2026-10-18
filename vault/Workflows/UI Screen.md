#Workflows

# 🖥️ UI Screen

> A screen from idea to in-game, matching an approved preview. Shape: **Pipeline**. Back to [[Workflows]]

## Inputs
| Load | From | Scope |
|---|---|---|
| The game's UI language | [[Style Bible]] (UI line) + `UI/Theme.luau` | full |
| Taste + technique | [[UI Craft]] | full |
| How screens are built | [[Roblox Framework]] (UI rules) | full |
| Studio rules | [[Studio Safety]] | from stage 03 |

## Stages (outputs in `Work/<date> <screen>/<NN Stage>/`)
1. **01 Spec:** what the screen does, which real data it shows, its states (empty, loading, locked, error), which controller owns it.
   - A lobby, hub or main menu: ask first whether it's a 2D menu or a **walkable 3D space**. A spec that says "menu" doesn't settle it.
2. **02 Preview:** 2–3 real directions as animated 1920×1080 mocks drawn over a real game frame ([[UI Craft]] technique), screenshots via `tools/ui/measure.mjs --png`, shown side by side on one page. **Checkpoint:** pick one.
3. **03 Build:** `UIController.Mount` + Fusion, every number from `measure.mjs` output, data from `DataController.Observe`.
4. **04 Compare:** in-game screenshot next to the preview; tune until they read the same; click every control in a playtest.

## Audit: before showing a preview
- [ ] Real data or honest empty states; no made-up content (fake items, names).
- [ ] "Polish the UI" means **2–3 real redesigns**, not a recolour of the current screen.
- [ ] "Like <game>" is split before drawing into **art style vs layout vs colours**, and you say which part comes from which reference. After a rejection, ask the shape language (round/chunky vs angular vs ink) before redrawing.
- [ ] If the person has a picture in their head ("menus as buildings"), one direction takes it literally.
- [ ] Only effects Roblox can build: no skew (slants are 9-slice images), no outlined custom-font text, no gradient masks on sliced images. Icons sit inside the shape they mark.
- [ ] Inventory items show the model (render or ViewportFrame), not a text card; player portraits are viewports of the real character.
- [ ] No generic "AI app" gloss (glossy gradients, emoji, glow wallpaper) unless the Style Bible asks for it.
- [ ] Everything animates the way the preview did (hover, press, open/close).
- [ ] Custom-font text uses the `Text` component.

## Audit: before calling it done
- [ ] Compared against the **approved preview**, never an old capture; every screen captured live. Check slanted corners, label centring and the widest values ("100%", long names).
- [ ] Screen sizes: 16:9, 4:3 and ultra-wide; say what phones do. Nothing overlaps the Roblox top bar (top-left ~270×60) or another panel.
- [ ] Symbols render: ► ▼ work in Roblox fonts, ▸ ▾ come out blank.
- [ ] Gradient fills sit on a white background (UIGradient multiplies); round strokes use `Round` joins; ViewportFrames judged ~2 s after they appear (first frames are blank).
- [ ] New 9-slice shapes slice only the vertical middle (corners = full halves); thin slice rows tear outlines.
- [ ] Images load in THIS experience: if the place's owner isn't the uploader, grant share access, then check by screenshot.
- [ ] Porting a built screen to another library: capture old and new in the same window and diff them; reproduce the old look on purpose.
- [ ] Menus don't freeze movement; only typing in a text box does.
- [ ] Clicked through in a playtest; client log clean.
