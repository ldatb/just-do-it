# Agent Roster

The "Just do It" system uses specialist agents organized by department. Each agent has deep domain expertise and is dispatched based on the work being done.

## Departments

### Engineering
| Agent | Domain | Dispatched When |
| ----- | ------ | --------------- |
| `do-coder` | Implementation | Always during Build for code tasks |
| `do-architect` | System design, trade-offs | Architecture decisions, tech strategy |
| `do-security` | AppSec, OWASP, secrets | Build + Verify when auth/crypto/input touched |
| `do-reliability` | Error handling, resilience | Build + Verify when error paths/data touched |
| `do-qa` | Testing, coverage | Always during Verify for code tasks |
| `do-devops` | CI/CD, infra, deploy | Build + Verify when infra touched |
| `do-debugger` | Bug investigation, root cause | When bugs found or tests fail |
| `do-perf` | Profiling, optimization | When performance matters |
| `do-integrator` | API integration, webhooks | When connecting external systems |
| `do-migrator` | Migrations, upgrades | Database/framework/version migrations |
| `do-data` | SQL, ETL, reporting | Data analysis and pipeline work |

### Business
| Agent | Domain | Dispatched When |
| ----- | ------ | --------------- |
| `do-strategist` | Strategy, analysis | Business/strategic tasks |
| `do-marketer` | Content, campaigns, SEO | Marketing tasks |
| `do-sales` | Outreach, proposals, pitch | Sales tasks |
| `do-finance` | Budgets, forecasting, models | Financial tasks |
| `do-ops` | Processes, project mgmt | Operations tasks |

### People & Legal
| Agent | Domain | Dispatched When |
| ----- | ------ | --------------- |
| `do-hr` | Hiring, onboarding, culture | People/HR tasks |
| `do-legal` | Contracts, compliance, risk | Legal/compliance tasks |
| `do-compliance` | Audit, regulatory, standards | Compliance/certification tasks |
| `do-support` | FAQs, runbooks, help docs | Customer support tasks |

### Product & Design
| Agent | Domain | Dispatched When |
| ----- | ------ | --------------- |
| `do-product` | PRDs, roadmaps, prioritization | Product decisions |
| `do-designer` | UI/UX, branding, design systems | Design tasks |

### Cross-Cutting
| Agent | Domain | Dispatched When |
| ----- | ------ | --------------- |
| `do-researcher` | Prior art, docs, analysis | Always during Research phase |
| `do-reviewer` | Code quality, doc quality | Always during Verify |
| `do-writer` | Docs, comms, content | Writing-heavy deliverables |

## Dispatch Logic

The orchestrator classifies work into a domain, then dispatches the relevant specialists:

1. **Classify** - What kind of work is this? (code, marketing, sales, ops, etc.)
2. **Select primary agents** - Which specialists own this domain?
3. **Select supporting agents** - Which cross-cutting specialists add value?
4. **Resolve models** - Look up each agent's model from the profile
5. **Dispatch in parallel** - Send all agents simultaneously where possible

### Example Dispatches

**"Add OAuth2 login"** (Engineering)
- Build: `do-coder`, `do-security`, `do-architect`
- Verify: `do-qa`, `do-reviewer`, `do-security`, `do-reliability`

**"Write Q1 marketing plan"** (Business)
- Research: `do-researcher`
- Build: `do-marketer`, `do-writer`
- Verify: `do-strategist`

**"Migrate from MySQL to PostgreSQL"** (Engineering)
- Research: `do-researcher`, `do-migrator`
- Build: `do-migrator`, `do-coder`
- Verify: `do-qa`, `do-data`, `do-reliability`

**"Create employee onboarding checklist"** (People)
- Research: `do-researcher`
- Build: `do-hr`, `do-writer`
- Verify: `do-ops`, `do-legal`

**"Debug production login timeout"** (Engineering)
- Build: `do-debugger`, `do-perf`
- Verify: `do-qa`, `do-reliability`

## Parallel Execution

During Build and Verify, agents run in parallel when they operate on independent concerns. The `max_concurrent` setting in config.json controls how many agents run simultaneously (default: 4).
