#!/usr/bin/env bash
# Tests for the copy gate: file names with spaces, the business's own material skipped, the
# owner's own name allowed, real offences still caught. Throwaway folders only.
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
T="$(mktemp -d)"; trap 'rm -rf "$T"' EXIT
pass=0; fail=0
ok(){ pass=$((pass+1)); echo "PASS  $1"; }; bad(){ fail=$((fail+1)); echo "FAIL  $1"; }
check(){ if eval "$2"; then ok "$1"; return 0; else bad "$1"; return 1; fi; }
N="Tuc"; N="${N}ker"   # the internal name, built at run time so this file never carries it
mkdir -p "$T/os/bin" "$T/package/out/Meet Caddy 2026-08-09" "$T/context/people" "$T/os/templates"
cp "$HERE/os/bin/copy-check.sh" "$T/os/bin/copy-check.sh"
printf '# BUSINESS.md: Meet Caddy\n\n## SESSION\n**Owner:** %s\n' "$N" > "$T/BUSINESS.md"
printf '%s, you hold the keys to Close.\n' "$N" > "$T/TEAM-NOTE.md"
printf 'the package \xe2\x80\x94 with a dash the owner typed\n' > "$T/package/out/Meet Caddy 2026-08-09/PACKAGE.md"
printf 'Owner: %s \xe2\x80\x94 Sales: Josh\n' "$N" > "$T/context/people/org.md"
printf 'A plain template line.\n' > "$T/os/templates/plain.md"
out="$(cd "$T" && bash os/bin/copy-check.sh 2>&1)"; rc=$?
check "copy check: clean when the only offences sit in the business's own files" '[[ $rc -eq 0 && "$out" == "copy check: clean" ]]' || echo "      said: $out"
check "copy check: no awk error on a folder name with spaces" '[[ "$out" != *"awk:"* ]]'
printf 'A line with an em dash \xe2\x80\x94 here.\n' > "$T/HOW-IT-WORKS.md"
out="$(cd "$T" && bash os/bin/copy-check.sh 2>&1)"; rc=$?
check "copy check: a dash in a template file is still caught" '[[ $rc -eq 1 && "$out" == *"HOW-IT-WORKS.md:1: em dash"* ]]' || echo "      said: $out"
rm "$T/HOW-IT-WORKS.md"
printf '# BUSINESS.md: Acme Roofing\n\n## SESSION\n**Owner:** Sam\n' > "$T/BUSINESS.md"
out="$(cd "$T" && bash os/bin/copy-check.sh 2>&1)"; rc=$?
check "copy check: an internal name is caught when the owner is someone else" '[[ $rc -eq 1 && "$out" == *"TEAM-NOTE.md:1: internal name"* ]]' || echo "      said: $out"
echo; echo "copy-check tests: $pass passed, $fail failed"; [[ $fail -eq 0 ]]
