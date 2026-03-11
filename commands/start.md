---
name: do:start
description: Start a new phase or project. Full pipeline - research, plan, build, verify.
argument-hint: <description of what to build>
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
Initialize project (if needed) and run the full execution pipeline for a phase.
</objective>

<execution_context>
@workflows/start.md
@references/agent-roster.md
@references/model-profiles.md
@references/session-continuity.md
</execution_context>

<context>
Arguments: $ARGUMENTS (description of what to build or accomplish)
</context>

<process>
**Follow the start workflow** from `@workflows/start.md`.

The workflow handles:
1. Project initialization (if `.work/` doesn't exist)
2. Phase creation
3. Research -> Plan -> Build -> Verify pipeline
4. Session state management throughout

Use the agent roster from `@references/agent-roster.md` to determine which specialists to dispatch.
Use model profiles from `@references/model-profiles.md` to resolve models for each agent.
</process>
