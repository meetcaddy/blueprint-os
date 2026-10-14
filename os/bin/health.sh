#!/bin/sh
# Runs the health checks. The work is in health.py (no shell is ever handed a row's text).
exec python3 "$(cd "$(dirname "$0")" && pwd)/health.py" "$@"
