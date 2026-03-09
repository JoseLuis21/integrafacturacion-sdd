# Context Index

This index explains which context files should be loaded for typical AI-assisted development tasks.

The goal is to avoid loading too much irrelevant context.

---

# Core Context Files

These files are useful in most coding sessions:

- `context/core/architecture-summary.md`
- `context/core/coding-rules.md`
- `context/core/naming-rules.md`
- `context/core/ai-workflow.md`
- `context/core/frontend-structure.md`

---

# Task-Based Context Loading

## Create a new module

Load:

- core context files
- `docs/modules/<module>.md`
- `specs/modules/<module>/module.json`

Optional:

- one or two nearby dependency modules if needed

---

## Generate backend code for an existing module

Load:

- core context files
- `context/modules/<module>.context.md`
- `docs/modules/<module>.md`
- `specs/modules/<module>/module.json`

---

## Generate frontend code for an existing module

Load:

- core context files
- `context/modules/<module>.context.md`
- `docs/modules/<module>.md`
- `specs/modules/<module>/module.json`

---

## Implement a change on an existing module

Load:

- core context files
- `context/modules/<module>.context.md`
- `docs/modules/<module>.md`
- `specs/modules/<module>/module.json`
- `docs/changes/<change>.md`
- `specs/modules/<module>/changes/<change>.json`

---

## Implement logic involving multiple modules

Load:

- core context files
- involved module contexts
- involved module specs

Example:
sale + inventory

- `context/modules/sale.context.md`
- `context/modules/inventory.context.md`

---

## Review or validate a module spec

Load:

- `docs/modules/<module>.md`
- relevant template if needed
- optionally `context/core/naming-rules.md`

---

## Convert spec to JSON

Load:

- `docs/modules/<module>.md`
- `templates/module-json-template.json`
- core naming rules if useful

---

## Review change impact

Load:

- core context files
- module context
- module base spec
- change spec
- nearby dependencies if affected

---

# Recommended Minimal Context Rule

Use:

- core context
- current module
- only nearby dependencies

Avoid loading:

- unrelated modules
- the entire project
- all changes
- all ADRs unless directly relevant

---

# Prompt Packs

Useful reusable prompt files:

- `context/prompts/master-prompt.md`
- `context/prompts/backend-module-prompt.md`
- `context/prompts/frontend-module-prompt.md`
- `context/prompts/change-implementation-prompt.md`

---

# Notes

- Keep module context files short and focused.
- If a module context becomes too large, split details into docs and keep context concise.
- Add new common task recipes here when the project evolves.
