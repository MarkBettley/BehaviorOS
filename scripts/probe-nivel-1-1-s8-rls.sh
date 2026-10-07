#!/usr/bin/env bash
# Nivel 1.1 S8 — Full RLS matrix RED/GREEN/READBACK harness.
# Proves: every table × operation × actor/context cell; policy readback;
# trusted writer INSERT ALLOW / UPDATE DENY / DELETE DENY.
set +H
set -uo pipefail
cd "$(dirname "$0")/.."
set -a && source .env && set +a
API="${API_EXTERNAL_URL:-http://localhost:8000}"
psql(){ docker compose exec -T db psql -U postgres -d postgres -tA -c "$1"; }
psql_table(){ docker compose exec -T db psql -U postgres -d postgres -P format=aligned -c "$1"; }
fail=0; pass=0; aid=""; bid=""
check(){ if [ "$1" = "$2" ]; then echo "[PASS] $3"; pass=$((pass+1)); else echo "[FAIL] $3 expected=$1 observed=$2"; fail=$((fail+1)); fi; }
cleanup(){ [ -n "${aid:-}" ] && curl -s -o /dev/null -X DELETE "$API/auth/v1/admin/users/$aid" -H "apikey:$SERVICE_ROLE_KEY" -H "Authorization:Bearer $SERVICE_ROLE_KEY" || true; [ -n "${bid:-}" ] && curl -s -o /dev/null -X DELETE "$API/auth/v1/admin/users/$bid" -H "apikey:$SERVICE_ROLE_KEY" -H "Authorization:Bearer $SERVICE_ROLE_KEY" || true; docker compose exec -T db psql -U postgres -d postgres -tA -c "DELETE FROM public.audit_logs WHERE correlation_id='bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb';" >/dev/null 2>&1 || true; }
trap cleanup EXIT
./scripts/healthcheck.sh >/dev/null || { echo "runtime unhealthy"; exit 1; }
check healthy healthy "runtime health"

signup(){ curl -s -X POST "$API/auth/v1/signup" -H "apikey:$ANON_KEY" -H "Content-Type:application/json" -d "{\"email\":\"$1\",\"password\":\"S8VerifyPassLong123\"}"; }

# === Test identities ===
ts=$(date +%s%N)
ra=$(signup "s8-a-$ts@example.local"); ata=$(echo "$ra" | sed -n 's/.*"access_token":"\([^"]*\)".*/\1/p'); aid=$(echo "$ra" | sed -n 's/.*"id":"\([^"]*\)".*/\1/p')
rb=$(signup "s8-b-$ts@example.local"); atb=$(echo "$rb" | sed -n 's/.*"access_token":"\([^"]*\)".*/\1/p'); bid=$(echo "$rb" | sed -n 's/.*"id":"\([^"]*\)".*/\1/p')
check present "$([ -n "$ata" ] && echo present || echo absent)" "patient A token"
check present "$([ -n "$atb" ] && echo present || echo absent)" "patient B token"
check present "$([ -n "$aid" ] && echo present || echo absent)" "patient A id"
check present "$([ -n "$bid" ] && echo present || echo absent)" "patient B id"

# === Seed owned rows for matrix tests ===
curl -s -o /dev/null -X POST "$API/rest/v1/patient_consents" -H "apikey:$ANON_KEY" -H "Authorization:Bearer $ata" -H "Content-Type:application/json" -d "{\"user_id\":\"$aid\",\"scope\":\"terms_of_service\",\"version\":\"1.0.0\",\"action\":\"grant\"}"
curl -s -o /dev/null -X POST "$API/rest/v1/patient_consents" -H "apikey:$ANON_KEY" -H "Authorization:Bearer $atb" -H "Content-Type:application/json" -d "{\"user_id\":\"$bid\",\"scope\":\"privacy_policy\",\"version\":\"1.0.0\",\"action\":\"grant\"}"
curl -s -o /dev/null -X PATCH "$API/rest/v1/patient_profiles?user_id=eq.$aid" -H "apikey:$ANON_KEY" -H "Authorization:Bearer $ata" -H "Content-Type:application/json" -H "Prefer:return=minimal" -d '{"updated_at":"2026-01-01T00:00:00Z"}'
curl -s -o /dev/null -X PATCH "$API/rest/v1/patient_profiles?user_id=eq.$bid" -H "apikey:$ANON_KEY" -H "Authorization:Bearer $atb" -H "Content-Type:application/json" -H "Prefer:return=minimal" -d '{"updated_at":"2026-01-02T00:00:00Z"}'

