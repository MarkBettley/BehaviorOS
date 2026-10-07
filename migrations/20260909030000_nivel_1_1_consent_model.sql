-- Nivel 1.1 S6 — approved consent model (PR2).
-- Seed idempotent initial consent versions and enforce ownership RLS.
INSERT INTO public.consent_versions (scope, version, text, is_current)
VALUES
  ('terms_of_service','1.0.0','Términos de servicio iniciales de BehaviorOS.',true),
  ('privacy_policy','1.0.0','Política de privacidad inicial de BehaviorOS.',true)
ON CONFLICT (scope, version) DO NOTHING;

-- Make 1.0.0 current only when no current version exists for the scope (idempotent, no downgrade).
UPDATE public.consent_versions v SET is_current = true
WHERE version = '1.0.0'
  AND NOT EXISTS (SELECT 1 FROM public.consent_versions v2 WHERE v2.scope = v.scope AND v2.is_current);

-- RLS: all authenticated patients can read any consent version.
CREATE POLICY "consent_versions_select_all"
  ON public.consent_versions
  FOR SELECT
  TO authenticated
  USING (true);

-- RLS: patients can read only their own consent history.
CREATE POLICY "patient_consents_select_own"
  ON public.patient_consents
  FOR SELECT
  TO authenticated
  USING ((select auth.uid()) = user_id);

-- RLS: patients can insert only their own consent records.
CREATE POLICY "patient_consents_insert_own"
  ON public.patient_consents
  FOR INSERT
  TO authenticated
  WITH CHECK ((select auth.uid()) = user_id);
