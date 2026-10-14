#!/usr/bin/env bash
# Tests for the drop folder: the extractor, the index, the flags, the ignore rules.
# Runs on a throwaway copy; touches nothing in this folder.
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
T="$(mktemp -d)"; trap 'rm -rf "$T"' EXIT
pass=0; fail=0
ok()   { pass=$((pass+1)); echo "PASS  $1"; }
bad()  { fail=$((fail+1)); echo "FAIL  $1"; }
check() { if eval "$2"; then ok "$1"; else bad "$1"; fi; }

mkdir -p "$T/os/bin" "$T/os/tests"
cp -R "$HERE/context" "$T/context"
cp "$HERE/os/bin/extract_text.py" "$HERE/os/bin/context-index.py" "$T/os/bin/"
cp "$HERE/.gitignore" "$T/.gitignore"
cd "$T"

python3 - <<'PY'
import os, zipfile
def z(path, files):
    with zipfile.ZipFile(path, "w") as zf:
        for n, c in files.items(): zf.writestr(n, c)
W='xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"'
z("context/how-we-work/estimate-sop.docx", {"word/document.xml":
 f'<w:document {W}><w:body><w:p><w:r><w:t>Step one: measure the roof</w:t></w:r></w:p>'
 '<w:tbl><w:tr><w:tc><w:p><w:r><w:t>Role</w:t></w:r></w:p></w:tc><w:tc><w:p><w:r><w:t>Who</w:t></w:r></w:p></w:tc></w:tr>'
 '<w:tr><w:tc><w:p><w:r><w:t>Estimator</w:t></w:r></w:p></w:tc><w:tc><w:p><w:r><w:t>Dana</w:t></w:r></w:p></w:tc></w:tr></w:tbl></w:body></w:document>'})
S='xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main"'
R='xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"'
z("context/money/pricing.xlsx", {
 "xl/workbook.xml": f'<workbook {S} {R}><sheets><sheet name="Prices" sheetId="1" r:id="rId1"/></sheets></workbook>',
 "xl/_rels/workbook.xml.rels": '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="x" Target="worksheets/sheet1.xml"/></Relationships>',
 "xl/sharedStrings.xml": f'<sst {S}><si><t>Item</t></si><si><t>Price</t></si><si><t>Shingle</t></si></sst>',
 "xl/worksheets/sheet1.xml": f'<worksheet {S}><sheetData><row r="1"><c r="A1" t="s"><v>0</v></c><c r="B1" t="s"><v>1</v></c></row><row r="2"><c r="A2" t="s"><v>2</v></c><c r="B2"><v>4.5</v></c></row><row r="3"><c r="A3" t="inlineStr"><is><t>Ridge cap</t></is></c><c r="B3"><v>12</v></c></row></sheetData></worksheet>'})
A='xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"'
z("context/tools/overview.pptx", {"ppt/slides/slide2.xml": f'<p:sld xmlns:p="x" {A}><a:p><a:r><a:t>Second slide</a:t></a:r></a:p></p:sld>',
                                   "ppt/slides/slide1.xml": f'<p:sld xmlns:p="x" {A}><a:p><a:r><a:t>Our quoting flow</a:t></a:r></a:p></p:sld>'})
open("context/customers/jobs.csv","w").write("job,customer,total\n101,Acme Roofing,4200\n")
open("context/people/org.txt","w").write("Owner: Sam\nEstimator: Dana\n")
open("context/tools/screen.png","wb").write(b"\x89PNG\r\n\x1a\n" + b"\x00"*32)
open("context/tools/brochure.pdf","wb").write(b"%PDF-1.4\n%fake\n")
open("context/recordings/walkthrough.mov","wb").write(b"\x00"*64)
open("context/recordings/intro.m4a","wb").write(b"\x00"*64); open("context/recordings/intro.txt","w").write("Hi, this is the intro transcript.\n")
open("context/anything-else/passwords.txt","w").write("password: hunter2hunter2\n")
open("context/anything-else/.env","w").write("API_KEY=ABCDEFGH12345678\n")
open("context/anything-else/notes.txt","w").write("Our api_key = ABCDEFGH12345678 lives in the vault\nSecond line fine\n")
open("context/money/ids.txt","w").write("Payroll note\nSSN 123-45-6789 for payroll\n")
os.makedirs("context/how-we-work/nested/deep"); open("context/how-we-work/nested/deep/checklist.md","w").write("- check the gutters\n")
open("context/anything-else/empty.docx","wb").write(b"")
open("context/anything-else/broken.docx","wb").write(b"not a zip at all")
open("context/anything-else/mystery.xyz","wb").write(b"\x01\x02\x03")
open("context/top-level-note.txt","w").write("a note at the top level\n")
PY

