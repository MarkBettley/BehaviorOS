#!/usr/bin/env bash
# Nivel 1.1 S7 — Audit writer harness (RED/GREEN/READBACK).
# Proves: six required events; id/type/timestamp/outcome/correlation;
# origin NULL-if-safe; failed-login writer path; append-only; INSERT-only denial.
set +H
set -uo pipefail
cd "$(dirname "$0")/.."
set -a && source .env && set +a
API="${API_EXTERNAL_URL:-http://localhost:8000}"
psql(){ docker compose exec -T db psql -U postgres -d postgres -tA -c "$1"; }
fail=0; pass=0; aid=""
check(){ if [ "$1" = "$2" ]; then echo "[PASS] $3"; pass=$((pass+1)); else echo "[FAIL] $3 expected=$1 observed=$2"; fail=$((fail+1)); fi; }
check_nonzero(){ if [ "$1" -ne 0 ]; then echo "[PASS] $2"; pass=$((pass+1)); else echo "[FAIL] $2 expected non-zero exit"; fail=$((fail+1)); fi; }
cleanup(){ [ -n "${aid:-}" ] && curl -s -o /dev/null -X DELETE "$API/auth/v1/admin/users/$aid" -H "apikey:$SERVICE_ROLE_KEY" -H "Authorization:Bearer $SERVICE_ROLE_KEY"; docker compose exec -T db psql -U postgres -d postgres -tA -c "DELETE FROM public.audit_logs WHERE correlation_id='a0a0a0a0-a0a0-a0a0-a0a0-a0a0a0a0a0a0';" >/dev/null 2>&1 || true; }
trap cleanup EXIT
./scripts/healthcheck.sh >/dev/null || { echo "runtime unhealthy"; exit 1; }
check healthy healthy "runtime health"

# RED: no deferred event types in Nivel 1.1.
check 0 "$(psql "SELECT count(*) FROM public.audit_logs WHERE event_type IN ('profile_read','critical_access')")" "RED: no profile_read/critical_access events"

# Create patient A.
ts=$(date +%s%N)
ra=$(curl -s -X POST "$API/auth/v1/signup" -H "apikey:$ANON_KEY" -H "Content-Type:application/json" -d "{\"email\":\"s7-a-$ts@example.local\",\"password\":\"S7VerifyPassLong123\"}")
ata=$(echo "$ra" | sed -n 's/.*"access_token":"\([^"]*\)".*/\1/p'); aid=$(echo "$ra" | sed -n 's/.*"id":"\([^"]*\)".*/\1/p')
rt=$(echo "$ra" | sed -n 's/.*"refresh_token":"\([^"]*\)".*/\1/p')
check present "$([ -n "$ata" ] && echo present || echo absent)" "patient A token"
check present "$([ -n "$aid" ] && echo present || echo absent)" "patient A id"

# Consent grant/revoke and profile update.
check 201 "$(curl -s -o /dev/null -w '%{http_code}' -X POST "$API/rest/v1/patient_consents" -H "apikey:$ANON_KEY" -H "Authorization:Bearer $ata" -H "Content-Type:application/json" -d "{\"user_id\":\"$aid\",\"scope\":\"terms_of_service\",\"version\":\"1.0.0\",\"action\":\"grant\"}")" "consent grant"
check 201 "$(curl -s -o /dev/null -w '%{http_code}' -X POST "$API/rest/v1/patient_consents" -H "apikey:$ANON_KEY" -H "Authorization:Bearer $ata" -H "Content-Type:application/json" -d "{\"user_id\":\"$aid\",\"scope\":\"terms_of_service\",\"version\":\"1.0.0\",\"action\":\"revoke\"}")" "consent revoke"
check 204 "$(curl -s -o /dev/null -w '%{http_code}' -X PATCH "$API/rest/v1/patient_profiles?user_id=eq.$aid" -H "apikey:$ANON_KEY" -H "Authorization:Bearer $ata" -H "Content-Type:application/json" -H "Prefer:return=minimal" -d '{"updated_at":"2026-01-01T00:00:00Z"}')" "profile update"

# Logout.
lcode=$(curl -s -o /dev/null -w '%{http_code}' -X POST "$API/auth/v1/logout" -H "apikey:$ANON_KEY" -H "Authorization:Bearer $ata" -H "Content-Type:application/json" -d "{\"refresh_token\":\"$rt\"}")
check 200_or_204 "$([ "$lcode" = "200" ] || [ "$lcode" = "204" ] && echo 200_or_204 || echo "$lcode")" "logout"

# Verify six mandatory events for patient A.
for et in registration login consent_grant consent_revoke profile_update logout; do
  check 1 "$(psql "SELECT count(*) FROM public.audit_logs WHERE actor_user_id='$aid' AND event_type='$et' AND outcome='success'")" "event $et exists"
done

# Verify required fields and origin NULL-if-safe.
check 6 "$(psql "SELECT count(*) FROM public.audit_logs WHERE actor_user_id='$aid' AND id IS NOT NULL AND event_type IS NOT NULL AND occurred_at IS NOT NULL AND outcome IS NOT NULL AND correlation_id IS NOT NULL AND correlation_id <> '' AND origin IS NULL")" "six events have required fields and null origin"

