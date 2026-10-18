#Workflows

# 🎮 Roblox Scripting

> Building or fixing a system in a Roblox game. Shape: **Loop**. Same as [[Feature]], plus the framework rules. Back to [[Workflows]]

## Inputs
| Load | From | Scope |
|---|---|---|
| Game wiring + code map | the game's project folder note | full |
| Layout + rules | [[Roblox Framework]] | full |
| Which module does what | [[Roblox Kit]] | when picking a library |
| Known traps | [[Roblox Gotchas]] + the game's own Gotchas | sections that match |
| Studio rules | [[Studio Safety]] | full |

## Loop
1. **Find what exists.** Search `src/` for the feature's keywords. Name the Service/Controller it belongs in, or say why it needs a new one.
2. **Plan.** List the module(s), any new packets for `Network.luau` with their exact types, any new data fields for the `DataService` template.
   - **Checkpoint** if it adds a new Service/Controller, changes saved data, or changes existing gameplay.
3. **Build** on disk (never in Studio's script editor).
4. **Verify** in a playtest (`start_stop_play`): call the service through a temporary `ZZ_` Script and print results; check client behaviour with `execute_luau` on Client plus key input (see [[Studio Bridge]]). Server and client logs both clean. Say what wasn't tested.
5. **Close:** commit. Nudge `/save`.

## Audit
- [ ] No new Script/LocalScript; the code lives in a Service or Controller.
- [ ] Wiring at the module's top level, actions in `Start()`; no require cycles.
- [ ] Every remote is a Packet in `Network.luau`; the server checks every client value with `Guard`.
- [ ] Data changes go through the replion from `DataService.Get`; new saved fields are in `DataService/Template.luau`.
- [ ] Lifetimes use the Janitor from `PlayerService`/`CharacterController` or the screen's Fusion scope.
- [ ] `selene src` passes; no `ZZ_` leftovers.
- [ ] Output clean on both sides during the playtest. **Read the console after the first playtest before trusting any numbers:** a module that errors on load leaves the system off, and readings can still look plausible.
- [ ] Server checks use real-world bounds: `workspace:GetServerTimeNow()` is ~1.8e9 (a 1e9 cap rejects everything); count caps sit above the game's real highest value; NaN/inf rejected; client positions and directions never trusted as-is.
- [ ] Player-id checks accept Studio test players: their UserIds are negative (Player1 = −1).
- [ ] Every button is pressed once in a playtest, not only its server handler called. Every player-facing counter ("hit it to stop it") is checked from where players really stand.
- [ ] A spec'd control is checked against what Roblox can read (no thumbstick distance) and the keys already bound; a key changing job is called out as a gameplay change.
- [ ] A save-format change keeps old saves loading: a version field (default 0 in the template), a migrate step that raises it, and a repair pass that parks bad data instead of deleting it. Studio's mock save persists between Play runs, so tests snapshot and restore.
- [ ] Replion: send a whole table once, then set only the values that change.
- [ ] Visuals that follow moving models (ropes, props) are welded into that model and drawn with Beams; no constraints between two driven models, no anchored parts moved from the server (they lag).
- [ ] A plan's facts about live code are checked in one quick playtest probe before building on them. Plans written from reading code can be wrong.
- [ ] Moves that grab or carry a player are checked in a real screenshot (camera framing, body height), not only by logs.
- [ ] Parallel chats on one game: re-read sibling Work folders and the uncommitted diff of shared files (data template, services) right before building anything that saves data.
