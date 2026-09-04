#!/bin/sh
# Prove the Airtable personal access token works without ever printing it.
#   bash connections/bin/check-airtable-pat.sh
# Needs AIRTABLE_PAT in .env (this folder). Prints "HTTP 200" and a base count when
# connected; "HTTP 401" when the token is wrong or lacks the schema.bases:read scope.
# Exit 2 while the card is still open.
set -u
. "$(dirname "$0")/_env.sh"
load_env
pat="${AIRTABLE_PAT:-}"
if [ -z "$pat" ] || [ "$pat" = "<paste here>" ]; then
  echo "airtable: AIRTABLE_PAT is not set in .env yet (the card is still open)"
  exit 2
fi
http_get "https://api.airtable.com/v0/meta/bases" -H "Authorization: Bearer $pat"
unset pat
count=$(json_len "$HTTP_BODY_FILE" bases); rm -f "$HTTP_BODY_FILE"
echo "airtable: HTTP $HTTP_CODE, $count base(s) visible"
[ "$HTTP_CODE" = "200" ]
