# Framework SDD - Specification Driven Development

This repository is the **design source of truth** and the central hub for **Specification Driven Development (SDD)**.

It provides a structured, AI-first approach to building scalable, modular systems with clear specifications before implementation.

---

# Purpose

This repository centralizes all design decisions, specifications, and context needed to build features with AI assistance and ensure consistency across projects.

It serves as the single source of truth for:

- architecture & design decisions (ADRs)
- feature specifications (markdown + JSON)
- change specifications
- domain models & entities
- coding & naming conventions
- AI context & reusable prompts
- specification templates
- navigation indexes

**This is not a runtime code repository.** The specifications here guide implementation in separate, language-specific codebases.

---

# Core Principle: Specs First

The SDD workflow follows this flow:

```
idea
  ↓
feature spec (.md + .json)
  ↓
domain model & rules
  ↓
AI-assisted implementation
  ↓
testing & validation
  ↓
code generation (optional)
```

**Key principle:** The specification is the source of truth, not the generated code.

This ensures:

- Clear requirements before coding
- Consistency across implementations
- AI can reference specs for context
- Easy to regenerate or port code

# Framework Structure

```
framework-sdd/
├── README.md                        # This file
├── docs/                            # Human-readable documentation
│   ├── architecture/                # Architecture diagrams & docs
│   ├── adr/                         # Architecture Decision Records
│   ├── conventions/                 # Coding & naming conventions
│   ├── glossary/                    # Domain terminology
│   ├── modules/                     # Module documentation
│   ├── structure/                   # Backend & frontend structure suggestions
│   └── tooling/                     # AI tools & workflows
├── specs/                           # Machine-readable specifications
│   ├── modules/                     # Module definitions
│   │   ├── auth/
│   │   │   ├── module.json
│   │   │   └── changes/
│   │   ├── product/
│   │   └── ...
│   └── shared/                      # Shared types, enums, permissions
├── context/                         # AI-optimized context files
│   ├── core/                        # Core rules & guidelines
│   │   ├── architecture-summary.md
│   │   ├── ai-workflow.md
│   │   ├── coding-rules.md
│   │   ├── naming-rules.md
│   │   ├── environment-rules.md
│   │   └── repository-structure.md
│   ├── modules/                     # Module-specific context
│   └── prompts/                     # Reusable AI prompts
├── templates/                       # Specification templates
│   ├── feature-spec-template.md
│   ├── change-spec-template.md
│   ├── module-json-template.json
│   ├── change-json-template.json
│   └── env/                         # Environment variable templates
│       └── backend.env.example
└── indexes/                         # Navigation & discovery
    ├── modules-index.md
    ├── context-index.md
    └── adr-index.md
```

---

# Folder Overview

## `docs/`

Human-readable project knowledge.

Includes:

- architecture
- ADRs
- conventions
- glossary
- domain descriptions
- flow descriptions
- module specs
- change specs

## `specs/`

Machine-readable definitions used for generation.

Includes:

- module JSON specs
- change JSON specs
- shared enums/types/permissions

## `context/`

Short context files optimized for AI prompts.

### `context/core/`

Core rules and guidelines:

- `architecture-summary.md` — Project architecture, stacks, and folder structure
- `ai-workflow.md` — AI-assisted development workflow
- `coding-rules.md` — Code quality & best practices
- `naming-rules.md` — Naming conventions
- `environment-rules.md` — Environment variables & secrets configuration
- `repository-structure.md` — Backend repository structure

### `context/modules/`

Module-specific context files for AI prompts.

### `context/prompts/`

Reusable AI prompts for different tasks (backend, frontend, feature implementation).

## `templates/`

Reusable templates for:

### Specifications
- `feature-spec-template.md` — Feature specification template
- `change-spec-template.md` — Change specification template
- `module-json-template.json` — Module structure template
- `change-json-template.json` — Change structure template

### Environment
- `env/backend.env.example` — Backend environment variables template

## `indexes/`

Fast navigation and discovery files:

