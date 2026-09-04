#!/usr/bin/env python3
"""
caddy-permission-guard, a PermissionRequest hook that applies a RISK PROFILE to permission prompts:
auto-approve the safe stuff, auto-deny catastrophes, and ask on everything else, logging every
decision so the profile can be graduated on evidence.

A3 step 2 of the governance pillar. Companion to caddy-safety-guard (blocks dangerous CALLS) and
caddy-config-guard (blocks guardrail-weakening CONFIG changes).

Profiles are NESTED (each is a superset of the one before):
  conservative, auto-approve only safe read-only ops; ask on everything else.
  standard    , conservative + safe writes/edits in-project + routine git; ask on installs/network/etc.
  trusted     , auto-approve everything EXCEPT the two hard floors below.

HARD FLOORS (apply at EVERY profile, including trusted, never auto-approved):
  - catastrophe ops (rm -rf root/glob, curl|bash, fork bomb, dd to device, …) -> DENY
  - anything touching secrets (read/write .env/.pem/id_rsa/credentials, secret in content) -> ASK

Modes (env CADDY_PERMGUARD_MODE > config.json "mode" > "advisory"):
  advisory, LOG the decision it WOULD make; do NOT act (normal prompt still shows). DEFAULT.
  active  , actually emit allow/deny; "ask" falls through to the normal prompt.

Graduation: `guard.py status` summarizes the decision log + reports readiness to move up a profile.
Flipping the profile is a deliberate edit to config.json by the owner, never automatic.

Read-only decisioning. Fail-open (any error -> ask/allow-through, exit 0). Logs to
~/.caddy/permission-guard.log.
"""
import sys, os, re, json, datetime
from collections import Counter

LOG = os.path.expanduser("~/.caddy/permission-guard.log")
PROFILES = ["conservative", "standard", "trusted"]

# --- hard floors (every profile): shared patterns from caddy-guards-common ---
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "caddy-guards-common"))
from patterns import is_catastrophe, SECRET_PATH, SECRET_IN_CONTENT, SECRET_READ_BASH
from lib import resolve_mode_profile as _resolve_cfg, log_line as _log_line  # shared mode/logging

# --- profile allowlists ---
SAFE_READ_TOOLS = {"Read", "Grep", "Glob", "NotebookRead"}
SAFE_READ_BASH = re.compile(r"^\s*(ls|pwd|whoami|which|echo|cat|head|tail|wc|rg|grep|find|tree|date|env|printenv|"
                            r"git\s+(status|diff|log|show|branch|remote|rev-parse|config\s+--get)|"
                            r"node\s+--version|npm\s+(ls|test|run\s+test)|python3?\s+--version|pip\s+list)\b")
WRITE_TOOLS = {"Write", "Edit", "MultiEdit", "NotebookEdit"}
ROUTINE_GIT = re.compile(r"^\s*git\s+(add|commit|diff|log|status|stash|fetch|pull|push(\s+[^\n]*--force-with-lease)?|"
                         r"checkout|switch|branch|merge\s--ff-only|restore)\b")
INSTALL_NETWORK = re.compile(r"(?i)\b(npm|pnpm|yarn|pip|pip3|brew|apt|gem|cargo|go)\s+(install|add|i)\b|"
                             r"\b(curl|wget|nc|ssh|scp|rsync)\b")


def _bash(ti):
    return (ti or {}).get("command", "") or ""


def hard_floor(tool_name, ti):
    """Returns (behavior, reason) if a hard floor applies, else None."""
    cmd = _bash(ti)
    if tool_name == "Bash" and is_catastrophe(cmd):
        return ("deny", "hard floor: catastrophe command")
    if tool_name == "Bash" and SECRET_READ_BASH.search(cmd):
        return ("ask", "hard floor: reads a secret/key file")
    if tool_name in WRITE_TOOLS:
        path = (ti or {}).get("file_path", "") or (ti or {}).get("notebook_path", "") or ""
        blob = " ".join(str((ti or {}).get(k, "")) for k in ("content", "new_string", "new_source"))
        if SECRET_PATH.search(path) or SECRET_IN_CONTENT.search(blob):
            return ("ask", "hard floor: writes a secret / sensitive path")
    if tool_name == "Read" and SECRET_PATH.search((ti or {}).get("file_path", "") or ""):
        return ("ask", "hard floor: reads a secret/key file")
    return None


