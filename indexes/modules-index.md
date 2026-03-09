# Modules Index

This index provides a quick overview of the current modules defined in the project.

Use this file to quickly navigate the system domain and understand which modules already exist.

---

# Active Modules

## auth
**Purpose:** authentication and account access  
**Docs:** `docs/modules/auth.md`  
**Spec:** `specs/modules/auth/module.json`  
**Context:** `context/modules/auth.context.md`  

Typical responsibilities:
- login
- logout
- current profile
- verify email
- reset password

---

## product
**Purpose:** product catalog management  
**Docs:** `docs/modules/product.md`  
**Spec:** `specs/modules/product/module.json`  
**Context:** `context/modules/product.context.md`

Typical responsibilities:
- create product
- update product
- list products
- disable product

---

## customer
**Purpose:** customer management for sales and billing  
**Docs:** `docs/modules/customer.md`  
**Spec:** `specs/modules/customer/module.json`  
**Context:** `context/modules/customer.context.md`

Typical responsibilities:
- create customer
- update customer
- list customers
- customer detail

---

## supplier
**Purpose:** supplier management for purchases  
**Docs:** `docs/modules/supplier.md`  
**Spec:** `specs/modules/supplier/module.json`  
**Context:** `context/modules/supplier.context.md`

Typical responsibilities:
- create supplier
- update supplier
- list suppliers

---

## purchase
**Purpose:** purchase document flow  
**Docs:** `docs/modules/purchase.md`  
**Spec:** `specs/modules/purchase/module.json`  
**Context:** `context/modules/purchase.context.md`

Typical responsibilities:
- create purchase draft
- post purchase
- purchase items
- purchase totals

---

## sale
**Purpose:** sales document flow  
**Docs:** `docs/modules/sale.md`  
**Spec:** `specs/modules/sale/module.json`  
**Context:** `context/modules/sale.context.md`

Typical responsibilities:
- create sale draft
- post sale
- sale items
- sale references

---

## inventory
**Purpose:** stock movements, balances and cost logic  
**Docs:** `docs/modules/inventory.md`  
**Spec:** `specs/modules/inventory/module.json`  
**Context:** `context/modules/inventory.context.md`

Typical responsibilities:
- inventory movements
- stock balances
- adjustments
- transfers
- kardex

---

## payment
**Purpose:** payments and pending balances  
**Docs:** `docs/modules/payment.md`  
**Spec:** `specs/modules/payment/module.json`  
**Context:** `context/modules/payment.context.md`

Typical responsibilities:
- register payments
- partial/full settlement
- accounts receivable/payable

---

## folio
**Purpose:** folio ranges and numbering strategy  
**Docs:** `docs/modules/folio.md`  
**Spec:** `specs/modules/folio/module.json`  
**Context:** `context/modules/folio.context.md`

Typical responsibilities:
- folio ranges
- next folio consumption
- CAF/range validation

---

## dte
**Purpose:** tax document integration and lifecycle  
**Docs:** `docs/modules/dte.md`  
**Spec:** `specs/modules/dte/module.json`  
**Context:** `context/modules/dte.context.md`

Typical responsibilities:
- DTE payload generation
- signing/sending
- SII tracking/state sync

---

# Recommended Reading Order

For new contributors, a useful reading sequence is:

1. `docs/architecture.md`
2. `context/core/architecture-summary.md`
3. `docs/conventions/...`
4. `indexes/modules-index.md`
5. the specific module you want to modify

---

# Notes

- Add new modules here when they become part of the system.
- If a module is experimental, make that explicit.
- Keep names consistent with folder names, spec names, and code module names.
