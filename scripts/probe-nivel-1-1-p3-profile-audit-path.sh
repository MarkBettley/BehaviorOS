#!/usr/bin/env bash
# Nivel 1.1 P3 corrective pass — focused proof for public.create_patient_profile()
# audit fallback path. Verifies the function no longer directly inserts into
# public.audit_logs and routes registration failures through the non-exposed
# trusted writer security.write_audit_event.
set +H
set -uo pipefail
cd "$(dirname "$0")/.."
set -a && source .env && set +a
API="${API_EXTERNAL_URL:-http://localhost:8000}"
psql(){ docker compose exec -T db psql -U postgres -d postgres -tA -c "$1"; }
fail=0; pass=0; uid=""
check(){ if [ "$1" = "$2" ]; then echo "[PASS] $3"; pass=$((pass+1)); else echo "[FAIL] $3 expected=$1 observed=$2"; fail=$((fail+1)); fi; }
cleanup(){
  local script_ec=$? cleanup_fail=0 ids="" corr_ids=""
  if [ -n "${uid:-}" ]; then
    ids="'$uid'"
    corr_ids="'$uid','${fail_corr:-}'"
    # Remove the session first so the logout trigger fires while the actor exists,
    # then delete the audit rows before the user is removed.
    if ! psql "DELETE FROM auth.sessions WHERE user_id='$uid';" >/dev/null; then
      echo "[FAIL] auth.sessions cleanup for uid $uid failed"; cleanup_fail=1
    fi
    if ! psql "DELETE FROM public.audit_logs WHERE actor_user_id='$uid' OR correlation_id='${fail_corr:-}';" >/dev/null; then
      echo "[FAIL] audit_logs cleanup for uid $uid failed"; cleanup_fail=1
    fi
    if ! curl -s -o /dev/null -X DELETE "$API/auth/v1/admin/users/$uid" -H "apikey:$SERVICE_ROLE_KEY" -H "Authorization:Bearer $SERVICE_ROLE_KEY"; then
      echo "[FAIL] auth admin delete for uid $uid failed"; cleanup_fail=1
    fi
  fi
  if [ -n "${force_uuid:-}" ]; then
    ids="${ids:+$ids,}'$force_uuid'"
    corr_ids="${corr_ids:+$corr_ids,}'$force_uuid'"
    if ! psql "DELETE FROM public.audit_logs WHERE actor_user_id='$force_uuid';" >/dev/null; then
      echo "[FAIL] audit_logs cleanup for force_uuid $force_uuid failed"; cleanup_fail=1
    fi
    # The forced identity was inserted directly into auth.users, so GoTrue admin
    # delete may not see it; remove it directly and let the FK cascade clean up.
    if ! psql "DELETE FROM auth.users WHERE id='$force_uuid';" >/dev/null; then
      echo "[FAIL] auth.users cleanup for force_uuid $force_uuid failed"; cleanup_fail=1
    fi
  fi
  if [ -n "$ids" ]; then
    local u_count p_count a_count
    u_count=$(psql "SELECT count(*) FROM auth.users WHERE id IN ($ids);")
    p_count=$(psql "SELECT count(*) FROM public.patient_profiles WHERE user_id IN ($ids);")
    a_count=$(psql "SELECT count(*) FROM public.audit_logs WHERE actor_user_id IN ($ids) OR correlation_id IN ($corr_ids);")
    if [ "$u_count" -eq 0 ]; then echo "[PASS] auth.users fixture residue is 0"; else echo "[FAIL] auth.users fixture residue is $u_count"; cleanup_fail=1; fi
    if [ "$p_count" -eq 0 ]; then echo "[PASS] patient_profiles fixture residue is 0"; else echo "[FAIL] patient_profiles fixture residue is $p_count"; cleanup_fail=1; fi
    if [ "$a_count" -eq 0 ]; then echo "[PASS] audit_logs fixture residue is 0"; else echo "[FAIL] audit_logs fixture residue is $a_count"; cleanup_fail=1; fi
  fi
  if [ $cleanup_fail -ne 0 ]; then exit 1; fi
  exit $script_ec
}
trap cleanup EXIT

./scripts/healthcheck.sh >/dev/null || { echo "runtime unhealthy"; exit 1; }
check healthy healthy "runtime health"

# Source inspection: no direct INSERT into public.audit_logs.
direct_insert=$(psql "SELECT count(*) FROM pg_proc p JOIN pg_namespace n ON n.oid=p.pronamespace WHERE n.nspname='public' AND p.proname='create_patient_profile' AND p.prosrc ~* 'INSERT\\s+INTO\\s+public\\.audit_logs';")
check 0 "$direct_insert" "profile trigger has no direct audit_logs INSERT"

# Source inspection: routes failure fallback through security.write_audit_event.
uses_writer=$(psql "SELECT count(*) FROM pg_proc p JOIN pg_namespace n ON n.oid=p.pronamespace WHERE n.nspname='public' AND p.proname='create_patient_profile' AND p.prosrc ~* 'security\\.write_audit_event';")
check 1 "$uses_writer" "profile trigger references security.write_audit_event"

# Privilege inspection: not callable by client roles.
priv_public=$(psql "SELECT count(*) FROM information_schema.routine_privileges WHERE specific_schema='public' AND routine_name='create_patient_profile' AND grantee='PUBLIC';")
check 0 "$priv_public" "EXECUTE revoked from PUBLIC"
priv_anon=$(psql "SELECT count(*) FROM information_schema.routine_privileges WHERE specific_schema='public' AND routine_name='create_patient_profile' AND grantee='anon';")
check 0 "$priv_anon" "EXECUTE revoked from anon"
priv_auth=$(psql "SELECT count(*) FROM information_schema.routine_privileges WHERE specific_schema='public' AND routine_name='create_patient_profile' AND grantee='authenticated';")
check 0 "$priv_auth" "EXECUTE revoked from authenticated"

