#!/bin/sh
# Session start: put the machine's memory in front of it before the first word.
# Reads only files that exist. Prints nothing when the Blueprint is not built yet. The only
# network call is the once-a-day version check (one public file, a 4-second cap, silent offline).
set -u
ROOT="${CLAUDE_PROJECT_DIR:-.}"
cd "$ROOT" 2>/dev/null || exit 0

show() {
  # $1 = path, $2 = label
  [ -f "$1" ] || return 0
  printf '\n===== %s (%s) =====\n' "$2" "$1"
  cat "$1"
}

show "BUSINESS.md" "Your memory of the business"
show "BLUEPRINT-DIRECTIVES.md" "Your standing orders"

# The active phase's design record: the lowest-numbered record whose Status line is not "done".
if [ -d design ]; then
  for f in $(ls design/phase-*.md 2>/dev/null | sort -V); do
    status=$(sed -n 's/^\*\*Status:\*\* *//p' "$f" | head -1)
    case "$status" in
      done*) continue ;;
      *) show "$f" "The active phase's design record"; break ;;
    esac
  done
fi

if [ -f .paul/STATE.md ]; then
  printf '\n===== The plan state (.paul/STATE.md, first 60 lines) =====\n'
  head -60 .paul/STATE.md
fi

if [ -f ACCESS-MAP.md ] || [ -f SYSTEMS.md ]; then
  printf '\n(ACCESS-MAP.md and SYSTEMS.md: read them before any card or any connection.)\n'
fi

# The Monday brief: the first time the folder opens in a week, once BUSINESS.md exists.
if [ -f os/bin/brief.sh ] && sh os/bin/brief.sh --due 2>/dev/null; then
  sh os/bin/brief.sh --stamp 2>/dev/null
  printf '\n'
  sh os/bin/brief.sh 2>/dev/null
  printf '(Say this brief to the owner first, in their words, before anything else.)\n'
elif [ -f WAITING-ON-YOU.md ]; then
  show "WAITING-ON-YOU.md" "Waiting on a person"
fi

# The once-a-day version check: one line when a newer build exists, otherwise nothing.
if [ -f os/bin/version-check.sh ]; then
  line=$(sh os/bin/version-check.sh 2>/dev/null)
  [ -n "$line" ] && printf '\n%s\n(Tell the owner in one line; pull only if they say yes.)\n' "$line"
fi
exit 0
