-- Nivel 1.1 P3 corrective pass — route the registration-failure audit fallback
-- through the non-exposed trusted writer. public.create_patient_profile() remains
-- the profile-creation trigger (its EXECUTE privilege is already revoked from
-- PUBLIC/anon/authenticated), but it no longer performs a direct INSERT into
-- public.audit_logs. All audit rows now flow through security.write_audit_event,
-- which enforces the six-event allowlist, outcome allowlist, correlation format,
-- origin provenance, secret-free context, and actor-binding rules.
CREATE OR REPLACE FUNCTION public.create_patient_profile()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, auth, security
AS $$
DECLARE
  v_err text;
BEGIN
  BEGIN
    INSERT INTO public.patient_profiles (user_id) VALUES (NEW.id);
  EXCEPTION WHEN OTHERS THEN
    v_err := SQLERRM;
    PERFORM security.write_audit_event(
      NEW.id,
      'registration',
      'failure',
      NEW.id::text,
      'create_patient_profile',
      jsonb_build_object('error', v_err)
    );
  END;
  RETURN NEW;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.create_patient_profile() FROM PUBLIC, anon, authenticated;

COMMENT ON FUNCTION public.create_patient_profile() IS 'Creates the owning patient_profiles row after the auth identity exists; registration failures are routed through security.write_audit_event without aborting registration.';
