<purpose>
Plan the current or specified phase. Creates PLAN.md with tasks, waves, agent assignments, and success criteria.
The plan MUST include all relevant agents - not just do-coder. Use the agent dispatch rules below.

Before finalizing, ask the user about key implementation decisions that affect the plan.
</purpose>

<process>

## 1. Load Context

1. Read `.work/STATE.md` for current position
2. Read `.work/PROJECT.md` for project context
3. Read `.work/config.json` for settings (enabled agents, fast_mode)
4. Determine which phase to plan:
   - If $ARGUMENTS contains a phase number, use that
   - Otherwise, use current phase from STATE.md

## 2. Read Phase Context

Read the phase directory `.work/phases/XX-<name>/`:
- `RESEARCH.md` if it exists (research findings + user decisions from research phase)
- `BRAINSTORM.md` if it exists (brainstorm output)
If no research exists, do a quick research pass first (use **Agent tool** to dispatch `do-researcher`).

## 3. Classify Work and Select Agents

**This step is critical. Plans that only dispatch do-coder produce incomplete work.**

### Step 3a: Classify complexity (cost-aware routing)

Before selecting agents, classify the task complexity per `references/intelligence.md` § Cost-Aware Routing:

- **trivial** (single file, <50 lines, no risk surface) -> `do-coder` only, skip verify agents
- **simple** (1-3 files, single concern) -> `do-coder` + `do-qa` + `do-reviewer`, skip design wave
- **standard** (multi-file, may involve architecture/security) -> full dispatch
- **complex** (cross-cutting, multiple domains) -> full dispatch + consider quality profile

Any risk surface (auth, data, money, external systems) = at least **standard**.

Note the complexity level in PLAN.md header. If trivial or simple, skip the steps below that don't apply.

### Step 3b: Consult learnings

If `.work/learnings.json` exists, read it. Look for entries with matching `task_type` or `domain` (3+ matches = a pattern):

- Agent that consistently catches issues early -> promote to earlier wave
- Agent that never finds issues for this task type -> skip in fast_mode
- Model profile that produced failures -> suggest upgrade

Note any learnings-based adjustments in PLAN.md under `## Decisions`.

### Step 3c: Classify the work domain

Read the phase goal and categorize:
- **Engineering** - code changes, architecture, infrastructure
- **Business** - marketing, sales, finance, strategy
- **People** - HR, legal, compliance
- **Product** - product decisions, design
- **Mixed** - spans multiple domains

### Step 3d: Select agents using dispatch rules

For EACH phase of execution (Build, then Verify), determine which agents run.

**BUILD phase agent selection:**

| Condition | Agents to Include |
| --------- | ----------------- |
| Always for code tasks | `do-coder` |
| Architecture decisions involved | `do-architect` (Wave 1, before coder) |
| Auth, crypto, security touched | `do-security` |
| Error handling, resilience touched | `do-reliability` |
| CI/CD, infra, deploy touched | `do-devops` |
| Database migrations involved | `do-migrator` |
| External API integrations | `do-integrator` |
| Performance-sensitive code | `do-perf` |
| Marketing/content work | `do-marketer`, `do-writer` |
| Sales deliverables | `do-sales`, `do-writer` |
| HR/people work | `do-hr`, `do-writer` |
| Legal/compliance work | `do-legal`, `do-compliance` |
| Product decisions needed | `do-product` |
| Design/UX work | `do-designer` |

**VERIFY phase agent selection:**

| Condition | Agents to Include |
| --------- | ----------------- |
| Always for code tasks | `do-qa`, `do-reviewer` |
| Security-relevant changes | `do-security` |
| Error handling changes | `do-reliability` |
| Infra changes | `do-devops` |
| Performance-sensitive | `do-perf` |
| Compliance-relevant | `do-compliance` |
| Business deliverables | `do-strategist` |
| People/legal deliverables | `do-legal`, `do-ops` |

**Fast mode**: Verify uses only `do-qa` + `do-reviewer` (skip conditional agents).

## 4. Organize into Waves

