#!/usr/bin/env python3
"""quiet-base-hook.py: point the memory engine's session-start entry at the quiet wrapper.

    python3 os/bin/quiet-base-hook.py <settings.json> <wrapper path>

Rewrites every SessionStart hook command that ends in "base hook session-start" to run the wrapper
instead (sh "<wrapper path>"). Idempotent: a settings file already pointing at the wrapper is left
alone. Prints one line: rewired, already quiet, or nothing to do.
"""
import json
import sys


def main(argv):
    if len(argv) < 2:
        print("usage: quiet-base-hook.py <settings.json> <wrapper path>")
        return 2
    path, wrapper = argv[0], argv[1]
    try:
        with open(path, encoding="utf-8") as fh:
            settings = json.load(fh)
    except (OSError, ValueError):
        print("nothing to do (no settings file)")
        return 0
    groups = (settings.get("hooks") or {}).get("SessionStart") or []
    changed = 0
    quiet = 0
    for g in groups:
        for h in g.get("hooks", []):
            cmd = (h.get("command") or "").strip()
            if cmd.endswith("base hook session-start"):
                h["command"] = 'sh "%s"' % wrapper
                changed += 1
            elif wrapper in cmd:
                quiet += 1
    if changed:
        with open(path, "w", encoding="utf-8") as fh:
            json.dump(settings, fh, indent=2)
            fh.write("\n")
        print("rewired %d session-start entr%s to the quiet wrapper" % (changed, "y" if changed == 1 else "ies"))
    elif quiet:
        print("already quiet")
    else:
        print("nothing to do (no engine session-start entry)")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
