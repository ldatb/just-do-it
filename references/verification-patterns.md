# Verification Patterns

## Multi-Specialist Verification

Each specialist verifies from their domain perspective. Results are compiled into VERIFY.md.

## Verification Dimensions

### QA Agent
- Tests exist and pass
- Coverage meets threshold (80%+)
- Edge cases covered
- No regressions introduced
- Test naming and organization

### Reviewer Agent
- Code is readable and well-named
- Functions are small and focused
- No deep nesting
- Immutable patterns used
- No hardcoded values
- Consistent with project conventions

### Security Agent
- No hardcoded secrets
- Input validation at boundaries
- SQL injection prevention
- XSS prevention
- Auth/authz verified
- Error messages don't leak data

### Reliability Agent
- Error handling is comprehensive
- Retries have backoff
- Timeouts are configured
- Graceful degradation exists
- Data integrity maintained
- Edge cases handled

### DevOps Agent
- Build passes
- CI/CD pipeline works
- Deploy configuration correct
- Environment variables documented
- Infrastructure changes safe

## Verification Report Format

Each specialist produces a section in VERIFY.md:

```markdown
## [Agent Name] Review

**Status:** PASS | FAIL | WARN

### Findings
- [CRITICAL] Description (must fix)
- [HIGH] Description (should fix)
- [MEDIUM] Description (consider fixing)
- [LOW] Description (nice to have)

### Verdict
Summary sentence.
```
