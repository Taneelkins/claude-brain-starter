#Workflows

# 🐛 Bug Fix

> Fixing something broken without breaking anything else. Shape: **Loop**. Back to [[Workflows]]

## Inputs
| Load | From | Scope |
|---|---|---|
| Known traps | project Gotchas | sections that match the symptom |
| Where the code lives | project folder note → Code map | the rows involved |

## Loop
1. **Reproduce.** Get the exact error or behaviour. Check Gotchas first; it may be known.
2. **Find the cause.** Re-read the current code fresh. If the bug comes from a check or guard, **say what rule it protects** before touching it.
3. **Fix with the smallest change** that makes it correct, keeping that rule.
4. **Verify:** reproduce again and show it passes. Then check the nearest thing the fix could break.
5. **Close:** if the trap could bite again, add one line to the project's Gotchas at `/save`.

**Checkpoint:** if the right fix needs more than a few lines, or changes behaviour users would notice, describe it and ask first.

## Audit
- [ ] Minimal diff: only the broken lines changed.
- [ ] The intent of any guard or check is kept, not deleted.
- [ ] Reproduced before, verified after, and the verification is named.
- [ ] No debug prints or probe files left behind.
- [ ] If the root cause is still unknown, say so; don't sell a symptom patch as the fix.
