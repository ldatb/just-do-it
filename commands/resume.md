---
name: do:resume
description: Resume work from the last saved session state.
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
Resume from saved session state in STATE.md.
</objective>

<execution_context>
@workflows/resume.md
@references/session-continuity.md
@references/agent-roster.md
@references/model-profiles.md
</execution_context>

<process>
**Follow the resume workflow** from `@workflows/resume.md`.
</process>
