#!/usr/bin/env python3
"""Checks for os/tests/test-settings.sh. Exit 0 when every command the skills run has an allow rule."""
import glob
import json
import re
import sys

d = json.load(open(".claude/settings.json"))
rules = d.get("permissions", {}).get("allow", [])
prefixes = [r[len("Bash("):-len(":*)")] for r in rules if r.startswith("Bash(") and r.endswith(":*)")]
exact = [r[len("Bash("):-1] for r in rules if r.startswith("Bash(") and not r.endswith(":*)")]
tick = chr(96)
pat = re.compile(tick + r"((?:python3|bash|sh) (?:os/bin|os/checks|setup|connections/bin|checks)/[A-Za-z0-9_./-]+)")
cmds = {"base --version"}
for f in glob.glob(".claude/skills/*/SKILL.md"):
    for m in pat.finditer(open(f, encoding="utf-8").read()):
        cmds.add(m.group(1))
missing = [c for c in sorted(cmds) if not (c in exact or any(c.startswith(p) for p in prefixes))]
okp = ("Bash(python3 os/bin/", "Bash(bash os/bin/", "Bash(sh os/bin/", "Bash(bash setup/", "Bash(bash os/checks/",
       "Bash(bash connections/bin/", "Bash(bash checks/", "Bash(base --version)", "Bash(git status", "Bash(git log",
       "Bash(git diff", "Bash(git add", "Bash(git commit", "Bash(git tag")
broad = [r for r in rules if not r.startswith(okp)]
if missing:
    print("missing allow rules for: " + ", ".join(missing))
if broad:
    print("rules broader than the OS folders or a git save command: " + ", ".join(broad))
print("%d commands checked, %d rules" % (len(cmds), len(rules)))
sys.exit(1 if (missing or broad) else 0)
