<purpose>
Primary entry point. Handles first-run initialization, returning-user continuation, and new phase creation.
Absorbs discover, setup, and resume. Config drives all automated behavior - once set, no re-asking.
</purpose>

<process>

## 1. Initialize

### First run (no `.work/config.json`)

1. Create `.work/` with: PROJECT.md, STATE.md, config.json, capabilities.md, context/
2. Copy templates from plugin `templates/` directory - config.json template is the single source of truth
3. Fill PROJECT.md from $ARGUMENTS, initialize STATE.md

4. Detect environment (no questions):
   - Is git present? (sets git question visibility)
   - Do files exist beyond `.git` and dotfiles? (existing codebase vs greenfield)
   - Are conventional commits used in git history? (sets default for conventional_commits)

5. Ask setup questions sequentially. Maximum 3 questions total before research starts.

   **Question A: Git workflow** (skip entirely if git is not present)

   Use AskUserQuestion:
   - header: "Setup: Git"
   - question: "How should git work during builds?"
   - options:
     - "Feature branches + auto-commit (Recommended)" - a branch per phase; commits auto after each wave; zero git friction
     - "Feature branches, manual commits" - branches created automatically; you approve each commit
     - "Commits only" - commit to current branch; no branch management
     - "No git" - don't touch git; you manage version control manually

   **Question B: Model profile**

   Use AskUserQuestion:
   - header: "Setup: Models"
   - question: "Which model profile should agents use?"
   - options:
     - "Balanced (Recommended)" - sonnet for all agents; best cost-quality tradeoff
     - "Quality" - opus for critical agents (architect, security, reviewer); costs ~3x more
     - "Budget" - haiku where possible; fastest and cheapest, lower quality

   **Question C: Codebase context** (only if existing files detected)

   Use AskUserQuestion:
   - header: "Setup: Context"
   - question: "This looks like an existing codebase. How should agents learn about it?"
   - options:
     - "Deep discovery - analyze everything (Recommended)" - 6 agents read the full codebase; takes a minute but makes all future agents smarter
     - "Quick scan - stack and structure only" - 2 agents, fast, enough for most tasks
     - "Skip - I'll describe context manually" - no discovery; agents use only what you tell them

   If no existing files (greenfield), skip Question C. Maximum 2 questions for greenfield — Questions A and B above are sufficient. Auto-detect project type from $ARGUMENTS:
   - If $ARGUMENTS mentions code, API, app, service, library, CLI, backend, frontend, database, or infrastructure -> project_type = "engineering"
   - If $ARGUMENTS mentions marketing, strategy, content, plan, campaign, sales, HR, legal, finance, or operations -> project_type = "business"
   - Otherwise -> project_type = "engineering" (default)
   Write the inferred project_type to config.json. Do NOT ask about it.

6. After questions complete:
   - Write answers to config.json
   - If existing codebase and discovery chosen: print `Existing codebase detected. Running discovery to build agent context...` then run discover workflow at the depth selected
   - If greenfield: create context files from answers, proceed to pipeline
   - Proceed to Step 3 (Git Branch)

### Returning user (`.work/config.json` exists)

1. Read STATE.md, PROJECT.md, config.json
2. Merge any missing config fields from template defaults (never overwrite existing values, never re-ask)
3. Display context block:

```
Project: <name>
Phase: <phase-name> (<step>)
Last: <last action from STATE.md>
Next: <next action from STATE.md>

Phases:
  [x] <completed-phase> - complete
  [>] <current-phase> - in progress
  [ ] <pending-phase> - pending
```

4. If $ARGUMENTS is provided: print `Resuming project: <name>` and proceed directly to Step 2 (Determine Phase) with the new description. Skip navigation question.

