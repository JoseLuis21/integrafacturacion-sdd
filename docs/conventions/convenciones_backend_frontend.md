# Convenciones Backend y Frontend
Proyecto: ERP / Facturación / Inventario
Stack: Go (Fiber v2, Arquitectura Hexagonal) + PostgreSQL + Next.js + shadcn/ui

Autor: José Luis Mancilla

---

# 1. Objetivo

Definir reglas claras para que el proyecto crezca con consistencia en:

- nombres
- estructura
- contratos
- DTOs
- errores
- responses
- validaciones
- hooks
- servicios
- componentes
- permisos
- eventos internos

Estas convenciones ayudan a:

- reducir refactors innecesarios
- mantener coherencia entre módulos
- acelerar desarrollo
- facilitar onboarding
- evitar estilos mezclados

---

# 2. Convenciones generales

## 2.1 Idioma
- Explicaciones y documentación: **español**
- Código: **inglés**
- nombres de variables, funciones, structs, interfaces, tablas y columnas: **inglés**
- labels UI: según contexto, normalmente **español**
- mensajes de error técnicos internos: inglés o neutro
- mensajes visibles al usuario: español claro

## 2.2 Estilo general
- preferir nombres explícitos antes que abreviaturas raras
- evitar nombres genéricos como `data`, `item`, `obj`, `helper`
- una responsabilidad clara por archivo
- funciones cortas y enfocadas
- no mezclar lógica de negocio con transporte HTTP
- no mezclar reglas de dominio con detalles de infraestructura

## 2.3 Nombres
- entidades: singular (`Product`, `Customer`, `Sale`)
- tablas SQL: plural (`products`, `customers`, `sales`)
- endpoints REST: plural (`/customers`, `/products`, `/sales`)
- archivos backend Go: snake_case
- componentes React: kebab-case en archivo, PascalCase en componente
- variables: camelCase
- tipos/interfaces TS: PascalCase
- structs Go: PascalCase
- métodos y funciones exportadas Go: PascalCase
- funciones no exportadas Go: camelCase

---

# 3. Convenciones de backend Go

## 3.1 Estructura de nombres por módulo

Ejemplo módulo product:

- entidad: `Product`
- repositorio: `Repository` o `ProductRepository`
- caso de uso: `CreateProductUseCase`
- handler HTTP: `Handler`
- archivo de rutas: `routes.go`
- DTO request: `CreateProductRequest`
- DTO response: `ProductResponse`

## 3.2 Archivos
Ejemplo:

```text
product/
├── domain/
│   ├── entity.go
│   ├── repository.go
│   ├── errors.go
│   └── value_objects.go
├── application/
│   ├── dto/
│   │   ├── create_product_input.go
│   │   └── product_output.go
│   └── usecases/
│       ├── create_product.go
│       ├── update_product.go
│       └── list_products.go
├── infrastructure/
│   ├── persistence/postgres/
│   │   ├── repository.go
│   │   ├── models.go
│   │   └── queries.go
│   └── http/
│       ├── handler.go
│       ├── request.go
│       ├── response.go
│       └── routes.go
└── module.go
```

## 3.3 Interfaces
- interfaces pequeñas
- definir interfaces en el consumidor, no en el proveedor cuando tenga sentido
- evitar interfaces gigantes de 15 métodos

Ejemplo bueno:

```go
type ProductRepository interface {
    Create(ctx context.Context, product *Product) error
    GetByID(ctx context.Context, id uuid.UUID) (*Product, error)
    Update(ctx context.Context, product *Product) error
}
```

## 3.4 Context
- todo caso de uso y repositorio recibe `context.Context`
- no usar context como contenedor arbitrario de negocio
- solo transportar metadatos técnicos o request-scoped

## 3.5 UUID
- usar UUID v7 generado en aplicación
- no generar IDs aleatorios tipo string manual
- no usar `bigserial` en entidades principales
- tablas pivote y saldos naturales pueden usar PK compuesta

---

# 4. Convenciones de dominio backend

## 4.1 Entidades
Una entidad debe representar negocio, no persistencia SQL exacta.

Ejemplo `Product`:
- id
- sku
- name
- product type
- tax config
- inventory config

No meter tags HTTP o DB directamente en dominio si puedes evitarlo.

## 4.2 Value Objects
Usarlos cuando agreguen claridad.

