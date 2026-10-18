#Workflows

# 🏃 Animation

> Clips from reference to playing on the real rig in game. Shape: **Pipeline**. Back to [[Workflows]]

## Inputs
| Load | From | Scope |
|---|---|---|
| The rig | the asset's Work folder (build script, segment names) + the rig in Studio | joint names, pivots |
| How the game plays clips | the game's animation/AI code (playback speed, hit timing, priorities) | the clips involved |
| Rig traps | project Gotchas | matching lines |
| Studio rules | [[Studio Safety]] | from stage 02 |

## Route
- **Default: Studio.** Clips are written as keyframe data → KeyframeSequence → uploaded, and timing gets judged in game.
- **Blender only when a person hand-animates.** Test the FBX → Roblox import on that rig first.
- Claude is strong at **cycles** (idle, walk, run, a wheel or lid). **Hero moves** (a lunge, a death) need a reference clip to match and a human eye at every checkpoint.

## Stages (outputs in `Work/<date> <rig> Animations/<NN Stage>/`)
1. **01 Clip list:** every clip with a reference, length, loop or one-shot, key moments (foot contacts, impact frame) and priority. First **read how the game plays clips** and **measure the rig from its model** (height, reach, leg length), never from the brief's guesses. Derive stride from leg length; flag speeds the body can't walk. **Checkpoint:** list OK'd.
2. **02 Key poses:** block the extremes on the **real rig** and check them yourself. Don't ask anyone to review still poses unless there's a named reason (a grip question that can't be read in motion).
3. **03 Playback:** full clips at real speed, looping, **shown playing** on the report page beside the reference. **Checkpoint:** timing and weight. This is the first thing the person sees.
4. **04 Polish + upload:** follow-through on tails, ears, cloth; impact frames as KeyframeMarkers; upload to the place's owner (group game → the group); save the ids next to the clip source. Wiring clips into AI or controls is a [[Roblox Scripting]] job.

## Audit (before every checkpoint)
- [ ] Shown on the real rig in game, not only a preview. Joint names unchanged (clips find joints by name).
- [ ] **Weight:** anticipation before big moves, overshoot and settle after. Nothing starts or stops dead.
- [ ] **Offset timing:** tail, head and ears trail the body by a few frames. Lockstep reads as stiff.
- [ ] **No dead secondary motion:** tails, manes, ears visibly move in every loop. If clearance forces freezing one, raise it; never trade motion away silently.
- [ ] Loops are seamless: last pose = first pose, no pop on wrap.
- [ ] Feet don't slide: stride × rate = movement speed, measured on the real rig. Planted feet come from IK, not hand-tuned angles. A pure sine leg swing skates; use a mostly-triangle wave.
- [ ] **No pops:** per-joint frame-to-frame angle jumps checked at high frame rate on the baked keys (a 171° wrist flip hid in a 30 fps sample). Two-bone legs never reach full extension.
- [ ] **Nothing passes through anything:** a frame-by-frame overlap check using the real box pieces (not whole-limb bounds, which false-flag), including parent/child pairs: no gap opening at a joint, no piece pushing into its neighbour. Look at close-ups from front, back and side.
- [ ] **Speed is the swing:** an even-speed attack reads as "a glide". Load, hang, fastest at contact, hard stop, slow heavy recovery. Peak speed sits on the hit marker.
- [ ] **The body drives the swing:** hips and torso turn and the weight shifts; arms-only clips fail. Combos start where the last swing ended, never twice from the same side.
- [ ] **Reactions land:** a stun or hit opens with an impact frame (snap in ≤ 0.07 s) before any loop.
- [ ] **Stances, not poses:** idles are asymmetric with a strong silhouette from front, ¾ and behind.
- [ ] Third-person clips read from a teammate's view (front and side): a block must show the blade.
- [ ] Priority layered and checked in play (list the playing tracks): an Action clip overrides Movement and two same-priority arm clips never blend.
- [ ] A one-shot that hands over to a gait does it with no blend, or the held last frame averages in.
- [ ] Every rig variant that shares the skeleton is captured mid-clip and looked at, not only measured.
- [ ] Held gear stays out of the ground and the body; paired clips (player + creature) are measured together at their pairing spot.
- [ ] Impact/event frames are KeyframeMarkers the code reads, and they line up with the hit in game.
- [ ] The clip source (keyframe data) is saved: it's the recipe. Upload ids saved next to it.
- [ ] [[Studio Safety]] passed. Preview rigs and test scripts deleted.