- `modules-index.md` — Index of all modules
- `context-index.md` — Guide to context files
- `adr-index.md` — Index of Architecture Decision Records

## `docs/structure/`

Backend and frontend code structure suggestions:

- `backend-structure.md` — Recommended backend folder layout (hexagonal architecture)
- Frontend structure (as needed)

## `docs/tooling/`

AI tooling configuration and workflows.

Includes:

- **ai-stack.md** — Recommended AI tools for SDD (Claude, GPT, Cursor)
- **mcps.md** — Model Context Protocol integrations (Filesystem, GitHub, Postgres, HTTP)
- **skills.md** — Reusable AI workflows (spec review, spec-to-JSON, boilerplate suggestions, code review, change impact analysis)

---

# Working with SDD Framework

## Define a New Module

1. **Human spec**: Write `docs/modules/<module>.md`
2. **Structured spec**: Create `specs/modules/<module>/module.json`
3. **AI context**: Create `context/modules/<module>.context.md`
4. **Architecture**: Document the module's domain model, use cases, and integration points

## Document a Feature Change

1. **Feature spec**: Write `docs/changes/<feature>.md` (acceptance criteria, flows)
2. **Structured change**: Create `specs/modules/<module>/changes/<feature>.json`
3. **Implementation**: Build the feature with the spec as reference
4. **Consolidate**: Update the module spec once the feature stabilizes

## Add Architecture Decisions

1. Write the ADR in `docs/adr/<decision>.md`
2. Reference it in `context/core/`
3. Update any affected module contexts

## Use Context for AI Prompts

**For code generation:**

- Reference `context/core/` (rules, conventions)
- Include relevant `context/modules/<module>.context.md`
- Use template from `context/prompts/`

**For design discussions:**

- Start with `context/prompts/master-prompt.md`
- Add module-specific context as needed
- Reference ADRs and architecture decisions

---

# Typical Development Workflow

## Starting a New Module

```
1. Define module domain model
2. Write docs/modules/<module>.md
3. Create specs/modules/<module>/module.json
4. Create context/modules/<module>.context.md
5. Generate or scaffold code
6. Implement with spec as reference
7. Add tests based on specs
```

## Adding a Feature to a Module

```
1. Write feature spec (acceptance criteria, flows, entities)
2. Create changes/<feature>.json in the module
3. Implement feature following spec
4. Test against acceptance criteria
5. Update module.json with new feature metadata
6. Consolidate changes into stable spec
```

## Iterating on Specs

- Keep specs updated as understanding evolves
- Version changes using the changes/ directory
- Use ADRs to document why specs changed
- Always propagate changes to runtime code

---

# AI-First Development

This framework is designed for **AI-assisted development**. Here's how to use it effectively:

## When Using AI for Code Generation

1. **Provide the spec**: Share the feature spec (markdown + JSON)
2. **Load context**: Include relevant core & module context files
3. **Keep it focused**: Only include dependencies you actually need
4. **Reference rules**: Always include coding and naming rules
5. **Validate output**: Check generated code against specs and rules

## When Using AI for Design

1. **Start with master prompt**: `context/prompts/master-prompt.md`
2. **Add domain context**: Include relevant module and domain docs
3. **Include ADRs**: Reference architecture decisions
4. **Provide examples**: Use templates to set expectations
5. **Iterate**: Use feedback to refine specs

## Best Practices

- **Small, relevant context** beats large, unfocused context
- Keep specs updated so AI always has fresh information
- Use context files instead of repeating information
- Document why decisions were made (ADRs help AI understand constraints)
- Version specs; use changes/ directory for tracking evolution

---

# AI Tooling & Skills

The `docs/tooling/` directory contains guides for AI-assisted SDD workflows.

## AI Development Stack (`ai-stack.md`)

**What it covers:** Recommended AI tools for different tasks.

**Key tools:**

