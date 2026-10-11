#Roblox

# 🖌️ UI Craft

> What makes a Roblox UI look designed instead of generated, and how a preview becomes the exact same thing in game. The [[UI Screen]] workflow is the steps; this is the taste and the technique. Worked example: `examples/ui-hud/`. Back to [[Roblox]]

## Taste rules (each one came from a rejected screen)
1. **Speak the game's language.** Palette, shapes and type come from the [[Style Bible]] and from the world's own materials. (The example HUD takes iron, brass and amber straight from the lantern model.)
2. **"Polish it" means redesign.** Show 2–3 genuinely different directions, not recolours of the current UI.
3. **Always judge over a real game frame.** A HUD that looks fine on a flat background can vanish over the actual scene (direction C in the example lost its number on top of a lantern).
4. **No AI gloss.** No glossy gradient icons, glow wallpapers, phone/app imitations, gem caps or crest plates, giant "K.O." banners, emoji in names. Default to matte surfaces, strong type, thin rules, colour as small accents.
5. **No made-up content.** Real data, or an honest empty state. Fake items and names get built into the game by accident.
6. **The game matches the approved preview 1:1.** Rebuild from the preview's measured numbers (below). Never palette-swap the old UI and call it the new design: it reads as "a low-quality version of the preview".
7. **Keep behaviour, redraw the look.** When replacing a screen, keep its data and remotes; disable the old UI instead of deleting it until the new one is approved.
8. **Menus don't freeze the player** (only typing in a text box should).
9. **Mock only with fonts you can ship.** Roblox built-ins that work: Merriweather, Oswald, Montserrat, Nunito, Josefin Sans, Kalam, Patrick Hand, Indie Flower, Permanent Marker, Amatic SC, Fondamento, Grenze Gotisch, Special Elite, Creepster, Bangers, Luckiest Guy, Fredoka One, Denk One, Michroma, Jura, Sarpanch, Titillium Web, Ubuntu, Roboto (+ Condensed), Source Sans Pro, Arimo, Inconsolata, Press Start 2P, Builder Sans. Anything else goes through Text+ as a custom atlas ([[Roblox Kit]]).

## Technique: preview → exact Roblox numbers
1. **Mock at 1920×1080** (the `UIController` canvas): one `[data-canvas]` div, absolutely positioned elements, `*{box-sizing:border-box}`, the game frame as background. Tag every piece you'll rebuild with `data-rbx="Name"`. Paste `tools/ui/measure-snippet.html` at the end.
2. **Animate it** if the real thing moves (hover, press, count-up). The preview is the spec for motion too.
3. **Measure:** `node tools/ui/measure.mjs mock.html --png shot.png` prints each element's `UDim2.fromOffset` position and size, font, size, colours, corner and stroke, and screenshots the mock. (Headless Brave/Chrome over DevTools; no installs.)
4. **Build in Fusion** inside `UIController.Mount` using those numbers verbatim. Known translations:
   - **UIStroke sits outside the frame edge**, CSS borders (border-box) sit inside → inset the frame by the stroke width on each side.
   - `letter-spacing` → Text+ `CharacterSpacing` (a multiplier; ≈ 1.3 for 4–5px at 16–24px) → tune by eye at stage 4.
   - `border-radius` → `UICorner` (50% → `UDim.new(1, 0)`); hover/press scale → `UIScale` driven by a `Spring`.
5. **Compare:** in-game screenshot next to the preview at the same size. Tune strengths (glows, tints, stroke weight) until they read the same, then click through every control.
