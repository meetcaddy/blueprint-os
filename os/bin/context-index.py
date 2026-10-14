#!/usr/bin/env python3
"""context-index.py: list what is in the drop folder and write context/INDEX.md.

    python3 os/bin/context-index.py             rewrite INDEX.md and remember what was seen
    python3 os/bin/context-index.py --summary   print the one-line summary only; change nothing

Never prints or copies a file's contents. A file that looks like a key or password file is named
and skipped, never read. A readable file that holds something that looks like a key is named with
its line number and not used. The "What your Caddy learned" and "What would help next" sections of
INDEX.md are kept exactly as they were; your Caddy writes those, this script only lists.
"""
import datetime
import importlib.util
import json
import os
import re
import sys

ROOT = os.environ.get("CLAUDE_PROJECT_DIR") or os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
CTX = os.path.join(ROOT, "context")
INDEX = os.path.join(CTX, "INDEX.md")
SEEN = os.path.join(CTX, ".seen.json")

SLOTS = [
    ("how-we-work", "SOPs, checklists, process documents"),
    ("people", "the org chart, who does what"),
    ("money", "the P&L, pricing, estimates, invoices"),
    ("customers", "real jobs start to finish, sample quotes"),
    ("tools", "screenshots, exports, reports"),
    ("recordings", "videos, voice memos, screen recordings"),
    ("anything-else", "whatever did not fit"),
]
SKIP_NAMES = {"README.md", "INDEX.md", "WHAT-GOES-HERE.md", ".DS_Store", ".seen.json", "Thumbs.db"}
NAME_FLAGS = re.compile(
    r"(^\.env($|\.)|\.pem$|\.key$|\.p12$|\.pfx$|\.kdbx$|\.keychain|^id_(rsa|ed25519|ecdsa|dsa)"
    r"|passw(or)?d|credential|secret|\btoken|api[-_]?key)", re.I)
CONTENT_FLAGS = [
    re.compile(r"-----BEGIN [A-Z ]*PRIVATE KEY-----"),
    re.compile(r"\b(sk|rk)-[A-Za-z0-9_-]{20,}"),
    re.compile(r"\bAKIA[0-9A-Z]{16}\b"),
    re.compile(r"\bxox[abprs]-[A-Za-z0-9-]{10,}"),
    re.compile(r"\bgh[pousr]_[A-Za-z0-9]{30,}"),
    re.compile(r"(?i)\b(api[_ -]?key|secret|password|passwd|token)\b\s*[:=]\s*\S{8,}"),
]
PII_HINT = re.compile(r"\b\d{3}-\d{2}-\d{4}\b")
TRANSCRIPT_EXT = (".txt", ".md", ".vtt", ".srt")
LEARNED_START, LEARNED_END = "<!-- learned:start -->", "<!-- learned:end -->"
MISSING_START, MISSING_END = "<!-- missing:start -->", "<!-- missing:end -->"
LEARNED_DEFAULT = "## What your Caddy learned\n\n(nothing yet: type /blueprint context and your Caddy reads what is new)\n"
MISSING_DEFAULT = "## What would help next\n\n(your Caddy fills this in as it reads)\n"


def load_extractor():
    spec = importlib.util.spec_from_file_location("extract_text", os.path.join(ROOT, "os", "bin", "extract_text.py"))
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def human(n):
    if n < 1024:
        return "%d B" % n
    if n < 1024 * 1024:
        return "%d KB" % round(n / 1024)
    return "%.1f MB" % (n / (1024 * 1024))


def scan_text(text):
    """Return ('key', line) if something key-like appears, ('pii', line) for ID-number hints, else None."""
    for i, line in enumerate(text.split("\n"), 1):
        for pat in CONTENT_FLAGS:
            if pat.search(line):
                return ("key", i)
    for i, line in enumerate(text.split("\n"), 1):
        if PII_HINT.search(line):
            return ("pii", i)
    return None


def gather(extractor):
    items = []
    if not os.path.isdir(CTX):
        return items
    for dirpath, dirnames, filenames in os.walk(CTX):
        dirnames[:] = sorted(d for d in dirnames if not d.startswith("."))
        for fn in sorted(filenames):
            if fn in SKIP_NAMES:
                continue
            if fn.startswith(".") and not NAME_FLAGS.search(fn):
                continue  # hidden machine files are skipped; a hidden key file is still named
            path = os.path.join(dirpath, fn)
            rel = os.path.relpath(path, CTX)
            parts = rel.split(os.sep)
            slot = parts[0] if len(parts) > 1 else "(top level)"
            try:
                st = os.stat(path)
            except OSError:
                continue
            size, mtime = st.st_size, int(st.st_mtime)
            item = {"rel": rel, "slot": slot, "size": size, "mtime": mtime, "flag": None, "kind": None}
            if NAME_FLAGS.search(fn):
                item["kind"] = "flagged"
                item["status"] = "waiting on you: looks like a key or password file. Please remove it. Not read."
                item["flag"] = "key-name"
                items.append(item)
                continue
            k = extractor.kind(path)
            item["kind"] = k
            if size == 0:
                item["status"] = "empty file"
            elif k in ("text", "docx", "xlsx", "pptx", "office"):
                try:
                    text = extractor.extract(path)
                except extractor.Unreadable as exc:
                    item["status"] = "unreadable (%s)" % exc
                else:
                    hit = scan_text(text)
                    if hit and hit[0] == "key":
                        item["status"] = ("waiting on you: line %d looks like a key or password. "
                                          "Please take it out or remove the file. Not used." % hit[1])
                        item["flag"] = "key-content"
                    elif hit and hit[0] == "pii":
                        item["status"] = "readable; may hold personal ID numbers (line %d): your Caddy asks before using it" % hit[1]
                        item["flag"] = "pii"
                    else:
                        item["status"] = "readable"
            elif k in ("pdf", "image"):
                item["status"] = "read directly by the app"
            elif k == "recording":
                stem = os.path.splitext(path)[0]
                if any(os.path.isfile(stem + e) for e in TRANSCRIPT_EXT):
                    item["status"] = "recording with a transcript next to it"
                else:
                    item["status"] = "recording: needs a transcript"
            else:
                item["status"] = "listed, not read (a kind of file your Caddy does not read)"
            items.append(item)
    return items


