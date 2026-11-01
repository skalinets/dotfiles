#!/bin/bash
# Fails when the repo contains private topology: tailnet name, employer hosts, private IP ranges.
set -euo pipefail
cd "$(dirname "$0")/.."
pattern='tail977112|breeze-soft|rtl\.co\.il|192\.168\.[0-9]+\.[0-9]+|(^|[^0-9.])10\.[0-9]+\.[0-9]+\.[0-9]+|172\.(1[6-9]|2[0-9]|3[01])\.[0-9]+\.[0-9]+|100\.(6[4-9]|[7-9][0-9]|1[01][0-9]|12[0-7])\.[0-9]+\.[0-9]+'
if git grep -nIE "$pattern" -- . ':!ci/check-private.sh'; then
  echo "Private info found above. Move it to a *.local file." >&2
  exit 1
fi
echo "No private info found."
