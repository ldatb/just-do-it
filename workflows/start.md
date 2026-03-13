<purpose>
Just do It - Full workflow: Initialize or continue a project, then execute the pipeline:
Describe -> Research -> Plan -> Build -> Verify

Config drives behavior. Preferences are set once during first-time setup and respected
automatically from that point forward.

**Optional pre-step:** Users can run `/do:brainstorm` before `/do:start` to explore and refine
their idea interactively. Brainstorming produces a BRAINSTORM.md in the phase directory with
a clear description and requirements. This is not required - `/do:start` works fine on its own.
</purpose>

<process>

## 1. Initialize Project

Check if `.work/` directory exists AND `.work/config.json` exists.

**If `.work/` does not exist or config.json does not exist (first-time setup only):**

1. Create `.work/` directory structure:
   ```
   .work/
   ├── PROJECT.md
   ├── STATE.md
   ├── config.json
   ├── capabilities.md
   └── context/
   ```

2. Copy templates from plugin `templates/` directory — config.json template is the **single source of truth** for config schema
3. Fill PROJECT.md from user's description in $ARGUMENTS
4. Initialize STATE.md with current timestamp
5. Initialize config.json from template defaults (fast_mode: false, balanced model, branches + conventional commits)

6. **First-time setup prompt** - ask user preferences via AskUserQuestion (ONCE, never again):

   Use AskUserQuestion:
   - header: "Project Setup"
   - question: "Set your preferences for this project (saved to config.json, never asked again):"
   - options:
     - "Branches + conventional commits + balanced model" - sensible defaults, recommended
     - "Branches + conventional commits + quality model" - thorough, highest quality
     - "Commits only + balanced model" - no branches, conventional commits
     - "No git + budget model" - no version control, cheapest
     - "Custom" - I'll configure config.json manually

   Save preferences to config.json. **Use the template schema exactly — do not add or rename fields.**

7. **Context detection:**
   - If the current directory has existing source code:
     Auto-run the discover workflow to generate `.work/context/` files.
   - If greenfield (empty/new project):
     Run the setup workflow - ask targeted questions to generate context files.
   - The user can always re-run `/do:discover` or `/do:setup` later.

**If `.work/` exists and config.json exists:**

