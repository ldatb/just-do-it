---
name: do:settings
description: View or modify project settings (model profile, agents, parallelization).
argument-hint: <setting value>
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
---

<objective>
View or change project configuration.
</objective>

<execution_context>
@workflows/settings.md
@references/model-profiles.md
</execution_context>

<context>
Arguments: $ARGUMENTS (optional setting change, e.g. "model_profile quality")
</context>

<process>
**Follow the settings workflow** from `@workflows/settings.md`.
</process>
