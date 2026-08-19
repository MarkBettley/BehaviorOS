# BehavioralOS

> Plataforma de psicoterapia gamificada basada en procesos, con IA on-device, evaluación adaptativa y experiencias inspiradas en Nintendo para pacientes y Apple para terapeutas.

## Nivel 0.2 – Infraestructura base

Este entregable proporciona un entorno de desarrollo reproducible con Docker Compose que incluye:

- **PostgreSQL** (base de datos relacional)
- **Supabase Auth** (GoTrue, autenticación JWT)
- **Supabase Storage** (almacenamiento de archivos)
- **PostgREST** (API REST automática sobre Postgres)
- **Kong** (API gateway)
- **Supabase Studio** (interfaz de administración local)

Documentación de referencia:

- `Sdd/specs/index/build-roadmap.md` – Nivel 0.2
- `Sdd/specs/000-Infrastructure/selection.md` – selección tecnológica
- `Sdd/specs/index/environment-variables.md` – contrato de variables de entorno

## Requisitos previos

- [Docker Engine](https://docs.docker.com/engine/install/) 24.x o superior
- [Docker Compose](https://docs.docker.com/compose/install/) v2 o superior
- (Opcional) [Supabase CLI](https://supabase.com/docs/guides/cli) para flujos locales adicionales

## Arranque rápido

```bash
# 1. Clonar o ubicarse en la raíz del repositorio BehaviorOS
cd BehaviorOS

# 2. Crear el archivo de variables de entorno
cp .env.example .env

# 3. Levantar la infraestructura
docker compose up -d

# 4. Verificar que los servicios responden
./scripts/healthcheck.sh
```

También puedes usar el script de conveniencia:

```bash
./scripts/setup-local.sh
```

## Servicios expuestos

| Servicio | URL local | Notas |
|----------|-----------|-------|
| API Gateway (Kong) | http://localhost:8000 | Punto de entrada unificado para Auth, REST y Storage |
| Supabase Studio | http://localhost:3000 | UI de administración de base de datos y auth |
| Auth (GoTrue) | http://localhost:9999 | Directo; normalmente se accede a través de Kong |
| Postgres | localhost:5432 | Conexión directa para migraciones y debugging |

## Variables de entorno

Todas las variables se definen en `.env.example`. Copia el archivo a `.env` y ajusta los secretos antes de usar en cualquier entorno que no sea desarrollo local.

Las categorías cubiertas son:

- Infraestructura local (puertos, JWT, claves de servicio)
- Backend (FastAPI)
- Base de datos (Supabase / PostgreSQL)
- Autenticación y seguridad
- IA y modelos (preparado para niveles posteriores)
- Integraciones de pago, comunicación y calendario (placeholders)
- Frontend (React)
- DevOps / observabilidad

## Dominio local

El dominio por defecto para desarrollo es `localhost`. Las URLs externas se configuran mediante:

- `API_EXTERNAL_URL` – punto de entrada de la API
- `GOTRUE_SITE_URL` – URL permitida para redirecciones de autenticación
- `GOTRUE_URI_ALLOW_LIST` – lista adicional de URIs permitidas

Para usar un dominio personalizado en local (por ejemplo `behavioralos.local`), modifica `.env` y añade la entrada correspondiente en tu archivo `hosts`:

```
127.0.0.1 behavioralos.local
```

## Próximos pasos

Una vez verificado el entorno local, el siguiente nivel es **Nivel 1.1 – Seguridad y autenticación**, que añade:

- Registro y login de pacientes
- Roles básicos y RLS en Postgres
- Auditoría de accesos

No se deben implementar características del Nivel 1.1 ni posteriores dentro de este entregable.

## Licencia

Proyecto privado – BehavioralOS.
