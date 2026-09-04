---
schema_version: 1.0
name: validate-phase
display_name: Validation Phase
category: dev
purpose: Adversarial post-implementation validation. Audits coverage, fills gaps with behavioral tests, scores PASS/PARTIAL/MISSING per dimension. Output VALIDATION.md.
duration: medium
risk_level: high
triggers:
  keywords: [validate, validation, test coverage, verify, audit results, behavioral test, integration test]
  patterns: ['(validate|verify|audit)\s+(the\s+)?(phase|implementation|build)', 'check\s+coverage', 'before\s+(ship|merge|deploy)']
  file_signals: [VALIDATION.md, '*.test.ts', '*.test.js', '*.spec.ts', '*.spec.js', '*_test.py', '*.test.go']
  required_after: [execute-phase, plan-phase]
  required_before: [secure-phase, ship-phase]
  recommended_for: [phases ending in customer-facing changes, anything pre-production, AI feature validation, refactor verification]
recommended_skills: []
related_paul_workflows: [paul:verify, paul:apply]
sources: [GSD commands/gsd/validate-phase.md]
---

# Validation Phase

## Purpose

Adversarial post-implementation validation. The job: verify the phase actually delivered what it claimed, not just that someone wrote tests. Adopts the FORCE adversarial stance from GSD's nyquist-auditor pattern: assume the implementation is broken until tests prove otherwise.

This phase exists because "tests pass" doesn't mean "the thing works." Tests can pass while testing the wrong behavior. Validation runs adversarial coverage analysis, generates tests for actual gaps, and scores the implementation honestly.

## When to recommend

Auto-detection should recommend validate-phase whenever:
- An execute-phase just completed
- ROADMAP entry shows the phase as "ready to validate"
- VALIDATION.md doesn't yet exist for the phase
- Customer-facing change is about to ship
- AI feature went through ai-integration-phase (always validate AI features)
- Refactor work just completed (high regression risk)

## Phase template

### Goal
Audit Nyquist validation coverage for the completed phase. Produce updated VALIDATION.md scoring each dimension PASS / PARTIAL / MISSING. Generate behavioral tests for MISSING dimensions. Output: confident yes-or-no on whether the phase actually meets its goals.

### Scope
Three execution states:
- **State A:** VALIDATION.md exists, audit it and fill any gaps
- **State B:** No VALIDATION.md but SUMMARY.md exists, reconstruct VALIDATION.md from artifacts
- **State C:** Phase not executed, exit with guidance to run execute-phase first

### Plans (suggested decomposition)
- [ ] Plan 1: Identify execution state (A/B/C); load relevant artifacts
- [ ] Plan 2: Map phase requirements (from PLAN.md / SPEC.md / ROADMAP.md) to dimensions
- [ ] Plan 3: Score each dimension PASS / PARTIAL / MISSING with FORCE adversarial stance
- [ ] Plan 4: For MISSING dimensions, identify validation gaps
- [ ] Plan 5: Generate adversarial behavioral tests for each gap (Nyquist auditor pattern)
- [ ] Plan 6: Run generated tests; document actual results (not what implementation claims)
- [ ] Plan 7: Write/update VALIDATION.md with scoring + test results
- [ ] Plan 8: Surface BLOCKER findings (any MISSING that can't be filled = ship-blocker)

### Dependencies
- Phase has been executed (execute-phase completed)
- PLAN.md or SPEC.md exists defining what the phase was supposed to deliver

### Verification
- VALIDATION.md exists at expected path
- Every dimension from PLAN/SPEC has a PASS/PARTIAL/MISSING score
- MISSING dimensions are either filled (with passing test) or escalated as BLOCKER
- Generated tests actually execute (don't pass trivially or test simpler behavior than required)
- Implementation files were NOT modified (this phase is read-only on implementation)

## Skills orchestrated

(Future) `paul:nyquist-auditor` agent, when ported from GSD's `gsd-nyquist-auditor`. Generates the adversarial behavioral tests.

(Future) `paul:eval-auditor` agent, when ported from GSD's `gsd-eval-auditor`. For AI-feature validation specifically (audits eval coverage retroactively).

## Source notes

**Primary source:** GSD `commands/gsd/validate-phase.md` plus its referenced workflow.

**What GSD contributes:**
- VALIDATION.md artifact pattern
- Three-state execution logic (A/B/C)
- Nyquist coverage discipline (every requirement must have a behavioral test that can fail)
- Adversarial stance: implementation is read-only; only test files get created/modified
- BLOCKER classification for missing dimensions that can't be filled

**Caddy-specific additions:**
- Pairs naturally with secure-phase: validate-phase covers functional correctness, secure-phase covers security posture. Both should fire before ship.
- Cross-references AI integration: when phase came from ai-integration-phase, validate-phase invokes paul:eval-auditor for AI-specific validation (eval coverage scoring).
- Confidence-based filtering: applies the >80% confidence rule from PAUL upgrades. Only flag findings above the threshold; consolidate similar issues.

**Why FORCE stance matters:** without adversarial discipline, validation produces feel-good reports. "Tests pass, looks good" with no probing of edge cases. FORCE stance forces the validator to start from "this is broken until proven", which surfaces the gaps that "looks good" reviews miss.

**Why implementation files are READ-ONLY:** validation that fixes implementation hides bugs. The validator's job is to surface, not patch. If a test fails because of an implementation bug, that bug ESCALATES to the team, not silently fixed by the validator.

## Anti-patterns

- DO NOT mark a dimension PARTIAL "because some tests exist." Partial coverage of a critical requirement is MISSING until the gap is quantified.
- DO NOT fix implementation bugs during validate-phase. Surface them, escalate, then run a separate fix phase.
- DO NOT credit documentation as implementation evidence. SPEC.md says X exists ≠ X actually works.
- DO NOT generate tests that pass trivially. A passing test that tests easier behavior than the requirement demands is worse than no test (creates false confidence).
- DO NOT run validate-phase on incomplete work. Run during a phase produces noise; run after produces signal.
