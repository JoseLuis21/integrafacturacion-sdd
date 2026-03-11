# ADR-009 — Shared Postman collection and local API testing artifacts

## Context

The repository defines module specs and HTTP endpoints, but it did not define how API testing artifacts should be generated and maintained.

Without a contract, generated projects may create:

- one collection per module
- ad hoc local environments
- missing token capture scripts
- endpoints with no ready-to-run examples

That weakens repeatability and slows manual validation.

## Decision

Use a shared Postman contract for backend APIs.

Rules:

- keep one base project collection in `postman/base.postman_collection.json`
- keep one local environment in `postman/local.postman_environment.json`
- group requests by module inside the shared collection
- every exposed endpoint should have at least one request example and one response example in the module spec
- local environment variables must include `baseUrl`, `accessToken`, `refreshToken`, `userId`, `companyId`, and `resourceId`
- authentication requests should include a standard test script to capture `accessToken` and related identifiers when present

If a project later needs generated module-specific exports, they should still derive from the shared collection structure.

## Consequences

### Pros

- consistent API validation workflow
- easier onboarding for manual testers and developers
- stable generation targets for AI and scaffolding tools
- examples stay close to the module contract

### Cons

- shared collection ownership requires coordination
- some endpoints need custom scripts beyond the default auth capture flow
