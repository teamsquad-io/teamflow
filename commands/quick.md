---
name: teamflow:quick
description: "Quick fix without formal spec"
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Grep
  - Glob
  - Task
---

Quick fix flow — bypasses the formal spec process for small, obvious changes.

1. Ask the user to describe the problem or change needed.
2. Implement directly. Make an atomic commit with format: `fix(<scope>): <description>`.
3. Optionally dispatch `tf-reviewer` for a mini-review if the change touches more than 2 files.
4. Register the change in `history/summaries/quick-YYYY-MM-DD-slug.md` with: date, description, files changed, and commit hash.

Use this ONLY for small fixes, typos, config tweaks, or minor bug fixes. If the change requires design decisions or touches architecture, redirect the user to `/spec` instead.
