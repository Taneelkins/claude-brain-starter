#ExampleProject #Plans

# 📋 Example Project Plans

> Unfinished Example Project work. Finished items get deleted, not ticked. Back to [[Plans]]

---

### Add login rate limiting · `next`
**Goal:** a client gets blocked for 10 minutes after 5 failed logins.
**Read for scope:** [[Example Project]] (Code map → auth), [[Example Project Gotchas]] (Redis section).
**Next step:** add a counter in `src/auth/login.ts` keyed on IP + username; test with 6 bad logins.

### Dark mode · `parked`
**Goal:** respect the system theme. Parked until the design pass.
