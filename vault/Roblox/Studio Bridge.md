#Roblox

# 🔌 Studio Bridge

> Lets Claude work inside Roblox Studio: read and edit scripts, build instances, run playtests, upload assets, export to Blender. Repo: [Taneelkins/claude-studio-bridge](https://github.com/Taneelkins/claude-studio-bridge). Back to [[Roblox]]

## Setup (the starter's `install.sh` does this)
Clone to `~/claude-studio-bridge` (**never under `~/Documents`**: macOS blocks the background daemon there), build the bridge, copy `release/TaruTools.rbxm` to `~/Documents/Roblox/Plugins/`, run `scripts/register-mcp.mjs` and `scripts/install-daemon.sh`. Restart Studio and Claude Code. First script edit: click **Allow** on Studio's permission prompt.
- Health: `curl -s http://127.0.0.1:44755/health` → `connected:true` + the open places.
- Uploads beyond small PNGs need an Open Cloud key: `node scripts/set-api-key.mjs` in a terminal (Assets read+write; make it under the group for group games). Never paste a key into chat.

## What Claude uses most
| Tool | For |
|---|---|
| `list_studios` / `select_studio` | link this chat to the right place (several Studios = must pick) |
| `get_tree`, `search_instances`, `search_scripts`, `get_script_source` | look before changing |
| `edit_script` | small exact edits (preferred over resending whole files) |
| `run_code` | anything else, in edit mode (one undo step) |
| `run_in_play_mode` | real playtest, server-side test code, returns logs + errors, auto-stops |
| `upload_asset` → `insert_asset` | PNG/audio/FBX/GLB → asset id → into the place |
| `export_to_blender` | any model in Studio → folder Blender rebuilds 1:1 (see [[3D Pipeline]]) |

## Rules
- **Right place first:** `list_studios`, then start every `run_code` with `assert(game.PlaceId == <id>)`.
- **With Rojo, code changes go on disk**, not through `set_script_source`/`edit_script` (Rojo overwrites them). Use the bridge for reading, testing, building non-code instances, and assets.
- **Test the client too:** `run_in_play_mode` runs on the server. To check client UI, add a temporary `ZZ_` LocalScript that reports back over a `ZZ_` RemoteEvent, then delete every `ZZ_` instance in the same step and confirm 0 left.
- **Playtests use real data** once API access is on. Snapshot any fields a test changes and restore them exactly.
- **Never publish without asking.**
- Big payloads: serve the folder with `python3 -m http.server <free port> --bind 127.0.0.1` and `HttpService:GetAsync` it inside `run_code`; never paste huge sources. Check the port is free first (`lsof -iTCP:<port>`).
