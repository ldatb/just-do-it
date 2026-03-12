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

2. Copy templates from plugin `templates/` directory
3. Fill PROJECT.md from user's description in $ARGUMENTS
4. Initialize STATE.md with current timestamp
5. Initialize config.json with defaults

6. **First-time setup prompt** - ask user preferences via AskUserQuestion (ONCE, never again):

   Use AskUserQuestion:
   - header: "Project Setup"
   - question: "Set your preferences for this project (saved to config.json, never asked again):"
   - options:
     - "Branches + conventional commits + balanced model + fast mode" - sensible defaults, minimal ceremony
     - "Branches + conventional commits + quality model + interactive mode" - thorough, highest quality
     - "Commits only + balanced model + fast mode" - no branches, conventional commits, fast
     - "No git + budget model + fast mode" - no version control, cheapest, quickest
     - "Custom" - I'll configure config.json manually

   Save all preferences to config.json and capabilities.md.

7. **Context detection:**
   - If the current directory has existing source code:
     Auto-run the discover workflow to generate `.work/context/` files.
   - If greenfield (empty/new project):
     Run the setup workflow - ask targeted questions to generate context files.
   - The user can always re-run `/do:discover` or `/do:setup` later.

**If `.work/` exists and config.json exists:**

1. Read `.work/STATE.md`, `.work/PROJECT.md`, and `.work/config.json`
2. Check `.work/context/` exists - if not, suggest `/do:discover` or `/do:setup`
3. Determine current position
4. Continue from where we left off

## 2. Determine Phase

**If no phases exist:**
Auto-create first phase: `.work/phases/01-<name>/` derived from the work description. No prompt.

**If phases exist:**
Read STATE.md. Find the next incomplete phase and auto-select it.

If the next phase is genuinely ambiguous (e.g. multiple incomplete phases in non-obvious order),
use AskUserQuestion to ask which phase to continue. Otherwise skip the prompt.

Create the phase directory:
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

**If BRAINSTORM.md exists** in the phase directory, use it as input for research. The brainstorm
summary contains requirements, constraints, open questions, and alternatives considered - feed
these to the researcher agents so they can focus on what matters.

Read `fast_mode` from config.json.

**If fast mode:** Dispatch a single `do-researcher` agent, brief scan, essential findings only.
**If normal mode:** Dispatch multiple `do-researcher` agents in parallel (libraries, architecture, risks).

Read `.work/config.json` to resolve the model for each `do-researcher` agent.

Each researcher writes findings. Orchestrator compiles into `RESEARCH.md` in the phase directory.

Auto-proceed to planning. No prompt.

## 5. Plan

Read `fast_mode` from config.json.

**If fast mode:** Dispatch orchestrator to produce a minimal `PLAN.md` - single wave, key tasks, brief.
**If normal mode:** Dispatch orchestrator to produce a detailed `PLAN.md` with waves, agents, verify steps.

Plan format:
1. Phase goal (one sentence)
2. Requirements covered
3. Agent selection using mandatory dispatch rules from agent-roster.md:
   - Classify work domain
   - Select ALL relevant agents (not just do-coder)
   - Design agents (architect, product) in Wave 1 BEFORE implementation
   - Verify agents (qa, reviewer + conditional) in final wave
4. Tasks grouped by wave - each specifies: agent, files, action, verify, done criteria
5. Success criteria

Write `PLAN.md` to phase directory.

**Always show the plan to the user, even in fast mode.**

Use AskUserQuestion:
- header: "Plan Review"
- question: "Here's the plan. Ready to build?"
- options:
  - "Go" - approve and start execution
  - "Adjust" - modify the plan before building
  - "Stop" - save state and exit

## 6. Build

Read PLAN.md. For each wave:

1. Resolve model for each task's agent from config.json
2. Dispatch agents in parallel (respecting `max_concurrent` from config)
3. Each agent reads context files + PLAN.md for its task, executes, reports back
4. Compile results into `BUILD.md`
5. Update STATE.md
6. Proceed to next wave automatically

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

**If fast mode:** Dispatch only `do-qa` + `do-reviewer` (2 agents).
**If normal mode:** Dispatch all relevant specialists.

Dispatch verification agents in parallel:
- `do-qa` - always
- `do-reviewer` - always
- `do-security` - if security-relevant files were touched
- `do-reliability` - if error handling / data integrity relevant
- `do-devops` - if infra files were touched

No prompt for which specialists. Config and file analysis decide.

Each agent reviews from its perspective. Compile results into `VERIFY.md`.

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
This workflow is settings-driven. config.json controls behavior. Only two things require user
input: plan approval (because plans need human review) and critical findings (because they may
require judgment calls). Everything else - branches, commits, research, wave dispatch, merges -
runs automatically according to config.

First-time setup preferences are asked once and never again. If you want to change behavior,
edit .work/config.json directly.
</warning>
