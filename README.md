# 🧠 Claude Brain Starter

An Obsidian vault that gives [Claude Code](https://claude.com/claude-code) a long-term memory you control.

Claude forgets everything between chats. Without a brain, every session starts with it re-exploring your code and re-learning the same traps. With one, it reads a few short notes at the start of each chat (where things are, what bit you last time, what's next), and you write what it learned back in with `/save`.

```
new chat ─▶ Claude reads: root index → Playbook → your project's note → the workflow for this task
                │
            does the work
                │
            /save ─▶ new facts, gotchas and next steps go back into the notes
```

## What you get

| Part | What it does |
|---|---|
| `Claude Brain.md` | Root index. Claude reads it first; it lists your projects. |
| `Playbook/` | How the brain works (Structure Law, session habits) and **Claude Rules**, your global `CLAUDE.md`. |
| `Plans/` | The backlog. "What's next?" reads this. One plans note per project. |
| `Workflows/` | Repeatable contracts for kinds of work (Feature, Bug Fix): inputs, steps, checkpoints, a pass/fail audit. |
| `Example Project/` | A filled-in sample so you can see the shape. Delete it once you have a real one. |
| `_templates/` | Templates for new projects, plans, gotchas and workflows. |
| Slash commands | `/brain`, `/save`, `/brain-audit`, `/new-project` |
| Obsidian plugins | [Waypoint](https://github.com/IdreesInc/Waypoint), [Folder Notes](https://github.com/LostPaul/obsidian-folder-notes), [Omnisearch](https://github.com/scambier/obsidian-omnisearch), [Tag Wrangler](https://github.com/pjeby/tag-wrangler), already configured |

## Setup (5 minutes)

**You need:** [Obsidian](https://obsidian.md/download), [Claude Code](https://docs.claude.com/en/docs/claude-code/overview) and git. macOS or Linux; on Windows, run the script in Git Bash or WSL.

1. Clone this repo somewhere that isn't iCloud-synced, e.g. `~/Developer`:
   ```bash
   git clone https://github.com/Taneelkins/claude-brain-starter.git ~/Developer/claude-brain-starter
   ```
2. Run the installer. It asks your name, then sets everything up:
   ```bash
   ~/Developer/claude-brain-starter/install.sh
   ```
   - Creates the vault at `~/Documents/Claude Brain` (use `VAULT=/some/path ./install.sh` to put it somewhere else)
   - Downloads the 4 Obsidian plugins
   - Installs the slash commands into `~/.claude/commands`
   - Links `~/.claude/CLAUDE.md` to `Playbook/Claude Rules.md`. If you already have a `CLAUDE.md`, it's left alone and the script tells you how to merge.
3. Open Obsidian → **Open folder as vault** → pick the vault folder → **Trust author and enable plugins**.
4. Open Claude Code in your project folder and run:
   ```
   /new-project My App ~/Developer/my-app
   ```
   Claude reads the repo, writes the project's folder note and code map, adds it to the index and offers to delete the example.

## Daily loop

1. **Start a chat.** Claude reads the brain on its own (that's in `CLAUDE.md`) and says in one line what it loaded. `/brain` gives you a quick "what's next" across all projects.
2. **Work.** One task per chat. Claude follows the matching workflow and stops at checkpoints.
3. **`/save`** after each chunk of work. Claude updates the notes and plans and gives you a one-line summary. Saving is manual on purpose: you see what goes in.
4. Every few weeks, **`/brain-audit <project>`** catches notes that have gone stale.

## The rules that make it work

The full version is in `Playbook/Playbook.md`. The short one:

- **Pointers, not dumps.** Notes say *where* something is and *when* to read it. Pasting code into notes makes them long, expensive and stale.
- **Every folder has a folder note** with the same name (`My App/My App.md`). The `%% Waypoint %%` line inside it turns into an auto-generated list of the folder's notes.
- **Unique note names.** Prefix with the project (`My App Gotchas`), because `[[links]]` break silently on duplicates.
- **Gotchas are gold.** Every "that took an hour to figure out" becomes one line in the project's Gotchas note, so it never costs an hour again.
- **Workflows improve themselves.** When Claude makes a mistake a checklist should have caught, `/save` adds that check to the workflow.

## Make it yours

- **Claude Rules** (`Playbook/Claude Rules.md`) is your global `CLAUDE.md`. Rule 1 ("partner, not a yes-man") makes Claude push back instead of agreeing with everything. Keep it, tune it, or add your own rules.
- **Add workflows** for work you repeat (UI screens, blog posts, releases) from `_templates/Workflow.md`.
- **Back up your vault.** It's your notes, not this repo. Make it its own private git repo, or use Obsidian Sync or iCloud.
- **Optional plugins** worth a look later: [Dataview](https://github.com/blacksmithgu/obsidian-dataview) (query notes like a database), [Smart Connections](https://github.com/brianpetro/obsidian-smart-connections) (semantic search), [Excalidraw](https://github.com/zsviczian/obsidian-excalidraw-plugin) (diagrams). Start without them.

## Updating

```bash
cd ~/Developer/claude-brain-starter && git pull && ./install.sh --update
```

This refreshes the slash commands and plugins. It never touches your notes. If the starter's `Playbook` or `Workflows` change, ask Claude: *"compare my Playbook with the one in ~/Developer/claude-brain-starter/vault and merge anything new."*
