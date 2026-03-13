<purpose>
Execute the current or specified phase's plan. Dispatches specialist agents per task in wave order.
The plan is already approved — just execute it. Only ask on task failure.

**You are an orchestrator.** Use the Agent tool to dispatch specialist agents.
Do NOT write application code yourself.
</purpose>

<process>

## 1. Load Context

1. Read `.work/STATE.md` for current position
2. Read `.work/config.json` for model profiles and settings
3. Determine which phase to build:
   - If $ARGUMENTS contains a phase number, use that
   - Otherwise, use current phase from STATE.md
4. Read `.work/phases/XX-<name>/PLAN.md`

**If no PLAN.md exists:** Error - run `/do:plan` first.

## 2. Execute Waves

For each wave in PLAN.md:

1. Collect all tasks in this wave
2. For each task:
   - Resolve the model for the task's agent using config
   - Prepare the task prompt with:
     - Project context files (.work/context/)
     - Phase plan (PLAN.md path)
     - Specific task details
     - Files to read/modify
3. **Use the Agent tool** to dispatch all wave tasks in parallel (up to `max_concurrent`)
4. Collect results from all agents
5. Update BUILD.md with results
6. Update STATE.md with wave progress
7. Brief status update to user: "Wave N complete. [summary of what was done]."

**CRITICAL: "Dispatch" means use the Agent tool with the correct `subagent_type` (e.g., `do-coder`, `do-architect`, `do-security`).
You are an orchestrator. You do NOT write application code yourself. You launch specialist agent subprocesses.**

**No decision questions during build.** The plan was already approved. Just execute it.

### File Permissions for Agents

Subagents inherit the parent's permission settings but CANNOT prompt for new permissions —
they fail silently if denied. To prevent this:

1. **Use absolute paths** in agent prompts — list every file the agent will need to create or modify
2. **If agents need to write outside the project directory** (e.g., external repos, shared packages),
   tell the user upfront which paths will be touched and let them approve before dispatching
3. **If an agent fails due to permissions**, surface it to the user immediately — do NOT silently
   retry or do the work yourself

### Handling Agent Failures

**If any task fails:**

Use AskUserQuestion:
- header: "Task Failed"
- question: "[Agent] failed: [error summary]. What to do?"
- options:
  - "Retry" - run the task again
  - "Skip" - continue without this task
  - "Debug" - dispatch do-debugger to investigate
  - "Stop" - save state and stop

**CRITICAL: Do NOT silently fall back to doing the agent's work yourself.** If an agent fails,
the user must know. The orchestrator does not write application code — ever. If retries fail,
ask the user to intervene.

### Git After Each Wave

If code was modified and `git.conventional_commits` is true in config:

1. Generate a conventional commit message from the wave's task descriptions and changed files
2. Stage specific files changed during this wave (never `git add .`)
3. Commit automatically - do not prompt

If `git.conventional_commits` is false or absent, skip the commit step entirely.

## 3. Compile Results

Write `BUILD.md` in the phase directory with:
- Execution log per wave
- Decisions made by agents
- Issues encountered
- Files modified (complete list)

## 4. Update State

Update STATE.md:
- Step: build
- Status: complete
- Next Action: "Verify phase XX"

</process>
