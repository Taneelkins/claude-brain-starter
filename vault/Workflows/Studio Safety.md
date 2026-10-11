#Workflows

# 🛡️ Studio Safety

> Checks every Roblox workflow runs whenever Claude touches Studio. Back to [[Workflows]]

## Before any change or playtest
- [ ] `list_studios` → the right place is linked; every `run_code` starts with `assert(game.PlaceId == <id>)`.
- [ ] Several Studios open → link by place, and confirm with the owner before a playtest.
- [ ] Code is changed on disk (Rojo), not in Studio. Re-read a file right before editing it.

## During tests
- [ ] Prefer `run_in_play_mode` (server-side checks, auto-stops).
- [ ] Any probe (`ZZ_*` scripts/remotes) is deleted in the same step; confirm `0` left.
- [ ] Tests on real saves: snapshot what you change, restore it exactly.

## After
- [ ] Before publishing: scan for `ZZ_*` and stray RemoteEvents.
- [ ] **Never publish without asking.** Say exactly what goes out.
- [ ] End with: "Reminder: save the place (Cmd/Ctrl-S)".
