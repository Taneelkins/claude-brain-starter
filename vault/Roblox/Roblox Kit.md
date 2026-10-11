#Roblox

# 🧰 Roblox Kit

> Every module the framework uses and the one rule for each. Versions pinned in `roblox-template/wally.toml` and `rokit.toml`. Back to [[Roblox]]

## Tools
| Tool | Job | Get it |
|---|---|---|
| Rokit | installs the project's tool versions (`rokit install`) | [rojo-rbx/rokit](https://github.com/rojo-rbx/rokit) |
| Rojo | syncs `src/` into Studio (`rojo serve` + Studio plugin) | [rojo.space](https://rojo.space) |
| Wally | packages (`wally install`) | [wally.run](https://wally.run) |
| Selene / StyLua | lint / format (`selene src`, `stylua src`) | in `rokit.toml` |

## Modules
| Module | Job | Rule |
|---|---|---|
| **ProfileStore** ([repo](https://github.com/MadStudioRoblox/ProfileStore)) | saves player data with session locking (no dupes, no lost saves) | only `DataService` touches it; `Reconcile()` on load |
| **Replion** ([repo](https://github.com/yTrev/Replion)) | live copy of server data on the client | change data only through the replion; its tables are **immutable** (each change makes a new table) |
| **Packet** ([DevForum](https://devforum.roblox.com/t/packet-networking-library/3573907)) | fast typed networking on one RemoteEvent | all packets in `Network.luau`, smallest type that fits; `:Response()` for request/answer |
| **Janitor** ([repo](https://github.com/howmanysmall/Janitor)) | cleanup | one per lifetime; `:Add(x, "Disconnect")`, `:LinkToInstance(model)` |
| **Fusion 0.3** ([repo](https://github.com/dphfox/Fusion)) | reactive UI: change a Value, the UI updates | one scope per screen (`UIController.Mount` does it); `Scope:Computed(function(Use) …)` |
| **Text+** ([repo](https://github.com/AlexanderLindholt/TextPlus)) | text with custom fonts, stroke, spacing, per-letter control | use via `UI/Components/Text`; the vendored copy has a UIScale fix (see Gotchas) |
| **Signal** ([RbxUtil](https://github.com/Sleitnick/RbxUtil)) | events between modules | expose signals, don't poll |
| **Promise** ([repo](https://github.com/evaera/roblox-lua-promise)) | async chains that can fail/time out | `task.spawn` for fire-and-forget |
| **Cmdr** ([repo](https://github.com/evaera/Cmdr)) | F2 admin/debug console | permissions via the `BeforeRun` hook in `CommandService` |

## Custom fonts (Text+)
Any `.ttf` can become a Text+ font: render the glyphs to an atlas PNG, upload it, and write the data module Text+ expects (a ModuleScript tagged `Fonts`). Claude can do the whole thing with Python (PIL) + the Studio bridge's `upload_asset`. Text+ docs: `documentation/custom-fonts/` in its repo.
