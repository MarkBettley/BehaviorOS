-- Nivel 1.1 PR1 S2 — approved base schema (patient profile, consent, audit).
-- No triggers, policies, seeds, or S3+ logic.
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS public.patient_profiles (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id uuid NOT NULL UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.consent_versions (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  scope text NOT NULL CHECK (scope IN ('terms_of_service','privacy_policy')),
  version text NOT NULL,
  text text NOT NULL,
  effective_at timestamptz NOT NULL DEFAULT now(),
  is_current boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (scope, version)
);
CREATE UNIQUE INDEX IF NOT EXISTS consent_versions_scope_current_idx ON public.consent_versions(scope) WHERE is_current;

CREATE TABLE IF NOT EXISTS public.patient_consents (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  scope text NOT NULL CHECK (scope IN ('terms_of_service','privacy_policy')),
  version text NOT NULL,
  action text NOT NULL CHECK (action IN ('grant','revoke')),
  created_at timestamptz NOT NULL DEFAULT now(),
  FOREIGN KEY (scope, version) REFERENCES public.consent_versions(scope, version)
);

CREATE TABLE IF NOT EXISTS public.audit_logs (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  actor_user_id uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  event_type text NOT NULL CHECK (event_type IN ('registration','login','logout','consent_grant','consent_revoke','profile_update')),
  occurred_at timestamptz NOT NULL DEFAULT now(),
  outcome text NOT NULL CHECK (outcome IN ('success','failure')),
  correlation_id text NOT NULL,
  origin text,
  context jsonb,
  created_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.patient_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.consent_versions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.patient_consents ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.audit_logs ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON public.patient_profiles, public.consent_versions, public.patient_consents, public.audit_logs FROM PUBLIC;
REVOKE ALL ON public.patient_profiles, public.consent_versions, public.patient_consents, public.audit_logs FROM anon, authenticated;
GRANT USAGE ON SCHEMA public TO anon, authenticated, service_role;
GRANT SELECT, INSERT, UPDATE ON public.patient_profiles TO authenticated;
GRANT SELECT ON public.consent_versions TO authenticated;
GRANT SELECT, INSERT ON public.patient_consents TO authenticated;
GRANT SELECT ON public.audit_logs TO authenticated;
GRANT ALL ON public.patient_profiles, public.consent_versions, public.patient_consents, public.audit_logs TO service_role;