Ejemplos:
- `RUT`
- `Email`
- `Money`
- `DocumentTypeCode`
- `TenantSchema`
- `SKU`

## 4.3 Reglas de negocio
Van en:
- entidades
- value objects
- servicios de dominio

No deben quedar enterradas en handlers o queries.

## 4.4 Errores de dominio
Cada módulo puede tener errores propios.

Ejemplo:
- `ErrProductNotFound`
- `ErrInsufficientStock`
- `ErrInvalidRUT`
- `ErrFolioRangeExpired`

Convención:
- nombre claro
- reusable
- sin acoplarse a HTTP status directamente

---

# 5. Convenciones de casos de uso

## 5.1 Nombres
- `CreateProductUseCase`
- `UpdateCustomerUseCase`
- `PostPurchaseUseCase`
- `CreateSaleDraftUseCase`
- `ApplyInventoryAdjustmentUseCase`

## 5.2 Responsabilidad
Un caso de uso:
- orquesta
- valida entrada
- llama repositorios
- ejecuta transacción si corresponde
- devuelve DTO claro

No debería:
- construir responses HTTP
- conocer Fiber
- formatear JSON

## 5.3 Inputs y outputs
Siempre usar structs claros.

Ejemplo:

```go
type CreateProductInput struct {
    TenantID uuid.UUID
    SKU      string
    Name     string
    UnitID   uuid.UUID
}
```

```go
type ProductOutput struct {
    ID   uuid.UUID
    SKU  string
    Name string
}
```

---

# 6. Convenciones HTTP backend

## 6.1 Endpoints REST
Usar nombres plurales.

Ejemplos:
- `GET /api/v1/customers`
- `POST /api/v1/customers`
- `GET /api/v1/customers/:id`
- `PATCH /api/v1/customers/:id`
- `DELETE /api/v1/customers/:id`

## 6.2 Acciones especiales
Si no es CRUD puro, usar subrutas claras.

Ejemplos:
- `POST /api/v1/auth/login`
- `POST /api/v1/auth/forgot-password`
- `POST /api/v1/sales/:id/post`
- `POST /api/v1/purchases/:id/post`
- `POST /api/v1/inventory/adjustments`
- `POST /api/v1/tenants`

## 6.3 Requests
- validar todo request en capa HTTP o application según corresponda
- no pasar body crudo directo al dominio
- usar structs request dedicados

Ejemplo:
- `CreateCustomerRequest`
- `CreateSaleRequest`

## 6.4 Responses
Usar estructura consistente.

Ejemplo sugerido éxito:

```json
{
  "success": true,
  "message": "Customer created successfully",
  "data": {
    "id": "018f..."
  }
}
```

Ejemplo error:

```json
{
  "success": false,
  "message": "Validation failed",
  "error": {
    "code": "VALIDATION_ERROR",
    "details": {
      "rut": ["invalid format"]
    }
  }
}
```

## 6.5 Paginación
Formato recomendado:

```json
{
  "success": true,
  "data": [...],
  "meta": {
    "page": 1,
    "page_size": 20,
    "total": 154,
    "total_pages": 8
  }
}
```

## 6.6 Filtros
Convención query params:
- `page`
- `page_size`
- `search`
- `status`
- `from`
- `to`
- `sort_by`
- `sort_order`

---

# 7. Convenciones de errores backend

## 7.1 Capas
### Dominio
Errores semánticos del negocio.

### Application
Traducción/orquestación y contexto.

### HTTP
Mapeo a status code y response final.

## 7.2 Mapping sugerido
- validation error → `400`
- unauthorized → `401`
- forbidden → `403`
- not found → `404`
- conflict → `409`
- unprocessable business rule → `422`
- internal error → `500`

## 7.3 Codes
Usar códigos estables.

Ejemplos:
- `VALIDATION_ERROR`
- `UNAUTHORIZED`
- `FORBIDDEN`
- `RESOURCE_NOT_FOUND`
- `CONFLICT`
- `INSUFFICIENT_STOCK`
- `INVALID_RUT`
- `FOLIO_RANGE_EXPIRED`

---

# 8. Convenciones SQL / PostgreSQL

## 8.1 Tablas
- nombres en plural
- snake_case
- ejemplo: `inventory_movements`

