#!/usr/bin/env python3
"""What is in the package folder, and is it enough to build the plan?

/blueprint ingest runs this first:

    python3 os/bin/package-check.py [package folder]

It prints plain lines about the package files: the transcript of the session, the intake
document, and, when the Caddy team sent one, the roadmap brief (package/roadmap-brief.md).
It reads the brief's shape, lists the opportunities each source carries, and says where the
brief and the transcript disagree. The transcript always wins. A brief with no transcript is
never enough: the plan is built from the session.

Exit 0: go on; the lines say what to build from. Exit 2: stop, and say the "Stop:" line to
the owner. The script prints an opportunity's number and name, never a file's contents.
"""
import os
import re
import sys

TRANSCRIPT_NAMES = ("transcript.md", "transcript.txt", "transcript.vtt")
INTAKE = "intake-doc.md"
BRIEF = "roadmap-brief.md"
RECAP = "session-recap.md"
OWN_FILES = {"README.md", INTAKE, BRIEF, RECAP}
VERDICTS = ("connect", "replace", "work around")
NUMBER_WORDS = {w: i for i, w in enumerate(
    "one two three four five six seven eight nine ten eleven twelve thirteen fourteen fifteen "
    "sixteen seventeen eighteen nineteen twenty".split(), start=1)}

OPP_RE = re.compile(r"blueprint opportunity\s+(\d+|[a-z]+)\s*[:,]\s*([^.\n]+)", re.I)
STRIKE_RE = re.compile(r"strike opportunity\s+(\d+|[a-z]+)", re.I)
END_RE = re.compile(r"that'?s the blueprint", re.I)
HEADING_RE = re.compile(r"^###\s*blueprint opportunity\s+(\d+)\s*:\s*(.+?)\s*$", re.I)
GRANT_RE = re.compile(r"^(.+?)\s+can grant\s+(.+?)\.?$", re.I)
DATE_RE = re.compile(r"^\d{4}-\d{2}-\d{2}$")


def read(path):
    with open(path, encoding="utf-8", errors="replace") as f:
        return f.read().replace("\u2019", "'").replace("\u2018", "'")


def num(s):
    s = s.strip().lower()
    return int(s) if s.isdigit() else NUMBER_WORDS.get(s)


def plain(name):
    return re.sub(r"[^a-z0-9]+", " ", name.lower()).strip()


def same(a, b):
    a, b = plain(a), plain(b)
    return a == b or a in b or b in a


def plural(n, one, many=None):
    return "%d %s" % (n, one if n == 1 else (many or one + "s"))


def numbers(ns):
    return ", ".join(str(n) for n in sorted(ns)) if ns else "none"


# --- the transcript: which opportunities the session framed, and which it struck

def scan_transcript(text):
    flat = " ".join(line.strip() for line in text.splitlines())
    end = END_RE.search(flat)
    if end:
        flat = flat[:end.start()]
    framed, twice, struck = {}, set(), set()
    for m in OPP_RE.finditer(flat):
        n = num(m.group(1))
        if n is None:
            continue
        name = m.group(2).strip()
        if n in framed:
            if not same(framed[n], name):
                twice.add(n)
            continue
        framed[n] = name
    for m in STRIKE_RE.finditer(flat):
        n = num(m.group(1))
        if n is not None:
            struck.add(n)
    return framed, struck, twice


# --- the brief: its shape, and what it carries

def sections(text):
    out, current = {}, "_top"
    for line in text.splitlines():
        if line.startswith("## "):
            current = line[3:].strip().lower().rstrip(":")
            out.setdefault(current, [])
            continue
        out.setdefault(current, []).append(line)
    return out


def field(lines, label):
    m = re.compile(r"^\*\*%s:\*\*\s*(.*?)\s*$" % re.escape(label), re.I)
    for line in lines:
        hit = m.match(line.strip())
        if hit:
            return hit.group(1)
    return ""


def items(lines):
    out = []
    for line in lines:
        s = line.strip()
        if s.startswith(("- ", "* ")):
            s = s[2:].strip()
        elif re.match(r"^\d+\.\s", s):
            s = re.sub(r"^\d+\.\s*", "", s)
        elif not s or s.startswith("["):
            continue
        if s.lower().rstrip(".") in ("none", "nothing", "none spoken", "nothing yet"):
            continue
        out.append(s)
    return out


