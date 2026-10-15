#!/bin/sh
# The copy-rules gate for everything the template ships in its own words.
#   bash os/bin/copy-check.sh          -> lists every offending line, exit 1 if any
# Rules checked: no em dashes, no en dashes, no spaced double hyphens, no internal names.
# Vendored engines (frameworks/, base/) keep their authors' style and are not checked. The
# business's own material (the business files, package/, context/, training/) is never scanned,
# and the owner's own name, read from BUSINESS.md, never counts as an internal name.
set -u
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT" || exit 2
owner=""
[ -f BUSINESS.md ] && owner="$(sed -n 's/^\*\*Owner:\*\* *//p' BUSINESS.md | head -1 | sed 's/ *$//')"
out="$(find . -type f \( -name '*.md' -o -name '*.sh' -o -name '*.py' -o -name '*.json' -o -name 'MANIFEST' -o -name 'VERSION' \) \
  -not -path './frameworks/*' -not -path './base/*' -not -path './.git/*' -not -path './.claude/worktrees/*' \
  -not -path './node_modules/*' -not -path './.base/*' -not -path './projects/*' -not -path './design/*' \
  -not -path './briefs/*' -not -path './.paul/*' -not -path './.seed/*' -not -path './checks/*' \
  -not -path './package/*' -not -path './context/*' -not -path './training/*' \
  -not -name 'BUSINESS.md' -not -name 'BLUEPRINT.md' -not -name 'BLUEPRINT-DIRECTIVES.md' -not -name 'SYSTEMS.md' \
  -not -name 'ACCESS-MAP.md' -not -name 'amendments.md' -not -name 'WAITING-ON-YOU.md' -not -name 'copy-check.sh' \
  | sort | while IFS= read -r f; do
  awk -v F="$f" -v O="$owner" '
    index($0, "\342\200\224") { print F ":" NR ": em dash: " substr($0, 1, 110) }
    index($0, "\342\200\223") { print F ":" NR ": en dash: " substr($0, 1, 110) }
    index($0, " -- ") && F !~ /\.sh$/ { print F ":" NR ": double hyphen: " substr($0, 1, 110) }
    (/Tucker/ && O !~ /^Tucker/) || /admin\/tools\// { print F ":" NR ": internal name or path: " substr($0, 1, 110) }
  ' "$f"
done)"
if [ -z "$out" ]; then echo "copy check: clean"; exit 0; fi
printf '%s\n' "$out"
echo "copy check: fix the lines above"; exit 1
