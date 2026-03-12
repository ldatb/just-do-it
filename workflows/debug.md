<purpose>
Debug an issue using scientific method. Dispatch do-debugger to investigate, reproduce, hypothesize, and fix.
Standalone entry point for bug investigation outside the build pipeline.
</purpose>

<process>

## 1. Initialize

1. Read `.work/STATE.md` and `.work/config.json` if they exist
2. Read `.work/context/project.md` and `.work/context/engineering.md` if they exist
3. If `.work/` does not exist, proceed anyway - debugging works without project state

## 2. Gather Context

From $ARGUMENTS, identify:
- **Symptoms**: what's going wrong (error message, unexpected behavior, failing test)
- **Location**: which files/modules/endpoints are involved (if known)
- **Reproduction**: how to trigger the issue (if known)

If $ARGUMENTS is vague, ask one clarifying question:

Use AskUserQuestion:
- header: "Debug"
- question: "Can you tell me more about the issue?"
- options:
  - "Here's the error message" - user will paste error
  - "A test is failing" - user will specify which test
  - "Unexpected behavior" - user will describe what happens vs expected
  - "Performance issue" - something is slow

## 3. Investigate

Resolve model for `do-debugger` from config (or use balanced default).

Dispatch `do-debugger` agent with:
- The bug description from $ARGUMENTS
- Project context files (if available)
- Engineering context (if available)
- Instructions to:
  1. Read relevant source files
  2. Reproduce the issue if possible (run tests, check logs)
  3. Form hypotheses about root cause
  4. Test each hypothesis
  5. Identify the fix

If performance-related, also dispatch `do-perf` in parallel.

## 4. Present Findings

Show the user:
- **Root cause**: what's wrong and why
- **Evidence**: what confirms the diagnosis
- **Proposed fix**: what to change

Use AskUserQuestion:
- header: "Fix"
- question: "Found the issue. Apply the fix?"
- options:
  - "Yes, fix it" - apply the proposed changes
  - "Show me the details" - see full investigation before deciding
  - "I'll fix it myself" - user takes over with the diagnosis info
  - "Investigate more" - not convinced, dig deeper

## 5. Apply Fix

If user approves:
1. Dispatch `do-coder` to implement the fix (or apply directly if simple)
2. Run relevant tests to verify the fix
3. Show results

If git is configured:

Use AskUserQuestion:
- header: "Commit Fix"
- question: "Fix applied and tests pass. Commit?"
- options:
  - "Yes, commit" - commit with `fix: <description>`
  - "Edit message" - modify commit message
  - "Skip" - don't commit

## 6. Update State

If `.work/STATE.md` exists, update:
- Last Action: "Debug: [issue summary]"
- Next Action: ready for next task

</process>
