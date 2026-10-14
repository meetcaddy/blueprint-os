#!/bin/sh
# Once a day, reads ONE public file (the template's version stamp) and says whether a newer build
# of your Caddy exists. Nothing about the business is sent. Silent when offline, when the answer
# is not the expected shape, when the check already ran today, or when this build was announced
# already. The pull itself happens only through /blueprint update, on the owner's yes.
#   sh os/bin/version-check.sh          the daily check: prints one line, or nothing
#   sh os/bin/version-check.sh --now    skip the once-a-day rule (the announce-once rule still holds)
set -u
ROOT="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/../.." && pwd)}"
cd "$ROOT" 2>/dev/null || exit 0
URL="${BLUEPRINT_VERSION_URL:-https://raw.githubusercontent.com/meetcaddy/blueprint-os/main/os/VERSION}"
DAY=.blueprint/last-version-check
SEEN=.blueprint/announced-build
today=$(date +%Y-%m-%d)
[ -f os/VERSION ] || exit 0
command -v curl >/dev/null 2>&1 || exit 0
if [ "${1:-}" != "--now" ] && [ "$(cat "$DAY" 2>/dev/null)" = "$today" ]; then exit 0; fi
mkdir -p .blueprint; printf '%s\n' "$today" > "$DAY"
remote=$(curl -fsS --max-time 4 "$URL" 2>/dev/null) || exit 0
first=$(printf '%s\n' "$remote" | sed -n '1p'); second=$(printf '%s\n' "$remote" | sed -n '2p')
case "$first" in v[0-9]*) ;; *) exit 0 ;; esac
case "$second" in build:*) ;; *) exit 0 ;; esac
local_build=$(sed -n '2p' os/VERSION)
[ "$local_build" = "$second" ] && exit 0
ld=$(printf '%s' "$local_build" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' | head -1)
rd=$(printf '%s' "$second" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' | head -1)
[ -n "$rd" ] || exit 0
if [ -n "$ld" ] && [ "$rd" \< "$ld" ]; then exit 0; fi
# a different build line on the same day is a newer build too (a same-day fix)
[ "$(cat "$SEEN" 2>/dev/null)" = "$second" ] && exit 0
printf '%s\n' "$second" > "$SEEN"
echo "A newer version of your Caddy is available (build $rd). Type /blueprint update when you want it; your business files are never touched."
exit 0
