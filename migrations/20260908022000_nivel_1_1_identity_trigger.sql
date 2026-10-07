-- Nivel 1.1 S3 — immutable patient role and profile creation on registration.
CREATE OR REPLACE FUNCTION public.set_patient_role()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, auth
AS $$
BEGIN
  NEW.raw_app_meta_data = COALESCE(NEW.raw_app_meta_data, '{}'::jsonb) || '{"app_role":"patient"}';
  RETURN NEW;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.set_patient_role() FROM PUBLIC, anon, authenticated;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'trg_set_patient_role' AND tgrelid = 'auth.users'::regclass) THEN CREATE TRIGGER trg_set_patient_role BEFORE INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.set_patient_role(); END IF; END $$;

CREATE OR REPLACE FUNCTION public.create_patient_profile()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, auth
AS $$
DECLARE
  v_err text;
BEGIN
  BEGIN
    INSERT INTO public.patient_profiles (user_id) VALUES (NEW.id);
  EXCEPTION WHEN OTHERS THEN
    v_err := SQLERRM;
    INSERT INTO public.audit_logs (actor_user_id, event_type, outcome, correlation_id, origin, context)
    VALUES (NEW.id, 'registration', 'failure', NEW.id::text, 'create_patient_profile', jsonb_build_object('error', v_err));
  END;
  RETURN NEW;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.create_patient_profile() FROM PUBLIC, anon, authenticated;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'trg_create_patient_profile' AND tgrelid = 'auth.users'::regclass) THEN CREATE TRIGGER trg_create_patient_profile AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.create_patient_profile(); END IF; END $$;

COMMENT ON FUNCTION public.set_patient_role() IS 'Forces raw_app_meta_data.app_role=patient on registration; client metadata cannot override it.';
COMMENT ON FUNCTION public.create_patient_profile() IS 'Creates the owning patient_profiles row after the auth identity exists; failures are logged without aborting registration.';
