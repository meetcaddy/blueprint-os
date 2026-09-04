---
schema_version: 1.0
name: secure-phase
display_name: Security Review Phase
category: dev
purpose: Apply security review at a defined point in the build cycle. Three depths from quick config check to comprehensive audit with scored posture assessment.
modes: [check, audit, full]
default_mode: audit
duration: short
risk_level: high
triggers:
  keywords: [security, secure, threat, vulnerability, auth, login, password, token, encryption, PII, credentials, CVE, audit]
  patterns: ['(security|secure)\s+(review|audit|check|scan)', 'before\s+(ship|production|launch)', 'handle\s+(user\s+data|customer\s+data|PII)']
  file_signals: [.env, secrets, auth, login, password, credentials, .pem, .key]
  required_after: [plan-phase, execute-phase]
  required_before: [ship-phase, deploy]
  recommended_for: [any project handling user data, customer-facing software, auth flows, payment processing, anything with login, production deploys]
recommended_skills: []
related_paul_workflows: [paul:audit]
sources: [GSD commands/gsd/secure-phase.md, cc-ultimate-guide examples/commands/security-audit.md, cc-ultimate-guide examples/commands/security-check.md]
---

# Security Review Phase

## Purpose

Apply security review gates to a project at a defined point in the build cycle. Three depths to match risk level and time available:

- **`check` mode** (~30 seconds), quick configuration security check against known threats database. Verifies Claude Code setup for malicious skills/MCPs/hooks. Use frequently.
- **`audit` mode** (~2-5 minutes), comprehensive 6-phase security audit with scored posture assessment (0-100, grade A-F). Use periodically.
- **`full` mode** (~15-30 minutes), retroactive phase verification + comprehensive audit + threat-model alignment. Updates SECURITY.md. Use before major ships.

## When to recommend

Auto-detection should recommend secure-phase whenever:
- Plan-phase or execute-phase touched: auth, login, password, token, encryption, PII handling
- New MCP servers were installed
- New skills or agents were installed (should pair with malicious-skill scan from Caddy threat DB)
- Project is approaching production deploy
- Customer data handling enters scope
- Phase has documented threat model in PLAN.md (run `full` mode to verify mitigations)

## Modes

### Mode: check
**Time:** ~30 seconds. **Scope:** Claude Code configuration only.

Quick verification against known threats database. Checks: MCP servers vs CVE list, installed skills/agents vs malicious entries, hooks for exfiltration patterns, memory poisoning, permissions, exposed secrets in config.

Use as: routine check after installing new components.

### Mode: audit
**Time:** ~2-5 minutes. **Scope:** Full project + Claude Code config.

Comprehensive 6-phase audit with scored posture (0-100, grade A-F):
1. Configuration security (via check mode)
2. Project secrets scan (with anti-false-positive verification)
3. Prompt injection surface analysis
4. Dependency audit (npm/pip/cargo/go)
5. Hook security assessment
6. Posture score + remediation plan

Use as: periodic security review, before staging deploys.

### Mode: full
**Time:** ~15-30 minutes. **Scope:** Project + config + threat model alignment + SECURITY.md update.

Retroactive verification of threat mitigations for a completed phase. Three states:
- **State A:** SECURITY.md exists, audit and verify mitigations match what's deployed
- **State B:** No SECURITY.md but PLAN.md has threat model, reconstruct SECURITY.md from artifacts
- **State C:** Phase not executed, exit with guidance

Use as: pre-production gate, post-incident review, compliance audit.

## Phase template

### Goal
Verify the project meets security posture requirements appropriate to its risk level. Output: actionable remediation plan if gaps found, or signed-off SECURITY.md if clean.

### Scope (varies by mode)
- check: 7-phase config sweep, report pass/fail per check
- audit: 6 audit phases with scoring, grade, prioritized remediation
- full: audit + threat model alignment + SECURITY.md write/update

### Plans (suggested decomposition for `audit` mode)
- [ ] Plan 1: Establish audit context (production / staging / local dev)
- [ ] Plan 2: Run config security checks (Phase 1 of 6)
- [ ] Plan 3: Project secrets scan with anti-false-positive verification (Phase 2)
- [ ] Plan 4: Prompt injection surface analysis (Phase 3)
- [ ] Plan 5: Dependency vulnerability audit (Phase 4)
- [ ] Plan 6: Hook security assessment (Phase 5)
- [ ] Plan 7: Calculate posture score + grade + write report (Phase 6)
- [ ] Plan 8: Generate prioritized remediation plan

### Dependencies
- For `full` mode: completed phase with SUMMARY.md or PLAN.md threat model
- Threat database loaded (`examples/commands/resources/threat-db.yaml` equivalent in Caddy)

### Verification
- Posture score recorded (audit/full modes)
- Critical findings have remediation actions assigned
- SECURITY.md exists and is current (full mode)
- All scoring rubric outputs are reproducible (deterministic)

## Skills orchestrated

When Caddy v3 ships, secure-phase invokes:
- `/caddy:security --scan` (malicious skill scanner from Caddy threat DB)
- `/caddy:security --cve-check` (verify installed MCPs against CVE list)
- `/caddy:security --audit` (comprehensive audit)

## Source notes

**Three-source merge.** Each source contributed a distinct mode.

**GSD `secure-phase`**, RETROSPECTIVE phase verification. Three states (SECURITY.md exists / PLAN.md threat model exists / phase not executed). Output: updated SECURITY.md.
- → became `full` mode (the deepest depth)

**cc-ultimate-guide `security-check`**, QUICK ~30s config-only check against threat database. Phases: load threat DB, MCP audit, skills/agents audit, hooks security, memory poisoning, permissions, exposed secrets.
- → became `check` mode (the lightest depth)
- Anti-false-positive verification rule preserved (must run verification commands before reporting any secrets finding)

**cc-ultimate-guide `security-audit`**, COMPREHENSIVE ~2-5 min scored audit (100 points across 5 categories, grade A-F). Includes config security (subsumes /security-check), secrets scan, injection surface, dependencies, hook security.
- → became `audit` mode (the middle depth)
- Scoring rubric preserved exactly (categories + weights)

**Why merge into one phase type:** all three are "apply security review at this point in the build". The mode flag captures depth/scope/duration. Customer picks based on time and risk.

**Caddy-specific additions:**
- All modes integrate with Caddy's `/caddy:security` command which uses Caddy-curated threat DB
- Malicious-skill scanner runs as part of check mode (uses Caddy threat DB Stage 1+ snapshot)
- CVE checks reference Caddy's threat DB (which v4 keeps fresh via Security Intel pipeline)

## Anti-patterns

- DO NOT skip the audit-context question (production vs staging vs local). Local dev with `DEBUG=True` is normal; flagging it as a vulnerability creates false positives.
- DO NOT ship `audit` or `full` mode reports without the remediation plan. Findings without fixes are noise.
- DO NOT cherry-pick which phases to run. The scoring rubric depends on running all 6 audit phases.
- DO NOT lower the threshold for "anti-false-positive verification" of secrets findings. Pattern matching alone produces noise; verification commands prove or disprove.
- DO NOT use `check` mode as a replacement for `audit` mode. Check is fast but incomplete by design.
