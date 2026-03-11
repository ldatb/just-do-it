---
name: do:build
description: Build the current or specified phase by dispatching specialist agents.
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
Execute a phase's plan by dispatching specialist agents in wave order.
</objective>

<execution_context>
@workflows/build.md
@references/agent-roster.md
@references/model-profiles.md
</execution_context>

<context>
Arguments: $ARGUMENTS (optional phase number)
</context>

<process>
**Follow the build workflow** from `@workflows/build.md`.
</process>
