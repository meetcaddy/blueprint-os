#!/usr/bin/env bash
# Step back to a saved point without losing anything. Run by /blueprint undo.
#   bash os/bin/undo.sh list            the last ten saved points, newest first, numbered
#   bash os/bin/undo.sh to <n>          go back to point <n> from that list (1 is the newest)
#   bash os/bin/undo.sh to <name>       go back to a named point (an update's step-back tag)
# Nothing is deleted: what you have right now is saved first, then a NEW saved point is made that
# matches the chosen one, so a step back can itself be stepped back. Files git does not keep (.env,
# the raw files in the drop folder) are never touched.
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT" || exit 2
say() { echo "$1"; }
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { say "FAIL  this folder is not a saved workspace, so there is nothing to step back to"; exit 2; }
git rev-parse --verify -q HEAD >/dev/null 2>&1 || { say "FAIL  there are no saved points yet"; exit 2; }
if [[ -f .git/MERGE_HEAD || -d .git/rebase-merge || -d .git/rebase-apply ]]; then
  say "FAIL  a merge is half done in this folder; the Caddy team should look (support@meetcaddy.com)"; exit 2
fi
cmd="${1:-list}"
case "$cmd" in
  list)
    say "Saved points, newest first:"
    git log -10 --format='%h|%ad|%s' --date=short | awk -F'|' '{printf "%2d. %s  %s  (%s)\n", NR, $2, $3, $1}'
    tags=$(git tag -l 'before-os-update-*' 2>/dev/null | sort -r | head -3)
    if [[ -n "$tags" ]]; then say "Step-back points from updates (use the name):"; printf '%s\n' "$tags" | sed 's/^/    /'; fi
    ;;
  to)
    target="${2:-}"
    [[ -n "$target" ]] || { say "which point? run: bash os/bin/undo.sh list"; exit 2; }
    if [[ "$target" =~ ^[0-9]+$ ]]; then
      sha=$(git log -10 --format='%H' | sed -n "${target}p")
      [[ -n "$sha" ]] || { say "FAIL  there is no point number $target in the list"; exit 2; }
    else
      sha=$(git rev-parse --verify -q "${target}^{commit}") || { say "FAIL  no saved point called $target"; exit 2; }
    fi
    stamp=$(date +%Y-%m-%d-%H%M)
    if [[ -n "$(git status --porcelain)" ]]; then
      git add -A >/dev/null 2>&1
      if git commit -q -m "saved before stepping back $stamp" >/dev/null 2>&1; then
        say "OK    saved what you have now first (saved before stepping back $stamp)"
      fi
    fi
    if [[ "$(git rev-parse HEAD)" == "$sha" ]]; then say "OK    you are already at that point; nothing to change"; exit 0; fi
    label=$(git log -1 --format='%ad %s' --date=short "$sha")
    # 1. files that exist at the chosen point: restore them
    git checkout -q "$sha" -- . 2>/dev/null || { say "FAIL  could not read that point; nothing was changed"; git checkout -q HEAD -- . 2>/dev/null; exit 1; }
    # 2. files added after the chosen point: remove them (tracked files only; nothing else is touched)
    # (this script never removes itself, so a step back can always be stepped forward again)
    added=$(git diff --name-only --diff-filter=A "$sha" HEAD 2>/dev/null | grep -vx 'os/bin/undo.sh' || true)
    if [[ -n "$added" ]]; then
      printf '%s\n' "$added" | while IFS= read -r f; do git rm -q -- "$f" >/dev/null 2>&1; done
    fi
    if [[ -z "$(git status --porcelain)" ]]; then say "OK    nothing differs from that point; nothing to change"; exit 0; fi
    changed=$(git status --porcelain | wc -l | tr -d ' ')
    git commit -q -m "stepped back to: $label ($stamp)" >/dev/null 2>&1 || { say "FAIL  could not save the step back"; exit 1; }
    say "OK    stepped back to: $label"
    say "      $changed file(s) changed. Everything from after that point is still saved; run the list to see it."
    ;;
  *) say "usage: bash os/bin/undo.sh list | to <n or name>"; exit 2 ;;
esac
exit 0