Group tasks into waves based on dependencies:

**Wave ordering rules:**
1. `do-architect` runs FIRST (Wave 1) - design decisions before implementation
2. `do-product` runs FIRST (Wave 1) - product decisions before implementation
3. `do-coder` runs AFTER architect/product (Wave 2+)
4. `do-security` can run in parallel with coder OR after (depends on task)
5. `do-qa`, `do-reviewer` run LAST (Verify wave)
6. Independent agents can run in parallel within the same wave

**Example wave structure for "Add OAuth2 login":**
```
Wave 1 (Design):     do-architect, do-product
Wave 2 (Build):      do-coder, do-security (parallel)
Wave 3 (Verify):     do-qa, do-reviewer, do-security, do-reliability
```

## 5. Ask About Implementation Decisions (MANDATORY unless fast_mode)

**Before writing PLAN.md, identify implementation-level decisions the user should weigh in on.**

Read `fast_mode` from config.json.

**If fast_mode is true:** Skip this step — make reasonable default decisions and note them in the plan.

**If fast_mode is false:** Think ahead of the user. Identify decisions that:
- Affect the architecture or structure of what's being built
- Have meaningful tradeoffs (not obvious best-answer questions)
- The user would want to know about before you start building

Examples:
- "Should the API use REST or GraphQL?"
- "Do you want pagination or infinite scroll for the list?"
- "Should we split this into 2 phases or do it all at once?"
- "The component needs state management — use stores, context, or props drilling?"
- "Do you want tests alongside the code or in a separate directory?"

For each decision, use AskUserQuestion:
- header: "Planning: [Decision Topic]"
- question: "[Clear question with your recommendation and why]"
- options: [2-4 concrete options, first option marked (Recommended), with tradeoff notes]

Keep to 2-4 decision questions max. Don't ask about things already decided in research.

## 6. Create PLAN.md

Write `PLAN.md` in the phase directory, incorporating user decisions from steps 4b and 5:

```markdown
# Plan: [Phase Name]

## Goal
[One sentence]

## Complexity
[trivial / simple / standard / complex] — [one-line justification]

## Decisions
[Key decisions made by the user during research and planning, with rationale]

## Agents
- Build: [list of agents for build waves]
- Verify: [list of agents for verify wave]

## Wave 1: [Name]
### Task 1.1: [Agent] - [Action]
- Files: [files to read/modify]
- Done when: [criteria]

### Task 1.2: [Agent] - [Action]
- Files: [files to read/modify]
- Done when: [criteria]

## Wave 2: [Name]
### Task 2.1: [Agent] - [Action]
...

## Verify Wave
### [Agent] - [Review focus]
...

## Success Criteria
[How we know the phase is complete]
```

## 7. Present Plan (MANDATORY - do not skip)

**You MUST present the plan to the user before asking for approval.**

For **trivial** complexity tasks, print a concise one-paragraph summary: what changes, which file, done criteria. No need for a full breakdown.

For **simple** complexity tasks, print: goal, which agents, which files, done criteria. Keep it brief.

For **standard** or **complex** tasks, print a full summary that includes:
- **Goal**: What this phase achieves
- **Decisions**: What the user chose and how it shapes the plan
- **Approach**: Key technical/design decisions and rationale
- **Agents**: Which specialists will be dispatched and why each is needed
- **Waves**: Execution order with what each wave does
- **Key files**: What will be created or modified

The user should understand the plan well enough to give informed approval.
Do NOT just write PLAN.md silently and ask "Go?". EXPLAIN it.

Then use AskUserQuestion:
- header: "Plan Review"
- question: "[N] waves, [N] agents, ~[N] files. Ready to build?"
- options:
  - "Go (Recommended)" - start execution as planned
  - "Change scope" - modify tasks, agents, or wave order
  - "Re-plan" - start planning over with different requirements
  - "Stop" - save plan and exit without building

## 8. Update State

Update STATE.md:
- Step: plan
- Status: complete
- Next Action: "Build phase XX"

</process>
