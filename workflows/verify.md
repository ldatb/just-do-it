<purpose>
Verify a phase by dispatching specialist review agents in parallel.
Config drives specialist selection. No confirmation before dispatch.
</purpose>

<process>

## 1. Load

1. Read STATE.md, config.json, phase BUILD.md and PLAN.md
2. If no BUILD.md: error — run `/do:start` to build first

## 2. Select Specialists

**Fast mode:** `do-qa` + `do-reviewer` only.

**Normal mode:** Always `do-qa` + `do-reviewer`, plus conditionally based on files in BUILD.md:

| If work involves... | Add |
| ------------------- | --- |
| Auth, crypto, user input, API endpoints, secrets | `do-security` |
| Error handling, retries, data access, external calls | `do-reliability` |
| CI/CD, Docker, infra, deploy scripts | `do-devops` |
| Performance-sensitive code | `do-perf` |
| Compliance-relevant code | `do-compliance` |

Announce specialists, then dispatch immediately.

## 3. Dispatch

Dispatch all specialists via Agent tool in parallel. Each reads project context, phase plan, and build log, then reviews from their domain perspective.

## 4. Consensus & Deduplication

Before writing the report, apply consensus rules per `references/intelligence.md` § Consensus Verification:

1. **Deduplicate:** Group findings by file + line range (within 5 lines = same location). Same location + same category = merge into one finding.
2. **Tiebreak severity:** When agents disagree on severity, domain expert outranks generalist. Two domain experts disagree -> use higher severity. Only generalists disagree -> use lower severity.
3. **Credit all agents** that found a merged issue.

## 5. Report

Write VERIFY.md with:
- Overall status (PASS only if all pass)
- Each finding with: severity, description, agents that found it, consensus note (if tiebreaker applied)
- Action items for CRITICAL/HIGH findings

## 6. Act — Auto-Fix Loop

Read `verify.auto_fix` from `.work/config.json`. Defaults: `enabled=true`, `max_iterations=3`.

**If `verify.auto_fix.enabled` is false:** skip the loop. Log all findings to VERIFY.md, print summary, done. User reviews and addresses manually.

**If enabled:** run the loop. No per-finding prompts.

### Loop

```
Iteration N of <max>:
  1. If zero CRITICAL + HIGH findings: exit loop, PASS.
  2. Dispatch do-coder (one agent) to fix all CRITICAL + HIGH in one pass.
     Brief: list every finding with file:line + consensus severity + agents that found it.
  3. Re-dispatch the same specialists from §3 in parallel. Re-apply §4 consensus.
  4. If fixes clear all CRITICAL + HIGH: exit loop, PASS.
  5. If iteration == max: exit loop, FAIL with remaining blockers.
  6. Else: increment N, go to 1.
```

Print status line each iteration:
```
Verify auto-fix: iteration N of <max>...
```

If `git.auto_commit` is true, coder auto-commits each iteration with `fix: verify iteration N - <summary>`. Enables trivial rollback via `git reset`.

### After loop

- **All CRITICAL + HIGH cleared:** write VERIFY.md with pass, all MEDIUM/LOW logged as deferred. Print `Phase verified.` Update STATE.md.
- **Loop exhausted, blockers remain:** write VERIFY.md with fail, list remaining CRITICAL/HIGH plus every iteration's diff summary. Present ONE AskUserQuestion summarizing the stuck state:
  - header: "Verify stuck after N iterations"
  - question: "<count> blockers remain after auto-fix loop. Choose path."
  - options:
    - "Show findings and stop (Recommended)" - print full VERIFY.md; user takes over
    - "Run N more iterations" - extend the loop
    - "Accept remaining and proceed" - mark deferred, unblock phase

**MEDIUM and LOW findings:** always logged to VERIFY.md, never prompted. User reads post-hoc.

## 7. Record Learnings

After every verify (pass or fail), append an entry to `.work/learnings.json` per `references/intelligence.md` § Self-Learning Loop:

```json
{
  "date": "ISO date",
  "phase": "phase name",
  "domain": "engineering|business|people|product",
  "task_type": "auth|api|migration|refactor|ui|docs|etc",
  "agents_used": ["list of agents dispatched"],
  "model_profile": "from config",
  "outcome": "pass|pass_with_fixes|fail",
  "notes": "one sentence — what worked or what went wrong"
}
```

If `.work/learnings.json` doesn't exist, create it with `{"entries": []}`. Append to the `entries` array — never overwrite.

</process>
