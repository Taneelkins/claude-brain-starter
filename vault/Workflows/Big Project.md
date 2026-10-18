#Workflows

# 🗂️ Big Project

> Running a big change as one manager chat plus a job chat per piece. The job chats show up nested under the manager in the Claude app's sidebar. Shape: **Pipeline**. Back to [[Workflows]]

## When
Anything bigger than one chat can hold: a revamp, a new mode, a new game. One system or asset fits in one chat, so it doesn't need this.

## Inputs
| Load | From | Scope |
|---|---|---|
| The design | [[Game Design]] stages 01–04, done in the manager chat | full |
| Running chats side by side | [[Running Many Chats]] | full |
| The project | project folder note + Plans | full |

## Stages (outputs in `Work/<date> <project>/`)
1. **01–03 Design** in the manager chat: problem → options → decision ([[Game Design]]).
2. **04 Plan:** a plan page with **numbered jobs**: `0.x` setup, audits and stress tests · `1.x` core systems · `2.x` features · `3.x` content. Each job has one line: what done looks like, which jobs it waits on, which files/systems it owns. **Checkpoint:** plan OK'd.
3. **Jobs:** for each job whose prerequisites are met, the manager:
   - writes `Work/<date> <project>/<N.N> <Job>/opener.md`: scope (and what NOT to touch), the notes and files to read (sections only), the approved decisions, done criteria, test steps, and the Chain footer below;
   - starts the chat itself (in the Claude app: a new session with the opener as its prompt, so it nests under the manager) and **sets its model and effort at creation**:
     | Job | Model · effort |
     |---|---|
     | New core system others build on | Opus · high |
     | Big build on an agreed design, 3D asset production | Opus · medium |
     | Ports, content on a clear spec, measured bug fixes | Sonnet · high |
     | Uploads, wiring ids, routine checks, wrap-ups | Sonnet · medium |
   - files it in the project's sidebar group and gives the person its link.
4. **Close:** when every job is done, the manager updates the plan page, runs `/save`, and archives finished job chats (only after checking each one saved).

## Rules
- **3–4 job chats at once, max.** Watch the usage limit.
- **Never two chats on the same files or system.** Jobs that share a system run one after another; the plan names each job's owned files.
- **The manager plans, it doesn't build.** It doesn't relay messages between job chats or re-explain what a job already showed; the person reads each job's own report page.
- A job is done when the person says so, not when its status file says so.

## Chain footer (paste at the end of every opener)
```
## Chain
Stay inside this job's scope; no extra systems. Report on your own page at each checkpoint: result + what the person must do + links. When the job is done: /save and check the notes landed on disk. If this opener names a next job and its prerequisites are met, write its opener and start it yourself (same model rules), then say so in one line with its link. If not, say exactly what's missing. Long chat (~300k)? /save, write a continuation opener in this folder and start it the same way.
```

## Audit
- [ ] Every job has done criteria, owned files and its waits-on list; no two running jobs own the same file.
- [ ] Each opener stands alone: a fresh chat with only the opener can do the job.
- [ ] Model and effort set at creation, matched to the table.
- [ ] Before archiving a chat: its report names the brain notes it changed, AND those notes are on disk. If not, ask it to `/save` first.
