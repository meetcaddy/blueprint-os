---
schema_version: 1.0
name: customer-lifecycle-phase
display_name: Customer Lifecycle Phase
category: marketing-and-ops
purpose: Operational customer-relationship work across the lifecycle. Three stages: onboarding (new customer), mid-life (active relationship), offboarding (cancellation flow).
modes: [onboarding, mid-life, offboarding]
default_mode: onboarding
duration: medium
risk_level: medium
triggers:
  keywords: [customer onboarding, customer offboarding, cancellation, churn, customer success, customer health, account review, mid-life, retention]
  patterns: ['(onboard|offboard|cancel|churn)', '(customer|account)\s+(review|health|success)', '(new|departing)\s+customer']
  file_signals: []
  required_after: []
  required_before: []
  recommended_for: [Caddy customers running customer-facing businesses, SaaS operators, agencies with retainer clients, anyone with recurring customer relationships]
recommended_skills: [intake, setup, tune-up, prep, followup, draft, pipeline, contacts-update, digest]
related_paul_workflows: []
sources: [Caddy native, synthesizes intake + setup + tune-up + prep + followup + draft + pipeline + contacts-update skills into lifecycle workflow]
---

# Customer Lifecycle Phase

## Purpose

Operational customer-relationship work organized by lifecycle stage. Three stages:

- **`onboarding` mode**, new customer just started. First 30-90 days. Goal: time-to-first-value + relationship establishment.
- **`mid-life` mode**, active customer, ongoing relationship. Goal: retention, expansion, satisfaction monitoring.
- **`offboarding` mode**, customer is leaving (cancellation, churn). Goal: clean exit + insight capture.

Each stage has a different operational pattern. Same orchestration backbone (skills + scheduling + tracking); different focus per stage.

## When to recommend

### onboarding mode
- New customer just signed
- Product/service trial starting
- Implementation or kickoff project
- Pairs with Caddy's existing `/intake` and `/setup` skills which Caddy installs use for THEIR own onboarding

### mid-life mode
- Quarterly customer health review
- Account expansion conversation
- Renewal nearing
- Customer success motion

### offboarding mode
- Customer requested cancellation
- Churn signals detected (silent customer, payment failure, downgrade)
- Contract end approaching without renewal
- Goal: clean exit + capture WHY for future improvement

## Modes

### Mode: onboarding
First 30-90 days of customer relationship. Walks through:
- Day 1: kickoff (welcome, expectations, access setup)
- Week 1: time-to-first-value milestones
- Week 2-4: skill-building / training
- Day 30: first review check-in
- Day 60-90: regular cadence established

### Mode: mid-life
Active relationship management:
- Quarterly health review (usage, satisfaction, expansion opportunities)
- Periodic check-ins
- Issue surfacing (proactive, not reactive)
- Renewal preparation
- Expansion conversations (upsell / cross-sell)

### Mode: offboarding
Departure handling:
- Cancellation acknowledgment + dignity
- Exit interview (capture WHY)
- Data export / handoff
- Final invoice + any contractual cleanup
- Insight capture (what could we have done differently?)
- Door-open close (welcome back later if they want)

## Phase template (onboarding mode)

### Goal
Customer reaches first-value milestone within 30 days, has clear understanding of how to use the product/service, and has established communication cadence with the team.

### Plans (suggested decomposition)
- [ ] Plan 1: Kickoff call prep + execution (orchestrates `prep` + `followup`)
- [ ] Plan 2: Welcome email + first-week resources (orchestrates `draft` + `humanizer`)
- [ ] Plan 3: Access setup confirmation (login, accounts, integrations)
- [ ] Plan 4: First-value milestone definition + tracking
- [ ] Plan 5: Week 1 check-in
- [ ] Plan 6: Day-30 review (orchestrates `prep` + `followup` for the meeting)
- [ ] Plan 7: Add to recurring meeting cadence (calendar setup)
- [ ] Plan 8: Pipeline status updated to active customer

## Phase template (mid-life mode)

### Goal
Active customer relationship maintained: quarterly health reviews completed, expansion opportunities surfaced, churn signals caught early, renewal conversation tee'd up.

