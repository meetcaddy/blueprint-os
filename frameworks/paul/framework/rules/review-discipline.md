---
paths:
  - "src/workflows/**/*.md"
  - "src/templates/**/*.md"
---

# Review Discipline Rules

Universal rules for any PAUL workflow that produces review/audit/critique/feedback output. Fires on: code review, architectural audit, user-acceptance verify, issue triage, plan validation, qualify steps in apply-phase, any step where PAUL surfaces "findings" or "issues" to the user.

The whole point: kill review noise. PAUL's reviews should surface signal, not bury the user under stylistic preferences.

## The >80% Confidence Rule

**Only report findings you are >80% confident are real issues.**

If you're not >80% sure something is a real problem, do not report it. Stylistic-disagreement findings, "could be cleaner" findings, "in some codebases this is convention" findings, all skip unless they violate a documented project convention.

Apply this filter in:
- Code review output
- Architectural audit findings
- UAT issue capture (`verify-work.md`)
- Plan validation output
- Qualify step results in apply-phase
- Any consider-issues triage output

## Skip Rules

Skip a finding even if technically true when:

1. **Stylistic preference**, formatting, naming, ordering, UNLESS it violates a documented project convention
2. **Unchanged code issues**, only flag issues in code that was modified or added in the current scope, EXCEPT for CRITICAL security findings which always surface
3. **Subjective architecture preferences**, "I would have done this differently", UNLESS there's a concrete failure mode

## Consolidation Rule

Multiple instances of the same issue collapse into one finding.

```markdown
# BAD (5 separate findings):
- Function `auth()` missing error handling
- Function `login()` missing error handling
- Function `register()` missing error handling
- Function `logout()` missing error handling
- Function `refresh()` missing error handling

# GOOD (1 consolidated finding):
- 5 functions in src/auth/ are missing error handling: auth(), login(), register(), logout(), refresh()
```

## Severity Classification

Every reported finding MUST carry a severity:

| Severity | When to use | Action expected |
|----------|-------------|-----------------|
| **CRITICAL** | Security vulnerability, data-loss risk, definite bug | Block ship; fix before merge |
| **HIGH** | Likely bug, significant maintainability issue, scalability concern | Fix in current scope |
| **MEDIUM** | Improvement opportunity, minor bug, edge case not handled | Fix if time permits |
| **LOW** | Quality-of-life suggestion, future-proofing | Bookmark; address in cleanup |

Findings without severity are noise. Tag every one.

## File:Line References Required

Every finding MUST include a file path and line number.

```markdown
# BAD: "The error handling in the auth module is weak"

# GOOD: "Error handling missing at src/auth/login.ts:42, promise rejection in `verifyToken()` is unhandled"
```

Vague findings cannot be acted on; PAUL surfaces specific findings or no findings.

## Output Format

Reviews/audits should follow this structure:

```markdown
## [Workflow Name] Output

**Scope:** [what was reviewed]
**Date:** [timestamp]

### Critical Findings ({count})
[List, with file:line + severity + recommended fix]

### High Findings ({count})
[List]

### Medium Findings ({count})
[List]

### Low Findings ({count})
[List]

### Passed Checks
[What was verified clean, important for confidence calibration]

### Recommendations (priority order)
1. [Most urgent fix with exact action]
2. [Next priority]
...
```

## Anti-patterns

**DO NOT report stylistic disagreements as findings.** "I would have used `const` here" is not a finding unless the project enforces `const` and the code uses `let`.

**DO NOT report "this could be more elegant".** Subjective elegance is noise.

**DO NOT scatter similar issues as separate findings.** Consolidate.

**DO NOT report findings without file:line references.** Unactionable.

**DO NOT skip the Passed Checks section.** Telling the user what passed is calibration; reviews that ONLY surface failures suggest everything is broken.

**DO NOT use this rule as an excuse to skip CRITICAL security findings in unchanged code.** The "unchanged code" exception applies to non-security findings only.

## Source

Adapted from ECC `agents/code-reviewer.md` confidence-based filtering pattern. See `~/.claude/LICENSE-NOTICES.md` for attribution.
