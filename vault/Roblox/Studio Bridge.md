#Roblox

# 🔌 Studio Bridge

> How Claude works inside Roblox Studio. Two MCP servers, split by job: Roblox's **built-in `Roblox_Studio`** does nearly everything (read, edit, playtest, input, screenshots, logs); our **`roblox-studio` bridge** only uploads local files and exports to Blender. Bridge repo: [Taneelkins/claude-studio-bridge](https://github.com/Taneelkins/claude-studio-bridge). Back to [[Roblox]]

## Setup
- **Built-in (do this yourself):** Studio → Assistant → ⋯ → Settings → MCP Servers → enable. `install.sh` registers it on Mac (`claude mcp add Roblox_Studio -s user -- /Applications/RobloxStudio.app/Contents/MacOS/StudioMCP`); on Windows point it at `StudioMCP.exe` in the Studio install folder.
- **Bridge (`install.sh` does this):** clone to `~/claude-studio-bridge` (**never under `~/Documents`**: macOS blocks the background daemon there), build, copy `release/TaruTools.rbxm` to `~/Documents/Roblox/Plugins/`, run `scripts/register-mcp.mjs` and `scripts/install-daemon.sh`. Restart Studio and Claude Code.
- Bridge health: `curl -s http://127.0.0.1:44755/health` → `connected:true` (the plugin is only needed for `export_to_blender`).
- Uploads need an Open Cloud key: `node scripts/set-api-key.mjs` in a terminal (Assets read+write; make it under the group for group games). Never paste a key into chat.

## Which tool for what
| Job | Tool |
|---|---|
| Find the right Studio | built-in `list_roblox_studios` → pass its `studio_id` to every call |
| Look before changing | built-in `search_game_tree`, `inspect_instance`, `script_read`, `script_grep` |
| Edit | built-in `multi_edit` (scripts), `execute_luau` (anything else, one undo step) |
| Playtest | built-in `start_stop_play` → `user_keyboard_input` / `character_navigation` → `execute_luau` on Server or Client → `get_console_output` → `start_stop_play false` |
| Screenshot | built-in `screen_capture` (edit mode or mid-playtest, UI included) |
| Creator Store | built-in `search_asset` → `insert_asset` |
| Upload a local file | bridge `upload_asset` (PNG/audio/FBX/GLB/video → asset id, logged in the asset ledger) → built-in `insert_asset` |
| Studio → Blender | bridge `export_to_blender` (any model → folder Blender rebuilds 1:1, see [[3D Pipeline]]) |

Don't use the bridge's old edit and playtest tools (`run_code`, `run_in_play_mode`, `edit_script`…). Roblox maintains the built-in ones.

## Rules
- **Right place first:** match the place name from `list_roblox_studios`, then start every `execute_luau` with `assert(game.PlaceId == <id>)`.
- **With Rojo, code changes go on disk**, not through `multi_edit` (Rojo overwrites them). Use Studio tools for reading, testing, building non-code instances, and assets.
- **Always stop a playtest** (`start_stop_play false`) and check `get_studio_state` reads Edit before moving on.
- **`execute_luau` has its own `require` cache**: game modules come back fresh, not the running copies. To drive live modules, parent a temporary `ZZ_` Script and delete it after its waits finish (destroying a Script kills its threads). Confirm 0 `ZZ_` left.
- **`screen_capture` skips post effects** (ColorCorrection, Bloom): judge colour from the real Studio window.
- **Playtests use real data** once API access is on. Snapshot any fields a test changes and restore them exactly.
- **Never publish without asking.**
- Big payloads: serve the folder with `python3 -m http.server <free port> --bind 127.0.0.1` and `HttpService:GetAsync` it inside `execute_luau`; never paste huge sources. Check the port is free first (`lsof -iTCP:<port>`).
