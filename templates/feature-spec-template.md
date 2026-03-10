# Module: <ModuleName>

## Purpose

Describe the main purpose of the module in one or two clear paragraphs.

Explain what problem it solves and why it exists.

---

# Scope

This module includes:

- <capability 1>
- <capability 2>
- <capability 3>

This module does **not** include:

- <out of scope 1>
- <out of scope 2>
- <out of scope 3>

---

# Actors

- <Actor 1>
- <Actor 2>
- <Actor 3>

---

# Main Entities

## <EntityName>
Describe the entity and its purpose.

Typical fields:
- id
- <field_1>
- <field_2>
- <field_3>

## <SecondaryEntityName>
Describe the entity and its purpose.

Typical fields:
- id
- <field_1>
- <field_2>

---

# Use Cases

- <Use case 1>
- <Use case 2>
- <Use case 3>
- <Use case 4>

Use clear verbs.

Examples:
- Create product
- Update customer
- Login
- Reset password
- Post sale

---

# Business Rules

- <Rule 1>
- <Rule 2>
- <Rule 3>
- <Rule 4>

Rules should be explicit and testable.

Examples:
- SKU must be unique per tenant.
- Blocked users cannot login.
- Draft documents do not affect inventory.
- Password reset tokens must be one-time use.

---

# States (Optional)

If the module has a lifecycle, define it here.

Suggested format:

- `draft`
- `posted`
- `cancelled`

Rules by state:

## <state_name>
- <state rule 1>
- <state rule 2>

---

# API Endpoints

## <METHOD> `<path>`
Describe the endpoint.

### Request
```json
{
  "<field>": "<value>"
}
```

### Response
```json
{
  "success": true,
  "data": {}
}
```

Repeat for all relevant endpoints.

---

# Permissions

List relevant permissions.

Examples:
- `<module>.read`
- `<module>.create`
- `<module>.update`
- `<module>.delete`
- `<module>.post`

If the module has public endpoints, say so explicitly.

---

# Data Ownership

Explain where the module belongs.

Examples:
- control database
- tenant schema
- tenant operational data

List typical tables:
- `<table_1>`
- `<table_2>`
- `<table_3>`

---

# Dependencies

List nearby dependencies.

Examples:
- customer
- product
- inventory
- folio
- dte
- mailer
- token provider

Only list real dependencies.

---

# Security Notes (Optional)

Include security rules if relevant.

Examples:
- Never store raw passwords.
- Apply rate limiting to login.
- Validate ownership before access.
- Do not leak sensitive account existence details.

---

# Error Scenarios

List important errors.

Examples:
- not found
- validation error
- insufficient stock
- invalid credentials
- expired token

Suggested stable codes:
- `VALIDATION_ERROR`
- `RESOURCE_NOT_FOUND`
- `CONFLICT`
- `INSUFFICIENT_STOCK`
- `INVALID_CREDENTIALS`

---

# Frontend Screens

List expected screens/components.

Examples:
- list page
- create page
- detail page
- edit form
- modal
- dashboard widget

---

# Local Runtime / Dev Environment (Optional)

Use this section when the module or scaffold is expected to run locally.

- runtime container required: <yes/no>
- runnable apps or services: <service/app names>
- local dependencies for `compose.yaml`: <postgres, redis, mailhog, etc.>
- expected local start command: `docker compose up`
- justified exception if Docker is intentionally omitted: <reason>

---

# Backend Structure Suggestion

```text
internal/modules/<module>/
├── domain/
├── application/
└── infrastructure/
```

Add module-specific expectations if needed.

---

# Frontend Structure Suggestion

```text
src/modules/<module>/
├── components/
├── hooks/
├── services/
├── schemas/
├── types/
└── pages/
```

---

# Testing Guidelines

List key test cases.

## Backend
- <test case 1>
- <test case 2>
- <test case 3>

## Frontend
- <test case 1>
- <test case 2>
- <test case 3>

---

# Future Changes

List likely future extensions if helpful.

Examples:
- Google OAuth
- MFA
- discounts
- reservations
- approval workflow

These should usually be added through **change specs**.
