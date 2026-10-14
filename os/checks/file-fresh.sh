#!/bin/sh
# Prove a file was written within the last N minutes (an automation that leaves a trace).
set -u
label="${1:?label}"; path="${2:?path}"; max="${3:?max age in minutes}"
[ -e "$path" ] || { echo "$label: missing ($path)"; exit 1; }
now=$(date +%s); mtime=$(stat -f %m "$path" 2>/dev/null || stat -c %Y "$path" 2>/dev/null || echo 0)
age=$(( (now - mtime) / 60 ))
if [ "$age" -le "$max" ]; then echo "$label: written $age minute(s) ago"; exit 0; fi
echo "$label: last written $age minute(s) ago, more than $max"; exit 1
