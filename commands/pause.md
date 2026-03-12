---
name: do:pause
description: Pause and save current session state. Alias for /do:save.
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
---

<objective>
Save current session state so work can be resumed later with `/do:resume`.
This is an alias for `/do:save` - both commands do the same thing.
</objective>

<execution_context>
@workflows/save.md
@references/session-continuity.md
</execution_context>

<process>
**Follow the save workflow** from `@workflows/save.md`.
</process>
