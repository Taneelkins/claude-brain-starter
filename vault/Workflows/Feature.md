#Workflows

# ⚙️ Feature

> Building or extending a system. Shape: **Loop**. Back to [[Workflows]]

## Inputs
| Load | From | Scope |
|---|---|---|
| Project wiring + code map | project folder note | full |
| Known traps | project Gotchas | sections that match |
| The plan entry | project Plans note | this item + its Read for scope |

## Loop
1. **Find what exists.** Search the code for the feature's keywords before proposing anything. Report what's already there.
2. **Plan where it lives.** Name the existing module it goes inside and the files it touches.
   - **Checkpoint** (stop, show, wait) if the plan changes existing behaviour, adds a new dependency, or adds a new top-level system.
   - Small, purely additive work inside an agreed plan: go.
3. **Build** inside that module, matching its style and structure.
4. **Verify:** run it / test it, and say exactly what was and wasn't tested.
5. **Close:** commit with a clear message. Nudge `/save`.

## Audit (all must pass before calling it done)
- [ ] Lives inside the existing structure; no duplicate helper next to one that already exists.
- [ ] Matches the project's naming, formatting and comment style.
- [ ] Existing code changed only where needed; no drive-by rewrites.
- [ ] Builds, and the tests that exist still pass.
- [ ] Anything untested is named.
