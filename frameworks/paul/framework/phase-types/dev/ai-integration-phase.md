---
schema_version: 1.0
name: ai-integration-phase
display_name: AI Integration Phase
category: dev
purpose: Specialized phase for projects integrating AI features. Walks through framework selection, model routing, eval strategy, guardrails, and fallback behavior. Produces AI-SPEC.md design contract.
duration: medium
risk_level: high
triggers:
  keywords: [AI, LLM, Claude, OpenAI, GPT, Anthropic, embedding, RAG, vector, chat, agent, completion, prompt, model, machine learning]
  patterns: ['(integrate|add|build)\s+(an?\s+)?(AI|LLM|chatbot|agent)', '(uses?|calls?)\s+(Claude|OpenAI|GPT|Anthropic)', 'RAG|retrieval.augmented']
  file_signals: ['anthropic', 'openai', 'langchain', '@anthropic-ai/sdk', '*.prompt.md', 'embeddings', 'vector']
  required_after: [spec-phase, plan-phase]
  required_before: [secure-phase, validate-phase]
  recommended_for: [any project building AI features, chatbot integrations, RAG systems, AI-powered tools, embedding-based search, agent systems]
recommended_skills: [claude-api]
related_paul_workflows: [paul:plan, paul:research]
sources: [GSD commands/gsd/ai-integration-phase.md]
---

# AI Integration Phase

## Purpose

Specialized phase for projects integrating AI features. Most modern projects need this; very few do it well. The phase produces an AI-SPEC.md design contract that locks in: which framework, which model(s), what eval strategy, what guardrails, what happens on failure.

This phase exists because AI integration without explicit design tends to ship as "Claude API call wrapped in a fetch." That works in demo. In production, it fails because: wrong model tier for the task (cost), no eval strategy (quality drifts), no guardrails (jailbreak surface), no fallback behavior (single point of failure).

## When to recommend

Auto-detection should recommend ai-integration-phase whenever:
- Project description mentions building chat/agent/RAG/AI features
- Codebase imports Anthropic SDK / OpenAI SDK / LangChain / similar
- New `*.prompt.md` files appear or prompt templates exist
- "Add AI to X" requests
- Embeddings or vector storage in scope
- Multi-model routing (Haiku/Sonnet/Opus or equivalent) is being designed

## Phase template

### Goal
Produce AI-SPEC.md that defines: framework, models, prompt design, eval strategy, guardrails, fallback behavior, cost monitoring. Implementation can proceed against the spec.

### Scope
- Framework selection (Anthropic SDK direct? Claude Agent SDK? LangChain? Custom?)
- Model routing strategy (Haiku for classification, Sonnet for implementation, Opus for architecture, or equivalent for chosen provider)
- Prompt design + caching strategy (prompt caching for cost reduction)
- Eval strategy (capability evals + regression evals)
- Guardrails (input validation, output validation, content moderation, rate limiting)
- Fallback behavior (what happens when LLM call fails / times out / returns malformed output)
- Cost monitoring (per-request, per-user, per-feature)
- Observability (logging what users sent, what model was picked, what came back)

### Plans (suggested decomposition)
- [ ] Plan 1: Select framework (orchestrates `gsd-framework-selector` equivalent)
- [ ] Plan 2: Research API docs (orchestrates `gsd-ai-researcher` equivalent, pulls Anthropic / OpenAI docs via Context7)
- [ ] Plan 3: Research domain (orchestrates `gsd-domain-researcher` equivalent, what does the use case actually need?)
- [ ] Plan 4: Design eval strategy (orchestrates `gsd-eval-planner` equivalent, capability + regression evals defined)
- [ ] Plan 5: Document guardrails + fallback behavior
- [ ] Plan 6: Define cost monitoring approach
- [ ] Plan 7: Write AI-SPEC.md
- [ ] Plan 8: Verify spec against project's existing patterns

### Dependencies
- spec-phase recommended (resolve ambiguity in WHAT before designing HOW)
- plan-phase comes AFTER ai-integration-phase (ai-integration produces the spec; plan-phase produces the implementation plan)

### Verification
- AI-SPEC.md exists at expected path
- Framework choice documented with rationale
- Model routing rules explicit (which task → which model tier)
- Prompt caching strategy defined (matches caddy-api skill pattern)
- Eval strategy includes both capability evals (does it work?) AND regression evals (did the latest change break it?)
- Guardrails enumerate input + output validation + moderation
- Fallback behavior defined for every API call (timeout, error, malformed)
- Cost monitoring approach documented

## Skills orchestrated

1. `claude-api` (the operator's installed skill, when present), for Anthropic SDK / Claude Code App design + prompt caching enforcement
2. (Future) `paul:framework-selector` agent, when ported from GSD's `gsd-framework-selector`
3. (Future) `paul:ai-researcher` agent, when ported from GSD's `gsd-ai-researcher`
4. (Future) `paul:domain-researcher` agent, when ported from GSD's `gsd-domain-researcher`
5. (Future) `paul:eval-planner` agent, when ported from GSD's `gsd-eval-planner`

## Source notes

**Single source:** GSD `commands/gsd/ai-integration-phase.md` plus its referenced workflow.

**What GSD contributes:**
- AI-SPEC.md design contract pattern (analog of UI-SPEC.md but for AI features)
- Orchestration of 4 specialist agents: framework-selector → ai-researcher → domain-researcher → eval-planner
- Workflow gate discipline ("preserve all workflow gates")
- Auto-detect next unplanned phase if argument omitted

**Caddy-specific additions / changes:**
- Integration with the operator's `claude-api` skill (which already handles prompt caching, model migration, Managed Agents)
- Explicit model routing reference to CARL Rule 4 (Auto-route model tier by task complexity, Haiku/Sonnet/Opus). This phase operationalizes that rule for AI features.
- Cost monitoring as required output (GSD doesn't make this explicit; Caddy makes it required because PSA delivery model needs predictable customer costs)
- Fallback behavior as required output (GSD treats as recommended; Caddy makes required)

**Pairs with secure-phase:** AI features ALWAYS need security review (prompt injection, jailbreak attempts, output sanitization). After ai-integration-phase, secure-phase should fire. Auto-detection chains this.

**Eval-review opportunity:** GSD has a separate `eval-review` command for retrospective eval audits. Caddy's ai-integration-phase includes eval design as Plan 4; the audit version (eval-review) becomes a sub-step of validate-phase rather than a standalone phase type.

## Anti-patterns

- DO NOT skip ai-integration-phase for "we're just calling the Claude API" projects. Even one API call needs framework choice, eval strategy, guardrails, fallback. Skipping creates production fragility.
- DO NOT default to the most expensive model for everything. Model routing is a Plan 1 decision, not an afterthought.
- DO NOT design guardrails as an afterthought. Input/output validation + moderation must be in the spec, not patched in after a customer reports a jailbreak.
- DO NOT skip cost monitoring. AI features without per-feature cost tracking become unprofitable surprises.
- DO NOT skip fallback behavior. When the LLM is down or returns garbage, the feature must degrade gracefully, not crash.
