# ADR-001 — PostgreSQL as main database

## Context

The system needs:

- strong transactions
- relational queries
- reporting
- inventory consistency

MongoDB was evaluated but does not provide the same relational guarantees.

## Decision

Use PostgreSQL as the main database.

## Consequences

Pros:

- strong transactional guarantees
- mature ecosystem
- powerful queries

Cons:

- less flexible schema
- migrations required
