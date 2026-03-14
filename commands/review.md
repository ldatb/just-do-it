---
name: do:review
description: Code review with all relevant specialist agents.
argument-hint: <path, PR number, or empty for uncommitted changes>
allowed-tools:
  - Read
  - Write
  - Bash
  - Glob
  - Grep
  - Agent
---

<objective>
Multi-specialist code review of files, PRs, or uncommitted changes.
</objective>

<execution_context>
@workflows/review.md
@references/agent-roster.md
@references/model-profiles.md
</execution_context>

<context>
Arguments: $ARGUMENTS (file path, directory path, PR number, or empty)
</context>

<process>
**Follow the review workflow** from `@workflows/review.md`.
</process>
