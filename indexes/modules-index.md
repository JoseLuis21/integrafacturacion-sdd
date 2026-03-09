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

## frontend-foundation

**Purpose:** frontend base infrastructure (routes, layout, api client, stores, shared components)
**Docs:** `docs/modules/frontend-foundation.md`
**Context:** `context/core/frontend-structure.md`

Typical responsibilities:

- route groups (landing, auth, dashboard)
- app shell (sidebar, topbar, user menu, breadcrumbs)
- API client with typed responses
- Zustand stores (auth, ui)
- shared components (DataTable, EmptyState, ConfirmDialog, etc.)
- route protection middleware
- module structure convention

---

# Recommended Reading Order

For new contributors, a useful reading sequence is:

1. `docs/architecture.md`
2. `context/core/architecture-summary.md`
3. `docs/conventions/...`
4. `indexes/modules-index.md`
5. the specific module you want to modify

---

# Notes

- Add new modules here when they become part of the system.
- If a module is experimental, make that explicit.
- Keep names consistent with folder names, spec names, and code module names.
