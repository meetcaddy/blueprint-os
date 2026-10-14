#!/bin/sh
# Runs the memory engine's own session-start hook and hides its vendor update banner. The banner
# offers an update the Caddy team does not ship (it needs the maker's own license) and names the
# maker's shop; neither belongs on the owner's screen. Everything else the engine prints passes
# through unchanged. The engine's version check itself still happens (a call to its maker's site;
# nothing about the business travels). Setup copies this file to ~/.claude/hooks/ and points the
# engine's session-start entry at it.
BASE="${BASE_BIN:-$HOME/.local/bin/base}"
[ -x "$BASE" ] || exit 0
"$BASE" hook session-start "$@" | awk '
  /^(═)+[ ]*$/ { if (inb) { inb = 0; next } held = $0; holding = 1; next }
  holding && /update available|Snooze 24h|base update|chrisai/ { inb = 1; holding = 0; next }
  holding { print held; holding = 0 }
  inb { next }
  { print }
'
exit 0
