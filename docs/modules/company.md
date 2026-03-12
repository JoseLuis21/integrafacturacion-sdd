# Module: Company

## Purpose

The `company` module is responsible for company onboarding and company master data.

In this system, a company is also the tenant boundary used to provision a dedicated PostgreSQL schema for operational data.

This module owns the company creation flow, the Chilean tax profile required for future DTE usage, and the provisioning state of the tenant schema.

---

# Scope

This module includes:

- company creation
- company listing and detail
- company legal and tax profile update
- activation and suspension of company access
- default branch and branch management
- tenant schema provisioning state
- retry of tenant bootstrap when provisioning fails

This module does **not** include:

- user authentication
- role and permission administration
- certificate management
- CAF/folios management
- DTE issuance or DTE lifecycle
- operational master data such as customers, products, or inventory

---

# Canonical Naming

Use `company` as the canonical module name.

Reasons:

- the repository already uses `company_id`
- the auth module already uses `company_users`
- `company` is clearer and more consistent than mixing `business` and `company`

---

# Actors

- Platform Admin
- Company Owner
- Company Admin
- Authenticated User with company membership
- System Provisioner

---

# Main Entities

## Company

Represents the legal and operational identity of a tenant company.

Typical fields:

- id
- tenant_code
- tenant_schema
- rut
- rut_normalized
- legal_name
- trade_name
- status
- onboarding_status
- primary_giro
- sii_environment
- sii_resolution_number
- sii_resolution_date
- dte_email
- contact_email
- billing_email
- phone
- website
- logo_url
- default_currency
- locale
- timezone
- created_by_user_id
- activated_at
- suspended_at
- created_at
- updated_at

Notes:

- `legal_name` maps to Chilean `razon social`
- `trade_name` maps to Chilean `nombre de fantasia`
- `primary_giro` represents the public giro used for tax and DTE issuer profile

---

## CompanyBranch

Represents the main branch or a secondary branch/sucursal of the company.

Typical fields:

- id
- company_id
- branch_name
- branch_type
- sii_branch_code
- is_default
- status
- email
- phone
- street
- street_number
- address_line2
- commune_code
- commune_name
- city
- region_code
- region_name
- country_code
- postal_code
- created_at
- updated_at

Notes:

- the first branch is usually the main branch / casa matriz
- `sii_branch_code` is optional during onboarding but should be available when the branch is used for DTE issuing

---

## CompanyEconomicActivity

Represents an ACTECO / SII economic activity assigned to the company.

Typical fields:

- id
- company_id
- sii_activity_code
- activity_name
- is_primary
- created_at

Notes:

- a company must have at least one activity
- exactly one activity must be marked as primary

---

## CompanyTenantProvisioning

Represents the lifecycle of the tenant schema bootstrap for a company.

Typical fields:

- company_id
- tenant_schema
- provisioning_status
- bootstrap_version
- requested_by_user_id
- started_at
- finished_at
- last_error_code
- last_error_message
- created_at
- updated_at

---

# Use Cases

- Create company
- List companies
- List current user companies
- Get company detail
- Update company
- Activate company
- Suspend company
- Get tenant provisioning state
- Retry tenant provisioning
- Create branch
- List branches
- Update branch
- Set default branch

---

# Chile-Specific Profile Requirements

The module should capture the fields normally required to onboard a Chilean company for ERP and DTE workflows.

## Required legal and tax identity

- `rut`
- `legal_name`
- `primary_giro`
- at least one `economic_activity`
- main branch address in Chile

## Recommended enumerations

### sii_environment

- `certification`
- `production`

## Required before production DTE flows

- `sii_environment = production`
- `sii_resolution_number`
- `sii_resolution_date`
- `dte_email`
- active main branch
- tenant provisioning status `ready`

These fields may be optional during initial onboarding, but they should be mandatory before the company is considered DTE-ready.

---

# Business Rules

- `rut` must be normalized before uniqueness checks.
- `rut_normalized` must be unique in the control database.
- `tenant_code` must be unique and URL-safe.
- `tenant_schema` must be unique and derived from `tenant_code`.
- `tenant_schema` becomes immutable after provisioning status becomes `ready`.
- Company creation requires one main/default branch.
- Company creation requires at least one economic activity.
- Exactly one economic activity must be primary.
- Default branch must belong to the same company.
- Main branch address must use country code `CL`.
- A company in status `suspended` cannot be used for tenant access.
- Tenant access requires:
  - active company status
  - active company membership
  - tenant provisioning status `ready`
