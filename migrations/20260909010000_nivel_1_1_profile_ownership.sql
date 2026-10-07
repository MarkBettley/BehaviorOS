-- Nivel 1.1 S5 — patient profile ownership RLS policies (PR2).
-- Minimum restrictions: own row only; no cross-patient access; no user_id reassignment; no delete.
CREATE POLICY "patient_profiles_select_own"
  ON public.patient_profiles
  FOR SELECT
  TO authenticated
  USING ((select auth.uid()) = user_id);

CREATE POLICY "patient_profiles_insert_own"
  ON public.patient_profiles
  FOR INSERT
  TO authenticated
  WITH CHECK ((select auth.uid()) = user_id);

CREATE POLICY "patient_profiles_update_own"
  ON public.patient_profiles
  FOR UPDATE
  TO authenticated
  USING ((select auth.uid()) = user_id)
  WITH CHECK ((select auth.uid()) = user_id);

COMMENT ON POLICY "patient_profiles_select_own" ON public.patient_profiles IS 'Patients can read only their own profile.';
COMMENT ON POLICY "patient_profiles_update_own" ON public.patient_profiles IS 'Patients can update only their own profile; user_id cannot be reassigned.';
