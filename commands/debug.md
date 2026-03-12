---
name: do:debug
description: Debug an issue with the debugger specialist agent.
argument-hint: <description of the bug or error>
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
Investigate and fix a bug using the do-debugger specialist. Scientific debugging: hypothesize, test, fix.
</objective>

<execution_context>
@workflows/debug.md
@references/agent-roster.md
@references/model-profiles.md
</execution_context>

<context>
Arguments: $ARGUMENTS (bug description, error message, or symptoms)
</context>

<process>
**Follow the debug workflow** from `@workflows/debug.md`.
</process>
