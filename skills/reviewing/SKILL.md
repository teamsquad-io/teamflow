---
name: reviewing
description: "Use when implementation is complete and code needs adversarial review against the spec, or when invoked via /review"
---

# Reviewing: Code Review Adversarial

## Overview
Despacha un reviewer adversarial que verifica el codigo contra el spec y el plan. El reviewer NO confia en lo que el implementador dice que hizo. Incluye danger scan automatico contra el Bug Map y verificacion visual con Playwright.

## El Proceso

1. **Cargar contexto:** Lee el `spec.md`, `plan.md` y `tasks.md` del feature activo.

2. **Obtener diff:** Ejecuta `git diff` para capturar todos los cambios del feature. Si el feature tiene multiples commits, usa `git log` para identificar el rango y `git diff` sobre ese rango.

3. **Danger Scan:** Analiza el diff contra el Bug Map:
   a. Lee `.bugmap/index.json`
   b. Extrae la lista de ficheros modificados del diff
   c. Para cada fichero, busca en `file_index` del bug map
   d. Genera un DANGER REPORT:

   ```
   ## ⚠️ DANGER REPORT
   
   Este PR toca N ficheros en zonas con historial de bugs:
   
   ### 🔴 CRITICAL: [Nombre Area] (N bugs, N sprints)
   - Ficheros afectados: [lista]
   - Patron recurrente: [descripcion]
   - Verificaciones requeridas:
     - [ ] [verificacion especifica del bug map]
     - [ ] [verificacion del Skill del componente]
   
   ### 🟠 HIGH: [Nombre Area] (N bugs, N sprints)
   - ...
   ```
   
   Si ningun fichero del diff esta en el bug map con level >= medium:
   ```
   ## ✅ DANGER REPORT: Sin zonas de riesgo detectadas
   ```
   
   e. Si existe un Skill para el componente en `.claude/skills/`, leer la seccion "Reglas al modificar"

4. **Despachar tf-reviewer:** Usa el Agent tool con `subagent_type: "teamflow:tf-reviewer"`. Pasa inline:
   - Spec completo (success criteria y acceptance criteria)
   - Plan (decisiones tecnicas)
   - Diff del codigo
   - **DANGER REPORT generado en paso 3**
   - **Framing adversarial:** "El implementador termino sospechosamente rapido. NO confies en su reporte. Verifica TODO contra el codigo real. Verifica CADA acceptance criteria contra el codigo REAL, no contra lo que el implementador dice que hizo."
   - **Checklist de shortcuts:** Busca activamente: logica simplificada sin edge cases, valores hardcodeados, tests que no testean (asserts triviales, mocks auto-replicantes), TODOs/placeholders, error handling ausente o generico, codigo muerto.
   - **Instruccion adicional:** "Presta especial atencion a las verificaciones del DANGER REPORT. Si el PR toca una zona CRITICAL, verifica CADA punto del checklist contra el codigo real."

5. **Playwright (EXPERIMENTAL):**
   Despues del review estatico, si el PR modifica ficheros de UI (componentes, estilos, vistas):
   a. Abrir browser con Playwright MCP (`browser_navigate`)
   b. Navegar a las paginas afectadas por el cambio
   c. Tomar screenshots de los componentes modificados (`browser_take_screenshot`)
   d. Verificar que no hay errores en consola (`browser_console_messages`)
   e. Si hay danger zone: ejecutar el flujo descrito en el Skill del componente
   f. Verificar responsive: desktop (1280x800) + mobile (375x812) via `browser_resize`
   
   **Nota:** Este paso es experimental. Si Playwright no puede completar la verificacion (timeout, elementos no encontrados, entorno no disponible), continuar sin el y documentar en el review que la verificacion visual no se pudo completar.

6. **Ejecutar tests:**
   Ejecutar `npm test` en el directorio del frontend para verificar que no hay regresiones.

7. **Evaluar veredicto:**
   - **PASS** — Codigo cumple spec, danger checks OK. Proceder a producing.
   - **PASS_WITH_NOTES** — Cumple pero con observaciones menores. Proceder con las notas registradas.
   - **NEEDS_CHANGES** — Hallazgos que requieren correccion. Volver a executing con los hallazgos como nuevas tareas.
   
   Criterio adicional: si el DANGER REPORT tiene items CRITICAL sin verificar → NEEDS_CHANGES.

8. **Escribir review:** Crea `review.md` en el directorio del feature con:
   - Hallazgos, severidad y veredicto
   - DANGER REPORT incluido
   - Screenshots de Playwright (si se hicieron)
   - Resultado de tests
   - Si el Visual Verifier es necesario (multi-marca, flujos E2E complejos):
   ```
   ## 🔍 REQUIERE VISUAL VERIFIER
   Razon: [por que se necesita verificacion visual profunda]
   Flujos a verificar: [lista]
   ```

9. **Si NEEDS_CHANGES:** Agrega los hallazgos como tareas nuevas al final de `tasks.md` y actualiza `state.yaml` para volver a fase executing.

## Errores Comunes
- Revisar sin el spec — el review pierde su ancla objetiva
- Confiar en el reporte del implementador sin verificar el codigo real
- Ignorar el DANGER REPORT — si hay danger zones, las verificaciones son OBLIGATORIAS
- No ejecutar tests — un review sin tests es incompleto

## Siguiente Paso
"Review aprobado. Invoca teamflow:producing para finalizar."
