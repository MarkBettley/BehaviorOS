#!/usr/bin/env bash
# Nivel 1.1 S1 — Auth/session capability probe against the healthy Nivel 0.2 runtime.
set +H
set -uo pipefail
cd "$(dirname "$0")/.."
set -a && source .env && set +a
psql(){ docker compose exec -T db psql -U postgres -d postgres -tA -c "$1"; }
fail=0; pass=0
check(){ if [ "$1" = "$2" ]; then echo "[PASS] $3"; pass=$((pass+1)); else echo "[FAIL] $3 expected=$1 observed=$2"; fail=$((fail+1)); fi; }

./scripts/healthcheck.sh >/dev/null || { echo "runtime unhealthy"; exit 1; }
check healthy healthy "runtime health"
echo "auth.sessions columns: $(psql "SELECT string_agg(column_name,',') FROM information_schema.columns WHERE table_schema='auth' AND table_name='sessions'")"

email="s1-probe-$(date +%s)@example.local"; pw='S1ProbePassLong123'
u=$(curl -s -X POST "$API_EXTERNAL_URL/auth/v1/admin/users" -H "apikey:$SERVICE_ROLE_KEY" -H "Authorization:Bearer $SERVICE_ROLE_KEY" -H "Content-Type:application/json" -d "{\"email\":\"$email\",\"password\":\"$pw\",\"email_confirm\":true}" | sed -n 's/.*"id":"\([^"]*\)".*/\1/p')
check present "$([ -n "$u" ] && echo present || echo absent)" "admin create user"

tok=$(curl -s -X POST "$API_EXTERNAL_URL/auth/v1/token?grant_type=password" -H "apikey:$ANON_KEY" -H "Content-Type:application/json" -d "{\"email\":\"$email\",\"password\":\"$pw\"}")
at=$(echo "$tok" | sed -n 's/.*"access_token":"\([^"]*\)".*/\1/p'); rt=$(echo "$tok" | sed -n 's/.*"refresh_token":"\([^"]*\)".*/\1/p')
check present "$([ -n "$at" ] && echo present || echo absent)" "access_token returned"
check present "$([ -n "$rt" ] && echo present || echo absent)" "refresh_token returned"

sleep 1; s1=$(psql "SELECT count(*) FROM auth.sessions WHERE user_id='$u'")
check exists "$([ "$s1" -ge 1 ] 2>/dev/null && echo exists || echo absent)" "sessions exist after login"
sid=$(psql "SELECT id::text FROM auth.sessions WHERE user_id='$u' LIMIT 1")
row=$(psql "SELECT COALESCE(user_agent,'NULL')||'|'||COALESCE(ip::text,'NULL') FROM auth.sessions WHERE id='$sid'")
echo "session_id=$sid user_agent=${row%|*} ip=${row#*|}"
check present "$([ -n "$sid" ] && echo present || echo absent)" "session identifier"
check "$u" "$(psql "SELECT user_id::text FROM auth.sessions WHERE id='$sid'")" "actor user_id in session"
check present_or_null "$([ "${row%|*}" = "NULL" ] && echo null || echo present_or_null)" "user_agent present or null"
check present_or_null "$([ "${row#*|}" = "NULL" ] && echo null || echo present_or_null)" "ip present or null"
check 0 "$(psql "SELECT count(*) FROM information_schema.columns WHERE table_schema='auth' AND table_name='sessions' AND column_name IN ('correlation_id','origin')")" "auth.sessions lacks correlation_id/origin"

code=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API_EXTERNAL_URL/auth/v1/logout" -H "apikey:$ANON_KEY" -H "Authorization:Bearer $at" -H "Content-Type:application/json" -d "{\"refresh_token\":\"$rt\"}")
sleep 1; s2=$(psql "SELECT count(*) FROM auth.sessions WHERE user_id='$u'")
echo "logout HTTP code=$code sessions after_login=$s1 after_logout=$s2"
check decreased "$([ "$s2" -lt "$s1" ] 2>/dev/null && echo decreased || echo "$s2")" "sessions decrease after logout"

dc=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE "$API_EXTERNAL_URL/auth/v1/admin/users/$u" -H "apikey:$SERVICE_ROLE_KEY" -H "Authorization:Bearer $SERVICE_ROLE_KEY")
check 200_or_204 "$([ "$dc" = "200" ] || [ "$dc" = "204" ] && echo 200_or_204 || echo "$dc")" "cleanup test user"
echo "S1 summary PASS=$pass FAIL=$fail"
exit $fail
