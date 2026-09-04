---
schema_version: 1.0
name: process-doc-phase
display_name: Process Documentation Phase
category: marketing-and-ops
purpose: Document an internal operational process so it's repeatable, delegable, and auditable. Output: structured process doc with steps, owners, checkpoints, edge cases.
duration: short
risk_level: low
triggers:
  keywords: [document, process, SOP, standard operating procedure, runbook, playbook, internal process, workflow doc, how-we-do]
  patterns: ['document\s+(the|our|this|a)\s+(process|workflow|procedure|SOP)', '(SOP|runbook|playbook)\s+(for|on)', 'how\s+(we|do\s+we)\s+\w+']
  file_signals: [SOP*.md, RUNBOOK*.md, PLAYBOOK*.md, PROCESS*.md]
  required_after: []
  required_before: []
  recommended_for: [scaling teams, delegation prep, process consistency, compliance prep, knowledge transfer, vendor handoff]
recommended_skills: [doc, humanizer, brand-kit]
related_paul_workflows: [paul:plan]
sources: [Caddy native, uses doc + humanizer skills with internal-process-doc structure]
---

# Process Documentation Phase

## Purpose

Document an internal operational process so it can be: followed by anyone, delegated cleanly, audited later, and improved over time. Output is a structured process doc (SOP / runbook / playbook) with explicit steps, owners, checkpoints, edge cases, and review cadence.

This phase exists because undocumented processes live only in one person's head. They don't scale, don't delegate, don't survive turnover, and can't be improved systematically.

## When to recommend

Auto-detection should recommend process-doc-phase whenever:
- Tucker says "let me document this" / "we should write this down"
- Process is being delegated to a VA, employee, or contractor
- Compliance or audit requirement
- Onboarding new hire or contractor
- Process has been done >3 times the same way (codify it)
- Process broke because someone forgot a step
- Vendor handoff requires explicit procedures

## Phase template

### Goal
Produce a structured process doc that someone unfamiliar with the process can follow successfully on their first try. Output: SOP/runbook/playbook artifact saved in the right location, indexed for findability, with review cadence set.

### Scope
- Identify the process (start point, end point, who runs it)
- Capture the actual steps (interview the person who does it OR document while doing)
- Identify decision points and edge cases
- Identify owners and handoffs
- Identify checkpoints (gates that must be cleared before moving on)
- Write the doc with consistent structure
- Save to the right location (team wiki, repo docs, Drive folder)
- Set review cadence (quarterly? annually? on-incident?)

### Plans (suggested decomposition)
- [ ] Plan 1: Process scope (start trigger, end deliverable, owner)
- [ ] Plan 2: Step capture (walkthrough or interview)
- [ ] Plan 3: Decision points + edge cases (what happens when X goes wrong?)
- [ ] Plan 4: Owners + handoffs (who does what, who hands off to whom)
- [ ] Plan 5: Checkpoints (must-clear-before-proceeding gates)
- [ ] Plan 6: Write doc with consistent structure (orchestrates `/doc` + humanizer)
- [ ] Plan 7: Save + index (where it lives so people can find it)
- [ ] Plan 8: Set review cadence + add to recurring calendar

### Dependencies
- Process EXISTS (this phase doesn't design new processes; it documents existing ones)
- Subject-matter expert available (the person who runs the process)
- Decision on doc location (Drive / wiki / repo)

### Verification
- Doc exists at agreed location
- Doc structure matches Caddy template (steps, owners, checkpoints, edge cases)
- Voice consistent (humanizer applied if customer-facing)
- Findability: doc is indexed where people will look for it
- Review cadence set on calendar
- Smoke test: someone unfamiliar reads it and could execute the process

## Skills orchestrated

1. `doc`, long-form structured doc generation
2. `humanizer`, voice consistency if doc is customer-facing
3. `brand-kit`, formatting + tone discipline

## Source notes

**Caddy native phase type, no external repo source.** Uses Tucker's existing `/doc` skill with a structured internal-process template overlaid.

**Why a phase type instead of just using `/doc` directly:** `/doc` generates documents from a template + voice. process-doc-phase adds the DISCIPLINE around process documentation: capture-then-write workflow, edge-case identification, owner mapping, checkpoint definition, review cadence setup. The phase makes "document our process" reliable, not just "write words about a process."

**Caddy-specific design:**
- Voice consistency required only if doc is customer-facing (internal SOPs can be terse)
- Findability is a REQUIRED Plan (a process doc nobody can find is worthless)
- Review cadence is REQUIRED (processes drift; documents go stale; cadence forces reconsideration)
- Smoke test: someone unfamiliar can execute the process from the doc

**Why no mode flags:** process documentation is one shape. Variations (SOP vs runbook vs playbook) are mostly naming conventions, not structural differences. Same orchestration backbone serves all.

**Pairs with:**
- `customer-lifecycle-phase` (process docs for customer onboarding/offboarding fall here)
- `campaign-phase` (campaign retrospectives often surface processes worth documenting)
- `paul:plan` (when documenting a complex process, plan-phase can structure the doc work itself)

## Anti-patterns

- DO NOT use this phase to DESIGN a new process. Use brainstorm or paul:discuss for design; this phase documents what ALREADY exists.
- DO NOT skip edge case identification. SOPs without edge cases break the first time something unusual happens.
- DO NOT skip owner mapping. Steps without owners create "someone should do this" gaps.
- DO NOT skip findability. A process doc nobody can find is worse than no doc (false sense of completeness).
- DO NOT skip review cadence. Processes drift; docs without review cadence go stale within months.
- DO NOT confuse with documenting CODE (use `paul:apply` doc steps for code documentation).