| Tool                  | Best For                                                   | Strengths                                                    |
| --------------------- | ---------------------------------------------------------- | ------------------------------------------------------------ |
| **Claude Code**       | Implementing features, architecture reasoning, refactoring | Long context, multi-file changes, architecture understanding |
| **GPT / Codex**       | Fast boilerplate, schema generation, DTOs                  | Speed, API endpoint generation, test templates               |
| **Cursor** (optional) | Inline editing, quick refactors                            | Real-time iteration, code navigation                         |

**Important:** AI assists implementation but doesn't replace architecture decisions. Always validate security, business logic, and architectural choices.

## Model Context Protocol (MCPs) (`mcps.md`)

**What it covers:** Optional integrations to extend AI capabilities.

**Available MCPs:**

1. **Filesystem MCP**
   - Lets AI read, edit, and inspect your project
   - Use for: implementing modules, editing specs, generating boilerplate

2. **GitHub MCP**
   - Lets AI analyze repos, PRs, and code changes
   - Use for: code review, repository navigation, architecture validation

3. **Postgres MCP**
   - Lets AI inspect database schemas
   - Use for: validating migrations, writing queries, understanding relations

4. **HTTP MCP** (optional)
   - Lets AI test endpoints in real-time
   - Use for: API validation, authentication flows, debugging

**When to use MCPs:** They're optional but extremely useful for automating AI-assisted workflows.

## AI Skills & Workflows (`skills.md`)

**What it covers:** Reusable AI workflows for common SDD tasks.

**Available skills:**

1. **Spec Review Skill**
   - Analyzes a module spec to find gaps
   - Detects: missing rules, ambiguous behavior, inconsistent naming, missing entities
   - Output: improvement suggestions and architecture concerns

2. **Spec → JSON Skill**
   - Converts markdown module specs into structured JSON
   - Input: `docs/modules/<module>.md`
   - Output: `specs/modules/<module>/module.json`

3. **Boilerplate Suggestion Skill**
   - Analyzes module JSON and suggests code structure
   - Suggests: use cases, DTOs, routes, repositories, services, frontend pages

4. **Code Review Skill**
   - Reviews generated code against architecture
   - Detects: architecture violations, domain logic in handlers, inconsistent naming, missing validations

5. **Change Impact Skill**
   - Analyzes changes and determines impact
   - Identifies: affected modules, endpoints, database changes, frontend updates

**How to use skills:** Reference them in AI prompts or configure them in your AI tool's workflow system.

---

# Quick Start

**New to this project?** Start here:

1. [architecture-summary.md](context/core/architecture-summary.md) — Understand the system design
2. [modules-index.md](indexes/modules-index.md) — See what modules exist
3. [context-index.md](indexes/context-index.md) — Explore documentation structure
4. [coding-rules.md](context/core/coding-rules.md) — Learn the conventions
5. [ai-stack.md](docs/tooling/ai-stack.md) — Set up your AI tools
6. Select a module and read its context file

**For AI workflows:**

- Review [ai-stack.md](docs/tooling/ai-stack.md) to choose your AI tools
- Check [mcps.md](docs/tooling/mcps.md) to see what integrations help you
- Reference [skills.md](docs/tooling/skills.md) for reusable automation

Then explore the spec for the module you want to work on.

---

# Framework Principles

- **Spec-first**: Always write specs before code
- **Modular**: Each module is independent with clear boundaries
- **AI-friendly**: Context files designed for AI prompts and generation
- **Single source of truth**: Specs are the truth; code implements them
- **Composable**: Reuse prompts, templates, and context across projects
- **Versionable**: Track design evolution with change specs and ADRs
- **Language-agnostic**: Works with any programming language

---

# Tips for Success

- **Stable module names**: Keep them consistent across specs and code
- **Concise context**: Short, focused context files are better than long ones
- **Use change specs**: Don't silently change specs; version them in changes/
- **Update templates**: Adapt templates as your project evolves
- **Document decisions**: Use ADRs to explain architectural trade-offs
- **Keep it living**: This repo is the system's design memory—maintain it actively
