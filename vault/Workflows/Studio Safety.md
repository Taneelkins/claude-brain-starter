#Workflows

# 🛡️ Studio Safety

> Checks every Roblox workflow runs whenever Claude touches Studio. Tools: [[Studio Bridge]]. Back to [[Workflows]]

## Before any change or playtest
- [ ] `list_roblox_studios` → the right place's `studio_id`; every `execute_luau` starts with `assert(game.PlaceId == <id>)`.
- [ ] Several Studios open → match by place name, and confirm with the owner before a playtest.
- [ ] Code is changed on disk (Rojo), not in Studio. Re-read a file right before editing it.

## During tests
- [ ] Playtest with built-in `start_stop_play` + `execute_luau` (Server or Client) + `get_console_output`; always `start_stop_play false` and `get_studio_state` = Edit at the end.
- [ ] Any probe (`ZZ_*` scripts/remotes) is deleted once its waits finish; confirm `0` left.
- [ ] Tests on real saves: snapshot what you change, restore it exactly.
- [ ] Colour calls come from the real Studio window, not `screen_capture` (it skips post effects).

## After
- [ ] Before publishing: scan for `ZZ_*` and stray RemoteEvents.
- [ ] **Never publish without asking.** Say exactly what goes out.
- [ ] End with: "Reminder: save the place (Cmd/Ctrl-S)".