- Retrying provisioning is allowed only when status is `failed`.
- Activation should fail if tenant provisioning is not `ready`.
- Suspending a company does not delete its tenant schema.
- Creating a company should also create the owner membership in `company_users`.

---

# Status Model

## Company status

- `onboarding`
- `active`
- `suspended`
- `archived`

## Tenant provisioning status

- `pending`
- `provisioning`
- `ready`
- `failed`

## Branch status

- `active`
- `inactive`

---

# Tenant Schema Provisioning Flow

Suggested flow for `CreateCompanyUseCase`:

1. Validate authenticated actor and permissions.
2. Normalize and validate RUT.
3. Reserve `tenant_code` and `tenant_schema`.
4. Create the company, default branch, activities, and provisioning row in the control database.
5. Create tenant schema: `tenant_<tenant_code>`.
6. Run base tenant migrations in the new schema.
7. Seed tenant-level bootstrap data if needed.
8. Create owner membership in `company_users`.
9. Mark provisioning as `ready` or `failed`.

If provisioning fails:

- keep the company in `onboarding`
- mark provisioning as `failed`
- persist `last_error_code` and `last_error_message`
- allow retry through a protected endpoint

---

# API Endpoints

## POST `/api/v1/companies`

Create a company and start tenant schema provisioning.

### Auth required

Yes. Use `Authorization: Bearer <access-token>`.

### Request

```json
{
  "legalName": "Comercializadora Demo SpA",
  "tradeName": "Demo ERP",
  "rut": "76.123.456-7",
  "primaryGiro": "Actividades de programacion informatica",
  "siiEnvironment": "certification",
  "siiResolutionNumber": null,
  "siiResolutionDate": null,
  "dteEmail": "dte@demo.cl",
  "contactEmail": "contacto@demo.cl",
  "billingEmail": "facturacion@demo.cl",
  "phone": "+56 9 1234 5678",
  "website": "https://demo.cl",
  "requestedTenantCode": "demo",
  "economicActivities": [
    {
      "code": "620100",
      "name": "Actividades de programacion informatica",
      "isPrimary": true
    }
  ],
  "mainBranch": {
    "branchName": "Casa Matriz",
    "branchType": "main",
    "siiBranchCode": "00000",
    "email": "casa.matriz@demo.cl",
    "phone": "+56 2 2234 5678",
    "street": "Avenida Apoquindo",
    "streetNumber": "3000",
    "addressLine2": "Oficina 701",
    "communeCode": "13114",
    "communeName": "Las Condes",
    "city": "Santiago",
    "regionCode": "RM",
    "regionName": "Metropolitana de Santiago",
    "countryCode": "CL",
    "postalCode": "7550000"
  }
}
```

### Response

```json
{
  "success": true,
  "data": {
    "id": "018f....",
    "tenantCode": "demo",
    "tenantSchema": "tenant_demo",
    "status": "onboarding",
    "onboardingStatus": "provisioning",
    "provisioningStatus": "pending"
  }
}
```

---

## GET `/api/v1/companies`

List companies available to the current actor or all companies for privileged actors.

### Filters

- `status`
- `tenantCode`
- `rut`
- `search`

---

## GET `/api/v1/companies/me`

List companies accessible to the current authenticated user.

---

## GET `/api/v1/companies/:id`

Get company detail including legal profile, tax profile, main branch, and economic activities.

---

## PATCH `/api/v1/companies/:id`

Update legal, tax, and contact fields for a company.

Typical updatable fields:

- `tradeName`
- `primaryGiro`
- `siiEnvironment`
- `siiResolutionNumber`
- `siiResolutionDate`
- `dteEmail`
- `contactEmail`
- `billingEmail`
- `phone`
- `website`
- `logoUrl`

Do not allow patching:

- `rut`
- `rutNormalized`
- `tenantCode`
- `tenantSchema`

unless an explicit change spec later allows it.

---

## POST `/api/v1/companies/:id/activate`

Move a company to `active`.

Activation should require:

- valid company profile
- provisioning status `ready`
- at least one active branch

---

## POST `/api/v1/companies/:id/suspend`

Move a company to `suspended`.

