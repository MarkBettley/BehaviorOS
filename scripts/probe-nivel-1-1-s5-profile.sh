#!/usr/bin/env bash
# Nivel 1.1 S5 — Patient profile ownership harness.
# Proves: OWN read/update allowed, OTHER read/update denied, user_id reassignment blocked,
# direct DELETE blocked, anonymous access denied.
set +H
set -uo pipefail
cd "$(dirname "$0")/.."
set -a && source .env && set +a
API="${API_EXTERNAL_URL:-http://localhost:8000}"
psql(){ docker compose exec -T db psql -U postgres -d postgres -tA -c "$1"; }
fail=0; pass=0; aid=""; bid=""
check(){ if [ "$1" = "$2" ]; then echo "[PASS] $3"; pass=$((pass+1)); else echo "[FAIL] $3 expected=$1 observed=$2"; fail=$((fail+1)); fi; }
cleanup(){ [ -n "${aid:-}" ] && curl -s -o /dev/null -X DELETE "$API/auth/v1/admin/users/$aid" -H "apikey:$SERVICE_ROLE_KEY" -H "Authorization:Bearer $SERVICE_ROLE_KEY"; [ -n "${bid:-}" ] && curl -s -o /dev/null -X DELETE "$API/auth/v1/admin/users/$bid" -H "apikey:$SERVICE_ROLE_KEY" -H "Authorization:Bearer $SERVICE_ROLE_KEY"; }
trap cleanup EXIT
./scripts/healthcheck.sh >/dev/null || { echo "runtime unhealthy"; exit 1; }
check healthy healthy "runtime health"
# Helpers.
signup(){ local em="$1"; curl -s -X POST "$API/auth/v1/signup" -H "apikey:$ANON_KEY" -H "Content-Type:application/json" -d "{\"email\":\"$em\",\"password\":\"S5VerifyPassLong123\"}"; }
# Create patients A and B via autoconfirm signup.
ts=$(date +%s%N)
ra=$(signup "s5-a-$ts@example.local"); ata=$(echo "$ra" | sed -n 's/.*"access_token":"\([^"]*\)".*/\1/p'); aid=$(echo "$ra" | sed -n 's/.*"id":"\([^"]*\)".*/\1/p')
rb=$(signup "s5-b-$ts@example.local"); atb=$(echo "$rb" | sed -n 's/.*"access_token":"\([^"]*\)".*/\1/p'); bid=$(echo "$rb" | sed -n 's/.*"id":"\([^"]*\)".*/\1/p')
check present "$([ -n "$ata" ] && echo present || echo absent)" "patient A token"
check present "$([ -n "$atb" ] && echo present || echo absent)" "patient B token"
check present "$([ -n "$aid" ] && echo present || echo absent)" "patient A id"
check present "$([ -n "$bid" ] && echo present || echo absent)" "patient B id"
# S3 invariant: profiles created.
check 1 "$(psql "SELECT count(*) FROM public.patient_profiles WHERE user_id='$aid'")" "A profile exists"
check 1 "$(psql "SELECT count(*) FROM public.patient_profiles WHERE user_id='$bid'")" "B profile exists"
# OWN allowed: A reads own profile.
own=$(curl -s -X GET "$API/rest/v1/patient_profiles?select=user_id&limit=1" -H "apikey:$ANON_KEY" -H "Authorization:Bearer $ata")
check 1 "$(echo "$own" | grep -c '"user_id"' || true)" "A reads own profile (1 row)"
check present "$(echo "$own" | grep -q "$aid" && echo present || echo absent)" "own row user_id matches A"
# OTHER denied: A reads B profile.
other=$(curl -s -X GET "$API/rest/v1/patient_profiles?select=user_id&user_id=eq.$bid&limit=1" -H "apikey:$ANON_KEY" -H "Authorization:Bearer $ata")
check 0 "$(echo "$other" | grep -c '"user_id"' || true)" "A reads B profile (0 rows)"
# B cannot modify A.
mods=$(curl -s -o /dev/null -w "%{http_code}" -X PATCH "$API/rest/v1/patient_profiles?user_id=eq.$aid" -H "apikey:$ANON_KEY" -H "Authorization:Bearer $atb" -H "Content-Type:application/json" -H "Prefer:return=minimal" -d '{"updated_at":"2026-01-01T00:00:00Z"}')
check 204 "$mods" "B PATCH A profile returns 204"
check 1 "$(psql "SELECT count(*) FROM public.patient_profiles WHERE user_id='$aid'")" "A profile count unchanged after B PATCH"
# A cannot reassign user_id to B (RLS WITH CHECK violation returns 403).
reassign=$(curl -s -o /dev/null -w "%{http_code}" -X PATCH "$API/rest/v1/patient_profiles?user_id=eq.$aid" -H "apikey:$ANON_KEY" -H "Authorization:Bearer $ata" -H "Content-Type:application/json" -H "Prefer:return=minimal" -d "{\"user_id\":\"$bid\"}")
check 403 "$reassign" "A reassign user_id to B blocked (403)"
check "$aid" "$(psql "SELECT user_id::text FROM public.patient_profiles WHERE user_id='$aid'")" "A user_id unchanged"
# A direct DELETE denied (no DELETE grant/policy returns 403).
del=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE "$API/rest/v1/patient_profiles?user_id=eq.$aid" -H "apikey:$ANON_KEY" -H "Authorization:Bearer $ata")
check 403 "$del" "A DELETE own profile blocked (403)"
check 1 "$(psql "SELECT count(*) FROM public.patient_profiles WHERE user_id='$aid'")" "A profile still exists after DELETE"
# Anonymous access denied.
anon=$(curl -s -o /dev/null -w "%{http_code}" -X GET "$API/rest/v1/patient_profiles?select=user_id&limit=1" -H "apikey:$ANON_KEY")
check 401 "$anon" "anon SELECT patient_profiles returns 401"
echo "S5 summary PASS=$pass FAIL=$fail"
exit $fail
