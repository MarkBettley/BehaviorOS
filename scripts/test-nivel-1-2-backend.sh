#!/usr/bin/env bash
# Nivel 1.2 backend API smoke test.
# Covers health, OpenAPI/docs, JWT failures, /auth/me, exercise catalog,
# start, complete, idempotency, and direct RLS reads.
set +H
set -o pipefail

cd "$(dirname "$0")/.."
set -a
source .env
set +a
set -u

API="${API:-http://localhost:8001}"
KONG="${API_EXTERNAL_URL:-http://localhost:8000}"
TEST_TAG="n12-backend-$(date +%s%N)"
fail=0
pass=0
RESP_BODY=""
RESP_CODE=""

curl_capture() {
  local tmpfile
  tmpfile=$(mktemp)
  RESP_CODE=$(curl -s -o "$tmpfile" -w "%{http_code}" "$@")
  RESP_BODY=$(cat "$tmpfile")
  rm -f "$tmpfile"
}

psql() {
  docker compose exec -T db psql -U postgres -d postgres -tA -c "$1"
}

psql_as_patient() {
  local sub="$1" sql="$2"
  # Run the query inside a single explicit transaction as the Supabase authenticated
  # role, with the patient's identity set transaction-local so RLS policies evaluate
  # with the caller's uid.
  docker compose exec -T db psql -U postgres -d postgres -tA --single-transaction \
    -c "SET LOCAL ROLE authenticated; SELECT set_config('request.jwt.claim.sub', '$sub', true); $sql" \
    | tail -n 1
}

check() {
  if [ "$1" = "$2" ]; then
    echo "[PASS] $3"
    pass=$((pass + 1))
  else
    echo "[FAIL] $3 expected=$1 observed=$2"
    fail=$((fail + 1))
  fi
}

http_code() {
  curl -s -o /dev/null -w "%{http_code}" "$@"
}

json_get() {
  python3 -c "import sys,json; print(json.load(sys.stdin).get('$2',''))" <<<"$1"
}

json_len() {
  python3 -c "import sys,json; print(len(json.load(sys.stdin)))" <<<"$1"
}

json_has_ok_status() {
  python3 -c "import sys,json; d=json.load(sys.stdin); sys.exit(0 if d.get('status')=='ok' else 1)" <<<"$1"
}

# Build a signed HS256 JWT for a synthetic patient identity.
make_jwt() {
  local secret="${1:?JWT secret required}"
  local sub="${2:?Patient ID required}"
  local email="${3:-}"
  local app_role="${4:-}"
  local exp_offset="${5:-3600}"
  local anonymous="${6:-false}"
  local sign_secret="${7:-$secret}"
  local alg="${8:-HS256}"
  python3 - "$secret" "$sub" "$email" "$app_role" "$exp_offset" "$anonymous" "$sign_secret" "$alg" <<'PY'
import sys, time, json, base64, hmac, hashlib
secret, sub, email, app_role, exp_offset, anonymous, sign_secret, alg = sys.argv[1:9]
now = int(time.time())
payload = {"sub": sub, "role": "authenticated", "aud": "authenticated", "iat": now, "exp": now + int(exp_offset)}
if email:
    payload["email"] = email
if app_role:
    payload["app_metadata"] = {"app_role": app_role}
if anonymous.lower() == "true":
    payload["is_anonymous"] = True
header = {"alg": alg, "typ": "JWT"}
def b64(d):
    return base64.urlsafe_b64encode(json.dumps(d, separators=(',', ':')).encode()).rstrip(b'=').decode()
msg = b64(header) + "." + b64(payload)
if alg == "none":
    print(msg + ".")
else:
    sig = base64.urlsafe_b64encode(hmac.new(sign_secret.encode(), msg.encode(), hashlib.sha256).digest()).rstrip(b'=').decode()
    print(msg + "." + sig)
PY
}

create_user() {
  local email="$1" password="$2"
  local resp
  resp=$(curl -s -X POST "$KONG/auth/v1/admin/users" \
    -H "apikey:$SERVICE_ROLE_KEY" \
    -H "Authorization:Bearer $SERVICE_ROLE_KEY" \
    -H "Content-Type:application/json" \
    -d "{\"email\":\"$email\",\"password\":\"$password\",\"email_confirm\":true}")
  json_get "$resp" "id"
}

