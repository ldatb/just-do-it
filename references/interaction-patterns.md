# Interaction Patterns

## Core Principle

**Config drives decisions.** The plugin reads `.work/config.json` and acts accordingly. Prompts are reserved for decisions that config cannot answer: plan approval and critical findings.

## When to Prompt (ONLY these cases)

| Situation | Why it needs a prompt |
| --------- | -------------------- |
| First-time setup (no config.json) | Need to know git, model, and mode preferences |
| Plan review | Human must approve what agents will do |
| CRITICAL verification findings | Human must decide: fix, defer, or override |
| Debug fix approval | Human must approve changes to fix a bug |
| Task failure during build | Human must decide: retry, skip, debug, or stop |

## When NOT to Prompt (use config instead)

| Situation | What config answers |
| --------- | ------------------- |
| Phase creation | Auto-create from STATE.md |
| Git branch creation | `git.use_branches` in config |
| Research dispatch | `fast_mode` in config |
| Research review | Auto-proceed to planning |
| Wave execution | Auto-dispatch from PLAN.md |
| Git commits | `git.conventional_commits` in config - auto-commit |
| Specialist selection for verify | `fast_mode` + file analysis |
| Phase completion (PASS) | Auto-update STATE.md |
| Branch merge | `git.use_branches` in config - auto-merge |

## AskUserQuestion Format

When a prompt IS needed, use AskUserQuestion with selectable options:

```
Use AskUserQuestion:
- header: "Section Title"
- question: "Clear question?"
- options:
  - "Option A" - brief description
  - "Option B" - brief description
  - "Option C" - brief description
```

Keep options to 2-3 max. No "Custom" or "Something else" options unless genuinely useful.

## Prompt Reduction by Command

| Command | Max Prompts | What they are |
| ------- | ----------- | ------------- |
| `/do:it` | 1 | CRITICAL findings only |
| `/do:start` | 3 | First-time setup (once), plan approval, CRITICAL findings |
| `/do:build` | 1 | Task failure only |
| `/do:verify` | 1 | CRITICAL findings only |
| `/do:research` | 0 | Config-driven, no prompts |
| `/do:debug` | 2 | Vague input clarification, fix approval |
| `/do:save` | 0 | Config-driven, no prompts |
| `/do:brainstorm` | Many | Interactive by nature (this is the exception) |
| `/do:discover` | 1 | Config recommendations |
| `/do:settings` | Many | Interactive by nature (changing settings) |

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

These show a warning in output but only prompt if the action is truly destructive and irreversible.

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
