# Just do It - A Full Company in a Plugin

Lean, agent-first execution system for Claude Code. 26 specialist agents covering engineering, security, marketing, sales, finance, HR, legal, product, design, operations, and more.

## Philosophy

- **Fast.** You describe what you want, it moves. No lengthy questioning phases.
- **Agent-first.** Specialist agents with deep domain expertise, not one generic executor.
- **Full-spectrum.** Code, marketing, sales, HR, legal, finance - one system for everything.
- **Interactive.** Every significant action requires user approval. No autonomous mode.
- **Context-aware.** Agents learn your project. Base knowledge + project-specific overrides.
- **Continuous.** Session state saved in markdown. Resume anytime.

## Installation

```bash
chmod +x install.sh
./install.sh
```

This copies files to `~/.claude/`:
- Agents -> `~/.claude/agents/do-*.md`
- Commands -> `~/.claude/commands/do/*.md`
- Core -> `~/.claude/do/` (workflows, templates, references)

## Quick Start

### Existing codebase (brownfield)
```
/do:start "add user authentication"
```
Discovery runs automatically on first use — no separate command needed.

### New project (greenfield)
```
/do:start "build the MVP"
```
Setup questions are asked automatically on first run.

### Not sure what to build?
```
/do:brainstorm "rough idea"
```
When ready, brainstorm hands off directly to the pipeline — no manual command needed.

## Commands

| Command | Purpose |
| ------- | ------- |
| `/do:start "description"` | Begin or continue a project task; handles first-run setup, discovery, and resumption automatically |
| `/do:it "description"` | Execute immediately, no ceremony |
| `/do:status` | Show project state and resume options |
| `/do:brainstorm "topic"` | Explore an idea before committing to build |
| `/do:review "what to review"` | Review code or decisions with specialists |
| `/do:debug "error or symptom"` | Investigate and fix a specific issue |
| `/do:settings` | View or change project configuration |
| `/do:help` | Show available commands and current state |

**Note:** `/do:start` absorbs the old discover, setup, plan, build, verify, resume, save, and pause commands. Those commands no longer exist. Discovery and setup happen automatically on first run; state saves automatically throughout execution.

## Agents (26 Specialists)

### Engineering
- **do-coder** - Pure implementation
- **do-architect** - System design, trade-offs
- **do-security** - OWASP, secrets, auth
- **do-reliability** - Error handling, resilience
- **do-qa** - Tests, coverage, regression
- **do-devops** - CI/CD, infra, deployment
- **do-debugger** - Bug investigation, root cause analysis
- **do-perf** - Profiling, optimization
- **do-integrator** - API integrations, webhooks
- **do-migrator** - Database/framework migrations
- **do-data** - SQL, ETL, reporting, analytics

### Business
- **do-strategist** - Strategy, analysis, positioning
- **do-marketer** - Content, campaigns, SEO
- **do-sales** - Outreach, proposals, pitch
- **do-finance** - Budgets, forecasting, models
- **do-ops** - Processes, project management

### People & Legal
- **do-hr** - Hiring, onboarding, culture
- **do-legal** - Contracts, compliance, risk
- **do-compliance** - Audit, regulatory, standards
- **do-support** - FAQs, runbooks, help docs

### Product & Design
- **do-product** - PRDs, roadmaps, prioritization
- **do-designer** - UI/UX, branding, design systems

### Cross-Cutting
- **do-researcher** - Prior art, documentation, analysis
- **do-reviewer** - Code and document quality
- **do-writer** - Technical writing, comms, content
- **do-docs** - Documentation updates (README, CHANGELOG, docs/)

## Context Layering

Agents have base knowledge (global) plus project-specific overrides:

```
Base agent (global)           -> "I'm a security expert"
  + project.md (shared)       -> "This is a Django app with PostgreSQL"
  + engineering.md (dept)     -> "We use pytest, ruff, Django REST Framework"
  + security.md (specific)   -> "Auth via django-guardian, JWTs, known CVE in deps"
```

Context files live in `.work/context/` and are generated automatically by `/do:start` on first run.

## Git Workflow

Uses conventional commits for both branches and commit messages:
- Branches: `feat/user-auth`, `fix/login-timeout`, `chore/update-deps`
- Commits: `feat: add JWT authentication`, `fix: prevent race condition`
- Git operations follow config settings (`auto_commit` controls commit behavior).

## Model Profiles

```
/do:settings   # open settings menu to change model_profile
```

Profiles: `quality` (best output, highest cost), `balanced` (default), `budget` (fast and cheap).

## Fast Mode

Reduces ceremony for well-understood work:
- Research: 1 agent, quick scan
- Plan: minimal, single wave
- Verify: only QA + reviewer

```
/do:settings   # toggle fast_mode from the settings menu
```

## Session Continuity

State saves automatically throughout execution — no manual save command needed.

```
/do:status    # check current position and navigate
/do:start     # continue from where you left off (or start something new)
```

See [sessions.md](sessions.md) for full documentation.

## Uninstall

```bash
chmod +x uninstall.sh
./uninstall.sh
```
