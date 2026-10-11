#ExampleGame

# 🧪 Example Game

> What a game's folder note looks like. `/new-game` makes a real one; delete this after. Back to [[Claude Brain]] · backlog: [[Example Game Plans]]
> verified: YYYY-MM-DD

> 🧠 **Claude wiring:** code `~/Developer/example-game` (from `roblox-template`) → `github.com/you/example-game`. Place `1234567890` (assert this PlaceId). Sync: `rojo serve`. Lint: `selene src`. Work files: `~/Developer/example-game/Work/`. Look: [[Style Bible]] → Example Game.

%% Waypoint %%

## Notes
- [[Example Game Gotchas]]: traps this game already hit.

## Code map
| System | Server | Client |
|---|---|---|
| Data | `Services/DataService` (Template: Coins, LastDaily) | `Controllers/DataController` |
| Daily reward | `Services/RewardService` | `Controllers/HudController` |
| Admin | `Services/CommandService`, `Commands/` | `Controllers/CommandController` |

## Rules for this game
- Example: all currency changes log through `RewardService`.
- Example: UI copy is uppercase.
