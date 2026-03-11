<purpose>
Discover and analyze an existing codebase. Generate project-specific context files
that customize agent behavior for this project.
</purpose>

<process>

## 1. Pre-flight

Check if `.work/` exists. If not, create it with default config.
Create `.work/context/` directory.

## 2. Dispatch Discovery Agents (Parallel)

Launch up to 4 research agents in parallel, each focused on a different dimension:

### Agent 1: Stack & Structure
Analyze the codebase for:
- Programming languages and versions
- Frameworks and libraries (with versions)
- Package manager and dependency files
- Directory structure and organization pattern
- Build system and scripts
- Configuration files and formats

Output: tech stack summary, repo structure overview

### Agent 2: Architecture & Patterns
Analyze the codebase for:
- Architecture pattern (monolith, microservices, serverless, etc.)
- Design patterns in use (repository, factory, observer, etc.)
- API style (REST, GraphQL, gRPC)
- Database and ORM usage
- Authentication and authorization approach
- State management approach
- Error handling patterns
- Logging and observability

Output: architecture summary, patterns catalog

### Agent 3: Quality & Testing
Analyze the codebase for:
- Test framework and test structure
- Test coverage (if measurable)
- Linting and formatting tools
- CI/CD pipeline configuration
- Code quality tools (static analysis, etc.)
- Documentation state
- Known technical debt indicators

Output: quality assessment, testing patterns

### Agent 4: Conventions & Concerns
Analyze the codebase for:
- Naming conventions (files, variables, functions, classes)
- Code style and formatting rules
- Import/module organization
- Comment and documentation style
- Git workflow (branch naming, commit style)
- Security posture (secrets management, input validation)
- Performance patterns (caching, optimization)
- Known issues (TODOs, FIXMEs, HACKs in code)

Output: conventions guide, concerns list

## 3. Compile Context Files

From the 4 agent outputs, generate:

### .work/context/project.md
Synthesize findings into a single project overview:
- Project description (inferred from README, package.json, etc.)
- Tech stack summary
- Repository structure
- Key conventions
- External services and integrations
- Deployment targets

### .work/context/engineering.md
From architecture, patterns, quality, and conventions:
- Frameworks and their configurations
- Architecture patterns to follow
- Code style rules
- Testing approach and framework
- Build and deploy process
- Known technical debt
- Performance considerations

### Agent-specific files (only if significant findings)
Generate per-agent context files when the discovery reveals deep domain knowledge:

- `.work/context/coder.md` - Project-specific coding patterns, preferred abstractions, file templates
- `.work/context/security.md` - Auth implementation details, known vulnerabilities, secrets management approach
- `.work/context/qa.md` - Test framework setup, coverage requirements, test data patterns
- `.work/context/devops.md` - CI/CD pipeline details, deployment process, environment configuration
- `.work/context/reviewer.md` - Project-specific review criteria beyond defaults

Only create agent-specific files when there's meaningful content. Don't create empty stubs.

## 4. Generate PROJECT.md

If `.work/PROJECT.md` doesn't exist, create it from discovery findings:
- What This Is (inferred from README and code)
- Core Value (inferred from primary functionality)
- Constraints (inferred from tech stack and architecture)

## 5. Present Summary

Show the user:
- What was discovered
- Which context files were generated
- A brief summary of each file's content
- Ask: "Review and edit these, or proceed?"

## 6. Update State

Update STATE.md:
- Status: discovered
- Last Action: Codebase discovery complete
- Next Action: Ready for work - use `/do:start` or `/do:plan`

</process>
