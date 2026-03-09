# ADR-002 — Multi-Tenant Strategy

## Context

The system is designed as a SaaS platform where multiple companies (tenants) use the same application.

The platform must ensure:

- logical isolation between tenants
- strong data integrity
- scalability for many tenants
- operational simplicity

ERP-style systems also require:

- transactional consistency
- reporting queries across many tables
- predictable performance

Several strategies were evaluated:

1. Single database with tenant_id column
2. Separate database per tenant
3. Shared control database + tenant schemas

## Decision

Use a **control database + tenant schemas strategy**.

Two layers will exist:

### Control Layer

Stores global platform data such as:

- users
- companies
- company_users
- roles
- permissions
- authentication tokens
- API keys

### Tenant Layer

Operational data is stored per tenant scope such as:

- customers
- suppliers
- products
- purchases
- sales
- inventory
- payments
- DTE data

Isolation is handled logically using tenant scoping.

## Consequences

### Pros

- simpler infrastructure than database-per-tenant
- good relational performance
- easier cross-tenant management for the platform
- easier migrations
- supports large ERP-style queries

### Cons

- application must always enforce tenant boundaries
- incorrect queries could leak data if not validated