## 8.2 Columnas
- snake_case
- foreign keys como `<entity>_id`
- timestamps:
  - `created_at`
  - `updated_at`
  - `deleted_at`

## 8.3 IDs
- `id uuid` en entidades principales
- PK compuesta en pivotes y balances naturales cuando tenga sentido

## 8.4 Índices
Nombre sugerido:
- `pk_<table>`
- `ux_<table>_<field>`
- `ix_<table>_<field>`
- `fk_<table>_<ref_table>`

Ejemplos:
- `ux_users_email_normalized`
- `ix_sales_issue_date`

## 8.5 Soft delete
Solo donde tenga sentido real:
- customers
- suppliers
- products
- sales
- purchases

No forzar soft delete en todo.

---

# 9. Convenciones multi-tenant

## 9.1 Control vs tenant
- `integra_control`: auth, users, companies, ACL
- `integra_tenant`: datos operativos por schema

## 9.2 Resolución de tenant
Prioridad sugerida:
1. subdominio
2. JWT/session
3. API key
4. header interno controlado si aplica

## 9.3 Search path
Siempre aplicar por request antes de usar repos tenant.

Ejemplo:
```sql
SET search_path TO tenant_airconnect, public;
```

## 9.4 Scoping
Aunque haya schema por tenant:
- seguir validando acceso de usuario a empresa
- no confiar solo en el schema

---

# 10. Convenciones de inventario

## 10.1 Fuente de verdad
- histórico: `inventory_movements`
- estado actual: `inventory_balances`

## 10.2 Entradas
Recalcular:
- stock
- avg_cost
- last_cost
- inventory_value

## 10.3 Salidas
Recalcular:
- stock
- inventory_value

El `avg_cost` se mantiene.

## 10.4 Nombres
- `stock_on_hand`
- `stock_reserved`
- `stock_available`
- `avg_cost`
- `last_cost`
- `inventory_value`

## 10.5 Cost snapshot
Siempre guardar `cost_snapshot` en líneas de venta al emitir/postear.

---

# 11. Convenciones frontend Next.js

## 11.1 Organización
Organizar por dominio.

Bueno:
```text
modules/product/
modules/sale/
modules/inventory/
```

Malo:
```text
forms/
tables/
pages/
```

todo mezclado sin dominio.

## 11.2 Archivos React
- nombre archivo: kebab-case
- nombre componente: PascalCase

Ejemplo:
- archivo: `product-form.tsx`
- componente: `ProductForm`

## 11.3 Componentes
### Globales
Van en `src/components/`

### Específicos de módulo
Van en `src/modules/<module>/components/`

## 11.4 Hooks
Nombres:
- `use-products.ts`
- `use-create-product.ts`
- `use-current-user.ts`
- `use-permission.ts`

## 11.5 Services
- un service por módulo cuando corresponda
- no meter toda la API en un solo archivo gigante

Ejemplo:
- `product.service.ts`
- `sale.service.ts`
- `customer.service.ts`

---

# 12. Convenciones de tipos y schemas frontend

## 12.1 Types
- `Product`
- `ProductFormValues`
- `CreateProductPayload`
- `ProductListItem`

## 12.2 Schemas
Usar Zod o equivalente.

Ejemplo:
- `product.schema.ts`
- `customer.schema.ts`

## 12.3 Separación útil
- tipos de dominio UI
- payloads request
- responses API

No usar el mismo tipo para todo si te complica evolución.

---

# 13. Convenciones de UI

## 13.1 Idioma
- UI visible: español
- nombres técnicos internos: inglés

## 13.2 Botones
Usar verbos claros:
- Crear
- Guardar
- Emitir
- Confirmar
- Cancelar
- Registrar pago

Evitar:
- Procesar
- Ejecutar
- Hacer acción

si no es necesario.

## 13.3 Estados visuales
Usar badges consistentes:
- Draft
- Active
- Paid
- Pending
- Rejected
- Accepted
- Suspended

## 13.4 Tema
- soporte claro/oscuro desde el inicio
- no hardcodear colores en componentes
- centralizar tokens/variables visuales

---

# 14. Convenciones de formularios frontend

## 14.1 Formularios
- usar react-hook-form + zod o equivalente
- validación cliente + servidor
- mostrar error inline por campo
- mantener submit loading claro

