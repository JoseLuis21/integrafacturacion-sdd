# Naming Rules

## Purpose

This file defines stable naming conventions for specs, modules, backend code, frontend code, and data structures.

Consistent naming reduces confusion for both humans and AI.

---

## General Naming

- Use English for code identifiers.
- Use Spanish or business-appropriate language in UI labels and documentation when desired.
- Prefer explicit names over abbreviations.
- Use the same term consistently across specs, code, and UI.

---

## Module Naming

Use singular module names for domain modules.

Examples:

- `auth`
- `product`
- `customer`
- `supplier`
- `sale`
- `purchase`
- `inventory`

Avoid mixing equivalent names like:

- `sale` vs `invoice` vs `order`
  unless they truly represent different concepts.

---

## Backend Naming

### Packages and folders

- use lowercase
- use simple names
- use one domain name per module

Examples:

- `internal/modules/product`
- `internal/modules/auth`

### Go files

Use snake_case.

Examples:

- `create_product.go`
- `get_current_user.go`
- `password_policy.go`

### Package names

Use the same name as the folder.

- `domain_product`
- `application_product`
- `infrastructure_product`

### Structs and exported types

Use PascalCase.

Examples:

- `Product`
- `CreateProductInput`
- `LoginUseCase`

### Unexported identifiers

Use camelCase.

Examples:

- `buildResponse`
- `loadSpec`

### Interfaces

Use names based on responsibility.

Examples:

- `Repository`
- `ProductRepository`
- `PasswordHasher`

Avoid vague names like:

- `Manager`
- `Helper`
- `Service` unless the meaning is really clear.

---

## DTO Naming

### Input DTOs

Examples:

- `CreateProductInput`
- `UpdateCustomerInput`
- `LoginInput`

### Output DTOs

Examples:

- `ProductOutput`
- `CustomerOutput`
- `LoginOutput`

### HTTP request/response

Examples:

- `CreateProductRequest`
- `ProductResponse`

---

## Use Case Naming

Use explicit action-oriented names.

Examples:

- `CreateProductUseCase`
- `UpdateProductUseCase`
- `LoginUseCase`
- `ForgotPasswordUseCase`

Avoid vague names like:

- `ProductManager`
- `HandleProduct`

---

## Frontend Naming

### Files

Use kebab-case for component files.

Examples:

- `product-form.tsx`
- `login-form.tsx`

### React components

Use PascalCase.

Examples:

- `ProductForm`
- `LoginForm`

### Hooks

Prefix with `use`.

Examples:

- `use-products.ts`
- `use-login.ts`
- `use-current-user.ts`

### Services

Use `<module>.service.ts`

Examples:

- `auth.service.ts`
- `product.service.ts`

### Schemas

Use `<module>.schema.ts` or action-specific schema names.

Examples:

- `product.schema.ts`
- `login.schema.ts`

### Types

Use descriptive type names.

Examples:

- `Product`
- `CreateProductPayload`
- `LoginResponse`

---

## Database Naming

- tables in plural
- columns in snake_case
- foreign keys as `<entity>_id`

Examples:

- `products`
- `customers`
- `inventory_movements`
- `user_id`
- `company_id`

Timestamp fields:

- `created_at`
- `updated_at`
- `deleted_at`

---

## API Naming

- use plural resource paths for CRUD resources
- use clear subpaths for actions

Examples:

- `POST /api/v1/products`
- `GET /api/v1/products`
- `GET /api/v1/products/:id`
- `POST /api/v1/auth/login`
- `POST /api/v1/auth/forgot-password`

---

## Permissions Naming

Use `<module>.<action>` format.

Examples:

- `products.read`
- `products.create`
- `products.update`
- `sales.post`
- `inventory.adjust`
- `auth.me`

---

## Spec Naming

Use stable file names.

Examples:

- `docs/modules/auth.md`
- `docs/modules/product.md`
- `specs/modules/auth/module.json`
- `specs/modules/auth/changes/google-oauth.json`

---

## Final Rule

If a concept already has a name in the project, reuse it.
Do not create synonyms unless the business meaning is actually different.
