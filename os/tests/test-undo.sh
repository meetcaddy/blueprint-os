#!/usr/bin/env bash
# Tests for /blueprint undo's script. A throwaway repo; nothing here is touched.
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
T="$(mktemp -d)"; trap 'rm -rf "$T"' EXIT
pass=0; fail=0
ok(){ pass=$((pass+1)); echo "PASS  $1"; }; bad(){ fail=$((fail+1)); echo "FAIL  $1"; }
check(){ if eval "$2"; then ok "$1"; else bad "$1"; fi; }
mkdir -p "$T/os/bin" "$T/context/money"; cp "$HERE/os/bin/undo.sh" "$T/os/bin/"; cp "$HERE/.gitignore" "$T/.gitignore"
cd "$T"
out="$(bash os/bin/undo.sh list)"; check "no repo: says so, exit 2" '[[ "$out" == FAIL* ]] && ! bash os/bin/undo.sh list >/dev/null 2>&1'
git init -q . && git config user.email t@t && git config user.name t
out="$(bash os/bin/undo.sh list)"; check "no saved points: says so" '[[ "$out" == *"no saved points"* ]]'
echo "a" > BUSINESS.md; git add BUSINESS.md .gitignore; git commit -q -m "first point"
git add os/bin/undo.sh; git commit -q -m "the undo script arrived"
echo "b" > BUSINESS.md; mkdir -p design; echo "phase one design" > design/phase-1.md; git add BUSINESS.md design/phase-1.md; git commit -q -m "second point"
git tag before-os-update-2026-10-13-0101
echo "c" > BUSINESS.md; echo "SECRET=do-not-touch" > .env; echo "raw" > context/money/pnl.txt; echo "new" > amendments.md
out="$(bash os/bin/undo.sh list)"
check "list: numbered, newest first" '[[ "$out" == *" 1. "*"second point"* && "$out" == *" 2. "*"first point"* ]]'
check "list: shows the update's step-back point" '[[ "$out" == *"before-os-update-2026-10-13-0101"* ]]'
out="$(bash os/bin/undo.sh to 3)"
check "to 2: saves the unsaved work first" '[[ "$out" == *"saved what you have now first"* ]] && git log --format=%s | grep -q "saved before stepping back"'
check "to 2: steps back" '[[ "$out" == *"stepped back to"*"first point"* ]]'
check "to 2: BUSINESS.md matches the first point" '[[ "$(cat BUSINESS.md)" == "a" ]]'
check "to 2: a file added after the point is gone" '[[ ! -f design/phase-1.md ]]'
check "to 2: the undo script itself survives (it was added after the point)" '[[ -f os/bin/undo.sh ]]'
check "to 2: amendments.md (saved in the first step) is gone too" '[[ ! -f amendments.md ]]'
check "to 2: .env untouched" '[[ "$(cat .env)" == "SECRET=do-not-touch" ]]'
check "to 2: the raw dropped file untouched" '[[ "$(cat context/money/pnl.txt)" == "raw" ]]'
check "to 3: nothing deleted from history" '[[ "$(git rev-list --count HEAD)" -eq 5 ]]'
check "to 2: the working tree is clean afterwards" '[[ -z "$(git status --porcelain)" ]]'
out="$(bash os/bin/undo.sh to 1)"; check "to 1: already there" '[[ "$out" == *"already at that point"* ]]'
out="$(bash os/bin/undo.sh to before-os-update-2026-10-13-0101)"
check "to a named point: steps forward again" '[[ "$out" == *"stepped back to"*"second point"* && "$(cat BUSINESS.md)" == "b" && -f design/phase-1.md ]]'
out="$(bash os/bin/undo.sh to 99)"; check "to 99: no such point, exit 2" '[[ "$out" == FAIL* ]] && ! bash os/bin/undo.sh to 99 >/dev/null 2>&1'
out="$(bash os/bin/undo.sh to nothing-here)"; check "to a bad name: no such point" '[[ "$out" == FAIL* ]]'
out="$(bash os/bin/undo.sh to 1)"; check "to 1 after a step: already there" '[[ "$out" == *"already at that point"* ]]'
echo; echo "undo tests: $pass passed, $fail failed"; [[ $fail -eq 0 ]]