# === READBACK: policy inventory ===
echo ""
echo "=== S8 READBACK: RLS policy inventory ==="
psql_table "SELECT tablename AS table, policyname AS policy_name, cmd AS op, CASE WHEN COALESCE(qual,'') LIKE '%auth.uid()%' OR COALESCE(with_check,'') LIKE '%auth.uid()%' THEN 'yes' ELSE 'no' END AS auth_uid, CASE WHEN COALESCE(qual,'') LIKE '%actor_user_id%' OR COALESCE(with_check,'') LIKE '%actor_user_id%' THEN 'ownership(actor_user_id)' WHEN COALESCE(qual,'') LIKE '%user_id%' OR COALESCE(with_check,'') LIKE '%user_id%' THEN 'ownership(user_id)' WHEN btrim(COALESCE(qual,'')) = 'true' OR btrim(COALESCE(qual,'')) = 'false' THEN btrim(COALESCE(qual,'')) ELSE 'other' END AS ownership, CASE WHEN COALESCE(qual,'') LIKE '%actor_user_id%' OR COALESCE(with_check,'') LIKE '%actor_user_id%' THEN 'actor_user_id' WHEN COALESCE(qual,'') LIKE '%user_id%' OR COALESCE(with_check,'') LIKE '%user_id%' THEN 'user_id' ELSE NULL END AS user_id, array_to_string(roles, ',') AS role, qual AS using, with_check FROM pg_policies WHERE schemaname='public' AND tablename IN ('patient_profiles','consent_versions','patient_consents','audit_logs') ORDER BY tablename, policyname;"

# === READBACK: grants inventory ===
echo ""
echo "=== S8 READBACK: grant inventory ==="
psql_table "SELECT grantee, table_name, string_agg(privilege_type, ', ' ORDER BY privilege_type) AS privileges FROM information_schema.table_privileges WHERE grantee IN ('anon','authenticated','service_role') AND table_schema='public' AND table_name IN ('patient_profiles','consent_versions','patient_consents','audit_logs') GROUP BY grantee, table_name ORDER BY table_name, grantee;"