# Effective-permission inspection for the non-exposed trusted writer.
# PostgreSQL privilege evaluation: catches a stray EXECUTE grant (including via
# PUBLIC or inheritance) even when schema USAGE remains denied and the
# rolled-back invocation still fails with "permission denied for schema security".
check_function_privilege(){
  local role=$1 expected=$2 result
  result=$(psql "SELECT has_function_privilege('$role', 'security.write_audit_event(uuid,text,text,text,text,jsonb)', 'EXECUTE')::text;")
  check "$expected" "$result" "has_function_privilege EXECUTE on security.write_audit_event for $role"
}
check_function_privilege anon false
check_function_privilege authenticated false

# Roles are also tested by attempting execution in a rolled-back transaction.
test_role_execute(){
  local role=$1 expected=$2 out observed
  out=$(psql "BEGIN; SET ROLE $role; SELECT security.write_audit_event(gen_random_uuid(),'registration','failure',gen_random_uuid()::text,'probe','{}'::jsonb); ROLLBACK;" 2>&1) || true
  if echo "$out" | grep -q '^ERROR:'; then observed=denied; else observed=allowed; fi
  check "$expected" "$observed" "rolled-back EXECUTE attempt on security.write_audit_event for $role"
}
test_role_execute anon denied
test_role_execute authenticated denied

# Normal registration path still succeeds and produces a profile + registration audit event.
ts=$(date +%s%N)
ra=$(curl -s -X POST "$API/auth/v1/signup" -H "apikey:$ANON_KEY" -H "Content-Type:application/json" -d "{\"email\":\"p3-profile-$ts@example.local\",\"password\":\"P3ProfilePassLong123\"}")
at=$(echo "$ra" | sed -n 's/.*"access_token":"\([^"]*\)".*/\1/p'); uid=$(echo "$ra" | sed -n 's/.*"id":"\([^"]*\)".*/\1/p')
check present "$([ -n "$at" ] && echo present || echo absent)" "normal signup returns access token"
check present "$([ -n "$uid" ] && echo present || echo absent)" "normal signup returns user id"
check 1 "$(psql "SELECT count(*) FROM public.patient_profiles WHERE user_id='$uid'")" "profile created for new user"
check 1 "$(psql "SELECT count(*) FROM public.audit_logs WHERE actor_user_id='$uid' AND event_type='registration' AND outcome='success'")" "registration/success audit event created"

# Force public.create_patient_profile() into its exception path by pre-inserting a
# profile row for a chosen UUID, then creating the auth identity with the trigger
# active. session_replication_role=replica is used only to bypass the FK check for
# the setup insert; the trigger itself runs under normal origin mode and catches
# the duplicate-key violation, routing the fallback through security.write_audit_event.
force_uuid=$(psql "SELECT gen_random_uuid();")
force_email="p3-force-${force_uuid%%-*}@example.local"
psql "BEGIN;
SET LOCAL session_replication_role = replica;
INSERT INTO public.patient_profiles (user_id) VALUES ('$force_uuid');
SET LOCAL session_replication_role = origin;
INSERT INTO auth.users (id, email, encrypted_password, created_at, updated_at, is_sso_user, is_anonymous)
VALUES ('$force_uuid', '$force_email', 'dummy-force-value', now(), now(), false, false);
COMMIT;" >/dev/null

# The user insert must succeed because the trigger catches the profile exception.
check 1 "$(psql "SELECT count(*) FROM auth.users WHERE id='$force_uuid'")" "forced-exception user exists despite profile conflict"

# Verify the audit outcome produced by the trigger's exception path.
check 1 "$(psql "SELECT count(*) FROM public.audit_logs WHERE actor_user_id='$force_uuid' AND event_type='registration' AND outcome='failure'")" "forced exception emits exactly one registration/failure audit row"
check "create_patient_profile" "$(psql "SELECT origin FROM public.audit_logs WHERE actor_user_id='$force_uuid' AND event_type='registration' AND outcome='failure'")" "registration/failure origin is create_patient_profile"
check "$force_uuid" "$(psql "SELECT correlation_id FROM public.audit_logs WHERE actor_user_id='$force_uuid' AND event_type='registration' AND outcome='failure'")" "registration/failure correlation_id equals forced user id"

force_ctx=$(psql "SELECT context::text FROM public.audit_logs WHERE actor_user_id='$force_uuid' AND event_type='registration' AND outcome='failure'")
force_secrets=$(echo "$force_ctx" | grep -iE 'password|token|jwt|secret|api_key|apikey|service_role|access_token|refresh_token|authorization|bearer|eyJ[a-zA-Z0-9_-]*\.eyJ' || true)
check "" "$force_secrets" "registration/failure context is secret-free"

# Forced-exception fixtures will be removed by the EXIT cleanup trap, which also
# asserts zero residue in auth.users, patient_profiles, and audit_logs.

# Prove the trusted writer accepts a registration/failure event (the fallback path
# now used by public.create_patient_profile()). This does not fabricate a normal
# registration failure; it only validates the writer contract for that event type.
fail_corr=$(psql "SELECT gen_random_uuid()::text;")
psql "SELECT security.write_audit_event('$uid','registration','failure','$fail_corr','test_profile_audit_path','{\"reason\":\"focused proof\"}'::jsonb);" >/dev/null
check 1 "$(psql "SELECT count(*) FROM public.audit_logs WHERE actor_user_id='$uid' AND event_type='registration' AND outcome='failure' AND correlation_id='$fail_corr'")" "writer accepts registration/failure event"

echo "P3 profile audit path summary PASS=$pass FAIL=$fail"
exit $fail
