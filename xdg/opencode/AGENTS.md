# Git

- Never touch git state. No `add`, `commit`, `stash`, `restore`, `reset`,
  `checkout`, `rebase`, `clean`, etc. Read-only commands (`status`, `diff`,
  `log`, `show`, `blame`) are fine.
- I stage code to mark it as accepted. Staged code is already reviewed —
  don't rewrite it unless the review discussion calls for it.
- Reread files. I often change files, and I don't want my changes overwritten.

# Questions

- When I question something, explain and justify the code. Don't edit it.
- Only change code when I explicitly ask for a change.

# Planning

- When making plans, ensure that interface API for the change is described
- Plans should illustrate ideas using pseudo code when possible
