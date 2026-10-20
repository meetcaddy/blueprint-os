#!/usr/bin/env python3
"""Read the intake document and say what each part of it becomes.

/blueprint ingest runs this after the package check:

    python3 os/bin/intake-read.py [path to the intake document] [--today YYYY-MM-DD]

The intake document always carries the booking answers under five headings (SESSION, BUSINESS
PROFILE, PAIN AND PRIORITIES, TECHNICAL READINESS, CLIENT NOTES). Since 2026-10-19 the Audit
Workbook renders it, so the document may also carry the Workbook's sections: SYSTEMS, TEAM,
MONEY AND VOLUME, WORKFLOWS, SAMPLES, CUSTOMERS AND COMMUNICATION, CONSTRAINTS, GOALS and GAPS.
An older document without them is complete; nothing is missing then, and this script says so
and prints nothing more.

What it prints, in plain blocks the ingest skill copies: the rows that seed SYSTEMS.md (each one
"not connected yet"), the lines for BUSINESS.md, the workflow candidates for the grounding gate
(never opportunities on their own) and the rows for WAITING-ON-YOU.md. It reads the document
and writes nothing. Exit 0 when the document was read, 2 when it is not there.
"""
import datetime
import os
import re
import sys

BOOKING = ("SESSION", "BUSINESS PROFILE", "PAIN AND PRIORITIES", "TECHNICAL READINESS", "CLIENT NOTES")
WORKBOOK = ("SYSTEMS", "TEAM", "MONEY AND VOLUME", "WORKFLOWS", "SAMPLES",
            "CUSTOMERS AND COMMUNICATION", "CONSTRAINTS", "GOALS", "GAPS")
EMPTY = ("(none listed)", "(none)", "(no files)")
MONEY = ("Revenue band", "Gross margin band", "Average job size", "Jobs a month", "Days to get paid",
         "Overtime hours a month")
CUSTOMERS = ("Lead sources", "First response", "Leads a week", "Channels", "What is sent and when")
CONSTRAINTS = ("Flags", "Details")
GOALS = ("12-month goal", "Exit horizon", "Who signs off on a build", "What done looks like")
NOT_GIVEN = "not given"

DASHES = "".join(chr(c) for c in (0x2014, 0x2013))  # the renderer's em dash, or an en dash; built here so this file carries none
TITLE_RE = re.compile(r"^#\s*BLUEPRINT INTAKE\s*(?:[" + DASHES + r"\-:])?\s*(.*?)\s*$", re.I)
FIELD_RE = re.compile(r"^\*\*(.+?):\*\*\s*(.*?)\s*$")
WORKFLOW_RE = re.compile(r"^###\s*(\d+)\.\s*(.*?)\s*$")
GAP_RE = re.compile(r"^(.+?):\s*(.+?)\s*\(feeds\s+(.+)\)\s*$")


def read(path):
    with open(path, encoding="utf-8", errors="replace") as f:
        return f.read()


# --- the shapes: headings, fields, tables, bullets

def sections(text):
    """The title line's business name, and {HEADING: [lines]} in document order."""
    business, out, current = "", {}, None
    for raw in text.splitlines():
        line = raw.rstrip()
        if current is None and not out:
            hit = TITLE_RE.match(line)
            if hit:
                business = hit.group(1)
                continue
        if line.startswith("## "):
            current = line[3:].strip().upper()
            out.setdefault(current, [])
            continue
        if current is not None:
            out[current].append(line)
    return business, out


def fields(lines):
    out = []
    for line in lines:
        hit = FIELD_RE.match(line.strip())
        if hit:
            out.append((hit.group(1).strip(), hit.group(2).strip()))
    return out


def field(lines, label):
    for name, value in fields(lines):
        if name.lower() == label.lower():
            return value
    return ""


def table(lines):
    """The first table: its header cells and its rows (lists of cells, blanks kept)."""
    rows, header, in_table = [], None, False
    for line in lines:
        s = line.strip()
        if s.startswith("|"):
            cells = [c.strip() for c in s.strip("|").split("|")]
            if header is None:
                header = cells
            elif all(re.fullmatch(r":?-{3,}:?", c) for c in cells if c) and any(c for c in cells):
                pass
            else:
                rows.append(cells)
            in_table = True
        elif in_table and s:
            break
    return header or [], rows


def bullets(lines):
    out = []
    for line in lines:
        s = line.strip()
        if s.startswith(("- ", "* ")):
            out.append(s[2:].strip())
    return out


def is_empty(lines):
    body = [l.strip() for l in lines if l.strip()]
    return not body or (len(body) == 1 and body[0] in EMPTY)


def cell(row, i):
    return row[i].strip() if i < len(row) else ""


# --- the document

