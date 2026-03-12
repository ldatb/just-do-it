<purpose>
Standalone research on a topic, technology, or approach. Dispatches do-researcher agents
and produces RESEARCH.md. Can run independently or feed into /do:plan.
Config-driven: dispatches based on fast_mode setting, no unnecessary prompts.
</purpose>

<process>

## 1. Initialize

1. Read `.work/config.json` if it exists (for model profile and fast_mode)
2. Read `.work/context/project.md` if it exists (for project context)
3. Determine output location:
   - If a current phase exists in STATE.md: write to that phase directory
   - Otherwise: write to `.work/` root

## 2. Dispatch Researchers

Resolve model for `do-researcher` from config.

Infer research angle from $ARGUMENTS:
- If comparing options: focus on alternatives and trade-offs
- If exploring a technology: focus on prior art and best practices
- If assessing risk: focus on pitfalls and failure modes
- If unclear: cover all angles

**If fast mode:** Single agent, focused on top 2-3 findings.

**If normal mode:** Up to 3 agents in parallel, each covering a different angle:
- Agent 1: Libraries, packages, existing solutions
- Agent 2: Architecture approaches, patterns, best practices
- Agent 3: Risks, pitfalls, trade-offs

Each agent reads project context files before researching.

## 3. Compile Findings

Compile all agent outputs into `RESEARCH.md`:

```markdown
# Research: [Topic]

## Objective
[What we needed to learn]

## Key Findings
[Top 3-5 findings, prioritized]

## Options Comparison (if applicable)
| Option | Pros | Cons | Recommendation |
|--------|------|------|----------------|
| ... | ... | ... | ... |

## Prior Art
[Existing solutions found]

## Risks
[What could go wrong]

## Recommendation
[Clear next step with rationale]
```

## 4. Present Results

Show the user a brief summary of findings. No prompt needed - research is complete.

## 5. Update State

If `.work/STATE.md` exists, update:
- Last Action: "Research: [topic]"
- Next Action: ready for planning or next task

</process>
