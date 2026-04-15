---
name: teamflow:spec
description: "Router: asks whether the user wants a functional (PO) or technical (developer) spec, then delegates to the right skill"
allowed-tools:
  - Skill
---

Before doing anything else, ask the user:

> **¿Qué tipo de spec quieres crear?**
>
> 1. **Funcional (PO)** — Reglas de negocio, sin decisiones técnicas. Para definir QUÉ tiene que hacer el feature desde la perspectiva del producto. → `/spec-functional`
> 2. **Técnica (Developer)** — Dominio formal, contratos API, constantes del sistema. Para formalizar la spec con detalle técnico. → `/spec-tech`

Wait for the user's answer. Then:
- If they choose **1 (funcional/PO)**: invoke the `teamflow:spec-functional` skill with any arguments that were passed to this command.
- If they choose **2 (técnica/developer)**: invoke the `teamflow:spec-tech` skill with any arguments that were passed to this command.
