<purpose>
Verify the current or specified phase by dispatching specialist review agents in parallel.
In fast mode, only QA + reviewer. In normal mode, all relevant specialists.
</purpose>

<process>

## 1. Load Context

1. Read `.work/STATE.md` for current position
2. Read `.work/config.json` for settings and model profiles
3. Determine which phase to verify:
   - If $ARGUMENTS contains a phase number, use that
   - Otherwise, use current phase from STATE.md
4. Read `.work/phases/XX-<name>/BUILD.md` for what was built
5. Read `.work/phases/XX-<name>/PLAN.md` for what was planned

**If no BUILD.md exists:** Error - run `/do:build` first.

## 2. Determine Specialists

**If fast mode:**
- `do-qa` - tests and coverage
- `do-reviewer` - code quality
(Only 2 agents, quick review)

**If normal mode:**
Always dispatch:
- `do-qa` - test coverage and correctness
- `do-reviewer` - code quality and patterns

Conditionally dispatch (based on files modified in BUILD.md):
- `do-security` - if auth, crypto, user input, API endpoints, or secrets were touched
- `do-reliability` - if error handling, retries, data access, or external calls were touched
- `do-devops` - if CI/CD, Dockerfiles, infra configs, or deploy scripts were touched
- `do-perf` - if performance-sensitive code was touched
- `do-compliance` - if compliance-relevant code was touched

Show which specialists will be dispatched:

Use AskUserQuestion:
- header: "Verification"
- question: "Running verification with: [agent list]. Proceed?"
- options:
  - "Yes, verify"
  - "Add more reviewers" - include additional specialists
  - "Remove reviewers" - exclude some specialists
  - "Skip verification" - mark phase done without review

## 3. Dispatch Reviewers

Resolve model for each specialist from config.

Dispatch all selected specialists in parallel. Each specialist:
1. Reads project context files (.work/context/)
2. Reads the phase plan and build log
3. Reviews relevant files from their domain perspective
4. Returns findings in their standard format

## 4. Compile Verification Report

Write `VERIFY.md` in the phase directory:
- Overall status (PASS only if all specialists PASS)
- Each specialist's findings section
- Action items for any CRITICAL or HIGH findings

## 5. Present Results

Show VERIFY.md summary to user.

**If CRITICAL findings exist:**

Use AskUserQuestion:
- header: "CRITICAL Issues Found"
- question: "[N] critical issues found. What to do?"
- options:
  - "Fix now" - address critical issues immediately
  - "Show details" - see full findings
  - "Fix later" - save state, address next session
  - "Override" - mark phase done anyway (shows warning)

If "Override" selected, show warning:
```
WARNING: Overriding critical findings. These issues remain unresolved:
[list of critical issues]
This decision is recorded in VERIFY.md.
```

**If all PASS:**

Use AskUserQuestion:
- header: "Phase Complete"
- question: "All checks passed! What next?"
- options:
  - "Next phase" - proceed to next phase
  - "Done for now" - save state and stop
  - "Review details" - see full verification report

## 6. Update State

Update STATE.md:
- Step: verify
- Status: complete (or needs-fixes)
- Next Action: based on results

</process>
