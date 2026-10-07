#!/usr/bin/env bash
# Nivel 1.1 aggregate security harness.
# Runs the focused RED/GREEN/READBACK scripts and adds the explicit auth/JWT
# scenarios required by patient-registration-auth/spec.md and
# security-test-harness/spec.md. Cleans its own transient data, preserves the
# PostgreSQL system identifier, and exits non-zero on any failure.
set +H
set -uo pipefail
cd "$(dirname "$0")/.."
set -a && source .env && set +a
API="${API_EXTERNAL_URL:-http://localhost:8000}"
psql(){ docker compose exec -T db psql -U postgres -d postgres -tA -c "$1"; }

fail=0; pass=0
check(){ if [ "$1" = "$2" ]; then echo "[PASS] $3"; pass=$((pass+1)); else echo "[FAIL] $3 expected=$1 observed=$2"; fail=$((fail+1)); fi; }

cleanup_users(){
  # Remove any audit rows that reference test identities before deleting users,
  # then delete the test identities themselves.
  docker compose exec -T db psql -U postgres -d postgres -tA -c "DELETE FROM public.audit_logs WHERE actor_user_id IN (SELECT id FROM auth.users WHERE email LIKE '%@example.local') OR (context->>'user_id') IN (SELECT id::text FROM auth.users WHERE email LIKE '%@example.local');" >/dev/null 2>&1 || true
  docker compose exec -T db psql -U postgres -d postgres -tA -c "DELETE FROM auth.users WHERE email LIKE '%@example.local';" >/dev/null 2>&1 || true
}

cleanup(){
  # IDs created by explicit scenarios.
  [ -n "${dup_id:-}" ] && curl -s -o /dev/null -X DELETE "$API/auth/v1/admin/users/$dup_id" -H "apikey:$SERVICE_ROLE_KEY" -H "Authorization:Bearer $SERVICE_ROLE_KEY" || true
  [ -n "${wp_id:-}" ] && curl -s -o /dev/null -X DELETE "$API/auth/v1/admin/users/$wp_id" -H "apikey:$SERVICE_ROLE_KEY" -H "Authorization:Bearer $SERVICE_ROLE_KEY" || true
  cleanup_users
}
trap cleanup EXIT

./scripts/healthcheck.sh >/dev/null || { echo "runtime unhealthy"; exit 1; }
check healthy healthy "runtime health"

# Capture PostgreSQL system identifier before the run.
sys_initial=$(psql "SELECT system_identifier FROM pg_control_system();")
check present "$([ -n "$sys_initial" ] && echo present || echo absent)" "initial system_identifier captured"
echo "system_identifier initial=$sys_initial"

# Start from a clean state: remove any leftover test identities from previous runs.
cleanup_users

# Helper to run a focused script and absorb its PASS/FAIL counts.
run_focused(){
  local script="$1" label="$2"
  echo ""
  echo "=== $label ==="
  local out
  if out=$(bash "$script" 2>&1); then
    local summary
    summary=$(echo "$out" | grep -E '(summary PASS=|summary )' | tail -n1)
    echo "$out"
    echo "[PASS] $label ($summary)"
    # Absorb counts if available.
    local p f
    p=$(echo "$summary" | sed -n 's/.*PASS=\([0-9]*\).*/\1/p'); f=$(echo "$summary" | sed -n 's/.*FAIL=\([0-9]*\).*/\1/p')
    [ -n "$p" ] && pass=$((pass+p))
    [ -n "$f" ] && fail=$((fail+f))
  else
    echo "$out"
    echo "[FAIL] $label exited non-zero"
    fail=$((fail+1))
    return 1
  fi
}

# Focused RED/GREEN/READBACK scripts (skipped in auth-only targeted mode).
if [ -z "${NIVEL_1_1_AUTH_ONLY:-}" ]; then
  run_focused ./scripts/probe-nivel-1-1-s1-auth.sh "S1 auth/session probe" || true
  run_focused ./scripts/repro-nivel-1-1-s2-isolated.sh "S2 schema isolated repro" || true
  run_focused ./scripts/probe-nivel-1-1-s4-session.sh "S4 session/JWT lifecycle" || true
  run_focused ./scripts/probe-nivel-1-1-s5-profile.sh "S5 profile ownership" || true
  run_focused ./scripts/probe-nivel-1-1-s6-consent.sh "S6 consent model" || true
  run_focused ./scripts/probe-nivel-1-1-s7-audit.sh "S7 audit writer" || true
  run_focused ./scripts/probe-nivel-1-1-s8-rls.sh "S8 RLS matrix" || true
  run_focused ./scripts/probe-nivel-1-1-p3-cascade-logout.sh "P3 cascade logout regression" || true
  run_focused ./scripts/probe-nivel-1-1-p3-profile-audit-path.sh "P3 profile audit path" || true