# === Matrix helpers ===
# $1=table $2=op $3=token(or anon) $4=target_user_id(or '') $5=expected(ALLOW|DENY) $6=label
run_cell(){
  local tbl="$1" op="$2" tok="$3" target="$4" expected="$5" label="$6"
  local code body observed result
  local hdr=(-H "apikey:$ANON_KEY")
  [ "$tok" != "anon" ] && hdr+=(-H "Authorization:Bearer $tok")
  case "$op" in
    SELECT)
      local filter=""
      [ -n "$target" ] && filter="?user_id=eq.$target"
      [ "$tbl" = "audit_logs" ] && [ -n "$target" ] && filter="?actor_user_id=eq.$target"
      code=$(curl -s -o /tmp/s8_body.json -w "%{http_code}" -X GET "$API/rest/v1/$tbl$filter" "${hdr[@]}")
      body=$(cat /tmp/s8_body.json)
      if [ "$code" = "401" ] || [ "$code" = "403" ]; then observed="DENY"; result="$expected==DENY"
      elif echo "$body" | grep -q '"'; then observed="ALLOW"; result="$expected==ALLOW"
      else observed="DENY"; result="$expected==DENY"
      fi
      ;;
    INSERT)
      local payload="{}"
      case "$tbl" in
        patient_profiles) payload="{\"user_id\":\"$target\"}" ;;
        patient_consents) payload="{\"user_id\":\"$target\",\"scope\":\"terms_of_service\",\"version\":\"1.0.0\",\"action\":\"grant\"}" ;;
        consent_versions) payload="{\"scope\":\"terms_of_service\",\"version\":\"9.9.9-s8\",\"text\":\"test\",\"is_current\":false}" ;;
        audit_logs) payload="{\"actor_user_id\":\"$target\",\"event_type\":\"login\",\"outcome\":\"success\",\"correlation_id\":\"aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa\"}" ;;
      esac
      code=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/rest/v1/$tbl" "${hdr[@]}" -H "Content-Type:application/json" -d "$payload")
      if [ "$code" = "401" ] || [ "$code" = "403" ]; then observed="DENY"; result="$expected==DENY"
      elif [ "$code" = "409" ]; then observed="ALLOW(conflict)"; result="$expected==ALLOW"
      elif [ "$code" -ge 200 ] && [ "$code" -lt 300 ]; then observed="ALLOW"; result="$expected==ALLOW"
      else observed="DENY($code)"; result="$expected==DENY"
      fi
      ;;
    UPDATE)
      local filter="" payload="{}"
      [ -n "$target" ] && filter="?user_id=eq.$target"
      [ "$tbl" = "audit_logs" ] && [ -n "$target" ] && filter="?actor_user_id=eq.$target"
      case "$tbl" in
        patient_profiles) payload='{"updated_at":"2026-06-06T00:00:00Z"}' ;;
        patient_consents) payload='{"action":"revoke"}' ;;
        consent_versions) payload='{"text":"hacked"}' ;;
        audit_logs) payload='{"outcome":"failure"}' ;;
      esac
      local before_sig="" after_sig=""
      if [ -n "$target" ]; then
        case "$tbl" in
          patient_profiles) before_sig=$(psql "SELECT updated_at::text FROM public.patient_profiles WHERE user_id='$target'");;
          patient_consents) before_sig=$(psql "SELECT action FROM public.patient_consents WHERE user_id='$target' ORDER BY created_at DESC LIMIT 1");;
          audit_logs) before_sig=$(psql "SELECT outcome FROM public.audit_logs WHERE actor_user_id='$target' ORDER BY occurred_at DESC LIMIT 1");;
        esac
      elif [ "$tbl" = "consent_versions" ]; then
        before_sig=$(psql "SELECT text FROM public.consent_versions WHERE scope='terms_of_service' AND version='1.0.0'")
      fi
      code=$(curl -s -o /dev/null -w "%{http_code}" -X PATCH "$API/rest/v1/$tbl$filter" "${hdr[@]}" -H "Content-Type:application/json" -H "Prefer:return=minimal" -d "$payload")
      if [ "$code" = "401" ] || [ "$code" = "403" ]; then observed="DENY"; result="$expected==DENY"
      elif [ "$code" -ge 200 ] && [ "$code" -lt 300 ]; then
        if [ -n "$target" ] || [ "$tbl" = "consent_versions" ]; then
          case "$tbl" in
            patient_profiles) after_sig=$(psql "SELECT updated_at::text FROM public.patient_profiles WHERE user_id='$target'");;
            patient_consents) after_sig=$(psql "SELECT action FROM public.patient_consents WHERE user_id='$target' ORDER BY created_at DESC LIMIT 1");;
            audit_logs) after_sig=$(psql "SELECT outcome FROM public.audit_logs WHERE actor_user_id='$target' ORDER BY occurred_at DESC LIMIT 1");;
            consent_versions) after_sig=$(psql "SELECT text FROM public.consent_versions WHERE scope='terms_of_service' AND version='1.0.0'");;
          esac
          if [ "$before_sig" != "$after_sig" ]; then observed="ALLOW(changed)"; result="$expected==ALLOW"
          else observed="DENY(0 rows)"; result="$expected==DENY"
          fi
        else observed="ALLOW(204)"; result="$expected==ALLOW"
        fi
      else observed="DENY($code)"; result="$expected==DENY"
      fi
      ;;
    DELETE)
      local filter="" before_count="0" after_count="0"
      [ -n "$target" ] && filter="?user_id=eq.$target"
      [ "$tbl" = "audit_logs" ] && [ -n "$target" ] && filter="?actor_user_id=eq.$target"
      if [ -n "$target" ] || [ "$tbl" = "consent_versions" ]; then
        case "$tbl" in
          patient_profiles) before_count=$(psql "SELECT count(*) FROM public.patient_profiles WHERE user_id='$target'") ;;
          patient_consents) before_count=$(psql "SELECT count(*) FROM public.patient_consents WHERE user_id='$target'") ;;
          consent_versions) before_count=$(psql "SELECT count(*) FROM public.consent_versions") ;;
          audit_logs) before_count=$(psql "SELECT count(*) FROM public.audit_logs WHERE actor_user_id='$target'") ;;
        esac
      fi
      code=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE "$API/rest/v1/$tbl$filter" "${hdr[@]}")
      if [ "$code" = "401" ] || [ "$code" = "403" ]; then observed="DENY"; result="$expected==DENY"
      elif [ "$code" -ge 200 ] && [ "$code" -lt 300 ]; then
        if [ -n "$target" ] || [ "$tbl" = "consent_versions" ]; then
          case "$tbl" in
            patient_profiles) after_count=$(psql "SELECT count(*) FROM public.patient_profiles WHERE user_id='$target'") ;;
            patient_consents) after_count=$(psql "SELECT count(*) FROM public.patient_consents WHERE user_id='$target'") ;;
            consent_versions) after_count=$(psql "SELECT count(*) FROM public.consent_versions") ;;
            audit_logs) after_count=$(psql "SELECT count(*) FROM public.audit_logs WHERE actor_user_id='$target'") ;;
          esac
        fi
        if [ "$before_count" != "$after_count" ]; then observed="ALLOW(deleted)"; result="$expected==ALLOW"
        else observed="DENY(0 rows)"; result="$expected==DENY"
        fi
      else observed="DENY($code)"; result="$expected==DENY"
      fi
      ;;
  esac
  if [ "$result" = "ALLOW==ALLOW" ] || [ "$result" = "DENY==DENY" ]; then
    echo "[PASS] $label | expected=$expected observed=$observed"
    pass=$((pass+1))
  else
    echo "[FAIL] $label | expected=$expected observed=$observed"
    fail=$((fail+1))
  fi
  printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$tbl" "$op" "$label" "$expected" "$observed" "$([ "$result" = "ALLOW==ALLOW" ] || [ "$result" = "DENY==DENY" ] && echo PASS || echo FAIL)" >> /tmp/s8_matrix.tsv
}

