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

## company

**Purpose:** company onboarding, Chilean tax profile, and tenant schema provisioning
**Docs:** `docs/modules/company.md`
**Spec:** `specs/modules/company/module.json`
**Context:** `context/modules/company/company.context.md`

Typical responsibilities:

- create company
- manage legal and tax profile
- manage branches
- provision tenant schema

## user

**Purpose:** user administration and company membership management
**Docs:** `docs/modules/user.md`
**Spec:** `specs/modules/user/module.json`
**Context:** `context/modules/user/user.context.md`

Typical responsibilities:

- create or invite users
- manage user status
- manage company memberships

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
