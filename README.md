# BehaviorOS

> Plataforma de software para digitalizar procesos de intervención, seguimiento y medición basados en ciencias del comportamiento.

BehaviorOS es un proyecto de ingeniería de software que combina **desarrollo backend, seguridad, análisis conductual y una arquitectura preparada para experiencias digitales adaptativas**.

El proyecto nace de la intersección entre mi experiencia profesional en **Psicología, Neuropsicología y Ciencias del Comportamiento** y mi formación en **desarrollo de software y análisis de datos**.

Su objetivo es transformar procedimientos conductuales —evaluación, intervención, seguimiento y medición— en componentes digitales estructurados, seguros y medibles.

---

## Estado actual

| Nivel | Alcance | Estado |
|---|---|---|
| 0.2 | Infraestructura base | ✅ Completado |
| 1.1 | Seguridad y autenticación | ✅ Implementado, verificado y archivado |
| 1.2 | Backend mínimo | ✅ Implementado, verificado y archivado |

### Nivel 1.1 — Seguridad y autenticación

Implementación del modelo inicial de identidad, seguridad y aislamiento de datos.

**Resultado de verificación:**

- 27/27 tareas completadas
- 29/29 requisitos
- 48/48 escenarios
- Veredicto: `PASS`
- 0 blockers
- 0 hallazgos críticos

Incluye:

- Registro y autenticación de pacientes
- JWT
- Perfiles de paciente
- Gestión de consentimiento
- Row Level Security (RLS)
- Auditoría de accesos
- Aislamiento de información entre usuarios
- Harness automatizado de seguridad

### Nivel 1.2 — Backend mínimo

Primera API funcional de BehaviorOS construida con FastAPI.

**Resultado de verificación:**

- 15/15 tareas completadas
- 10/10 requisitos
- 23/23 escenarios
- Harness: `PASS=50 / FAIL=0`
- Veredicto: `PASS`
- 0 blockers
- 0 hallazgos críticos
- Python `compileall`: exit 0

Incluye:

- API versionada `/api/v1`
- Health endpoint
- Documentación OpenAPI
- Autenticación mediante JWT
- Endpoint `/auth/me`
- Catálogo inicial de ejercicios
- Gestión de sesiones de ejercicio
- Inicio y finalización de sesiones
- Finalización idempotente
- Control de propiedad de sesiones
- Persistencia de telemetría conductual
- Pruebas de RLS y aislamiento entre pacientes

---

## Arquitectura actual

```text
Client
   │
   ▼
Kong API Gateway
   │
   ├── Supabase Auth / GoTrue
   │
   ├── PostgREST
   │
   └── FastAPI Backend
            │
            ▼
      PostgreSQL / Supabase
            │
            ├── Patient Profiles
            ├── Consent
            ├── Audit Logs
            ├── Exercise Catalog
            ├── Exercise Sessions
            └── Behavioral Telemetry
```

La infraestructura se ejecuta mediante **Docker Compose**, permitiendo reproducir localmente los servicios necesarios para el desarrollo.

---

## Stack tecnológico

### Backend

- Python
- FastAPI
- Uvicorn
- SQLAlchemy
- Alembic
- Pydantic

### Datos e infraestructura

- PostgreSQL
- Supabase
- PostgREST
- Supabase Auth / GoTrue
- Supabase Storage
- Kong API Gateway
- Docker
- Docker Compose

### Seguridad

- JSON Web Tokens (JWT)
- Row Level Security (RLS)
- Roles de base de datos
- Separación entre credenciales administrativas y de aplicación
- Auditoría de operaciones
- Gestión de consentimiento

### Ingeniería y calidad

- Git / GitHub
- OpenAPI
- Migraciones versionadas
- Pruebas automatizadas
- Harnesses de integración y seguridad
- Specification-Driven Development (SDD)
- OpenSpec

---

## API

El backend utiliza una API versionada:

```text
/api/v1
```

Entre los endpoints implementados se encuentran:

```text
/api/v1/health
/api/v1/auth/me
/api/v1/exercises
/api/v1/exercises/EX_1
```

El backend incluye documentación OpenAPI disponible en el entorno local.

---

## Telemetría conductual

El Nivel 1.2 incorpora persistencia de variables asociadas a la interacción con ejercicios.

Actualmente se registran cuatro variables:

```text
duration
completion
pauses
retries
```

Esto establece una base para analizar posteriormente patrones de interacción y adherencia dentro de las experiencias terapéuticas.

---

## Seguridad y privacidad

