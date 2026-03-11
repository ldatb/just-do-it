---
name: do:save
description: Save current session state for later resumption.
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
---

<objective>
Save current session state so work can be resumed later with `/do:resume`.
</objective>

<execution_context>
@workflows/save.md
@references/session-continuity.md
</execution_context>

<process>
**Follow the save workflow** from `@workflows/save.md`.
</process>