Suspension should block tenant access but must not remove tenant data.

---

## GET `/api/v1/companies/:id/tenant-provisioning`

Return current bootstrap state for the tenant schema.

Example response:

```json
{
  "success": true,
  "data": {
    "companyId": "018f....",
    "tenantSchema": "tenant_demo",
    "provisioningStatus": "ready",
    "bootstrapVersion": "v1",
    "startedAt": "2026-03-12T10:00:00Z",
    "finishedAt": "2026-03-12T10:00:06Z"
  }
}
```

---

## POST `/api/v1/companies/:id/retry-tenant-provisioning`

Retry provisioning when the current status is `failed`.

This endpoint should return `202 Accepted` if the retry was queued or started asynchronously.

---

## GET `/api/v1/companies/:id/branches`

List branches for a company.

---

## POST `/api/v1/companies/:id/branches`

Create a new branch/sucursal.

---

## PATCH `/api/v1/companies/:id/branches/:branchId`

Update branch data.

---

## POST `/api/v1/companies/:id/branches/:branchId/set-default`

Set the default branch for the company.

Rules:

- the branch must belong to the company
- only one branch can be default
- default branch should normally remain active

---

# Permissions

Suggested permissions:

- `company.read`
- `company.create`
- `company.update`
- `company.activate`
- `company.suspend`
- `company.branch.read`
- `company.branch.create`
- `company.branch.update`
- `company.tenant.read`
- `company.tenant.retry`

---

# Data Ownership

This module belongs primarily to the **control database**.

Tables typically owned by this module:

- `companies`
- `company_branches`
- `company_economic_activities`
- `company_tenant_provisioning`

Related tables owned by other modules:

- `users` from `auth`
- `company_users` from `auth`

Tenant-side consequence of this module:

- company creation provisions the tenant schema
- tenant operational data is stored later inside that schema

The company record itself should remain the source of truth in the control layer.

---

# Dependencies

The company module depends on:

- auth middleware
- users repository
- company_users repository or application service
- tenant schema provisioner
- embedded SQL migration runner
- RUT validation utility
- Chile communes/regions catalog
- SII economic activity catalog
- audit logger

---

# Security Notes

- Validate membership and permission before exposing company detail.
- Never rely only on `search_path` for authorization.
- Restrict activation, suspension, and provisioning retry.
- Audit provisioning failures and state changes.
- Do not allow arbitrary tenant schema names without normalization and collision checks.

---

# Error Scenarios

Typical errors include:

- invalid RUT
- duplicated RUT
- duplicated tenant code
- duplicated tenant schema
- company not found
- forbidden company access
- invalid company status transition
- default branch missing
- primary activity missing
- provisioning failed
- validation error
- unauthorized session

Suggested stable error codes:

- `INVALID_RUT`
- `RUT_ALREADY_EXISTS`
- `TENANT_CODE_ALREADY_EXISTS`
- `TENANT_SCHEMA_ALREADY_EXISTS`
- `COMPANY_NOT_FOUND`
- `FORBIDDEN`
- `INVALID_COMPANY_STATUS`
- `DEFAULT_BRANCH_REQUIRED`
- `PRIMARY_ACTIVITY_REQUIRED`
- `TENANT_PROVISIONING_FAILED`
- `VALIDATION_ERROR`
- `UNAUTHORIZED`

---

# Frontend Screens

Suggested frontend pages/components:

- companies list page
- my companies switcher
- create company page
- company detail page
- edit company form
- branches tab
- tenant provisioning status card

Suggested reusable UI pieces:

- company form
- tax profile form
- branch form
- branch list
- provisioning status badge
- company status badge

---

# Backend Structure Suggestion

```text
internal/modules/company/
├── domain/
│   ├── company.go
│   ├── branch.go
│   ├── economic_activity.go
│   ├── tenant_provisioning.go
│   ├── repository.go
│   ├── provisioner.go
│   ├── errors.go
│   └── value_objects/
│       ├── rut.go
│       ├── tenant_schema.go
│       └── chilean_address.go
├── application/
│   ├── create_company.go
│   ├── update_company.go
│   ├── get_company.go
│   ├── list_companies.go
│   ├── retry_tenant_provisioning.go
│   ├── create_branch.go
│   └── set_default_branch.go
└── infrastructure/
    ├── persistence/
    ├── http/
    └── provisioner/
```
