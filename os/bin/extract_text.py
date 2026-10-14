#!/usr/bin/env python3
"""extract_text.py: turn a dropped file into plain text, with nothing but the standard library.

Your Caddy runs this to read what you dropped. It prints the text and writes nothing to disk.

    python3 os/bin/extract_text.py <file>           print the file's text
    python3 os/bin/extract_text.py --kind <file>    print only the kind of file
    python3 os/bin/extract_text.py <file> --from 301 --count 300   print one part of a long file (lines)

Kinds: text (read as it is), docx, xlsx, pptx, office (read through the Mac's own converter),
pdf and image (the app reads those directly), recording (needs a transcript), unknown.
Exit codes: 0 text printed; 3 the app reads it directly; 4 a recording; 5 an unknown kind;
6 unreadable (empty, protected or damaged).
"""
import html
import os
import re
import subprocess
import sys
import zipfile
from xml.etree import ElementTree as ET

MAX_CHARS = 250_000
CUT_NOTE = "\n\n[cut here: the file is longer than your Caddy reads in one go; ask for a specific part]\n"

TEXT_EXT = {".txt", ".md", ".markdown", ".csv", ".tsv", ".json", ".yaml", ".yml", ".log", ".xml",
            ".ini", ".cfg", ".toml", ".vtt", ".srt", ".eml"}
HTML_EXT = {".html", ".htm"}
OFFICE_VIA_TEXTUTIL = {".rtf", ".rtfd", ".doc", ".odt", ".webarchive"}
PDF_EXT = {".pdf"}
IMAGE_EXT = {".png", ".jpg", ".jpeg", ".gif", ".webp"}
IMAGE_EXPORT_EXT = {".heic", ".heif", ".bmp", ".tif", ".tiff", ".psd", ".svg"}
OLD_OFFICE_EXT = {".xls", ".ppt", ".pages", ".numbers"}
RECORDING_EXT = {".mp4", ".mov", ".m4v", ".mkv", ".avi", ".webm", ".m4a", ".mp3", ".wav", ".aac",
                 ".ogg", ".flac", ".aiff", ".aif", ".caf", ".wma"}

NS_W = "{http://schemas.openxmlformats.org/wordprocessingml/2006/main}"
NS_A = "{http://schemas.openxmlformats.org/drawingml/2006/main}"
NS_S = "{http://schemas.openxmlformats.org/spreadsheetml/2006/main}"
NS_R = "{http://schemas.openxmlformats.org/officeDocument/2006/relationships}"
NS_PR = "{http://schemas.openxmlformats.org/package/2006/relationships}"

EXIT_DIRECT, EXIT_RECORDING, EXIT_UNKNOWN, EXIT_UNREADABLE = 3, 4, 5, 6


class Unreadable(Exception):
    """The file is empty, protected or damaged."""


def kind(path):
    """Classify a file by its extension; a file with no extension is sniffed for plain text."""
    ext = os.path.splitext(path)[1].lower()
    if ext in TEXT_EXT or ext in HTML_EXT:
        return "text"
    if ext == ".docx":
        return "docx"
    if ext in (".xlsx", ".xlsm"):
        return "xlsx"
    if ext == ".pptx":
        return "pptx"
    if ext in OFFICE_VIA_TEXTUTIL:
        return "office"
    if ext in PDF_EXT:
        return "pdf"
    if ext in IMAGE_EXT:
        return "image"
    if ext in IMAGE_EXPORT_EXT:
        return "image-export"
    if ext in OLD_OFFICE_EXT:
        return "old-office"
    if ext == ".key":
        try:
            with open(path, "rb") as fh:
                head = fh.read(4)
            return "keynote" if head.startswith(b"PK") else "unknown"
        except Exception:
            return "unknown"
    if ext in RECORDING_EXT:
        return "recording"
    if ext == "":
        try:
            with open(path, "rb") as fh:
                head = fh.read(4096)
            if head and b"\x00" not in head:
                head.decode("utf-8")
                return "text"
        except Exception:
            pass
    return "unknown"


