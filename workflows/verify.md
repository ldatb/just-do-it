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

## 6. Act

**CRITICAL findings:** Present each finding individually. Do NOT bundle multiple findings together.

For EACH CRITICAL finding, use AskUserQuestion:
- header: "Critical: [finding title]"
- question: "[One sentence: what is wrong, where, which agent found it]"
- options:
  - "Fix now (Recommended)" - dispatch agent to fix this specific issue immediately
  - "Show details" - see full finding with file path, line number, and code context
  - "Fix later" - acknowledge and defer; recorded in VERIFY.md as deferred
  - "Not an issue" - override; you will provide justification recorded in VERIFY.md

When user selects "Show details":
1. Print the full finding: severity, description, file path, line number, code snippet (if available), which agents found it, consensus note if applicable.
2. Re-present the identical AskUserQuestion (same header, same question, same 4 options).

**HIGH findings:** Use the same structure as CRITICAL.

For EACH HIGH finding, use AskUserQuestion:
- header: "High: [finding title]"
- question: "[One sentence: what is wrong, where, which agent found it]"
- options:
  - "Fix now (Recommended)" - dispatch agent to fix this specific issue immediately
  - "Show details" - see full finding with file path, line number, and code context
  - "Fix later" - acknowledge and defer; recorded in VERIFY.md as deferred
  - "Not an issue" - override; you will provide justification recorded in VERIFY.md

When user selects "Show details": same behavior as CRITICAL — print full finding, re-present same question.

**MEDIUM findings:** Use the same 4-option structure, but "Fix later" is the recommended default.

For EACH MEDIUM finding, use AskUserQuestion:
- header: "Medium: [finding title]"
- question: "[One sentence: what is wrong, where, which agent found it]"
- options:
  - "Fix later (Recommended)" - defer; recorded in VERIFY.md; address in next iteration
  - "Fix now" - dispatch agent to fix this issue immediately
  - "Show details" - see full finding with file path, line number, and code context
  - "Not an issue" - override; you will provide justification recorded in VERIFY.md

When user selects "Show details": print full finding, re-present same question.

**LOW findings:** Log in VERIFY.md. No AskUserQuestion needed.

**All PASS:** Print "Phase verified." Update STATE.md.

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