def parse_brief(text):
    sec = sections(text)
    problems = []
    top = sec.get("_top", [])
    business = field(top, "Business")
    session = field(top, "Session date")
    author = field(top, "Author")
    written = field(top, "Written")
    if not business:
        problems.append("the business line is missing")
    if not DATE_RE.match(session):
        problems.append("the session date is missing or not written as a date (YYYY-MM-DD)")
    if "caddy team" not in author.lower():
        problems.append("the author line does not say the Caddy team")
    if not DATE_RE.match(written):
        problems.append("the written-on date is missing or not written as a date (YYYY-MM-DD)")

    stack = []
    lines = sec.get("their stack, for the record")
    if lines is None:
        problems.append("the stack section is missing (Their stack, for the record)")
    else:
        rows = [l.strip() for l in lines if l.strip().startswith("|")]
        if len(rows) < 2:
            problems.append("the stack table is missing")
        else:
            head = [c.strip().lower() for c in rows[0].strip("|").split("|")]
            if head[:5] != ["system", "verdict", "plan", "version", "checked"]:
                problems.append("the stack table needs the columns System, Verdict, Plan, Version, Checked")
            for row in rows[2:]:
                cells = [c.strip() for c in row.strip("|").split("|")]
                if len(cells) < 5 or not cells[0] or cells[0].startswith("["):
                    continue
                verdict = cells[1].lower()
                if verdict not in VERDICTS:
                    problems.append('the verdict for %s is "%s"; it must be connect, replace or work around'
                                    % (cells[0], cells[1]))
                checked = cells[4]
                if not (DATE_RE.match(checked) or checked.lower() == "not checked"):
                    problems.append("the checked date for %s is not a date (YYYY-MM-DD) or the words not checked"
                                    % cells[0])
                stack.append({"system": cells[0], "verdict": verdict, "plan": cells[2],
                              "version": cells[3], "checked": checked})

    opps = {}
    lines = sec.get("opportunities")
    if lines is None:
        problems.append("the opportunities section is missing")
    else:
        current = None
        for line in lines:
            if line.startswith("### "):
                hit = HEADING_RE.match(line)
                if not hit:
                    problems.append('an opportunity heading has no number: "%s"' % line[4:].strip())
                    current = None
                    continue
                n = int(hit.group(1))
                if n in opps:
                    problems.append("opportunity %d appears twice" % n)
                current = opps.setdefault(n, {"name": hit.group(2), "body": []})
                continue
            if current is not None:
                current["body"].append(line.strip())
        for n, o in sorted(opps.items()):
            body = " ".join(l for l in o["body"] if l)
            o["body"] = body
            low = body.lower()
            o["missing"] = []
            if "today," not in low and "today " not in low:
                problems.append("opportunity %d has no Today sentence" % n)
            if "the machine should" not in low:
                problems.append("opportunity %d has no The machine should sentence" % n)
            if "that lives in" not in low:
                o["missing"].append("systems")
            if "owns this one" not in low:
                o["missing"].append("owner")
            o["phase"] = bool(re.search(r"\b(early|mid|late)-phase item", low))
            o["constraints"] = len(re.findall(r"constraint on opportunity %d\s*:" % n, low))
        if not opps:
            problems.append("the opportunities section has no numbered opportunity")

    general = items(sec.get("constraints, general", []))
    if "constraints, general" not in sec:
        problems.append("the general constraints section is missing (Constraints, general; write none when there are none)")

    lines = sec.get("phase 1 starts with")
    first = items(lines) if lines is not None else []
    if lines is None or not first:
        problems.append("the first move is missing (Phase 1 starts with)")

    grants = []
    lines = sec.get("access owners")
    if lines is None:
        problems.append("the access owners section is missing")
    else:
        for s in items(lines):
            hit = GRANT_RE.match(s)
            if hit:
                grants.append((hit.group(1), hit.group(2)))
            else:
                problems.append('an access owner line is not in the shape "[Name] can grant [system].": "%s"' % s)

    lines = sec.get("unconfirmed")
    unconfirmed = items(lines) if lines is not None else []
    if lines is None:
        problems.append("the unconfirmed section is missing (write nothing when there is nothing)")

    return {"business": business, "session": session, "written": written, "stack": stack, "opps": opps,
            "general": general, "first": first[0] if first else "", "grants": grants,
            "unconfirmed": unconfirmed}, problems


