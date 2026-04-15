---
name: teamflow:status
description: "Show current project state"
allowed-tools:
  - Read
---

Read `.workflow/state.md` and present a summary of the current project state: active feature, phase, progress, recent decisions, and blockers. If no `.workflow/state.md` exists, inform the user that no TeamFlow project is active.