fi

# === Explicit auth scenarios from patient-registration-auth/spec.md ===
echo ""
echo "=== Explicit authentication scenarios ==="
ts=$(date +%s%N)

# Duplicate registration rejection.
dup_email="test-dup-$ts@example.local"
ra=$(curl -s -X POST "$API/auth/v1/signup" -H "apikey:$ANON_KEY" -H "Content-Type:application/json" -d "{\"email\":\"$dup_email\",\"password\":\"TestDupPassLong123\"}")
dup_id=$(echo "$ra" | sed -n 's/.*"id":"\([^"]*\)".*/\1/p')
check present "$([ -n "$dup_id" ] && echo present || echo absent)" "duplicate registration: first signup succeeds"
rb=$(curl -s -X POST "$API/auth/v1/signup" -H "apikey:$ANON_KEY" -H "Content-Type:application/json" -d "{\"email\":\"$dup_email\",\"password\":\"TestDupPassLong123\"}")
dup_code=$(echo "$rb" | sed -n 's/.*"code":\([0-9]*\).*/\1/p')
dup_error_code=$(echo "$rb" | sed -n 's/.*"error_code":"\([^"]*\)".*/\1/p')
dup_msg=$(echo "$rb" | sed -n 's/.*"msg":"\([^"]*\)".*/\1/p')
check 422 "$dup_code" "duplicate registration returns code 422"
check user_already_exists "$dup_error_code" "duplicate registration error_code is user_already_exists"
check "User already registered" "$dup_msg" "duplicate registration msg is deterministic"

# Wrong password and unknown email equivalence.
wp_email="test-wp-$ts@example.local"
wp_id=$(curl -s -X POST "$API/auth/v1/admin/users" -H "apikey:$SERVICE_ROLE_KEY" -H "Authorization:Bearer $SERVICE_ROLE_KEY" -H "Content-Type:application/json" -d "{\"email\":\"$wp_email\",\"password\":\"WpPassLong123\",\"email_confirm\":true}" | sed -n 's/.*"id":"\([^"]*\)".*/\1/p')
check present "$([ -n "$wp_id" ] && echo present || echo absent)" "wrong-password test user created"
wp_wrong=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/auth/v1/token?grant_type=password" -H "apikey:$ANON_KEY" -H "Content-Type:application/json" -d "{\"email\":\"$wp_email\",\"password\":\"WrongPass123\"}")
wp_unknown=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/auth/v1/token?grant_type=password" -H "apikey:$ANON_KEY" -H "Content-Type:application/json" -d "{\"email\":\"test-unknown-$ts@example.local\",\"password\":\"AnyPass123\"}")
check same "$([ "$wp_wrong" = "$wp_unknown" ] && echo same || echo "different($wp_wrong vs $wp_unknown)")" "wrong password and unknown email return same status"
check 400_or_401 "$([ "$wp_wrong" = "400" ] || [ "$wp_wrong" = "401" ] && echo 400_or_401 || echo "$wp_wrong")" "invalid credential status is 400/401"

# Missing, malformed, and non-Bearer token rejection.
no_auth=$(curl -s -o /dev/null -w "%{http_code}" -X GET "$API/rest/v1/patient_profiles?select=user_id&limit=1" -H "apikey:$ANON_KEY")
check 401 "$no_auth" "missing Authorization header rejected"
bad_auth=$(curl -s -o /dev/null -w "%{http_code}" -X GET "$API/rest/v1/patient_profiles?select=user_id&limit=1" -H "apikey:$ANON_KEY" -H "Authorization: Bearer not-a-jwt")
check 401 "$bad_auth" "malformed Bearer token rejected"
non_bearer=$(curl -s -o /dev/null -w "%{http_code}" -X GET "$API/rest/v1/patient_profiles?select=user_id&limit=1" -H "apikey:$ANON_KEY" -H "Authorization: Basic dXNlcjpwYXNz")
check 401 "$non_bearer" "non-Bearer Authorization header rejected"

