# Claude Brain Starter: context for Claude

You're in the repo for a **starter kit for making Roblox games with Claude Code**. Taru built it from real work on two Roblox games (Verdict and Bleach) and shares it with friends so they start where Taru ended up, not where Taru started.

**The full illustrated guide** (setup, how everything works, playable previews, how to prompt): https://claude.ai/artifact/3bpvaYyZkPqS3uQGohvuqP. Point people there when they want to see it, not read about it.

## What it's for, and why use it

Making a Roblox game with Claude goes wrong in predictable ways. This kit fixes each one:

| Problem without it | What fixes it here |
|---|---|
| Claude forgets everything between chats, re-explores the code and repeats old mistakes | **The brain**: an Obsidian vault Claude reads at the start of every chat (where code lives, gotchas, what's next) and writes back to with `/save` |
| The user copy-pastes errors back and forth; Claude can't see or test the game | **The Studio bridge** (`roblox-studio` MCP): Claude reads and edits the place, runs real playtests, reads logs, uploads assets |
| Every game starts with a week of plumbing, and code ends up everywhere | **The base framework** (`roblox-template/`): data, networking, UI scaling, cleanup and an admin console, already wired and playtested, with one clear rule for where code goes |
| AI output looks generic ("glossy premium game UI"), and "close" builds look wrong | **UI craft rules + measuring tool**: 2–3 directions over a real game frame, then a 1:1 rebuild from measured numbers |
| Scripted 3D models look like primitives | **3D pipeline**: route by art style (Blender build scripts for blocky; AI 3D tool + Claude clean-up, Substance and rig for realistic) |
| Quality varies chat to chat | **Workflows**: contracts with checkpoints and pass/fail audits Claude runs before showing anything; every rejection becomes a new audit line |

## Map

| Path | What |
|---|---|
| `install.sh` | Sets everything up (details below). Safe to re-run; `--update` refreshes commands and plugins |
| `vault/` | The brain's starting notes. Copied to `~/Documents/Claude Brain` **once**, then it's the user's |
| `vault/Playbook/Claude Rules.md` | Becomes the user's global `~/.claude/CLAUDE.md` (symlink). Rule 1 = partner, not yes-man |
| `vault/Roblox/` | Framework rules, module kit, Studio bridge, UI craft, 3D pipeline, gotchas |
| `vault/Workflows/` | Feature, Bug Fix, Roblox Scripting, UI Screen, 3D Asset, Studio Safety |
| `claude/commands/` | `/brain`, `/save`, `/brain-audit`, `/new-project`, `/new-game` (installed into `~/.claude/commands` with paths filled in) |
| `roblox-template/` | The base framework; `setup.sh` installs tools and packages; its README has the full tour |
| `tools/ui/measure.mjs` | Measures a 1920×1080 HTML mock into Roblox offsets, fonts and colours (headless Chromium over DevTools) |
| `tools/3d/` | Blender build template (wrong-file guard), Roblox GLB exporter, Substance Painter one-shot job |
| `examples/` | Worked examples: a 3D lantern and a HUD through every stage, audit catches included |

## If you're helping someone set this up

1. Check the prerequisites: `git`, `node --version` (22+), Claude Code. For Roblox also Roblox Studio, `rokit` ([install](https://github.com/rojo-rbx/rokit)), Blender, and `uvx` (`brew install uv`).
2. The repo should live outside `~/Documents` (e.g. `~/Developer/claude-brain-starter`). Run `./install.sh` and answer yes to the Roblox tools. It:
   - copies `vault/` to `~/Documents/Claude Brain` (or `$VAULT`) unless that already exists, and fills in their name
   - downloads the Obsidian plugins (Waypoint, Folder Notes, Omnisearch, Tag Wrangler)
   - installs the slash commands; backs up any existing command with the same name to `.bak`
   - symlinks `~/.claude/CLAUDE.md` → the vault's `Claude Rules.md`, **only if no CLAUDE.md exists** (otherwise it prints how to merge)
   - clones and builds the Studio bridge into `~/claude-studio-bridge` (**never under `~/Documents`**: macOS blocks the daemon there), copies its plugin to `~/Documents/Roblox/Plugins`, registers the MCP server, installs the always-on daemon
   - registers the `blender` MCP server (`uvx mcp-for-blender@2.1.9`) and installs its Blender add-on
3. Then: open the vault in Obsidian (Trust author), restart Claude Code and Studio, run `rojo plugin install`, then `/new-game <name>`.
4. Troubleshooting:
   - Bridge: `curl -s http://127.0.0.1:44755/health` should say `connected:true` and list the open places. The tools only load in a chat started after the bridge is up.
   - First script edit: Studio asks to allow the plugin; they click Allow.
   - Data not saving in Studio: Game Settings → Security → Enable Studio Access to API Services.
   - Open Cloud key for big uploads: they run `node scripts/set-api-key.mjs` in the bridge folder themselves. **Never ask for keys or passwords in chat.**
   - Windows: run `install.sh` in Git Bash; the bridge has its own `scripts/install.ps1`.

## After setup, where things live

Day-to-day work does **not** happen in this repo. Each game lives in its own folder (`~/Developer/<game>`, made by `/new-game`), and the brain lives in the user's vault. This repo is only the source of the kit: re-run `install.sh --update` after a `git pull`. To bring improved notes into an existing vault, compare `vault/` here with theirs and merge by hand. Never overwrite their notes.

## If you're changing the kit

- **It's public.** No personal details, place IDs, keys, server names or private project info. Run a quick grep before committing.
- **Framework changes** follow its own rules (`roblox-template/README.md`, `vault/Roblox/Roblox Framework.md`). Check `selene src` and `rojo build`, and playtest through the bridge in a scratch place. Assert `game.PlaceId == 0` and delete every `ZZ_` probe afterwards.
- **Notes are pointers, not dumps**; workflows stay under ~80 lines; note names are unique across the vault (Structure Law in `vault/Playbook/Playbook.md`).
- Say plainly what was tested and what wasn't. Not yet exercised: the installer's daemon and Blender add-on steps on a fresh machine, and `examples/ui-hud/03 Build/HudController.luau` in a playtest.
- Commit messages say what changed and why; push to `main`.