5. If no $ARGUMENTS: present context-sensitive navigation question.

   **If mid-phase (build or verify in progress):**

   Use AskUserQuestion:
   - header: "Continue"
   - question: "<phase-name> is in progress. What would you like to do?"
   - options:
     - "Continue from where I left off (Recommended)" - resume <next action from STATE.md>
     - "Show what was built" - review BUILD.md before continuing
     - "Re-verify previous phase" - run verify again on the previous phase
     - "Start a new phase" - begin something new without resuming current

   **If phase complete, next phase pending:**

   Use AskUserQuestion:
   - header: "Continue"
   - question: "<phase-name> is complete. Ready to start <next-phase>?"
   - options:
     - "Start <next-phase> (Recommended)" - begin next planned phase
     - "Review <phase-name> results" - check what was built before moving on
     - "Re-verify <phase-name>" - run verify again
     - "Change direction" - define a different next phase

## 2. Determine Phase

**No phases exist:** Auto-create `.work/phases/01-<name>/` from $ARGUMENTS. Print: `Creating phase 01-<name>...`

**Phases exist, new $ARGUMENTS provided:** Auto-create next numbered phase directory. Print: `Creating phase <N>-<name>...`

**Phases exist, continuing:** Use current phase from STATE.md.

## 3. Git Branch

Before doing anything else in this step, use `TodoWrite` to create a task list for the remaining pipeline:

- `Git branch setup`
- `Research`
- `Plan`
- `Build — Wave N` (one entry per wave, derived from PLAN.md once it exists; update/add these when Plan is done)
- `Documentation update`
- `Verify`
- `Complete & merge`

Mark `Git branch setup` as `in_progress` immediately, then `completed` when done.
Mark each step `in_progress` when you enter it, `completed` when you leave it.
This tracker is the canonical view of progress — never let it go stale.

If `git.use_branches` is true: print `Creating branch feat/<phase-name>...` then auto-create `feat/<phase-name>` branch.

Type derived from work: feat, fix, refactor, docs, test, chore, perf, ci.

## 4. Research

If BRAINSTORM.md exists in phase directory, use it as research input.

Print: `Running research...`

**Fast mode:** Dispatch one `do-researcher` agent. Brief scan.
**Normal mode:** Dispatch multiple `do-researcher` agents in parallel.

Compile outputs into phase `RESEARCH.md`.

**Then present findings (MANDATORY):**
1. Summary (3-5 bullets with tradeoffs)
2. For each key decision (2-4 max), use AskUserQuestion with concrete options and your recommendation
3. Save decisions to RESEARCH.md under `## Decisions`

Think ahead of the user. Surface decisions they don't know they need to make.

## 5. Plan

Print: `Planning...`

Generate `PLAN.md` reflecting user's research decisions:
1. Phase goal (one sentence)
2. Decisions made (from research)
3. Agent selection per mandatory dispatch rules (agent-roster.md)
4. Tasks grouped by wave - each: agent, files, action, done criteria
5. Success criteria

**Fast mode:** Single wave, minimal plan.
**Normal mode:** Detailed waves with design agents in Wave 1.

Surface any new implementation decisions (2-3 max) via AskUserQuestion.

**Present plan to user (MANDATORY):**

Use AskUserQuestion:
- header: "Plan Review"
- question: "<N> waves, <M> agents, ~<K> files. Ready to build?"
- options:
  - "Go (Recommended)" - start execution as planned
  - "Change agents" - add or remove specialists from the roster
  - "Change scope" - add or remove tasks from the plan
  - "Stop" - save plan and exit without building

After user approves, update the todo list via `TodoWrite`:
- Mark `Plan` as `completed`
- Replace the generic `Build — Wave N` placeholder todos with one todo per actual wave from PLAN.md (e.g. `Wave 1: Design — do-architect`, `Wave 2: Build — do-coder, do-security`)

## 6. Build

Print: `Building...`

**Respect PLAN.md `## Complexity` line** (see `references/intelligence.md` § Cost-Aware Routing):
- **trivial**: dispatch `do-coder` only. Skip Wave 1 entirely. After coder finishes, jump to Step 9 (Complete). Announce: `Skipping Docs + Verify waves (complexity: trivial).`
- **simple**: dispatch `do-coder` (no design wave). Announce: `Skipping Design wave (complexity: simple).`
- **standard / complex**: run all waves per plan.