# Wrong-signature JWT rejection.
ws_jwt=$(python3 - "$JWT_SECRET" <<'PY'
import hmac, hashlib, base64, json, sys, uuid, time
s=sys.argv[1].encode(); sub=str(uuid.uuid4()); n=int(time.time())
pld={"sub":sub,"role":"authenticated","aud":"authenticated","iat":n,"exp":n+3600}
def b(d): return base64.urlsafe_b64encode(d).rstrip(b'=').decode()
h=b(json.dumps({"alg":"HS256","typ":"JWT"}).encode())
p=b(json.dumps(pld).encode())
sg=base64.urlsafe_b64encode(hmac.new(b'wrong-secret-for-signature-test',(h+'.'+p).encode(),hashlib.sha256).digest()).rstrip(b'=').decode()
print(h+'.'+p+'.'+sg)
PY
)
ws_code=$(curl -s -o /dev/null -w "%{http_code}" -X GET "$API/rest/v1/patient_profiles?select=user_id&limit=1" -H "apikey:$ANON_KEY" -H "Authorization:Bearer $ws_jwt")
check 401 "$ws_code" "wrong-signature JWT rejected"

# Expired JWT rejection (deterministic sibling signed with the real JWT_SECRET).
exp_jwt=$(python3 - "$JWT_SECRET" <<'PY'
import hmac, hashlib, base64, json, sys, uuid, time
s=sys.argv[1].encode(); sub=str(uuid.uuid4()); n=int(time.time())
pld={"sub":sub,"role":"authenticated","aud":"authenticated","iat":n-7200,"exp":n-3600}
def b(d): return base64.urlsafe_b64encode(d).rstrip(b'=').decode()
h=b(json.dumps({"alg":"HS256","typ":"JWT"}).encode())
p=b(json.dumps(pld).encode())
sg=base64.urlsafe_b64encode(hmac.new(s,(h+'.'+p).encode(),hashlib.sha256).digest()).rstrip(b'=').decode()
print(h+'.'+p+'.'+sg)
PY
)
exp_code=$(curl -s -o /dev/null -w "%{http_code}" -X GET "$API/rest/v1/patient_profiles?select=user_id&limit=1" -H "apikey:$ANON_KEY" -H "Authorization:Bearer $exp_jwt")
check 401 "$exp_code" "expired JWT rejected"

# Clean up the explicit-scenario test identities before final residue checks.
cleanup

# === Final residue ===
echo ""
echo "=== Final residue ==="
res_users=$(psql "SELECT count(*) FROM auth.users WHERE email LIKE '%@example.local'")
res_sessions=$(psql "SELECT count(*) FROM auth.sessions WHERE user_id IN (SELECT id FROM auth.users WHERE email LIKE '%@example.local')")
res_profiles=$(psql "SELECT count(*) FROM public.patient_profiles WHERE user_id IN (SELECT id FROM auth.users WHERE email LIKE '%@example.local')")
res_consents=$(psql "SELECT count(*) FROM public.patient_consents WHERE user_id IN (SELECT id FROM auth.users WHERE email LIKE '%@example.local')")
echo "auth.users=$res_users auth.sessions=$res_sessions patient_profiles=$res_profiles patient_consents=$res_consents"
check 0 "$res_users" "no test users residue"
check 0 "$res_sessions" "no test sessions residue"
check 0 "$res_profiles" "no test profiles residue"
check 0 "$res_consents" "no test consents residue"

# System identity preservation.
sys_final=$(psql "SELECT system_identifier FROM pg_control_system();")
check "$sys_initial" "$sys_final" "system_identifier unchanged ($sys_initial -> $sys_final)"

echo ""
if [ -n "${NIVEL_1_1_AUTH_ONLY:-}" ]; then
  echo "AUTH-ONLY SECURITY HARNESS SUMMARY PASS=$pass FAIL=$fail"
else
  echo "AGGREGATE SECURITY HARNESS SUMMARY PASS=$pass FAIL=$fail"
fi
exit $fail
