#!/usr/bin/env bash
# BehavioralOS – Nivel 0.2 script de arranque local
# Uso: ./scripts/setup-local.sh

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if [ ! -f .env ]; then
  echo "[setup] Creando .env desde .env.example..."
  cp .env.example .env
  echo "[setup] IMPORTANTE: edita .env y cambia los secretos por defecto antes de usar en producción."
fi

# shellcheck source=/dev/null
set -a && source .env && set +a

if [ -z "${POSTGRES_PASSWORD:-}" ] || [ -z "${JWT_SECRET:-}" ] || [ -z "${ANON_KEY:-}" ] || [ -z "${SERVICE_ROLE_KEY:-}" ]; then
  echo "[setup] ERROR: faltan secretos requeridos en .env (POSTGRES_PASSWORD, JWT_SECRET, ANON_KEY, SERVICE_ROLE_KEY)." >&2
  exit 1
fi

echo "[setup] Validando configuración de Compose..."
docker compose config -q

echo "[setup] Creando directorios de volúmenes..."
mkdir -p volumes/storage

echo "[setup] Levantando infraestructura base (Supabase local)..."
if docker compose up --help | grep -q -- --wait; then
  docker compose up -d --wait --no-build
else
  docker compose up -d --no-build
fi

echo "[setup] Provisioning backend application database role..."
./scripts/provision-backend-role.sh

echo "[setup] Estado de los contenedores:"
docker compose ps

if ! docker compose ps | grep -E "behavioralos-(db|auth|rest|storage|meta|kong|studio|imgproxy)" | grep -v "healthy\|running" >/dev/null 2>&1; then
  echo "[setup] BehavioralOS Nivel 0.2 listo."
  echo "  - Supabase Studio: http://localhost:${STUDIO_PORT:-3000}"
  echo "  - API Gateway (Kong): http://localhost:${KONG_HTTP_PORT:-8000}"
  echo "  - Auth (GoTrue): http://localhost:${AUTH_PORT:-9999}"
  echo "  - Postgres: localhost:${POSTGRES_PORT:-5432}"
else
  echo "[setup] ALERTA: algunos contenedores no están saludables. Ejecuta ./scripts/healthcheck.sh" >&2
fi

echo ""
echo "[setup] Para detener: docker compose down"
