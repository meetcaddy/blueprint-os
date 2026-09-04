---
schema_version: 1.0
name: spec-phase
display_name: Specification Phase
category: dev
purpose: Clarify WHAT a phase delivers through structured Socratic questioning with quantitative ambiguity scoring. Locks "what/why" before plan-phase handles "how".
duration: medium
risk_level: high
triggers:
  keywords: [spec, specification, requirements, ambiguous, unclear, clarify, what should this do]
  patterns: ['(write|create|define)\s+a\s+spec', 'clarify\s+(requirements|what)', 'before\s+(planning|coding)']
  file_signals: [SPEC.md, REQUIREMENTS.md]
  required_after: [scaffold-phase]
  required_before: [plan-phase, ai-integration-phase]
  recommended_for: [phases with unclear requirements, multi-stakeholder builds, anything where "wrong thing built" is a real risk]
recommended_skills: [paul:discuss-milestone, paul:assumptions]
related_paul_workflows: [paul:discuss, paul:plan, paul:assumptions]
sources: [GSD commands/gsd/spec-phase.md]
---

# Specification Phase

## Purpose

Use structured Socratic questioning to remove ambiguity from a phase's requirements before planning starts. Produces a SPEC.md with falsifiable requirements scored against an ambiguity rubric. The output gates plan-phase: if ambiguity is too high, you keep specifying; once it drops below threshold, you can plan.

This phase exists because plan-phase fails when fed unclear requirements. Specifying first makes planning radically faster and reduces rework.

## When to recommend

- Requirements are vague or contested
- Multiple plausible interpretations of the goal
- Stakeholders disagree on what success looks like
- Phase touches multiple systems or teams
- Past similar work has been built wrong because of unclear specs
- AI-integration-phase is queued (always run spec-phase first for AI work)

## Phase template

### Goal
Produce a SPEC.md with quantified ambiguity score below 0.20 across all dimensions. SPEC defines: what, why, success criteria, falsifiability, scope boundaries.

### Scope
- Load context (PROJECT.md, ROADMAP.md, STATE.md, any prior research)
- Scout codebase (understand current state before asking questions)
- Run Socratic interview loop (up to 6 rounds, rotating perspectives)
- Score ambiguity across 4 weighted dimensions per round
- Gate at ambiguity ≤ 0.20 AND all dimension minimums met
- Write SPEC.md to phase directory

### Plans (suggested decomposition)
- [ ] Plan 1: Context load + codebase scout
- [ ] Plan 2: Round 1 of Socratic interview (broad)
- [ ] Plan 3: Score ambiguity, identify weakest dimensions
- [ ] Plan 4: Targeted rounds 2-6 on weak dimensions until gate clears
- [ ] Plan 5: Write SPEC.md, commit

### Dependencies
- scaffold-phase (or some project structure) must exist
- A roadmap phase entry must exist (this spec is for THAT phase)

### Verification
- SPEC.md exists at expected path
- Ambiguity score ≤ 0.20 documented in SPEC.md
- All 4 dimensions meet their minimum thresholds
- SPEC contains falsifiable success criteria (not vague aspirations)

## Skills orchestrated

1. `paul:discuss`, for the human conversation portion of the Socratic loop
2. `paul:assumptions`, surfaces Claude's assumptions for validation during interviews

## Source notes

**Primary source:** GSD `commands/gsd/spec-phase.md`, Socratic interview loop with quantitative ambiguity scoring across 4 dimensions, gate at 0.20.

**Key extraction:** the ambiguity score gate is the load-bearing innovation. Without it, "specify the requirements" is endless. The score quantifies "are we done specifying yet?"

**Adapted for Caddy/PAUL:** GSD's spec-phase has 6 rounds max + 4 dimensions. Caddy preserves these. The actual scoring rubric (what counts as ambiguous in each dimension) lives in the runtime workflow that 3b will build, not in this template.

**Not merged from any other source.** ccug doesn't have a spec-phase equivalent.

## Anti-patterns

- DO NOT skip spec-phase for "obvious" work. "Obvious" is where the worst miscommunications happen.
- DO NOT use spec-phase as discussion. PAUL's discuss-phase is for thinking-partner exploration; spec-phase is for ambiguity reduction. Different shapes.
- DO NOT lower the ambiguity gate to "ship faster". The gate exists because lower-ambiguity specs cause less rework downstream.
- DO NOT write SPEC.md from a single interview round. The Socratic loop is rotating-perspective by design.
