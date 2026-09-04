# caddy-safety-guard: PreToolUse detect-and-prevent

The **prevent** half of the governance pillar. `caddy-agent-audit` scans config *after the fact*;
this hook inspects each tool call *before it runs* and can stop the dangerous ones.

Companion to [caddy-agent-audit](../caddy-agent-audit/). Wave A2 of the digest-batch ATTACK-LIST.

## What it catches
- **BLOCK set** (unambiguous catastrophes, `block` mode denies these): `rm -rf` on `/`/`~`/`$HOME`/glob,
  `sudo rm -rf`, pipe-to-shell (`curl|bash`), base64-decode|sh, fork bombs, `dd of=/dev/…`, `mkfs`,
  redirect into a block device, and secret-file → network exfil (`cat .env | curl …`).
- **WARN set** (risky but often legitimate, always surfaced, never blocked): non-root `rm -rf`, force
  push (but NOT `--force-with-lease`), `git reset --hard`, `git clean -fdx`, `chmod 777`, `--no-verify`,
  destructive SQL, reading a secret/key file (`cat .env`/`.pem`/`id_rsa`/`credentials`…).
- **Write/Edit:** writing a secret pattern into a file, or writing to a sensitive path (`.env`, `.pem`,
  `.ssh/`, …) → warn.
- **Read:** reading a secret/key file → warn (exfil risk if the context is shared).

## Modes (the safety staging)
Resolve order: env `CADDY_GUARD_MODE` > `config.json` `"mode"` > `"warn"`.
- **`warn`** (default), never blocks. Emits a `systemMessage` and logs to `~/.caddy/safety-guard.log`.
  Run here first to confirm zero false positives on real work.
- **`block`:** denies the BLOCK set; still only warns on the rest.

It is **read-only** (never executes anything) and **fail-open** (any parse/internal error → allow, so a
bug in the guard can never wedge the operator).

## Test
```bash
python3 admin/tools/caddy-safety-guard/test_guard.py   # 25 classify cases + 3 contract checks
```

## Wiring it live (already done by the template in .claude/settings.json)
Installing this is a standing-config change, so it is applied only on explicit approval. Add to
`~/.claude/settings.json` (MERGE into any existing `hooks.PreToolUse`, do not overwrite):
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash|Write|Edit|MultiEdit|NotebookEdit|Read",
        "hooks": [
          { "type": "command", "command": "python3 ~/.claude/skills/caddy-safety-guard/guard.py" }
        ]
      }
    ]
  }
}
```
Then start in `warn` mode, work normally for a few sessions, review `~/.caddy/safety-guard.log`, and only
flip `config.json` to `"block"` once the log shows no false positives.

## Roadmap
- Self-install safety bundle (ship with the Caddy plugin, warn-default).
- **ACE Security Hardening Pack**: deploy admin-level on a client's plan (block-mode for their catastrophe
  set), with `caddy-agent-audit` as the verify step. (ATTACK-LIST Wave C.)
- Tune the WARN/BLOCK sets from real `safety-guard.log` data.

*v0.1, 2026-06-07.*
