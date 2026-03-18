---
name: specifying
description: "Router: when a user wants to create a spec, asks whether functional (PO) or technical (developer) and delegates. Triggers on: /spec, 'I want to build X', 'new feature', 'let's add X', 'define requirements for', 'what should we build'. This is the starting point of the TeamFlow workflow."
---

# Specifying: Router de Specs

Este skill es un **router**. Antes de hacer nada, pregunta al usuario que tipo de spec quiere crear y delega al skill correspondiente.

## Paso 1: Preguntar tipo

Presenta esta pregunta al usuario:

> **¿Que tipo de spec quieres crear?**
>
> 1. **Funcional (PO)** — Reglas de negocio, sin decisiones tecnicas. Para definir QUE tiene que hacer el feature desde la perspectiva del producto.
> 2. **Tecnica (Developer)** — Dominio formal, contratos API, constantes del sistema. Para formalizar la spec con detalle tecnico.

## Paso 2: Delegar

- Si elige **1 (funcional/PO)**: invocar `teamflow:spec-functional` con los argumentos originales.
- Si elige **2 (tecnica/developer)**: invocar `teamflow:spec-tech` con los argumentos originales.

No hacer nada mas. Solo preguntar y delegar.