def read_intake(text):
    business, sec = sections(text)
    doc = {"business": business, "booking": [h for h in BOOKING if h in sec],
           "workbook": [h for h in WORKBOOK if h in sec],
           "session_date": field(sec.get("SESSION", []), "Session date")}
    has = doc["workbook"]

    systems = []
    if "SYSTEMS" in has and not is_empty(sec["SYSTEMS"]):
        header, rows = table(sec["SYSTEMS"])
        for r in rows:
            if not cell(r, 0) or cell(r, 0).startswith("["):
                continue
            systems.append({"system": cell(r, 0), "kind": cell(r, 1), "plan": cell(r, 2), "version": cell(r, 3),
                            "runs": cell(r, 4), "admin": cell(r, 5), "cost": cell(r, 6), "renewal": cell(r, 7),
                            "export": cell(r, 8), "replace": cell(r, 9), "notes": cell(r, 10)})
    doc["systems"] = systems

    team = {"field": "", "payroll": "", "champion": "", "roles": []}
    if "TEAM" in has:
        lines = sec["TEAM"]
        team["field"] = field(lines, "People in the field")
        team["payroll"] = field(lines, "Office payroll, a month")
        team["champion"] = field(lines, "Champion")
        header, rows = table(lines)
        for r in rows:
            if cell(r, 0) and not cell(r, 0).startswith("["):
                team["roles"].append({"role": cell(r, 0), "people": cell(r, 1), "focus": cell(r, 2)})
    doc["team"] = team

    doc["money"] = [(label, field(sec["MONEY AND VOLUME"], label)) for label in MONEY] if "MONEY AND VOLUME" in has else []
    doc["customers"] = [(label, field(sec["CUSTOMERS AND COMMUNICATION"], label)) for label in CUSTOMERS] \
        if "CUSTOMERS AND COMMUNICATION" in has else []
    doc["constraints"] = [(label, field(sec["CONSTRAINTS"], label)) for label in CONSTRAINTS] if "CONSTRAINTS" in has else []
    doc["goals"] = [(label, field(sec["GOALS"], label)) for label in GOALS] if "GOALS" in has else []

    workflows = []
    if "WORKFLOWS" in has and not is_empty(sec["WORKFLOWS"]):
        current = None
        for line in sec["WORKFLOWS"]:
            hit = WORKFLOW_RE.match(line.strip())
            if hit:
                current = {"number": int(hit.group(1)), "name": hit.group(2) or "Untitled workflow",
                           "recording": "", "steps": [], "in_steps": False}
                workflows.append(current)
                continue
            if current is None:
                continue
            f = FIELD_RE.match(line.strip())
            if f and f.group(1).strip().lower() == "recording":
                current["recording"] = f.group(2).strip()
                current["in_steps"] = False
            elif f and f.group(1).strip().lower() == "steps":
                current["in_steps"] = True
                if f.group(2).strip():
                    current["steps"].append(f.group(2).strip())
            elif current["in_steps"] and line.strip():
                current["steps"].append(line.strip())
        for w in workflows:
            del w["in_steps"]
    doc["workflows"] = workflows

    samples = {"files": [], "none": ""}
    if "SAMPLES" in has:
        if not is_empty(sec["SAMPLES"]):
            header, rows = table(sec["SAMPLES"])
            for r in rows:
                if cell(r, 0) and not cell(r, 0).startswith("["):
                    samples["files"].append({"slot": cell(r, 0), "file": cell(r, 1), "size": cell(r, 2)})
        samples["none"] = field(sec["SAMPLES"], "Not available")
    doc["samples"] = samples

    gaps = []
    if "GAPS" in has and not is_empty(sec["GAPS"]):
        for b in bullets(sec["GAPS"]):
            hit = GAP_RE.match(b)
            if hit:
                gaps.append({"step": hit.group(1), "what": hit.group(2), "feeds": hit.group(3), "line": b})
            else:
                gaps.append({"step": "", "what": b, "feeds": "", "line": b})
    doc["gaps"] = gaps
    return doc


def plural(n, one, many=None):
    return "%d %s" % (n, one if n == 1 else (many or one + "s"))


def summary(doc):
    """One clause for the package check's intake line."""
    if not doc["workbook"]:
        return "the booking answers only; no Audit Workbook sections, which is fine for an older package"
    return "the booking answers and the Audit Workbook: %s, %s, %s, %s, %s" % (
        plural(len(doc["systems"]), "system"), plural(len(doc["team"]["roles"]), "office role"),
        plural(len(doc["workflows"]), "workflow"), plural(len(doc["samples"]["files"]), "file"),
        plural(len(doc["gaps"]), "gap"))


# --- what each part becomes

def given(value):
    return value if value else NOT_GIVEN


def ledger_rows(doc):
    since = ("%s, from the Audit Workbook" % doc["session_date"]) if doc["session_date"] else "from the Audit Workbook"
    rows = []
    for s in doc["systems"]:
        where = [p for p in (s["runs"], ", ".join(p for p in (s["plan"], ("version " + s["version"]) if s["version"] else "") if p)) if p]
        does = [s["kind"]]
        if s["cost"]:
            does.append("%s a month" % s["cost"])
        if s["renewal"]:
            does.append("renews %s" % s["renewal"])
        if s["export"]:
            does.append("export or API used: %s" % s["export"])
        if s["replace"]:
            does.append("would replace: %s" % s["replace"])
        if s["notes"]:
            does.append(s["notes"])
        rows.append("| %s | %s | %s | %s | not connected yet | %s |" % (
            s["system"], "; ".join(where) or "not said", s["admin"] or "not named",
            "; ".join(p for p in does if p) or "not said", since))
    return rows


