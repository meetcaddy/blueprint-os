#!/usr/bin/env bash
# Pulls the template's OS files into this folder. Run by /blueprint update.
# Replaces ONLY the paths listed in os/MANIFEST, from the template's main branch. The
# business's own files are never touched. A commit is made before and after, so the step
# back is always one command away (git log shows it).
set -u

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATE_URL="${BLUEPRINT_TEMPLATE_URL:-https://github.com/meetcaddy/blueprint-os.git}"
TEMPLATE_BRANCH="${BLUEPRINT_TEMPLATE_BRANCH:-main}"
MANIFEST="$REPO/os/MANIFEST"
STAMP="$(date +%Y-%m-%d-%H%M)"

cd "$REPO" || exit 2
say()  { echo "$1"; }
fail() { echo "FAIL  $1"; exit 1; }

say "== Your Caddy: update =="
[[ -d .git ]] || fail "this folder is not a git repository; your Caddy cannot update safely"
[[ -f "$MANIFEST" ]] || fail "os/MANIFEST is missing; nothing to update from"

# 0. Never run with unsaved work: everything gets committed first (the backup).
if [[ -n "$(git status --porcelain)" ]]; then
  git add -A >/dev/null 2>&1
  git commit -q -m "before os update $STAMP" >/dev/null 2>&1 && say "OK    saved your work first (commit: before os update $STAMP)"
fi
git tag -f "before-os-update-$STAMP" >/dev/null 2>&1 && say "OK    marked the step-back point: before-os-update-$STAMP"

# 1. The template remote
if git remote get-url template >/dev/null 2>&1; then
  git remote set-url template "$TEMPLATE_URL"
else
  git remote add template "$TEMPLATE_URL"
fi
git fetch -q template "$TEMPLATE_BRANCH" 2>/dev/null || fail "could not reach the template at $TEMPLATE_URL (check the internet connection)"
say "OK    template reached ($TEMPLATE_URL, $TEMPLATE_BRANCH)"

OLD_VERSION="$(sed -n '2p' os/VERSION 2>/dev/null)"
NEW_VERSION="$(git show "template/$TEMPLATE_BRANCH:os/VERSION" 2>/dev/null | sed -n '2p')"

# 2. Replace only the manifest paths
CHANGED=0
while IFS= read -r line || [[ -n "$line" ]]; do
  line="${line%%#*}"; line="$(echo "$line" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')"
  [[ -z "$line" ]] && continue
  path="${line%/}"
  if git cat-file -e "template/$TEMPLATE_BRANCH:$path" 2>/dev/null; then
    if [[ "$line" == */ ]]; then
      # a folder: take the template's version wholesale so removed files go too
      git rm -r -q --cached "$path" >/dev/null 2>&1 || true
      rm -rf "$path"
    fi
    git checkout -q "template/$TEMPLATE_BRANCH" -- "$path" 2>/dev/null && CHANGED=$((CHANGED+1))
  fi
done < "$MANIFEST"

# 3. What changed, in plain words
if [[ -z "$(git status --porcelain)" ]]; then
  say "OK    nothing to update: your Caddy already matches the template ($OLD_VERSION)"
  exit 0
fi
FILES="$(git status --porcelain | wc -l | tr -d ' ')"
git add -A >/dev/null 2>&1
git commit -q -m "os update $STAMP: ${NEW_VERSION:-template}" >/dev/null 2>&1 || fail "could not save the update"
say "OK    updated $FILES file(s) from the template"
say "      was: ${OLD_VERSION:-unknown}"
say "      now: ${NEW_VERSION:-unknown}"
say "      step back any time with: git checkout before-os-update-$STAMP -- ."

# 4. Engine files changed? Then the engine must be put in place again.
if git diff --name-only "before-os-update-$STAMP" HEAD | grep -qE '^(frameworks/|base/|setup/setup\.sh)'; then
  say "NEXT  the engine changed: type /blueprint setup once more so the new pieces are put in place"
fi
say "UPDATE COMPLETE."
exit 0
