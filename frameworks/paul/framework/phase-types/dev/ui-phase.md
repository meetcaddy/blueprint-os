---
schema_version: 1.0
name: ui-phase
display_name: UI Development Phase
category: dev
purpose: Frontend UI development with explicit design contract (UI-SPEC.md), then retroactive 6-pillar visual audit (UI-REVIEW.md). Two-step pattern enforces design quality.
modes: [build, review]
default_mode: build
duration: medium
risk_level: medium
triggers:
  keywords: [UI, frontend, design, layout, page, component, visual, interface, dashboard, form]
  patterns: ['(build|create|design)\s+(a\s+)?(page|component|UI|interface|dashboard|form|screen)']
  file_signals: [.tsx, .jsx, .vue, .svelte, .astro, .html, .css, .scss, components/, pages/, app/]
  required_after: [spec-phase, plan-phase]
  required_before: [validate-phase, ship-phase]
  recommended_for: [any phase touching frontend code, design refresh work, new customer-facing pages]
recommended_skills: [frontend-design]
related_paul_workflows: [paul:plan, paul:apply]
sources: [GSD commands/gsd/ui-phase.md, GSD commands/gsd/ui-review.md]
---

# UI Development Phase

## Purpose

Two-step pattern for frontend work:

- **`build` mode**, generate a UI design contract (UI-SPEC.md) BEFORE coding. Forces explicit decisions about structure, design system, accessibility, interactions.
- **`review` mode**, retroactive 6-pillar visual audit (UI-REVIEW.md) AFTER coding. Grades 1-4 per pillar.

The two modes are paired: build before code, review after code. Either can run independently if the other already exists or isn't needed.

This phase exists because frontend work without an explicit design contract drifts toward generic AI aesthetics. The build/review pattern enforces design quality at both ends.

## When to recommend

### build mode
- New UI surface (new page, new dashboard, new component library)
- Design refresh of existing UI
- Frontend work where layout/design hasn't been decided
- Multi-component feature where consistency matters

### review mode
- Frontend code shipped without a UI-SPEC
- Design quality concerns surfaced during validation
- Pre-launch visual audit
- Pairs naturally with the `design-quality-check` hook (when Caddy v3 ships hooks)

## Modes

### Mode: build
Pre-implementation. Orchestrates research + design + verification:
- Validate phase + roadmap entry
- Research UI patterns (Context7, design system references)
- Generate UI-SPEC.md (structure, design system tokens, interactions, accessibility)
- Verify UI-SPEC against project's design conventions

Output: `{phase_dir}/UI-SPEC.md`

### Mode: review
Post-implementation. 6-pillar visual audit with 1-4 grading per pillar.

Six pillars (typical):
1. Visual hierarchy and contrast
2. Spacing rhythm
3. Typography
4. Color and theme consistency
5. Interaction states (hover, focus, disabled, loading, error)
6. Accessibility (semantic HTML, ARIA, keyboard navigation, color contrast)

Output: `{phase_dir}/{phase_num}-UI-REVIEW.md`

## Phase template (build mode)

### Goal
Produce UI-SPEC.md that defines the structure, design system, interactions, and accessibility contract for this phase's UI work. Code can be generated against the spec.

### Scope
- Validate phase exists in roadmap
- Research relevant UI patterns + libraries (via Context7)
- Generate UI-SPEC.md with structure, components, tokens, interactions, accessibility
- Verify spec aligns with project's existing design system

### Plans (suggested decomposition)
- [ ] Plan 1: Validate phase + load design context
- [ ] Plan 2: Research UI patterns (gsd-ui-researcher equivalent)
- [ ] Plan 3: Generate UI-SPEC.md
- [ ] Plan 4: Verify UI-SPEC against project conventions (gsd-ui-checker equivalent)

## Phase template (review mode)

### Goal
Produce UI-REVIEW.md with 6-pillar graded assessment. Output documents what's strong, what's weak, what to fix.

### Scope
- Read all frontend files modified in the target phase
- Score each of 6 pillars (1-4)
- Document specific findings per pillar with file:line references
- Generate prioritized fix list

### Plans
- [ ] Plan 1: Identify frontend files in scope (changed in target phase)
- [ ] Plan 2: Run 6-pillar audit (parallel pillar scorers)
- [ ] Plan 3: Synthesize findings, write UI-REVIEW.md
- [ ] Plan 4: Generate prioritized fix list with file:line references

### Verification
- UI-SPEC.md exists (build mode) OR UI-REVIEW.md exists (review mode)
- All 6 pillars graded (review mode)
- Findings have file:line references (no vague "the spacing is off")
- Recommendations are actionable

## Skills orchestrated

1. `frontend-design`, Caddy's frontend design skill, used in both modes
2. (Future) `paul:ui-researcher` agent, when ported from GSD's `gsd-ui-researcher`
3. (Future) `paul:ui-checker` agent, when ported from GSD's `gsd-ui-checker`

## Source notes

**Two-source merge:** GSD `commands/gsd/ui-phase.md` + GSD `commands/gsd/ui-review.md`.

**ui-phase contributes (`build` mode):**
- UI-SPEC.md design contract pattern
- Orchestration of researcher + checker agents
- Pre-implementation discipline

**ui-review contributes (`review` mode):**
- Retroactive 6-pillar visual audit
- 1-4 grading per pillar
- UI-REVIEW.md artifact

**Why merge into one phase type:** they're paired by design, build (pre) + review (post). They share the same target (UI work) and the same tooling (frontend-design skill, Context7 for research). Mode flag = `build | review`. A project can run build → implement → review as a flow, or just one if the other already exists.

**Caddy integration:** `review` mode pairs naturally with the `design-quality-check` hook from ECC (queued in Caddy v3 hook bundle). Hook catches generic-AI-aesthetic signals during edits; review mode does the deeper structured audit.

**Why not also merge with frontend-design skill:** frontend-design is a Claude Code skill (component-by-component generation discipline). ui-phase is a phase orchestration (workflow that uses frontend-design plus other tools). Different layers.

## Anti-patterns

- DO NOT skip `build` mode for "small" frontend work. Small UI changes are where generic-aesthetic drift creeps in.
- DO NOT use `review` mode as a substitute for `build` mode. Review without a spec to compare against produces vague feedback.
- DO NOT confuse this with the `design-quality-check` hook. Hook is automatic and lightweight; this phase is deliberate and deep.
- DO NOT run `review` mode on frontend code generated by a skill that already enforces design quality (frontend-design). Will surface noise. Run only when concerns exist.
