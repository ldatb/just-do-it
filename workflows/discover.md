<purpose>
Deep codebase discovery and scaffolding. "If I have 1 hour to cut something, I'll spend 50 minutes sharpening my blade."

This is the most important step in the pipeline. Thorough discovery produces rich context files
that make every agent smarter for THIS specific project. Shallow discovery means generic agents
that miss project-specific patterns, conventions, and risks.

Discovery generates:
1. Project-wide context (project.md) - every agent reads this
2. Department context (engineering.md, business.md, etc.) - department agents read these
3. Agent-specific context (coder.md, security.md, qa.md, etc.) - deep per-agent knowledge
4. Codebase health report (HEALTH.md) - actionable summary of where to invest
5. Recommended config (config.json updates) - disable irrelevant agents, set model preferences
</purpose>

<process>

## 1. Pre-flight

Check if `.work/` exists. If not, create it.
Create `.work/context/` directory.

**If `.work/config.json` does not exist:**
Copy the config template from the plugin's `templates/config.json`. This ensures ALL required
fields exist with defaults. The template schema is the single source of truth for config structure.

**If `.work/config.json` exists:**
Validate it has all required fields from the template. If fields are missing, merge them in
with template defaults (don't overwrite existing values).

**Required config.json structure (from template):**
```json
{
  "model_profile": "balanced",
  "model_overrides": {},
  "fast_mode": false,
  "parallelization": { "max_concurrent": 4 },
  "git": {
    "auto_commit": false,
    "use_branches": true,
    "conventional_commits": true
  }
}
```

**CRITICAL: Always use this exact structure. Do NOT invent new fields like `disabled_agents`,
`git.mode`, `git.commit_style`, or put `max_concurrent` at root level. The template is the schema.**

**If `.work/context/` already has files (re-discovery):**
- Back up existing context to `.work/context/.backup/` (timestamped)
- Print: `Backing up existing context files to .work/context/.backup/<timestamp>/...`
- This preserves any manual edits the user made.

## 2. Dispatch Discovery Agents (Parallel)

Print: `Dispatching 6 discovery agents to analyze the codebase...`

**Use the Agent tool** to launch up to 6 `do-researcher` agents in parallel. Each agent MUST read the codebase deeply - not just skim file names.

**CRITICAL: You are an orchestrator. You do NOT analyze the codebase yourself. You dispatch agents and compile their results.**

### Agent 1: Stack & Structure
Analyze the codebase for:
- Programming languages and versions (from config files, shebangs, file extensions)
- Frameworks and libraries (with exact versions from lock files)
- Package manager and dependency files
- Directory structure and organization pattern (feature-based, layer-based, etc.)
- Build system, scripts, and Makefile/taskfile targets
- Configuration files and formats (dotfiles, yaml, toml, json)
- Monorepo structure (if applicable - workspaces, packages)

Output: tech stack summary, repo structure overview, dependency inventory

### Agent 2: Architecture & Patterns
Analyze the codebase for:
- Architecture pattern (monolith, microservices, serverless, modular monolith, etc.)
- Design patterns in use (repository, factory, observer, middleware, etc.)
- API style (REST, GraphQL, gRPC, tRPC) and route organization
- Database and ORM usage (models, migrations, query patterns)
- Authentication and authorization approach (JWT, sessions, OAuth, API keys)
- State management approach (global state, context, stores, signals)
- Error handling patterns (try/catch strategy, error types, fallback behavior)
- Logging and observability (structured logging, tracing, metrics)
- External service integrations (APIs, SDKs, webhooks)

Output: architecture summary, patterns catalog, integration inventory

### Agent 3: Quality & Testing
Analyze the codebase for:
- Test framework and runner (Jest, pytest, Go test, etc.)
- Test file structure and naming convention
- Test types present (unit, integration, e2e, snapshot, property-based)
- Approximate test coverage (ratio of test files to source files)
- Mocking patterns and test utilities
- Test data management (fixtures, factories, seeds)
- Linting and formatting tools (config files AND whether they're actually used)
- CI/CD pipeline configuration (all stages, not just build)
- Code quality tools (static analysis, type checking, bundle analysis)
- Documentation state (README quality, API docs, inline docs)
- Technical debt indicators (TODO count, FIXME count, HACK count, deprecated usage)

Output: quality assessment, testing patterns, debt inventory

### Agent 4: Conventions & Style
Analyze the codebase for:
- Naming conventions (files, variables, functions, classes, constants)
- Code style rules (from config AND from actual code patterns)
- Import/module organization (absolute vs relative, barrel exports, etc.)
- Comment and documentation style (JSDoc, docstrings, inline, none)
- File organization within modules (index files, barrel exports, co-location)
- Common abstractions (base classes, shared utilities, custom hooks)
- Error message format and i18n approach

Output: conventions guide, style rules

### Agent 5: Git History & Health
Analyze the git repository for:
- Commit message style (conventional commits, prefix patterns, etc.)
- Branch naming patterns
- Commit frequency and cadence
- Hotspot files (most frequently changed in last 100 commits)
- Recently active areas (files changed in last 20 commits)
- Bug-fix frequency by area (commits with "fix" in message)
- Contributors and ownership patterns
- Stale branches
- Large files in history

Output: git patterns, hotspot map, activity report

### Agent 6: Security & Environment
Analyze the codebase for:
- `.env` files and `.env.example` templates
- Environment variable usage patterns (how they're loaded, validated)
- Secret management approach (env vars, vault, AWS SSM, etc.)
- Authentication implementation details (where, how, what libraries)
- Authorization model (RBAC, ABAC, policy-based)
- Input validation patterns (where, how, what libraries)
- Dependency vulnerabilities (check lock files for known CVEs if possible)
- CORS, CSP, and security header configuration
- Sensitive data handling (PII, encryption at rest/transit)
- API key and token patterns

Output: security posture, environment map, vulnerability notes

## 3. Compile Context Files

Print: `Compiling context files from discovery results...`

From the 6 agent outputs, generate ALL relevant context files:

### Always generated:

#### .work/context/project.md
Synthesize findings into a single project overview:
- Project name and description (inferred from README, package.json, etc.)
- Tech stack summary (languages, frameworks, key libraries)
- Repository structure (directory layout with purpose of each)
- Key conventions (naming, style, organization)
- External services and integrations
- Deployment targets and environments
- Timeline/status (inferred from git activity and README)

#### .work/context/engineering.md
From architecture, patterns, quality, and conventions:
- Architecture pattern and key design decisions
- Frameworks and their specific configurations
- Code style rules (concrete, not generic)
- Testing approach: framework, runner, patterns, coverage
- Build and deploy process
- Known technical debt (with file locations)
- Performance considerations
- Common abstractions and utilities to reuse

### Department files (generate if relevant domain exists):

#### .work/context/business.md
Only if business/marketing/sales content found:
- Business domain model
- Market context (from README or docs)
- Key metrics or KPIs mentioned

#### .work/context/people.md
Only if HR/legal/policy content found:
- Team structure (from CODEOWNERS or contribution patterns)
- Policy or compliance requirements

#### .work/context/product.md
Only if product/design content found:
- User-facing features inventory
- Design system or component library details
- UX patterns in use

### Agent-specific files (generate ALL with meaningful content):

#### .work/context/coder.md
- Project-specific coding patterns to follow
- Preferred abstractions and utilities (with file paths)
- File templates and conventions for new files
- Import organization rules
- Common patterns to reuse (don't reinvent)
- Anti-patterns to avoid (specific to this codebase)

#### .work/context/security.md
- Auth implementation details (library, strategy, file locations)
- Known vulnerabilities or security concerns
- Secrets management approach
- Input validation patterns
- API security configuration
- Sensitive data handling requirements

#### .work/context/qa.md
- Test framework setup and configuration
- Test naming and organization conventions
- Mocking patterns and test utilities available
- Test data management approach
- Coverage requirements and current state
- How to run tests (exact commands)

#### .work/context/devops.md
- CI/CD pipeline details (stages, triggers, environments)
- Deployment process (manual steps, automated, blue-green, etc.)
- Environment configuration (dev, staging, prod)
- Infrastructure details (cloud provider, services used)
- Monitoring and alerting setup

#### .work/context/reviewer.md
- Project-specific review criteria beyond defaults
- Hot spots that need extra attention
- Areas with known technical debt
- Style rules not captured by linters
- Common mistakes in this codebase

#### .work/context/architect.md
- Current architecture decisions and rationale
- Scalability concerns
- Integration points and data flow
- Database schema overview
- API design patterns in use

#### .work/context/reliability.md
- Error handling patterns in this codebase
- Retry and fallback strategies
- Data integrity mechanisms
- Known failure modes
- Monitoring and alerting gaps

#### .work/context/debugger.md
- How to run the project locally
- Common debugging commands
- Log locations and formats
- Known intermittent issues
- Test commands for quick verification

Only create agent-specific files when the discovery reveals meaningful content for that agent. Skip files that would be empty or too generic to be useful.

## 4. Generate Codebase Health Report

Print: `Generating codebase health report...`

Create `.work/HEALTH.md`:

```markdown
# Codebase Health Report

## Score: X/10

## Strengths
- [What's good about this codebase]

## Concerns
- [CRITICAL] [Issue] - [location/evidence]
- [HIGH] [Issue] - [location/evidence]
- [MEDIUM] [Issue] - [location/evidence]

## Metrics
- Languages: [list]
- Files: [count]
- Test files: [count] ([ratio]% of source)
- TODOs: [count]
- FIXMEs: [count]
- Dependencies: [count] ([outdated count] outdated)
- Git commits (last 30 days): [count]
- Hotspot files: [top 5 most-changed files]

## Recommended First Actions
1. [Most impactful improvement]
2. [Second most impactful]
3. [Third most impactful]
```

## 5. Generate Config Recommendations

Read the current `.work/config.json`. Ensure it follows the template schema exactly.

Determine project-specific recommendations based on discovery findings:
- Add `model_overrides` for critical agents (e.g., `"security": "opus"` if complex security setup)
- Set `git.conventional_commits` based on what was found in history
- Set `git.use_branches` based on current git workflow
- Adjust `parallelization.max_concurrent` if needed

**CRITICAL: Only modify values within the existing template structure. Do NOT add new top-level
fields, rename fields, or restructure.**

Present recommendations using an iterative single-select loop. Do NOT ask the user to "select all that apply."

Use AskUserQuestion:
- header: "Config: Recommendations"
- question: "Discovery found <N> recommended adjustments. Apply one, or select Done when finished."
- options:
  - "<setting>: <current> -> <recommended> (Recommended)" - <one-sentence rationale>
  - "<setting>: <current> -> <recommended>" - <one-sentence rationale>
  - "<setting>: <current> -> <recommended>" - <one-sentence rationale>
  - "Done" - proceed without further changes

After each selection (except "Done"): apply the change to config.json immediately, print the updated value (e.g., `conventional_commits set to true`), then re-present the menu with that option removed.

When "Done" is selected: proceed to Step 6.

If no recommendations exist, skip this step.

## 6. Generate PROJECT.md

If `.work/PROJECT.md` doesn't exist, create it from discovery findings:
- What This Is (inferred from README and code)
- Core Value (inferred from primary functionality)
- Constraints (inferred from tech stack and architecture)
- Key Requirements (inferred from features found)
- Timeline/Status (inferred from git activity)

If `.work/PROJECT.md` exists, offer to update it with new findings.

## 7. Present Summary

Show the user:
- Codebase health score (X/10)
- Number of context files generated
- Key findings (top 3-5 most important discoveries)
- Recommended first actions

Use AskUserQuestion:
- header: "Discovery Complete"
- question: "Discovery generated <N> context files. What next?"
- options:
  - "Looks good, proceed (Recommended)" - accept all generated context and move on
  - "Review generated files" - show a summary of project.md, engineering.md, and HEALTH.md findings
  - "Re-discover" - run discovery again with different focus

When user selects "Review generated files": display a combined summary showing the project overview (project.md), engineering context (engineering.md), and health report findings (HEALTH.md score, top concerns, recommended actions), then re-present the identical AskUserQuestion.

## 8. Update State

Update STATE.md:
- Status: discovered
- Last Action: Deep codebase discovery complete (<N> context files generated)
- Next Action: Ready for work

</process>

<fast-mode>
In fast mode, reduce to 2 agents instead of 6:
- Agent 1: Stack, structure, architecture, conventions (combined)
- Agent 2: Quality, security, git history (combined)

Print: `Dispatching 2 discovery agents (fast mode)...`

Generate fewer context files: project.md, engineering.md, and only the most relevant agent-specific files (max 3).
Skip health report. Skip config recommendations.
</fast-mode>
