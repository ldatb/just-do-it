<purpose>
Execute the current or specified phase's plan. Dispatches specialist agents per task in wave order.
Always interactive - user approves each wave and each commit.
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
2. Show what will be executed:

   Use AskUserQuestion:
   - header: "Wave N - [N tasks]"
   - question: "Dispatching agents: [list]. Proceed?"
   - options:
     - "Yes, execute this wave"
     - "Skip this wave"
     - "Save for later" - save state and stop

3. For each task:
   - Resolve the model for the task's agent using config
   - Prepare the task prompt with:
     - Project context files (.work/context/)
     - Phase plan (PLAN.md path)
     - Specific task details
     - Files to read/modify
4. Dispatch all wave tasks in parallel (up to `max_concurrent`)
5. Collect results from all agents
6. Update BUILD.md with results
7. Update STATE.md with wave progress

**If any task fails:**

Use AskUserQuestion:
- header: "Task Failed"
- question: "[Agent] failed: [error summary]. What to do?"
- options:
  - "Retry" - run the task again
  - "Skip" - continue without this task
  - "Debug" - dispatch do-debugger to investigate
  - "Stop" - save state and stop

### Git After Each Wave

If code was modified and `git.conventional_commits` is true:

1. Show changed files and propose commit message (conventional format)

   Use AskUserQuestion:
   - header: "Commit Wave N Changes"
   - question: "Commit: '<type>: <description>'?\n\nFiles: [list]"
   - options:
     - "Yes, commit"
     - "Edit message"
     - "Skip commit"

2. Stage specific files (never `git add .`)
3. Commit only if user approves

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
