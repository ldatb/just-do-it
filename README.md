<div align="center">

# JUST DO IT

**A full company in a single plugin. Works with Claude Code and Codex.**

[![License](https://img.shields.io/badge/license-MIT-blue?style=for-the-badge)](LICENSE)
[![Agents](https://img.shields.io/badge/agents-26-green?style=for-the-badge)]()
[![Claude Code](https://img.shields.io/badge/Claude_Code-plugin-8A2BE2?style=for-the-badge)]()
[![Codex](https://img.shields.io/badge/Codex-compatible-10a37f?style=for-the-badge)]()

<br>

```bash
git clone https://github.com/ldatb/just-do-it.git && cd just-do-it && ./install.sh
```

<br>

*You describe what you want. 26 specialist agents research, plan, build, and verify.*

<br>

[How It Works](#how-it-works) &nbsp;|&nbsp; [Commands](#commands) &nbsp;|&nbsp; [Agents](#agents) &nbsp;|&nbsp; [Quality](#quality) &nbsp;|&nbsp; [Configuration](#configuration)

</div>

---

## How It Works

```
/do:start "add OAuth2 login with Google"

  1. RESEARCH  ->  do-researcher finds libraries, patterns, risks
  2. PLAN      ->  tasks grouped by wave, agents assigned (you approve)
  3. BUILD     ->  do-coder implements, do-security hardens (parallel)
  4. AUDIT     ->  security + performance + code quality loop (automatic)
  5. VERIFY    ->  do-qa tests, do-reviewer reviews (parallel)
```

You make every decision. The plugin presents options with a clear recommendation. Nothing happens without your approval.

### First Run

Run `/do:start` in any directory. The plugin auto-detects your environment:

- **Existing codebase** — asks how deep to scan (deep discovery, quick, or skip), then starts
- **New project** — asks 2 setup questions, then starts
- **Returning** — shows where you left off and offers to continue

Two to three questions, then you're building. Settings available later via `/do:settings`.

### The Pipeline

| Phase | What happens | Output |
|-------|-------------|--------|
| **Research** | Specialist agents investigate the domain. You review findings and make key decisions. | `RESEARCH.md` |
| **Plan** | Tasks grouped by wave with agent assignments. You approve before execution. | `PLAN.md` |
| **Build** | Agents execute in parallel waves. Status updates after each wave. | `BUILD.md` |
| **Audit** | Automatic security, performance, and code quality loop. Repeats until clean. | *(built into build)* |
| **Verify** | Multi-specialist review. Critical findings block completion — you decide what to fix. | `VERIFY.md` |

### Fast Lane

```
/do:it "add rate limiting to the API"
```

Same pipeline, zero ceremony. No decision prompts, no plan approval, single wave. Only stops for critical findings.

---

## Commands

Eight commands. That's it.

| Command | What it does |
|---------|-------------|
| `/do:start "task"` | Begin or continue a project. Handles setup, discovery, and resumption automatically. |
| `/do:it "task"` | Execute immediately, no ceremony. For well-understood work. |
| `/do:brainstorm "idea"` | Explore and refine an idea. When ready, flows directly into the pipeline. |
| `/do:debug "issue"` | Investigate and fix a bug with the debugger specialist. |
| `/do:review "target"` | Multi-specialist code review of files, PRs, or uncommitted changes. |
| `/do:status` | Show project state. Navigate, resume, or review previous work. |
| `/do:settings` | View or change configuration: model profile, git, agent overrides. |
| `/do:help` | Show commands and current project state. |

---

## Agents

26 specialists across 5 departments. The orchestrator classifies your work and dispatches the right ones automatically.

### Engineering (11)

| Agent | Domain |
|-------|--------|
| `do-coder` | Implementation — clean, production-ready code with mandatory verification loop |
| `do-architect` | System design, trade-off analysis, SOLID architecture |
| `do-security` | OWASP Top 10, secrets, auth/authz, zero-trust posture |
| `do-reliability` | Error handling, resilience, chaos-ready design |
| `do-qa` | Tests, coverage, regression, enterprise testing standards |
| `do-devops` | CI/CD, containers, infrastructure-as-code, immutable deployments |
| `do-debugger` | Root cause analysis, scientific debugging |
| `do-perf` | Profiling, optimization, measure-first methodology |
| `do-integrator` | API integrations, contract-first design, circuit breakers |
| `do-migrator` | Zero-downtime migrations, backward-compatible schema changes |
| `do-data` | SQL, ETL, analytics, query optimization, connection pooling |

### Business (5)

| Agent | Domain |
|-------|--------|
| `do-strategist` | Business strategy, competitive analysis, positioning |
| `do-marketer` | Content, campaigns, SEO, email marketing, brand |
| `do-sales` | Outreach, proposals, pitch decks, objection handling |
| `do-finance` | Budgeting, forecasting, unit economics, financial modeling |
| `do-ops` | Process design, project management, vendor management |

### People & Legal (4)

| Agent | Domain |
|-------|--------|
| `do-hr` | Hiring, onboarding, performance frameworks |
| `do-legal` | Contracts, policies, compliance, risk assessment |
| `do-compliance` | Audit prep, regulatory standards, certifications |
| `do-support` | FAQs, runbooks, knowledge base, customer communication |

### Product & Design (2)

| Agent | Domain |
|-------|--------|
| `do-product` | PRDs, roadmaps, feature prioritization, data-informed decisions |
| `do-designer` | UI/UX, design systems, WCAG 2.1 AA accessibility |

### Cross-Cutting (4)

| Agent | Domain |
|-------|--------|
| `do-researcher` | Prior art, libraries, documentation, technology research |
| `do-reviewer` | Code quality, KISS/DRY/SOLID compliance, convention adherence |
| `do-writer` | Technical docs, internal comms, presentations |
| `do-docs` | README, CHANGELOG, docs/ — kept in sync with code after every build |

---

## Quality

Every agent enforces four non-negotiable principles:

| Principle | What it means |
|-----------|--------------|
| **KISS** | Radical simplicity. The simplest solution that works is the best solution. |
| **Kodawari** | Obsessive craft. Every detail matters — names, edge cases, error messages. |
| **DRY** | Single source of truth. But wait for three repetitions before abstracting. |
| **SOLID** | Structural integrity. Single responsibility, dependency inversion, clean interfaces. |

### Verification Loop

Every code change goes through a mandatory audit cycle:

```
Build -> Test -> Security Audit -> Performance Check -> Scalability Review
  ^                                                            |
  |______________ fix and repeat until all checks pass ________|
```

The build workflow runs `do-security`, `do-perf`, and `do-reviewer` in parallel after every build. If critical or high issues are found, `do-coder` fixes them and the audit runs again — up to 3 iterations. Only clean code ships.

### Enterprise Ready

All engineering agents produce production-ready code from the first commit:

- Graceful degradation under failure
- Structured logging with correlation IDs
- Configuration via environment, never hardcoded
- Idempotent operations, backward-compatible changes
- Health checks and observability hooks

---

## Configuration

### Context Layering

Agents start with base expertise, then learn your project:

```
Base agent (global)            ->  "I'm a security expert"
  + project.md (all agents)    ->  "This is a Django app with PostgreSQL"
  + engineering.md (dept)      ->  "We use pytest, ruff, Django REST Framework"
  + security.md (agent)        ->  "Auth via django-guardian, JWTs, known CVEs"
```

Context lives in `.work/context/` and is generated automatically on first `/do:start`.

### Model Profiles

Control cost vs quality per agent:

| Profile | Description | Cost |
|---------|-------------|------|
| **balanced** | Sonnet for all agents (default) | Standard |
| **quality** | Opus for critical agents (architect, security, reviewer) | ~3x |
| **budget** | Haiku where possible | ~0.3x |

Override specific agents:

```json
{
  "model_profile": "balanced",
  "model_overrides": {
    "security": "opus",
    "coder": "opus"
  }
}
```

### Git

Configurable via `/do:settings`:

- **Feature branches** — a branch per phase (`feat/add-auth`, `fix/login-timeout`)
- **Auto-commit** — commit after each wave, or approve each manually
- **Conventional commits** — `feat:`, `fix:`, `chore:`, etc.

### Fast Mode

Less ceremony for well-understood work:

| Phase | Normal | Fast |
|-------|--------|------|
| Research | Multiple agents, deep dive | 1 agent, quick scan |
| Plan | Detailed waves, you approve | Minimal, auto-proceed |
| Verify | All relevant specialists | QA + reviewer only |

### Session Continuity

State saves automatically after every wave. No manual save needed.

```bash
/do:status    # see where you are and navigate
/do:start     # continue from where you left off
```

---

## Installation

```bash
git clone https://github.com/ldatb/just-do-it.git
cd just-do-it
./install.sh
```

Installs for both Claude Code and Codex in one step.

**Claude Code** (`~/.claude/`):
- Agents → `~/.claude/agents/do-*.md`
- Commands → `~/.claude/commands/do/*.md`
- Core → `~/.claude/do/` (workflows, templates, references)

**Codex** (`~/.codex/`):
- Instructions → `~/.codex/instructions.md` (appended with clear markers)

### Uninstall

```bash
./uninstall.sh
```

Removes all installed files from both `~/.claude/` and `~/.codex/`. Project directories (`.work/`) are preserved.

---

## Codex

The same 26 specialist modes and 8-command system, adapted for Codex's single-agent architecture.

Use natural language triggers instead of slash commands:

| Trigger | Equivalent |
|---------|-----------|
| `do start: <task>` | `/do:start` |
| `do it: <task>` | `/do:it` |
| `do brainstorm: <idea>` | `/do:brainstorm` |
| `do debug: <issue>` | `/do:debug` |
| `do review: <target>` | `/do:review` |
| `do status` | `/do:status` |
| `do settings` | `/do:settings` |
| `do help` | `/do:help` |

Specialist roles (coder, architect, security, QA, etc.) are adopted inline rather than dispatched as sub-agents. The `.work/` project state directory is identical between both platforms — projects are portable.

---

## License

MIT License. See [LICENSE](LICENSE).

<div align="center">

**Specialist agents make AI coding tools reliable. Works with Claude Code and Codex.**

</div>
