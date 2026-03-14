---
name: do:setup
description: Interactive project setup. Answer questions to generate project-specific context files.
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
  - Agent
---

<objective>
Interactive setup for a new or existing project. Gather information to generate
project-specific context files that customize agent behavior.
</objective>

<execution_context>
@workflows/setup.md
@references/agent-roster.md
</execution_context>

<process>
**Follow the setup workflow** from `@workflows/setup.md`.

Ask targeted questions based on project type, then generate context files.
</process>
