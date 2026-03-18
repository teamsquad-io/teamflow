---
name: spec-tech
description: "Use when a developer wants to create a technical specification with formal domain, API contracts, and system constants. Triggers on: /spec-tech, /spec-dev, 'spec tecnica', 'spec de developer', 'formalizar feature'. Builds on a functional spec (if exists) adding technical detail."
---

# Spec Tecnica (Developer)

Convierte ideas, tickets o specs funcionales en specs tecnicas formales. Dominio formal, contratos API, constantes del sistema, logica verificable. Una spec = un concepto. Compacta (~100 lineas), verificable.

## Cuando Usar

- El developer quiere formalizar un feature con detalle tecnico
- Hay una spec funcional aprobada que necesita la capa tecnica
- Se necesita definir contratos API, constantes del sistema, o logica formal antes de planificar

## Diferencias con el Spec Funcional

| Aspecto | Spec Funcional (PO) | Spec Tecnica (developer) |
|---------|---------------------|--------------------------|
| Quien | Product Owner | Developer |
| Contiene | Solo reglas de negocio | Reglas negocio + contrato API + detalles tecnicos |
| Contrato API | No | Si, con formato OpenAPI simplificado |
| Constantes del sistema | Solo valores de negocio | Puede incluir valores tecnicos |
| Inputs | Descritos a nivel usuario | Tabla formal con tipos |
| Reglas | Lenguaje natural claro | Notacion formal (logica) |

## Principios

- **Reglas de negocio + dominio tecnico, no implementacion.** La spec define QUE con logica formal. Nunca HOW (archivos, arquitectura, tecnologias concretas). Si detectas "usar Redis" o "crear tabla X", moverlo a notas para el plan.
- **Una spec = un concepto.** Si la idea mezcla funcionalidades independientes, separar en specs distintas.
- **Compacta y formal.** Target: ~100 lineas. Inputs como tabla, reglas como logica formal, invariantes explicitas, matriz de estados completa, BDD exhaustivo.
- **Verificable.** Cada regla debe poder probarse con la matriz de estados. Si no puedes escribir la matriz completa, la spec no esta clara.
- **Construir sobre la funcional.** Si existe una spec funcional aprobada en la carpeta wip, usarla como base y enriquecerla con el dominio formal.

## El Proceso

### 1. Identificar fuente

"¿De donde viene este feature?" (manual, Jira, spec funcional existente).
Si tiene ID de ticket, usarlo en el nombre de la carpeta.
Si es de Jira, extraer la info via MCP.
Si ya existe una carpeta wip con spec funcional, trabajar ahi mismo.

### 2. Verificar spec funcional

Buscar en `.workflow/wip/` si ya existe una carpeta para este feature:
- Si **existe spec funcional aprobada**: usarla como base. Las reglas de negocio ya estan validadas por el PO.
- Si **no existe**: explorar con el developer para definir el dominio formal desde cero.

### 3. Explorar y descomponer

Guiar al usuario:
- ¿Que problema resuelve?
- ¿Es un concepto o varios? Si son varios, separar.
- ¿Cuales son los inputs formales y sus tipos?
- ¿Cuales son las constantes del sistema?
- ¿Cuales son las reglas de negocio en logica formal?
- ¿Que endpoints se crean o modifican?

### 4. Crear carpeta de trabajo (si no existe)

Directorio en `.workflow/wip/`:
- Con ticket: `.workflow/wip/st-5837_banner-json-rendering/`
- Sin ticket: `.workflow/wip/banner-json-rendering/`
- Formato: `[id-ticket_]slug-descriptivo` (lowercase, kebab-case)

Si la carpeta ya existe (porque hay spec funcional), trabajar ahi.

### 5. Generar la spec tecnica

Crear `spec.md` (o actualizar el existente) en la carpeta de trabajo. Usar el template del directorio `templates/spec.md`. Asegurar que incluye:
- **Dominio formal:** inputs como tabla con tipos, constantes del sistema
- **Reglas de negocio:** logica formal (R1, R2... con notacion clara)
- **Invariantes:** condiciones que SIEMPRE se cumplen + que NO afecta a esta spec
- **Matriz completa de estados:** todas las combinaciones posibles de inputs → outputs
- **BDD exhaustivo:** escenarios que cubren cada fila de la matriz
- **Contrato API** (solo si la spec define/modifica un endpoint)

### 6. Preguntar dominio destino

"¿Cuando este feature se complete, a que dominio pertenece la spec?" (compliance, payments, frontend, etc.). Guardarlo en `state.yaml` como `target_domain`.

### 7. Crear/actualizar estado

Crear o actualizar `state.yaml` en la carpeta de trabajo:
```yaml
feature: [slug]
ticket: [ID o null]
phase: specifying
status: draft
spec_type: technical
approvals:
  po: { approved: [true si viene de funcional], by: [nombre], date: [fecha] }
  developer: { approved: false, by: null, date: null }
target_domain: [dominio destino]
```

### 8. Si hay detalles de implementacion valiosos

(flows, archivos existentes, bugs conocidos, coordinacion con otros equipos) → guardarlos en `_references/` dentro de la carpeta de trabajo.

### 9. Revisar con el developer

Presentar la spec. Verificar: "¿La matriz de estados cubre TODOS los casos?" El usuario itera hasta aprobar.

## Template

Busca template en `.workflow/templates/spec.md`. Si no existe, usa esta estructura:

```markdown
# SPEC — [titulo]

| Campo | Valor |
|-------|-------|
| Version | 1.0.0 |
| Tipo | Tecnica (Developer) |
| Owner | [dominio / equipo] |
| Scope | [una frase: que determina esta spec] |
| Estado | draft / approved |

---

## 1. Dominio Formal

### 1.1 Inputs

| Variable | Tipo | Descripcion |
|----------|------|-------------|
| [var] | [tipo] | [que representa] |

### 1.2 Constantes del sistema

```
[CONSTANTE] = [valores]
```

---

## 2. Reglas de Negocio (Source of Truth)

### R1 — [nombre de la regla]

```
[expresion formal de la regla]
```

### R2 — [nombre]

```
[expresion formal]
```

---

## 3. Invariantes

- [Condicion que SIEMPRE debe cumplirse]
- [Variable o concepto que NO afecta a esta spec]

---

## 4. Matriz Completa de Estados

| [Input A] | [Input B] | [Output] |
|-----------|-----------|----------|
| true | true | [valor] |
| true | false | [valor] |
| false | true | [valor] |
| false | false | [valor] |

No existen mas combinaciones posibles en esta spec.

---

## 5. BDD — Escenarios Exhaustivos

### Scenario: [titulo descriptivo]

Given [contexto]
And [condicion]
When [accion]
Then [resultado esperado]

---

## 6. Contrato API (si aplica)

```yaml
POST /api/[recurso]:
  request:
    [campo]: [tipo]
  response:
    [campo]: [tipo]
  errors:
    [codigo]: [descripcion]
```

---

## Fuera de Alcance

- [Exclusion explicita y por que]
```

## Siguiente Paso

Spec tecnica aprobada. Invoca `teamflow:planning` para crear el plan de implementacion.
