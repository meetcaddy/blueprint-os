#!/usr/bin/env bash
# Tests for the package check /blueprint ingest runs first: the three package files, the Caddy
# team's roadmap brief read beside the transcript, the transcript winning every disagreement, the
# brief alone refused plainly, and the state summary saying what is in the package. Throwaway
# folders only; the fixture is the parse contract's made-up roofing business, never a client.
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
T="$(mktemp -d)"; trap 'rm -rf "$T"' EXIT
pass=0; fail=0
ok(){ pass=$((pass+1)); echo "PASS  $1"; }; bad(){ fail=$((fail+1)); echo "FAIL  $1"; }
check(){ if eval "$2"; then ok "$1"; else bad "$1"; fi; }
mkdir -p "$T/os/bin" "$T/os/templates" "$T/package"
cp "$HERE/os/bin/package-check.py" "$HERE/os/bin/state-summary.sh" "$T/os/bin/"
cp "$HERE/os/VERSION" "$T/os/VERSION"; cp "$HERE/.gitignore" "$T/.gitignore"
cd "$T"; export CLAUDE_PROJECT_DIR="$T"
run(){ out="$(python3 os/bin/package-check.py 2>&1)"; rc=$?; }

transcript(){ cat > package/transcript.md <<'EOF'
LEAD: This is the Caddy Blueprint session for Harbor Point Roofing, August eighth, twenty twenty-six.
OWNER: Good.
LEAD: Blueprint opportunity 1: invoice follow-up. Today, Maria chases unpaid invoices by hand every Friday, about four hours. The machine should send the reminders and flag only the ones that need a human call.
LEAD: This is an early-phase item. That lives in QuickBooks and Gmail. Maria owns this one.
CLIENT: Honestly the estimates take longer than the invoicing.
LEAD: Blueprint opportunity two: estimate drafts. Today, every estimate starts from a blank document, about an hour each. The machine should draft from the last three similar jobs, and you approve.
LEAD: Strike opportunity 1.
LEAD: Blueprint opportunity 3: invoice follow-up, the full cycle. Today, it's Friday batch-chasing. The machine should watch invoices daily and handle the whole reminder ladder.
LEAD: Update opportunity 2: draft from the last five similar jobs, not three.
LEAD: Their stack, for the record: QuickBooks, Gmail, the estimating spreadsheet, Dropbox.
LEAD: Maria can grant QuickBooks. You can grant Gmail and Dropbox.
LEAD: Phase 1 starts with the invoice reminder ladder.
LEAD: That’s the Blueprint, everything after this is setup.
LEAD: Blueprint opportunity 9: install chatter, never read.
EOF
}
intake(){ printf '# BLUEPRINT INTAKE\n\n**Session date:** 2026-08-08\n' > package/intake-doc.md; }
brief(){ cat > package/roadmap-brief.md <<'EOF'
# Roadmap brief: Harbor Point Roofing

**Business:** Harbor Point Roofing
**Session date:** 2026-08-08
**Author:** the Caddy team
**Written:** 2026-08-10

## Their stack, for the record
| System | Verdict | Plan | Version | Checked |
|---|---|---|---|---|
| QuickBooks | connect | Online Plus | n/a | 2026-08-10 |
| Gmail | connect | Workspace Business Starter | n/a | 2026-08-10 |
| The estimating spreadsheet | work around | Excel, a shared file | 2021 | 2026-08-10 |
| Dropbox | replace | Basic | n/a | 2026-08-10 |

## Opportunities
### Blueprint opportunity 2: estimate drafts
Today, every estimate starts from a blank document, about an hour each. The machine should draft from the last five similar jobs, and the owner approves. That lives in the estimating spreadsheet and Dropbox. The owner owns this one. This is an early-phase item.

### Blueprint opportunity 3: invoice follow-up, the full cycle
Today, it is Friday batch-chasing, about four hours a week. The machine should watch invoices daily and handle the whole reminder ladder. That lives in QuickBooks and Gmail. Maria owns this one. This is an early-phase item.
Constraint on opportunity 3: reminders keep Maria's exact wording.

### Blueprint opportunity 4: the job photo log
Today, crews text photos to the owner, no number known. The machine should file each photo under its job. That lives in Dropbox. This is a mid-phase item.

## Constraints, general
- nothing that makes money gets disrupted

## Phase 1 starts with
the invoice reminder ladder

## Access owners
- Maria can grant QuickBooks.
- The owner can grant Gmail and Dropbox.

## Unconfirmed
- whether the crews would use a shared album instead of texts
EOF
}

