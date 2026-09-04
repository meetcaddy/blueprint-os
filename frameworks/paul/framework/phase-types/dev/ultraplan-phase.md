---
schema_version: 1.0
name: ultraplan-phase
display_name: Ultraplan Phase (Heavyweight Planning)
category: dev
purpose: Heavyweight planning mode for complex, risky, or multi-system phases. Offload plan generation to a deeper planning pass with adversarial review built in.
duration: medium
risk_level: high
triggers:
  keywords: [complex, risky, multi-system, heavyweight, adversarial, careful planning, high stakes]
  patterns: ['(complex|risky|critical|high.stakes)\s+(phase|work|change)', 'multi.(system|service|team)']
  file_signals: []
  required_after: [spec-phase, exploration-phase]
  required_before: []
  recommended_for: [phases touching critical paths, irreversible changes, integrations across multiple services, anything where rollback is hard]
recommended_skills: [paul:plan, paul:assumptions]
related_paul_workflows: [paul:plan, paul:audit]
sources: [GSD commands/gsd/ultraplan-phase.md]
---

# Ultraplan Phase

## Purpose

Heavyweight alternative to standard `/paul:plan` for phases where the cost of a bad plan is high. Adds adversarial review, deeper assumption surfacing, and multi-pass refinement before plan approval.

This is the right phase type when "we'll figure it out as we go" would be expensive, for irreversible changes, multi-system migrations, security-sensitive work, or anything where rollback is painful.

## When to recommend

- Phase touches a critical path (auth, billing, customer data)
- Irreversible or hard-to-rollback changes (schema migrations, API breaking changes, infrastructure swaps)
- Multi-system integration (changes ripple across 3+ services or codebases)
- Stakeholder review required before execution
- Past similar work has gone wrong because the plan was too thin
- High blast radius if the work fails (production incident, customer-facing breakage)

## Phase template

### Goal
Produce a plan with explicit risk analysis, contingencies, and rollback procedures. Plan has been adversarially challenged and refined across multiple passes.

### Scope
- Standard `/paul:plan` workflow as starting point
- Add: explicit assumption surfacing (`/paul:assumptions`)
- Add: adversarial plan-challenger pass (PAUL upgrade pending in tracker)
- Add: explicit rollback procedure per task
- Add: blast-radius analysis per task
- Multi-pass refinement until plan-challenger has no surviving objections

### Plans (suggested decomposition)
- [ ] Plan 1: Initial plan via `/paul:plan`
- [ ] Plan 2: Run `/paul:assumptions` to surface Claude's hidden assumptions for user validation
- [ ] Plan 3: Run plan-challenger agent (when PAUL gets the upgrade) for adversarial review
- [ ] Plan 4: Refine plan based on challenger findings
- [ ] Plan 5: Add explicit rollback procedure per task in PLAN.md
- [ ] Plan 6: Add blast-radius analysis per task
- [ ] Plan 7: Stakeholder review (if applicable)
- [ ] Plan 8: Lock plan and route to execute

### Dependencies
- spec-phase or exploration-phase has clarified the WHAT (ultraplan handles the HOW)
- ROADMAP entry exists for this phase

### Verification
- PLAN.md exists with all standard PAUL plan sections
- ASSUMPTIONS.md exists documenting surfaced assumptions
- plan-challenger output included with all objections resolved or accepted
- Each task has explicit rollback procedure
- Each task has blast-radius classification
- Stakeholder approval recorded if required

## Skills orchestrated

1. `paul:plan`, base plan generation
2. `paul:assumptions`, surface assumptions for validation
3. `paul:audit`, architectural audit on the plan

## Source notes

**Primary source:** GSD `commands/gsd/ultraplan-phase.md`, described as "BETA: offload plan phase to Claude Code's ultraplan cloud" using remote infrastructure.

**Adapted for Caddy/PAUL:** GSD's ultraplan offloads to remote cloud (Claude Code v2.1.91+ feature). Caddy's ultraplan-phase keeps execution LOCAL but adds the discipline GSD's cloud offload provides:
- Multi-pass refinement
- Adversarial review (when plan-challenger PAUL upgrade ships)
- Explicit assumption surfacing
- Rollback + blast-radius per task

**No remote dependency:** customers don't need ultraplan cloud. Local execution preserves data privacy + works offline.

**Pairs with future PAUL upgrade:** `paul:plan-challenger` agent (queued in tracker PAUL upgrades section). When that ships, ultraplan-phase invokes it as Plan 3.

## Anti-patterns

- DO NOT use ultraplan-phase for routine work. Standard `/paul:plan` is sufficient for most phases.
- DO NOT skip the adversarial pass. The whole point is challenging the plan before commit.
- DO NOT bypass the rollback-per-task discipline. If a task can't be rolled back, that's important, surface it explicitly.
- DO NOT confuse with `/paul:audit` (post-plan architectural review). Audit comes AFTER ultraplan if needed; they stack.
