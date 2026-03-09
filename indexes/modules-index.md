# Modules Index

This index provides a quick overview of the current modules defined in the project.

Use this file to quickly navigate the system domain and understand which modules already exist.

---

# Active Modules

## auth

**Purpose:** authentication and account access
**Docs:** `docs/modules/auth.md`
**Spec:** `specs/modules/auth/module.json`
**Context:** `context/modules/auth/auth.context.md`

Typical responsibilities:

- login
- logout
- current profile
- verify email
- reset password

# Recommended Reading Order

For new contributors, a useful reading sequence is:

1. `docs/architecture/architecture.md`
2. `context/core/architecture-summary.md`
3. `indexes/architecture-index.md` (foundation & infrastructure)
4. `docs/conventions/...`
5. `indexes/modules-index.md`
6. the specific module you want to modify

---

# Notes

- Add new modules here when they become part of the system.
- If a module is experimental, make that explicit.
- Keep names consistent with folder names, spec names, and code module names.

---

# Related

- **Architecture & Foundation:** See `indexes/architecture-index.md` for infrastructure components like frontend-foundation that all modules build upon.