1. Read `.work/STATE.md`, `.work/PROJECT.md`, and `.work/config.json`
2. Validate config.json has all required fields from the template schema. If any fields are missing,
   merge them in with template defaults (don't overwrite existing values). **Do NOT re-ask setup questions.**
3. Check `.work/context/` exists - if not, suggest `/do:discover` or `/do:setup`
4. Determine current position
5. Continue from where we left off

## 2. Determine Phase

**If no phases exist:**
Auto-create first phase: `.work/phases/01-<name>/` derived from the work description. No prompt.

**If phases exist:**
Read STATE.md. Assess the state of all phases.

### 2a. Present Status and Ask What to Do

First, give the user a clear picture of where things stand:
- **Previous phase**: name, status (complete/in-progress/needs-verify), any uncommitted changes
- **Next phase**: name, what it will accomplish
- **Loose ends**: uncommitted git changes, unmerged branches, unverified work

Then use AskUserQuestion to let the user decide what to do:

Use AskUserQuestion:
- header: "Phase Navigation"
- question: "[Status summary — e.g., 'Phase 1 (admin-api) is built but has uncommitted changes. Phase 2 (backoffice-app) is next.'] What would you like to do?"
- options:
  - "Start phase [N]" - proceed to next phase (research → plan → build → verify)
  - "Review previous work" - review what was built in the last phase before moving on
  - "Verify previous phase" - run /do:verify on the last phase
  - "Commit and continue" - commit pending changes, then start next phase
  - "Rework previous phase" - go back and modify the last phase
  - "Stop" - save state and exit

**Adapt the options to context.** Don't show "Commit and continue" if there are no uncommitted
changes. Don't show "Verify" if already verified. Only show options that make sense for the
current state.

### 2b. Execute User's Choice

Based on the user's selection:
- **Start phase N**: proceed to step 2c
- **Review**: show BUILD.md and key files from previous phase, then re-ask
- **Verify**: run the verify workflow on previous phase, then re-ask
- **Commit and continue**: commit changes, then proceed to step 2c
- **Rework**: re-enter the previous phase's build step
- **Stop**: save STATE.md and exit

### 2c. Confirm Next Phase

Present the next phase summary:
- **Phase**: number and name
- **Goal**: what this phase will accomplish (from STATE.md or $ARGUMENTS)
- **Prerequisites**: what's already done that this phase builds on
- **Pipeline**: research → plan → build → verify

Create the phase directory if it doesn't exist:
```
.work/phases/XX-<name>/
```

## 3. Git Branch (if configured)

Read `git.use_branches` from config.json.

**If `use_branches` is true:**
Determine branch type from the work description:
- New feature -> `feat/<phase-name>`
- Bug fix -> `fix/<phase-name>`
- Refactor -> `refactor/<phase-name>`
- Documentation -> `docs/<phase-name>`
- Maintenance -> `chore/<phase-name>`
- Performance -> `perf/<phase-name>`
- CI/CD -> `ci/<phase-name>`
- Tests -> `test/<phase-name>`

Auto-create the branch. No prompt.

**If `use_branches` is false or git mode is "none":**
Skip this step entirely.

## 4. Research

### 4a. Dispatch Research Agents

**If BRAINSTORM.md exists** in the phase directory, use it as input for research. The brainstorm
summary contains requirements, constraints, open questions, and alternatives considered - feed
these to the researcher agents so they can focus on what matters.

Read `fast_mode` from config.json.

**If fast mode:** Use the **Agent tool** to dispatch a single `do-researcher` agent. Brief scan, essential findings only.
**If normal mode:** Use the **Agent tool** to dispatch multiple `do-researcher` agents **in parallel** (libraries, architecture, risks).

**CRITICAL: "Dispatch" means use the Agent tool with `subagent_type: "do-researcher"`.
You are an orchestrator. You do NOT do the research yourself. You launch agent subprocesses.**

Read `.work/config.json` to resolve the model for each agent.

Each researcher writes findings. You (the orchestrator) compile their outputs into `RESEARCH.md` in the phase directory.

### 4b. Present Research Findings and Ask for Direction (MANDATORY)

**You MUST present findings to the user and ask about key decisions before proceeding to planning.**

After compiling RESEARCH.md, analyze the findings and identify:
1. **Decisions that need user input** — e.g., which library to use, which architecture pattern, which approach
2. **Tradeoffs the user should know about** — e.g., "Option A is faster to build but harder to extend"
3. **Things the user probably hasn't thought about** — risks, edge cases, dependencies, constraints

**Think ahead of the user.** Your job is to surface decisions they don't know they need to make.
For example:
- "Should we use SSR or SPA? SSR is better for SEO but adds server complexity."
- "There are 3 auth libraries that fit. Lucia is simplest, Auth.js has most features, custom gives most control."
- "This will need a database migration — do you want to handle that now or in a separate phase?"
- "The design kit you linked uses Tailwind but this project uses vanilla CSS — should we add Tailwind?"

Present findings as a brief summary with your recommendation, then use AskUserQuestion for each
key decision. Use single-choice for either/or decisions, multi-choice when the user can pick several.

**Format:**

1. Print research summary (3-5 bullets of key findings with tradeoffs)
2. For each decision point, use AskUserQuestion:
   - header: "Research: [Decision Topic]"
   - question: "[Clear question with context on why it matters]"
   - options: [2-4 concrete options, each with a brief tradeoff note]

**Example:**
```
Research found 3 viable approaches for the component library:

- **Shadcn/ui**: Copy-paste components, full control, Tailwind-based. Most popular in 2025.
- **Skeleton UI**: SvelteKit-native, built-in themes, good DX. Smaller community.
- **Custom from scratch**: Maximum flexibility but 3x more work.

AskUserQuestion:
  header: "Component Library"
  question: "Which component approach fits your needs? (Shadcn is most flexible, Skeleton is fastest to ship)"
  options:
    - "Shadcn/ui" - copy-paste components, full customization, Tailwind required
    - "Skeleton UI" - SvelteKit-native, themed, fastest to ship
    - "Custom" - build from scratch, most work but total control
```

Keep decision questions to 2-4 max. Don't ask about things config already answers.
Only ask about decisions that genuinely affect the plan.

After getting answers, save the decisions to RESEARCH.md under a `## Decisions` section.

## 5. Plan

### 5a. Generate Plan

Read `fast_mode` from config.json. Read the decisions from RESEARCH.md step 4b.

**If fast mode:** Produce a minimal `PLAN.md` - single wave, key tasks, brief.
**If normal mode:** Produce a detailed `PLAN.md` with waves, agents, verify steps.

The plan MUST reflect the user's decisions from the research phase. Do not override their choices.

Plan format:
1. Phase goal (one sentence)
2. Requirements covered
3. Decisions made (reference what user chose in step 4b)
4. Agent selection using mandatory dispatch rules from agent-roster.md:
   - Classify work domain
   - Select ALL relevant agents (not just do-coder)
   - Design agents (architect, product) in Wave 1 BEFORE implementation
   - Verify agents (qa, reviewer + conditional) in final wave
5. Tasks grouped by wave - each specifies: agent, files, action, verify, done criteria
6. Success criteria

Write `PLAN.md` to phase directory.

### 5b. Surface Planning Decisions (if any remain)

After generating the plan, check if there are implementation-level decisions the user should weigh in on.
These are decisions that emerged DURING planning that weren't covered in research.

Examples:
- "Should the API use REST or GraphQL?"
- "Do you want pagination on this list or infinite scroll?"
- "Should we split this into 2 phases or do it all at once?"

If there are such decisions, use AskUserQuestion for each (2-3 max).
If no new decisions — skip this step.

### 5c. Present the Plan to the User (MANDATORY)

**You MUST explain the plan to the user before asking for approval. This is not optional.**

Print a clear summary that includes:
- **Goal**: What this phase achieves (one sentence)
- **Decisions**: What the user chose and how it shapes the plan
- **Approach**: How you'll build it (the key technical/design decisions)
- **Agents**: Which specialist agents will be dispatched and why
- **Waves**: The execution order (e.g., "Wave 1: Architecture decisions → Wave 2: Implementation → Wave 3: Verification")
- **Key files**: What will be created or modified

This is your chance to align with the user. Explain the WHY, not just the WHAT.
The user should understand the plan well enough to give informed approval.

THEN use AskUserQuestion:
- header: "Plan Review"
- question: "Ready to build?"
- options:
  - "Go" - approve and start execution
  - "Adjust" - modify the plan before building
  - "Stop" - save state and exit

## 6. Build

**Follow the build workflow in `build.md` exactly.** The key principles:

1. **Pass file PATHS to agents, not file CONTENTS** — each agent gets a fresh 200k context window
2. **Use the Agent tool** to dispatch agents in parallel (respecting `max_concurrent`)
3. Agents write their results to `.work/phases/XX/agent-results/<agent>.md`
4. Keep orchestrator context lean — don't carry full agent outputs
5. Brief status updates per wave

**CRITICAL: You are a LEAN orchestrator. Do NOT read file contents to paste into prompts.
Do NOT carry agent results in your context. Do NOT write application code yourself.
If an agent fails, ask the user — NEVER fall back to doing it yourself.**

### File Permissions

Before dispatching agents, list ALL absolute file paths they will write to.
If any are outside the project directory, tell the user and get approval FIRST.
Subagents CANNOT prompt for permissions — they fail silently.

No per-wave confirmation prompt.

### Git Commits During Build

After each wave, read `git.mode` and `git.conventional_commits` from config.json.

**If git mode is not "none" and `conventional_commits` is true:**
Auto-commit after each wave. Stage specific files only (never `git add .`).
Commit message follows conventional commits format:
```
<type>: <description>
```

No prompt. No confirmation. Just commit.

**If git mode is "none":**
Skip commits entirely.

## 7. Verify

Read `fast_mode` from config.json.

**If fast mode:** Use the **Agent tool** to dispatch only `do-qa` + `do-reviewer` (2 agents).
**If normal mode:** Use the **Agent tool** to dispatch all relevant specialists.

**Use the Agent tool** to dispatch verification agents in parallel:
- `do-qa` - always
- `do-reviewer` - always
- `do-security` - if security-relevant files were touched
- `do-reliability` - if error handling / data integrity relevant
- `do-devops` - if infra files were touched

No prompt for which specialists. Config and file analysis decide.

Each agent reviews from its perspective. You (the orchestrator) compile results into `VERIFY.md`.

**If any CRITICAL findings:**

Use AskUserQuestion:
- header: "CRITICAL Issues Found"
- question: "Verification found critical issues. What to do?"
- options:
  - "Fix now" - address critical issues immediately
  - "Review findings" - see details before deciding
  - "Save for later" - save state, fix next session

**If PASS:**

Print "Phase complete." Auto-proceed to step 8.

## 8. Complete

Update STATE.md:
- Mark current phase as complete
- Set next action (next phase or "project complete")

Read `git.use_branches` from config.json.

**If `use_branches` is true and a branch exists:**
Auto-merge to main and delete the branch. No prompt.

**If more phases remain:**
Auto-proceed to the next phase from STATE.md.

**If all phases complete:**
Print "Project complete." Stop.

</process>

<warning>
## Orchestrator Role (CRITICAL)

You are an ORCHESTRATOR, not a worker. Your job is to:
1. Read config and state
2. Make dispatch decisions
3. Use the **Agent tool** to launch specialist agents (do-coder, do-researcher, do-architect, etc.)
4. Compile their results into summary files (RESEARCH.md, BUILD.md, VERIFY.md)
5. Present results to the user and get approval where required

You do NOT:
- Write application code yourself (that's do-coder's job)
- Do research yourself (that's do-researcher's job)
- Make architecture decisions yourself (that's do-architect's job)
- Review code yourself (that's do-reviewer's job)

The only files you write directly are orchestration files: STATE.md, BUILD.md, RESEARCH.md, VERIFY.md, PLAN.md.

## User Communication (CRITICAL)

You MUST keep the user informed at key milestones:
- After research: summarize key findings (2-3 bullets)
- After planning: EXPLAIN the plan in detail before asking for approval
- After each build wave: brief status update
- After verification: summarize findings

Do NOT silently generate artifacts. The user should always know what's happening and why.

## Settings-Driven

config.json controls behavior. Only two things require user input: plan approval (because plans
need human review) and critical findings (because they may require judgment calls). Everything
else - branches, commits, research, wave dispatch, merges - runs automatically according to config.

First-time setup preferences are asked once and never again. If you want to change behavior,
edit .work/config.json directly.
</warning>
