---
name: do:research
description: Research a topic, technology, or approach before implementing.
argument-hint: <topic or question to research>
allowed-tools:
  - Read
  - Write
  - Bash
  - Glob
  - Grep
  - Agent
  - WebFetch
  - WebSearch
---

<objective>
Standalone research on a topic. Dispatches do-researcher to investigate and produces RESEARCH.md.
</objective>

<execution_context>
@workflows/research.md
@references/agent-roster.md
@references/model-profiles.md
</execution_context>

<context>
Arguments: $ARGUMENTS (topic, technology, question, or comparison to research)
</context>

<process>
**Follow the research workflow** from `@workflows/research.md`.
</process>
