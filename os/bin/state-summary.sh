#!/bin/sh
# Prints the copy-ready state summary /blueprint help shows the owner. Read-only.
# Carries the version stamp, the business name, the phase and the last step. No keys, no
# file contents, no personal data beyond the business name and the owner's first name.
set -u
ROOT="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/../.." && pwd)}"
cd "$ROOT" 2>/dev/null || exit 0

get() { sed -n "s/^\*\*$1:\*\* *//p" "$2" 2>/dev/null | head -1; }

version=$(sed -n '1p' os/VERSION 2>/dev/null); build=$(sed -n '2p' os/VERSION 2>/dev/null)
business=$(sed -n 's/^# BUSINESS\.md: *//p; s/^# BUSINESS\.md — *//p' BUSINESS.md 2>/dev/null | head -1)
owner=$(get Owner BUSINESS.md); session=$(get "Session date" BUSINESS.md)
if [ -f .paul/STATE.md ]; then
  phase=$(sed -n 's/^Phase: *//p' .paul/STATE.md | head -1)
  plan=$(sed -n 's/^Plan: *//p' .paul/STATE.md | head -1)
  stage="building"
elif ls design/phase-*.md >/dev/null 2>&1; then
  stage="deep dive"; phase=$(ls design/phase-*.md | wc -l | tr -d ' ')
elif [ -f BLUEPRINT.md ]; then
  stage="blueprint built, deep dive not started"
elif [ -f BUSINESS.md ]; then
  stage="installed, waiting for the package"
else
  stage="not set up yet"
fi
last=$(git log -1 --format='%ad %s' --date=short 2>/dev/null)
mac=$(uname -sm 2>/dev/null)

echo "----- your Caddy: state summary (copy everything between the lines) -----"
echo "Version: ${version:-unknown} (${build:-no build stamp})"
echo "Business: ${business:-not recorded yet}"
[ -n "$owner" ] && echo "Owner: $owner"
[ -n "$session" ] && echo "Session date: $session"
echo "Stage: $stage"
[ -n "${phase:-}" ] && echo "Phase: $phase"
[ -n "${plan:-}" ] && echo "Plan: $plan"
echo "Last saved step: ${last:-no commits yet}"
echo "Machine: ${mac:-unknown}"
echo "Engine: base $(base --version 2>/dev/null | head -1 || echo 'not found'); .base/ $([ -f .base/base.toml ] && echo present || echo missing); PAUL commands $([ -d "$HOME/.claude/commands/paul" ] && echo present || echo missing)"
echo "-------------------------------------------------------------------------"
exit 0
