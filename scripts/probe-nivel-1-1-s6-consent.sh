#!/usr/bin/env bash
# Nivel 1.1 S6 — Consent model harness.
# Proves: approved scopes only, version binding, immutable history,
# grant→revoke→re-grant, ownership RLS, anonymous denial.
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

# RED: approved scopes only.
scopes=$(psql "SELECT string_agg(scope,',' ORDER BY scope) FROM public.consent_versions")
check "privacy_policy,terms_of_service" "$scopes" "only approved scopes exist"

# Helpers.
signup(){ local em="$1"; curl -s -X POST "$API/auth/v1/signup" -H "apikey:$ANON_KEY" -H "Content-Type:application/json" -d "{\"email\":\"$em\",\"password\":\"S6VerifyPassLong123\"}"; }
grant(){ local at="$1" uid="$2" sc="$3"; curl -s -o /dev/null -w "%{http_code}" -X POST "$API/rest/v1/patient_consents" -H "apikey:$ANON_KEY" -H "Authorization:Bearer $at" -H "Content-Type:application/json" -d "{\"user_id\":\"$uid\",\"scope\":\"$sc\",\"version\":\"1.0.0\",\"action\":\"grant\"}"; }
revoke(){ local at="$1" uid="$2" sc="$3"; curl -s -o /dev/null -w "%{http_code}" -X POST "$API/rest/v1/patient_consents" -H "apikey:$ANON_KEY" -H "Authorization:Bearer $at" -H "Content-Type:application/json" -d "{\"user_id\":\"$uid\",\"scope\":\"$sc\",\"version\":\"1.0.0\",\"action\":\"revoke\"}"; }

ts=$(date +%s%N)
ra=$(signup "s6-a-$ts@example.local"); ata=$(echo "$ra" | sed -n 's/.*"access_token":"\([^"]*\)".*/\1/p'); aid=$(echo "$ra" | sed -n 's/.*"id":"\([^"]*\)".*/\1/p')
rb=$(signup "s6-b-$ts@example.local"); atb=$(echo "$rb" | sed -n 's/.*"access_token":"\([^"]*\)".*/\1/p'); bid=$(echo "$rb" | sed -n 's/.*"id":"\([^"]*\)".*/\1/p')
check present "$([ -n "$ata" ] && echo present || echo absent)" "patient A token"
check present "$([ -n "$atb" ] && echo present || echo absent)" "patient B token"

# A grants ToS and PP, revokes ToS, re-grants ToS.
check 201 "$(grant "$ata" "$aid" "terms_of_service")" "A grant terms_of_service"
check 201 "$(grant "$ata" "$aid" "privacy_policy")" "A grant privacy_policy"
check 201 "$(revoke "$ata" "$aid" "terms_of_service")" "A revoke terms_of_service"
check 201 "$(grant "$ata" "$aid" "terms_of_service")" "A re-grant terms_of_service"

# Immutable history: 4 rows; original ToS grant and re-grant both preserved.
check 4 "$(psql "SELECT count(*) FROM public.patient_consents WHERE user_id='$aid'")" "A consent history has 4 rows"
check 2 "$(psql "SELECT count(*) FROM public.patient_consents WHERE user_id='$aid' AND scope='terms_of_service' AND action='grant'")" "ToS grant rows preserved (grant + re-grant)"
check 1 "$(psql "SELECT count(*) FROM public.patient_consents WHERE user_id='$aid' AND scope='terms_of_service' AND action='revoke'")" "ToS revoke row preserved"

# Current state: ToS granted, PP granted.
current=$(psql "SELECT string_agg(scope||':'||action,',' ORDER BY scope) FROM (SELECT DISTINCT ON (scope) scope, action FROM public.patient_consents WHERE user_id='$aid' ORDER BY scope, created_at DESC) q")
check "privacy_policy:grant,terms_of_service:grant" "$current" "current state reflects latest action"

# Scope independence: B has no history until B acts.
check 0 "$(psql "SELECT count(*) FROM public.patient_consents WHERE user_id='$bid'")" "B has no consent history before B acts"

# B grants PP; A cannot read B's history.
check 201 "$(grant "$atb" "$bid" "privacy_policy")" "B grant privacy_policy"
a_read_b=$(curl -s "$API/rest/v1/patient_consents?select=id&user_id=eq.$bid" -H "apikey:$ANON_KEY" -H "Authorization:Bearer $ata")
check 0 "$(echo "$a_read_b" | grep -c '"id"' || true)" "A cannot read B consent history"

# A cannot UPDATE or DELETE own consent rows.
upd=$(curl -s -o /dev/null -w "%{http_code}" -X PATCH "$API/rest/v1/patient_consents?scope=eq.terms_of_service" -H "apikey:$ANON_KEY" -H "Authorization:Bearer $ata" -H "Content-Type:application/json" -H "Prefer:return=minimal" -d '{"action":"revoke"}')
check 403 "$upd" "A UPDATE own consent blocked (403)"
del=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE "$API/rest/v1/patient_consents?scope=eq.terms_of_service" -H "apikey:$ANON_KEY" -H "Authorization:Bearer $ata")
check 403 "$del" "A DELETE own consent blocked (403)"

# Anonymous denied.
anonv=$(curl -s -o /dev/null -w "%{http_code}" -X GET "$API/rest/v1/consent_versions?select=scope&limit=1" -H "apikey:$ANON_KEY")
check 401 "$anonv" "anon SELECT consent_versions returns 401"
anonc=$(curl -s -o /dev/null -w "%{http_code}" -X GET "$API/rest/v1/patient_consents?select=id&limit=1" -H "apikey:$ANON_KEY")
check 401 "$anonc" "anon SELECT patient_consents returns 401"

echo "S6 summary PASS=$pass FAIL=$fail"
exit $fail
