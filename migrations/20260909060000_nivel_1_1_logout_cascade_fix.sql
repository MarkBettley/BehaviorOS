-- Nivel 1.1 P3 — remediate logout audit FK failure when admin user deletion
-- cascades auth.sessions after auth.users removal. The logout trigger now binds
-- actor_user_id normally when the user still exists, and records NULL with safe
-- non-secret context (session_id + user_id) when cascade ordering removes the
-- user before the trigger fires. Append-only logout evidence is preserved.

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
  IF p_type IS NULL OR p_type NOT IN ('registration','login','logout','consent_grant','consent_revoke','profile_update') THEN
    RAISE EXCEPTION 'Invalid audit event_type: %', p_type;
  END IF;
  IF p_outcome IS NULL OR p_outcome NOT IN ('success','failure') THEN
    RAISE EXCEPTION 'Invalid audit outcome: %', p_outcome;
  END IF;
  -- Actor binding: NULL allowed for pre-auth login failure, or for logout after
  -- cascade user deletion when safe correlation context is retained.
  IF p_actor IS NULL AND NOT (
       (p_type = 'login' AND p_outcome = 'failure')
    OR (p_type = 'logout' AND p_outcome = 'success' AND (p_ctx ? 'user_id'))
  ) THEN
    RAISE EXCEPTION 'Missing actor_user_id for event %/%', p_type, p_outcome;
  END IF;
  IF p_type IN ('consent_grant','consent_revoke','profile_update')
     AND (select auth.uid()) IS NOT NULL
     AND p_actor IS DISTINCT FROM (select auth.uid()) THEN
    RAISE EXCEPTION 'Actor binding mismatch for %', p_type;
  END IF;
  IF p_corr ~ '^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$' THEN
    v_corr := p_corr;
  ELSIF p_corr IS NULL OR p_corr = '' THEN
    v_corr := gen_random_uuid()::text;
  ELSE
    RAISE EXCEPTION 'Invalid correlation_id format';
  END IF;
  IF p_origin IS NOT NULL AND p_origin !~ '^[a-zA-Z][a-zA-Z0-9_.-]{0,63}$' THEN
    RAISE EXCEPTION 'Invalid origin provenance';
  END IF;
  v_ctx_lower := lower(p_ctx::text);
  IF v_ctx_lower ~ '(password|token|jwt|secret|api_key|apikey|service_role|access_token|refresh_token|authorization|bearer)'
     OR v_ctx_lower ~ 'eyj[a-z0-9_-]*\.eyj[a-z0-9_-]*\.[a-z0-9_-]*' THEN
    RAISE EXCEPTION 'Audit context contains forbidden secret-like content';
  END IF;
  INSERT INTO public.audit_logs (actor_user_id,event_type,occurred_at,outcome,correlation_id,origin,context)
  VALUES (p_actor,p_type,now(),p_outcome,v_corr,p_origin,p_ctx);
END;
$$;

CREATE OR REPLACE FUNCTION security.audit_logout()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = security, public, auth
AS $$
DECLARE
  v_actor uuid;
BEGIN
  SELECT id INTO v_actor FROM auth.users WHERE id = OLD.user_id;
  IF v_actor IS NOT NULL THEN
    PERFORM security.write_audit_event(v_actor,'logout','success',NULL,NULL,jsonb_build_object('session_id',OLD.id::text));
  ELSE
    PERFORM security.write_audit_event(NULL,'logout','success',NULL,NULL,jsonb_build_object('session_id',OLD.id::text,'user_id',OLD.user_id::text));
  END IF;
  RETURN OLD;
END;
$$;