BehaviorOS adopta una arquitectura donde el acceso a información sensible no depende únicamente de la lógica de la aplicación.

PostgreSQL utiliza **Row Level Security (RLS)** para restringir el acceso a los datos según la identidad y el rol del usuario.

El backend utiliza además un usuario de base de datos específico para la aplicación, separado de las credenciales administrativas utilizadas para migraciones.

El Nivel 1.1 incluye pruebas específicas para:

- autenticación
- sesiones
- perfiles
- consentimiento
- auditoría
- RLS
- aislamiento entre pacientes
- cierre de sesión y revocación de acceso

---

## Desarrollo guiado por especificaciones

BehaviorOS utiliza un flujo de **Specification-Driven Development**.

Cada incremento puede contener:

```text
proposal
exploration
research
design
specifications
tasks
implementation
verification
archive
```

Las especificaciones sincronizadas funcionan como fuente de verdad del comportamiento esperado del sistema.

Los ciclos completados conservan además evidencia de implementación y verificación dentro de:

```text
openspec/changes/archive/
```

Esto permite mantener trazabilidad entre:

```text
requisito → implementación → prueba → verificación
```

---

## Estructura del repositorio

```text
BehaviorOS/
├── backend/
│   ├── alembic/
│   └── app/
│       ├── api/
│       ├── core/
│       └── exercises/
│
├── migrations/
│
├── openspec/
│   ├── changes/
│   │   └── archive/
│   └── specs/
│
├── scripts/
│
├── Sdd/
│   └── specs/
│
├── docker-compose.yml
└── README.md
```

---

## Ejecución local

### Requisitos

- Docker Engine 24.x o superior
- Docker Compose v2 o superior

### 1. Clonar el repositorio

```bash
git clone https://github.com/MarkBettley/BehaviorOS.git
cd BehaviorOS
```

### 2. Configurar variables

```bash
cp .env.example .env
```

Completa los valores locales requeridos en `.env`.

Los secretos reales **no deben incorporarse al repositorio**.

### 3. Preparar el entorno

```bash
./scripts/setup-local.sh
```

También es posible iniciar los servicios directamente:

```bash
docker compose up -d
```

### 4. Verificar infraestructura

```bash
./scripts/healthcheck.sh
```

---

## Servicios locales

| Servicio | Dirección |
|---|---|
| Kong API Gateway | `http://localhost:8000` |
| Backend FastAPI | `http://localhost:8001` |
| Supabase Studio | `http://localhost:3000` |
| Supabase Auth / GoTrue | `http://localhost:9999` |
| PostgreSQL | `localhost:5432` |

---

## Visión del proyecto

BehaviorOS está diseñado como una plataforma evolutiva.

La arquitectura general contempla progresivamente componentes relacionados con:

- experiencias digitales de intervención
- seguimiento longitudinal
- medición de procesos conductuales
- analítica
- personalización
- herramientas para profesionales
- sistemas adaptativos
- integración futura de componentes de inteligencia artificial

Estas capacidades forman parte de la evolución arquitectónica del proyecto y **no implican que todos estos módulos estén actualmente implementados**.

---

## Motivación

Mi formación inicial es en **Psicología y Neuropsicología**, y posteriormente amplié mi perfil hacia el **desarrollo de software, datos e inteligencia artificial**.

BehaviorOS surge como un proyecto para explorar cómo convertir conocimiento especializado de ciencias del comportamiento en sistemas de software estructurados y técnicamente verificables.

El proyecto funciona también como laboratorio para desarrollar competencias en:

- arquitectura backend
- APIs
- bases de datos
- seguridad
- testing
- diseño de sistemas
- análisis de datos conductuales
- desarrollo asistido por IA

---

## Roadmap

El desarrollo continúa de forma incremental mediante nuevos ciclos de especificación, implementación y verificación.

La arquitectura completa y las decisiones de diseño se documentan dentro de `Sdd/specs/`, mientras que las especificaciones funcionales vigentes se mantienen en `openspec/specs/`.

---

## Autor

**Marco Antonio Hernández Baños**

Psychology & Neuropsychology · Software Development · Data & AI · Behavioral Science

GitHub: [@MarkBettley](https://github.com/MarkBettley)

---

## Estado del proyecto

🚧 **En desarrollo activo**

Los niveles 0.2, 1.1 y 1.2 constituyen actualmente la base implementada del sistema. Las capacidades posteriores se incorporarán progresivamente mediante ciclos independientes de desarrollo y verificación.
