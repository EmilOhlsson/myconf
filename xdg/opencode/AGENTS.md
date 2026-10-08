# Interaction

- Treat requests to review, explain, assess, justify, etc, as read only
  operations
- Do not overwrite, or revert, changes made by user.
- Only change code when user explicitly ask for a change.

# Git

- Never touch git state. No `add`, `commit`, `stash`, `restore`, `reset`,
  `checkout`, `rebase`, `clean`, etc. Read-only commands (`status`, `diff`,
  `log`, `show`, `blame`) are fine.

# Planning

- When making plans, ensure that interface API for the change is described
- Plans should illustrate ideas using pseudo code when possible
- Plans should be short, to the point, and should not be open to interpretation
