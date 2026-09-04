#!/bin/sh
# Prove a key-in-header connection without ever printing the key.
#
#   bash connections/bin/check-http.sh <label> <url> <header-name> <env-var> [expected-code]
#
# Reads .env from the current folder (never printed, never executed), sends one GET with the
# header "<header-name>: <value of env-var>" (a header name of "Bearer" sends
# "Authorization: Bearer <value>"), and prints only the HTTP status and the response size.
# Exit 0 when the status is the expected code (default 200); 2 when the key is not set yet.
set -u
label="${1:?label}"; url="${2:?url}"; header="${3:?header-name}"; var="${4:?env-var}"; want="${5:-200}"
. "$(dirname "$0")/_env.sh"
load_env
val=$(printenv "$var" 2>/dev/null || true)
if [ -z "$val" ] || [ "$val" = "<paste here>" ]; then
  echo "$label: $var is not set in .env yet (the card is still open)"
  exit 2
fi
if [ "$header" = "Bearer" ]; then hdr="Authorization: Bearer $val"; else hdr="$header: $val"; fi
code=$(http_code "$url" -H "$hdr")
unset val hdr
size=$(wc -c < "$HTTP_BODY_FILE" | tr -d ' '); rm -f "$HTTP_BODY_FILE"
echo "$label: HTTP $code, $size bytes"
[ "$code" = "$want" ]
