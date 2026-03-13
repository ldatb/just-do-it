# Interaction Patterns

## Core Principles

1. **Think ahead of the user.** Surface decisions, tradeoffs, and risks the user hasn't considered yet. Your job is to be the expert assistant who anticipates problems and presents informed options.

2. **Ask before acting on decisions that matter.** When research reveals multiple viable approaches, when planning requires tradeoff decisions, when there are implications the user should know about — ASK. Use AskUserQuestion with concrete options and your recommendation.

3. **Config drives operational decisions.** Git settings, model profiles, agent selection, fast mode — these are set once in config.json and respected automatically. Don't re-ask about things config already answers.

4. **Present, explain, then ask.** Never silently generate artifacts. Show your work, explain the reasoning, then ask for direction.

## When to Ask the User (Decision Points)

| Situation | What to ask | Format |
| --------- | ----------- | ------ |
| Research reveals multiple approaches | "Which approach fits your needs? Here are the tradeoffs..." | Single-choice with recommendation |
| Research surfaces risks/constraints | "This will also require X — handle now or defer?" | Single-choice |
| Planning requires design decisions | "REST or GraphQL? Pagination or infinite scroll?" | Single-choice with tradeoffs |
| Presenting research findings | Show summary + "Here's what I found. A few decisions before we plan..." | Summary then questions |
| Presenting plan | Explain goal, approach, agents, waves — then "Ready to build?" | Summary then approval |
| CRITICAL verification findings | "Critical issues found. Fix now, review, or defer?" | Single-choice |
| Debug fix ready | "Found the issue. Apply the fix?" | Single-choice |
| Task failure during build | "Task failed. Retry, skip, debug, or stop?" | Single-choice |
| First-time setup (no config.json) | Project preferences | Single-choice preset profiles |
| Discovery config recommendations | "Apply recommended config changes?" | Single-choice |

## When NOT to Ask (Config-Driven)

| Situation | What config answers |
| --------- | ------------------- |
| Phase creation | Auto-create from STATE.md |
| Git branch creation | `git.use_branches` in config |
| Agent dispatch during build | PLAN.md + config determine agents |
| Git commits | `git.conventional_commits` in config |
| Specialist selection for verify | `fast_mode` + file analysis |
| Phase completion (PASS) | Auto-update STATE.md |
| Branch merge | `git.use_branches` in config |

## Fast Mode vs Normal Mode

**Normal mode (`fast_mode: false`):**
- Research: ask 2-4 decision questions based on findings
- Plan: ask about implementation decisions, explain plan in detail
- Verify: full specialist dispatch
- The user is consulted on decisions that shape the outcome

**Fast mode (`fast_mode: true`):**
- Research: brief summary, skip decision questions (make reasonable defaults)
- Plan: show plan briefly, skip approval (just proceed)
- Verify: minimal (qa + reviewer only)
- The user trusts the system to make good defaults

**Builder (`/do:build`):**
- Never asks decision questions — the plan is already approved
- Only asks on task failure (retry/skip/debug/stop)

**Go mode (`/do:go`, `/do:it`):**
- Zero ceremony, no decision questions
- Only stops for CRITICAL findings

## Prompt Budget by Command

| Command | Decision Questions | Approval Gates | Error Prompts |
| ------- | ------------------ | -------------- | ------------- |
| `/do:start` | 2-4 (research) + 0-3 (plan) | Plan approval | CRITICAL findings, task failure |
| `/do:research` | 2-4 (findings) | None | None |
| `/do:plan` | 0-3 (impl decisions) | Plan approval | None |
| `/do:build` | None | None | Task failure only |
| `/do:verify` | None | None | CRITICAL findings only |
| `/do:debug` | 0-1 (clarification) | Fix approval | None |
| `/do:go` / `/do:it` | None | None | CRITICAL findings only |
| `/do:brainstorm` | Many | None | None |
| `/do:discover` | None | Config apply | None |
| `/do:settings` | Many | None | None |
| `/do:save` | None | None | None |

## AskUserQuestion Format

When asking, always:
1. **Give context** — explain WHY this decision matters
2. **Include your recommendation** — "I recommend X because..."
3. **Show tradeoffs** — each option has a brief note on pros/cons
4. **Keep it concrete** — real options, not abstract choices

```
Use AskUserQuestion:
- header: "Section: Decision Topic"
- question: "Clear question with context and recommendation"
- options:
  - "Option A" - tradeoff note (RECOMMENDED if applicable)
  - "Option B" - tradeoff note
  - "Option C" - tradeoff note
```

Keep options to 2-4. Always include a recommended option when you have an informed opinion.

## Dangerous Operations Warning

The following operations always show a warning banner (but don't necessarily prompt):

```
WARNING: [Description of what will happen]
```

- Force push
- Branch deletion
- File deletion outside .work/
- Database migrations
- Overwriting uncommitted changes

## Git Auto-Commit Behavior

When `git.conventional_commits` is true:
1. After each build wave: auto-commit modified files with `<type>: <description>`
2. After save: auto-commit state files with `chore: save work state`
3. After debug fix: auto-commit with `fix: <description>`
4. Stage specific files only (never `git add .`)
5. Generate conventional commit message from the work done
6. No prompt needed - the user configured this behavior

When `git.conventional_commits` is false:
- No git operations happen automatically
- User manages git manually
