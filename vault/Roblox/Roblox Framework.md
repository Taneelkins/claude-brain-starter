#Roblox

# 🏗️ Roblox Framework

> How every game is laid out, so Claude always knows where code goes. Full tour in `roblox-template/README.md`. Back to [[Roblox]]

## Layout (Rojo)
| On disk | In Studio | Holds |
|---|---|---|
| `src/server/Main.server.luau` | `ServerScriptService.Server.Main` | the ONLY Script |
| `src/server/Services/` | `…Server.Services` | `PlayerService`, `DataService/`, `CommandService`, one module per system |
| `src/server/Guard.luau` | `…Server.Guard` | Cooldown / Number / Near checks |
| `src/server/Commands/` | `…Server.Commands` | Cmdr commands (`Name` + `NameServer`) |
| `src/client/Main.client.luau` | `StarterPlayerScripts.Client.Main` | the ONLY LocalScript |
| `src/client/Controllers/` | `…Client.Controllers` | `DataController`, `UIController`, `CharacterController`, `CommandController`, one per system |
| `src/client/UI/` | `…Client.UI` | `Theme` + Fusion `Components/` (Text, Button) |
| `src/shared/` | `ReplicatedStorage.Shared` | `Config`, `Permissions`, `Network` (every Packet), `Vendor/` (Text+, Packet) |
| `Packages/`, `ServerPackages/` | `ReplicatedStorage.Packages`, `ServerScriptService.ServerPackages` | Wally installs: never edit, never commit |

## Boot
`Main` requires every module in its folder, then calls each one's `Start()` in its own thread. **Top level = wiring** (requires, `Signal:Connect`, `OnServerInvoke`); **`Start()` = doing** (loops, players, building UI). No Init step, no framework object.

## Rules
- **One Script per side.** New system = new module.
- Modules require each other at the top. **No require cycles** (two modules requiring each other hang forever).
- **Lifetimes:** listen to `PlayerService.PlayerAdded` / `CharacterAdded` (server) or `CharacterController.CharacterAdded` (client) and put cleanup in the Janitor you're handed.
- **Data:** `DataService.Get(Player)` returns the player's Replion. Change it ONLY with `:Set/:Increase/:Update/:Insert`; it saves and replicates by itself. New saved field = add it to `DataService/Template.luau`. Client reads with `DataController.Observe(Path, Fn)`.
- **Network:** every remote is a Packet in `Shared/Network.luau` with exact types. The server checks every value with `Guard` before acting.
- **UI:** `UIController.Mount(Name, function(Scope, Canvas) ... end)` builds a screen in Fusion at 1920×1080; `Unmount` cleans its scope. Colours/fonts from `UI/Theme`. Text that needs a custom font, stroke or spacing uses the `Text` component (Text+).
- **Admin:** `Permissions.IsAdmin` (owner, group rank ≥ `Config.AdminRank`, `Config.Admins`, everyone in Studio). Debug tools go in as Cmdr commands, not temporary GUIs.
- **Code lives on disk.** Rojo overwrites edits made in Studio's script editor.
