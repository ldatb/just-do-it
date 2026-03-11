---
name: do:plan
description: Plan the current or specified phase.
argument-hint: <phase number>
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
  - Agent
  - WebFetch
  - WebSearch
---

<objective>
Create an executable plan for a phase with tasks, waves, and success criteria.
</objective>

<execution_context>
@workflows/plan.md
@references/agent-roster.md
@references/model-profiles.md
</execution_context>

<context>
Arguments: $ARGUMENTS (optional phase number)
</context>

<process>
**Follow the plan workflow** from `@workflows/plan.md`.
</process>
