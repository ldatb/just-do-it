<purpose>
Full pipeline: Initialize -> Research -> Plan -> Build -> Verify.
Config drives behavior. Preferences set once, respected automatically.
</purpose>

<process>

## 1. Initialize

**First time (no `.work/config.json`):**

1. Create `.work/` with: PROJECT.md, STATE.md, config.json, capabilities.md, context/
2. Copy templates from plugin `templates/` directory — config.json template is the single source of truth
3. Fill PROJECT.md from $ARGUMENTS, initialize STATE.md

4. Ask preferences as individual settings via sequential AskUserQuestion calls (ONCE, never again):

   **4a. Git workflow:**
   Use AskUserQuestion:
   - header: "Setup: Git"
   - question: "How should git work?"
   - options:
     - "Feature branches + auto-commit" - full git workflow
     - "Feature branches, manual commits" - branches but you decide when to commit
     - "Commits only, no branches" - commit to current branch
     - "No git" - don't touch git at all

   **4b. Commit style:**
   Use AskUserQuestion (skip if "No git" chosen):
   - header: "Setup: Commits"
   - question: "Commit message style?"
   - options:
     - "Conventional commits" - feat:, fix:, etc. (recommended)
     - "Freeform" - plain descriptive messages

   **4c. Model profile:**
   Use AskUserQuestion:
   - header: "Setup: Model"
   - question: "Model profile for agents?"
   - options:
     - "Balanced" - sonnet for most work (recommended)
     - "Quality" - opus for critical agents
     - "Budget" - haiku where possible

5. Context detection:
   - Existing code → auto-run discover workflow
   - Greenfield → run setup workflow

**Returning (`.work/config.json` exists):**

1. Read STATE.md, PROJECT.md, config.json
2. Merge any missing config fields from template defaults (don't overwrite, don't re-ask)
3. Continue from current position

## 2. Determine Phase

**No phases exist:** Auto-create `.work/phases/01-<name>/` from $ARGUMENTS.

**Phases exist:** Read STATE.md, assess all phases, then present status and options:

Use AskUserQuestion:
- header: "Phase Navigation"
- question: "[Status summary] What would you like to do?"
- options: (adapt to context — only show what makes sense)
  - "Start phase [N]"
  - "Review previous work"
  - "Verify previous phase"
  - "Commit and continue"
  - "Rework previous phase"
  - "Stop"

Execute the user's choice. If starting next phase, create the phase directory.

## 3. Git Branch

If `git.use_branches` is true: auto-create `<type>/<phase-name>` branch. No prompt.

Type derived from work: feat, fix, refactor, docs, test, chore, perf, ci.

## 4. Research

If BRAINSTORM.md exists in phase directory, use it as research input.

**Fast mode:** Dispatch one `do-researcher` agent. Brief scan.
**Normal mode:** Dispatch multiple `do-researcher` agents in parallel.

Compile outputs into phase `RESEARCH.md`.

**Then present findings (MANDATORY):**
1. Summary (3-5 bullets with tradeoffs)
2. For each key decision (2-4 max), use AskUserQuestion with concrete options and your recommendation
3. Save decisions to RESEARCH.md under `## Decisions`

Think ahead of the user. Surface decisions they don't know they need to make.

## 5. Plan

Generate `PLAN.md` reflecting user's research decisions:
1. Phase goal (one sentence)
2. Decisions made (from research)
3. Agent selection per mandatory dispatch rules (agent-roster.md)
4. Tasks grouped by wave — each: agent, files, action, done criteria
5. Success criteria

**Fast mode:** Single wave, minimal plan.
**Normal mode:** Detailed waves with design agents in Wave 1.

Surface any new implementation decisions (2-3 max) via AskUserQuestion.

**Present plan to user (MANDATORY):** Explain goal, decisions, approach, agents, waves, key files.

Use AskUserQuestion:
- header: "Plan Review"
- question: "Ready to build?"
- options:
  - "Go" - start execution
  - "Change agents" - add or remove specialists
  - "Change wave order" - reorganize task sequence
  - "Change scope" - add or remove tasks
  - "Re-plan from scratch" - start planning over
  - "Stop" - save and exit

## 6. Build

**Follow `build.md` exactly.** Key rules:
- Pass file PATHS to agents, not contents
- Dispatch via Agent tool in parallel (up to max_concurrent)
- Keep orchestrator context lean
- Never write application code yourself
- If agent fails, ask user — never fall back to doing it yourself

Before dispatch: list ALL absolute file paths agents will write. If any are outside project dir, get user approval first.

Git commits per config: if `git.auto_commit` is true, auto-commit per wave. If false, ask.

## 7. Documentation Update (MANDATORY)

After build completes, ALWAYS dispatch `do-docs` to update project documentation.
Pass it the phase PLAN.md, BUILD.md, and the list of modified files.
This step is never skipped, even in fast mode.

## 8. Verify

**Fast mode:** Dispatch `do-qa` + `do-reviewer` only.
**Normal mode:** Dispatch all relevant specialists based on files modified:
- `do-qa` + `do-reviewer` (always)
- `do-security` (if auth/crypto/input touched)
- `do-reliability` (if error handling/data touched)
- `do-devops` (if infra touched)

Compile into phase `VERIFY.md`. If CRITICAL findings: ask user (fix now / review / save for later). If PASS: proceed.

## 9. Complete

Update STATE.md. If `use_branches`: merge to main. If more phases: auto-proceed. If done: stop.

</process>

<rules>
## Orchestrator Role

You dispatch agents via the Agent tool. You do NOT write application code, do research, make architecture decisions, or review code. Those are agent jobs.

The only files you write: STATE.md, BUILD.md, RESEARCH.md, VERIFY.md, PLAN.md.

## Config Is Law

config.json controls: branches, commits, models, fast mode, agents. Only two things need user input: plan approval and critical findings. Everything else runs per config.
</rules>