def memory_lines(doc):
    out = []
    t = doc["team"]
    if "TEAM" in doc["workbook"]:
        out.append("TEAM:")
        out.append("- People in the field: %s" % given(t["field"]))
        out.append("- Office payroll, a month: %s" % given(t["payroll"]))
        out.append("- Champion: %s" % given(t["champion"]))
        for r in t["roles"]:
            out.append("- %s: %s%s" % (r["role"], given(r["people"]), (" (%s)" % r["focus"]) if r["focus"] else ""))
    if doc["money"] or any(label == "Leads a week" for label, _ in doc["customers"]):
        out.append("BASELINES:")
        for label, value in doc["money"]:
            if value.lower() == "not tracked":
                out.append("- %s: not tracked (no number known: measure it in week one)" % label)
            else:
                out.append("- %s: %s" % (label, given(value)))
        for label, value in doc["customers"]:
            if label == "Leads a week":
                out.append("- Leads a week: %s" % given(value))
    for heading, pairs in (("CUSTOMERS AND COMMUNICATION", doc["customers"]), ("CONSTRAINTS", doc["constraints"]),
                           ("GOALS", doc["goals"])):
        if heading in doc["workbook"]:
            out.append(heading + ":")
            for label, value in pairs:
                out.append("- %s: %s" % (label, given(value)))
    if "SAMPLES" in doc["workbook"]:
        out.append("NOTES:")
        files = ", ".join("%s (%s)" % (f["slot"], f["file"]) for f in doc["samples"]["files"]) or "none"
        line = "- Samples sent with the Workbook: %s." % files
        if doc["samples"]["none"]:
            line += " Not available: %s." % doc["samples"]["none"]
        line += " The files are with the Caddy team, not on this computer: ask the owner for copies into context/ at the Deep Dive."
        out.append(line)
    return out


def candidate_lines(doc):
    out = []
    for w in doc["workflows"]:
        parts = []
        if w["recording"]:
            parts.append("a recording (%s)" % w["recording"])
        parts.append(plural(len(w["steps"]), "written step") if w["steps"] else "no written steps")
        out.append("%d. %s: %s." % (w["number"], w["name"], ", ".join(parts)))
        for s in w["steps"]:
            out.append("   " + s)
    return out


def waiting_rows(doc, today, owner):
    return ["| %s | %s | %s | your Audit Workbook |" % (today, owner, g["line"]) for g in doc["gaps"]]


def owner_name(root):
    try:
        with open(os.path.join(root, "BUSINESS.md"), encoding="utf-8", errors="replace") as f:
            for line in f:
                hit = FIELD_RE.match(line.strip())
                if hit and hit.group(1).strip().lower() == "owner" and hit.group(2).strip():
                    return hit.group(2).strip()
    except OSError:
        pass
    return "the owner"


def main(argv):
    path, today = None, datetime.date.today().isoformat()
    args = list(argv)
    while args:
        a = args.pop(0)
        if a == "--today" and args:
            today = args.pop(0)
        else:
            path = a
    root = os.environ.get("CLAUDE_PROJECT_DIR") or os.getcwd()
    path = path or os.path.join("package", "intake-doc.md")
    if not os.path.isfile(path):
        print("Intake document: %s is not here." % path)
        print("Stop: the intake document (intake-doc.md, your booking answers) is not here. It came in your "
              "Blueprint package email. Save it into the package folder and type /blueprint ingest again.")
        return 2
    doc = read_intake(read(path))
    head = "Intake document: %s" % path
    if doc["business"]:
        head += ": %s" % doc["business"]
    if doc["session_date"]:
        head += ", session %s" % doc["session_date"]
    print(head + ".")
    print("Booking answers: %s." % ("here (%s)" % plural(len(doc["booking"]), "heading") if doc["booking"]
                                     else "the five headings are missing; read the file by hand"))
    if not doc["workbook"]:
        print("Audit Workbook: not in this document (an older package; nothing is missing).")
        return 0
    print("Audit Workbook: here: %s." % summary(doc).split(": ", 1)[1])

    rows = ledger_rows(doc)
    print("")
    print("== Systems ledger rows (SYSTEMS.md, every one not connected yet) ==")
    print("\n".join(rows) if rows else "(no systems listed)")
    print("")
    print("== Business memory (BUSINESS.md) ==")
    print("\n".join(memory_lines(doc)) or "(nothing beyond the booking answers)")
    print("")
    print("== Workflow candidates (for the grounding gate; never opportunities on their own) ==")
    cands = candidate_lines(doc)
    print("\n".join(cands) if cands else "(no workflows written up)")
    print("")
    print("== Waiting on you (WAITING-ON-YOU.md rows, one per gap) ==")
    gaps = waiting_rows(doc, today, owner_name(root))
    print("\n".join(gaps) if gaps else "(no gaps: the owner filled in every step)")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
