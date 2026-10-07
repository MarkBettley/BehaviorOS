#!/usr/bin/env bash
# Nivel 1.1 S2 — isolated RED→GREEN evidence via rollback-guarded transaction.
# Does NOT mutate active persistent schema; all changes roll back on success or error.
set -uo pipefail
cd "$(dirname "$0")/.."
tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT
cat > "$tmp" <<'SQL'
BEGIN;
DROP TABLE IF EXISTS public.patient_profiles CASCADE;
DROP TABLE IF EXISTS public.consent_versions CASCADE;
DROP TABLE IF EXISTS public.patient_consents CASCADE;
DROP TABLE IF EXISTS public.audit_logs CASCADE;
DROP FUNCTION IF EXISTS public.create_patient_profile(), public.set_patient_role() CASCADE;
\echo '--- RED: expect FAIL rows ---'
\i /tmp/assert.sql
\echo '--- GREEN: apply versionable migration ---'
\i /tmp/base-schema.sql
\i /tmp/identity-trigger.sql
\echo '--- READBACK: expect PASS rows ---'
\i /tmp/assert.sql
\echo '--- R1: SECURITY DEFINER functions not callable by app roles ---'
SELECT CASE WHEN has_function_privilege('anon','public.set_patient_role()','EXECUTE') THEN 'FAIL|anon set_patient_role EXECUTE' ELSE 'PASS|anon set_patient_role EXECUTE' END, CASE WHEN has_function_privilege('authenticated','public.set_patient_role()','EXECUTE') THEN 'FAIL|authenticated set_patient_role EXECUTE' ELSE 'PASS|authenticated set_patient_role EXECUTE' END, CASE WHEN has_function_privilege('anon','public.create_patient_profile()','EXECUTE') THEN 'FAIL|anon create_patient_profile EXECUTE' ELSE 'PASS|anon create_patient_profile EXECUTE' END, CASE WHEN has_function_privilege('authenticated','public.create_patient_profile()','EXECUTE') THEN 'FAIL|authenticated create_patient_profile EXECUTE' ELSE 'PASS|authenticated create_patient_profile EXECUTE' END;
\echo '--- R4: migration idempotency ---'
\i /tmp/base-schema.sql
\i /tmp/identity-trigger.sql
SELECT CASE WHEN count(*)=2 THEN 'PASS|exactly 2 nivel triggers after double apply' ELSE 'FAIL|trigger count '||count(*)::text END FROM pg_trigger WHERE tgname IN ('trg_set_patient_role','trg_create_patient_profile') AND tgrelid='auth.users'::regclass;
\echo '--- R4: forced profile failure must not abort registration ---'
ALTER TABLE public.patient_profiles ADD CONSTRAINT test_force_profile_failure CHECK (false) NOT VALID;
DO $$
DECLARE v_user_id uuid := uuid_generate_v4(); v_count int;
BEGIN
  INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, is_sso_user, is_anonymous, created_at, updated_at) VALUES (v_user_id, 'probe-'||v_user_id::text||'@example.local', '', now(), false, false, now(), now());
  SELECT count(*) INTO v_count FROM auth.users WHERE id=v_user_id; IF v_count<>1 THEN RAISE EXCEPTION 'registration aborted by profile failure'; END IF;
  SELECT count(*) INTO v_count FROM public.audit_logs WHERE actor_user_id=v_user_id AND event_type='registration' AND outcome='failure'; IF v_count<>1 THEN RAISE EXCEPTION 'profile failure not logged'; END IF;
END $$;
ROLLBACK;
SQL
docker compose cp "$tmp" db:/tmp/repro-s2.sql >/dev/null || { echo "INFRA_FAILURE: copy repro to container"; exit 2; }
docker compose cp scripts/assert-nivel-1-1-s2-schema.sql db:/tmp/assert.sql >/dev/null || { echo "INFRA_FAILURE: copy assert SQL"; exit 2; }
docker compose cp migrations/20260819190000_nivel_1_1_base_schema.sql db:/tmp/base-schema.sql >/dev/null || { echo "INFRA_FAILURE: copy base schema"; exit 2; }
docker compose cp migrations/20260908022000_nivel_1_1_identity_trigger.sql db:/tmp/identity-trigger.sql >/dev/null || { echo "INFRA_FAILURE: copy identity trigger"; exit 2; }
timeout 120s docker compose exec -T db psql -U postgres -d postgres -v ON_ERROR_STOP=1 -f /tmp/repro-s2.sql | tee /tmp/repro-s2.out; rc=$?
[ "$rc" -ne 0 ] && { echo "INFRA_FAILURE: repro execution failed"; exit 2; }
docker compose exec -T db rm -f /tmp/repro-s2.sql /tmp/assert.sql /tmp/base-schema.sql /tmp/identity-trigger.sql
awk '/--- R1:/{p=1} p&&/FAIL[|]/{c++} END{if(c>0){print "ASSERTION_FAILURE: "c" targeted check(s) failed"; exit 1}}' /tmp/repro-s2.out || exit 1
echo "REPRO_COMPLETE: rollback verified"
rm -f /tmp/repro-s2.out
