#!/usr/bin/env bash
# The shipped settings: valid JSON, the three guard hooks still wired, every command the skills run
# has an allow rule, and no rule is broader than the OS's own folders or a git save command.
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"; cd "$HERE"
pass=0; fail=0
ok(){ pass=$((pass+1)); echo "PASS  $1"; }; bad(){ fail=$((fail+1)); echo "FAIL  $1"; }
check(){ if eval "$2"; then ok "$1"; else bad "$1"; fi; }
check "settings.json is valid JSON" 'python3 -c "import json; json.load(open(\".claude/settings.json\"))"'
check "the safety guard, the permission guard and the session hook are wired" 'python3 -c "
import json; d=json.load(open(\".claude/settings.json\")); h=d[\"hooks\"]
assert any(\"caddy-safety-guard\" in x[\"command\"] for g in h[\"PreToolUse\"] for x in g[\"hooks\"])
assert any(\"caddy-permission-guard\" in x[\"command\"] for g in h[\"PermissionRequest\"] for x in g[\"hooks\"])
assert any(\"session-start.sh\" in x[\"command\"] for g in h[\"SessionStart\"] for x in g[\"hooks\"])"'
out="$(python3 os/tests/settings_check.py 2>&1)"; rc=$?
check "every script the skills run has an allow rule, and no rule is too broad" '[[ $rc -eq 0 ]]' || echo "      $out"
echo "      $out"
echo; echo "settings tests: $pass passed, $fail failed"; [[ $fail -eq 0 ]]
