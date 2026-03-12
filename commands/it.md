---
name: do:it
description: Just do it. Skip ceremony, execute fast. For well-understood tasks.
argument-hint: <what to do>
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
Execute a task with minimal ceremony. No brainstorming, brief research, single-wave plan, fast verification. For when you know what you want and just need it done.
</objective>

<execution_context>
@workflows/go.md
@references/agent-roster.md
@references/model-profiles.md
</execution_context>

<context>
Arguments: $ARGUMENTS (what to do - be specific)
</context>

<process>
**Follow the go workflow** from `@workflows/go.md`.

This is the fast lane: initialize if needed, quick research, minimal plan, build, quick verify.
Only stops for git approval and CRITICAL findings.
</process>