# --- ingest with the brief
transcript; intake; brief; run
check "with the brief: goes on (exit 0)" '[[ $rc -eq 0 ]]'
check "with the brief: names the transcript with its size" '[[ "$out" == *"Transcript: transcript.md ("*"words)"* ]]'
check "with the brief: a short transcript is flagged, not refused" '[[ "$out" == *"short for a session, so ask once"* ]]'
check "with the brief: the recap being absent is fine" '[[ "$out" == *"Session recap: not there (fine)."* ]]'
check "with the brief: reads the header" '[[ "$out" == *"written by the Caddy team on 2026-08-10 for Harbor Point Roofing (session 2026-08-08)"* ]]'
check "with the brief: counts the verdicts" '[[ "$out" == *"4 systems checked (2 connect, 1 replace, 1 work around)"* ]]'
check "with the brief: counts the brief's parts" '[[ "$out" == *"3 opportunities, 1 general constraint, the first move, 2 access owners, 1 unconfirmed item."* ]]'
check "with the brief: the session's numbers, the strike, and a number said as a word" '[[ "$out" == *"Opportunities framed in the session: 1, 2, 3 (struck: 1)."* ]]'
check "with the brief: everything after the end marker is ignored" '[[ "$out" != *"opportunity 9"* && "$out" != *" 9"* ]]'
check "with the brief: the shared opportunities" '[[ "$out" == *"In both the session and the brief: 2, 3."* ]]'
check "with the brief: a brief-only opportunity is listed by name" '[[ "$out" == *"From the brief only: 4 (the job photo log)."* ]]'
check "with the brief: nothing from the session only" '[[ "$out" == *"From the session only: none."* ]]'
check "with the brief: a missing fact becomes a week-one item" '[[ "$out" == *"Brief, opportunity 4 (the job photo log): no owner named; that becomes a week-one item."* ]]'
check "with the brief: no disagreement when they agree" '[[ "$out" != *"Disagreement"* ]]'
check "with the brief: ready, with every source named" '[[ "$out" == *"Ready: build from the transcript, with the intake and the brief beside it. Count each source in the report."* ]]'
check "with the brief: never prints the transcript's own lines" '[[ "$out" != *"Maria chases"* && "$out" != *"blank document"* ]]'

# --- ingest without the brief
rm package/roadmap-brief.md; run
check "without the brief: goes on (exit 0)" '[[ $rc -eq 0 ]]'
check "without the brief: says it is not there and that is fine" '[[ "$out" == *"Roadmap brief: not there (fine: the Caddy team sends one with some packages, not all)."* ]]'
check "without the brief: ready from the transcript and the intake" '[[ "$out" == *"Ready: build from the transcript, with the intake beside it."* ]]'
check "without the brief: no source comparison" '[[ "$out" != *"In both"* && "$out" != *"From the brief only"* ]]'

# --- a conflicting brief: a renamed opportunity, and a struck one still listed
brief
sed -i.bak -e 's/^### Blueprint opportunity 3: invoice follow-up, the full cycle/### Blueprint opportunity 3: invoice chasing/' \
  -e 's/^### Blueprint opportunity 4: the job photo log/### Blueprint opportunity 1: invoice follow-up/' package/roadmap-brief.md
rm -f package/roadmap-brief.md.bak; run
check "conflict: still goes on (exit 0)" '[[ $rc -eq 0 ]]'
check "conflict: a renamed opportunity is a disagreement and the session wins" '[[ "$out" == *"Disagreement: opportunity 3 is \"invoice follow-up, the full cycle\" in the session and \"invoice chasing\" in the brief. The session wins."* ]]'
check "conflict: a struck opportunity the brief still lists stays out" '[[ "$out" == *"Disagreement: the session struck opportunity 1; the brief still lists it (invoice follow-up). The session wins: it stays out."* ]]'
check "conflict: the struck one is not counted as brief-only" '[[ "$out" == *"From the brief only: none."* ]]'
check "conflict: the agreeing opportunity carries no disagreement line" '[[ "$out" != *"Disagreement: opportunity 2"* ]]'

# --- a brief alone (no transcript): refused plainly
brief; rm package/transcript.md; run
check "brief alone: stops (exit 2)" '[[ $rc -eq 2 ]]'
check "brief alone: says the brief alone is not enough" '[[ "$out" == *"Stop: the brief alone is not enough to build your plan."* ]]'
check "brief alone: asks for the transcript and names support" '[[ "$out" == *"Where is the transcript file?"*"support@meetcaddy.com"* ]]'
check "brief alone: still read the brief, so the owner knows it arrived" '[[ "$out" == *"Roadmap brief: roadmap-brief.md, written by the Caddy team"* ]]'
check "brief alone: no ready line" '[[ "$out" != *"Ready:"* ]]'

