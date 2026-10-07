#!/usr/bin/env bash
# Nivel 1.1 S4 — Session/JWT lifecycle harness.
# Proves: no BehaviorOS access-JWT denylist, logout revokes session/refresh,
# access JWT stays valid until exp, expired JWT is rejected.
set +H
set -uo pipefail
cd "$(dirname "$0")/.."
set -a && source .env && set +a
API="${API_EXTERNAL_URL:-http://localhost:8000}"
psql(){ docker compose exec -T db psql -U postgres -d postgres -tA -c "$1"; }
fail=0; pass=0; u=""
check(){ if [ "$1" = "$2" ]; then echo "[PASS] $3"; pass=$((pass+1)); else echo "[FAIL] $3 expected=$1 observed=$2"; fail=$((fail+1)); fi; }
cleanup(){ [ -n "${u:-}" ] && curl -s -o /dev/null -X DELETE "$API/auth/v1/admin/users/$u" -H "apikey:$SERVICE_ROLE_KEY" -H "Authorization:Bearer $SERVICE_ROLE_KEY"; }
trap cleanup EXIT
./scripts/healthcheck.sh >/dev/null || { echo "runtime unhealthy"; exit 1; }
check healthy healthy "runtime health"
# RED: no custom access-JWT denylist / revocation mechanism.
dt=$(psql "SELECT count(*) FROM information_schema.tables WHERE table_schema IN ('public','auth') AND table_name ~* 'denylist|revocation|revoked|blacklist|invalidat'")
check 0 "$dt" "RED: no denylist/revocation table"
df=$(psql "SELECT count(*) FROM information_schema.routines WHERE routine_schema IN ('public','auth') AND routine_name ~* 'denylist|revoke_access|invalidate_jwt|blacklist'")
check 0 "$df" "RED: no access-JWT invalidation routine"
# GREEN: login, logout, and token lifecycle.
email="s4-$(date +%s%N)@example.local"; pw='S4VerifyPassLong123'
u=$(curl -s -X POST "$API/auth/v1/admin/users" -H "apikey:$SERVICE_ROLE_KEY" -H "Authorization:Bearer $SERVICE_ROLE_KEY" -H "Content-Type:application/json" -d "{\"email\":\"$email\",\"password\":\"$pw\",\"email_confirm\":true}" | sed -n 's/.*"id":"\([^"]*\)".*/\1/p')
check present "$([ -n "$u" ] && echo present || echo absent)" "admin create user"
tok=$(curl -s -X POST "$API/auth/v1/token?grant_type=password" -H "apikey:$ANON_KEY" -H "Content-Type:application/json" -d "{\"email\":\"$email\",\"password\":\"$pw\"}")
at=$(echo "$tok" | sed -n 's/.*"access_token":"\([^"]*\)".*/\1/p'); rt=$(echo "$tok" | sed -n 's/.*"refresh_token":"\([^"]*\)".*/\1/p')
check present "$([ -n "$at" ] && echo present || echo absent)" "login access_token"
check present "$([ -n "$rt" ] && echo present || echo absent)" "login refresh_token"
pay=$(echo "$at" | cut -d. -f2); pad=$((4 - ${#pay} % 4)); [ $pad -eq 4 ] && pad=0
pay_std=$(printf '%s' "$pay" | sed 's/-/+/g; s/_/\//g')$(printf '=%.0s' $(seq 1 $pad))
exp=$(echo "$pay_std" | base64 -d 2>/dev/null | sed -n 's/.*"exp":\([0-9]*\).*/\1/p')
iat=$(echo "$pay_std" | base64 -d 2>/dev/null | sed -n 's/.*"iat":\([0-9]*\).*/\1/p')
check present "$([ -n "$exp" ] && echo present || echo absent)" "access token exp claim"
echo "READBACK iat=$iat exp=$exp ttl=$((exp-iat))"
check 1 "$(psql "SELECT count(*) FROM auth.sessions WHERE user_id='$u'")" "session exists after login"
lcode=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/auth/v1/logout" -H "apikey:$ANON_KEY" -H "Authorization:Bearer $at" -H "Content-Type:application/json" -d "{\"refresh_token\":\"$rt\"}")
check 200_or_204 "$([ "$lcode" = "200" ] || [ "$lcode" = "204" ] && echo 200_or_204 || echo "$lcode")" "logout returns 200/204"
check 0 "$(psql "SELECT count(*) FROM auth.sessions WHERE user_id='$u'")" "session revoked after logout"
rcode=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/auth/v1/token?grant_type=refresh_token" -H "apikey:$ANON_KEY" -H "Content-Type:application/json" -d "{\"refresh_token\":\"$rt\"}")
check 400_or_401 "$([ "$rcode" = "400" ] || [ "$rcode" = "401" ] && echo 400_or_401 || echo "$rcode")" "refresh token denied after logout"
# No BehaviorOS access-token denylist: still accepted by PostgREST before exp.
acode=$(curl -s -o /dev/null -w "%{http_code}" -X GET "$API/rest/v1/patient_profiles?select=user_id&limit=1" -H "apikey:$ANON_KEY" -H "Authorization:Bearer $at")
check 200 "$acode" "access JWT accepted before exp after logout (no denylist)"
# READBACK: expired JWT rejected.
et=$(python3 - "$JWT_SECRET" "$u" <<'PY'
import hmac, hashlib, base64, json, sys, time
s=sys.argv[1].encode(); sub=sys.argv[2]; n=int(time.time())
pld={"sub":sub,"role":"authenticated","aud":"authenticated","iat":n-7200,"exp":n-3600}
def b(d): return base64.urlsafe_b64encode(d).rstrip(b'=').decode()
h=b(json.dumps({"alg":"HS256","typ":"JWT"}).encode())
p=b(json.dumps(pld).encode())
sg=base64.urlsafe_b64encode(hmac.new(s,(h+'.'+p).encode(),hashlib.sha256).digest()).rstrip(b'=').decode()
print(h+'.'+p+'.'+sg)
PY
)
ecode=$(curl -s -o /dev/null -w "%{http_code}" -X GET "$API/rest/v1/patient_profiles?select=user_id&limit=1" -H "apikey:$ANON_KEY" -H "Authorization:Bearer $et")
check 401 "$ecode" "expired access JWT rejected"
echo "S4 summary PASS=$pass FAIL=$fail"
exit $fail