## 14.2 Inputs
- `RUTInput`
- `MoneyInput`
- `DateInput`
- `SelectField`
- `TextareaField`

## 14.3 Form values
Ejemplo:
- `CreateCustomerFormValues`
- `CreateSaleFormValues`

## 14.4 Errores
- mostrar mensajes entendibles
- mapear errores backend por campo cuando sea posible

---

# 15. Convenciones de tablas frontend

## 15.1 Data tables
Toda tabla debería definir:
- columnas
- filtros
- búsqueda
- paginación
- estado vacío
- loading state
- error state

## 15.2 Column names
Usar labels entendibles en español:
- Razón social
- RUT
- Estado
- Total
- Fecha emisión

## 15.3 Acciones
Estándar:
- Ver
- Editar
- Desactivar
- Eliminar
- Emitir
- Registrar pago

---

# 16. Convenciones de permisos frontend

## 16.1 Guards
No mostrar:
- menús
- botones
- acciones
- páginas

si el usuario no tiene permiso.

## 16.2 Nombres permisos
Formato:
`<module>.<action>`

Ejemplos:
- `sales.read`
- `sales.create`
- `sales.update`
- `inventory.adjust`
- `settings.manage`

## 16.3 Hook sugerido
```ts
usePermission("sales.create")
```

## 16.4 Componente sugerido
```tsx
<PermissionGuard permission="sales.create">
  <Button>Crear venta</Button>
</PermissionGuard>
```

---

# 17. Convenciones de naming API y frontend

## 17.1 Backend response field names
Usar snake_case o camelCase de forma consistente.  
Recomendación para JSON API moderna: **camelCase**.

Ejemplo:
```json
{
  "issueDate": "2026-03-08",
  "customerId": "..."
}
```

## 17.2 DB
Mantener snake_case en PostgreSQL.

## 17.3 Mapping
- DB: snake_case
- Go structs internos: PascalCase con tags json
- JSON API: camelCase
- frontend: camelCase

Esto suele ser el equilibrio más limpio.

---

# 18. Convenciones de logs y auditoría

## 18.1 Logs técnicos
Estructurados.

Campos sugeridos:
- `request_id`
- `tenant`
- `module`
- `action`
- `user_id`
- `error`
- `duration_ms`

## 18.2 Auditoría funcional
Campos sugeridos:
- actor
- tenant
- action
- entity
- entity_id
- before
- after
- created_at

## 18.3 Qué auditar
- login
- cambios de ACL
- creación/edición/cancelación de documentos
- ajustes inventario
- asignación de folios

---

# 19. Convenciones de testing

## 19.1 Backend
- `*_test.go`
- nombrar tests por comportamiento
- testear casos felices y reglas de negocio

Ejemplo:
- `TestCreateProduct_Success`
- `TestPostSale_InsufficientStock`

## 19.2 Frontend
- component tests para formularios y tablas
- e2e para flujos críticos

Ejemplo:
- login
- crear cliente
- registrar compra
- registrar venta

---

# 20. Convenciones de commits y ramas

## 20.1 Ramas
Formato sugerido:
- `feat/auth-login`
- `feat/inventory-engine`
- `fix/sale-stock-validation`
- `chore/setup-migrations`

## 20.2 Commits
Formato sugerido:
- `feat: add inventory balances upsert`
- `fix: validate stock before posting sale`
- `chore: add tenant bootstrap script`
- `refactor: split product usecases`

---

# 21. Convenciones de documentación

## 21.1 Docs por tema
- arquitectura
- base de datos
- inventario
- dte
- frontend
- decisiones técnicas

## 21.2 ADRs
Cuando una decisión tenga impacto fuerte, documentarla.

Ejemplos:
- usar UUID v7
- usar schema por tenant
- usar promedio ponderado móvil
- DTE como módulo separado

---

# 22. Recomendación final

## Backend
- dominio limpio
- casos de uso explícitos
- repositorios pequeños
- responses uniformes
- errores estables
- multi-tenant consistente

## Frontend
- organizar por módulo
- componentes reutilizables
- formularios consistentes
- permisos visibles e invisibles bien controlados
- camelCase en cliente

## Resultado esperado
Con estas convenciones el proyecto puede crecer con orden cuando metas:
- DTE
- reportes
- jobs
- auditoría
- más tenants
- más desarrolladores
