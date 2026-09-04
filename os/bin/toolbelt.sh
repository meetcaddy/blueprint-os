#!/bin/sh
# The toolbelt on demand. Run by /blueprint toolbelt.
#   bash os/bin/toolbelt.sh list
#   bash os/bin/toolbelt.sh add <name> "<reason: the phase and design that calls for it>"
#   bash os/bin/toolbelt.sh remove <name>
# A tool is a skill kept in os/toolbelt/<name>/. "add" copies it into .claude/skills/<name>/
# and writes one line in BUSINESS.md under NOTES saying why. Nothing else changes.
set -u
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT" || exit 2
cmd="${1:-list}"; name="${2:-}"; reason="${3:-}"
case "$cmd" in
  list)
    echo "Tools in the belt (installed ones marked *):"
    for d in os/toolbelt/*/; do
      n=$(basename "$d"); mark=" "; [ -d ".claude/skills/$n" ] && mark="*"
      desc=$(sed -n 's/^description: *//p' "$d/SKILL.md" | head -1 | cut -c1-90)
      echo "  $mark $n: $desc"
    done
    ;;
  add)
    [ -n "$name" ] || { echo "which tool? run: bash os/bin/toolbelt.sh list"; exit 2; }
    [ -d "os/toolbelt/$name" ] || { echo "no tool named $name in the belt"; exit 2; }
    [ -n "$reason" ] || { echo "a tool is added only for a reason: give the phase and the design that calls for it"; exit 2; }
    if [ -d ".claude/skills/$name" ]; then echo "$name is already installed"; exit 0; fi
    mkdir -p .claude/skills && cp -R "os/toolbelt/$name" ".claude/skills/$name" || exit 1
    if [ -f BUSINESS.md ]; then
      printf '%s\n' "- Toolbelt: /$name added $(date +%Y-%m-%d). Reason: $reason" >> BUSINESS.md
    fi
    echo "OK    /$name is installed (.claude/skills/$name). Start a new session to use it."
    ;;
  remove)
    [ -n "$name" ] || { echo "which tool?"; exit 2; }
    [ -d ".claude/skills/$name" ] || { echo "$name is not installed"; exit 0; }
    [ -d "os/toolbelt/$name" ] || { echo "$name is not a toolbelt tool; leaving it alone"; exit 2; }
    rm -rf ".claude/skills/$name"
    [ -f BUSINESS.md ] && printf '%s\n' "- Toolbelt: /$name removed $(date +%Y-%m-%d)." >> BUSINESS.md
    echo "OK    /$name removed"
    ;;
  *) echo "usage: toolbelt.sh list | add <name> \"<reason>\" | remove <name>"; exit 2 ;;
esac