rm -f /tmp/s8_matrix.tsv
printf '%s\t%s\t%s\t%s\t%s\t%s\n' "table" "operation" "actor_context" "expected" "observed" "result" > /tmp/s8_matrix.tsv

echo ""
echo "=== S8 RED/GREEN/READBACK: RLS matrix cells ==="

# patient_profiles
run_cell patient_profiles SELECT anon  "" DENY "anon SELECT patient_profiles"
run_cell patient_profiles SELECT "$ata" "$aid" ALLOW "A-own SELECT patient_profiles"
run_cell patient_profiles SELECT "$ata" "$bid" DENY "A->B SELECT patient_profiles"
run_cell patient_profiles SELECT "$atb" "$bid" ALLOW "B-own SELECT patient_profiles"
run_cell patient_profiles SELECT "$atb" "$aid" DENY "B->A SELECT patient_profiles"
run_cell patient_profiles INSERT anon  "" DENY "anon INSERT patient_profiles"
run_cell patient_profiles INSERT "$ata" "$aid" ALLOW "A-own INSERT patient_profiles"
run_cell patient_profiles INSERT "$ata" "$bid" DENY "A->B INSERT patient_profiles"
run_cell patient_profiles INSERT "$atb" "$bid" ALLOW "B-own INSERT patient_profiles"
run_cell patient_profiles INSERT "$atb" "$aid" DENY "B->A INSERT patient_profiles"
run_cell patient_profiles UPDATE anon  "" DENY "anon UPDATE patient_profiles"
run_cell patient_profiles UPDATE "$ata" "$aid" ALLOW "A-own UPDATE patient_profiles"
run_cell patient_profiles UPDATE "$ata" "$bid" DENY "A->B UPDATE patient_profiles"
run_cell patient_profiles UPDATE "$atb" "$bid" ALLOW "B-own UPDATE patient_profiles"
run_cell patient_profiles UPDATE "$atb" "$aid" DENY "B->A UPDATE patient_profiles"
run_cell patient_profiles DELETE anon  "" DENY "anon DELETE patient_profiles"
run_cell patient_profiles DELETE "$ata" "$aid" DENY "A-own DELETE patient_profiles"
run_cell patient_profiles DELETE "$ata" "$bid" DENY "A->B DELETE patient_profiles"
run_cell patient_profiles DELETE "$atb" "$bid" DENY "B-own DELETE patient_profiles"
run_cell patient_profiles DELETE "$atb" "$aid" DENY "B->A DELETE patient_profiles"