def _decode(data):
    for enc in ("utf-8-sig", "utf-8", "cp1252", "latin-1"):
        try:
            return data.decode(enc)
        except UnicodeDecodeError:
            continue
    return data.decode("utf-8", errors="replace")


def read_text(path):
    with open(path, "rb") as fh:
        data = fh.read(MAX_CHARS * 4)
    text = _decode(data)
    if os.path.splitext(path)[1].lower() in HTML_EXT:
        text = re.sub(r"(?is)<(script|style).*?</\1>", " ", text)
        text = re.sub(r"(?s)<[^>]+>", " ", text)
        text = html.unescape(text)
        text = re.sub(r"[ \t]+", " ", text)
        text = re.sub(r"\n\s*\n+", "\n\n", text)
    return text


def _para_text(p):
    parts = []
    for el in p.iter():
        if el.tag == NS_W + "t":
            parts.append(el.text or "")
        elif el.tag == NS_W + "tab":
            parts.append("\t")
        elif el.tag == NS_W + "br":
            parts.append("\n")
    return "".join(parts)


def read_docx(path):
    with zipfile.ZipFile(path) as z:
        xml = z.read("word/document.xml")
    root = ET.fromstring(xml)
    body = root.find(NS_W + "body")
    if body is None:
        raise Unreadable("no document body")
    out = []

    def walk(container):
        for child in container:
            if child.tag == NS_W + "p":
                out.append(_para_text(child))
            elif child.tag == NS_W + "tbl":
                for tr in child.findall(NS_W + "tr"):
                    cells = []
                    for tc in tr.findall(NS_W + "tc"):
                        cells.append(" ".join(_para_text(p) for p in tc.findall(NS_W + "p")).strip())
                    out.append(" | ".join(cells))
                out.append("")
            elif child.tag == NS_W + "sdt":
                content = child.find(NS_W + "sdtContent")
                if content is not None:
                    walk(content)
    walk(body)
    return "\n".join(out)


def read_xlsx(path):
    with zipfile.ZipFile(path) as z:
        names = set(z.namelist())
        shared = []
        if "xl/sharedStrings.xml" in names:
            sst = ET.fromstring(z.read("xl/sharedStrings.xml"))
            for si in sst.findall(NS_S + "si"):
                shared.append("".join(t.text or "" for t in si.iter(NS_S + "t")))
        sheets = []
        try:
            wb = ET.fromstring(z.read("xl/workbook.xml"))
            rels = ET.fromstring(z.read("xl/_rels/workbook.xml.rels"))
            targets = {r.get("Id"): r.get("Target") for r in rels.findall(NS_PR + "Relationship")}
            for sh in wb.find(NS_S + "sheets").findall(NS_S + "sheet"):
                target = targets.get(sh.get(NS_R + "id"), "") or ""
                if target.startswith("/"):
                    target = target[1:]
                elif not target.startswith("xl/"):
                    target = "xl/" + target
                sheets.append((sh.get("name") or target, target))
        except Exception:
            sheets = [(n.split("/")[-1], n) for n in sorted(names) if n.startswith("xl/worksheets/sheet")]
        if not sheets:
            raise Unreadable("no sheets")
        out = []
        for name, target in sheets:
            if target not in names:
                continue
            out.append("## Sheet: " + name)
            root = ET.fromstring(z.read(target))
            rows = 0
            for row in root.iter(NS_S + "row"):
                cells = []
                for c in row.findall(NS_S + "c"):
                    t = c.get("t")
                    v = c.find(NS_S + "v")
                    if t == "s" and v is not None:
                        try:
                            cells.append(shared[int(v.text)])
                        except Exception:
                            cells.append("")
                    elif t == "inlineStr":
                        cells.append("".join(x.text or "" for x in c.iter(NS_S + "t")))
                    elif v is not None:
                        cells.append(v.text or "")
                    else:
                        cells.append("")
                out.append("\t".join(cells).rstrip())
                rows += 1
                if rows >= 3000:
                    out.append("[cut here: more rows than your Caddy reads in one go]")
                    break
            out.append("")
    return "\n".join(out)


