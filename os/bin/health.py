#!/usr/bin/env python3
"""health.py: run the check in each SYSTEMS.md row and print one line per system. Run by /blueprint health.

    python3 os/bin/health.py

A row's "How to check it is healthy" cell may carry one check, written as
    check: `bash os/checks/<script> ...`   or   check: `bash connections/bin/<script> ...`
    or    check: `bash checks/<script> ...`   (the business's own folder; updates never touch it)
The script must live inside one of those three folders (links and ".." do not count). It runs
WITHOUT a shell, so nothing after a ";" or "|" or "$" in a row is ever interpreted. Each check gets
20 seconds and is stopped together with everything it started. Only its last line is shown. Exit 0
means running, 2 means it needs a person, anything else means broken.
"""
import os
import re
import shlex
import signal
import subprocess
import sys

ROOT = os.environ.get("CLAUDE_PROJECT_DIR") or os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
ALLOWED = ("os/checks", "connections/bin", "checks")
TIMEOUT = 20


def rows(text):
    for line in text.splitlines():
        line = line.rstrip()
        if not line.startswith("| ") or line.startswith("|---") or line.startswith("| What"):
            continue
        cells = [c.strip() for c in line.strip().strip("|").split("|")]
        if len(cells) < 6:
            yield cells[0] if cells else "", None
            continue
        yield cells[0], cells[4]


def check_of(cell):
    m = re.search(r"check:\s*`([^`]*)`", cell or "")
    return m.group(1).strip() if m else ""


def resolve(cmd):
    try:
        argv = shlex.split(cmd)
    except ValueError:
        return None, "its check could not be read"
    if len(argv) < 2 or argv[0] not in ("bash", "sh"):
        return None, "its check is not one your Caddy runs; open it by hand"
    script = argv[1]
    if os.path.isabs(script) or ".." in script.split("/"):
        return None, "its check is not in one of the three check folders; open it by hand"
    real = os.path.realpath(os.path.join(ROOT, script))
    allowed = any(real.startswith(os.path.realpath(os.path.join(ROOT, d)) + os.sep) for d in ALLOWED)
    if not allowed:
        return None, "its check is not in one of the three check folders; open it by hand"
    if not os.path.isfile(real):
        return None, "its check script is missing"
    return ["bash", real] + argv[2:], None


def run(argv):
    p = subprocess.Popen(argv, cwd=ROOT, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, start_new_session=True)
    try:
        out, _ = p.communicate(timeout=TIMEOUT)
    except subprocess.TimeoutExpired:
        try:
            os.killpg(p.pid, signal.SIGKILL)
        except Exception:
            pass
        p.communicate()
        return 142, ""
    text = out.decode("utf-8", errors="replace").strip()
    return p.returncode, (text.splitlines()[-1] if text else "")


def main():
    path = os.path.join(ROOT, "SYSTEMS.md")
    if not os.path.isfile(path):
        print("health: nothing built outside your Caddy yet (no SYSTEMS.md)")
        return 0
    with open(path, encoding="utf-8", errors="replace") as fh:
        text = fh.read()
    running = needs = broken = manual = total = 0
    for name, cell in rows(text):
        if not name or name == "[name]":
            continue
        total += 1
        if cell is None:
            manual += 1
            print("manual    %s: the row is missing its check column; open it by hand" % name)
            continue
        cmd = check_of(cell)
        if not cmd:
            manual += 1
            print("manual    %s: %s" % (name, cell))
            continue
        argv, why = resolve(cmd)
        if argv is None:
            manual += 1
            print("manual    %s: %s" % (name, why))
            continue
        rc, last = run(argv)
        if rc == 0:
            running += 1
            print("running   %s: %s" % (name, last or "ok"))
        elif rc == 2:
            needs += 1
            print("needs you %s: %s" % (name, last or "a card is still open"))
        elif rc == 142:
            broken += 1
            print("broken    %s: the check took more than %d seconds" % (name, TIMEOUT))
        else:
            broken += 1
            print("broken    %s: %s" % (name, last or "the check failed"))
    print("health: %d system(s): %d running, %d need you, %d broken, %d manual" % (total, running, needs, broken, manual))
    return 0 if broken == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
