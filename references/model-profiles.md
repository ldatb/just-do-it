# Model Profiles

Three profiles control which model each agent uses. Set via `.work/config.json` field `model_profile`.

## Profile Definitions

### Engineering Agents

| Agent        | quality | balanced | budget  |
| ------------ | ------- | -------- | ------- |
| coder        | opus    | sonnet   | sonnet  |
| architect    | opus    | sonnet   | sonnet  |
| security     | opus    | sonnet   | haiku   |
| reliability  | sonnet  | sonnet   | haiku   |
| qa           | sonnet  | sonnet   | haiku   |
| devops       | sonnet  | haiku    | haiku   |
| debugger     | opus    | sonnet   | sonnet  |
| perf         | sonnet  | sonnet   | haiku   |
| integrator   | sonnet  | sonnet   | haiku   |
| migrator     | opus    | sonnet   | sonnet  |
| data         | sonnet  | sonnet   | haiku   |

### Business Agents

| Agent        | quality | balanced | budget  |
| ------------ | ------- | -------- | ------- |
| strategist   | opus    | sonnet   | sonnet  |
| marketer     | opus    | sonnet   | sonnet  |
| sales        | opus    | sonnet   | sonnet  |
| finance      | opus    | sonnet   | haiku   |
| ops          | sonnet  | sonnet   | haiku   |

### People & Legal Agents

| Agent        | quality | balanced | budget  |
| ------------ | ------- | -------- | ------- |
| hr           | sonnet  | sonnet   | haiku   |
| legal        | opus    | sonnet   | sonnet  |
| compliance   | opus    | sonnet   | haiku   |
| support      | sonnet  | sonnet   | haiku   |

### Product & Design Agents

| Agent        | quality | balanced | budget  |
| ------------ | ------- | -------- | ------- |
| product      | opus    | sonnet   | sonnet  |
| designer     | opus    | sonnet   | haiku   |

### Cross-Cutting Agents

| Agent        | quality | balanced | budget  |
| ------------ | ------- | -------- | ------- |
| researcher   | opus    | sonnet   | haiku   |
| reviewer     | sonnet  | sonnet   | haiku   |
| writer       | opus    | sonnet   | sonnet  |

## Resolution Algorithm

1. Read `model_profile` from `.work/config.json` (default: `balanced`)
2. Check `model_overrides` for agent-specific override
3. If override exists, use it
4. Otherwise, look up agent in profile table above
5. Pass resolved model to `Agent` tool via `model` parameter

## Override Example

```json
{
  "model_profile": "balanced",
  "model_overrides": {
    "coder": "opus",
    "legal": "opus"
  }
}
```

Here `coder` and `legal` get `opus` (overridden) while all other agents use `balanced` profile defaults.

## Profile Selection Guide

- **quality** - Important deliverables, complex work, client-facing output. Higher cost.
- **balanced** - Day-to-day work. Good results at reasonable cost. Default.
- **budget** - High-volume, repetitive, or low-stakes work. Lowest cost.
