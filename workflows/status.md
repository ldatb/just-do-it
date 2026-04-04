<purpose>
Show current project status: position in workflow, phase progress, and what to do next.
Offers context-sensitive navigation so the user can resume, review, or change direction.
</purpose>

<process>

## 1. Check Project Exists

Check if `.work/` directory exists.

**If not:** Inform user no project is initialized. Suggest `/do:start`.
Stop here — do not show a navigation question.

## 2. Load State

1. Read `.work/STATE.md`
2. Read `.work/PROJECT.md`
3. List phase directories in `.work/phases/`

## 3. Display Status

Show a concise status report:

```
Project: <name from PROJECT.md>
Phase: XX-<name> (step: <current step>)
Status: <status>

Phases:
  [x] 01-<name> - complete
  [>] 02-<name> - in progress (build, wave 2 of 3)
  [ ] 03-<name> - pending

Next: <next action from STATE.md>
```

## 4. Navigation Question

Immediately after displaying status, present context-sensitive options based on STATE.md.
Only show options that make sense for the current state.

### If mid-phase (build or verify in progress)

Use AskUserQuestion:
- header: "Continue"
- question: "[phase-name] is in progress ([step], [wave N of M if applicable]). What would you like to do?"
- options:
  - "Continue from where I left off (Recommended)" - resume [next action from STATE.md]
  - "Show what was built" - review BUILD.md before continuing
  - "Re-verify previous phase" - run verify again on the last completed phase
  - "Stop" - exit; resume later with /do:status or /do:start

### If phase complete and next phase pending

Use AskUserQuestion:
- header: "Continue"
- question: "[current-phase] is complete. Ready to start [next-phase]?"
- options:
  - "Start [next-phase] (Recommended)" - begin next planned phase
  - "Review [current-phase] results" - check BUILD.md and VERIFY.md before moving on
  - "Re-verify [current-phase]" - run verify again
  - "Stop" - exit; resume later with /do:status or /do:start

### If all phases complete

Use AskUserQuestion:
- header: "Continue"
- question: "All phases complete. What would you like to do?"
- options:
  - "Start a new phase (Recommended)" - define the next thing to build
  - "Review final results" - see the full build and verify summary
  - "Stop" - nothing more to do right now

### If no phases exist yet (project initialized but nothing started)

Use AskUserQuestion:
- header: "Continue"
- question: "Project initialized but no phases started. What would you like to do?"
- options:
  - "Start building (Recommended)" - run /do:start with a task description
  - "Stop" - exit for now

## 5. Handle Selection

**"Continue from where I left off" / "Start [next-phase]" / "Start a new phase" / "Start building":**
Invoke the start workflow directly. Pass the current STATE.md context as input so it resumes correctly.

**"Show what was built" / "Review [current-phase] results" / "Review final results":**
Read and display BUILD.md and VERIFY.md for the relevant phase. After displaying, re-present the same navigation question.

**"Re-verify [previous/current] phase":**
Invoke the verify workflow for that phase.

**"Stop":**
Exit. Print: "Run /do:status anytime to return."

</process>
