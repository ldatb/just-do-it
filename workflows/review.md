<purpose>
Code review with all relevant specialists. Can target a path, PR, or recent changes.
</purpose>

<process>

## 1. Determine Scope

Parse $ARGUMENTS:
- If a file/directory path: review those files
- If a PR number: fetch PR diff with `gh pr diff <number>`
- If empty: review uncommitted changes (`git diff` + `git diff --cached`)

## 2. Gather Files

Collect the list of files to review based on scope.

## 3. Classify Files

Determine which specialists are relevant:
- **Always:** `do-reviewer` (code quality)
- **If test files present or code lacks tests:** `do-qa`
- **If auth, crypto, input handling, API:** `do-security`
- **If error handling, retries, data access:** `do-reliability`
- **If CI/CD, Dockerfiles, infra:** `do-devops`

## 4. Dispatch Specialists

Read `.work/config.json` if it exists for model profiles (otherwise use defaults).

Dispatch all relevant specialists in parallel. Each receives:
- The list of files to review
- Context about what changed (diff summary)

## 5. Compile Report

Combine all specialist reports into a single review:

```markdown
# Code Review

## Summary
- Specialists: <list>
- Files reviewed: N
- Overall: PASS | FAIL | WARN

## Findings by Specialist
<each specialist's report>

## Action Items
<consolidated list of things to fix, ordered by severity>
```

Present the compiled report to the user.

</process>
