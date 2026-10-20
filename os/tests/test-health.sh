#!/usr/bin/env bash
# Tests for /blueprint health's script and the shipped checks. Throwaway folder only.
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
T="$(mktemp -d)"; trap 'rm -rf "$T"' EXIT
pass=0; fail=0
ok(){ pass=$((pass+1)); echo "PASS  $1"; }; bad(){ fail=$((fail+1)); echo "FAIL  $1"; }
check(){ if eval "$2"; then ok "$1"; else bad "$1"; fi; }
mkdir -p "$T/os/bin" "$T/os/checks" "$T/connections/bin" "$T/checks" "$T/elsewhere"
cp "$HERE/os/bin/health.sh" "$HERE/os/bin/health.py" "$T/os/bin/"; cp "$HERE"/os/checks/*.sh "$T/os/checks/"; cp "$HERE"/connections/bin/*.sh "$T/connections/bin/"
printf '#!/bin/sh\necho "mine: ok"\n' > "$T/checks/my-check.sh"; printf '#!/bin/sh\ntouch "$T/escaped"\n' > "$T/elsewhere/evil.sh"; ln -s "$T/elsewhere/evil.sh" "$T/os/checks/link.sh"
cd "$T"; export CLAUDE_PROJECT_DIR="$T"
out="$(bash os/bin/health.sh)"; check "no SYSTEMS.md: says nothing is built yet" '[[ "$out" == *"nothing built outside"* ]]'
touch present.txt; echo "old" > old.txt; touch -t 202001010000 old.txt
printf '#!/bin/sh\nsleep 30 &\nwait\n' > os/checks/slow.sh; chmod +x os/checks/slow.sh
marker="$T/should-not-exist"
cat > SYSTEMS.md <<SYS
# SYSTEMS.md

| What | Where it lives | Whose account | What it does | How to check it is healthy | Since |
|---|---|---|---|---|---|
| [name] | x | x | x | check: \`bash os/checks/file-exists.sh placeholder present.txt\` | x |
| Quote folder | the machine | Sam | builds quotes | open the folder; check: \`bash os/checks/file-exists.sh "Quote folder" present.txt\` | 2026-10-05 |
| Nightly export | the machine | Sam | exports | check: \`bash os/checks/file-fresh.sh "Nightly export" old.txt 60\` | 2026-10-05 |
| Reminder rail | n8n | Dana | sends reminders | check: \`bash connections/bin/check-http.sh n8n https://example.invalid/x X-N8N-API-KEY N8N_API_KEY\` | 2026-10-06 |
| Slow thing | the machine | Sam | hangs | check: \`bash os/checks/slow.sh\` | 2026-10-07 |
| Hand check | their CRM | Sam | syncs | open the CRM and look for today's date on the last sync line | 2026-10-08 |
| Sneaky row | nowhere | x | x | check: \`touch $marker\` | 2026-10-09 |
| Missing file | the machine | Sam | x | check: \`bash os/checks/file-exists.sh "Missing file" nope.txt\` | 2026-10-10 |
| Joined row | nowhere | x | x | check: \`bash os/checks/file-exists.sh joined present.txt; touch $marker-joined\` | 2026-10-11 |
| Dotdot row | nowhere | x | x | check: \`bash connections/bin/../../elsewhere/evil.sh\` | 2026-10-11 |
| Link row | nowhere | x | x | check: \`bash os/checks/link.sh\` | 2026-10-11 |
| Own check | the machine | Sam | x | check: \`bash checks/my-check.sh\` | 2026-10-12 |
| Webhook row | n8n | Sam | x | check: \`bash os/checks/http-ok.sh hook https://example.invalid/webhook/abc\` | 2026-10-12 |
| Listed system | Cloud | Dana | CRM | not connected yet | 2026-11-03, from the Audit Workbook |
SYS
start=$(date +%s); out="$(bash os/bin/health.sh)"; rc=$?; end=$(date +%s)
check "placeholder row ignored" '[[ "$out" != *"placeholder"* ]]'
check "a passing check reads running" '[[ "$out" == *"running   Quote folder: Quote folder: present"* ]]'
check "a stale file reads broken" '[[ "$out" == *"broken    Nightly export"*"more than 60"* ]]'
check "a check whose key is not set reads needs you" '[[ "$out" == *"needs you Reminder rail"*"not set"* ]]'
check "a hanging check is cut off at 20 seconds" '[[ "$out" == *"broken    Slow thing: the check took more than 20 seconds"* ]]'
check "the hanging check and its child are stopped inside about 20 seconds" '[[ $((end-start)) -lt 26 ]]'
check "a plain-words cell reads manual" '[[ "$out" == *"manual    Hand check: open the CRM"* ]]'
check "a command outside the two folders is never run" '[[ ! -e "$marker" ]] && [[ "$out" == *"manual    Sneaky row"* ]]'
check "a missing file reads broken" '[[ "$out" == *"broken    Missing file"*"missing"* ]]'
check "a joined command runs only the check, never the rest" '[[ ! -e "$marker-joined" ]] && [[ "$out" == *"Joined row"* ]]'
check "a .. path is never run" '[[ "$out" == *"manual    Dotdot row"* ]] && [[ ! -e "$T/escaped" ]]'
check "a link out of the folder is never run" '[[ "$out" == *"manual    Link row"* ]] && [[ ! -e "$T/escaped" ]]'
check "the business's own checks folder is allowed" '[[ "$out" == *"running   Own check: mine: ok"* ]]'
check "a webhook address is refused as a check" '[[ "$out" == *"broken    Webhook row"*"starts something"* ]]'
echo "      summary: $(printf '%s\n' "$out" | tail -1)"
check "a system listed from the Audit Workbook reads not yet and is never run" '[[ "$out" == *"not yet   Listed system: not connected yet"* ]]'
check "summary counts" '[[ "$out" == *"health: 13 system(s): 2 running, 1 need you, 5 broken, 4 manual, 1 not connected yet"* ]]'
check "exit code is non-zero when something is broken" '[[ $rc -ne 0 ]]'
check "no key value ever printed" '[[ "$out" != *"N8N_API_KEY="* ]]'
out="$(bash os/checks/http-ok.sh test http://10.255.255.1/ 2>&1)"; check "http-ok: dead host says no answer, exit 3" '[[ "$out" == *"no answer"* ]]'
echo; echo "health tests: $pass passed, $fail failed"; [[ $fail -eq 0 ]]
