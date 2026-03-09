
# Glosario ERP y DTE

Autor: José Luis Mancilla

Este documento define términos usados en el sistema para mantener consistencia.

---

## ERP
Sistema de gestión empresarial que integra ventas, compras, inventario y finanzas.

---

## Tenant
Empresa que usa el sistema.

Cada tenant tiene:
- su schema
- sus datos

---

## DTE
Documento Tributario Electrónico emitido al SII.

Ejemplos:

33 → Factura electrónica  
39 → Boleta electrónica  
52 → Guía despacho

---

## Folio
Número único de documento tributario dentro de un rango autorizado.

---

## CAF
Archivo de Autorización de Folios entregado por el SII.

---

## Kardex
Historial de movimientos de inventario.

Incluye:
- entradas
- salidas
- saldo acumulado

---

## Costo Promedio
Costo unitario promedio de un producto calculado con promedio ponderado.

---

## Stock on Hand
Cantidad física disponible en inventario.

---

## Stock Reservado
Stock comprometido para ventas.

---

## Stock Disponible
Stock utilizable.

Fórmula:

stock_available = stock_on_hand - stock_reserved

---

## Snapshot
Copia de datos relevantes en el momento de crear un documento.

Ejemplo:

snapshot del cliente en una venta.

---

## Draft
Documento en borrador que aún no impacta inventario ni contabilidad.

---

## Posted
Documento confirmado.

---

## Ajuste de Inventario
Movimiento manual para corregir stock.

---

## Transferencia
Movimiento de inventario entre bodegas.

---

## CxC
Cuentas por cobrar.

---

## CxP
Cuentas por pagar.

---

## Track ID
Identificador entregado por el SII al enviar un DTE.