def read_pptx(path):
    with zipfile.ZipFile(path) as z:
        slides = [n for n in z.namelist() if re.match(r"ppt/slides/slide\d+\.xml$", n)]
        slides.sort(key=lambda n: int(re.search(r"(\d+)", n.split("/")[-1]).group(1)))
        if not slides:
            raise Unreadable("no slides")
        out = []
        for i, n in enumerate(slides, 1):
            root = ET.fromstring(z.read(n))
            out.append("## Slide %d" % i)
            for p in root.iter(NS_A + "p"):
                line = "".join(t.text or "" for t in p.iter(NS_A + "t")).strip()
                if line:
                    out.append(line)
            out.append("")
    return "\n".join(out)


def read_office(path):
    try:
        res = subprocess.run(["textutil", "-convert", "txt", "-stdout", path],
                             capture_output=True, timeout=60)
    except FileNotFoundError:
        raise Unreadable("no converter for this kind of file on this computer")
    except subprocess.TimeoutExpired:
        raise Unreadable("the converter took too long")
    if res.returncode != 0:
        raise Unreadable("the converter could not read it")
    return _decode(res.stdout)


def extract(path):
    """Return the file's text, or raise Unreadable. Only for kinds that carry text."""
    if not os.path.isfile(path):
        raise Unreadable("not a file")
    if os.path.getsize(path) == 0:
        raise Unreadable("empty")
    k = kind(path)
    try:
        if k == "text":
            text = read_text(path)
        elif k == "docx":
            text = read_docx(path)
        elif k == "xlsx":
            text = read_xlsx(path)
        elif k == "pptx":
            text = read_pptx(path)
        elif k == "office":
            text = read_office(path)
        else:
            raise Unreadable("this kind of file carries no text your Caddy can read here")
    except Unreadable:
        raise
    except (zipfile.BadZipFile, KeyError, ET.ParseError, OSError, ValueError) as exc:
        raise Unreadable("protected or damaged (%s)" % type(exc).__name__)
    if len(text) > MAX_CHARS:
        text = text[:MAX_CHARS] + CUT_NOTE
    return text


def main(argv):
    if not argv or argv[0] in ("-h", "--help"):
        print(__doc__.strip())
        return 0
    if argv[0] == "--kind":
        if len(argv) < 2:
            print("which file?", file=sys.stderr)
            return 2
        print(kind(argv[1]))
        return 0
    path = argv[0]
    start, count = None, None
    if "--from" in argv:
        try:
            start = int(argv[argv.index("--from") + 1])
            count = int(argv[argv.index("--count") + 1]) if "--count" in argv else 300
        except (ValueError, IndexError):
            print("say which lines: --from 301 --count 300", file=sys.stderr)
            return 2
    if not os.path.isfile(path):
        print("not a file: %s" % path, file=sys.stderr)
        return EXIT_UNREADABLE
    k = kind(path)
    if k in ("pdf", "image"):
        print("%s: the app reads this file directly" % k, file=sys.stderr)
        return EXIT_DIRECT
    if k == "recording":
        print("recording: needs a transcript", file=sys.stderr)
        return EXIT_RECORDING
    if k == "unknown":
        print("unknown kind of file: listed, not read", file=sys.stderr)
        return EXIT_UNKNOWN
    try:
        text = extract(path)
    except Unreadable as exc:
        print("unreadable: %s" % exc, file=sys.stderr)
        return EXIT_UNREADABLE
    if start is not None:
        lines = text.split("\n")
        chunk = lines[max(start - 1, 0):max(start - 1, 0) + max(count, 1)]
        text = "\n".join(chunk) + ("\n[%d lines in all; this part: %d to %d]" % (len(lines), start, start + len(chunk) - 1))
    sys.stdout.write(text)
    if not text.endswith("\n"):
        sys.stdout.write("\n")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
