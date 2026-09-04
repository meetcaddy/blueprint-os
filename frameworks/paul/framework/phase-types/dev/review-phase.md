---
schema_version: 1.0
name: review-phase
display_name: Review Phase
category: dev
purpose: Structured review of work product. Three modes: PR review (GitHub PR), plan review (PLAN.md before implementation), or codebase review (full project health audit).
modes: [pr, plan, codebase]
default_mode: codebase
duration: short
risk_level: medium
triggers:
  keywords: [review, audit, code review, PR review, plan review, codebase health, refactor candidate]
  patterns: ['(review|audit)\s+(this|the|my)\s+(PR|pull request|plan|code|codebase|project)']
  file_signals: [PLAN.md]
  required_after: []
  required_before: [ship-phase]
  recommended_for: [pre-merge PR review, pre-implementation plan review, periodic codebase health audit, refactor scoping]
recommended_skills: []
related_paul_workflows: [paul:audit, paul:plan]
sources: [cc-ultimate-guide examples/commands/review-pr.md, cc-ultimate-guide examples/commands/review-plan.md, cc-ultimate-guide examples/commands/audit-codebase.md]
---

# Review Phase

## Purpose

Structured review of work product across three different targets:

- **`pr` mode**, review a GitHub pull request comprehensively (code quality, functionality, security, testing, docs)
- **`plan` mode**, review a PLAN.md across 4 axes BEFORE writing code (architecture, code quality, testing, performance) with engineering preferences applied
- **`codebase` mode**, score full codebase health across 7 weighted categories with progression plan

Each mode is a different layer of "review", pre-implementation (plan), post-implementation (PR), or holistic (codebase). All three apply >80% confidence filtering and consolidation discipline (no review noise).

## When to recommend

### pr mode
- Pull request opened that needs review
- Pre-merge gate
- External contributor PR
- Cross-team PR

### plan mode
- PLAN.md exists but implementation hasn't started
- Plan is high-stakes or complex (pairs with ultraplan-phase)
- Garry-Tan-style structured review before any code is written
- Plan from a contributor that needs senior review

### codebase mode
- Periodic health check (quarterly)
- New project taken over from another team
- Pre-acquisition / due-diligence review
- Refactor scoping (which areas need work most?)

## Modes

### Mode: pr
Comprehensive PR code review. Covers: code quality, functionality, security, testing, documentation. Uses `gh pr view` to load the PR. Output: structured feedback with approval status.

### Mode: plan
Pre-implementation plan review across 4 axes. Pause-and-confirm between axes. Engineering preferences applied:
- DRY violations flagged aggressively
- Well-tested code is non-negotiable
- "Engineered enough" (not under, not over)
- Bias toward handling more edge cases
- Bias toward explicit over clever

Four axes: Architecture, Code Quality, Testing, Performance.

### Mode: codebase
7-category scored health audit (1-10 per category) with weighted total. Categories include secrets, security, code quality, tests, performance, dependencies, documentation. Output: scored report + prioritized progression plan.

## Phase template (pr mode)

### Goal
Produce a structured PR review with approval status (Approved / Approved with suggestions / Changes requested) and per-finding feedback.

### Scope
- Get PR data via `gh pr view`
- Review each changed file
- Apply review checklist (quality, functionality, security, testing, docs)
- Apply >80% confidence filter (skip stylistic prefs unless violating project conventions)
- Consolidate similar issues
- Produce structured output

### Plans
- [ ] Plan 1: Load PR via gh CLI
- [ ] Plan 2: Identify scope (files changed, surface area)
- [ ] Plan 3: Apply review checklist per file
- [ ] Plan 4: Filter findings (>80% confidence, consolidate similar)
- [ ] Plan 5: Generate structured review output

## Phase template (plan mode)

### Goal
Review PLAN.md across 4 axes BEFORE any code is written. Surface architecture concerns, DRY violations, missing test coverage, performance bottlenecks. Confirm with user between axes.

