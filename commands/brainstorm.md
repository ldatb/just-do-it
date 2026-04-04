---
name: do:brainstorm
description: Brainstorm with Claude to explore and refine what to build before starting
argument-hint: <optional topic or idea to explore>
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
  - AskUserQuestion
---

<objective>
Interactive brainstorming session to explore, refine, and scope an idea before committing to a full pipeline.
</objective>

<execution_context>
@workflows/brainstorm.md
@references/agent-roster.md
</execution_context>

<context>
Arguments: $ARGUMENTS (optional topic, idea, or problem to brainstorm about)
</context>

<process>
**Follow the brainstorm workflow** from `@workflows/brainstorm.md`.

The workflow handles:
1. Opening the conversation (or picking up from $ARGUMENTS)
2. Interactive exploration loop - clarifying, suggesting, narrowing
3. Saving brainstorm summary to the phase directory
4. Directly invoking the start pipeline when the user selects "Start building" - no manual command needed
</process>
