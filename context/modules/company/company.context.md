# Company Module Context

## Purpose

Company handles company onboarding, Chilean tax profile setup, and tenant schema provisioning.

It is the canonical module for creating a tenant company in the platform.

## Core Use Cases

- Create company with tenant schema bootstrap
- List companies available to the current user
- Get company detail
- Update company legal and tax profile
- Activate or suspend company access
- Manage branches/sucursales
- Retry tenant provisioning when schema bootstrap fails

## Main Entities

- Company
- CompanyBranch
- CompanyEconomicActivity
- CompanyTenantProvisioning

## Key Rules

- Use `company` as the canonical term across specs, code, and docs.
- Company master data belongs to the control database.
- Each company maps to exactly one tenant schema.
- `rut` must be normalized and validated before persistence.
- `rut_normalized`, `tenant_code`, and `tenant_schema` must be unique.
- `tenant_schema` should follow `tenant_<tenant_code>` and becomes immutable once provisioning is `ready`.
- Company creation requires one main branch and at least one economic activity.
- A company must have exactly one primary economic activity.
- Main branch address must include Chilean location data: commune, city, region, and country `CL`.
- `default_currency` defaults to `CLP`, `locale` to `es-CL`, and `timezone` to `America/Santiago`.
- `sii_resolution_number`, `sii_resolution_date`, and `dte_email` are optional during onboarding but required before enabling production DTE flows.
- Creating a company must also create or request the owner membership in `company_users` through the `user` module.
- Tenant access requires both active company membership and tenant provisioning status `ready`.

## Main Endpoints

- POST /api/v1/companies
- GET /api/v1/companies
- GET /api/v1/companies/me
- GET /api/v1/companies/:id
- PATCH /api/v1/companies/:id
- POST /api/v1/companies/:id/activate
- POST /api/v1/companies/:id/suspend
- GET /api/v1/companies/:id/tenant-provisioning
- POST /api/v1/companies/:id/retry-tenant-provisioning
- GET /api/v1/companies/:id/branches
- POST /api/v1/companies/:id/branches
- PATCH /api/v1/companies/:id/branches/:branchId
- POST /api/v1/companies/:id/branches/:branchId/set-default

## Dependencies

- users
- company_users
- tenant schema provisioner
- embedded SQL migration runner
- RUT validator
- Chile location catalog
- SII economic activity catalog

## Security Notes

- Validate ownership or platform-admin permission before exposing company detail.
- Never trust tenant schema alone; always validate company membership too.
- Restrict activation/suspension and provisioning retry to authorized actors.
- Audit company creation, updates, status changes, and provisioning failures.

## Frontend Implementation

### Module Location

`src/modules/company/` in the frontend repository.

### Suggested Structure

```text
src/modules/company/
├── services/company.service.ts
├── schemas/
│   ├── company.schema.ts
│   ├── branch.schema.ts
│   └── company-status.schema.ts
├── hooks/
│   ├── use-companies.ts
│   ├── use-my-companies.ts
│   ├── use-create-company.ts
│   ├── use-update-company.ts
│   ├── use-company-branches.ts
│   └── use-tenant-provisioning.ts
└── components/
    ├── company-form.tsx
    ├── company-legal-card.tsx
    ├── company-tax-profile-card.tsx
    ├── branch-form.tsx
    ├── branch-list.tsx
    └── provisioning-status-badge.tsx
```

### Suggested Pages

- `src/app/(dashboard)/companies/`
- `src/app/(dashboard)/companies/new/`
- `src/app/(dashboard)/companies/[companyId]/`
- `src/app/(dashboard)/companies/[companyId]/branches/`
