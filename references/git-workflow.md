# Git Workflow

## Principles

1. **Conventional commits.** All messages and branches follow the convention.
2. **Feature branches.** Code work happens on branches when configured.
3. **No attribution lines.** Never add "Co-Authored-By" or any attribution. Ever.
4. **`auto_commit` is the single source of truth.** If true: commit automatically. If false: ask user first.

## Conventional Commits

Format: `<type>[optional scope]: <description>`

| Type | When | Branch |
| ---- | ---- | ------ |
| `feat` | New feature | `feat/user-auth` |
| `fix` | Bug fix | `fix/login-timeout` |
| `refactor` | Restructuring | `refactor/extract-validators` |
| `docs` | Documentation | `docs/api-reference` |
| `test` | Tests | `test/payment-flow` |
| `chore` | Maintenance | `chore/update-deps` |
| `perf` | Performance | `perf/query-optimization` |
| `ci` | CI/CD | `ci/github-actions` |

## Commit Behavior

Read `git.auto_commit` from config.json:

**If `auto_commit: true`:**
- Stage specific files (never `git add .`)
- Generate conventional commit message from the work done
- Commit. No prompt.

**If `auto_commit: false`:**
- Show user: files, proposed message, diff summary
- Ask via AskUserQuestion: "Commit?" → Yes / Edit message / Skip
- Only commit if user approves

## Branches

When `git.use_branches` is true:
1. Auto-create `<type>/<name>` branch at phase start
2. All commits go on this branch
3. On phase completion: merge to main automatically

## Push

Never push automatically. Always ask user first.

## Never Commit

`.env` files, secrets, `node_modules`, `__pycache__`, build artifacts, `.gitignore`'d files.