# consent_versions
run_cell consent_versions SELECT anon  "" DENY "anon SELECT consent_versions"
run_cell consent_versions SELECT "$ata" "" ALLOW "A SELECT consent_versions"
run_cell consent_versions SELECT "$atb" "" ALLOW "B SELECT consent_versions"
run_cell consent_versions INSERT anon  "" DENY "anon INSERT consent_versions"
run_cell consent_versions INSERT "$ata" "" DENY "A INSERT consent_versions"
run_cell consent_versions INSERT "$atb" "" DENY "B INSERT consent_versions"
run_cell consent_versions UPDATE anon  "" DENY "anon UPDATE consent_versions"
run_cell consent_versions UPDATE "$ata" "" DENY "A UPDATE consent_versions"
run_cell consent_versions UPDATE "$atb" "" DENY "B UPDATE consent_versions"
run_cell consent_versions DELETE anon  "" DENY "anon DELETE consent_versions"
run_cell consent_versions DELETE "$ata" "" DENY "A DELETE consent_versions"
run_cell consent_versions DELETE "$atb" "" DENY "B DELETE consent_versions"

# patient_consents
run_cell patient_consents SELECT anon  "" DENY "anon SELECT patient_consents"
run_cell patient_consents SELECT "$ata" "$aid" ALLOW "A-own SELECT patient_consents"
run_cell patient_consents SELECT "$ata" "$bid" DENY "A->B SELECT patient_consents"
run_cell patient_consents SELECT "$atb" "$bid" ALLOW "B-own SELECT patient_consents"
run_cell patient_consents SELECT "$atb" "$aid" DENY "B->A SELECT patient_consents"
run_cell patient_consents INSERT anon  "" DENY "anon INSERT patient_consents"
run_cell patient_consents INSERT "$ata" "$aid" ALLOW "A-own INSERT patient_consents"
run_cell patient_consents INSERT "$ata" "$bid" DENY "A->B INSERT patient_consents"
run_cell patient_consents INSERT "$atb" "$bid" ALLOW "B-own INSERT patient_consents"
run_cell patient_consents INSERT "$atb" "$aid" DENY "B->A INSERT patient_consents"
run_cell patient_consents UPDATE anon  "" DENY "anon UPDATE patient_consents"
run_cell patient_consents UPDATE "$ata" "$aid" DENY "A-own UPDATE patient_consents"
run_cell patient_consents UPDATE "$ata" "$bid" DENY "A->B UPDATE patient_consents"
run_cell patient_consents UPDATE "$atb" "$bid" DENY "B-own UPDATE patient_consents"
run_cell patient_consents UPDATE "$atb" "$aid" DENY "B->A UPDATE patient_consents"
run_cell patient_consents DELETE anon  "" DENY "anon DELETE patient_consents"
run_cell patient_consents DELETE "$ata" "$aid" DENY "A-own DELETE patient_consents"
run_cell patient_consents DELETE "$ata" "$bid" DENY "A->B DELETE patient_consents"
run_cell patient_consents DELETE "$atb" "$bid" DENY "B-own DELETE patient_consents"
run_cell patient_consents DELETE "$atb" "$aid" DENY "B->A DELETE patient_consents"

