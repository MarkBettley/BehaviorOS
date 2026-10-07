#!/usr/bin/env bash
# Nivel 1.1 S2 — run schema assertions against the local DB.
set -uo pipefail
cd "$(dirname "$0")/.."
docker compose cp scripts/assert-nivel-1-1-s2-schema.sql db:/tmp/assert.sql >/dev/null || { echo "INFRA_FAILURE: could not copy assertion SQL"; exit 2; }
if ! out=$(timeout 60s docker compose exec -T db psql -U postgres -d postgres -v ON_ERROR_STOP=1 -f /tmp/assert.sql 2>&1); then
  printf '%s\n' "$out"
  echo "INFRA_FAILURE: psql execution failed"
  exit 2
fi
printf '%s\n' "$out"
if printf '%s\n' "$out" | grep -q '| FAIL'; then
  echo "ASSERTION_FAILURE"
  exit 1
fi
echo "PASS"
exit 0
