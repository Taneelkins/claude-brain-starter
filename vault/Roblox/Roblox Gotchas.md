#Roblox

# ⚠️ Roblox Gotchas

> Traps every Roblox dev hits once. Add your own as they bite. Back to [[Roblox]]

## Players & characters
- **`PlayerAdded` misses players who joined before you connected** (common in Studio solo play) → loop `Players:GetPlayers()` first, then connect.
- **ScreenGuis made in code vanish on respawn** → `ResetOnSpawn = false`.
- **Character connections leak across respawns** → put them in a per-character Janitor.

## Data
- **Data doesn't save in Studio** → Game Settings → Security → *Enable Studio Access to API Services*. Without it ProfileStore silently runs in mock mode.
- **Changing the data template doesn't update old players** unless `Profile:Reconcile()` runs on load.

## Networking
- **Packet types are enforced, values aren't.** A client can send any `NumberU8`. Check ranges, cooldowns and distance on the server.
- **Never send the client what it shouldn't know** (other players' data, hidden answers). Exploiters read every packet.

## Studio & Rojo
- **Script edits in Studio get overwritten by Rojo** → edit on disk. Build and terrain still happen in Studio.
- **`WaitForChild` with no timeout can hang forever** and only warns once → give a timeout on anything that might not exist (StreamingEnabled parts especially).
- **Use `task.wait/spawn/delay`**, never the old `wait/spawn/delay`.
