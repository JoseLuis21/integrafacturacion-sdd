# ADR-005 — Modular Monolith Architecture

## Context

The system contains many domains:

- authentication
- products
- customers
- inventory
- sales
- purchases
- payments
- DTE integration

A microservices architecture was considered but introduces:

- operational complexity
- distributed transactions
- network latency
- infrastructure overhead

Early-stage SaaS systems benefit from simpler deployments.

## Decision

Start with a **modular monolith** architecture.

The system will:

- run as a single backend service
- organize code by domain modules
- enforce boundaries between modules

Example module structure:

internal/modules/<module>/
- domain
- application
- infrastructure

## Consequences

### Pros

- simpler deployment
- easier debugging
- strong module boundaries
- avoids premature microservices complexity

### Cons

- requires discipline to maintain module isolation
- eventual scaling might require service extraction