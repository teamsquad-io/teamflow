---
name: planning
description: "Use when the user needs a technical plan, wants to decide how to build something, or needs architecture decisions before coding. Triggers on: /plan, 'how should we build this', 'technical approach', 'architecture for this feature', 'create the plan'. Also use when there is an approved spec that needs a technical plan."
---

# Planning: De Spec a Plan Tecnico

Convierte un spec aprobado en un plan tecnico con decisiones, estructura de cambios y validacion constitucional.

## Cuando Usar
- Hay un spec aprobado que necesita plan tecnico.
- El usuario invoca `/plan`.
- Se necesita tomar decisiones de arquitectura antes de implementar.

## El Proceso

1. **Leer el spec aprobado.** Abre `.workflow/wip/[feature-name]/spec.md`. Verifica que el estado sea `approved`. Si no lo esta, advierte y pregunta si continuar.

2. **Leer contexto del proyecto (solo lo necesario).** Lee:
   - `.workflow/constitution.md` (principios y reglas)
   - `.workflow/components.yaml` — identifica que componentes afecta el feature
   - **Solo las guidelines de componentes afectados.** Lee `.workflow/platform/components/<componente>.md` solo para los componentes que el feature toca. NUNCA cargues todas las guidelines a la vez.
   - Si una guideline excede ~20KB, lee solo las primeras 50 lineas (TOC/overview) y carga secciones relevantes bajo demanda.

3. **Investigar codigo real (OBLIGATORIO).** Antes de generar el plan, investiga el codigo existente usando el MCP indexer de codigo (teamsquad-indexer) u otras herramientas de busqueda disponibles. NUNCA generes un plan basado en asunciones sobre el codigo — las asunciones causan retrabajos.

   - **Buscar componentes afectados:** Usa `search_code` para localizar los simbolos principales que el feature toca.
   - **Leer source de componentes clave:** Usa `get_symbol(include_source=true)` para entender la logica actual de los componentes que se van a modificar.
   - **Mapear dependencias:** Usa `find_references` para entender quien importa/usa cada componente. Esto revela flujos separados, consumidores ocultos y side effects.
   - **Descubrir patrones existentes:** Identifica selectores, hooks, contextos, tipos y convenciones que el plan debe reutilizar (no reinventar).
   - **Documentar hallazgos:** Los descubrimientos tecnicos relevantes (flujos separados, componentes que no hacen lo que parece, datos que vienen de sitios inesperados) se documentan como IT-xxx en el plan.

   Si no hay MCP indexer disponible, usar Grep/Glob/Read para la misma investigacion. Lo importante es investigar, no la herramienta.

4. **Generar el plan.** Crea `.workflow/wip/[feature-name]/plan.md` con:
   - **Componentes afectados** (tags de componente, tipo de cambio)
   - **Investigacion tecnica** (IT-001... hallazgos del paso 3)
   - **Decisiones tecnicas** (DT-001... con contexto, opciones evaluadas, decision, rationale)
   - **Estructura de cambios** por componente (archivos, tipo, descripcion)
   - **Riesgos y mitigaciones**

5. **Constitutional gate check.** Si existe `.workflow/constitution.md`, verifica que cada principio y regla se respete. Documenta la verificacion en el plan.

6. **Validar trazabilidad.** Cada regla de negocio (R-xxx) del spec debe estar cubierto por al menos una entrada en la estructura de cambios. Si falta cobertura, corregir.

7. **Actualizar estado.** Mueve `state.yaml` a fase `planning`, estado `draft`.

8. **Revisar con el usuario.** Presenta el plan y pide aprobacion.

## Template
Busca template en `.workflow/templates/plan.md`. Si no existe, usa la estructura descrita arriba.

## Errores Comunes
- Crear plan sin investigar el codigo real — genera planes basados en asunciones que causan retrabajos (ej: asumir un flujo unico cuando hay dos separados, asumir que un componente ejecuta una accion cuando solo selecciona datos).
- Crear plan sin leer la constitution — puede violar principios del proyecto.
- No validar trazabilidad spec->plan — requisitos se pierden silenciosamente.
- Decisiones tecnicas sin rationale — se olvida el "por que" y se repite el debate.

## Siguiente Paso
Plan aprobado. Invoca `teamflow:tasking` para desglosar en tareas atomicas.
