---
name: do:discover
description: Scan an existing codebase and generate project-specific context files for all agents.
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
Discover and analyze an existing codebase. Generate project-specific context files in
.work/context/ that customize agent behavior for this project.
</objective>

<execution_context>
@workflows/discover.md
@references/context-layering.md
@references/agent-roster.md
@references/model-profiles.md
</execution_context>

<process>
**Follow the discover workflow** from `@workflows/discover.md`.

Dispatch 4 parallel research agents to analyze:
1. Stack and structure
2. Architecture and patterns
3. Quality and testing
4. Conventions and concerns

Compile findings into layered context files in `.work/context/`.
</process>
