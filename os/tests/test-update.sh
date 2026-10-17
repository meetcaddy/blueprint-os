#!/usr/bin/env bash
# Tests for /blueprint update on a fake client made from this very build: files added by the
# template arrive even when the client's manifest is older, business files survive, the raw
# drop-folder files survive, and undo steps over the update and back. Throwaway folders only.
# It clones the COMMITTED state of this branch: commit before running it.
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
branch="$(git -C "$HERE" rev-parse --abbrev-ref HEAD)"
T="$(mktemp -d)"; trap 'rm -rf "$T"' EXIT
pass=0; fail=0
ok(){ pass=$((pass+1)); echo "PASS  $1"; }; bad(){ fail=$((fail+1)); echo "FAIL  $1"; }
check(){ if eval "$2"; then ok "$1"; return 0; else bad "$1"; return 1; fi; }
cd "$T"; git clone -q -b "$branch" "$HERE" client 2>/dev/null || { echo "could not clone $HERE ($branch)"; exit 1; }
cd client; git config user.email c@c; git config user.name client
# make it an OLD client: drop what this build added, age the stamp, and strip the manifest lines
rm -rf .claude/skills/blueprint-context .claude/skills/blueprint-undo .claude/skills/blueprint-health os/checks os/prompts os/bin/undo.sh os/bin/health.sh context/README.md package/README.md
for d in context/*/; do rm -f "$d/WHAT-GOES-HERE.md"; done
printf 'v1\nbuild: 2020-01-01 (old)\n' > os/VERSION
grep -v -e 'blueprint-context' -e 'blueprint-undo' -e 'blueprint-health' -e '^context/' -e '^package/' os/MANIFEST > m.tmp && mv m.tmp os/MANIFEST
# an older updater (the one that read the local manifest), to prove the self re-run
sed -i '' 's/done <<< "\$TMPL_MANIFEST"/done < "$MANIFEST"/' setup/update.sh
# the business's own files, a tracked phase folder, and raw files git must never keep
printf '# BUSINESS.md: Acme Roofing\n\n## SESSION\n**Owner:** Sam\n' > BUSINESS.md
mkdir -p design context/phase-1 context/money; echo "design" > design/phase-1.md; echo "raw sop" > context/phase-1/sop.txt
echo "SECRET=keep" > .env; echo "pnl" > context/money/pnl.txt
mkdir -p checks package; echo "# ServiceTitan recipe" > connections/servicetitan.md; printf '#!/bin/sh\necho ok\n' > checks/my-check.sh; echo "transcript" > package/transcript.md
printf '| ServiceTitan | 2026-10-01 | no | walked 2026-10-01 | Sam | fine |\n' >> connections/WALK-LOG.md
git add -A >/dev/null 2>&1; git commit -q -m "old client"; before=$(git rev-parse HEAD)
check "setup: raw files under context/ are ignored, in a slot or a phase folder" '! git ls-files --error-unmatch context/money/pnl.txt >/dev/null 2>&1 && ! git ls-files --error-unmatch context/phase-1/sop.txt >/dev/null 2>&1'
export BLUEPRINT_TEMPLATE_URL="$HERE" BLUEPRINT_TEMPLATE_BRANCH="$branch"
out="$(bash setup/update.sh 2>&1)"; rc=$?
check "update: completes" '[[ $rc -eq 0 && "$out" == *"UPDATE COMPLETE"* ]]'
check "update: the updater re-ran itself once (the old one changed)" '[[ "$out" == *"running it once more"* ]]'
check "update: new skills arrived although the client manifest was old" '[[ -f .claude/skills/blueprint-context/SKILL.md && -f .claude/skills/blueprint-undo/SKILL.md && -f .claude/skills/blueprint-health/SKILL.md ]]'
check "update: drop-folder notes and package note arrived" '[[ -f context/README.md && -f context/money/WHAT-GOES-HERE.md && -f package/README.md ]]'
check "update: new scripts arrived" '[[ -f os/bin/undo.sh && -f os/bin/health.sh && -f os/checks/http-ok.sh && -f os/prompts/design-duel.md ]]'
check "update: version stamp is the template's" '[[ "$(sed -n 2p os/VERSION)" == "$(sed -n 2p "$HERE/os/VERSION")" ]]'
check "update: BUSINESS.md untouched" '[[ "$(cat BUSINESS.md)" == *"Acme Roofing"* ]]'
check "update: design record untouched" '[[ "$(cat design/phase-1.md)" == "design" ]]'
check "update: the phase folder's raw file untouched" '[[ "$(cat context/phase-1/sop.txt)" == "raw sop" ]]'
check "update: raw money file and .env untouched" '[[ "$(cat context/money/pnl.txt)" == "pnl" && "$(cat .env)" == "SECRET=keep" ]]'
check "update: a recipe the machine wrote survives" '[[ -f connections/servicetitan.md ]]'
check "update: the business's own check script survives" '[[ -f checks/my-check.sh ]]'
check "update: the template's own recipes were refreshed" '[[ -f connections/n8n.md && -f connections/bin/check-http.sh ]]'
check "update: the walk-log row the business wrote survives" 'grep -q "walked 2026-10-01" connections/WALK-LOG.md'
check "update: the transcript stays out of git" '! git ls-files --error-unmatch package/transcript.md >/dev/null 2>&1 && [[ -f package/transcript.md ]]'
check "update: tree clean, commits made, step-back tag present" '[[ -z "$(git status --porcelain)" && "$(git rev-parse HEAD)" != "$before" ]] && git tag -l "before-os-update-*" | grep -q .'
out2="$(bash setup/update.sh 2>&1)"; check "update: a second run finds nothing to do" '[[ "$out2" == *"nothing to update"* ]]'
n=$(git rev-list --count "$before"..HEAD)
out3="$(bash os/bin/undo.sh to $((n+1)) 2>&1)"
check "undo: steps back over the update(s)" '[[ "$out3" == *"stepped back to"*"old client"* && ! -f os/bin/health.sh && ! -f context/README.md ]]' || echo "      undo said: $out3"
check "undo: raw files and .env still there" '[[ -f context/money/pnl.txt && -f .env && "$(cat context/phase-1/sop.txt)" == "raw sop" ]]'
check "undo: the undo script never removes itself" '[[ -f os/bin/undo.sh ]]'
out4="$(bash os/bin/undo.sh to 2 2>&1)"
check "undo: steps forward again" '[[ "$out4" == *"stepped back to"* && -f os/bin/health.sh ]]' || echo "      undo said: $out4"
echo; echo "update tests: $pass passed, $fail failed"; [[ $fail -eq 0 ]]
