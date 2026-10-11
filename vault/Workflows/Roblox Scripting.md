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
4. **Verify** with `run_in_play_mode`: call the service directly and print results; for client behaviour use a `ZZ_` probe (see [[Studio Bridge]]). Server and client logs both clean. Say what wasn't tested.
5. **Close:** commit. Nudge `/save`.

## Audit
- [ ] No new Script/LocalScript; the code lives in a Service or Controller.
- [ ] Wiring at the module's top level, actions in `Start()`; no require cycles.
- [ ] Every remote is a Packet in `Network.luau`; the server checks every client value with `Guard`.
- [ ] Data changes go through the replion from `DataService.Get`; new saved fields are in `DataService/Template.luau`.
- [ ] Lifetimes use the Janitor from `PlayerService`/`CharacterController` or the screen's Fusion scope.
- [ ] `selene src` passes; no `ZZ_` leftovers.
- [ ] Output clean on both sides during the playtest.
