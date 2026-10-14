#!/bin/sh
# Prove a web address answers. Prints the status only.
set -u
label="${1:?label}"; url="${2:?url}"; want="${3:-200}"
case "$url" in
  *[Ww]ebhook*|*/hooks/*|*/hook/*|*/trigger*|*/run|*/run/*|*/send|*/send/*|*/start|*/start/*)
    echo "$label: that address starts something; a check must only look. Use a status or health address."; exit 1 ;;
esac
code=$(curl -sS -o /dev/null -w '%{http_code}' --max-time 15 "$url" 2>/dev/null) || code="000"
[ -z "$code" ] && code="000"
if [ "$code" = "000" ]; then echo "$label: no answer from $url (offline, or the address is wrong)"; exit 3; fi
echo "$label: HTTP $code"
[ "$code" = "$want" ]
