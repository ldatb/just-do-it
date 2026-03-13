<purpose>
Verify the current or specified phase by dispatching specialist review agents in parallel.
Config drives specialist selection. No confirmation prompts before dispatch.
</purpose>

<process>

## 1. Load Context

1. Read `.work/STATE.md` for current position
2. Read `.work/config.json` for settings and model profiles (including `fast_mode`)
3. Determine which phase to verify:
   - If $ARGUMENTS contains a phase number, use that
   - Otherwise, use current phase from STATE.md
4. Read `.work/phases/XX-<name>/BUILD.md` for what was built and which files were modified
5. Read `.work/phases/XX-<name>/PLAN.md` for what was planned

**If no BUILD.md exists:** Error - run `/do:build` first.

## 2. Determine Specialists

Read `fast_mode` from config.json. Do not ask the user which specialists to use.

**If fast_mode is true:**
Always dispatch:
- `do-qa` - tests and coverage
- `do-reviewer` - code quality

**If fast_mode is false:**
Always dispatch:
- `do-qa` - test coverage and correctness
- `do-reviewer` - code quality and patterns

Conditionally dispatch based on files modified listed in BUILD.md:
- `do-security` - if auth, crypto, user input, API endpoints, or secrets were touched
- `do-reliability` - if error handling, retries, data access, or external calls were touched
- `do-devops` - if CI/CD, Dockerfiles, infra configs, or deploy scripts were touched
- `do-perf` - if performance-sensitive code was touched
- `do-compliance` - if compliance-relevant code was touched

Announce which specialists will be dispatched, then proceed immediately.

## 3. Dispatch Reviewers

Resolve model for each specialist from config.json model_overrides or the active profile.

**Use the Agent tool** to dispatch all selected specialists in parallel. Each specialist:
1. Reads project context files (.work/context/)
2. Reads the phase plan and build log
3. Reviews relevant files from their domain perspective
4. Returns findings in their standard format

## 4. Compile Verification Report

Write `VERIFY.md` in the phase directory:
- Overall status (PASS only if all specialists PASS)
- Each specialist's findings section
- Action items for any CRITICAL or HIGH findings

## 5. Present Results and Act

Show the VERIFY.md summary.

**If CRITICAL findings exist:**

Use AskUserQuestion:
- header: "CRITICAL Issues Found"
- question: "[N] critical issue(s) found. What do you want to do?"
- options:
  - "Fix now" - address critical issues immediately
  - "Show details" - see full findings before deciding
  - "Fix later" - save state, address next session
  - "Override" - mark phase done anyway (records warning in VERIFY.md)

If "Override" selected, record in VERIFY.md:
```
WARNING: Overriding critical findings. These issues remain unresolved:
[list of critical issues]
This decision was recorded on [date].
```

**If all checks PASS:**

Print: "Phase verified. All checks passed."

Update STATE.md and stop. Do not ask what to do next.

## 6. Update State

Update STATE.md:
- Step: verify
- Status: complete (or needs-fixes if critical findings were not overridden)
- Next Action: next phase, or fix critical issues

</process>
