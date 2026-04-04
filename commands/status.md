---
name: do:status
description: Show project state, navigate, or resume work.
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Bash
  - AskUserQuestion
---

<objective>
Display project position, phase progress, and offer navigation or resume options based on current state.
</objective>

<execution_context>
@workflows/status.md
</execution_context>

<process>
**Follow the status workflow** from `@workflows/status.md`.

The workflow handles:
1. Reading STATE.md, PROJECT.md, and config.json
2. Displaying a concise project context block
3. Presenting context-sensitive navigation options (continue, review, re-verify, or start new phase)
4. Resuming work if the user selects continue - absorbs the former /do:resume use case
</process>
