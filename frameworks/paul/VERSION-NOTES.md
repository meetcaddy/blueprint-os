# PAUL version notes

## v0.2.0 (2026-08-10)

- Adds the 12 specialist subagents under `agents/`: research, domain research, evaluation planning, framework selection, UI research and checking, security audit, and the four build-stream agents (backend, frontend, tests, docs). `caddy-link` links them into `~/.claude/agents/`.
- Retires the old "degraded direct-model mode" note. The full command set and the subagents now ship together.
- Note: a few subagents list optional research connectors (context7, firecrawl, exa) among their tools. If a connector is not installed, the agent simply runs with its remaining tools. Nothing breaks.
- Note: some subagents mention orchestrator commands (multi-stream, ui-phase, secure-phase, ai-integration-phase) that are not part of this release. Each agent also works standalone via normal agent invocation.
- Note: seven subagents are adapted from the GSD project (MIT; see LICENSE-NOTICES.md). Some of their optional reference reads (a get-shit-done reference folder, a paul-sdk CLI) are not part of this distribution; the agents proceed without them.

## v0.1.0 (2026-05-11)

- Initial Caddy distribution.
