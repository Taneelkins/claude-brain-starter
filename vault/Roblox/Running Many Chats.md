#Roblox

# 🧵 Running Many Chats

> How several Claude chats share one Mac: Studio windows, Blender slots, taking turns with locks, and the guard hooks. Read when two or more chats work at once (see [[Big Project]]). Back to [[Roblox]]

## Setup (once)
`./install.sh` → answer **yes** to "several chats at once" (or `MULTI=yes ./install.sh`). It copies the tools to `~/claude-tools`, starts the shared Blender server, registers Blender slots `blender`…`blender6`, and adds two hooks to `~/.claude/settings.json`. Restart Claude Code afterwards. The shared Blender server and the hooks are Mac-only for now; `claude-lock` works anywhere with Python 3.

## Studio: several windows
- **Each window needs the MCP switch on:** Studio → Assistant → ⋯ → Settings → MCP Servers → "Enable Studio as MCP server". Then `list_roblox_studios` shows every window with its `studio_id` and place name.
- **Give each window a job**, written in the project note: e.g. an **edit window** (all scripts and lasting changes) and a **test window** (playtests and previews). Two accounts can each open the same Team Create place; previews made in edit mode replicate to both, so name them plainly and delete them.
- **Claude picks the window by its job and place name**, passes its `studio_id` to every call and starts every `execute_luau` with `assert(game.PlaceId == <id>)`. A window that closes and reopens gets a new id: list again.
- **A playtest blocks edits in that window.** With only one window, keep tests short and get back to Edit.
- **Local multiplayer:** Test → Start Test Session → Server and Clients. Every client and the server is its own studio id; stopping the server closes them all.
- **Captures:** built-in `screen_capture` for layout and UI; real-window captures (`screencapture -l <window id>`, in the background) for colour. Studio must not be in macOS full screen and must be on the current Space. Never take over the mouse or keyboard without asking, and hand control back right after.

## Blender: one slot per chat
- Six slots: `blender` (port 9876), `blender2` (9877) … `blender6` (9881). **One shared background server** serves all six, so chats don't each start their own (six servers per chat across 20 chats used 10 GB and crashed a Mac).
- **Give a chat its slot in its first message** ("use Blender slot 2"). The chat opens it with `~/claude-tools/blender-slot 2 [file.blend]` and only ever calls that slot's tools, never other slots, not even to check status. No slot given → work headless (`blender -b --python`) or ask.
- Never save "slot 2 belongs to X" as a rule: slots are per chat.
- **Before replacing an open scene**, save it and diff it against the file on disk: fold anything that only lived in the scene into the build script.
- Tools failing? `curl -s 127.0.0.1:9870/status`, then restart the server: `launchctl kickstart -k gui/$(id -u)/com.claude-brain.blender-bridge` (log: `~/claude-tools/blender-bridge.log`).

## Taking turns: `claude-lock`
For anything only one chat can do at a time:
```
~/claude-tools/claude-lock take <resource> --who "<this chat's title>" --why "<what>" [--wait 540] [--ttl 300]
... do it ...
~/claude-tools/claude-lock give <resource> --who "<this chat's title>"
~/claude-tools/claude-lock status
```
- It queues you and waits (up to `--wait` s). A dead chat's lock expires after `--ttl` (300 s); `renew` during long jobs. A play → fix → play loop in one turn takes `--ttl 900`.
- **Resources:** `studio-test` (any playtest), `studio-camera` (moving a window's camera or capturing it), `screen` (anything that takes over the screen), `file:<name>` (a shared file being written). With two windows, name them: `studio-camera:edit`, `studio-camera:test`.
- Hold a lock only for the action itself, never across turns. Release on failure too (wrap scripts in a `trap`).
- Waiting for a lock (or anything else): one background watcher, never polling turn after turn.

## Guard hooks
- **Playtest guard** (`play-guard`): blocks `start_stop_play` unless this chat holds a `studio-*` lock under its **exact chat title**. The block message gives the command to run. A chat with no title isn't checked.
- **Long-chat guard** (`context-guard`): at ~300k, 450k and 600k tokens it tells the chat to `/save`, write a continuation opener and start the next chat itself.
- Both fail open: if they break, they never block work.

## Habits that keep it calm
- **3–4 busy chats max**, never two on the same files ([[Big Project]]).
- Restarting the Claude app stops every chat's background watchers: nudge any chat that was waiting.
- Only stop processes you started, by PID. Local servers: check a port is free (`lsof -iTCP:<port> -sTCP:LISTEN`) and take another one rather than killing someone else's.
- Another chat's `undo` can undo your step: re-check temp objects still exist, and count `ZZ_` leftovers at the end.
