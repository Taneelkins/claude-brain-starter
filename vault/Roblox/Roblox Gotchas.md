#Roblox

# ⚠️ Roblox Gotchas

> Traps that bite everyone once. Add your own as they bite. Back to [[Roblox]]

## Players & characters
- **`PlayerAdded` misses players who joined before you connected** (Studio solo play) → loop `Players:GetPlayers()` first. `PlayerService` already does.
- **ScreenGuis made in code vanish on respawn** → `ResetOnSpawn = false` (the App gui has it).
- **Character connections leak across respawns** → per-character Janitor.

## Data
- **Data doesn't save in Studio** → Game Settings → Security → *Enable Studio Access to API Services*. Otherwise ProfileStore prints "API services unavailable" and runs in memory.
- **Replion data is immutable**: every change makes a new table. `DataService` keeps the profile pointing at the latest one; never cache `Profile.Data` or a sub-table and edit it.
- **Waiting on Replion's own registry races the save hook**: Replion resumes waiters before `DataService` has stored the replion. Use `DataService.Wait(Player)`, never `Replion.Server:WaitReplionFor` (found by testing this template).

## Networking
- **Packet enforces types, not values.** A client can send any `NumberU8`. Check ranges, cooldowns, distance with `Guard`.
- **Exploiters read every packet.** Never send what a player shouldn't know.

## UI
- **Text+ under a UIScale drifts left** when centred/right-aligned: it reads `AbsoluteSize` (scaled) but places letters in unscaled offsets. The vendored Text+ divides by the UIScale chain; keep that fix if you update Text+.
- Design at 1920×1080 inside the canvas; never mix Scale and Offset sizing on the same screen without a reason.

## Studio & Rojo
- **Script edits in Studio get overwritten by Rojo** → edit on disk. Building and terrain still happen in Studio.
- **Cmdr 1.13 uses new Luau syntax** (`const`, `@self` requires): it only runs inside Studio/Roblox, not in standalone Luau tools.
- **`WaitForChild` with no timeout can hang forever** → give a timeout for anything that might not exist (StreamingEnabled parts especially).
- Use `task.wait/spawn/delay`, never the old `wait/spawn/delay`.
