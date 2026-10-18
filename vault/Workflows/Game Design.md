#Workflows

# 🎲 Game Design

> Turning an idea into a decided, build-ready spec. Shape: **Pipeline**. Back to [[Workflows]]

## Inputs
| Load | From | Scope |
|---|---|---|
| Standing design rules | the project's Design note | full |
| What's already decided | project notes + Plans | matching sections |
| Systems it touches | the project's code map | matching rows |

## Stages (outputs in `Work/<date> <topic>/<NN Stage>/`)
1. **01 Problem:** what the player experiences now, what should change and why. Check it isn't already decided or built.
2. **02 Options:** 2–4 genuinely different options with honest trade-offs and **Claude's recommendation**. Show them visually on a page when the idea is visual.
   - The options page can save the picks itself (an Artifact with a database: one card per question plus a note box). A note beats a button ("A+B" means mix them); a card left blank with a note means the note is the answer.
   - **Checkpoint:** pick, mix or reject. Record why anything was rejected.
3. **03 Decision:** log it with the date, plus what was rejected and why, in the project's notes. Log from the page's saved picks, not a chat summary.
4. **04 Spec:** build-ready: goal, rules, numbers, feel, edge cases, what's out of scope. It says **what**, not how. It hands off to [[Roblox Scripting]] / [[UI Screen]], or to [[Big Project]] when it's several jobs.

## Audit
- [ ] Fits the game's multiplayer mode; nothing reads as single-player by accident. For a new map, ask first: **one shared world, or one per player?**
- [ ] Built on systems and data that already exist where possible, and says which. Options that hang on a live system (hotbar, classes, shop) first ask whether that system is about to be redone.
- [ ] Every number is either computed from live game data or labelled a tuning guess. Economy numbers come from one script that also writes the page tables and the build data, so examples can't drift from the rule.
- [ ] Every price names a currency **and where that currency exists** (saved vs per-round).
- [ ] Maps and spaces are proposed big, in baseplates (2048 × 2048), with the time to run across at walking speed and what fills it.
- [ ] Anything placed in the world fits the spaces it must move through, measured. A creature's size comes from where it has to go.
- [ ] Hubs and lobbies are judged on looks and scale first: offer a real town of enterable buildings, not a small camp.
- [ ] A one-word tone change ("scarier") gets its meaning confirmed before rewriting everything.
- [ ] Status of related work is read from the project Log, not old briefs.
- [ ] Counters that need a class or item have a fallback for teams without it.
- [ ] A parked design brought back is checked against what was built since.
- [ ] Loop reviews tag every step built / placeholder / missing, from the live code.
- [ ] No IP copies (names, signature abilities).
- [ ] Plans are ordered build lists, never Day 1 / Day 2. Every referenced page or asset is a clickable link.
- [ ] A UI chat stays on the screen: economy rules go to a design chat even if a UI brief brings them up.
