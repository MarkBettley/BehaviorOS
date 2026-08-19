#!/usr/bin/env bash
# BehavioralOS – verificación de salud de Nivel 0.2
# Uso: ./scripts/healthcheck.sh

set -uo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if [ -f .env ]; then
  # shellcheck source=/dev/null
  set -a && source .env && set +a
fi

API_URL="${API_EXTERNAL_URL:-http://localhost:8000}"
STUDIO_URL="${STUDIO_URL:-http://localhost:3000}"
ANON_KEY="${ANON_KEY:-}"
SERVICE_ROLE_KEY="${SERVICE_ROLE_KEY:-}"
EXIT_CODE=0

req() {
  curl -s -o /dev/null -w "%{http_code}" "$@" 2>/dev/null
}

check() {
  local name="$1"
  local url="$2"
  local expected="$3"
  shift 3

  echo -n "[health] $name ($url) ... "
  local code
  code="$(req "$@" "$url")"
  if [ "$code" = "$expected" ]; then
    echo "OK ($code)"
  else
    echo "FAIL (got $code, expected $expected)"
    EXIT_CODE=1
  fi
}

check_anon() {
  local name="$1"
  local url="$2"
  local expected="$3"
  if [ -n "$ANON_KEY" ]; then
    check "$name" "$url" "$expected" -H "apikey: $ANON_KEY"
  else
    echo "[health] $name SKIPPED (ANON_KEY no definida)"
    EXIT_CODE=1
  fi
}

check_service_role() {
  local name="$1"
  local url="$2"
  local expected="$3"
  if [ -n "$SERVICE_ROLE_KEY" ]; then
    check "$name" "$url" "$expected" -H "apikey: $SERVICE_ROLE_KEY"
  else
    echo "[health] $name SKIPPED (SERVICE_ROLE_KEY no definida)"
    EXIT_CODE=1
  fi
}

# DB: responde solo a credenciales; no exponemos health HTTP.
echo -n "[health] Postgres (localhost:${POSTGRES_PORT:-5432}) ... "
if docker compose exec -T db pg_isready -U postgres -h localhost >/dev/null 2>&1; then
  echo "OK (pg_isready)"
else
  echo "FAIL (pg_isready)"
  EXIT_CODE=1
fi

# Auth public
check_anon "Auth public health" "$API_URL/auth/v1/health" "200"
# Auth secure: anon debe obtener 401 en /auth/v1/user sin JWT
check_anon "Auth secure (anon key-auth)" "$API_URL/auth/v1/user" "401"
# REST via Kong requiere apikey
echo -n "[health] REST via Kong (anon) ($API_URL/rest/v1/) ... "
if [ -n "$ANON_KEY" ]; then
  rh=$(curl -sS -D - -o /dev/null -m 5 -H "apikey: $ANON_KEY" "$API_URL/rest/v1/" 2>/dev/null)
  rs=$(echo "$rh" | awk 'NR==1{print $2}')
  [ "$rs" = "200" ] && echo "$rh" | grep -qi '^content-type: application/openapi+json' && echo "OK (200, application/openapi+json)" || { echo "FAIL (status=$rs)"; EXIT_CODE=1; }
else
  echo "SKIPPED (ANON_KEY no definida)"
  EXIT_CODE=1
fi
# Storage vía Kong
check_anon "Storage status via Kong" "$API_URL/storage/v1/status" "200"
# Meta vía Kong requiere service_role
check_service_role "Meta via Kong" "$API_URL/pg/" "200"
# Kong admin sin key-auth -> 404 o 401 según ruta; usamos raíz que cae en dashboard basic-auth
check "Kong dashboard" "$API_URL/" "401"
# Studio
check "Studio /api/profile" "$STUDIO_URL/api/profile" "200"
# imgproxy directo
echo -n "[health] imgproxy health (http://imgproxy:5001/health) ... "
io=$(docker compose exec -T storage wget -S --spider -T 5 "http://imgproxy:5001/health" 2>&1)
is=$?
ic=$(echo "$io" | awk '/HTTP\/[0-9.]+/{print $2; exit}')
[ "$is" -eq 0 ] && [ "$ic" = "200" ] && echo "OK (200)" || { echo "FAIL (status=$ic, wget_exit=$is)"; EXIT_CODE=1; }

exit $EXIT_CODE
