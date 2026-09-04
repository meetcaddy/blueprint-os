#!/bin/sh
# Prove the n8n API key works without ever printing it.
#   bash connections/bin/check-n8n-api.sh
# Needs N8N_BASE_URL and N8N_API_KEY in .env (this folder). Prints "HTTP 200" and a
# workflow count when connected; "HTTP 401" when the key is wrong or expired; "HTTP 000"
# when the address could not be reached. Exit 2 while the card is still open.
set -u
. "$(dirname "$0")/_env.sh"
load_env
base="${N8N_BASE_URL:-}"; key="${N8N_API_KEY:-}"
if [ -z "$base" ] || [ "$base" = "<paste here>" ] || [ -z "$key" ] || [ "$key" = "<paste here>" ]; then
  echo "n8n: N8N_BASE_URL or N8N_API_KEY is not set in .env yet (the card is still open)"
  exit 2
fi
base="${base%/}"
http_get "$base/api/v1/workflows?limit=50" -H "X-N8N-API-KEY: $key"
unset key
count=$(json_len "$HTTP_BODY_FILE" data); rm -f "$HTTP_BODY_FILE"
echo "n8n: HTTP $HTTP_CODE, $count workflow(s) visible"
[ "$HTTP_CODE" = "200" ]
