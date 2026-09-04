# caddy-permission-guard: risk-profile permission hook (A3 step 2)

Applies a **risk profile** to Claude Code permission prompts: auto-approve the safe stuff, auto-deny
catastrophes, ask on everything else, and logs every decision so the profile can be **graduated on
evidence**. The harness-enforced version of CARL's permission posture.

Governance pillar: caddy-agent-audit (scan) · caddy-safety-guard (dangerous calls) ·
caddy-config-guard (guardrail-weakening config) · **this** (permission auto-decisions).

## Profiles (nested: each a superset of the previous)
- **conservative:** auto-approve only safe read-only ops (Read/Grep/Glob, ls, git status/diff/log, cat
  of non-secret files). Ask on everything else.
- **standard** (default), conservative + in-project writes/edits + routine git (add/commit/diff/pull/
  push --force-with-lease). Ask on installs, network, and unknown commands.
- **trusted:** auto-approve everything EXCEPT the hard floors.

## Hard floors (EVERY profile, including trusted: never auto-approved)
- Catastrophe commands (rm -rf root/glob, curl|bash, fork bomb, dd to device, mkfs) → **deny**.
- Anything touching secrets (read/write .env/.pem/id_rsa/credentials, secret in content) → **ask**.

## Modes (env CADDY_PERMGUARD_MODE / CADDY_PERMGUARD_PROFILE > config.json > advisory/standard)
- **advisory** (default), logs the decision it WOULD make; never acts (the normal prompt still shows).
- **active:** actually emits allow/deny; "ask" falls through to the normal prompt.

Read-only decisioning, fail-open. Log: `~/.caddy/permission-guard.log`.

## Graduation (the test-then-promote path)
```bash
python3 guard.py status   # decision counts + readiness to move up a profile
```
When the log shows a clean track record at the current profile, graduate by editing `config.json`
`"profile"` (your call, never automatic; a self-escalating security control is exactly what
caddy-config-guard flags), then re-run `caddy-config-guard/guard.py baseline` to accept.

Activation path: advisory → review log → flip `"mode": "active"` (your go) → run standard a while →
`status` → graduate to trusted when ready.

## Wired
Installed to `~/.claude/skills/caddy-permission-guard/`; `PermissionRequest` hook in
`~/.claude/settings.json`, **advisory mode / standard profile**. 21 tests + nesting invariant pass.

*v0.1, 2026-06-07.*
