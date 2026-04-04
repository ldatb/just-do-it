---
name: do:start
description: Begin or continue a project task. Handles first-run setup, returning-user continuation, discovery, and the full research-plan-build-verify pipeline.
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
Primary entry point for all project work. On first run: initializes the project, asks up to 3 setup questions, runs discovery if an existing codebase is detected, then proceeds to the pipeline. On return: displays project context and offers context-sensitive navigation, or proceeds directly if an argument is provided.
</objective>

<execution_context>
@workflows/start.md
@references/agent-roster.md
@references/model-profiles.md
</execution_context>

<context>
Arguments: $ARGUMENTS (description of what to build or accomplish; may be empty if returning to an existing project)
</context>

<process>
**Follow the start workflow** from `@workflows/start.md`.

The workflow handles:
1. First-run detection and initialization (absorbs setup and discover)
2. Returning-user context display and navigation (absorbs resume)
3. Phase creation and git branch management
4. Research -> Plan -> Build -> Verify pipeline
5. Session state management throughout

Use the agent roster from `@references/agent-roster.md` to determine which specialists to dispatch.
Use model profiles from `@references/model-profiles.md` to resolve models for each agent.
</process>
