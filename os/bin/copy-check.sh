#!/bin/sh
# The copy-rules gate for everything the template ships in its own words.
#   bash os/bin/copy-check.sh          -> lists every offending line, exit 1 if any
# Rules checked: no em dashes, no en dashes, no spaced double hyphens, no internal names.
# Vendored engines (frameworks/, base/) keep their authors' style and are not checked.
set -u
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT" || exit 2
bad=0
files=$(find . -type f \( -name '*.md' -o -name '*.sh' -o -name '*.py' -o -name '*.json' -o -name 'MANIFEST' -o -name 'VERSION' \) \
  -not -path './frameworks/*' -not -path './base/*' -not -path './.git/*' -not -path './.claude/worktrees/*' \
  -not -path './node_modules/*' -not -path './.base/*' -not -path './projects/*' -not -path './design/*' \
  -not -path './context/*' -not -path './briefs/*' -not -path './package/*' -not -path './.paul/*' -not -path './.seed/*' \
  -not -name 'BUSINESS.md' -not -name 'BLUEPRINT.md' -not -name 'BLUEPRINT-DIRECTIVES.md' -not -name 'SYSTEMS.md' \
  -not -name 'ACCESS-MAP.md' -not -name 'amendments.md' | sort)
for f in $files; do
  awk -v F="$f" '
    index($0, "\342\200\224") { print F ":" NR ": em dash: " substr($0, 1, 110); bad = 1 }
    index($0, "\342\200\223") { print F ":" NR ": en dash: " substr($0, 1, 110); bad = 1 }
    index($0, " -- ")        { print F ":" NR ": double hyphen: " substr($0, 1, 110); bad = 1 }
    /Tucker|admin\/tools\// { print F ":" NR ": internal name or path: " substr($0, 1, 110); bad = 1 }
    END { exit bad }
  ' "$f" || bad=1
done
if [ "$bad" = 0 ]; then echo "copy check: clean"; exit 0; fi
echo "copy check: fix the lines above"; exit 1
