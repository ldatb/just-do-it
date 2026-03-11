---
name: do:verify
description: Verify the current or specified phase with specialist review agents.
argument-hint: <phase number>
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
  - Agent
---

<objective>
Run multi-specialist verification on a completed phase.
</objective>

<execution_context>
@workflows/verify.md
@references/agent-roster.md
@references/model-profiles.md
@references/verification-patterns.md
</execution_context>

<context>
Arguments: $ARGUMENTS (optional phase number)
</context>

<process>
**Follow the verify workflow** from `@workflows/verify.md`.
</process>