**Follow `build.md` exactly.** Key rules:
- Pass file PATHS to agents, not contents
- Dispatch via Agent tool in parallel (up to max_concurrent)
- Keep orchestrator context lean
- Never write application code yourself
- If agent fails, ask user - never fall back to doing it yourself

Before dispatch: list ALL absolute file paths agents will write. If any are outside project dir, get user approval first.

Git commits per config:
- If `git.auto_commit` is true: print `Auto-committing: <type>: <description> (<N> files)...` then commit.
- If false: ask user before committing.

## 7. Documentation Update

**Respect complexity classification:**
- **trivial**: skip entirely. Announce: `Skipping Docs (complexity: trivial).`
- **simple**: skip unless README, public API, or user-facing surface was modified. Announce the skip or the dispatch explicitly.
- **standard / complex**: always dispatch `do-docs`.

Print: `Dispatching do-docs to update project documentation.`

Dispatch `do-docs` with the phase PLAN.md, BUILD.md, and the list of modified files.

## 8. Verify

**Respect complexity classification:**
- **trivial**: skip the entire Verify wave. Announce: `Skipping Verify (complexity: trivial).` Run any available linter/test command via Bash as a sanity check instead.
- **simple**: dispatch `do-reviewer` only (covers style + obvious test gaps). Skip `do-qa` and all specialists.
- **standard (fast mode)**: dispatch `do-qa` + `do-reviewer` only.
- **standard / complex (normal mode)**: dispatch all relevant specialists based on files modified:
  - `do-qa` + `do-reviewer` (always)
  - `do-security` (if auth/crypto/input touched)
  - `do-reliability` (if error handling/data touched)
  - `do-devops` (if infra touched)

Print: `Verifying...`

Compile into phase `VERIFY.md`.

Run the auto-fix loop from `workflows/verify.md` §6: dispatch `do-coder` to fix all CRITICAL + HIGH in one pass, re-dispatch specialists, re-apply consensus, loop up to `verify.auto_fix.max_iterations` (default 3). No per-finding prompts.

MEDIUM and LOW findings: always logged to VERIFY.md, never prompted.

Loop exit paths:
- **All CRITICAL + HIGH cleared:** proceed to §9.
- **Loop exhausted, blockers remain:** present the single summary AskUserQuestion from `verify.md` §6 (Show findings and stop / Run N more iterations / Accept remaining and proceed).

## 9. Complete

Print: `Phase <N> complete.`

Update STATE.md.

If `git.use_branches` is true: print `Merging feat/<phase-name> to main...` then merge.

If more phases pending: print `Phase <N> complete. Starting phase <N+1>: <name>...` then auto-proceed.

If all done: stop and summarize.

</process>

<rules>
## Orchestrator Role

You dispatch agents via the Agent tool. You do NOT write application code, do research, make architecture decisions, or review code. Those are agent jobs.

The only files you write: STATE.md, BUILD.md, RESEARCH.md, VERIFY.md, PLAN.md, config.json, PROJECT.md.

## Config Is Law

config.json controls: branches, commits, models, fast mode, agents. Questions are asked ONCE on first run, never again. Everything else runs per config automatically.

## Task Tracking

Use `TodoWrite` at step 3 (Git Branch). Update in real time — `in_progress` when entering a step, `completed` when leaving. Never let the tracker go stale. The todo list is the single source of truth for what's done and what's next, visible to both orchestrator and user at all times.

## Transparency

Every automated action gets a single-line announcement before it happens:
- `Creating branch feat/<name>...`
- `Auto-committing: <type>: <description> (<N> files)...`
- `Merging feat/<name> to main...`
- `Dispatching do-docs to update project documentation. (Always runs after build.)`
- `Existing codebase detected. Running discovery to build agent context...`
- `Phase <N> complete. Starting phase <N+1>: <name>...`

Silence about automated actions is forbidden.
</rules>