def main():
    folder = sys.argv[1] if len(sys.argv) > 1 else "package"
    out = []
    stop = []
    if not os.path.isdir(folder):
        print("Package folder: %s is not here." % folder)
        print("Stop: the package is not here yet. When your Blueprint package arrives by email from the "
              "Caddy team, save its files into the %s folder and type /blueprint ingest." % folder)
        return 2

    present = sorted(f for f in os.listdir(folder) if os.path.isfile(os.path.join(folder, f)))
    transcript = next((f for f in TRANSCRIPT_NAMES if f in present), None)
    if transcript is None:
        others = [f for f in present if f not in OWN_FILES and f.lower().endswith((".md", ".txt", ".vtt"))]
        if len(others) == 1:
            transcript = others[0]
        elif len(others) > 1:
            out.append("Transcript: not sure which file it is: %s." % ", ".join(others))
            stop.append("Stop: name the transcript of your session transcript.md (or tell me which file it is) "
                        "and type /blueprint ingest again.")
    has_intake = INTAKE in present
    has_brief = BRIEF in present
    has_recap = RECAP in present

    text = ""
    if transcript:
        text = read(os.path.join(folder, transcript))
        chars, words = len(text), len(text.split())
        line = "Transcript: %s (%s characters, about %s words)" % (transcript, format(chars, ","), format(words, ","))
        if transcript not in TRANSCRIPT_NAMES:
            line += ", taken as the transcript: the only other text file here"
        if words < 2000:
            line += "; short for a session, so ask once whether it is the right file"
        out.append(line + ".")
    elif not stop:
        out.append("Transcript: not there. I looked for transcript.md, transcript.txt or transcript.vtt in %s/."
                   % folder)
        if has_brief:
            stop.append("Stop: the brief alone is not enough to build your plan. The plan is built from the "
                        "transcript of your session; the Caddy team's brief only adds to it. Where is the "
                        "transcript file? It came in your Blueprint package email. If you cannot find it, email "
                        "support@meetcaddy.com and the Caddy team will resend it.")
        else:
            stop.append("Stop: the transcript of your session is not here yet. It came in your Blueprint package "
                        "email, as a text file. Save it into the %s folder and type /blueprint ingest again. "
                        "If you cannot find it, email support@meetcaddy.com and the Caddy team will resend it."
                        % folder)

    out.append("Intake document: %s" % (INTAKE if has_intake else "not there."))
    if not has_intake and not stop:
        stop.append("Stop: the intake document (intake-doc.md, your booking answers) is not here. It came in your "
                    "Blueprint package email. Save it into the %s folder and type /blueprint ingest again."
                    % folder)
    out.append("Session recap: %s" % (RECAP if has_recap else "not there (fine)."))

    brief, problems = None, []
    if has_brief:
        brief, problems = parse_brief(read(os.path.join(folder, BRIEF)))
        if problems:
            out.append("Roadmap brief: %s is there but could not be read: %s. It is set aside; the plan is built "
                       "from the transcript and the intake. The Caddy team can send a fixed one "
                       "(support@meetcaddy.com)." % (BRIEF, "; ".join(problems)))
            brief = None
        else:
            counts = {v: sum(1 for s in brief["stack"] if s["verdict"] == v) for v in VERDICTS}
            out.append("Roadmap brief: %s, written by the Caddy team on %s for %s (session %s): %s checked "
                       "(%d connect, %d replace, %d work around), %s, %s, the first move, %s, %s."
                       % (BRIEF, brief["written"], brief["business"], brief["session"],
                          plural(len(brief["stack"]), "system"), counts["connect"], counts["replace"],
                          counts["work around"], plural(len(brief["opps"]), "opportunity", "opportunities"),
                          plural(len(brief["general"]), "general constraint"),
                          plural(len(brief["grants"]), "access owner"),
                          plural(len(brief["unconfirmed"]), "unconfirmed item")))
            for n, o in sorted(brief["opps"].items()):
                if o["missing"]:
                    out.append("Brief, opportunity %d (%s): no %s named; %s a week-one item."
                               % (n, o["name"], " or ".join(o["missing"]),
                                  "each becomes" if len(o["missing"]) > 1 else "that becomes"))
    else:
        out.append("Roadmap brief: not there (fine: the Caddy team sends one with some packages, not all).")

    if stop:
        print("\n".join(out))
        print("\n".join(stop))
        return 2

    framed, struck, twice = scan_transcript(text)
    live = {n: name for n, name in framed.items() if n not in struck}
    line = "Opportunities framed in the session: %s" % numbers(framed)
    if struck:
        line += " (struck: %s)" % numbers(struck)
    out.append(line + ".")
    for n in sorted(twice):
        out.append("Note: the session uses the number %d for two different names; the first one is kept and the "
                   "second goes to the confirm list." % n)

    if brief:
        both = sorted(n for n in brief["opps"] if n in live)
        brief_only = sorted(n for n in brief["opps"] if n not in framed)
        session_only = sorted(n for n in live if n not in brief["opps"])
        out.append("In both the session and the brief: %s." % numbers(both))
        out.append("From the brief only: %s."
                   % (", ".join("%d (%s)" % (n, brief["opps"][n]["name"]) for n in brief_only) or "none"))
        out.append("From the session only: %s." % numbers(session_only))
        for n in both:
            if not same(framed[n], brief["opps"][n]["name"]):
                out.append('Disagreement: opportunity %d is "%s" in the session and "%s" in the brief. '
                           "The session wins." % (n, framed[n], brief["opps"][n]["name"]))
        for n in sorted(n for n in brief["opps"] if n in struck):
            out.append("Disagreement: the session struck opportunity %d; the brief still lists it (%s). "
                       "The session wins: it stays out." % (n, brief["opps"][n]["name"]))
        out.append("Ready: build from the transcript, with the intake and the brief beside it. Count each "
                   "source in the report.")
    else:
        out.append("Ready: build from the transcript, with the intake beside it.")
    print("\n".join(out))
    return 0


if __name__ == "__main__":
    sys.exit(main())
