<purpose>
Standalone research on a topic, technology, or approach. Dispatches do-researcher agents
and produces RESEARCH.md. Can run independently or feed into /do:plan.
</purpose>

<process>

## 1. Initialize

1. Read `.work/config.json` if it exists (for model profile)
2. Read `.work/context/project.md` if it exists (for project context)
3. Determine output location:
   - If a current phase exists in STATE.md: write to that phase directory
   - Otherwise: write to `.work/` root

## 2. Scope the Research

From $ARGUMENTS, identify:
- **Topic**: what to research
- **Purpose**: why (comparing options, learning a technology, finding prior art, assessing risk)

If the topic is broad, ask one scoping question:

Use AskUserQuestion:
- header: "Research"
- question: "What angle matters most for this research?"
- options:
  - "Compare options" - evaluate alternatives, produce a recommendation
  - "Find prior art" - existing implementations, libraries, patterns
  - "Assess risk" - what could go wrong, common pitfalls
  - "Deep dive" - thorough understanding of one technology/approach

## 3. Dispatch Researchers

Resolve model for `do-researcher` from config.

**If fast mode:** Single agent, focused on top 2-3 findings.

**If normal mode:** Up to 3 agents in parallel, each covering a different angle:
- Agent 1: Libraries, packages, existing solutions
- Agent 2: Architecture approaches, patterns, best practices
- Agent 3: Risks, pitfalls, trade-offs

Each agent reads project context files before researching.

## 4. Compile Findings

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

## 5. Present Results

Show the user a brief summary of findings.

Use AskUserQuestion:
- header: "Research Done"
- question: "Research complete. What next?"
- options:
  - "Plan it" - proceed to /do:plan with these findings
  - "Research more" - dig deeper on a specific area
  - "Done" - save findings and stop

## 6. Update State

If `.work/STATE.md` exists, update:
- Last Action: "Research: [topic]"
- Next Action: based on user choice

</process>
