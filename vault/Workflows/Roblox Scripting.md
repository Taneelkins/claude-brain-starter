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

## Loop
1. **Find what exists.** Search `src/` for the feature's keywords. Name the Service/Controller it belongs in, or say why it needs a new one.
2. **Plan.** List the module(s), any new packets for `Network.luau` with their exact types, any new data fields for the `DataService` template.
   - **Checkpoint** if it adds a new Service/Controller, changes saved data, or changes existing gameplay.
3. **Build** on disk (never in Studio's script editor).
4. **Verify** in a Studio playtest: server and client output both clean, then the feature itself. Say what wasn't tested.
5. **Close:** commit. Nudge `/save`.

## Audit
- [ ] No new Script/LocalScript; the code lives in a Service or Controller.
- [ ] Wiring at the module's top level, actions in `Start()`; no require cycles.
- [ ] Every remote is a Packet in `Network.luau`; the server checks every client value.
- [ ] Data changes go through `DataService`; template fields added for anything saved.
- [ ] Lifetimes (character, round, screen) are cleaned up with a Janitor or Fusion scope.
- [ ] Output clean on both sides during the playtest.
