# AI Workflow

## Purpose
This file defines the standard AI-assisted development workflow for the project.

It should be used as reusable guidance whenever AI is helping with design, generation, implementation, or review.

---

## Core Flow

```text
idea
→ feature spec (.md)
→ structured spec (.json)
→ boilerplate generation
→ implementation
→ tests
```

The most important rule is:

**do not start with code if the feature is not clearly specified.**

---

## Source of Truth
The source of truth for a feature is:

1. feature spec (`docs/modules/...`)
2. structured spec (`specs/modules/.../module.json`)
3. project conventions
4. architecture context

Generated code is not the original source of truth.

---

## Use AI For
AI is especially useful for:
- reviewing specs
- converting specs into structured JSON
- generating boilerplate
- implementing bounded use cases
- generating schemas and DTOs
- generating tests
- reviewing consistency

---

## Do Not Overload Context
Do not load the whole project into the prompt.

Use:
- core context
- current module context
- relevant spec
- only nearby dependencies

This improves output quality and reduces hallucination.

---

## Standard Prompt Order
For most tasks, the prompt should provide:

1. project/core context
2. module context
3. feature spec
4. structured spec
5. explicit task request
6. constraints and limits

---

## Recommended Sequence Per Module

### Step 1 — Write the human spec
Create:
- `docs/modules/<module>.md`

### Step 2 — Create structured spec
Create:
- `specs/modules/<module>/module.json`

### Step 3 — Generate boilerplate
Use a CLI or generation flow to create:
- backend skeleton
- frontend skeleton

### Step 4 — Review generated structure
Check:
- naming
- architecture
- files created
- missing pieces
- unnecessary files

### Step 5 — Implement logic
Ask AI for specific bounded tasks.

Examples:
- implement `CreateProductUseCase`
- implement `LoginUseCase`
- implement `ForgotPasswordUseCase`

### Step 6 — Generate and improve tests
Test:
- success paths
- business rule failures
- boundary cases

---

## Change Workflow
When adding a major capability to an existing module:

1. create a change spec in `docs/changes/`
2. create a structured change spec in `specs/modules/<module>/changes/`
3. implement the change
4. merge/update the main module spec once stable

---

## Prompting Rules
When asking AI to write code:
- define exactly what module is being changed
- define exactly what files or folders may be touched
- define what must not be changed
- define the business rules explicitly
- define the expected output

Bad:
- “implement auth”

Good:
- “implement LoginUseCase for the auth module, following the existing structure and these rules...”

---

## Review Rules
Always review generated code for:
- architectural boundaries
- missing business rules
- inconsistent naming
- unsafe assumptions
- hidden complexity
- unnecessary scope expansion

---

## Final Principle
Use AI to accelerate implementation, not to outsource architecture and judgment.

The developer remains responsible for:
- defining the problem
- approving the structure
- validating the business rules
- reviewing the generated code
