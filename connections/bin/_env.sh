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

# http_code <url> <header...>: prints the HTTP status only ("000" when the request failed).
http_code() {
  url="$1"; shift
  tmp=$(mktemp)
  code=$(curl -sS -o "$tmp" -w '%{http_code}' "$@" -H 'Accept: application/json' "$url" 2>/dev/null) || code=""
  [ -z "$code" ] && code="000"
  HTTP_BODY_FILE="$tmp"
  printf '%s' "$code"
}
