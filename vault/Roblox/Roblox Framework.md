#Roblox

# 🏗️ Roblox Framework

> How every game is laid out, so Claude always knows where code goes. The working version is `roblox-template/`. Back to [[Roblox]]

## Layout (Rojo)
| On disk | In Studio | Holds |
|---|---|---|
| `src/server/Main.server.luau` | `ServerScriptService.Server.Main` | the ONLY server Script |
| `src/server/Services/` | `ServerScriptService.Server.Services` | one ModuleScript per server system (`DataService`, `CombatService`…) |
| `src/client/Main.client.luau` | `StarterPlayerScripts.Client.Main` | the ONLY LocalScript |
| `src/client/Controllers/` | `StarterPlayerScripts.Client.Controllers` | one ModuleScript per client system (`CoinController`, `CameraController`…) |
| `src/shared/` | `ReplicatedStorage.Shared` | code both sides use; `Network.luau` defines every remote |
| `src/shared/Vendor/` | `ReplicatedStorage.Shared.Vendor` | `.rbxm` libraries not on Wally (Packet, Text+) |
| `Packages/`, `ServerPackages/` | `ReplicatedStorage.Packages`, `ServerScriptService.ServerPackages` | Wally installs; never edit, never commit |

## How it boots
1. `Main` requires every module in `Services/` (or `Controllers/`).
2. Then it calls each module's `Start()` in its own thread, if it has one.

So a module's **top level** is for wiring: requires, connecting to signals and packets, setting `OnServerInvoke`. **`Start()`** is for doing things: player loops, `while true` loops, building UI. Every module can safely connect to every other module's signals before anything starts. No `Init` step, no framework object, no magic.

## Rules
- **One Script per side.** Never add another Script or LocalScript. New system = new module in `Services/` or `Controllers/`.
- **Services talk by requiring each other** at the top (`local DataService = require(script.Parent.DataService)`). No two modules may require each other (a cycle hangs forever).
- **Every remote lives in `Shared/Network.luau`** as a Packet. Nothing else creates RemoteEvents.
- **The server owns the truth.** Clients ask; the server checks every value (range, cooldown, distance, ownership) before acting.
- **Only `DataService` touches ProfileStore.** Everyone else goes through `DataService.Get(Player)`.
- **Anything tied to a lifetime goes in a Janitor** (character, round, UI screen) and is cleaned up when that lifetime ends.
- **Requires go at the top** as `local X = require(...)`, never inline.
- **Code lives on disk.** With Rojo, edits made in Studio's script editor get overwritten on the next sync.
