<purpose>
Internal workflow — invoked by start.md and status.md, not directly by users. The /do:resume command has been removed.

Resume work from the last saved session state. Used internally by start.md when returning to
an existing project. Use /do:start or /do:status to return to a project.
</purpose>

<process>

## 1. Load State

1. Read `.work/STATE.md`
2. Read `.work/PROJECT.md`
3. Read the current phase directory

**If `.work/` doesn't exist:** Error - no project to resume. Suggest `/do:start`.

## 2. Display Context

Show the user:
```
Project: <name>
Phase: <phase-name> (<step>)
Last: <last action taken>
Next: <next action planned>
```

Include phase list if multiple phases exist:
```
Phases:
  [x] 01-<name> - complete
  [>] 02-<name> - in progress
```

## 3. Resume

Based on STATE.md content, derive the next action and present navigation options.

Use AskUserQuestion:
- header: "Resume"
- question: "<project name> - <current phase> (<step>). What would you like to do?"
- options:
  - "<next action from STATE.md> (Recommended)" - resume from last saved position
  - "Show what was done" - review last completed step before continuing
  - "Jump to a different phase" - navigate to a specific phase in this project
  - "Stop" - exit without resuming

The first option must be the specific next action from STATE.md (e.g., "Continue build wave 3", "Start verify phase", "Start next phase"). Do not use a generic label.

**If "Show what was done" is selected:**
1. Display the relevant file for the last completed step (BUILD.md, RESEARCH.md, or PLAN.md).
2. Re-present the exact same AskUserQuestion (same header, same question, same options).

**If "Jump to a different phase" is selected:**
- List available phases and ask which one to navigate to.
- Use AskUserQuestion with the phase names as options.
- After selection, update STATE.md to point to that phase and proceed.

**If "Stop" is selected:**
- Exit cleanly. State is already saved.

## 4. Execute

Proceed with the appropriate workflow step based on the user's selection:
- Research phase -> run research workflow
- Plan phase -> run plan workflow
- Build phase -> run build workflow (from the correct wave)
- Verify phase -> run verify workflow
- Fix issues -> show VERIFY.md findings, start fixing
- Start next phase -> create next phase directory, run start

</process>