# --- the extractor
out="$(python3 os/bin/extract_text.py context/how-we-work/estimate-sop.docx)"; code=$?
check "docx: paragraph text" '[[ "$out" == *"measure the roof"* ]]'
check "docx: table row" '[[ "$out" == *"Estimator | Dana"* ]]'
check "docx: exit 0" '[[ $code -eq 0 ]]'
out="$(python3 os/bin/extract_text.py context/money/pricing.xlsx)"
check "xlsx: sheet name" '[[ "$out" == *"Sheet: Prices"* ]]'
check "xlsx: shared string + number" '[[ "$out" == *"Shingle"*"4.5"* ]]'
check "xlsx: inline string" '[[ "$out" == *"Ridge cap"* ]]'
out="$(python3 os/bin/extract_text.py context/tools/overview.pptx)"
check "pptx: slides in order" '[[ "$out" == *"Slide 1"*"Our quoting flow"*"Slide 2"*"Second slide"* ]]'
python3 os/bin/extract_text.py context/tools/brochure.pdf >/dev/null 2>&1; check "pdf: exit 3 (read directly)" '[[ $? -eq 3 ]]'
python3 os/bin/extract_text.py context/recordings/walkthrough.mov >/dev/null 2>&1; check "recording: exit 4" '[[ $? -eq 4 ]]'
python3 os/bin/extract_text.py context/anything-else/mystery.xyz >/dev/null 2>&1; check "unknown: exit 5" '[[ $? -eq 5 ]]'
python3 os/bin/extract_text.py context/anything-else/empty.docx >/dev/null 2>&1; check "empty: exit 6" '[[ $? -eq 6 ]]'
python3 os/bin/extract_text.py context/anything-else/broken.docx >/dev/null 2>&1; check "broken: exit 6" '[[ $? -eq 6 ]]'
check "--kind" '[[ "$(python3 os/bin/extract_text.py --kind context/people/org.txt)" == "text" ]]'

# --- the index
summary="$(python3 os/bin/context-index.py)"
check "index: summary line" '[[ "$summary" == context:*item* ]]'
check "index: INDEX.md written" '[[ -f context/INDEX.md ]]'
idx="$(cat context/INDEX.md)"
check "index: nested file listed" '[[ "$idx" == *"nested/deep/checklist.md"* ]]'
check "index: top-level file listed" '[[ "$idx" == *"(top level)"*"top-level-note.txt"* ]]'
check "index: password file flagged by name, not read" '[[ "$idx" == *"passwords.txt"*"looks like a key or password file"* ]]'
check "index: .env flagged by name" '[[ "$idx" == *".env"*"looks like a key or password file"* ]]'
check "index: key-like line flagged with its number" '[[ "$idx" == *"notes.txt"*"line 1 looks like a key"* ]]'
check "index: ID-number hint" '[[ "$idx" == *"ids.txt"*"personal ID numbers"* ]]'
check "index: never prints the secret" '[[ "$idx" != *"hunter2"* && "$idx" != *"ABCDEFGH12345678"* && "$idx" != *"123-45-6789"* ]]'
check "index: pdf read directly" '[[ "$idx" == *"brochure.pdf"*"read directly"* ]]'
check "index: recording needs a transcript" '[[ "$idx" == *"walkthrough.mov"*"needs a transcript"* ]]'
check "index: recording with transcript next to it" '[[ "$idx" == *"intro.m4a"*"transcript next to it"* ]]'
check "index: empty file" '[[ "$idx" == *"empty.docx"*"empty file"* ]]'
check "index: broken file unreadable" '[[ "$idx" == *"broken.docx"*"unreadable"* ]]'
check "index: unknown kind listed not read" '[[ "$idx" == *"mystery.xyz"*"listed, not read"* ]]'
check "index: new markers on first run" '[[ "$idx" == *"readable (new)"* ]]'
check "index: waiting section present" '[[ "$idx" == *"## Waiting on you"* ]]'
s2="$(python3 os/bin/context-index.py --summary)"
check "summary: nothing new after an index" '[[ "$s2" == *"0 new since"* ]]'
check "summary mode changes nothing" '[[ "$(cat context/INDEX.md)" == "$idx" ]]'
sleep 1; echo "- and the downspouts" >> context/how-we-work/nested/deep/checklist.md
s3="$(python3 os/bin/context-index.py --summary)"
check "summary: a changed file counts as new" '[[ "$s3" == *"1 new since"* ]]'
python3 - <<'PY'
p="context/INDEX.md"; s=open(p).read()
s=s.replace("(nothing yet: type /blueprint context and your Caddy reads what is new)","- `how-we-work/estimate-sop.docx`: the estimating steps; serves opportunity 1")
s=s.replace("(your Caddy fills this in as it reads)","- a sample invoice, in money/")
open(p,"w").write(s)
PY
python3 os/bin/context-index.py >/dev/null
idx2="$(cat context/INDEX.md)"
check "learned block kept across re-runs" '[[ "$idx2" == *"the estimating steps; serves opportunity 1"* ]]'
check "missing block kept across re-runs" '[[ "$idx2" == *"a sample invoice, in money/"* ]]'
check "re-run clears the new marker" 'grep -F "estimate-sop.docx" context/INDEX.md | grep -vq "(new)"'

rm context/people/org.txt; python3 os/bin/context-index.py >/dev/null
check "index: an emptied slot says nothing here yet" 'grep -A2 "^### people" context/INDEX.md | grep -q "nothing here yet"'

# --- the ignore rules
git init -q . && git add -A >/dev/null 2>&1
tracked="$(git ls-files)"
check "git keeps the README, the notes and the index" '[[ "$tracked" == *"context/README.md"* && "$tracked" == *"context/money/WHAT-GOES-HERE.md"* && "$tracked" == *"context/INDEX.md"* ]]'
check "git never keeps a raw file" '[[ "$tracked" != *"estimate-sop.docx"* && "$tracked" != *"passwords.txt"* && "$tracked" != *"checklist.md"* && "$tracked" != *".seen.json"* && "$tracked" != *"top-level-note.txt"* ]]'
check "git ignores .blueprint/" '[[ "$(git check-ignore .blueprint/x 2>/dev/null)" == ".blueprint/x" ]]'

echo; echo "context tests: $pass passed, $fail failed"
[[ $fail -eq 0 ]]
