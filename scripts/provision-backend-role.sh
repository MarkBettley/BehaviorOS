#!/usr/bin/env bash
# Provision the backend_app PostgreSQL role idempotently on an initialized
# Supabase local database. Reads secrets from the ignored .env file.
# Never prints the role password.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

set +u
set -a
source .env
set +a
set -u

if [ -z "${POSTGRES_PASSWORD:-}" ]; then
  echo "[provision-backend-role] ERROR: POSTGRES_PASSWORD is required" >&2
  exit 1
fi

if [ -z "${BACKEND_DB_PASSWORD:-}" ]; then
  echo "[provision-backend-role] ERROR: BACKEND_DB_PASSWORD is required" >&2
  exit 1
fi

if [ -z "${BACKEND_DB_USER:-}" ]; then
  BACKEND_DB_USER=backend_app
fi

if [ "$BACKEND_DB_PASSWORD" = "$POSTGRES_PASSWORD" ]; then
  echo "[provision-backend-role] ERROR: BACKEND_DB_PASSWORD must differ from POSTGRES_PASSWORD" >&2
  exit 1
fi

# Escape single quotes in the password for safe SQL string interpolation.
pw_escaped="${BACKEND_DB_PASSWORD//"'"/"''"}"
role_escaped="${BACKEND_DB_USER//"'"/"''"}"

echo "[provision-backend-role] Ensuring PostgreSQL role '${BACKEND_DB_USER}' exists..."
PGPASSWORD="$POSTGRES_PASSWORD" docker compose exec -T db psql -U postgres -d postgres <<SQL
DO \$\$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = '${role_escaped}') THEN
    CREATE ROLE ${role_escaped} WITH LOGIN PASSWORD '${pw_escaped}';
  ELSE
    ALTER ROLE ${role_escaped} WITH PASSWORD '${pw_escaped}';
  END IF;
END
\$\$;
SQL

if docker compose exec -T db psql -U postgres -d postgres -tA -c "SELECT 1 FROM pg_roles WHERE rolname = '${BACKEND_DB_USER}'" | grep -q 1; then
  echo "[provision-backend-role] OK: role '${BACKEND_DB_USER}' is provisioned."
else
  echo "[provision-backend-role] ERROR: role '${BACKEND_DB_USER}' was not found after provisioning" >&2
  exit 1
fi
