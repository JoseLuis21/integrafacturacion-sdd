
# ADRs Iniciales del Proyecto ERP

Autor: José Luis Mancilla

Este documento registra **decisiones arquitectónicas importantes (ADR: Architecture Decision Records)** para el sistema ERP.

Cada ADR tiene:
- Contexto
- Decisión
- Consecuencias

---

# ADR-001 — Uso de PostgreSQL como base de datos principal

## Contexto
El sistema requiere:
- transacciones fuertes
- integridad de datos
- consultas complejas
- multi-tenant

## Decisión
Usar **PostgreSQL** como base principal.

## Consecuencias
Ventajas:
- ACID fuerte
- excelente para joins
- soporte JSON
- índices avanzados

Desventajas:
- requiere diseño de índices cuidadoso

---

# ADR-002 — Multi-tenant por schema

## Contexto
El ERP debe soportar múltiples empresas.

## Decisión
Usar **un schema por tenant** dentro de PostgreSQL.

Estructura:

integra_control → usuarios / empresas  
integra_tenant → schemas por empresa

## Consecuencias
Ventajas:
- aislamiento fuerte
- fácil backup por tenant
- evita filtros tenant_id en cada query

Desventajas:
- más schemas a administrar

---

# ADR-003 — UUID v7 como identificadores

## Contexto
Evitar IDOR y mejorar distribución.

## Decisión
Usar **UUID v7 generados en la aplicación**.

## Consecuencias
Ventajas:
- orden temporal
- menos fragmentación en índices
- evita exposición de secuencias

---

# ADR-004 — Arquitectura Hexagonal

## Contexto
Separar dominio de infraestructura.

## Decisión
Usar arquitectura:

domain  
application  
infrastructure

## Consecuencias
Ventajas:
- dominio limpio
- testabilidad
- desacople de framework

---

# ADR-005 — Promedio ponderado móvil para costos

## Contexto
El ERP necesita calcular costo de inventario.

## Decisión
Usar **Weighted Moving Average (WMA)**.

## Consecuencias
Ventajas:
- simple
- rápido
- común en ERP

---

# ADR-006 — Historial de inventario con movimientos

## Contexto
Necesidad de auditoría de inventario.

## Decisión
Usar:

inventory_movements → historial  
inventory_balances → estado actual

## Consecuencias
Permite:
- kardex
- reconstrucción
- auditoría

---

# ADR-007 — Backend monolito modular

## Contexto
Equipo pequeño.

## Decisión
Usar **monolito modular** en vez de microservicios.

## Consecuencias
Ventajas:
- menos complejidad
- transacciones simples

---

# ADR-008 — Next.js para frontend

## Contexto
Necesidad de UI moderna.

## Decisión
Usar **Next.js + shadcn/ui**.

## Consecuencias
Ventajas:
- componentes reutilizables
- SSR/SPA flexible