cleanup_patient() {
  local pid="$1"
  [ -n "$pid" ] || return 0
  psql "DELETE FROM public.exercise_telemetry WHERE session_id IN (SELECT id FROM public.exercise_sessions WHERE patient_id='$pid');" >/dev/null 2>&1 || true
  psql "DELETE FROM public.exercise_sessions WHERE patient_id='$pid';" >/dev/null 2>&1 || true
  psql "DELETE FROM public.patient_profiles WHERE user_id='$pid';" >/dev/null 2>&1 || true
  psql "DELETE FROM auth.users WHERE id='$pid';" >/dev/null 2>&1 || true
}

cleanup() {
  cleanup_patient "${PA_ID:-}"
  cleanup_patient "${PB_ID:-}"
}
trap cleanup EXIT

# --- Preflight ---------------------------------------------------------------
if [ -z "${SUPABASE_JWT_SECRET:-}" ]; then
  echo "[ENV FAIL] SUPABASE_JWT_SECRET is not set; source a populated .env"
  exit 1
fi
if [ -z "${SERVICE_ROLE_KEY:-}" ]; then
  echo "[ENV FAIL] SERVICE_ROLE_KEY is not set; source a populated .env"
  exit 1
fi

health_code=$(http_code "$API/api/v1/health")
if [ "$health_code" != "200" ]; then
  echo "[ENV FAIL] Backend not reachable at $API/api/v1/health (HTTP $health_code)"
  exit 1
fi

# --- Test users --------------------------------------------------------------
PA_EMAIL="$TEST_TAG-a@example.local"
PB_EMAIL="$TEST_TAG-b@example.local"
PA_PASSWORD='N12BackendPassLongA123'
PB_PASSWORD='N12BackendPassLongB123'

PA_ID=$(create_user "$PA_EMAIL" "$PA_PASSWORD")
PB_ID=$(create_user "$PB_EMAIL" "$PB_PASSWORD")
check present "$([ -n "$PA_ID" ] && echo present || echo absent)" "create patient A"
check present "$([ -n "$PB_ID" ] && echo present || echo absent)" "create patient B"

# The registration trigger creates profiles automatically.
# Keep A's profile; remove only B's synthetic profile for the
# approved identity-without-profile scenario.
psql "INSERT INTO public.patient_profiles (user_id) VALUES ('$PA_ID') ON CONFLICT DO NOTHING;" >/dev/null
check 1 "$(psql "SELECT count(*) FROM public.patient_profiles WHERE user_id='$PA_ID'")" "patient A profile seeded"

if [ -n "$PB_ID" ]; then
  psql "DELETE FROM public.patient_profiles WHERE user_id='$PB_ID';" >/dev/null
fi
check 0 "$(psql "SELECT count(*) FROM public.patient_profiles WHERE user_id='$PB_ID'")" "patient B has no profile"

PA_TOKEN=$(make_jwt "$SUPABASE_JWT_SECRET" "$PA_ID" "$PA_EMAIL" "patient")
PB_TOKEN=$(make_jwt "$SUPABASE_JWT_SECRET" "$PB_ID" "$PB_EMAIL" "patient")
check present "$([ -n "$PA_TOKEN" ] && echo present || echo absent)" "patient A token signed"
check present "$([ -n "$PB_TOKEN" ] && echo present || echo absent)" "patient B token signed"

# --- Health and docs ---------------------------------------------------------
echo ""
echo "=== Health and OpenAPI/docs ==="
health_body=$(curl -s "$API/api/v1/health")
json_has_ok_status "$health_body"
check 0 "$?" "health body contains status ok"
check 200 "$(http_code "$API/api/v1/health")" "GET /api/v1/health"
openapi_body=$(curl -s "$API/api/v1/openapi.json")
check 200 "$(http_code "$API/api/v1/openapi.json")" "GET /api/v1/openapi.json"
check present "$([ -n "$(echo "$openapi_body" | grep '/api/v1/health')" ] && echo present || echo absent)" "openapi.json contains /api/v1 paths"
check 200 "$(http_code "$API/docs")" "GET /docs"

# --- JWT failures ------------------------------------------------------------
echo ""
echo "=== JWT failure cases ==="
check 401 "$(http_code "$API/api/v1/auth/me")" "missing Authorization header returns 401"
check 401 "$(http_code "$API/api/v1/auth/me" -H "Authorization: Bearer not-a-jwt")" "malformed token returns 401"

bad_sig=$(make_jwt "$SUPABASE_JWT_SECRET" "$PA_ID" "$PA_EMAIL" "patient" 3600 false "wrong-secret-for-signature-test")
check 401 "$(http_code "$API/api/v1/auth/me" -H "Authorization: Bearer $bad_sig")" "wrong-signature token returns 401"