# --- other package states
rm package/roadmap-brief.md; run
check "empty package: stops and asks for the transcript" '[[ $rc -eq 2 && "$out" == *"Stop: the transcript of your session is not here yet."* ]]'
transcript; rm package/intake-doc.md; run
check "no intake: stops and asks for the intake document" '[[ $rc -eq 2 && "$out" == *"Stop: the intake document (intake-doc.md, your booking answers) is not here."* ]]'
intake; mv package/transcript.md "package/Blueprint Session.txt"; run
check "a transcript under another name is taken when it is the only other text file" '[[ $rc -eq 0 && "$out" == *"Transcript: Blueprint Session.txt ("*"taken as the transcript"* ]]'
cp "package/Blueprint Session.txt" package/notes.md; run
check "two candidate files: stops and asks which one" '[[ $rc -eq 2 && "$out" == *"not sure which file it is"* ]]'
rm package/notes.md; mv "package/Blueprint Session.txt" package/transcript.md
brief; sed -i.bak 's/| Dropbox | replace |/| Dropbox | maybe |/' package/roadmap-brief.md; rm -f package/roadmap-brief.md.bak; run
check "a brief with an unknown verdict is set aside with the reason, and the plan goes on" '[[ $rc -eq 0 && "$out" == *"could not be read: the verdict for Dropbox is \"maybe\"; it must be connect, replace or work around. It is set aside"* && "$out" == *"Ready: build from the transcript, with the intake beside it."* ]]'
brief; sed -i.bak '/^## Unconfirmed/,$d' package/roadmap-brief.md; rm -f package/roadmap-brief.md.bak; run
check "a brief missing a section is set aside with the reason" '[[ $rc -eq 0 && "$out" == *"the unconfirmed section is missing"* ]]'
brief; sed -i.bak 's/^\*\*Author:\*\* the Caddy team/**Author:** someone else/' package/roadmap-brief.md; rm -f package/roadmap-brief.md.bak; run
check "a brief not from the Caddy team is set aside" '[[ "$out" == *"the author line does not say the Caddy team"* ]]'
brief; run; check "the fixture brief itself reads clean again" '[[ "$out" == *"Roadmap brief: roadmap-brief.md, written by the Caddy team"* ]]'

# --- the brief stays out of git, like the transcript
git init -q . && git add -A >/dev/null 2>&1
check "git never keeps the brief or the transcript" '! git ls-files --error-unmatch package/roadmap-brief.md >/dev/null 2>&1 && ! git ls-files --error-unmatch package/transcript.md >/dev/null 2>&1'

# --- the template, the docs and the skill
tpl="$HERE/os/templates/roadmap-brief.md"
check "the template exists with its seven parts" '[[ -f "$tpl" ]] && grep -q "^## Their stack, for the record" "$tpl" && grep -q "^## Opportunities" "$tpl" && grep -q "^## Constraints, general" "$tpl" && grep -q "^## Phase 1 starts with" "$tpl" && grep -q "^## Access owners" "$tpl" && grep -q "^## Unconfirmed" "$tpl" && grep -q "^\*\*Author:\*\* the Caddy team" "$tpl"'
check "the templates index lists it" 'grep -q "roadmap-brief.md" "$HERE/os/templates/README.md"'
check "the ingest skill runs the check first and names the brief's rules" 'grep -q "python3 os/bin/package-check.py" "$HERE/.claude/skills/blueprint-ingest/SKILL.md" && grep -q "The transcript wins every disagreement" "$HERE/.claude/skills/blueprint-ingest/SKILL.md" && grep -q "A brief with no transcript is not enough" "$HERE/.claude/skills/blueprint-ingest/SKILL.md"'
check "the shipped settings allow the check" 'grep -q "Bash(python3 os/bin/package-check.py:\*)" "$HERE/.claude/settings.json"'
check "the package note and the manual tell the owner about the notes in plain words" 'grep -q "roadmap-brief.md" "$HERE/package/README.md" && grep -q "the Caddy team'"'"'s notes" "$HERE/HOW-IT-WORKS.md"'

# --- the state summary says what is in the package
rm -rf package/*; printf '# BUSINESS.md: Harbor Point Roofing\n\n## SESSION\n**Owner:** Sam\n' > BUSINESS.md
check "state summary: nothing in the package yet" '[[ "$(sh os/bin/state-summary.sh)" == *"Stage: installed, waiting for the package"* ]]'
intake
check "state summary: part of the package" '[[ "$(sh os/bin/state-summary.sh)" == *"Stage: installed, part of the package is here (the intake document), waiting for the transcript"* ]]'
transcript; brief
check "state summary: the whole package, notes included" '[[ "$(sh os/bin/state-summary.sh)" == *"Stage: installed, the package is here (the transcript, the intake document, the Caddy team'"'"'s notes): type /blueprint ingest"* ]]'
echo; echo "ingest tests: $pass passed, $fail failed"; [[ $fail -eq 0 ]]
