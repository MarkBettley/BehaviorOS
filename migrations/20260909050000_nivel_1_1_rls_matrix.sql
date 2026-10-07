-- Nivel 1.1 S8 — RLS matrix completion: actor-scoped audit log read policy.
-- Minimum correction to S1-S7: adds the missing authenticated SELECT policy
-- for audit_logs so patients can read only their own audit events.
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE schemaname = 'public'
      AND tablename = 'audit_logs'
      AND policyname = 'audit_logs_select_own'
  ) THEN
    CREATE POLICY "audit_logs_select_own"
      ON public.audit_logs
      FOR SELECT
      TO authenticated
      USING ((select auth.uid()) = actor_user_id);
  END IF;
END
$$;

COMMENT ON POLICY "audit_logs_select_own" ON public.audit_logs IS 'Patients can read only their own audit events.';