### Plans
- [ ] Plan 1: Quarterly health snapshot (usage, satisfaction signals, recent communications via `digest`)
- [ ] Plan 2: Customer prep for review meeting (orchestrates `prep`)
- [ ] Plan 3: Review meeting + follow-up (orchestrates `followup`)
- [ ] Plan 4: Expansion / renewal conversation (if applicable)
- [ ] Plan 5: Pipeline status update (orchestrates `pipeline`)
- [ ] Plan 6: Action items for next quarter

## Phase template (offboarding mode)

### Goal
Customer departs cleanly. Reason captured for product/service improvement. Door left open for future return.

### Plans
- [ ] Plan 1: Acknowledge cancellation respectfully (orchestrates `draft` + humanizer for the response)
- [ ] Plan 2: Exit interview (capture: why leaving, what would have changed mind, what to improve)
- [ ] Plan 3: Data export / handoff (legal + contractual obligations)
- [ ] Plan 4: Final invoice + cleanup
- [ ] Plan 5: Insight capture (write findings into customer-success memory for future improvement)
- [ ] Plan 6: Door-open close (genuine "welcome back if anything changes")
- [ ] Plan 7: Pipeline status updated to closed-lost with reason

### Dependencies
- Customer record exists in pipeline / CRM
- Voice fingerprint exists (humanizer for all customer-facing communication)
- Communication channels active (Gmail for emails, Calendar for meetings)

### Verification
- All planned customer-facing communications sent
- Calendar cadence established (or terminated for offboarding)
- Pipeline reflects accurate status
- Insight captured (especially for offboarding)
- Customer signals (CSAT/usage/health) updated

## Skills orchestrated

1. `intake`, for the first onboarding intake (Caddy customer onboarding their own customer)
2. `setup`, for any account/integration setup
3. `tune-up`, for periodic health-check ritual (mid-life mode)
4. `prep`, for every customer meeting
5. `followup`, for every customer meeting
6. `draft`, for customer-facing emails
7. `pipeline`, status tracking
8. `contacts-update`, keep customer contact records current
9. `digest`, for synthesizing recent communications during reviews
10. `humanizer`, voice consistency on all customer-facing copy
11. `quick-capture`, for capturing customer insights mid-conversation

## Source notes

**Caddy native phase type, no external repo source.** Synthesized from Tucker's existing Caddy skill catalog into a lifecycle-stage-driven workflow.

**Why merge three stages into one phase type:** all three are operational customer-relationship work. They share 80% of skill orchestration (prep, followup, draft, humanizer, pipeline, contacts-update). Mode flag captures the lifecycle stage; per-mode template captures the stage-specific outcomes.

**Naming conflict resolved:** Caddy already has `/intake` skill for ITS customer's own onboarding (the Caddy install onboarding flow). `customer-lifecycle-phase` orchestrates a Caddy customer's work onboarding THEIR OWN customers. Different layer; cross-reference in docs to avoid confusion.

**Caddy-specific design:**
- All customer-facing communication uses humanizer (voice consistency in customer relationship is non-negotiable)
- Pipeline tracking is REQUIRED (no relationship management without status visibility)
- Insight capture in offboarding mode is REQUIRED (churned-customer reasons are highest-signal product feedback)
- Door-open close in offboarding (relationship doesn't end at cancellation, many customers return when situation changes)

**Pairs with:**
- `outreach-phase` (warm mode, for re-engaging dormant customers)
- `content-series-phase` (case-study mode, onboarded customers may become case studies)
- `process-doc-phase` (documenting customer-success processes)

## Anti-patterns

- DO NOT skip onboarding for "small" customers. Onboarding cost is fixed; small customers benefit MORE from clear onboarding (they have less context to figure things out independently).
- DO NOT skip exit interviews. Departing-customer reasons are the most accurate product feedback you'll ever get.
- DO NOT make offboarding adversarial. Door-open close is RELATIONSHIP work; saving the relationship for future is more valuable than a clean exit transaction.
- DO NOT use generic templates for customer-facing communication. Voice consistency via humanizer is REQUIRED at every touchpoint.
- DO NOT skip the day-30 onboarding review. The review is the gate between "new customer" and "active relationship".
