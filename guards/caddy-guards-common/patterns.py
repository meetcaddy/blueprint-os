#!/usr/bin/env python3
"""
caddy-guards-common — shared pattern library for the Caddy governance guards.
Single source of truth for the catastrophe + secret regexes used by caddy-safety-guard (PreToolUse)
and caddy-permission-guard (PermissionRequest). Tune a pattern HERE and both guards pick it up.

Imported via a sibling-dir path insert, e.g.:
    sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "caddy-guards-common"))
    from patterns import BLOCK_BASH, SECRET_PATH, SECRET_IN_CONTENT, SECRET_READ_BASH, is_catastrophe
(works in source admin/tools/ and in the ~/.claude/skills/ install — both keep these dirs as siblings.)
"""
import re

# --- BLOCK: unambiguous catastrophe bash (almost never legitimate). (reason, compiled) ---
BLOCK_BASH = [
    ("rm -rf on a root/home/glob target", re.compile(r"\brm\s+-[a-z]*r[a-z]*f[a-z]*\s+(-{2}no-preserve-root\s+)?(/(\s|$)|/\*|~(/|\s|$)|\$HOME|\.\s*$)")),
    ("sudo rm -rf", re.compile(r"\bsudo\s+rm\s+-[a-z]*r")),
    ("pipe-to-shell remote code execution", re.compile(r"(?i)(curl|wget)\b[^\n|]*\|\s*(sudo\s+)?(ba|z)?sh\b")),
    ("base64-decode piped to shell", re.compile(r"(?i)base64\s+-d[^\n|]*\|\s*(ba)?sh")),
    ("fork bomb", re.compile(r":\(\)\s*\{\s*:\s*\|\s*:")),
    ("disk overwrite (dd to device)", re.compile(r"\bdd\b[^\n]*\bof=/dev/")),
    ("filesystem format", re.compile(r"\bmkfs(\.[a-z0-9]+)?\b")),
    ("redirect into a block device", re.compile(r">\s*/dev/(sd|nvme|disk)")),
    ("secret file piped to network (exfil)", re.compile(r"(?i)(\.env|\.pem|id_rsa|credentials|caddy\.env|\.aws/)[^\n|]*\|\s*(curl|wget|nc)\b|(curl|wget)\b[^\n]*(-d\s*@|--data[^\n]*@)\s*[^\n]*(\.env|credentials|\.pem|id_rsa)")),
]


def is_catastrophe(cmd):
    """True if a bash command matches any catastrophe pattern."""
    return any(pat.search(cmd or "") for _, pat in BLOCK_BASH)


# --- SECRET surfaces ---
SECRET_IN_CONTENT = re.compile(
    r"\bsk-[A-Za-z0-9_\-]{20,}|\b(ghp|gho|ghu|ghs|github_pat)_[A-Za-z0-9_]{20,}|\bAKIA[0-9A-Z]{16}\b|"
    r"\bpit-[A-Za-z0-9\-]{16,}|\bxox[baprs]-[A-Za-z0-9\-]{10,}|-----BEGIN [A-Z ]*PRIVATE KEY-----")
SECRET_PATH = re.compile(r"(?i)(\.env(\.|$)|\.pem$|id_rsa|/credentials$|\.aws/credentials|caddy\.env|\.pgpass|\.netrc|\.ssh/)")
SECRET_READ_BASH = re.compile(r"(?i)\b(cat|less|more|head|tail|bat)\b[^\n]*(\.env\b|\.pem\b|id_rsa\b|/credentials\b|caddy\.env|\.pgpass|\.netrc)")
