---
name: spec-functional
description: "Use when a PO (Product Owner) wants to create a functional spec. Triggers on: /spec-functional, /spec-po, 'spec funcional', 'spec de PO', 'definir feature', 'nuevo feature PO'. Creates business-only specs without technical decisions — those go in the plan phase by the developer."
---

# Spec Funcional (PO)

Crea specs puramente funcionales para Product Owners. Sin decisiones tecnicas — esas van en el plan, que hace el developer.

> **Contexto:** El spec se separa en dos: funcional (PO) y tecnico (developer en el plan).
> Al final se genera un spec definitivo que combina ambas partes.

## Cuando Usar

- El PO quiere definir un nuevo feature o regla de negocio
- Hay un ticket de Jira que necesita formalizarse como spec
- Alguien dice "quiero definir que tiene que hacer X" sin entrar en como se implementa

## Diferencias con el Spec Tecnico

| Aspecto | Spec Tecnico (developer) | Spec Funcional (PO) |
|---------|--------------------------|---------------------|
| Quien | Developer | Product Owner |
| Contiene | Reglas negocio + contrato API + detalles tecnicos | Solo reglas de negocio |
| Contrato API | Si, con formato OpenAPI | No. Solo describe inputs/outputs a nivel usuario |
| Constantes del sistema | Puede incluir valores tecnicos | Solo valores de negocio |
| Decisiones tecnicas | Puede mencionar cache, DB, etc. | Prohibido. Si aparece algo tecnico, mover a notas para el plan |
| Aprobacion | Developer aprueba | PO aprueba funcional, Developer aprueba plan despues |

## Principios

- **Solo QUE y POR QUE, nunca COMO.** Si el PO dice "usar Redis", "crear tabla", "endpoint REST" → no incluirlo en la spec, guardarlo en `_references/notas-tecnicas.md` para que el developer lo tenga en cuenta en el plan.
- **Lenguaje de negocio.** Usar terminologia que el PO entienda. "El usuario puede..." en vez de "El endpoint devuelve..."
- **Una spec = un concepto.** Si mezcla funcionalidades independientes, separar.
- **Verificable.** Cada regla debe tener escenarios BDD que el PO pueda validar.

## El Proceso

### 1. Identificar fuente

"¿De donde viene este feature?" (idea, ticket Jira, conversacion).
Si tiene ID de ticket, usarlo en el nombre de la carpeta.
Si es de Jira, extraer la info via MCP.

### 2. Explorar con el PO

Guiar con preguntas de NEGOCIO (nunca tecnicas):
- ¿Que problema resuelve para el usuario?
- ¿Quien es el usuario afectado? (roles)
- ¿Que puede hacer el usuario hoy vs que queremos que pueda hacer?
- ¿Hay restricciones de negocio? (legal, compliance, reglas de producto)
- ¿Que pasa si el usuario intenta hacer algo incorrecto?
- ¿Hay casos especiales o excepciones?

**NUNCA preguntar:**
- ¿Que endpoint necesitamos?
- ¿Donde se almacena?
- ¿Que servicio se encarga?
- ¿Como cachear esto?

### 3. Crear carpeta de trabajo

Directorio en `.workflow/wip/`:
- Con ticket: `.workflow/wip/st-5837_banner-json-rendering/`
- Sin ticket: `.workflow/wip/banner-json-rendering/`
- Formato: `[id-ticket_]slug-descriptivo` (lowercase, kebab-case)

### 4. Generar el spec funcional

Crear `spec.md` en la carpeta de trabajo usando el template funcional (seccion Template abajo).
Asegurar que incluye:
- **Contexto de negocio:** por que existe este feature
- **Actores:** quien interactua (usuario, admin, sistema, etc.)
- **Reglas de negocio:** logica formal sin implementacion
- **Invariantes:** condiciones que siempre se cumplen
- **Matriz de estados:** todas las combinaciones posibles
- **BDD exhaustivo:** escenarios en lenguaje que el PO entienda

### 5. Filtro anti-tecnico

Antes de mostrar la spec al PO, revisar:
- ¿Menciona tecnologias? (Redis, MySQL, API, endpoint, cache, cola...) → SACAR
- ¿Menciona archivos o rutas de codigo? → SACAR
- ¿Menciona arquitectura? (microservicio, consumer, worker...) → SACAR
- Si hay informacion tecnica valiosa mencionada por el PO, guardarla en `_references/notas-tecnicas.md`

### 6. Crear estado

Crear `state.yaml` con:
```yaml
feature: [slug]
ticket: [ID o null]
phase: specifying
status: draft
spec_type: functional
approvals:
  po: { approved: false, by: null, date: null }
  developer: { approved: false, by: null, date: null }
target_domain: [dominio destino cuando se complete]
```

### 7. Aprobacion del PO

Presentar la spec al PO. Preguntar:
- "¿La matriz de estados cubre TODOS los casos?"
- "¿Falta algun escenario que pueda pasar en produccion?"
- "¿Las reglas reflejan exactamente lo que quieres?"

Cuando el PO aprueba, actualizar `state.yaml`:
```yaml
approvals:
  po: { approved: true, by: "[nombre]", date: "[fecha]" }
```

## Template

```markdown
# SPEC FUNCIONAL — [titulo]

| Campo | Valor |
|-------|-------|
| Version | 1.0.0 |
| Tipo | Funcional (PO) |
| Owner | [PO que lo define] |
| Scope | [una frase: que determina esta spec] |
| Estado | draft / po-approved / approved |

---

## 1. Contexto de Negocio

[Por que existe este feature. Que problema resuelve. Que valor aporta.]

---

## 2. Actores

| Actor | Descripcion |
|-------|-------------|
| [rol] | [que hace en relacion a este feature] |

---

## 3. Reglas de Negocio

### R1 — [nombre de la regla]

[Descripcion en lenguaje natural claro]

### R2 — [nombre]

[Descripcion]

---

## 4. Invariantes

- [Condicion que SIEMPRE debe cumplirse]
- [Que NO cambia con esta spec]

---

## 5. Matriz de Estados

| [Situacion A] | [Situacion B] | [Resultado para el usuario] |
|---------------|---------------|----------------------------|
| si | si | [que pasa] |
| si | no | [que pasa] |
| no | si | [que pasa] |
| no | no | [que pasa] |

---

## 6. BDD — Escenarios

### Escenario: [titulo descriptivo]

Dado que [contexto]
Y [condicion]
Cuando [accion del usuario]
Entonces [resultado esperado]

---

## Fuera de Alcance

- [Que NO cubre esta spec y por que]
```

## Siguiente Paso

Spec funcional aprobado por el PO. El developer invoca `teamflow:planning` para crear el plan tecnico, que incluira las decisiones de implementacion.

## Errores Comunes

- **PO incluye decisiones tecnicas**: No incluirlas. Mover a `_references/notas-tecnicas.md`.
- **Spec demasiado vago**: Forzar la matriz de estados completa. Si no puedes llenarla, la spec no esta clara.
- **Mezclar features**: Una spec = un concepto. Si puedes implementar A sin B, son specs distintas.
- **BDD con jerga tecnica**: Los escenarios deben ser comprensibles para el PO. "Dado que el usuario esta logueado" en vez de "Dado que la sesion tiene un JWT valido".
