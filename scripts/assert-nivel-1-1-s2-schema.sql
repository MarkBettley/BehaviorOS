-- Nivel 1.1 S2 — schema assertions. Run before GREEN (should FAIL) and after READBACK (should PASS).
WITH c AS (
  SELECT 'patient_profiles exists' n,'1' e,(SELECT count(*)::text FROM information_schema.tables WHERE table_schema='public' AND table_name='patient_profiles') o
  UNION ALL SELECT 'consent_versions exists','1',(SELECT count(*)::text FROM information_schema.tables WHERE table_schema='public' AND table_name='consent_versions')
  UNION ALL SELECT 'patient_consents exists','1',(SELECT count(*)::text FROM information_schema.tables WHERE table_schema='public' AND table_name='patient_consents')
  UNION ALL SELECT 'audit_logs exists','1',(SELECT count(*)::text FROM information_schema.tables WHERE table_schema='public' AND table_name='audit_logs')
  UNION ALL SELECT 'patient_profiles.user_id type','uuid',(SELECT data_type::text FROM information_schema.columns WHERE table_schema='public' AND table_name='patient_profiles' AND column_name='user_id')
  UNION ALL SELECT 'patient_profiles.user_id unique','1',(SELECT count(*)::text FROM pg_indexes WHERE schemaname='public' AND tablename='patient_profiles' AND indexdef LIKE '%UNIQUE%user_id%')
  UNION ALL SELECT 'patient_profiles.user_id fk','1',(SELECT count(*)::text FROM information_schema.table_constraints WHERE constraint_schema='public' AND table_name='patient_profiles' AND constraint_type='FOREIGN KEY')
  UNION ALL SELECT 'consent_versions.scope check','1',(SELECT count(*)::text FROM information_schema.table_constraints WHERE constraint_schema='public' AND table_name='consent_versions' AND constraint_type='CHECK' AND constraint_name LIKE '%scope%')
  UNION ALL SELECT 'consent_versions.current unique','1',(SELECT count(*)::text FROM pg_indexes WHERE schemaname='public' AND tablename='consent_versions' AND indexdef LIKE '%UNIQUE%is_current%')
  UNION ALL SELECT 'patient_consents.action check','1',(SELECT count(*)::text FROM information_schema.table_constraints WHERE constraint_schema='public' AND table_name='patient_consents' AND constraint_type='CHECK' AND constraint_name LIKE '%action%')
  UNION ALL SELECT 'patient_consents.version fk','2',(SELECT count(*)::text FROM information_schema.table_constraints WHERE constraint_schema='public' AND table_name='patient_consents' AND constraint_type='FOREIGN KEY')
  UNION ALL SELECT 'audit_logs.event_type check','1',(SELECT count(*)::text FROM information_schema.table_constraints WHERE constraint_schema='public' AND table_name='audit_logs' AND constraint_type='CHECK' AND constraint_name LIKE '%event_type%')
  UNION ALL SELECT 'audit_logs.outcome check','1',(SELECT count(*)::text FROM information_schema.table_constraints WHERE constraint_schema='public' AND table_name='audit_logs' AND constraint_type='CHECK' AND constraint_name LIKE '%outcome%')
  UNION ALL SELECT 'audit_logs.correlation_id not null','NO',(SELECT is_nullable::text FROM information_schema.columns WHERE table_schema='public' AND table_name='audit_logs' AND column_name='correlation_id')
  UNION ALL SELECT 'audit_logs.origin nullable','YES',(SELECT is_nullable::text FROM information_schema.columns WHERE table_schema='public' AND table_name='audit_logs' AND column_name='origin')
  UNION ALL SELECT 'patient_profiles rls','true',(SELECT relrowsecurity::text FROM pg_class WHERE relnamespace='public'::regnamespace AND relname='patient_profiles')
  UNION ALL SELECT 'consent_versions rls','true',(SELECT relrowsecurity::text FROM pg_class WHERE relnamespace='public'::regnamespace AND relname='consent_versions')
  UNION ALL SELECT 'patient_consents rls','true',(SELECT relrowsecurity::text FROM pg_class WHERE relnamespace='public'::regnamespace AND relname='patient_consents')
  UNION ALL SELECT 'audit_logs rls','true',(SELECT relrowsecurity::text FROM pg_class WHERE relnamespace='public'::regnamespace AND relname='audit_logs')
),
expected_grants AS (
  SELECT t.table_name, r.role_name, p.privilege_type,
    CASE
      WHEN r.role_name='anon' THEN false
      WHEN r.role_name='service_role' THEN true
      WHEN t.table_name='patient_profiles' AND p.privilege_type IN ('SELECT','INSERT','UPDATE') THEN true
      WHEN t.table_name='consent_versions' AND p.privilege_type='SELECT' THEN true
      WHEN t.table_name='patient_consents' AND p.privilege_type IN ('SELECT','INSERT') THEN true
      WHEN t.table_name='audit_logs' AND p.privilege_type='SELECT' THEN true
      ELSE false
    END AS expected
  FROM (VALUES ('patient_profiles'),('consent_versions'),('patient_consents'),('audit_logs')) AS t(table_name)
  CROSS JOIN (VALUES ('anon'),('authenticated'),('service_role')) AS r(role_name)
  CROSS JOIN (VALUES ('SELECT'),('INSERT'),('UPDATE'),('DELETE')) AS p(privilege_type)
),
observed AS (
  SELECT table_name, grantee AS role_name, privilege_type, true AS granted
  FROM information_schema.table_privileges
  WHERE table_schema='public'
    AND table_name IN ('patient_profiles','consent_versions','patient_consents','audit_logs')
    AND grantee IN ('anon','authenticated','service_role')
    AND privilege_type IN ('SELECT','INSERT','UPDATE','DELETE')
),
g AS (
  SELECT 'grant|' || e.table_name || '|' || e.role_name || '|' || e.privilege_type AS n,
         CASE WHEN e.expected THEN 'GRANTED' ELSE 'NONE' END AS e,
         CASE WHEN COALESCE(o.granted,false) THEN 'GRANTED' ELSE 'NONE' END AS o
  FROM expected_grants e
  LEFT JOIN observed o USING (table_name, role_name, privilege_type)
)
SELECT n AS name, e AS expected, o AS observed, CASE WHEN e=o THEN 'PASS' ELSE 'FAIL' END AS result FROM c
UNION ALL
SELECT n, e, o, CASE WHEN e=o THEN 'PASS' ELSE 'FAIL' END FROM g
ORDER BY name;
