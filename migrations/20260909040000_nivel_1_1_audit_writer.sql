-- Nivel 1.1 S7 — trusted audit writer and six-event emission triggers (PR3).
CREATE SCHEMA IF NOT EXISTS security;

-- Trusted writer: non-exposed schema, SECURITY DEFINER, fixed search_path,
-- allowlist validation, INSERT-only, secret-free context contract.
CREATE OR REPLACE FUNCTION security.write_audit_event(
  p_actor uuid,
  p_type text,
  p_outcome text,
  p_corr text,
  p_origin text,
  p_ctx jsonb
) RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = security, public, auth
AS $$
DECLARE
  v_corr text;
  v_ctx_lower text;
BEGIN
  -- Event and outcome allowlists.
  IF p_type IS NULL OR p_type NOT IN ('registration','login','logout','consent_grant','consent_revoke','profile_update') THEN
    RAISE EXCEPTION 'Invalid audit event_type: %', p_type;
  END IF;
  IF p_outcome IS NULL OR p_outcome NOT IN ('success','failure') THEN
    RAISE EXCEPTION 'Invalid audit outcome: %', p_outcome;
  END IF;
  -- Actor binding: NULL only allowed for pre-authentication login failure.
  IF p_actor IS NULL AND NOT (p_type = 'login' AND p_outcome = 'failure') THEN
    RAISE EXCEPTION 'Missing actor_user_id for event %/%', p_type, p_outcome;
  END IF;
  -- User-scoped events must be bound to the current authenticated identity when available.
  IF p_type IN ('consent_grant','consent_revoke','profile_update')
     AND (select auth.uid()) IS NOT NULL
     AND p_actor IS DISTINCT FROM (select auth.uid()) THEN
    RAISE EXCEPTION 'Actor binding mismatch for %', p_type;
  END IF;
  -- Correlation format: valid UUID or generated opaque value.
  IF p_corr ~ '^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$' THEN
    v_corr := p_corr;
  ELSIF p_corr IS NULL OR p_corr = '' THEN
    v_corr := gen_random_uuid()::text;
  ELSE
    RAISE EXCEPTION 'Invalid correlation_id format';
  END IF;
  -- Origin provenance: allow NULL or a simple controlled token; block URLs/secrets.
  IF p_origin IS NOT NULL AND p_origin !~ '^[a-zA-Z][a-zA-Z0-9_.-]{0,63}$' THEN
    RAISE EXCEPTION 'Invalid origin provenance';
  END IF;
  -- Secret-free context: reject known secret-bearing keys or JWT-shaped values.
  v_ctx_lower := lower(p_ctx::text);
  IF v_ctx_lower ~ '(password|token|jwt|secret|api_key|apikey|service_role|access_token|refresh_token|authorization|bearer)'
     OR v_ctx_lower ~ 'eyj[a-z0-9_-]*\.eyj[a-z0-9_-]*\.[a-z0-9_-]*' THEN
    RAISE EXCEPTION 'Audit context contains forbidden secret-like content';
  END IF;
  INSERT INTO public.audit_logs (actor_user_id,event_type,occurred_at,outcome,correlation_id,origin,context)
  VALUES (p_actor,p_type,now(),p_outcome,v_corr,p_origin,p_ctx);
END;
$$;
REVOKE ALL ON FUNCTION security.write_audit_event(uuid,text,text,text,text,jsonb) FROM PUBLIC, anon, authenticated;

-- Registration success.
CREATE OR REPLACE FUNCTION security.audit_registration()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = security, public, auth
AS $$
BEGIN
  PERFORM security.write_audit_event(NEW.id,'registration','success',NULL,NULL,'{}'::jsonb);
  RETURN NEW;
END;
$$;
REVOKE ALL ON FUNCTION security.audit_registration() FROM PUBLIC, anon, authenticated;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname='trg_audit_registration_success' AND tgrelid='auth.users'::regclass) THEN
  CREATE TRIGGER trg_audit_registration_success AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION security.audit_registration();
END IF; END $$;

-- Login.
CREATE OR REPLACE FUNCTION security.audit_login()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = security, public, auth
AS $$
BEGIN
  PERFORM security.write_audit_event(NEW.user_id,'login','success',NULL,NULL,jsonb_build_object('session_id',NEW.id::text));
  RETURN NEW;
END;
$$;
REVOKE ALL ON FUNCTION security.audit_login() FROM PUBLIC, anon, authenticated;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname='trg_audit_login' AND tgrelid='auth.sessions'::regclass) THEN
  CREATE TRIGGER trg_audit_login AFTER INSERT ON auth.sessions FOR EACH ROW EXECUTE FUNCTION security.audit_login();
END IF; END $$;

-- Logout.
CREATE OR REPLACE FUNCTION security.audit_logout()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = security, public, auth
AS $$
BEGIN
  PERFORM security.write_audit_event(OLD.user_id,'logout','success',NULL,NULL,jsonb_build_object('session_id',OLD.id::text));
  RETURN OLD;
END;
$$;
REVOKE ALL ON FUNCTION security.audit_logout() FROM PUBLIC, anon, authenticated;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname='trg_audit_logout' AND tgrelid='auth.sessions'::regclass) THEN
  CREATE TRIGGER trg_audit_logout AFTER DELETE ON auth.sessions FOR EACH ROW EXECUTE FUNCTION security.audit_logout();
END IF; END $$;

-- Consent grant/revoke.
CREATE OR REPLACE FUNCTION security.audit_consent()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = security, public, auth
AS $$
BEGIN
  PERFORM security.write_audit_event(
    NEW.user_id,
    CASE NEW.action WHEN 'grant' THEN 'consent_grant' ELSE 'consent_revoke' END,
    'success',
    NULL,
    NULL,
    jsonb_build_object('scope',NEW.scope,'version',NEW.version)
  );
  RETURN NEW;
END;
$$;
REVOKE ALL ON FUNCTION security.audit_consent() FROM PUBLIC, anon, authenticated;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname='trg_audit_consent' AND tgrelid='public.patient_consents'::regclass) THEN
  CREATE TRIGGER trg_audit_consent AFTER INSERT ON public.patient_consents FOR EACH ROW EXECUTE FUNCTION security.audit_consent();
END IF; END $$;

-- Profile update.
CREATE OR REPLACE FUNCTION security.audit_profile_update()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = security, public, auth
AS $$
BEGIN
  PERFORM security.write_audit_event(NEW.user_id,'profile_update','success',NULL,NULL,jsonb_build_object('profile_id',NEW.id::text));
  RETURN NEW;
END;
$$;
REVOKE ALL ON FUNCTION security.audit_profile_update() FROM PUBLIC, anon, authenticated;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname='trg_audit_profile_update' AND tgrelid='public.patient_profiles'::regclass) THEN
  CREATE TRIGGER trg_audit_profile_update AFTER UPDATE ON public.patient_profiles FOR EACH ROW EXECUTE FUNCTION security.audit_profile_update();
END IF; END $$;

-- Retention note: two-year minimum retention for audit logs.
COMMENT ON TABLE public.audit_logs IS 'Append-only security audit log. Retain rows at least two years from occurred_at.';
