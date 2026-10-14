#!/bin/sh
# The Monday brief: where we are, what runs on its own, what waits on you. Read-only, no network.
# The session hook prints it the first time the folder opens in a week.
#   sh os/bin/brief.sh          print the brief (only once BUSINESS.md exists)
#   sh os/bin/brief.sh --due    exit 0 when a brief is due this week, 1 when not; changes nothing
#   sh os/bin/brief.sh --stamp  record that the brief was shown this week
set -u
ROOT="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/../.." && pwd)}"
cd "$ROOT" 2>/dev/null || exit 0
week=$(date +%G-W%V)
STAMP=.blueprint/last-brief
case "${1:-}" in
  --due)   [ -f BUSINESS.md ] || exit 1; [ "$(cat "$STAMP" 2>/dev/null)" = "$week" ] && exit 1; exit 0 ;;
  --stamp) mkdir -p .blueprint; printf '%s\n' "$week" > "$STAMP"; exit 0 ;;
esac
[ -f BUSINESS.md ] || exit 0
echo "===== Your week, in one look ($(date +%Y-%m-%d)) ====="
[ -f os/bin/state-summary.sh ] && sh os/bin/state-summary.sh 2>/dev/null | grep -E '^(Stage|Phase|Plan): ' | sed 's/^Stage: /Where we are: /'
if [ -f SYSTEMS.md ]; then
  n=$(awk -F'|' '/^\| / && $2 !~ /^ *What *$/ && $0 !~ /\[name\]/ && $0 !~ /^\|-/ {c++} END {print c+0}' SYSTEMS.md)
  [ "$n" -gt 0 ] && echo "Running on its own: $n thing(s) (the list is in SYSTEMS.md)"
fi
if [ -f WAITING-ON-YOU.md ]; then
  rows=$(grep -E '^\| [0-9]{4}-[0-9]{2}-[0-9]{2} ' WAITING-ON-YOU.md)
  if [ -n "$rows" ]; then
    echo "Waiting on you:"
    printf '%s\n' "$rows" | awk -F'|' '{gsub(/^ +| +$/, "", $2); gsub(/^ +| +$/, "", $3); gsub(/^ +| +$/, "", $4); printf "  - since %s, %s: %s\n", $2, $3, $4}'
  else
    echo "Waiting on you: nothing."
  fi
fi
[ -f os/bin/context-index.py ] && python3 os/bin/context-index.py --summary 2>/dev/null | sed 's/^context: /Drop folder: /'
echo "Type /blueprint status for the full picture."
exit 0
