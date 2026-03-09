# Recommended AI Skills

Skills are reusable prompts or workflows that automate repetitive tasks in the SDD process.

---

# Spec Review Skill

Purpose:

Analyze a module specification and detect:

- missing business rules
- ambiguous behavior
- inconsistent naming
- missing entities
- missing use cases

Output:

- suggested improvements
- missing rules
- architecture concerns

---

# Spec → JSON Skill

Purpose:

Convert a human module spec into a structured JSON spec.

Input:

docs/modules/<module>.md

Output:

specs/modules/<module>/module.json

---

# Boilerplate Suggestion Skill

Purpose:

Analyze a module JSON spec and suggest:

- required use cases
- DTOs
- routes
- repositories
- services
- frontend pages

---

# Code Review Skill

Purpose:

Review generated code to detect:

- architecture violations
- domain logic inside handlers
- inconsistent naming
- missing validations

---

# Change Impact Skill

Purpose:

Analyze a change spec and determine:

- impacted modules
- impacted endpoints
- required database changes
- required frontend updates
