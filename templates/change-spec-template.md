# Change: <ChangeName>

## Affected Module

<module>

---

## Purpose

Describe the purpose of this change.

Explain what new capability is being added or what behavior is changing.

---

## Why This Change Exists

Explain the business or product reason for the change.

Examples:
- users need social login
- sales now require discount rules
- inventory now needs reservations
- customers want approval workflows

---

## New Use Cases

- <New use case 1>
- <New use case 2>
- <New use case 3>

Use clear verbs.

Examples:
- Login with Google
- Link Google account
- Reserve stock
- Apply discount rule

---

## Impacted Existing Use Cases

List current behaviors that may be affected.

- <existing use case 1>
- <existing use case 2>

Example:
- Login
- Get current profile
- Post sale

---

## Business Rules

- <Rule 1>
- <Rule 2>
- <Rule 3>

Examples:
- Existing users should be linked by normalized email.
- Blocked users cannot use the new login flow.
- Reservation reduces available stock but not on-hand stock.

---

## New Data Required

Describe new tables, fields, or providers if needed.

### New tables
- <table_1>
- <table_2>

### New fields
- <field_1>
- <field_2>

### New providers/integrations
- <provider_1>
- <provider_2>

---

## API Changes

List new or modified endpoints.

- <METHOD> <path>
- <METHOD> <path>

Examples:
- GET /api/v1/auth/google/start
- GET /api/v1/auth/google/callback
- POST /api/v1/inventory/reservations

---

## UI Changes

Describe frontend impact.

Examples:
- add button
- add callback page
- add new tab in settings
- add new form fields

---

## Backend Impact

List impacted backend areas.

Examples:
- auth module
- new provider adapter
- repository changes
- new use cases
- route changes

---

## Frontend Impact

List impacted frontend areas.

Examples:
- login page
- profile page
- product detail page
- sales form

---

## Security Notes (Optional)

If relevant, define security constraints.

Examples:
- validate OAuth state
- do not trust unverified provider email
- validate ownership before reservation release

---

## Migration / Data Considerations

If relevant, define data migration or compatibility notes.

Examples:
- backfill existing rows
- default new field value
- preserve legacy behavior during rollout

---

## Compatibility Risks

List risks this change introduces.

Examples:
- changes current login flow
- adds new status transition
- modifies route behavior
- affects old mobile clients

---

## Testing

List required tests.

- <test case 1>
- <test case 2>
- <test case 3>

Examples:
- should reject invalid callback state
- should reserve stock when rule applies
- should preserve previous password login flow

---

## Consolidation Plan

Explain how the change will be merged into the main module spec once accepted.

Example:
- implement change
- validate behavior
- update `docs/modules/<module>.md`
- update `specs/modules/<module>/module.json`