def classify(tool_name, tool_input, profile):
    """Pure decision core. Returns (behavior, reason). behavior in {allow, deny, ask}."""
    profile = profile if profile in PROFILES else "standard"
    floor = hard_floor(tool_name, tool_input)
    if floor:
        return floor
    cmd = _bash(tool_name == "Bash" and tool_input or {})
    # conservative: safe read-only
    if tool_name in SAFE_READ_TOOLS:
        return ("allow", f"{profile}: safe read-only tool")
    if tool_name == "Bash" and SAFE_READ_BASH.search(cmd):
        return ("allow", f"{profile}: safe read-only command")
    if profile == "conservative":
        return ("ask", "conservative: not in safe-read allowlist")
    # standard: + writes/edits + routine git (hard floors already excluded secrets)
    if tool_name in WRITE_TOOLS:
        return ("allow", f"{profile}: in-project write/edit")
    if tool_name == "Bash" and ROUTINE_GIT.search(cmd):
        return ("allow", f"{profile}: routine git")
    if profile == "standard":
        if tool_name == "Bash" and INSTALL_NETWORK.search(cmd):
            return ("ask", "standard: install/network needs confirmation")
        return ("ask", "standard: not in allowlist")
    # trusted: everything except the hard floors above
    return ("allow", "trusted: auto-approved (non-floor)")


def resolve_cfg():
    return _resolve_cfg(__file__, "CADDY_PERMGUARD_MODE", "CADDY_PERMGUARD_PROFILE", "advisory", "standard")


def log(mode, profile, behavior, tool_name, reason):
    _log_line(LOG, mode, profile, behavior, tool_name, reason)


def status():
    if not os.path.exists(LOG):
        print("No decisions logged yet."); return
    rows = [l.rstrip("\n").split("\t") for l in open(LOG) if l.strip()]
    beh = Counter(r[3] for r in rows if len(r) > 3)
    prof = Counter(r[2] for r in rows if len(r) > 2)
    floor_denies = sum(1 for r in rows if len(r) > 5 and "hard floor" in r[5])
    print(f"caddy-permission-guard, {len(rows)} decisions logged")
    print("  by behavior:", dict(beh))
    print("  by profile :", dict(prof))
    print(f"  hard-floor hits: {floor_denies}")
    auto = beh.get("allow", 0)
    cur = max(prof, key=prof.get) if prof else "standard"
    nxt = {"conservative": "standard", "standard": "trusted"}.get(cur)
    if nxt and auto >= 100:
        print(f"  READINESS: {auto} auto-approvals on '{cur}'. If the log looks clean, consider graduating to '{nxt}' "
              f"(edit config.json profile, then re-run caddy-config-guard baseline). Graduation is YOUR call.")
    elif nxt:
        print(f"  READINESS: {auto}/100 auto-approvals on '{cur}' before suggesting graduation to '{nxt}'.")
    else:
        print("  READINESS: already at 'trusted' (top profile).")


def main():
    if len(sys.argv) > 1 and sys.argv[1] == "status":
        status(); return
    try:
        event = json.load(sys.stdin)
    except Exception:
        sys.exit(0)  # fail-open
    tool_name = event.get("tool_name") or event.get("tool") or ""
    tool_input = event.get("tool_input") or event.get("input") or {}
    mode, profile = resolve_cfg()
    try:
        behavior, reason = classify(tool_name, tool_input, profile)
    except Exception:
        sys.exit(0)  # fail-open
    log(mode, profile, behavior, tool_name, reason)
    if mode != "active" or behavior == "ask":
        sys.exit(0)  # advisory, or "ask" -> let the normal permission prompt happen
    print(json.dumps({"hookSpecificOutput": {"hookEventName": "PermissionRequest",
                                             "decision": {"behavior": behavior}},
                      "systemMessage": f"caddy-permission-guard [{profile}] auto-{behavior}: {reason}"}))
    sys.exit(0)


if __name__ == "__main__":
    main()