def load_seen():
    try:
        with open(SEEN, encoding="utf-8") as fh:
            return json.load(fh)
    except Exception:
        return {}


def save_seen(items):
    data = {it["rel"]: [it["size"], it["mtime"]] for it in items}
    tmp = SEEN + ".tmp"
    with open(tmp, "w", encoding="utf-8") as fh:
        json.dump(data, fh, indent=1, sort_keys=True)
    os.replace(tmp, SEEN)


def keep_block(old, start, end, default):
    if old and start in old and end in old:
        return old.split(start, 1)[1].split(end, 1)[0].strip("\n") + "\n"
    return default


def summary_line(items):
    readable = sum(1 for i in items if i["status"].startswith("readable"))
    direct = sum(1 for i in items if i["status"].startswith("read directly"))
    transcript = sum(1 for i in items if i["status"].startswith("recording: needs"))
    waiting = sum(1 for i in items if i["flag"] in ("key-name", "key-content"))
    new = sum(1 for i in items if i.get("new"))
    slots = len({i["slot"] for i in items})
    if not items:
        return "context: the drop folder is empty"
    return ("context: %d item(s) in %d slot(s); %d readable, %d read directly, %d need a transcript, "
            "%d waiting on you; %d new since the last index" % (len(items), slots, readable, direct, transcript, waiting, new))


def write_index(items):
    old = ""
    try:
        with open(INDEX, encoding="utf-8") as fh:
            old = fh.read()
    except OSError:
        pass
    learned = keep_block(old, LEARNED_START, LEARNED_END, LEARNED_DEFAULT)
    missing = keep_block(old, MISSING_START, MISSING_END, MISSING_DEFAULT)
    today = datetime.date.today().isoformat()
    lines = ["# INDEX.md: what is in your drop folder", "",
             "> Written by your Caddy on %s. It lists what is here and what your Caddy learned, never the contents." % today,
             "> Drop more any time, then type /blueprint context.", ""]
    lines.append("**" + summary_line(items).replace("context: ", "") + ".**")
    lines.append("")
    waiting = [i for i in items if i["flag"] in ("key-name", "key-content")]
    sensitive = [i for i in items if i["flag"] == "pii"]
    if waiting or sensitive:
        lines.append("## Waiting on you")
        lines.append("")
        for i in waiting:
            lines.append("- `%s`: %s" % (i["rel"], i["status"]))
        for i in sensitive:
            lines.append("- `%s`: %s" % (i["rel"], i["status"]))
        lines.append("")
    lines.append("## By slot")
    lines.append("")
    by_slot = {}
    for i in items:
        by_slot.setdefault(i["slot"], []).append(i)
    order = [s for s, _ in SLOTS] + sorted(s for s in by_slot if s not in {s for s, _ in SLOTS})
    hints = dict(SLOTS)
    for slot in order:
        rows = by_slot.get(slot, [])
        lines.append("### %s" % slot + (" (%s)" % hints[slot] if slot in hints else ""))
        lines.append("")
        if not rows:
            lines.append("nothing here yet")
            lines.append("")
            continue
        lines.append("| File | Size | Dropped | Status |")
        lines.append("|---|---|---|---|")
        for i in rows:
            name = i["rel"].split(os.sep, 1)[1] if slot != "(top level)" else i["rel"]
            dropped = datetime.date.fromtimestamp(i["mtime"]).isoformat()
            status = i["status"] + (" (new)" if i.get("new") else "")
            lines.append("| `%s` | %s | %s | %s |" % (name, human(i["size"]), dropped, status))
        lines.append("")
    lines.append(LEARNED_START)
    lines.append(learned.rstrip("\n"))
    lines.append(LEARNED_END)
    lines.append("")
    lines.append(MISSING_START)
    lines.append(missing.rstrip("\n"))
    lines.append(MISSING_END)
    lines.append("")
    tmp = INDEX + ".tmp"
    with open(tmp, "w", encoding="utf-8") as fh:
        fh.write("\n".join(lines))
    os.replace(tmp, INDEX)


def main(argv):
    summary_only = "--summary" in argv
    if not os.path.isdir(CTX):
        print("context: there is no drop folder in this workspace yet")
        return 0
    extractor = load_extractor()
    items = gather(extractor)
    seen = load_seen()
    for it in items:
        prev = seen.get(it["rel"])
        it["new"] = prev != [it["size"], it["mtime"]]
    print(summary_line(items))
    if summary_only:
        return 0
    write_index(items)
    save_seen(items)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
