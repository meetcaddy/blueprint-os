#!/usr/bin/env bash
# The quiet wrapper for the engine's session-start hook: drops the vendor update banner, keeps
# everything else; and the settings rewrite is exact and idempotent. Throwaway folder only.
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
T="$(mktemp -d)"; trap 'rm -rf "$T"' EXIT
pass=0; fail=0
ok(){ pass=$((pass+1)); echo "PASS  $1"; }; bad(){ fail=$((fail+1)); echo "FAIL  $1"; }
check(){ if eval "$2"; then ok "$1"; else bad "$1"; fi; }
cat > "$T/fakebase" <<'FB'
#!/bin/sh
cat <<'OUT'
first line of engine context

═══════════════════════════════════════
🔄 ChrisAI update available
   base 0.10.2→0.16.0

   Run: base update
   Snooze 24h: base update --snooze
   Chris AI Systems · https://chrisai.cv/skool
═══════════════════════════════════════
<flow-protocol>
keep this
</flow-protocol>
═══════════════════════════════════════
a boxed note that is not the banner
═══════════════════════════════════════
last line
OUT
FB
chmod +x "$T/fakebase"
out="$(BASE_BIN="$T/fakebase" sh "$HERE/os/hooks/base-session-start.sh")"
check "the banner is gone" '[[ "$out" != *"update available"* && "$out" != *"chrisai"* && "$out" != *"Snooze"* ]]'
check "the engine context before and after is kept, in order" '[[ "$out" == "first line of engine context"*"<flow-protocol>"*"keep this"*"last line" ]]'
check "a boxed note that is not the banner is kept with its rules" '[[ "$out" == *"═══"*"a boxed note that is not the banner"*"═══"* ]]'
check "a missing engine binary exits 0 silently" '[[ -z "$(BASE_BIN="$T/nope" sh "$HERE/os/hooks/base-session-start.sh")" ]]'
cat > "$T/settings.json" <<'JS'
{"hooks": {"SessionStart": [{"hooks": [{"type": "command", "command": "/Users/x/.local/bin/base hook session-start"}]}],
           "Stop": [{"hooks": [{"type": "command", "command": "/Users/x/.local/bin/base hook stop"}]}]}}
JS
out="$(python3 "$HERE/os/bin/quiet-base-hook.py" "$T/settings.json" "$T/wrap.sh")"
check "rewrite: the session-start entry now runs the wrapper" '[[ "$out" == "rewired 1"* ]] && python3 -c "import json,sys; d=json.load(open(sys.argv[1])); c=d[\"hooks\"][\"SessionStart\"][0][\"hooks\"][0][\"command\"]; sys.exit(0 if c==\"sh \\\"\"+sys.argv[2]+\"\\\"\" else 1)" "$T/settings.json" "$T/wrap.sh"'
check "rewrite: the other engine hooks are untouched" 'grep -q "base hook stop" "$T/settings.json"'
out="$(python3 "$HERE/os/bin/quiet-base-hook.py" "$T/settings.json" "$T/wrap.sh")"
check "rewrite: a second run says already quiet and changes nothing" '[[ "$out" == "already quiet" ]]'
check "rewrite: a missing settings file is not an error" '[[ "$(python3 "$HERE/os/bin/quiet-base-hook.py" "$T/none.json" "$T/wrap.sh")" == "nothing to do"* ]]'
echo; echo "base-quiet tests: $pass passed, $fail failed"; [[ $fail -eq 0 ]]
