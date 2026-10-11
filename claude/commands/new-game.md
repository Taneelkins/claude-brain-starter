---
description: Start a new Roblox game from the starter framework and add it to the Claude Brain
---

Start a new Roblox game. Name / details: $ARGUMENTS (if blank, ask me the game's name and a one-line pitch).

1. Read `{{VAULT}}/Roblox/Roblox Framework.md` and `{{VAULT}}/Playbook/Playbook.md`.
2. Pick the folder: `~/Developer/<kebab-name>` (never under `~/Documents`). Stop if it already exists.
3. `cp -R "{{REPO}}/roblox-template" <folder>`, then run `<folder>/setup.sh` (needs Rokit; if it's missing, give me the link https://github.com/rojo-rbx/rokit and stop). Then `git init` + first commit.
4. Add the game to the brain like `/new-project` does: `<Game>/<Game>.md` from `_templates/Project.md` with the **Claude wiring** line filled in (code folder, `rojo serve`, `selene src`, `Work/` folder, PlaceId once I have one) and the template's code map; `<Game> Gotchas.md`; `Plans/<Game> Plans.md` with my first goals; rows in `Claude Brain.md` and `Plans/Plans.md`.
5. Add an empty section for the game to `Art Direction/Style Bible.md` and ask me 3 quick questions to fill it (vibe in one line, 3 reference games, blocky or realistic).
6. If `Example Game` still exists, ask whether to delete it (folder, its plans note, table rows).
7. Tell me the next steps in 3 lines: `rojo serve` in the folder → open a new place in Studio → Rojo plugin Connect → Play.
