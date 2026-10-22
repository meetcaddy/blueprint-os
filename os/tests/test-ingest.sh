#!/usr/bin/env bash
# Tests for the package check /blueprint ingest runs first: the three package files, the Caddy
# team's roadmap brief read beside the transcript, the transcript winning every disagreement, the
# brief alone refused plainly, the Audit Workbook's sections in the intake document read by
# os/bin/intake-read.py (the sample document is the one the Workbook's own renderer test builds,
# a made-up roofing business), and the state summary saying what is in the package. Throwaway
# folders only; no fixture is a client.
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
T="$(mktemp -d)"; trap 'rm -rf "$T"' EXIT
pass=0; fail=0
ok(){ pass=$((pass+1)); echo "PASS  $1"; }; bad(){ fail=$((fail+1)); echo "FAIL  $1"; }
check(){ if eval "$2"; then ok "$1"; else bad "$1"; fi; }
mkdir -p "$T/os/bin" "$T/os/templates" "$T/package"
cp "$HERE/os/bin/package-check.py" "$HERE/os/bin/state-summary.sh" "$HERE/os/bin/intake-read.py" "$T/os/bin/"
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

# --- the Audit Workbook's sections in the intake document (the sample from caddy-app's render.test.ts)
# The title line carries the renderer's em dash, written as an escape so this file carries none.
workbook_intake(){ printf '# BLUEPRINT INTAKE \342\200\224 Summit Ridge Roofing\n' > package/intake-doc.md; cat >> package/intake-doc.md <<'EOF'

## SESSION
**Session date:** 2026-11-03
**Attendees:** Mike (owner), Dana (office manager)
**Operations seat:** Dana, office manager

## BUSINESS PROFILE
**What the business does:** Residential roofing. Insurance restoration.
**Team:** 22 people
**Tools and systems:** QuickBooks Desktop and Enterprise, AccuLynx, Some Local Tool

## PAIN AND PRIORITIES
**Biggest time sinks:** Re-keying jobs
**Hand-off-tomorrow job:** Supplements
**Prior attempts and roadblocks:** Zapier, broke
**Baselines:** 38 jobs a month; average job $14,500; 47 days to get paid; overtime not tracked; 13 in the field

## TECHNICAL READINESS
**OS:** Windows
**Company-managed device:** no
**Admin rights:** yes
**AI plan status:** confirmed
**GitHub account:** no

## CLIENT NOTES
**Requested topics:** Estimates take two days

## SYSTEMS
| System | Kind | Plan or edition | Version | Runs | Administered by | Monthly cost | Renewal | Export or API used | Would replace | Notes |
|---|---|---|---|---|---|---|---|---|---|---|
| QuickBooks Desktop and Enterprise | Accounting and job cost | Enterprise | 2024 | Desktop | Office manager | $210 | 2027-03-01 | no | depends | Payroll / runs through it |
| AccuLynx | CRM and sales | Pro Bundle |  | Cloud |  |  |  |  |  |  |
| Some Local Tool | CRM and sales |  |  |  |  |  |  |  |  |  |

## TEAM
**People in the field:** 13
**Office payroll, a month:** $25K to $50K
**Champion:** Dana

| Role | People | What they spend most time on |
|---|---|---|
| Office manager | 1 | Billing |
| Permit runner | 1 |  |

## MONEY AND VOLUME
**Revenue band:** $3M to $10M
**Gross margin band:** 30% to 40%
**Average job size:** $14,500
**Jobs a month:** 38
**Days to get paid:** 47
**Overtime hours a month:** not tracked

## WORKFLOWS

### 1. Lead to signed proposal
**Recording:** https://www.loom.com/share/x

### 2. Job close to paid invoice
**Steps:**
1. Luis marks complete
2. Dana invoices
3. Call at day 30

## SAMPLES
| Slot | File | Size |
|---|---|---|
| An estimate | Estimate-1142.pdf | 402 KB |
| System screenshot | qb-billing.png | 402 KB |

**Not available:** Safety program

## CUSTOMERS AND COMMUNICATION
**Lead sources:** Phone calls, Referrals
**First response:** Dana
**Leads a week:** 25
**Channels:** Text, Phone
**What is sent and when:** Estimate within two days

## CONSTRAINTS
**Flags:** Union rules
**Details:** Two public jobs a year

## GOALS
**12-month goal:** Get to $8M
**Exit horizon:** 3 to 5 years
**Who signs off on a build:** Chris
**What done looks like:** No re-keying
**Priorities, in order:** Enterprise value; Fewer people, or growth without adding people; More output and better quality

## GAPS
- Workflows: 2 of 5 workflows (feeds the gap hunt covers only what you showed us)
- Samples: No proposal (feeds proposal automation)
- Samples: No invoice (feeds the collections design)
- Samples: No wip or job-cost report (feeds the job-cost lag check before the call)
- Samples: No cost codes or chart of accounts (feeds the accounting link)
- Constraints: Skipped for now (feeds the constraints every design must honor)
EOF
}
readit(){ rout="$(python3 os/bin/intake-read.py --today 2026-10-19 "$@" 2>&1)"; rrc=$?; }
rm -f package/roadmap-brief.md; transcript; workbook_intake; run
check "workbook: the package check counts the Workbook's parts and nothing more" '[[ $rc -eq 0 && "$out" == *"Intake document: intake-doc.md (the booking answers and the Audit Workbook: 3 systems, 2 office roles, 2 workflows, 2 files, 6 gaps)."* ]]'
check "workbook: the package check still never prints a value from the document" '[[ "$out" != *"25K"* && "$out" != *"QuickBooks"* ]]'
check "workbook: the sample keeps the five booking headings first, in the contract's order" '[[ "$(grep "^## " package/intake-doc.md | head -5 | tr "\n" "/")" == "## SESSION/## BUSINESS PROFILE/## PAIN AND PRIORITIES/## TECHNICAL READINESS/## CLIENT NOTES/" ]]'
check "workbook: the Workbook sections follow, in the contract's order" '[[ "$(grep "^## " package/intake-doc.md | tail -9 | tr "\n" "/")" == "## SYSTEMS/## TEAM/## MONEY AND VOLUME/## WORKFLOWS/## SAMPLES/## CUSTOMERS AND COMMUNICATION/## CONSTRAINTS/## GOALS/## GAPS/" ]]'
printf '# BUSINESS.md: Summit Ridge Roofing\n\n## SESSION\n**Owner:** Mike\n' > BUSINESS.md
readit
check "reader: reads the business and the session date from the title and SESSION" '[[ $rrc -eq 0 && "$rout" == *"Intake document: package/intake-doc.md: Summit Ridge Roofing, session 2026-11-03."* ]]'
check "reader: says the Workbook is there, with its counts" '[[ "$rout" == *"Audit Workbook: here: 3 systems, 2 office roles, 2 workflows, 2 files, 6 gaps."* ]]'
check "reader: a full systems row seeds the ledger, not connected yet, dated from the session" '[[ "$rout" == *"| QuickBooks Desktop and Enterprise | Desktop; Enterprise, version 2024 | Office manager | Accounting and job cost; \$210 a month; renews 2027-03-01; export or API used: no; would replace: depends; Payroll / runs through it | not connected yet | 2026-11-03, from the Audit Workbook |"* ]]'
check "reader: the raw plan text wins and blank cells read not named" '[[ "$rout" == *"| AccuLynx | Cloud; Pro Bundle | not named | CRM and sales | not connected yet |"* ]]'
check "reader: a nearly empty row still seeds a line" '[[ "$rout" == *"| Some Local Tool | not said | not named | CRM and sales | not connected yet |"* ]]'
check "reader: every ledger row is not connected yet" '[[ "$(printf "%s\n" "$rout" | grep -c "^| .* | not connected yet | ")" -eq 3 ]]'
check "reader: the team lines, roles with headcounts only" '[[ "$rout" == *"TEAM:"$'"'"'\n'"'"'"- People in the field: 13"$'"'"'\n'"'"'"- Office payroll, a month: \$25K to \$50K"$'"'"'\n'"'"'"- Champion: Dana"$'"'"'\n'"'"'"- Office manager: 1 (Billing)"$'"'"'\n'"'"'"- Permit runner: 1"* ]]'
check "reader: not tracked stays not tracked and becomes a week-one measurement" '[[ "$rout" == *"- Overtime hours a month: not tracked (no number known: measure it in week one)"* ]]'
check "reader: the money lines and the leads a week land in BASELINES" '[[ "$rout" == *"BASELINES:"*"- Revenue band: \$3M to \$10M"*"- Days to get paid: 47"*"- Leads a week: 25"* ]]'
check "reader: customers, constraints and goals get their own blocks" '[[ "$rout" == *"CUSTOMERS AND COMMUNICATION:"*"- What is sent and when: Estimate within two days"*"CONSTRAINTS:"*"- Flags: Union rules"*"GOALS:"*"- Who signs off on a build: Chris"*"- Priorities, in order: Enterprise value; Fewer people, or growth without adding people; More output and better quality"* ]]'
check "reader: the samples go to NOTES by name, with what is not available" '[[ "$rout" == *"- Samples sent with the Workbook: An estimate (Estimate-1142.pdf), System screenshot (qb-billing.png). Not available: Safety program."* ]]'
check "reader: workflows are candidates, with the recording or the steps" '[[ "$rout" == *"never opportunities on their own"*"1. Lead to signed proposal: a recording (https://www.loom.com/share/x), no written steps."*"2. Job close to paid invoice: 3 written steps."*"   2. Dana invoices"* ]]'
check "reader: never frames a workflow as an opportunity" '[[ "$rout" != *"Blueprint opportunity"* && "$rout" != *"opportunity 1"* ]]'
check "reader: one waiting row per gap, dated today, to the owner by name, from the Workbook" '[[ "$(printf "%s\n" "$rout" | grep -c "| your Audit Workbook |$")" -eq 6 && "$rout" == *"| 2026-10-19 | Mike | Workflows: 2 of 5 workflows (feeds the gap hunt covers only what you showed us) | your Audit Workbook |"* ]]'
check "reader: the last gap row is the skipped step" '[[ "$rout" == *"| 2026-10-19 | Mike | Constraints: Skipped for now (feeds the constraints every design must honor) | your Audit Workbook |"* ]]'
rm BUSINESS.md; readit
check "reader: with no owner recorded yet the rows say the owner" '[[ "$rout" == *"| 2026-10-19 | the owner | Samples: No proposal (feeds proposal automation) | your Audit Workbook |"* ]]'
intake; readit
check "reader: an older intake document is complete and prints nothing more" '[[ $rrc -eq 0 && "$rout" == *"Audit Workbook: not in this document (an older package; nothing is missing)."* && "$rout" != *"=="* ]]'
run
check "workbook: the package check says an older document is fine" '[[ $rc -eq 0 && "$out" == *"Intake document: intake-doc.md (the booking answers only; no Audit Workbook sections, which is fine for an older package)."* ]]'
printf '# BLUEPRINT INTAKE: Bare Co\n\n## SESSION\n**Session date:** 2026-08-08\n\n## SYSTEMS\n(none listed)\n\n## TEAM\n**People in the field:** \n**Office payroll, a month:** Prefer not to say\n**Champion:** \n\n## WORKFLOWS\n(none)\n\n## SAMPLES\n(no files)\n\n## GAPS\n(none)\n' > package/intake-doc.md; readit
check "reader: empty Workbook sections count zero and print their empty lines" '[[ $rrc -eq 0 && "$rout" == *"Audit Workbook: here: 0 systems, 0 office roles, 0 workflows, 0 files, 0 gaps."* && "$rout" == *"(no systems listed)"* && "$rout" == *"(no workflows written up)"* && "$rout" == *"(no gaps: the owner filled in every step)"* ]]'
check "reader: a blank field reads not given, a range is kept as written" '[[ "$rout" == *"- People in the field: not given"* && "$rout" == *"- Office payroll, a month: Prefer not to say"* ]]'
rm package/intake-doc.md; readit
check "reader: a missing document stops with the plain line" '[[ $rrc -eq 2 && "$rout" == *"Stop: the intake document (intake-doc.md, your booking answers) is not here."* ]]'
intake
check "the ingest skill runs the reader and names what each section becomes" 'grep -q "python3 os/bin/intake-read.py" "$HERE/.claude/skills/blueprint-ingest/SKILL.md" && grep -q "SYSTEMS seeds the systems ledger" "$HERE/.claude/skills/blueprint-ingest/SKILL.md" && grep -q "never opportunities on their" "$HERE/.claude/skills/blueprint-ingest/SKILL.md" && grep -q "GAPS go on the short list" "$HERE/.claude/skills/blueprint-ingest/SKILL.md"'
check "the shipped settings allow the reader" 'grep -q "Bash(python3 os/bin/intake-read.py:\*)" "$HERE/.claude/settings.json"'
check "the ledger template, its index, the waiting list and the manual know the Workbook" 'grep -q "not connected yet" "$HERE/os/templates/SYSTEMS.md" && grep -q "/blueprint ingest" "$HERE/os/templates/README.md" && grep -q "your Audit Workbook" "$HERE/os/templates/WAITING-ON-YOU.md" && grep -q "Audit Workbook" "$HERE/HOW-IT-WORKS.md" && grep -q "Audit Workbook" "$HERE/package/README.md"'

# --- the state summary says what is in the package
rm -rf package/*; printf '# BUSINESS.md: Harbor Point Roofing\n\n## SESSION\n**Owner:** Sam\n' > BUSINESS.md
check "state summary: nothing in the package yet" '[[ "$(sh os/bin/state-summary.sh)" == *"Stage: installed, waiting for the package"* ]]'
intake
check "state summary: part of the package" '[[ "$(sh os/bin/state-summary.sh)" == *"Stage: installed, part of the package is here (the intake document), waiting for the transcript"* ]]'
transcript; brief
check "state summary: the whole package, notes included" '[[ "$(sh os/bin/state-summary.sh)" == *"Stage: installed, the package is here (the transcript, the intake document, the Caddy team'"'"'s notes): type /blueprint ingest"* ]]'
echo; echo "ingest tests: $pass passed, $fail failed"; [[ $fail -eq 0 ]]