# Correlation IDs are opaque and not derived from secrets/identity/tokens.
check 0 "$(psql "SELECT count(*) FROM public.audit_logs WHERE actor_user_id='$aid' AND correlation_id IN ('$aid','$ata','$rt')")" "correlation_id not derived from identity or tokens"

# Failed login: writer supports login/failure with null actor (trusted direct call).
fail_corr='a0a0a0a0-a0a0-a0a0-a0a0-a0a0a0a0a0a0'
psql "SELECT security.write_audit_event(NULL,'login','failure','$fail_corr',NULL,'{}'::jsonb);" >/dev/null
check 1 "$(psql "SELECT count(*) FROM public.audit_logs WHERE event_type='login' AND outcome='failure' AND actor_user_id IS NULL AND correlation_id='$fail_corr'")" "writer records login/failure with null actor"

# Failed login via API does NOT fabricate an event (no safe hook available).
before=$(psql "SELECT count(*) FROM public.audit_logs WHERE event_type='login' AND outcome='failure'")
curl -s -X POST "$API/auth/v1/token?grant_type=password" -H "apikey:$ANON_KEY" -H "Content-Type:application/json" -d '{"email":"s7-fail@example.local","password":"WrongPass123"}' >/dev/null
after=$(psql "SELECT count(*) FROM public.audit_logs WHERE event_type='login' AND outcome='failure'")
check "$before" "$after" "API failed login does not fabricate audit event"

# Append-only / writer INSERT-only: patient direct INSERT/UPDATE/DELETE denied.
check 403 "$(curl -s -o /dev/null -w '%{http_code}' -X POST "$API/rest/v1/audit_logs" -H "apikey:$ANON_KEY" -H "Authorization:Bearer $ata" -H "Content-Type:application/json" -d "{\"actor_user_id\":\"$aid\",\"event_type\":\"login\",\"outcome\":\"success\",\"correlation_id\":\"fake\"}")" "direct INSERT audit denied (403)"
check 403 "$(curl -s -o /dev/null -w '%{http_code}' -X PATCH "$API/rest/v1/audit_logs?actor_user_id=eq.$aid" -H "apikey:$ANON_KEY" -H "Authorization:Bearer $ata" -H "Content-Type:application/json" -H "Prefer:return=minimal" -d '{"outcome":"failure"}')" "direct UPDATE audit denied (403)"
check 403 "$(curl -s -o /dev/null -w '%{http_code}' -X DELETE "$API/rest/v1/audit_logs?actor_user_id=eq.$aid" -H "apikey:$ANON_KEY" -H "Authorization:Bearer $ata")" "direct DELETE audit denied (403)"

# Negative assertions: writer validations reject invalid inputs (direct trusted calls).
neg_before=$(psql "SELECT count(*) FROM public.audit_logs")
run_sql(){ docker compose exec -T db psql -U postgres -d postgres -tA -c "$1" >/dev/null 2>&1; echo $?; }

# Invalid correlation format.
ec=$(run_sql "SELECT security.write_audit_event('$aid','login','success','not-a-uuid',NULL,'{}'::jsonb);")
check_nonzero "$ec" "writer rejects invalid correlation format"
check "$neg_before" "$(psql "SELECT count(*) FROM public.audit_logs")" "invalid correlation did not insert"

# Invalid origin provenance.
ec=$(run_sql "SELECT security.write_audit_event('$aid','login','success',NULL,'!invalid!','{}'::jsonb);")
check_nonzero "$ec" "writer rejects invalid origin provenance"
check "$neg_before" "$(psql "SELECT count(*) FROM public.audit_logs")" "invalid origin did not insert"

# Secret-bearing context.
ec=$(run_sql "SELECT security.write_audit_event('$aid','login','success',NULL,NULL,'{\"password\":\"secret123\"}'::jsonb);")
check_nonzero "$ec" "writer rejects secret-bearing context"
check "$neg_before" "$(psql "SELECT count(*) FROM public.audit_logs")" "secret context did not insert"

# Actor binding: NULL actor for a user-scoped success event.
ec=$(run_sql "SELECT security.write_audit_event(NULL,'profile_update','success',NULL,NULL,'{}'::jsonb);")
check_nonzero "$ec" "writer rejects NULL actor for profile_update"
check "$neg_before" "$(psql "SELECT count(*) FROM public.audit_logs")" "NULL actor did not insert"

# Actor binding: mismatch for user-scoped event when auth.uid() is set.
ec=$(run_sql "SET LOCAL request.jwt.claim.sub = '00000000-0000-0000-0000-000000000000'; SELECT security.write_audit_event('$aid','profile_update','success',NULL,NULL,'{}'::jsonb);")
check_nonzero "$ec" "writer rejects actor binding mismatch for profile_update"
check "$neg_before" "$(psql "SELECT count(*) FROM public.audit_logs")" "actor mismatch did not insert"

# Final append-only count for patient A is exactly six success events.
check 6 "$(psql "SELECT count(*) FROM public.audit_logs WHERE actor_user_id='$aid'")" "six success events for patient A (append-only)"

echo "S7 summary PASS=$pass FAIL=$fail"
exit $fail
