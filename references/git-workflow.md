# Git Workflow

## Principles

1. **User approves every git action.** No silent commits, no auto-push.
2. **Conventional commits.** All messages and branches follow the convention.
3. **Feature branches.** Code work happens on branches, never directly on main.
4. **No attribution lines.** Never add "Co-Authored-By" or any attribution to commits. Ever.

## Conventional Commits

Based on https://www.conventionalcommits.org/en/v1.0.0/

### Commit Message Format
```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Types (for commits AND branches)
| Type | When | Branch Example |
| ---- | ---- | -------------- |
| `feat` | New feature or capability | `feat/user-auth` |
| `fix` | Bug fix | `fix/login-timeout` |
| `refactor` | Code restructuring, no behavior change | `refactor/extract-validators` |
| `docs` | Documentation only | `docs/api-reference` |
| `test` | Adding or updating tests | `test/payment-flow` |
| `chore` | Maintenance, config, dependencies | `chore/update-deps` |
| `perf` | Performance improvement | `perf/query-optimization` |
| `ci` | CI/CD pipeline changes | `ci/github-actions` |
| `style` | Formatting, whitespace, no logic change | `style/lint-fixes` |
| `build` | Build system changes | `build/webpack-config` |

### Branch Naming
```
<type>/<short-kebab-description>
```

Examples:
```
feat/oauth2-login
fix/session-race-condition
refactor/shared-validation
docs/api-endpoints
chore/upgrade-to-v3
```

### Commit Examples
```
feat: add JWT authentication to login endpoint

fix: prevent race condition in session refresh

refactor: extract validation logic into shared module

docs: add API documentation for user endpoints

test: add integration tests for payment flow

chore: update dependencies to latest versions

feat(auth): add password reset flow

fix(api): handle null response from payment gateway

BREAKING CHANGE: rename login endpoint from /auth to /login
```

### Scoped Commits
Use scope when the change targets a specific module:
```
feat(auth): add two-factor authentication
fix(payments): handle declined card gracefully
refactor(users): extract email validation
```

## Branch Strategy

When `git.use_branches` is true:

1. Determine branch type from the work being done
2. Ask user to confirm branch name via AskUserQuestion
3. Create branch: `git checkout -b <type>/<name>`
4. All commits go on this branch
5. On phase completion, ask user: merge, PR, or leave

## Commit Protocol

**EVERY commit must be approved by the user.** The workflow:

1. Stage changes: `git add <specific files>` (never `git add .` or `git add -A`)
2. Show the user via AskUserQuestion:
   - Files being committed
   - The proposed commit message
   - The diff summary
3. Options:
   - "Yes, commit" - proceed
   - "Edit message" - modify before committing
   - "Skip" - don't commit now
4. Only commit if user explicitly approves

## What to Commit

### Always ask before committing:
- Source code changes
- Configuration changes
- Test files
- Documentation

### Planning docs (`.work/`):
- Only commit if user approves
- Ask separately from source code commits

### Never commit:
- `.env` files or secrets
- `node_modules`, `__pycache__`, build artifacts
- Temporary/generated files
- Files in `.gitignore`

## Push Protocol

Never push automatically. When phase is complete or user requests:

1. Show what will be pushed (branch, commits)
2. Use AskUserQuestion:
   - "Yes, push"
   - "Not now"
3. Only push if explicitly approved

## Merge Protocol

When merging back to main:

Use AskUserQuestion:
- header: "Merge Branch"
- question: "Merge <branch> into main?"
- options:
  - "Merge (fast-forward)" - if possible
  - "Merge (with commit)" - create merge commit
  - "Create PR instead" - push and open PR
  - "Leave on branch" - don't merge yet

## Pull Request Creation

When creating PRs:

1. Push branch with `-u` flag
2. Create PR with:
   - Title: conventional commit format (e.g., "feat: add user authentication")
   - Body: summary of changes, test plan
3. Show PR URL to user
