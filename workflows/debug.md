<purpose>
Debug an issue using scientific method. Dispatch do-debugger to investigate, reproduce, hypothesize, and fix.
Standalone entry point for bug investigation outside the build pipeline.
Config-driven: only prompts when genuinely ambiguous or when presenting fix options.
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

If $ARGUMENTS is too vague to act on (less than a few words, no error info), ask one clarifying question:

Use AskUserQuestion:
- header: "Debug"
- question: "Can you describe what's going wrong?"
- options:
  - "An error is being thrown (Recommended)" - I'll share the error message or stack trace
  - "A test is failing" - a specific test is not passing
  - "Behavior is wrong but no error" - something produces the wrong result silently
  - "It's slow" - performance problem, not a crash or wrong output

After the user selects, ask one targeted follow-up question to gather the specific detail needed:
- For "An error is being thrown": ask what the error message or stack trace says
- For "A test is failing": ask which test or test file is failing
- For "Behavior is wrong but no error": ask what input triggers the wrong result and what the wrong result is
- For "It's slow": ask which operation or endpoint is slow and at what scale

Maximum one follow-up question. Then proceed to investigation.

If $ARGUMENTS is specific enough, skip the prompt and proceed directly to investigation.

## 3. Investigate

Resolve model for `do-debugger` from config (or use balanced default).

**Use the Agent tool** to dispatch `do-debugger` agent with:
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

## 4. Present Findings and Apply Fix

Show the user:
- **Root cause**: what's wrong and why
- **Evidence**: what confirms the diagnosis
- **Proposed fix**: what to change

Use AskUserQuestion:
- header: "Fix"
- question: "Found the issue. Apply the fix?"
- options:
  - "Fix it now (Recommended)" - apply the proposed changes immediately
  - "Show details" - see full investigation log, evidence, and code context before deciding
  - "I'll fix it myself" - take over with the diagnosis info in hand

When user selects "Show details":
1. Display the full investigation: root cause explanation, evidence trail, affected files and line numbers, code context, and the proposed change.
2. Re-present the exact same AskUserQuestion (same header, same question, same options).

## 5. Commit (if fix applied)

If fix was applied and `git.auto_commit` is true in config:
- Print: "Auto-committing: fix: <description> (<N> files)..."
- Auto-commit with `fix: <description>` message
- Stage only the modified files

If `auto_commit` is false: ask user before committing.

## 6. Update State

If `.work/STATE.md` exists, update:
- Last Action: "Debug: [issue summary]"
- Next Action: ready for next task

</process>