expired=$(make_jwt "$SUPABASE_JWT_SECRET" "$PA_ID" "$PA_EMAIL" "patient" -3600)
check 401 "$(http_code "$API/api/v1/auth/me" -H "Authorization: Bearer $expired")" "expired token returns 401"

alg_none=$(make_jwt "$SUPABASE_JWT_SECRET" "$PA_ID" "$PA_EMAIL" "patient" 3600 false "$SUPABASE_JWT_SECRET" "none")
check 401 "$(http_code "$API/api/v1/auth/me" -H "Authorization: Bearer $alg_none")" "alg:none token returns 401"

anonymous=$(make_jwt "$SUPABASE_JWT_SECRET" "$PA_ID" "$PA_EMAIL" "patient" 3600 true)
check 401 "$(http_code "$API/api/v1/auth/me" -H "Authorization: Bearer $anonymous")" "anonymous token returns 401"

# --- /auth/me ----------------------------------------------------------------
echo ""
echo "=== /auth/me ==="
me_a=$(curl -s "$API/api/v1/auth/me" -H "Authorization: Bearer $PA_TOKEN")
check 200 "$(http_code "$API/api/v1/auth/me" -H "Authorization: Bearer $PA_TOKEN")" "authenticated /auth/me returns 200"
check "$PA_ID" "$(json_get "$me_a" "sub")" "/auth/me sub matches patient A"
check "$PA_EMAIL" "$(json_get "$me_a" "email")" "/auth/me email matches patient A"
check "patient" "$(json_get "$me_a" "app_role")" "/auth/me app_role is patient"
check present "$([ "$(json_get "$me_a" "profile")" != "" ] && echo present || echo absent)" "/auth/me returns a profile block for patient A"