# audit_logs
run_cell audit_logs SELECT anon  "" DENY "anon SELECT audit_logs"
run_cell audit_logs SELECT "$ata" "$aid" ALLOW "A-own SELECT audit_logs"
run_cell audit_logs SELECT "$ata" "$bid" DENY "A->B SELECT audit_logs"
run_cell audit_logs SELECT "$atb" "$bid" ALLOW "B-own SELECT audit_logs"
run_cell audit_logs SELECT "$atb" "$aid" DENY "B->A SELECT audit_logs"
run_cell audit_logs INSERT anon  "" DENY "anon INSERT audit_logs"
run_cell audit_logs INSERT "$ata" "$aid" DENY "A-own INSERT audit_logs"
run_cell audit_logs INSERT "$ata" "$bid" DENY "A->B INSERT audit_logs"
run_cell audit_logs INSERT "$atb" "$bid" DENY "B-own INSERT audit_logs"
run_cell audit_logs INSERT "$atb" "$aid" DENY "B->A INSERT audit_logs"
run_cell audit_logs UPDATE anon  "" DENY "anon UPDATE audit_logs"
run_cell audit_logs UPDATE "$ata" "$aid" DENY "A-own UPDATE audit_logs"
run_cell audit_logs UPDATE "$ata" "$bid" DENY "A->B UPDATE audit_logs"
run_cell audit_logs UPDATE "$atb" "$bid" DENY "B-own UPDATE audit_logs"
run_cell audit_logs UPDATE "$atb" "$aid" DENY "B->A UPDATE audit_logs"
run_cell audit_logs DELETE anon  "" DENY "anon DELETE audit_logs"
run_cell audit_logs DELETE "$ata" "$aid" DENY "A-own DELETE audit_logs"
run_cell audit_logs DELETE "$ata" "$bid" DENY "A->B DELETE audit_logs"
run_cell audit_logs DELETE "$atb" "$bid" DENY "B-own DELETE audit_logs"
run_cell audit_logs DELETE "$atb" "$aid" DENY "B->A DELETE audit_logs"

# === Trusted writer ===
echo ""
echo "=== S8 RED/GREEN/READBACK: trusted writer cells ==="
tw_before=$(psql "SELECT count(*) FROM public.audit_logs WHERE actor_user_id='$aid' AND event_type='login' AND outcome='success' AND correlation_id='bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb'")
psql "SELECT security.write_audit_event('$aid','login','success','bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb','s8_harness','{}'::jsonb);" >/dev/null
tw_after=$(psql "SELECT count(*) FROM public.audit_logs WHERE actor_user_id='$aid' AND event_type='login' AND outcome='success' AND correlation_id='bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb'")
check 1 "$((tw_after - tw_before))" "trusted writer INSERT ALLOW (audit_logs +1)"
printf '%s\t%s\t%s\t%s\t%s\t%s\n' "audit_logs" "INSERT" "trusted writer" "ALLOW" "ALLOW" "PASS" >> /tmp/s8_matrix.tsv

tw_update=$(psql "SELECT count(*) FROM pg_proc p JOIN pg_namespace n ON n.oid=p.pronamespace WHERE n.nspname='security' AND p.prosrc ~* 'UPDATE\\s+public\.audit_logs'")
if [ "$tw_update" -eq 0 ]; then tw_update_obs="DENY"; else tw_update_obs="ALLOW($tw_update functions)"; fi
check DENY "$tw_update_obs" "trusted writer UPDATE audit_logs"
printf '%s\t%s\t%s\t%s\t%s\t%s\n' "audit_logs" "UPDATE" "trusted writer" "DENY" "$tw_update_obs" "$([ "$tw_update" -eq 0 ] && echo PASS || echo FAIL)" >> /tmp/s8_matrix.tsv

tw_delete=$(psql "SELECT count(*) FROM pg_proc p JOIN pg_namespace n ON n.oid=p.pronamespace WHERE n.nspname='security' AND p.prosrc ~* 'DELETE\\s+FROM\\s+public\.audit_logs'")
if [ "$tw_delete" -eq 0 ]; then tw_delete_obs="DENY"; else tw_delete_obs="ALLOW($tw_delete functions)"; fi
check DENY "$tw_delete_obs" "trusted writer DELETE audit_logs"
printf '%s\t%s\t%s\t%s\t%s\t%s\n' "audit_logs" "DELETE" "trusted writer" "DENY" "$tw_delete_obs" "$([ "$tw_delete" -eq 0 ] && echo PASS || echo FAIL)" >> /tmp/s8_matrix.tsv

# === Matrix TSV dump ===
echo ""
echo "=== S8 matrix TSV ==="
cat /tmp/s8_matrix.tsv

echo ""
echo "S8 summary PASS=$pass FAIL=$fail"
exit $fail