### Plans
- [ ] Plan 1: Architecture review (component boundaries, dependency graph, scaling, security architecture) → confirm
- [ ] Plan 2: Code quality review (organization, DRY, error handling, technical debt, over/under-engineering) → confirm
- [ ] Plan 3: Test review (coverage gaps, test quality, edge cases, untested failure modes) → confirm
- [ ] Plan 4: Performance review (N+1 queries, memory, caching, complexity) → confirm
- [ ] Plan 5: Synthesize findings into REVIEW.md

## Phase template (codebase mode)

### Goal
Score the codebase across 7 health categories with weighted total. Produce prioritized progression plan.

### Plans
- [ ] Plan 1: Category 1 (Secrets), scan and score 1-10
- [ ] Plan 2: Category 2 (Security), scan and score
- [ ] Plan 3: Category 3 (Code Quality), score
- [ ] Plan 4: Category 4 (Tests), coverage analysis + score
- [ ] Plan 5: Category 5 (Performance), score
- [ ] Plan 6: Category 6 (Dependencies), vulnerability audit + score
- [ ] Plan 7: Category 7 (Documentation), score
- [ ] Plan 8: Calculate weighted total + grade
- [ ] Plan 9: Generate prioritized progression plan

### Verification
- Output exists (PR review document, REVIEW.md, or AUDIT.md depending on mode)
- All findings have file:line references (no vague critiques)
- >80% confidence filter applied (no review noise)
- Similar issues consolidated (e.g., "5 functions missing error handling" not 5 separate findings)

## Skills orchestrated

When Caddy v3 ships:
- `/caddy:review` (this phase's command counterpart)
- `/caddy:audit-codebase` (the codebase mode counterpart)
- `/caddy:review-pr` (the pr mode counterpart)

## Source notes

**Three-source merge.** Each source maps to one mode.

**cc-ultimate-guide `review-pr.md` (→ pr mode):**
- Comprehensive PR review with `gh pr view` integration
- 5-axis checklist (code quality, functionality, security, testing, docs)
- Structured output with approval status
- Filter: only report confident issues; never block on style

**cc-ultimate-guide `review-plan.md` (→ plan mode):**
- Inspired by Garry Tan's workflow
- 4-axis structured review BEFORE code (architecture, code quality, tests, performance)
- Engineering preferences applied (DRY, well-tested, "engineered enough", explicit over clever)
- Pause-and-confirm between axes
- Opinionated recommendations with concrete tradeoffs

**cc-ultimate-guide `audit-codebase.md` (→ codebase mode):**
- 7-category weighted health audit (1-10 per category)
- Categories: secrets, security, code quality, tests, performance, dependencies, documentation
- Scoring rubric per category
- Prioritized progression plan as output
- Optional category filtering via $ARGUMENTS

**Why merge into one phase type:** all three are "structured review of work product." They differ by TARGET (PR vs plan vs codebase), not by SHAPE (review with rubric, surface findings, prioritize fixes). Mode flag captures target.

**Caddy-specific additions:**
- ALL modes apply the >80% confidence filter (from ECC code-reviewer agent harvest in PAUL upgrades)
- ALL modes consolidate similar findings ("5 functions missing X" not 5 findings)
- ALL modes require file:line references (no vague critiques)
- The `/caddy:code-review` skill merge (queued in tracker) becomes the runtime that powers pr mode

**Why not also merge with /paul:audit:** paul:audit is an architectural audit on a PLAN (different from this phase's plan mode in that paul:audit is enterprise-grade architecture review while this phase's plan mode is the 4-axis Garry-Tan-style review). They're distinct enough to keep separate. They CAN stack: run review-phase plan mode AND paul:audit on high-stakes plans.

## Anti-patterns

- DO NOT skip confidence filtering. The >80% threshold + consolidation rules kill 90% of review noise. Without them, reviews bury real findings under stylistic preferences.
- DO NOT use pr mode without `gh` CLI configured. Mode requires GitHub access.
- DO NOT skip "pause and confirm between axes" in plan mode. The pause prevents a scattershot review; user feedback per axis sharpens subsequent axes.
- DO NOT report findings without file:line references. Vague review feedback is uneval-able.
- DO NOT cherry-pick categories in codebase mode without explicit reason. The weighted total assumes all 7 ran; partial audits skew the grade.
- DO NOT use review-phase as a substitute for validate-phase. Review = quality assessment; validate = does it work? Different shapes, both needed.
