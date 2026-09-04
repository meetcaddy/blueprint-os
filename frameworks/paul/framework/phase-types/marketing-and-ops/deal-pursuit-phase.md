---
schema_version: 1.0
name: deal-pursuit-phase
display_name: Deal Pursuit Phase
category: marketing-and-ops
purpose: Multi-touchpoint sales process from qualified lead through close. Orchestrates pipeline tracking, prep for every meeting, follow-up after every meeting, voice-consistent communication.
duration: long
risk_level: medium
triggers:
  keywords: [deal, sales process, prospect, pursue, sales meeting, pitch, demo, proposal, contract negotiation, close deal]
  patterns: ['(pursue|pursuing|chasing|working)\s+(a|the)\s+(deal|prospect|account)', 'sales\s+(meeting|call|process)', '(pitch|demo|proposal)\s+(to|for)']
  file_signals: []
  required_after: [outreach-phase]
  required_before: []
  recommended_for: [B2B sales with sales cycles longer than 1 meeting, high-value deals, founder-led sales, agency client pursuits]
recommended_skills: [pipeline, prep, followup, draft, humanizer, doc, contacts-update, close]
related_paul_workflows: []
sources: [Caddy native, synthesizes pipeline + prep + followup + draft + humanizer + close skills into deal pursuit workflow]
---

# Deal Pursuit Phase

## Purpose

Run a multi-touchpoint sales process from qualified lead through close. Orchestrates the discipline of: prep before every meeting, follow-up after every meeting, voice-consistent communication, pipeline accuracy, and a deliberate close motion.

This phase exists because deals don't close themselves. The difference between a closed deal and a stalled one is usually: did the seller follow up appropriately + remember context + send the right thing at the right time? Phase makes that the default, not an accident.

## When to recommend

Auto-detection should recommend deal-pursuit-phase whenever:
- Outreach-phase produced a warm response (lead has agreed to a meeting)
- New qualified lead in pipeline
- Sales cycle longer than 1 meeting (most B2B)
- High-value deal (custom proposal, contract negotiation likely)
- Founder-led sales motion (Tucker's own Caddy sales is the canonical example)

## Phase template

### Goal
Move a deal from qualified-lead state to close (won or lost) with disciplined per-touchpoint execution. Output: pipeline accurately reflects status, every meeting prepped + followed up, voice-consistent communication throughout, decisive close motion at the right moment.

### Scope
- Initial discovery / qualification call (orchestrates `prep` + `followup`)
- Subsequent meetings (demo, technical deep-dive, pricing discussion, etc.), each prepped + followed up
- Asynchronous communication (email, LinkedIn DMs), voice-consistent, well-timed
- Proposal / contract production (orchestrates `doc`)
- Pricing + negotiation handling
- Close motion (orchestrates `close` skill)
- Pipeline tracking continuously updated

### Plans (suggested decomposition)
- [ ] Plan 1: Initial discovery call prep (orchestrates `prep`) + execution + follow-up
- [ ] Plan 2: Pipeline status update, qualified, key context captured
- [ ] Plan 3: Subsequent meeting cycle (repeat per meeting): prep → meeting → followup → pipeline update
- [ ] Plan 4: Async communication between meetings (orchestrates `draft` + humanizer)
- [ ] Plan 5: Proposal / pricing document production (orchestrates `doc` + humanizer)
- [ ] Plan 6: Negotiation handling (objection responses, pricing flex, terms)
- [ ] Plan 7: Close motion (orchestrates `/close` skill)
- [ ] Plan 8: Pipeline final state, won (route to customer-lifecycle-phase onboarding mode) OR lost (capture reason)

### Dependencies
- Pipeline initialized + lead exists in pipeline
- Voice fingerprint exists (humanizer for all communication)
- Calendar + Gmail connected
- For Tucker specifically: Stripe (or Fanbasis pending decision) integrated for payment after close

### Verification
- Every meeting in the cycle was prepped (no walk-in-cold meetings)
- Every meeting in the cycle had a follow-up sent
- Pipeline status accurate at every stage transition
- Voice consistent across all written communication
- Close motion executed deliberately (not by accident or by the prospect)
- For won: deal handed off to customer-lifecycle-phase onboarding
- For lost: reason captured + pipeline marked closed-lost

## Skills orchestrated

1. `pipeline`, continuous status tracking
2. `prep`, before every meeting (gathers attendee context, prior thread history, suggested talking points)
3. `followup`, after every meeting (recap email + structured action items)
4. `draft`, async communication (proposals, negotiation emails, scheduling)
5. `doc`, proposal / contract document generation
6. `humanizer`, voice consistency on all written touchpoints
7. `contacts-update`, keep prospect contact records current
8. `close`, deliberate close motion when timing is right

## Source notes

**Caddy native phase type, no external repo source.** Synthesized from Tucker's existing Caddy skill catalog. Tucker uses these skills daily for his own Caddy sales motion; this phase formalizes the orchestration pattern.

**Why no mode flags:** deal pursuit is one shape. There aren't fundamentally different "kinds" of deal pursuit that warrant mode flags. Variations (large vs small deal, transactional vs consultative) are PROJECT-specific, not phase-type-specific. Customer can adjust depth per touchpoint without needing a mode.

**Caddy-specific design:**
- Prep + followup are NON-NEGOTIABLE per touchpoint. Skipping either is what causes deals to stall.
- Voice consistency via humanizer applies to EVERY touchpoint (a deal-pursuit email that sounds different from earlier emails reads as a different person; trust erodes).
- Pipeline accuracy is required at every stage (not just at the end). Inaccurate pipeline = no learning loop on what works.
- Close motion is a deliberate Plan 7, not "let the prospect decide when they're ready" (prospects almost never decide unilaterally; sellers move them).

**For Tucker's own Caddy sales motion:**
- Initial outreach typically starts with `outreach-phase` (cold-email or warm modes) → produces qualified leads
- Qualified leads enter `deal-pursuit-phase`
- Won deals route to `customer-lifecycle-phase` onboarding mode
- Lost deals capture reason for product/pricing/positioning iteration

**Pairs with:**
- `outreach-phase` (precedes; produces qualified leads)
- `customer-lifecycle-phase` (follows for won deals)
- `content-series-phase` case-study mode (won deals can become case studies later)

## Anti-patterns

- DO NOT skip prep before "small" meetings. Walk-in-cold meetings telegraph that the deal isn't important to you.
- DO NOT skip follow-up after meetings. The follow-up is what differentiates "I had a conversation" from "the deal is moving."
- DO NOT let pipeline lag reality. Updating pipeline at end-of-quarter destroys forecasting accuracy.
- DO NOT use template emails for deal-pursuit communication. Per-deal context is what closes deals; templates dilute it.
- DO NOT defer close motion ("let me know when you're ready"). Prospects don't self-close; sellers move them.
- DO NOT skip lost-deal reason capture. Lost reasons are highest-signal product/pricing feedback.
