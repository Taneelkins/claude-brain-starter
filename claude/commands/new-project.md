---
description: Add a new project to the Claude Brain (folder note, Gotchas, Plans, root table)
---

Add a project to my Claude Brain at `{{VAULT}}/`. Project: $ARGUMENTS (if blank, ask me its name, what it is, and where the code lives).

1. Read `Playbook/Playbook.md` (Structure Law) and the templates in `_templates/`.
2. Check the project name isn't already used by any note in the vault.
3. If I gave a code folder, look at it briefly (README, package/manifest file, top-level folders, how to run and test) so the folder note's **Claude wiring** line and **Code map** are real. Don't read generated folders.
4. Create:
   - `<Project>/<Project>.md` from `_templates/Project.md` (tag `#<ProjectNoSpaces>`)
   - `<Project>/<Project> Gotchas.md` from `_templates/Gotchas.md` (empty sections are fine)
   - `Plans/<Project> Plans.md` from `_templates/Plans.md`, with whatever I said I want to do next
5. Add a row to the **Projects** table in `Claude Brain.md` and to the table in `Plans/Plans.md`.
6. If `Example Game` still exists, ask whether to delete it (its folder + `Plans/Example Game Plans.md` + its table rows).

Finish with a one-line summary of what you created.
