#!/usr/bin/env python3
"""
caddy-safety-guard, a PreToolUse hook that DETECTS and (optionally) PREVENTS dangerous tool calls
BEFORE they execute: destructive bash, secret exfiltration, and secret/key-file reads.

The detect-and-prevent companion to caddy-agent-audit (which only scans config after the fact).

Modes (resolve order: env CADDY_GUARD_MODE > config.json "mode" > "warn"):
  warn:   never blocks; emits a systemMessage warning + logs. (DEFAULT: tune false positives first.)
  block:  denies the unambiguous-catastrophe set ("block" severity); still only warns on the rest.

Design rules:
  - READ-ONLY decisioning. It inspects the proposed tool call; it never runs anything itself.
  - FAIL-OPEN. Any parse/internal error → allow (exit 0). A safety hook must never wedge the operator.
  - Tight BLOCK set (only things that are almost never legitimate); broad WARN set for review.

PreToolUse contract: reads a JSON event on stdin (tool_name, tool_input, ...). To deny, prints
{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":...}}.
To warn without blocking, prints {"systemMessage": "..."} and exits 0 (normal permission flow proceeds).
"""
import sys, os, re, json, datetime
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "caddy-guards-common"))
from patterns import BLOCK_BASH, SECRET_IN_CONTENT, SECRET_PATH  # shared catastrophe/secret patterns
from lib import resolve_mode as _resolve_mode, log_line as _log_line  # shared mode/logging

LOG = os.path.expanduser("~/.caddy/safety-guard.log")
SENSITIVE_PATH = SECRET_PATH  # local alias so classify() references read unchanged

# BLOCK_BASH (catastrophe set) imported from caddy-guards-common/patterns.py.
# --- WARN: risky-but-often-legitimate (surface for review, never block) -------------------------
WARN_BASH = [
    ("rm -rf (non-root target)", re.compile(r"\brm\s+-[a-z]*r[a-z]*f")),
    ("force push", re.compile(r"\bgit\s+push\b[^\n]*(--force(?!-with-lease)|\s-f(\s|$))")),
    ("hard reset", re.compile(r"\bgit\s+reset\s+--hard")),
    ("git clean -fdx", re.compile(r"\bgit\s+clean\s+-[a-z]*f[a-z]*d")),
    ("chmod 777", re.compile(r"\bchmod\s+-?R?\s*777")),
    ("git history-skip flag", re.compile(r"--no-verify|core\.hooksPath")),
    ("destructive SQL", re.compile(r"(?i)\b(drop\s+(database|table)|truncate\s+table|delete\s+from)\b")),
    ("reads a secret/key file", re.compile(r"(?i)\b(cat|less|more|head|tail|bat)\b[^\n]*(\.env\b|\.pem\b|id_rsa\b|/credentials\b|\.aws/credentials|caddy\.env|\.pgpass|\.netrc)")),
]
# SECRET_IN_CONTENT + SECRET_PATH imported from caddy-guards-common/patterns.py (SENSITIVE_PATH alias above).


def classify(tool_name, tool_input):
    """Pure decision core. Returns (action, severity, reason). action ∈ {allow, warn, block}."""
    ti = tool_input or {}
    if tool_name == "Bash":
        cmd = ti.get("command", "") or ""
        for reason, pat in BLOCK_BASH:
            if pat.search(cmd):
                return ("block", "CRITICAL", f"destructive/exfil bash: {reason}")
        for reason, pat in WARN_BASH:
            if pat.search(cmd):
                return ("warn", "HIGH", f"risky bash: {reason}")
        return ("allow", None, None)
    if tool_name in ("Write", "Edit", "MultiEdit", "NotebookEdit"):
        path = ti.get("file_path", "") or ti.get("notebook_path", "") or ""
        blob = " ".join(str(ti.get(k, "")) for k in ("content", "new_string", "new_source"))
        if SECRET_IN_CONTENT.search(blob):
            return ("warn", "HIGH", "writing a secret into a file, keep it gitignored + chmod 600, never commit")
        if SENSITIVE_PATH.search(path):
            return ("warn", "MEDIUM", f"writing to a sensitive path ({path})")
        return ("allow", None, None)
    if tool_name == "Read":
        path = ti.get("file_path", "") or ""
        if SENSITIVE_PATH.search(path):
            return ("warn", "MEDIUM", f"reading a secret/key file ({path}), exfil risk if this context is shared")
        return ("allow", None, None)
    return ("allow", None, None)


def resolve_mode():
    return _resolve_mode(__file__, "CADDY_GUARD_MODE", "warn")


def log(action, severity, reason, tool_name, mode):
    _log_line(LOG, mode, action, severity, tool_name, reason)


def main():
    try:
        event = json.load(sys.stdin)
    except Exception:
        sys.exit(0)  # fail-open
    tool_name = event.get("tool_name", "")
    tool_input = event.get("tool_input", {})
    try:
        action, severity, reason = classify(tool_name, tool_input)
    except Exception:
        sys.exit(0)  # fail-open
    if action == "allow":
        sys.exit(0)
    mode = resolve_mode()
    log(action, severity, reason, tool_name, mode)
    if action == "block" and mode == "block":
        print(json.dumps({"hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": "deny",
            "permissionDecisionReason": f"caddy-safety-guard blocked this: {reason}. (Override: set CADDY_GUARD_MODE=warn.)"
        }}))
        sys.exit(0)
    # warn (or block-severity while still in warn mode): surface, do not block
    label = "WOULD BLOCK" if action == "block" else "warning"
    print(json.dumps({"systemMessage": f"⚠️ caddy-safety-guard ({mode} mode) {label}: {reason}"}))
    sys.exit(0)


if __name__ == "__main__":
    main()
