#!/usr/bin/env bash
# Runs the check written in each SYSTEMS.md row and prints one line per system. Run by /blueprint health.
#   bash os/bin/health.sh
# A row's "How to check it is healthy" cell may carry a check your Caddy can run, written as
#   check: `bash os/checks/<script> ...`    or    check: `bash connections/bin/<script> ...`
# Only those two folders are ever run; anything else in a cell is reported as manual, never run.
# Each check gets 20 seconds. Exit 0 running, 2 needs you, anything else broken. The shipped checks
# print a status and never a value; this script shows nothing but their one line.
set -u
ROOT="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
cd "$ROOT" || exit 2
[[ -f SYSTEMS.md ]] || { echo "health: nothing built outside your Caddy yet (no SYSTEMS.md)"; exit 0; }
running=0; needs=0; broken=0; manual=0; rows=0
trim() { sed 's/^[[:space:]]*//; s/[[:space:]]*$//'; }
while IFS= read -r line || [[ -n "$line" ]]; do
  [[ "$line" == "| "* ]] || continue
  [[ "$line" == "|---"* || "$line" == "| What"* ]] && continue
  name=$(printf '%s' "$line" | awk -F'|' '{print $2}' | trim)
  cell=$(printf '%s' "$line" | awk -F'|' '{print $6}' | trim)
  [[ -z "$name" || "$name" == "[name]" ]] && continue
  rows=$((rows+1))
  cmd=$(printf '%s' "$cell" | sed -n 's/.*check: *`\([^`]*\)`.*/\1/p')
  if [[ -z "$cmd" ]]; then manual=$((manual+1)); echo "manual    $name: $cell"; continue; fi
  case "$cmd" in
    "bash os/checks/"*|"bash connections/bin/"*) ;;
    *) manual=$((manual+1)); echo "manual    $name: its check is not one your Caddy runs; open it by hand"; continue ;;
  esac
  out=$(perl -e 'alarm shift; exec @ARGV' 20 bash -c "$cmd" 2>&1); rc=$?
  last=$(printf '%s\n' "$out" | tail -1)
  if [[ $rc -eq 0 ]]; then running=$((running+1)); echo "running   $name: ${last:-ok}"
  elif [[ $rc -eq 2 ]]; then needs=$((needs+1)); echo "needs you $name: ${last:-a card is still open}"
  elif [[ $rc -eq 142 ]]; then broken=$((broken+1)); echo "broken    $name: the check took more than 20 seconds"
  else broken=$((broken+1)); echo "broken    $name: ${last:-the check failed}"; fi
done < SYSTEMS.md
echo "health: $rows system(s): $running running, $needs need you, $broken broken, $manual manual"
[[ $broken -eq 0 ]]
