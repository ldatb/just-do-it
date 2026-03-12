<div align="center">

# JUST DO IT

**A full company in a single Claude Code plugin. 25 specialist agents for engineering, marketing, sales, finance, HR, legal, product, design, and operations.**

[![License](https://img.shields.io/badge/license-MIT-blue?style=for-the-badge)](LICENSE)
[![Agents](https://img.shields.io/badge/agents-25-green?style=for-the-badge)]()
[![Claude Code](https://img.shields.io/badge/Claude_Code-plugin-8A2BE2?style=for-the-badge)]()

<br>

```bash
git clone https://github.com/yourusername/just-do-it.git && cd just-do-it && ./install.sh
```

<br>

*"I don't need sprint ceremonies, story points, or Jira workflows. I need specialist agents that know their domain and do the work."*

<br>

[Why This Exists](#why-this-exists) - [How It Works](#how-it-works) - [Agents](#25-specialist-agents) - [Commands](#commands) - [User Guide](docs/README.md)

</div>

## Why This Exists

Most AI workflow tools fall into two camps: fully autonomous agents that produce inconsistent output, or heavyweight project management systems that add more ceremony than value.

Just do It is neither. It is a lean, agent-first execution system where specialist agents do the work and you make the decisions. You describe what you want. Specialist agents research, plan, build, and verify - asking you at every step.

The same plugin handles code, marketing plans, sales decks, HR policies, legal reviews, and financial models. One system, 25 specialists, zero enterprise theater.

## How It Works

```
/do:start "add OAuth2 login with Google"

1. RESEARCH  -> do-researcher finds libraries, patterns, risks
2. PLAN      -> tasks grouped by wave with agent assignments (you approve)
3. BUILD     -> do-coder implements, do-security hardens auth (in parallel)
4. VERIFY    -> do-qa writes tests, do-reviewer checks quality (in parallel)
```

At each step, you get a prompt with selectable options. Nothing happens without your say.

### 0. Brainstorm (optional)

```
/do:brainstorm
```

Not sure what to build? Start here. Claude becomes a brainstorming partner - asking clarifying questions, suggesting approaches, pushing toward specificity. One question at a time, not a questionnaire.

The output is a `BRAINSTORM.md` with a clear description, requirements, constraints, and alternatives considered. Feed it directly into `/do:start`.

### 1. Research

```
/do:start "add user authentication"
```

The system dispatches `do-researcher` agents to investigate the domain. In normal mode, multiple agents research in parallel (libraries, architecture, risks). In fast mode, one agent does a quick scan.

You review findings and decide whether to proceed, dig deeper, or skip ahead.

**Creates:** `RESEARCH.md` in the phase directory.

### 2. Plan

The system creates a `PLAN.md` with tasks grouped by wave. Each task specifies which agent runs it, which files it touches, what it does, and how to verify it worked.

**You always review the plan before execution.** Even in fast mode.

Use AskUserQuestion prompts let you approve, modify, reject, or save for later.

**Creates:** `PLAN.md` in the phase directory.

### 3. Build

Agents execute the plan in waves. Independent tasks run in parallel. Each agent reads the project context files plus its specific task from the plan.

After each wave, if code was modified, you are asked whether to commit (with a proposed conventional commit message), edit the message, or skip.

**Creates:** `BUILD.md` in the phase directory.

### 4. Verify

Multiple specialist agents review the work from different angles:
- `do-qa` - tests and coverage
- `do-reviewer` - code quality and patterns
- `do-security` - if auth/crypto/input was touched
- `do-reliability` - if error handling/data integrity is relevant
- `do-devops` - if infra files were touched

Critical findings block completion. You decide what to fix now vs later.

**Creates:** `VERIFY.md` in the phase directory.

## Installation

```bash
git clone https://github.com/ldatb/just-do-it.git
cd just-do-it
chmod +x install.sh
./install.sh
```

This copies files to `~/.claude/`:

- Agents -> `~/.claude/agents/do-*.md`
- Commands -> `~/.claude/commands/do/*.md`
- Core -> `~/.claude/do/` (workflows, templates, references)

### Uninstall

```bash
chmod +x uninstall.sh
./uninstall.sh
```

Your `.work/` project directories are not removed.

## Quick Start

### Just do it (fast)

```bash
/do:it "add user authentication"    # skip ceremony, just build it
```

### Full pipeline

```bash
/do:discover                        # deep codebase scan, generates agent context
/do:start "add user authentication" # research -> plan -> build -> verify
```

### New project

```bash
/do:setup                           # interactive Q&A to configure context
/do:start "build the MVP"           # start working
```

### Not sure what to build?

```bash
/do:brainstorm                      # explore and refine your idea with Claude
/do:start "the refined description" # then start with a clear scope
```

### Debug something

```bash
/do:debug "login endpoint returns 500" # scientific debugging with specialist
```

## 25 Specialist Agents

Every agent has deep domain expertise. The orchestrator classifies your work and dispatches the right specialists automatically.

### Engineering (11)

| Agent | Domain |
| ----- | ------ |
| `do-coder` | Pure implementation, clean production code |
| `do-architect` | System design, trade-off analysis, tech strategy |
| `do-security` | OWASP Top 10, secrets, auth/authz, input validation |
| `do-reliability` | Error handling, resilience, edge cases, data integrity |
| `do-qa` | Tests, coverage, regression, test strategy |
| `do-devops` | CI/CD, containers, infra-as-code, deployment |
| `do-debugger` | Root cause analysis, scientific debugging |
| `do-perf` | Profiling, optimization, caching, load testing |
| `do-integrator` | API integrations, webhooks, OAuth, third-party services |
| `do-migrator` | Database migrations, framework upgrades, legacy modernization |
| `do-data` | SQL, ETL, reporting, analytics, data modeling |

### Business (5)

| Agent | Domain |
| ----- | ------ |
| `do-strategist` | Business strategy, competitive analysis, positioning |
| `do-marketer` | Content, campaigns, SEO, email marketing, brand voice |
| `do-sales` | Outreach sequences, proposals, pitch decks, objection handling |
| `do-finance` | Budgeting, forecasting, unit economics, financial modeling |
| `do-ops` | Process design, project management, vendor management |

### People and Legal (4)

| Agent | Domain |
| ----- | ------ |
| `do-hr` | Job descriptions, interviews, onboarding, performance frameworks |
| `do-legal` | Contracts, policies, compliance frameworks, risk assessment |
| `do-compliance` | Audit prep, regulatory standards, certification requirements |
| `do-support` | FAQs, runbooks, knowledge base, customer communication |

### Product and Design (2)

| Agent | Domain |
| ----- | ------ |
| `do-product` | PRDs, roadmaps, feature prioritization, user stories |
| `do-designer` | UI/UX specs, design systems, accessibility, branding |

### Cross-Cutting (3)

| Agent | Domain |
| ----- | ------ |
| `do-researcher` | Prior art, libraries, documentation, technology research |
| `do-reviewer` | Code quality, patterns, readability, convention adherence |
| `do-writer` | Technical docs, internal comms, presentations, content |

## Context Layering

Agents have base knowledge globally, but learn your project through context files. The same `do-security` agent behaves differently for a Django app vs a Node.js API.

```
Base agent (global)           -> "I'm a security expert"
  + project.md (all agents)   -> "This is a Django app with PostgreSQL"
  + engineering.md (dept)     -> "We use pytest, ruff, Django REST Framework"
  + security.md (agent)       -> "Auth via django-guardian, JWTs, known CVE-2024-XXXX"
```

Context lives in `.work/context/` and is generated automatically:

- `/do:discover` - 6 parallel agents deep-scan your codebase (stack, architecture, quality, conventions, git history, security)
- `/do:setup` - interactive Q&A for new projects
- Or edit the markdown files directly

Discovery generates agent-specific context files (coder.md, security.md, qa.md, devops.md, reviewer.md, architect.md, reliability.md, debugger.md) so every agent has deep, project-specific knowledge.

## Commands

### Quick Start

| Command | What it does |
| ------- | ----------- |
| `/do:it "task"` | **Just do it.** Minimal ceremony, fast execution. |
| `/do:start "task"` | Full pipeline: research -> plan -> build -> verify |
| `/do:brainstorm "topic"` | Explore and refine an idea before building |
| `/do:help` | Show all commands and usage |

### Project Setup

| Command | What it does |
| ------- | ----------- |
| `/do:discover` | Deep codebase scan, generate agent context files |
| `/do:setup` | Interactive project setup for new projects |

### Pipeline Steps (standalone)

| Command | What it does |
| ------- | ----------- |
| `/do:research "topic"` | Research a topic, technology, or approach |
| `/do:plan` | Plan the current phase |
| `/do:build` | Build the current phase with specialist agents |
| `/do:verify` | Multi-specialist verification of current phase |

### Tools

| Command | What it does |
| ------- | ----------- |
| `/do:debug "issue"` | Debug a bug with the specialist agent |
| `/do:review [path or PR#]` | Code review with relevant specialists |

### Session Management

| Command | What it does |
| ------- | ----------- |
| `/do:status` | Show current position and next action |
| `/do:resume` | Continue from saved state |
| `/do:save` / `/do:pause` | Save session state for later |
| `/do:settings` | Configure model profiles, agents, git, etc. |

## Git Workflow

Uses [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/) for branches and messages.

**Branches:**

```bash
feat/user-auth
fix/login-timeout
refactor/extract-validators
chore/update-deps
```

**Commits:**

```bash
feat: add JWT authentication to login endpoint
fix: prevent race condition in session refresh
test: add integration tests for payment flow
```

**All git operations require your approval.** The plugin shows you the files, the proposed message, and asks before committing. It never pushes without asking.

## Model Profiles

Control cost vs quality per agent:

| Profile | Description | Use when |
| ------- | ----------- | -------- |
| `quality` | Opus for critical agents | Important deliverables, complex architecture |
| `balanced` | Sonnet for most agents (default) | Day-to-day work |
| `budget` | Haiku for most agents | High-volume, repetitive, or low-stakes work |

```bash
/do:settings    # then select "Model profile"
```

Override specific agents in `.work/config.json`:

```json
{
  "model_profile": "balanced",
  "model_overrides": {
    "coder": "opus",
    "legal": "opus"
  }
}
```

## Fast Mode

For well-understood work where you want less ceremony:

| Phase | Normal | Fast |
| ----- | ------ | ---- |
| Research | Multiple agents, deep dive | 1 agent, quick scan |
| Plan | Detailed waves and tasks | Minimal, single wave |
| Build | Full execution with logging | Execute immediately |
| Verify | All relevant specialists | QA + reviewer only |

**Fast mode never skips:** git approval, plan approval, critical findings.

```bash
/do:settings    # then select "Fast mode"
```

## Session Continuity

All state lives in `.work/STATE.md`. You can close Claude Code and come back later.

```bash
/do:save      # save current state explicitly
/do:resume    # pick up where you left off
/do:status    # check where you are without resuming
```

STATE.md tracks current phase, current step, last action, next action, context, and pending items. It is human-readable and editable.

## Safety

- No autonomous mode. Every action prompts the user.
- Git commits require explicit approval.
- Git push requires explicit approval.
- Destructive actions (file deletion, force push, branch deletion) show a warning and require confirmation.
- The legal agent always recommends professional counsel for final documents.
- Capabilities are documented in `.work/capabilities.md` so you can see exactly what the plugin is configured to do.

## License

MIT License. See [LICENSE](LICENSE) for details.

<div align="center">

**Claude Code is powerful. Specialist agents make it reliable.**

</div>
