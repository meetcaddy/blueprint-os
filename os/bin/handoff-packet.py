#!/usr/bin/env python3
"""handoff-packet.py: assemble everything the Caddy team would need to take a phase over, in one file.

    python3 os/bin/handoff-packet.py        writes HANDOFF-PACKET.md in this folder

It gathers the business memory, the Blueprint, the standing orders, the access map, the systems
ledger, the waiting list, the design records, the amendments, the plan state and what was learned
from the drop folder. It never includes .env, any key file or any raw dropped file, and any line
that looks like a key is left out with a note. Nothing is sent; the owner forwards the file or not.
"""
import datetime
import os
import re
import sys

ROOT = os.environ.get("CLAUDE_PROJECT_DIR") or os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
OUT = os.path.join(ROOT, "HANDOFF-PACKET.md")
PARTS = [
    ("BUSINESS.md", "The business memory"),
    ("BLUEPRINT.md", "The Blueprint"),
    ("BLUEPRINT-DIRECTIVES.md", "The standing orders"),
    ("ACCESS-MAP.md", "Who grants what"),
    ("SYSTEMS.md", "Everything built or touched outside the machine"),
    ("WAITING-ON-YOU.md", "Waiting on a person"),
    ("amendments.md", "Ideas folded in after the session"),
    (".paul/STATE.md", "The plan state"),
]
KEY_LIKE = [
    re.compile(r"-----BEGIN [A-Z ]*PRIVATE KEY-----"),
    re.compile(r"\b(sk|rk)-[A-Za-z0-9_-]{20,}"),
    re.compile(r"\bAKIA[0-9A-Z]{16}\b"),
    re.compile(r"\bxox[abprs]-[A-Za-z0-9-]{10,}"),
    re.compile(r"\bgh[pousr]_[A-Za-z0-9]{30,}"),
    re.compile(r"(?i)\b(api[_ -]?key|secret|password|passwd|token)\b\s*[:=]\s*\S{8,}"),
]


def clean(text):
    out = []
    left_out = 0
    for line in text.split("\n"):
        if any(p.search(line) for p in KEY_LIKE):
            out.append("[a line that looked like a key was left out]")
            left_out += 1
        else:
            out.append(line)
    return "\n".join(out), left_out


def read(rel):
    p = os.path.join(ROOT, rel)
    try:
        with open(p, encoding="utf-8", errors="replace") as fh:
            return fh.read()
    except OSError:
        return None


def learned_block():
    s = read(os.path.join("context", "INDEX.md"))
    if not s or "<!-- learned:start -->" not in s:
        return None
    return s.split("<!-- learned:start -->", 1)[1].split("<!-- learned:end -->", 1)[0].strip("\n")


def main():
    today = datetime.date.today().isoformat()
    chunks = ["# Hand-over packet", "",
              "> Assembled by your Caddy on %s at the owner's request. Everything the Caddy team would need to take a phase over, in one file. It holds no keys, no passwords and none of the raw files from the drop folder. The owner sends it, or not." % today,
              ""]
    total_left_out = 0
    for rel, title in PARTS:
        s = read(rel)
        if s is None:
            continue
        s, n = clean(s)
        total_left_out += n
        chunks += ["", "---", "", "# %s (`%s`)" % (title, rel), "", s.strip("\n"), ""]
    design_dir = os.path.join(ROOT, "design")
    if os.path.isdir(design_dir):
        for fn in sorted(os.listdir(design_dir)):
            if fn.endswith(".md"):
                s = read(os.path.join("design", fn))
                if s is None:
                    continue
                s, n = clean(s)
                total_left_out += n
                chunks += ["", "---", "", "# Design record (`design/%s`)" % fn, "", s.strip("\n"), ""]
    lb = learned_block()
    if lb:
        lb, n = clean(lb)
        total_left_out += n
        chunks += ["", "---", "", "# What was learned from the drop folder (`context/INDEX.md`)", "", lb, ""]
    if total_left_out:
        chunks += ["", "(%d line(s) that looked like a key were left out.)" % total_left_out]
    with open(OUT, "w", encoding="utf-8") as fh:
        fh.write("\n".join(chunks).rstrip("\n") + "\n")
    print("HANDOFF-PACKET.md written (%d part(s); nothing sent)" % sum(1 for rel, _ in PARTS if read(rel) is not None))
    return 0


if __name__ == "__main__":
    sys.exit(main())
