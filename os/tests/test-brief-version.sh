#!/usr/bin/env bash
# Tests for the Monday brief and the version check. Throwaway folders only; no real network.
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
T="$(mktemp -d)"; trap 'rm -rf "$T"' EXIT
pass=0; fail=0
ok(){ pass=$((pass+1)); echo "PASS  $1"; }; bad(){ fail=$((fail+1)); echo "FAIL  $1"; }
check(){ if eval "$2"; then ok "$1"; else bad "$1"; fi; }
mkdir -p "$T/os/bin" "$T/os/hooks" "$T/context" "$T/remote"
cp "$HERE/os/bin/brief.sh" "$HERE/os/bin/version-check.sh" "$HERE/os/bin/state-summary.sh" "$HERE/os/bin/context-index.py" "$HERE/os/bin/extract_text.py" "$T/os/bin/"
cp "$HERE/os/hooks/session-start.sh" "$T/os/hooks/"
printf 'v1\nbuild: 2026-10-13 (test)\n' > "$T/os/VERSION"
cd "$T"; export CLAUDE_PROJECT_DIR="$T"

# --- the brief
check "brief: not due before BUSINESS.md exists" '! sh os/bin/brief.sh --due'
check "brief: prints nothing before BUSINESS.md exists" '[[ -z "$(sh os/bin/brief.sh)" ]]'
printf '# BUSINESS.md: Acme Roofing\n\n## SESSION\n**Owner:** Sam\n**Session date:** 2026-10-01\n' > BUSINESS.md
check "brief: still not due before the Blueprint is built (first boot seeds BUSINESS.md)" '! sh os/bin/brief.sh --due'
printf '# Your Blueprint\n' > BLUEPRINT.md
check "brief: due once the Blueprint exists" 'sh os/bin/brief.sh --due'
printf '# SYSTEMS.md\n\n| What | Where it lives | Whose account | What it does | How to check it is healthy | Since |\n|---|---|---|---|---|---|\n| [name] | x | x | x | x | x |\n| Invoice reminder | n8n | Sam | sends reminders | open n8n | 2026-10-05 |\n| Quote folder watcher | the machine | Sam | builds quotes | file-fresh | 2026-10-08 |\n' > SYSTEMS.md
printf '# WAITING-ON-YOU.md\n\n| Since | Who | What | Where it came from |\n|---|---|---|---|\n| 2026-10-10 | Dana | sign in to n8n and click Allow | phase 1, plan 1 |\n' > WAITING-ON-YOU.md
out="$(sh os/bin/brief.sh)"
check "brief: header" '[[ "$out" == *"Your week, in one look"* ]]'
check "brief: counts real systems, not the placeholder, and says what it counts" '[[ "$out" == *"Built or connected outside your Caddy: 2 thing(s)"* ]]'
check "brief: waiting rows, by name" '[[ "$out" == *"since 2026-10-10, Dana: sign in to n8n and click Allow"* ]]'
check "brief: drop folder line" '[[ "$out" == *"Drop folder:"* ]]'
check "brief: points to status" '[[ "$out" == *"/blueprint status"* ]]'
sh os/bin/brief.sh --stamp
check "brief: not due again this week after the stamp" '! sh os/bin/brief.sh --due'
printf '# WAITING-ON-YOU.md\n\n| Since | Who | What | Where it came from |\n|---|---|---|---|\n' > WAITING-ON-YOU.md
check "brief: empty waiting list says nothing" '[[ "$(sh os/bin/brief.sh)" == *"Waiting on you: nothing."* ]]'

# --- the version check (a file:// URL stands in for the template)
export BLUEPRINT_VERSION_URL="file://$T/remote/VERSION"
printf 'v1\nbuild: 2026-10-13 (test)\n' > remote/VERSION
check "version: same build says nothing" '[[ -z "$(sh os/bin/version-check.sh --now)" ]]'
printf 'v1\nbuild: 2026-11-02 (newer)\n' > remote/VERSION
rm -f .blueprint/last-version-check
out="$(sh os/bin/version-check.sh)"
check "version: a newer build is announced once, with its date" '[[ "$out" == *"newer version"*"2026-11-02"*"/blueprint update"* ]]'
check "version: silent the second time the same day" '[[ -z "$(sh os/bin/version-check.sh)" ]]'
check "version: silent again even with --now (already announced)" '[[ -z "$(sh os/bin/version-check.sh --now)" ]]'
printf 'v1\nbuild: 2026-12-01 (newer still)\n' > remote/VERSION
check "version: a newer build than the announced one is announced again" '[[ "$(sh os/bin/version-check.sh --now)" == *"2026-12-01"* ]]'
printf 'v1\nbuild: 2026-09-04 (older)\n' > remote/VERSION
check "version: an older remote says nothing" '[[ -z "$(sh os/bin/version-check.sh --now)" ]]'
printf 'v1\nbuild: 2026-10-13 (a same-day fix)\n' > remote/VERSION
check "version: a different build on the same day is announced" '[[ "$(sh os/bin/version-check.sh --now)" == *"2026-10-13"* ]]'
check "version: and only once" '[[ -z "$(sh os/bin/version-check.sh --now)" ]]'
printf '<html><body>Sign in to the hotel network</body></html>\n' > remote/VERSION
check "version: a captive portal page says nothing" '[[ -z "$(sh os/bin/version-check.sh --now)" ]]'
rm -f remote/VERSION
check "version: unreachable says nothing and exits 0" '[[ -z "$(sh os/bin/version-check.sh --now)" ]] && sh os/bin/version-check.sh --now'
printf 'v1\nbuild: 2027-01-01 (x)\n' > remote/VERSION; mv os/VERSION os/VERSION.bak
check "version: no local version file says nothing" '[[ -z "$(sh os/bin/version-check.sh --now)" ]]'
mv os/VERSION.bak os/VERSION
start=$(date +%s); BLUEPRINT_VERSION_URL="http://10.255.255.1/VERSION" sh os/bin/version-check.sh --now >/dev/null; end=$(date +%s)
check "version: a dead host gives up within about five seconds" '[[ $((end-start)) -le 6 ]]'
unset BLUEPRINT_VERSION_URL

# --- the hook
rm -f .blueprint/last-brief; printf '# Your Blueprint\n' > BLUEPRINT.md
export BLUEPRINT_VERSION_URL="file://$T/remote/VERSION"; rm -f .blueprint/announced-build .blueprint/last-version-check
printf 'v1\nbuild: 2027-02-02 (hook)\n' > remote/VERSION
hook="$(sh os/hooks/session-start.sh)"
check "hook: shows the business memory" '[[ "$hook" == *"Your memory of the business"* ]]'
check "hook: shows the brief when due" '[[ "$hook" == *"Your week, in one look"* ]]'
check "hook: shows the version line" '[[ "$hook" == *"2027-02-02"* ]]'
hook2="$(sh os/hooks/session-start.sh)"
check "hook: second open this week shows no brief" '[[ "$hook2" != *"Your week, in one look"* ]]'
check "hook: second open shows no version line" '[[ "$hook2" != *"2027-02-02"* ]]'
check "hook: .blueprint stamps exist" '[[ -f .blueprint/last-brief && -f .blueprint/last-version-check && -f .blueprint/announced-build ]]'
echo; echo "brief + version tests: $pass passed, $fail failed"; [[ $fail -eq 0 ]]
