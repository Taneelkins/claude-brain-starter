#Workflows

# ✨ VFX & Sound

> Effects and sounds from brief to seen and heard in game. Shape: **Pipeline**. Back to [[Workflows]]

## Inputs
| Load | From | Scope |
|---|---|---|
| The look and feel | [[Style Bible]] | this game's section |
| Existing effects to reuse or match | the game's FX modules / project notes | the matching ones |
| Past sound decisions | project Gotchas / notes | sound entries |
| Studio rules | [[Studio Safety]] | from stage 03 |

## Stages (outputs in `Work/<date> <effect>/<NN Stage>/`)
1. **01 Brief:** what it's for, the feel in words, references, similar effects already in the game. Group by the game's own data (element, class, kit), not by names or colours.
2. **02 Variants:** 2–3 versions. VFX as a playable preview page; sound as a listening page (an Artifact with players). Measure sound references (pitch, brightness) rather than guessing.
   - **Checkpoint:** pick one, or give direction.
3. **03 Build:**
   - VFX: an FX module in the game's style, started and stopped by the client.
   - Sound: final render, uploaded to the place's owner, ids saved to the game's config. **Upload only what was picked after listening**, never every variant first.
4. **04 In game:** wire a real trigger and **see or hear it in a playtest**. Not done until it's been seen or heard.

## Sources
- **Synthesis** suits tonal and mechanical sounds (horns, impacts, UI).
- **CC0 recordings** suit animal voices and real-world foley (Freesound with the CC0 filter, BigSoundBank). Offer one as a variant from the start. Search with 1–2 words (more words narrow to zero). Record the source and licence per clip. Keep recordings cheap: trim, fade, match loudness, fix loops.
- Downloading anything needs the person's OK in that chat.

## Audit
- [ ] Textures and sounds are owned by, or shared with, this game's owner (check "not authorized" errors).
- [ ] **Fresh uploads load late:** right after approval most clips report `IsLoaded=false` for a while. Re-check before calling it broken.
- [ ] The game's sound player is checked against each clip's length (a player that destroys sounds after 3 s cuts long ones).
- [ ] FX and sounds are cleaned up when they end (Janitor), so nothing lingers after respawn.
- [ ] Particles: one emitter caps at 400/s (stack emitters); the on-screen budget is named; checked in a real-window capture, at night too if the game has night.
- [ ] Names don't clash with existing systems.
- [ ] Seen or heard in game, not just in the preview; [[Studio Safety]] passed.
