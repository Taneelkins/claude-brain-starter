#Workflows

# 🛡️ Studio Safety

> Checks every Roblox workflow runs whenever Claude touches Studio. Tools: [[Studio Bridge]]. Several chats or windows: [[Running Many Chats]]. Back to [[Workflows]]

## Before any change or playtest
- [ ] `list_roblox_studios` → the right window's `studio_id` (match the place name); every `execute_luau` starts with `assert(game.PlaceId == <id>)`. The built-in tools don't remember the window between chats: look it up each time.
- [ ] Several Studios open → pick the window by its **job** (edit window vs test window, see the project note), and confirm with the owner before a playtest.
- [ ] Code is changed on disk (Rojo), not in Studio. Re-read a file right before editing it; someone may have just changed it.
- [ ] Shared Studio (other chats or people): check for a running playtest (`get_studio_state`) before previews or camera moves, and take the matching `claude-lock` ([[Running Many Chats]]).
- [ ] Previews and imports go in your own plainly named folder (e.g. `Workspace.<Job>Preview`), never `workspace.Model`; another chat's import can sit there. Delete them yourself.
- [ ] Studio is **not** in macOS full screen (a full-screen window is its own Space; Claude can't capture it).

## During tests
- [ ] Playtest with built-in `start_stop_play` + `execute_luau` (Server or Client) + `get_console_output`; **always** `start_stop_play false` and `get_studio_state` = Edit before you hand the window back.
- [ ] Any probe (`ZZ_*` scripts/remotes) is deleted once its waits finish; confirm `0` left. Another chat's `undo` can revert your step: re-check temp instances still exist before relying on them.
- [ ] Tests on real saves: snapshot exactly what you change, restore it exactly. Never clear items by name.
- [ ] Colour calls come from a **real-window capture** (`screencapture -l <window id>` on Mac, in the background), never built-in `screen_capture` (it skips post effects), and never in a shaded spot.
- [ ] Test input limits: it can't press hotbar keys (`One`…) or trigger ProximityPrompts, and `user_mouse_input` is off by the top-bar height for drag/drop hit tests. A server `PivotTo` of your character gets overwritten (move it from the client). Plan these as hand-tests and name them.
- [ ] Script paths differ by mode: in Play, `script_read` can fail; read `.Source` through `execute_luau` instead.
- [ ] Multiplayer locally: Test → Start Test Session → Server and Clients (can start at 0 players, then Test → Add Clients). Each client and the server show up as separate studio ids; `start_stop_play false` on the server closes them all.
- [ ] Freshly uploaded images: wait for `Approved` (`get_asset_status`) before Studio loads the id, or it stays white for the whole session. Right after a Studio restart, textures can show white for a few seconds.

## After
- [ ] Before publishing: scan for `ZZ_*`, preview folders and stray RemoteEvents.
- [ ] **Never publish without asking.** Say exactly what goes out.
- [ ] End with: "Reminder: save the place (Cmd/Ctrl-S)".
