---
schema_version: 1.0
name: exploration-phase
display_name: Exploration Phase
category: dev
purpose: Pre-commitment exploration of design ideas (sketch mode) or feasibility unknowns (spike mode). Output is throwaway artifacts that produce verified knowledge for the real build.
modes: [sketch, spike]
default_mode: sketch
duration: short
risk_level: medium
triggers:
  keywords: [explore, sketch, spike, prototype, mockup, experiment, try, validate idea, feasibility]
  patterns: ['(quick|rough)\s+(sketch|mockup|prototype)', 'spike\s+(an?|the)\s+\w+', 'explore\s+(design|idea|approach)']
  file_signals: []
  required_after: []
  required_before: [spec-phase, plan-phase]
  recommended_for: [greenfield design work, technical unknowns, comparing 2-3 approaches before committing]
recommended_skills: [frontend-design, paul:research]
related_paul_workflows: [paul:research, paul:research-phase, paul:discuss]
sources: [GSD commands/gsd/sketch.md, GSD commands/gsd/spike.md]
---

# Exploration Phase

## Purpose

Time-boxed exploration BEFORE committing to a real phase. Two distinct modes:

- **`sketch` mode**, design exploration via throwaway HTML mockups. Build 2-3 visual variants for comparison. Used when "what should this look like?" is unclear.
- **`spike` mode**, technical feasibility exploration via focused experiments. Build the smallest thing that proves whether an approach works. Used when "can we even do this?" is unclear.

The output is verified knowledge (mockups, prototype results, decision rationale) that informs the real build, NOT production code.

## When to recommend

### sketch mode
- Multiple plausible UI/UX approaches and the team can't pick without seeing them
- New design direction (brand refresh, new product surface)
- Stakeholders need to see options before approving direction

### spike mode
- Technical question with no obvious answer (will library X work for our case?)
- Comparing 2-3 implementation approaches
- Validating performance assumptions before committing
- New external dependency / integration with unknown behavior

## Modes

### Mode: sketch
Design-direction exploration. Output: 2-3 throwaway HTML mockups in `.planning/sketches/` that can be compared side-by-side. Includes mood/direction intake, decomposition, building, side-by-side comparison.

### Mode: spike
Technical feasibility exploration. Output: focused experiment in `.planning/spikes/` with documented findings. Includes decomposition, alignment, building, results documentation.

## Phase template

### Goal (sketch mode)
Produce 2-3 throwaway visual mockups that surface the trade-offs of different design directions. Output enables a confident pick.

### Goal (spike mode)
Produce a focused experiment that validates (or invalidates) a feasibility assumption. Output is a documented yes/no/it-depends with concrete evidence.

### Scope
- Define the question (design direction OR feasibility unknown)
- Time-box the exploration (default: 1 day max)
- Build the throwaway artifact
- Document findings + recommended next move

### Plans (suggested decomposition)
- [ ] Plan 1: Define the question + time-box + success criteria
- [ ] Plan 2: Build the artifact (sketch variants OR spike experiment)
- [ ] Plan 3: Compare/measure (side-by-side review for sketches, results write-up for spikes)
- [ ] Plan 4: Document findings + recommended next phase

### Dependencies
None for sketch mode. Spike mode may depend on access to the system being spiked.

### Verification
- Throwaway artifact exists and runs (mockup loads, spike experiment executes)
- Findings document exists with explicit recommendation
- Time-box was respected (this is exploration, not implementation)
- Output points clearly to the next phase (commit, abandon, try alternative)

## Skills orchestrated

1. `frontend-design` (sketch mode), for the visual mockups
2. `paul:research` (spike mode), when feasibility involves library docs / external research

## Source notes

**Primary sources:** GSD `commands/gsd/sketch.md` + GSD `commands/gsd/spike.md`. Both are GSD's pre-commitment exploration patterns. They share enough structure to merge into one phase type with mode flags.

**What sketch contributes:**
- Throwaway HTML mockups in `.planning/sketches/`
- 2-3 variants per sketch for comparison
- Mood/direction intake step
- Frontier mode (analyze existing sketches and propose what to do next)
- Loads spike findings to ground mockups in real data shapes

**What spike contributes:**
- Throwaway experiments in `.planning/spikes/`
- Focused validation of a feasibility question
- Decomposition + alignment + build + results
- Frontier mode (analyze existing spikes and propose integration/next-frontier spikes)

**Why merge into one phase type:** both are TIME-BOXED EXPLORATION OUTPUT IS THROWAWAY. The fact that one produces visual mockups and the other produces code experiments is a mode difference, not a phase-type difference. Mode flag = `sketch | spike`.

**Distinct from `paul:research-phase`:** that workflow researches unknowns for an EXISTING phase. Exploration-phase is its own phase that exists BEFORE you've committed to a real phase. Different intent, different artifacts. Cross-reference each from the other in docs.

**Frontier mode preserved:** both source workflows have a "frontier mode" that analyzes existing sketches/spikes and proposes what's missing. Not built into 3a's template; bookmark for 3b runtime.

**Wrap-up workflows:** both source workflows have a `--wrap-up` flag that packages findings into a persistent project skill. Bookmark for 3b runtime; not in 3a template.

## Anti-patterns

- DO NOT use exploration-phase to ship code. Output is throwaway by design.
- DO NOT skip the time-box. Open-ended exploration drifts into implementation; time-boxing forces a verdict.
- DO NOT use sketch mode for backend work. Use spike mode.
- DO NOT use spike mode for design questions. Use sketch mode.
- DO NOT confuse with `paul:research-phase`. Use that for "research unknowns of an existing phase". Use exploration-phase for "explore before committing to a phase at all".
