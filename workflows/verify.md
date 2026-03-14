<purpose>
Verify a phase by dispatching specialist review agents in parallel.
Config drives specialist selection. No confirmation before dispatch.
</purpose>

<process>

## 1. Load

1. Read STATE.md, config.json, phase BUILD.md and PLAN.md
2. If no BUILD.md: error — run `/do:build` first

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

## 4. Report

Write VERIFY.md with:
- Overall status (PASS only if all pass)
- Each specialist's findings: status (PASS/FAIL/WARN), findings by severity (CRITICAL/HIGH/MEDIUM/LOW), verdict
- Action items for CRITICAL/HIGH findings

## 5. Act

**CRITICAL findings:** Ask user (fix now / show details / fix later / override).
If override: record warning in VERIFY.md with date.

**All PASS:** Print "Phase verified." Update STATE.md. Stop.

</process>
