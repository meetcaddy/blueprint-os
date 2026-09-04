#!/bin/sh
# Shared by the check scripts. Reads .env from the current folder WITHOUT executing it:
# one KEY=VALUE per line, comments and blanks skipped, surrounding quotes stripped. A value
# is exported as-is, so a placeholder like <paste here> is harmless. Nothing is printed.
load_env() {
  [ -f .env ] || return 0
  while IFS= read -r line || [ -n "$line" ]; do
    case "$line" in ''|'#'*) continue ;; esac
    case "$line" in *=*) ;; *) continue ;; esac
    key=${line%%=*}; val=${line#*=}
    key=$(printf '%s' "$key" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//; s/^export[[:space:]]*//')
    val=$(printf '%s' "$val" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')
    case "$val" in
      \"*\") val=${val#\"}; val=${val%\"} ;;
      \'*\') val=${val#\'}; val=${val%\'} ;;
    esac
    case "$key" in ''|*[!A-Za-z0-9_]*) continue ;; esac
    export "$key=$val"
  done < .env
  unset key val line
}

# http_get <url> <curl header args...>
# Sets HTTP_CODE (the status, "000" when the request failed) and HTTP_BODY_FILE (a temp
# file holding the response; the caller removes it). Called directly, never in $(...),
# so the variables reach the caller. Prints nothing.
http_get() {
  url="$1"; shift
  HTTP_BODY_FILE=$(mktemp)
  HTTP_CODE=$(curl -sS -o "$HTTP_BODY_FILE" -w '%{http_code}' "$@" -H 'Accept: application/json' "$url" 2>/dev/null) || HTTP_CODE=""
  [ -z "$HTTP_CODE" ] && HTTP_CODE="000"
  unset url
}

# json_len <file> <key>: prints the length of the JSON array under <key>, or "?".
json_len() {
  python3 -c 'import json,sys
try:
    d=json.load(open(sys.argv[1])); print(len(d.get(sys.argv[2], [])))
except Exception: print("?")' "$1" "$2" 2>/dev/null
}
