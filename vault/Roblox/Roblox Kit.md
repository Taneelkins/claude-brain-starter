#Roblox

# 🧰 Roblox Kit

> The modules every game starts with, and the one rule for each. Versions are pinned in `roblox-template/wally.toml`. Back to [[Roblox]]

## Tools
| Tool | Job | Get it |
|---|---|---|
| Rokit | installs the right Rojo/Wally versions per project (`rokit install`) | [rojo-rbx/rokit](https://github.com/rojo-rbx/rokit) |
| Rojo | syncs `src/` into Studio (`rojo serve` + the Studio plugin) | [rojo.space](https://rojo.space) |
| Wally | package manager (`wally install`) | [wally.run](https://wally.run) |

## Modules
| Module | Job | Rule | Get it |
|---|---|---|---|
| **Janitor** | cleans up connections, instances, threads when something ends | one Janitor per lifetime; `:Cleanup()` on end or `:LinkToInstance()` | Wally · [howmanysmall/Janitor](https://github.com/howmanysmall/Janitor) |
| **Packet** | fast, typed networking over one RemoteEvent | define every packet in `Shared/Network.luau` with exact types (`NumberU8`, `Vector3F24`…) | `.rbxm` · [DevForum post](https://devforum.roblox.com/t/packet-networking-library/3573907) |
| **ProfileStore** | player data with session locking (no dupes, no lost saves) | only `DataService` uses it; always `Reconcile()` so new template fields appear | Wally (server) · [MadStudioRoblox/ProfileStore](https://github.com/MadStudioRoblox/ProfileStore) |
| **Fusion** | reactive UI in code: change a Value, the UI updates | one `scope` per screen; `scope:doCleanup()` when it closes | Wally · [dphfox/Fusion](https://github.com/dphfox/Fusion) |
| **Text+** | text with custom fonts and per-letter control | use for designed text (titles, damage numbers), plain TextLabels elsewhere | `.rbxm` · [AlexanderLindholt/TextPlus](https://github.com/AlexanderLindholt/TextPlus) |
| **Signal** | custom events between modules (`DataService.ProfileLoaded`) | expose signals, don't poll | Wally · [Sleitnick/RbxUtil](https://github.com/Sleitnick/RbxUtil) |
| **Promise** | async work that can fail or time out | for chains of yields; plain `task.spawn` for fire-and-forget | Wally · [evaera/roblox-lua-promise](https://github.com/evaera/roblox-lua-promise) |

## Add when needed
- **Replion** ([yTrev/Replion](https://github.com/yTrev/Replion)): replicates server state tables to clients. Use it when many systems need player data on the client, instead of a packet per field.
- **Cmdr** ([evaera/Cmdr](https://github.com/evaera/Cmdr)): admin/debug command console.
- **Vide** ([centau/vide](https://github.com/centau/vide)): a lighter alternative to Fusion. Pick one per game, never both.