me_b=$(curl -s "$API/api/v1/auth/me" -H "Authorization: Bearer $PB_TOKEN")
check 200 "$(http_code "$API/api/v1/auth/me" -H "Authorization: Bearer $PB_TOKEN")" "authenticated /auth/me without profile returns 200"
check "$PB_ID" "$(json_get "$me_b" "sub")" "/auth/me sub matches patient B"
profile_b_is_null=$(python3 -c '
import json
import sys
data = json.load(sys.stdin)
print("yes" if data.get("profile") is None else "no")
' <<<"$me_b")
check yes "$profile_b_is_null" "/auth/me profile is null/absent for patient B"

# --- Catalog -----------------------------------------------------------------
echo ""
echo "=== Exercise catalog ==="
catalog=$(curl -s "$API/api/v1/exercises" -H "Authorization: Bearer $PA_TOKEN")
check 200 "$(http_code "$API/api/v1/exercises" -H "Authorization: Bearer $PA_TOKEN")" "GET /exercises returns 200"
check 1 "$(json_len "$catalog")" "catalog contains exactly one exercise"
check "mindfulness" "$(python3 -c "import sys,json; print(json.load(sys.stdin)[0].get('type',''))" <<<"$catalog")" "exercise type is mindfulness"
check "EX_1" "$(python3 -c "import sys,json; print(json.load(sys.stdin)[0].get('id',''))" <<<"$catalog")" "exercise id is EX_1"

check 200 "$(http_code "$API/api/v1/exercises/EX_1" -H "Authorization: Bearer $PA_TOKEN")" "GET /exercises/EX_1 returns 200"
check 404 "$(http_code "$API/api/v1/exercises/UNKNOWN" -H "Authorization: Bearer $PA_TOKEN")" "GET /exercises/UNKNOWN returns 404"

# --- Start / Complete / Idempotency ------------------------------------------
echo ""
echo "=== Start, complete, idempotency ==="
curl_capture -X POST "$API/api/v1/exercises/UNKNOWN/start" -H "Authorization: Bearer $PA_TOKEN" -H "Content-Type:application/json"
check 404 "$RESP_CODE" "start non-existent exercise returns 404"

curl_capture -X POST "$API/api/v1/exercises/EX_1/start" -H "Authorization: Bearer $PA_TOKEN" -H "Content-Type:application/json"
start_a=$RESP_BODY
check 201 "$RESP_CODE" "start EX_1 returns 201"
SESSION_A=$(json_get "$start_a" "session_id")
check present "$([ -n "$SESSION_A" ] && echo present || echo absent)" "start response contains session_id"
check "EX_1" "$(json_get "$start_a" "exercise_id")" "start response exercise_id is EX_1"
check "active" "$(json_get "$start_a" "status")" "start response status is active"

# Cross-patient completion must return 404.
curl_capture -X POST "$API/api/v1/exercises/EX_1/complete" \
  -H "Authorization: Bearer $PB_TOKEN" -H "Content-Type:application/json" \
  -d "{\"session_id\":\"$SESSION_A\",\"pauses\":0,\"retries\":0}"
check 404 "$RESP_CODE" "patient B cannot complete patient A session"

# Complete the active session and record telemetry.
complete_payload="{\"session_id\":\"$SESSION_A\",\"pauses\":2,\"retries\":1}"
curl_capture -X POST "$API/api/v1/exercises/EX_1/complete" -H "Authorization: Bearer $PA_TOKEN" -H "Content-Type:application/json" -d "$complete_payload"
complete_a=$RESP_BODY
check 200 "$RESP_CODE" "complete active session returns 200"
check "completed" "$(json_get "$complete_a" "status")" "completed session status is completed"

telemetry_count=$(psql "SELECT count(*) FROM public.exercise_telemetry WHERE session_id='$SESSION_A'")
check 4 "$telemetry_count" "active completion inserts exactly four telemetry rows"

# Idempotent retry must return 200 without changing data.
curl_capture -X POST "$API/api/v1/exercises/EX_1/complete" -H "Authorization: Bearer $PA_TOKEN" -H "Content-Type:application/json" -d "$complete_payload"
complete_a2=$RESP_BODY
check 200 "$RESP_CODE" "idempotent completion returns 200"
telemetry_count2=$(psql "SELECT count(*) FROM public.exercise_telemetry WHERE session_id='$SESSION_A'")
check "$telemetry_count" "$telemetry_count2" "idempotent completion leaves telemetry count unchanged"

# Complete without an active session must return 400.
curl_capture -X POST "$API/api/v1/exercises/EX_1/start" -H "Authorization: Bearer $PA_TOKEN" -H "Content-Type:application/json"
start_for_cancel=$RESP_BODY
SESSION_CANCEL=$(json_get "$start_for_cancel" "session_id")
psql "UPDATE public.exercise_sessions SET status='cancelled' WHERE id='$SESSION_CANCEL';" >/dev/null
curl_capture -X POST "$API/api/v1/exercises/EX_1/complete" -H "Authorization: Bearer $PA_TOKEN" -H "Content-Type:application/json" -d "{\"session_id\":\"$SESSION_CANCEL\",\"pauses\":0,\"retries\":0}"
check 400 "$RESP_CODE" "complete cancelled session returns 400"

# --- Direct RLS reads --------------------------------------------------------
echo ""
echo "=== Direct RLS reads ==="
pa_sessions_expected=$(psql "SELECT count(*) FROM public.exercise_sessions WHERE patient_id='$PA_ID'")
check yes "$([ "$pa_sessions_expected" -gt 0 ] && echo yes || echo no)" "patient A has sessions to test RLS"
pa_sessions=$(psql_as_patient "$PA_ID" "SELECT count(*) FROM public.exercise_sessions;")
pb_sessions=$(psql_as_patient "$PB_ID" "SELECT count(*) FROM public.exercise_sessions;")
check "$pa_sessions_expected" "$pa_sessions" "patient A sees only own sessions via RLS"
check 0 "$pb_sessions" "patient B sees zero sessions via RLS"

pa_telemetry_expected=$(psql "SELECT count(*) FROM public.exercise_telemetry WHERE session_id IN (SELECT id FROM public.exercise_sessions WHERE patient_id='$PA_ID')")
check yes "$([ "$pa_telemetry_expected" -gt 0 ] && echo yes || echo no)" "patient A has telemetry to test RLS"
pa_telemetry=$(psql_as_patient "$PA_ID" "SELECT count(*) FROM public.exercise_telemetry;")
pb_telemetry=$(psql_as_patient "$PB_ID" "SELECT count(*) FROM public.exercise_telemetry;")
check "$pa_telemetry_expected" "$pa_telemetry" "patient A sees only own telemetry via RLS"
check 0 "$pb_telemetry" "patient B sees zero telemetry via RLS"

b_sees_a_session=$(psql_as_patient "$PB_ID" "SELECT count(*) FROM public.exercise_sessions WHERE id='${SESSION_A:-}';")
check 0 "$b_sees_a_session" "patient B cannot select patient A session by id"

# --- Summary -----------------------------------------------------------------
echo ""
echo "Nivel 1.2 backend smoke summary PASS=$pass FAIL=$fail"
exit $fail
