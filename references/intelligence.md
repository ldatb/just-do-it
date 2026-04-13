# Intelligence

Five design principles that make the system smarter and more respectful of user agency.

## 0. Granular User Prompts

Every AskUserQuestion MUST offer granular, per-item options. Never bundle decisions.

### Rules

1. **One decision per prompt.** If there are 3 config settings to change, show 3 individual options — not "Apply all / Review each / Skip."
2. **Show current → proposed values.** For settings changes, always show `field: current → new`.
3. **Specific actions, not meta-actions.** Options should describe WHAT happens, not HOW the user wants to review. "Change agents" is better than "Adjust". "Fix now" is better than "Review each."
4. **2-4 options per prompt.** AskUserQuestion supports 2-4 authored options. A fifth "Other" is always available automatically. Do not exceed 4.
5. **Always include an escape hatch.** "Done", "Skip", "Stop", or "Something else" so the user is never forced.
6. **No blanket approvals.** Never offer "Apply all" as the primary option. Each item is its own choice.
7. _(reserved)_
8. _(reserved)_
9. **Recommended option always first.** Every AskUserQuestion must have exactly one option with a `(Recommended)` suffix. That option appears first in the list.

### Anti-patterns

| Bad | Good |
| --- | ---- |
| "Apply all / Review each / Skip" | One option per setting, each showing current → new value |
| "Adjust" (vague) | "Change agents" / "Change scope" / "Change wave order" (specific) |
| "Review files" (bulk) | "Review project.md" / "Review engineering.md" / "Review health report" |
| Bundled preference combos | Individual setting per prompt |

## 1. Self-Learning Loop

After every verify phase, record what worked and what didn't in `.work/learnings.json`.

### Format

```json
{
  "entries": [
    {
      "date": "2026-03-14",
      "phase": "01-add-oauth",
      "domain": "engineering",
      "task_type": "auth",
      "agents_used": ["do-architect", "do-coder", "do-security"],
      "model_profile": "balanced",
      "outcome": "pass",
      "notes": "security agent caught token storage issue in build, saved a verify round"
    }
  ]
}
```

### Fields

| Field | Values | Purpose |
| ----- | ------ | ------- |
| outcome | `pass` / `pass_with_fixes` / `fail` | Did verify pass on first try? |
| task_type | Free text (auth, api, migration, refactor, ui, docs, etc.) | Match similar future tasks |
| notes | One sentence | What worked or what went wrong |

### How Plan Uses Learnings

During agent selection (plan step 3), read `.work/learnings.json` if it exists. Look for entries with matching `task_type` or `domain`. If a pattern emerges:

- An agent consistently catches issues early → promote it to an earlier wave
- An agent never finds issues for this task type → consider skipping in fast_mode
- A model profile produced failures → suggest upgrading for similar work

Don't over-optimize. 3+ matching entries = a pattern. Fewer = ignore.

## 2. Cost-Aware Routing

Not every task needs the full agent roster. Classify task complexity before selecting agents.

### Complexity Levels

| Level | Criteria | Agent Strategy |
| ----- | -------- | -------------- |
| **trivial** | Single file, < 50 lines changed, no new dependencies, no security surface | `do-coder` only. **Skip research, design, docs, AND verify waves.** Run linter/tests directly via Bash if available. |
| **simple** | 1-3 files, single concern, no architecture decisions | `do-coder` + `do-reviewer`. **Skip research wave, skip design wave, skip `do-docs` unless README is affected, skip `do-qa` (reviewer covers style + obvious test gaps).** |
| **standard** | Multi-file, may involve architecture or security | Full dispatch per agent-roster.md rules. |
| **complex** | Cross-cutting, multiple domains, new system boundaries | Full dispatch + consider quality model profile. |

### Enforcement (not optional)

Workflows MUST gate wave execution on complexity. The orchestrator reads PLAN.md's `## Complexity` line and skips waves accordingly:

- **trivial**: run Wave 2 (coder) only. No Wave 1, no docs, no Verify. Commit directly. Done.
- **simple**: run Wave 2 (coder), then single-agent Verify (`do-reviewer` only). Skip docs if no user-facing code or README touched.
- **standard / complex**: run every wave per plan.

Every skipped wave must be announced to the user with the reason: `Skipping Verify wave (complexity: trivial).` Silent skips are forbidden.

### Classification Rules

Read the phase goal and PLAN.md context. Assign complexity based on:

1. **File count** — how many files will change?
2. **Scope** — single concern or cross-cutting?
3. **Risk surface** — does it touch auth, data, money, or external systems?
4. **Novelty** — new pattern or following established pattern?

If any risk surface exists, complexity is at least **standard** regardless of file count.

### Fast Mode Interaction

`fast_mode: true` reduces ceremony but does NOT reduce complexity classification. A complex task in fast mode still gets full agent dispatch — it just skips decision questions.

## 3. Anti-Drift Checkpoints

In multi-wave builds (3+ waves), agents in later waves can drift from the plan — especially if earlier waves produced unexpected output.

### Checkpoint Rule

**After every 2 build waves**, the orchestrator pauses and:

1. Read the outputs from completed waves (agent-results files)
2. Compare against PLAN.md goals and success criteria
3. Check: are we still on track?

### Possible Outcomes

| Result | Action |
| ------ | ------ |
| On track | Continue to next wave. Log "Checkpoint: on track." |
| Minor drift | Note the drift, adjust next wave's agent prompts to correct. Log adjustment. |
| Major drift | Stop. Tell the user what drifted and why. Ask: Continue / Re-plan / Stop. |

### What Counts as Drift

- Files modified that aren't in the plan
- Architecture decisions made that contradict plan decisions
- Success criteria that can no longer be met given current output
- Agents producing work outside their assigned scope

### Single-Wave and Two-Wave Builds

No checkpoint needed. The verify phase catches issues for short builds.

## 4. Consensus Verification

When multiple verify agents review the same code, they may disagree on severity. This wastes the user's time if every disagreement escalates.

### Tiebreaker Rules

**Same finding, different severity:**

| Scenario | Resolution |
| -------- | ---------- |
| Domain expert rates higher than generalist | Use domain expert's rating. `do-security` outranks `do-reviewer` on security findings. |
| Domain expert rates lower than generalist | Use domain expert's rating. They have more context. |
| Two domain experts disagree | Use the higher severity. Err on the side of caution. |
| Only generalists disagree | Use the lower severity. |

**Domain expertise hierarchy for tiebreaking:**

| Finding Category | Domain Expert | Generalists |
| ---------------- | ------------- | ----------- |
| Security | `do-security` | `do-reviewer`, `do-qa` |
| Performance | `do-perf` | `do-reviewer`, `do-qa` |
| Reliability | `do-reliability` | `do-reviewer`, `do-qa` |
| Infrastructure | `do-devops` | `do-reviewer`, `do-qa` |
| Compliance | `do-compliance` | `do-reviewer`, `do-qa` |
| Code quality | `do-reviewer` | `do-qa` |
| Test coverage | `do-qa` | `do-reviewer` |

### Deduplication

Before writing VERIFY.md, merge findings that describe the same issue:
1. Group findings by file + line range (within 5 lines = same location)
2. If same location + same category → merge into one finding
3. Apply tiebreaker rules for severity
4. Credit all agents that found it

### VERIFY.md Additions

When consensus was applied, note it:

```markdown
### Finding 3: SQL injection in user query (CRITICAL)
- **Found by:** do-security (CRITICAL), do-reviewer (HIGH)
- **Consensus:** CRITICAL — domain expert (do-security) rating applied
```
