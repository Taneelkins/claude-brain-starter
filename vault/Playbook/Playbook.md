#ClaudeBrain #Playbook

# 🎛️ Playbook

> The rules that keep this brain cheap to read and hard to rot. Read at session start. Back to [[Claude Brain]]

%% Waypoint %%

## Notes
- [[Claude Rules]]: the global rules Claude loads in every session (`~/.claude/CLAUDE.md` is a symlink to it). Edit them here.

---

## 📐 Structure Law
Every time anything is added, it conforms, or it gets reorganized:
1. **Every folder has a folder note** named exactly like the folder (`Foo/Foo.md`). Nothing sits loose.
2. **Tags = membership, never type.** First line is `#<Project> #<ParentFolder>` (e.g. `#MyApp #Plans`). A project root note gets just `#<Project>`. Never a shared tag like `#FolderNote`: it links the whole graph into a hairball.
3. **Every folder note uses the same shape** (see `_templates/Project.md`): tags, title, one-line purpose with a `Back to` link, the `%% Waypoint %%` flag, then a `## Notes` list of one-line pointers.
4. **Pointers, not dumps.** Say where something is and why you'd read it. Never paste source code.
5. **Condensed, not sprawling.** Make a subfolder only when a list gets long (~8+). No empty or single-note folders.
6. **Two levels by default:** root → project → note. Go deeper only when a project genuinely needs it.
7. **Note names are unique across the vault.** `[[Links]]` break silently when two notes share a name. Prefix with the project: `MyApp Gotchas`, not `Gotchas`.
8. **One link up per note.** Each note's `Back to` line links to exactly one parent. Only project roots, [[Plans]] and [[Playbook]] link [[Claude Brain]]. Links down come free from Waypoint.

> **Waypoint:** the `%% Waypoint %%` line (capital W, exactly) gets replaced with an auto-generated list of the folder's notes. If you see the bare flag in a folder note, Waypoint isn't running. The hand-written `## Notes` list stays anyway: Waypoint says *what* exists, your list says *when to read it*.

## 🏭 Working conventions
1. **One home per fact.** Other notes link to it; they never copy it.
2. **Routing notes route.** Folder notes and workflows stay under ~80 lines. Long material goes in a leaf note that gets read by section.
3. **Load sections, not whole notes.** Long Gotchas and Logs are read only in the sections the task touches.
4. **Learn from references, not from earlier outputs**, so a weak first draft never becomes the standard.
5. **Audit before showing.** Every workflow has a pass/fail checklist that runs before you see anything.
6. **Every output is a saved, editable file** in the project's `Work/` folder. The scratchpad is only for throwaway files.
7. **A step is done when you say so**, not when the last chat's status note says so.
8. **Detailed live pass before showing:** test the real thing, every page the change touches, every safe button, scroll to the end of every list, read the console. Guessed data is labelled "Unverified" with the reason.

## 🎚️ Phase → Model
Claude flags the switch; you change it in the model picker.

| Phase | Model |
|---|---|
| Planning, architecture, nasty debugging | **Opus** |
| Normal implementation | **Sonnet** |
| Bulk edits, search, mechanical batches | **Haiku** |

## ⚡ Commands
- **`/brain`**: where am I? Top "what's next" per project, then asks what to work on.
- **`/save`**: write this session's facts, gotchas and plan changes back into the brain. **The brain does not auto-update; this is how knowledge gets in.**
- **`/brain-audit <project>`**: check a project's notes against reality. Flags stale facts, dead paths and broken links; stamps `verified:` dates.
- **`/new-game <name>`**: copy the Roblox framework into `~/Developer/<name>`, install everything, and add the game to the brain.
- **`/new-project <name>`**: same brain setup for anything that isn't a Roblox game.

## 🧭 "What's next"
Read [[Plans]] first, then the project's plans note. Each entry's **Read for scope** pointers say exactly what to load before acting.

## 🧹 Session hygiene
- **One task per chat.** Finish, `/save`, start a fresh chat. Long chats get compacted and Claude starts forgetting rules.
- **Context budget:** a fresh chat costs ~60–140k tokens just loading notes, so don't restart for nothing; but every turn re-reads the whole chat. Hand off at the next stage break once a chat passes ~300k, never past ~500k (quality drops). The context guard hook ([[Running Many Chats]]) reminds Claude.
- **Big project = manager chat + job chats** ([[Big Project]]). One chat per system or asset: two chats on the same thing build it twice and collide.
- **Read big notes by section:** grep the headings, then read only the range you need. Never load a whole long Gotchas or Log note.
- **Restarting the Claude app kills background work** (watchers, scheduled wake-ups). After a restart, nudge any chat that was waiting.
- **Save after each chunk**, not just at the end. Saving is manual on purpose: you review what goes in. Claude nudges you.
- **Freshness:** a stale note is worse than none, because Claude acts on it confidently. When a note is checked against real code, stamp `> verified: <date>` under its purpose line. Run `/brain-audit` now and then.
- **Brain vs memory:** Claude's own memory (`~/.claude/projects/.../memory`) is for *how Claude should behave*. Project facts go in the brain.
