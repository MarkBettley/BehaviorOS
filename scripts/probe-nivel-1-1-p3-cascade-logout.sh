#!/usr/bin/env bash
# Nivel 1.1 P3 — focused regression: admin deletion of a user with an active session
# must succeed and leave a valid logout audit row (NULL actor_user_id with safe
# non-secret correlation context) instead of an FK error.
set +H
set -uo pipefail
cd "$(dirname "$0")/.."
set -a && source .env && set +a
API="${API_EXTERNAL_URL:-http://localhost:8000}"
psql(){ docker compose exec -T db psql -U postgres -d postgres -tA -c "$1"; }
fail=0; pass=0; uid=""; sid=""
check(){ if [ "$1" = "$2" ]; then echo "[PASS] $3"; pass=$((pass+1)); else echo "[FAIL] $3 expected=$1 observed=$2"; fail=$((fail+1)); fi; }
cleanup(){ [ -n "${uid:-}" ] && curl -s -o /dev/null -X DELETE "$API/auth/v1/admin/users/$uid" -H "apikey:$SERVICE_ROLE_KEY" -H "Authorization:Bearer $SERVICE_ROLE_KEY" || true; }
trap cleanup EXIT
./scripts/healthcheck.sh >/dev/null || { echo "runtime unhealthy"; exit 1; }
check healthy healthy "runtime health"

email="p3-$(date +%s%N)@example.local"
pw='P3VerifyPassLong123'

# Admin-create a confirmed user.
uid=$(curl -s -X POST "$API/auth/v1/admin/users" -H "apikey:$SERVICE_ROLE_KEY" -H "Authorization:Bearer $SERVICE_ROLE_KEY" -H "Content-Type:application/json" -d "{\"email\":\"$email\",\"password\":\"$pw\",\"email_confirm\":true}" | sed -n 's/.*"id":"\([^"]*\)".*/\1/p')
check present "$([ -n "$uid" ] && echo present || echo absent)" "admin create user"

# Login to create an active session.
tok=$(curl -s -X POST "$API/auth/v1/token?grant_type=password" -H "apikey:$ANON_KEY" -H "Content-Type:application/json" -d "{\"email\":\"$email\",\"password\":\"$pw\"}")
rt=$(echo "$tok" | sed -n 's/.*"refresh_token":"\([^"]*\)".*/\1/p')
check present "$([ -n "$rt" ] && echo present || echo absent)" "login refresh_token"

# Confirm exactly one active session.
sid=$(psql "SELECT id::text FROM auth.sessions WHERE user_id='$uid'")
check present "$([ -n "$sid" ] && echo present || echo absent)" "active session exists"
check 1 "$(psql "SELECT count(*) FROM auth.sessions WHERE user_id='$uid'")" "exactly one active session"

# Admin-delete the user while the session is still active.
dcode=$(curl -s -o /dev/null -w '%{http_code}' -X DELETE "$API/auth/v1/admin/users/$uid" -H "apikey:$SERVICE_ROLE_KEY" -H "Authorization:Bearer $SERVICE_ROLE_KEY")
check 200_or_204 "$([ "$dcode" = "200" ] || [ "$dcode" = "204" ] && echo 200_or_204 || echo "$dcode")" "admin delete user with active session succeeds"

# Verify no FK error occurred and a valid logout audit row exists.
check 0 "$(psql "SELECT count(*) FROM auth.users WHERE id='$uid'")" "user removed"
check 0 "$(psql "SELECT count(*) FROM auth.sessions WHERE user_id='$uid'")" "sessions removed"
check 1 "$(psql "SELECT count(*) FROM public.audit_logs WHERE event_type='logout' AND outcome='success' AND actor_user_id IS NULL AND context->>'session_id'='$sid' AND context->>'user_id'='$uid'")" "logout audit row with null actor and safe context"
check 1 "$(psql "SELECT count(*) FROM public.audit_logs WHERE event_type='logout' AND outcome='success' AND actor_user_id IS NULL AND context->>'session_id'='$sid' AND context->>'user_id'='$uid' AND correlation_id IS NOT NULL AND correlation_id <> ''")" "logout audit row has opaque correlation_id"

# Ensure no secret-bearing content leaked into the cascade logout context.
check 0 "$(psql "SELECT count(*) FROM public.audit_logs WHERE event_type='logout' AND outcome='success' AND actor_user_id IS NULL AND lower(context::text) ~ '(password|token|jwt|secret|api_key|apikey|service_role|access_token|refresh_token|authorization|bearer)'")" "cascade logout context is secret-free"

# Zero residue of transient identity data (audit row intentionally retained).
check 0 "$(psql "SELECT count(*) FROM public.patient_profiles WHERE user_id='$uid'")" "patient_profiles residue zero"

echo "P3 cascade logout regression PASS=$pass FAIL=$fail"
exit $fail
