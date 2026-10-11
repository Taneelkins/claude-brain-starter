---
description: Audit a project's brain notes against reality — flag stale facts + broken pointers
---

Audit the Claude Brain at `{{VAULT}}/` for **staleness**. Target: $ARGUMENTS (a project name; if blank, ask which project, or offer to sweep the whole brain).

1. Read the target's folder note, its other notes' headings, and its `Plans/<Project> Plans.md`.
2. For every concrete pointer (file paths, commands, function names, `Read for scope` links), **check it against reality**:
   - Does the file or path still exist?
   - Do the referenced functions/commands still exist and do what the note claims? (spot-check where cheap)
   - Do `[[links]]` point at notes that exist?
   - Is anything documented as current actually dead (code nothing calls any more, a replaced system)?
3. Report a tight list:
   - ✅ **verified**: still accurate
   - ⚠️ **stale**: note says X, reality is Y
   - ❌ **broken**: file / note / link is gone
4. On each note you confirmed accurate, add or refresh a `> verified: <today's date>` line under its purpose line.
5. **Do NOT auto-fix** the stale or broken items. List them and ask which to fix.
