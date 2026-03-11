<purpose>
Just do It - Full workflow: Initialize or continue a project, then execute the pipeline:
Describe -> Research -> Plan -> Build -> Verify

All operations are interactive. The user is always in the loop.

**Optional pre-step:** Users can run `/do:brainstorm` before `/do:start` to explore and refine
their idea interactively. Brainstorming produces a BRAINSTORM.md in the phase directory with
a clear description and requirements. This is not required - `/do:start` works fine on its own.
</purpose>

<process>

## 1. Initialize Project

Check if `.work/` directory exists.

**If `.work/` does not exist:**

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
6. Generate capabilities.md

7. **Setup prompts** - ask user preferences via AskUserQuestion:

   Use AskUserQuestion:
   - header: "Git Workflow"
   - question: "How should we handle git?"
   - options:
     - "Branches + conventional commits" - create feature branches (feat/, fix/, chore/, etc.), conventional commit messages
     - "Commits only" - commit to current branch with conventional commit messages
     - "No git" - don't touch git at all

   Use AskUserQuestion:
   - header: "Model Profile"
   - question: "Which model profile?"
   - options:
     - "quality" - best output, highest cost (opus for critical agents)
     - "balanced" - good results, reasonable cost (default)
     - "budget" - fast and cheap (haiku for most agents)

   Use AskUserQuestion:
   - header: "Work Mode"
   - question: "How fast do you want to move?"
   - options:
     - "Interactive" - full ceremony, confirm every step
     - "Fast" - reduced ceremony, shorter research/verify

   Save all preferences to config.json and capabilities.md.

8. **Context detection:**
   - If the current directory has existing source code:
     Auto-run the discover workflow to generate `.work/context/` files.
   - If greenfield (empty/new project):
     Run the setup workflow - ask targeted questions to generate context files.
   - The user can always re-run `/do:discover` or `/do:setup` later.

**If `.work/` exists:**

1. Read `.work/STATE.md` and `.work/PROJECT.md`
2. Check `.work/context/` exists - if not, suggest `/do:discover` or `/do:setup`
3. Determine current position
4. Continue from where we left off

## 2. Determine Phase

**If no phases exist:**
Create first phase: `.work/phases/01-<name>/`

**If phases exist:**
Find the next incomplete phase from STATE.md

Use AskUserQuestion:
- header: "Phase"
- question: "Starting phase: XX-<name>. Proceed?"
- options:
  - "Yes, start this phase"
  - "Rename it" - change the phase name
  - "Skip to a different phase"

Create the phase directory:
```
.work/phases/XX-<name>/
```

## 3. Git Branch (if configured)

If `git.use_branches` is true in config:

Determine branch type from the work description:
- New feature -> `feat/<phase-name>`
- Bug fix -> `fix/<phase-name>`
- Refactor -> `refactor/<phase-name>`
- Documentation -> `docs/<phase-name>`
- Maintenance -> `chore/<phase-name>`
- Performance -> `perf/<phase-name>`
- CI/CD -> `ci/<phase-name>`
- Tests -> `test/<phase-name>`

Use AskUserQuestion:
- header: "Git Branch"
- question: "Create branch: <type>/<phase-name>?"
- options:
  - "Yes, create it"
  - "Change the name" - customize branch name
  - "Skip branching" - work on current branch

## 4. Research

**If BRAINSTORM.md exists** in the phase directory, use it as input for research. The brainstorm
summary contains requirements, constraints, open questions, and alternatives considered - feed
these to the researcher agents so they can focus on what matters.

**If fast mode:** Quick research - 1 agent, essential findings only.
**If normal mode:** Full research - multiple angles.

Read `.work/config.json` to resolve model for `researcher` agent.

Dispatch `do-researcher` agent(s):
- Normal: one agent per research angle (libraries, architecture, risks), parallel
- Fast: single agent, brief scan

Each researcher writes findings. Orchestrator compiles into `RESEARCH.md` in the phase directory.

Use AskUserQuestion:
- header: "Research Complete"
- question: "Research findings ready. How to proceed?"
- options:
  - "Looks good, plan it" - proceed to planning
  - "More research" - dig deeper on specific topics
  - "Skip to planning" - enough context already

## 5. Plan

Dispatch orchestrator to create `PLAN.md`:

**If fast mode:** Minimal plan - single wave, key tasks only, brief.
**If normal mode:** Detailed plan with waves, agents, verify steps.

1. Define phase goal (one sentence)
2. List requirements covered
3. Break into tasks grouped by wave
4. Each task specifies: agent, files, action, verify, done criteria
5. Define success criteria

Write `PLAN.md` to phase directory.

**Always show the plan to the user, even in fast mode.**

Use AskUserQuestion:
- header: "Plan Review"
- question: "Here's the plan. How to proceed?"
- options:
  - "Approve, build it" - start execution
  - "Modify" - adjust the plan
  - "Reject, replan" - start planning over
  - "Save for later" - save state and stop

## 6. Build

Read PLAN.md. For each wave:

1. Show which agents will be dispatched for this wave

   Use AskUserQuestion:
   - header: "Wave N Execution"
   - question: "Dispatching: [agent list]. Proceed?"
   - options:
     - "Yes, execute" - run agents
     - "Modify agents" - change which agents run
     - "Save for later" - save state and stop

2. Resolve model for each task's agent from config
3. Dispatch agents in parallel (respecting max_concurrent)
4. Each agent reads context files + PLAN.md for its task, executes, reports back
5. Compile results into `BUILD.md`
6. Proceed to next wave

Update STATE.md after each wave.

### Git Commits During Build

After each wave, if code was modified and git is configured:

Use AskUserQuestion:
- header: "Commit Changes"
- question: "Wave N complete. Commit? [show files + proposed message]"
- options:
  - "Yes, commit" - commit with proposed message
  - "Edit message" - modify the commit message
  - "Skip" - don't commit now

Commit message follows conventional commits:
```
<type>: <description>
```

Stage specific files only (never `git add .`).

## 7. Verify

**If fast mode:** Only `do-qa` + `do-reviewer` (2 agents).
**If normal mode:** All relevant specialists.

Dispatch verification agents in parallel:
- `do-qa` - always
- `do-reviewer` - always
- `do-security` - if security-relevant files were touched
- `do-reliability` - if error handling / data integrity relevant
- `do-devops` - if infra files were touched

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

Use AskUserQuestion:
- header: "Phase Complete"
- question: "All checks passed. What next?"
- options:
  - "Next phase" - proceed to next phase
  - "Done for now" - save state and stop
  - "Review details" - see full verification report

## 8. Complete

Update STATE.md:
- Mark current phase as complete
- Set next action (next phase or "project complete")

If git is configured and branch exists:

Use AskUserQuestion:
- header: "Branch Complete"
- question: "Phase done on branch <name>. What to do?"
- options:
  - "Merge to main" - merge and delete branch
  - "Create PR" - push and create pull request
  - "Leave on branch" - keep for later

</process>

<warning>
This plugin is interactive by design. Every significant action requires user approval.
There is no autonomous mode. If agents are running without user oversight, something is wrong.

Git commits, pushes, and destructive actions ALWAYS require explicit user confirmation.
</warning>
