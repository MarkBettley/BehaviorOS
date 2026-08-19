---
id: LIC-001
title: Sistema de Licencias y Acceso (LIC)
version: 1.0.0
status: Stable
owner: Comercio & Seguridad
last_updated: 2026-07-14
depends_on:
  - BCE (Modelo de negocio — planes, suscripciones, roles)
  - 900-Security/security.md (RBAC, cifrado, auditoría)
  - 200-Backend/api-graph.md (API Graph — endpoints de verificación)
  - 200-Backend/database-graph.md (Database Graph — tablas de licencias)
  - BCMS (Gestión clínica — asignación de licencias a pacientes)
  - BCOE (Consentimientos — consentimiento para acceso a datos)
exports:
  - Generador de tokens/licencias con expiración
  - Control RBAC (roles y permisos)
  - Verificador de acceso (backend FastAPI)
  - Suspensión/revocación inmediata
  - Integración con BCE, BCMS, BCOE
  - Integración con Stripe/Mercado Pago
used_by:
  - Backend (FastAPI middleware de verificación)
  - Patient App (acceso según licencia)
  - Therapist App (gestión de licencias asignadas)
  - BCE (activación/desactivación de licencias)
  - BCMS (asignación de licencias a pacientes)
---

# BehavioralOS – Sistema de Licencias y Acceso (LIC)

> *"La licencia es el contrato técnico entre el usuario y el ecosistema. Define qué puede hacer, cuánto tiempo, y qué pasa cuando termina. No es un obstáculo; es la puerta de entrada al valor."*

---

## 1. Propósito y Alcance

### 1.1. Propósito
Este documento define el **Sistema de Licencias y Acceso (LIC)**, el componente que gestiona la generación, validación, suspensión y revocación de licencias en el BehavioralOS. Su objetivo es:

- **Generar tokens/licencias** con expiración para cada plan contratado.
- **Control de roles y permisos** (RBAC) que determina qué funcionalidades están disponibles según el plan.
- **Verificar acceso** en tiempo real (middleware backend).
- **Suspender o revocar** licencias de forma inmediata.
- **Integrarse con BCE** (activación por pago), **BCMS** (asignación a pacientes), **BCOE** (consentimientos) y **Stripe/Mercado Pago** (webhooks de pago).

### 1.2. Alcance

| Componente | Descripción |
|-----------|-------------|
| **Generador de tokens** | Emite JWTs con claims de plan, rol, permisos y expiración |
| **RBAC** | Matriz de roles (Paciente, Profesional, Supervisor, Admin, Student, Clinic Admin) × permisos |
| **Verificador de acceso** | Middleware FastAPI que valida token en cada request |
| **Suspensión/revocación** | Invalidación inmediata de tokens (revocation list en Redis) |
| **Integración BCE** | Webhooks de pago activan/desactivan licencias |
| **Integración BCMS** | Asignación de licencias de app a pacientes desde el terapeuta |
| **Integración BCOE** | Consentimiento informado antes de otorgar acceso a datos clínicos |
| **Stripe/Mercado Pago** | Sincronización de estado de suscripción con licencia |

### 1.3. Principios

| # | Principio | Descripción |
|---|-----------|-------------|
| 1 | **Tokens firmados** | JWT con firma RS256. Nunca confiar en tokens no verificables. |
| 2 | **Expiración obligatoria** | Todo token tiene TTL. No hay tokens "para siempre". |
| 3 | **Revocación inmediata** | Un token revocado deja de funcionar en < 1 minuto (Redis TTL). |
| 4 | **Principio de mínimo privilegio** | Cada rol solo tiene los permisos estrictamente necesarios. |
| 5 | **Trazabilidad** | Cada verificación de acceso se registra para auditoría. |
| 6 | **Sin fricción** | La verificación no debe agregar latencia perceptible (< 50ms). |

---

## 2. Arquitectura del Sistema

### 2.1. Diagrama de Componentes

```
┌─────────────────────────────────────────────────────────────────┐
│                        FLUJO DE LICENCIA                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  [BCE: Pago exitoso]                                            │
│         │                                                       │
│         ▼                                                       │
│  [LIC: Generar Token] ──→ [Redis: Revocation List]             │
│         │                     (lista de tokens revocados)       │
│         ▼                                                       │
│  [JWT Firmado]                                                  │
│    - sub: user_id                                               │
│    - plan: pat_individual / pro_professional / ...              │
│    - role: patient / professional / supervisor / admin          │
│    - permissions: [read_exercises, ...]                         │
│    - exp: 30d                                                   │
│    - iat: now                                                   │
│         │                                                       │
│         ▼                                                       │
│  [Backend: FastAPI Middleware]                                   │
│    1. Extraer token del header Authorization: Bearer <jwt>      │
│    2. Verificar firma RS256                                     │
│    3. Verificar expiración                                      │
│    4. Verificar en Redis si está revocado                       │
│    5. Si todo OK → inyectar user info en request context        │
│    6. Si falla → 401 Unauthorized                               │
│         │                                                       │
│         ▼                                                       │
│  [Endpoints protegidos]                                         │
│    - /exercises/*  → requiere permiso read_exercises            │
│    - /ai/*         → requiere permiso use_ai                    │
│    - /sessions/*   → requiere permiso manage_sessions           │
│    - /invoices/*   → requiere permiso read_invoices             │
│    ...                                                          │
└─────────────────────────────────────────────────────────────────┘
```

### 2.2. Estructura del Token JWT

```json
{
  "header": {
    "alg": "RS256",
    "typ": "JWT",
    "kid": "lic-key-2026-07"
  },
  "payload": {
    "sub": "usr_a1b2c3d4",
    "iss": "behavioralos.com",
    "aud": "behavioralos-api",
    "iat": 1752537600,
    "exp": 1755129600,
    "jti": "tok_x1y2z3",
    "plan": "pro_professional",
    "role": "professional",
    "permissions": [
      "read_patients",
      "manage_sessions",
      "use_ai",
      "use_marketplace",
      "manage_billing",
      "read_reports",
      "use_videotherapy",
      "manage_exercises"
    ],
    "ai_credits": 100000,
    "clinic_id": null,
    "supervisor_id": null
  }
}
```

---

## 3. Roles y Permisos (RBAC)

### 3.1. Matriz de Roles

| Rol | Descripción | Planes asociados |
|-----|-------------|-------------------|
| `patient` | Paciente que usa la app | pat_individual, pat_couple, pat_family, pat_neuro |
| `professional` | Psicólogo/terapeuta | pro_professional, pro_plus, pro_expert |
| `supervisor` | Supervisor clínico | pro_expert (incluido) |
| `clinic_admin` | Administrador de clínica | clinic_starter, clinic_growth, clinic_enterprise |
| `student` | Estudiante de psicología | edu_student |
| `professor` | Profesor de universidad | edu_professor |
| `platform_admin` | Administrador de la plataforma | (interno, no comercial) |

### 3.2. Matriz de Permisos

| Permiso | patient | professional | supervisor | clinic_admin | student | professor |
|---------|---------|-------------|-----------|-------------|---------|-----------|
| `read_exercises` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| `play_games` | ✅ | ❌ | ❌ | ❌ | ✅ | ❌ |
| `use_ai` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| `read_own_data` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| `read_patients` | ❌ | ✅ | ✅ | ✅ | ❌ | ❌ |
| `manage_sessions` | ❌ | ✅ | ✅ | ✅ | ❌ | ❌ |
| `use_videotherapy` | ❌ | ✅ | ✅ | ✅ | ❌ | ❌ |
| `manage_billing` | ❌ | ✅ | ✅ | ✅ | ❌ | ❌ |
| `use_marketplace` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| `create_products` | ❌ | ✅ | ✅ | ✅ | ❌ | ❌ |
| `read_reports` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| `generate_reports` | ❌ | ✅ | ✅ | ✅ | ❌ | ❌ |
| `manage_exercises` | ❌ | ✅ | ✅ | ✅ | ❌ | ❌ |
| `use_neuropsych` | ❌ | ✅¹ | ✅ | ✅¹ | ❌ | ❌ |
| `use_couple` | ❌ | ✅¹ | ✅ | ✅¹ | ❌ | ❌ |
| `use_family` | ❌ | ✅¹ | ✅ | ✅¹ | ❌ | ❌ |
| `supervise` | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ |
| `manage_team` | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ |
| `view_analytics` | ❌ | ✅ | ✅ | ✅ | ❌ | ✅ |
| `use_api` | ❌ | ✅¹ | ✅ | ❌ | ❌ | ❌ |
| `custom_branding` | ❌ | ✅¹ | ✅ | ❌ | ❌ | ❌ |
| `meet_copilot` | ❌ | ✅² | ✅ | ❌ | ❌ | ❌ |
| `manage_clinical_cases` | ❌ | ❌ | ❌ | ❌ | ✅ | ✅ |
| `manage_courses` | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |

> ¹ Solo en plan Professional Plus o superior
> ² Solo en plan Expert

### 3.3. Permisos Especiales por Plan

| Plan | Permisos extra |
|------|---------------|
| `pat_couple` | `use_couple`, `play_cooperative_games` |
| `pat_family` | `use_family`, `use_family_games`, `read_family_telemetry` |
| `pat_neuro` | `use_neuropsych`, `read_cognitive_dashboard` |
| `pro_plus` | `use_neuropsych`, `use_couple`, `use_family`, `view_analytics_advanced`, `use_api`, `custom_branding` |
| `pro_expert` | `white_label`, `manage_team`, `supervise`, `meet_copilot`, `use_ai_advanced`, `export_data` |
| `clinic_*` | `manage_team`, `view_clinic_analytics`, `supervise` |

---

## 4. Generación de Licencias

### 4.1. Flujo de Generación

```
[Pago exitoso en BCE]
         │
         ▼
[LIC: Generar Licencia]
         │
         ├── 1. Consultar plan contratado (BCE)
         ├── 2. Determinar rol y permisos (RBAC)
         ├── 3. Generar JWT con claims
         ├── 4. Firmar con clave RS256
         ├── 5. Almacenar metadatos en PostgreSQL (tabla licenses)
         ├── 6. Devolver token al cliente
         │
         ▼
[Token almacenado en cliente]
  - localStorage (web)
  - SecureStore (React Native)
  - HttpOnly cookie (si aplica)
```

### 4.2. Tabla `licenses` (PostgreSQL)

```sql
CREATE TABLE licenses (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES users(id),
    plan_id         VARCHAR(50) NOT NULL,
    role            VARCHAR(30) NOT NULL,
    token_jti       VARCHAR(100) UNIQUE NOT NULL,  -- JWT ID para revocación
    status          VARCHAR(20) DEFAULT 'active',   -- active, suspended, revoked, expired
    issued_at       TIMESTAMPTZ DEFAULT NOW(),
    expires_at      TIMESTAMPTZ NOT NULL,
    revoked_at      TIMESTAMPTZ,
    revoked_reason  TEXT,
    metadata        JSONB DEFAULT '{}',
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    updated_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_licenses_user ON licenses(user_id);
CREATE INDEX idx_licenses_status ON licenses(status);
CREATE INDEX idx_licenses_expires ON licenses(expires_at);
```

### 4.3. Estrategia de Renovación

| Evento | Acción |
|--------|--------|
| **Pago exitoso (renovación)** | Generar nuevo token, revocar el anterior, actualizar `expires_at`. |
| **Pago fallido** | No revocar inmediatamente. Dar período de gracia (3 días). |
| **Cancelación** | Revocar token al final del período facturado. |
| **Upgrade** | Revocar token actual, generar nuevo con permisos expandidos. |
| **Downgrade** | Revocar token actual, generar nuevo con permisos reducidos (al final del ciclo). |

---

## 5. Verificación de Acceso

### 5.1. Middleware FastAPI

```python
from fastapi import Request, HTTPException, Security
from fastapi.security import HTTPBearer
import jwt
import redis

security = HTTPBearer()
redis_client = redis.Redis(host='redis', port=6379, db=0)

async def verify_license(request: Request):
    """
    Middleware que verifica la licencia del usuario.
    1. Extrae el token del header Authorization
    2. Verifica firma RS256
    3. Verifica expiración
    4. Verifica si está en la lista de revocación (Redis)
    5. Inyecta user info en el request context
    """
    auth_header = request.headers.get("Authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Token requerido")

    token = auth_header.split(" ")[1]

    try:
        payload = jwt.decode(
            token,
            PUBLIC_KEY,
            algorithms=["RS256"],
            audience="behavioralos-api",
            issuer="behavioralos.com"
        )
    except jwt.ExpiredSignatureError:
        raise HTTPException(status_code=401, detail="Token expirado")
    except jwt.InvalidTokenError:
        raise HTTPException(status_code=401, detail="Token inválido")

    # Verificar revocación en Redis
    jti = payload.get("jti")
    if redis_client.get(f"revoked:{jti}"):
        raise HTTPException(status_code=401, detail="Token revocado")

    # Verificar permiso específico para el endpoint
    required_permission = get_required_permission(request.url.path, request.method)
    if required_permission and required_permission not in payload.get("permissions", []):
        raise HTTPException(status_code=403, detail="Permiso insuficiente")

    # Inyectar en el contexto
    request.state.user_id = payload["sub"]
    request.state.plan = payload["plan"]
    request.state.role = payload["role"]
    request.state.permissions = payload["permissions"]
    request.state.ai_credits = payload.get("ai_credits", 0)

    return payload
```

### 5.2. Endpoint de Verificación Rápida

```
GET /api/v1/license/verify
Headers: Authorization: Bearer <jwt>

Response 200:
{
  "valid": true,
  "plan": "pro_professional",
  "role": "professional",
  "permissions": ["read_patients", "manage_sessions", ...],
  "ai_credits_remaining": 85000,
  "expires_at": "2026-08-14T00:00:00Z"
}

Response 401:
{
  "valid": false,
  "error": "Token expirado"
}

Response 403:
{
  "valid": true,
  "error": "Permiso insuficiente",
  "missing_permission": "use_neuropsych"
}
```

---

## 6. Suspensión y Revocación

### 6.1. Tipos de Suspensión

| Tipo | Causa | Acción | Reversión |
|------|-------|--------|-----------|
| **Pausa voluntaria** | El usuario solicita pausa | Token se mantiene pero con `status: paused` | Reactivación automática al reanudar |
| **Pago fallido** | Tarjeta rechazada | Período de gracia (3 días) | Al realizar pago exitoso |
| **Cancelación** | El usuario cancela | Revocación al final del período | No aplica (nueva suscripción) |
| **Suspensión administrativa** | Violación de términos | Revocación inmediata | Solo por revisión manual |
| **Expiración** | Fin del período | Token invalidado | Al renovar suscripción |

### 6.2. Mecanismo de Revocación

```
[Admin/ Sistema decide revocar]
         │
         ▼
[LIC: Revocar Token]
         │
         ├── 1. Agregar jti a Redis (revoked:<jti> con TTL = expiración original)
         ├── 2. Actualizar status en tabla licenses
         ├── 3. Registrar evento de auditoría
         ├── 4. Notificar al usuario (si aplica)
         │
         ▼
[Verificación de acceso falla]
  - Redis check detecta token revocado
  - Retorna 401 al siguiente request
  - Latencia adicional: < 1ms (Redis lookup)
```

### 6.3. Revocación Inmediata por BCE

Cuando el BCE recibe un webhook de `customer.subscription.deleted` o detecta un pago fallido irreversible:

```python
@router.post("/webhooks/stripe")
async def handle_stripe_webhook(event: StripeEvent):
    if event.type == "customer.subscription.deleted":
        user_id = event.data.object.metadata.user_id
        await lic_service.revoke_all_licenses(
            user_id=user_id,
            reason="subscription_canceled"
        )
    elif event.type == "invoice.payment_failed":
        # Iniciar período de gracia, no revocar aún
        user_id = event.data.object.metadata.user_id
        await lic_service.start_grace_period(user_id, days=3)
```

---

## 7. Modelo Dual de Licenciamiento

### 7.1. Dos Formas de Otorgar Acceso

El sistema soporta dos modelos que el psicólogo puede elegir:

| Modelo | Quién paga | Cómo funciona |
|--------|-----------|---------------|
| **Incluido** | El psicólogo (su suscripción SaaS) | El terapeuta asigna licencias de la app a sus pacientes sin costo adicional para ellos |
| **Compartido** | El paciente (su suscripción directa) | El paciente contrata su propia suscripción para acceder a la app |

### 7.2. Flujo — Modelo Incluido

```
[Psicólogo con plan Professional ($999/mes)]
         │
         ├── Asigna licencia a paciente "Ana"
         │
         ▼
[LIC genera token para Ana]
  - plan: "patient_included"
  - role: patient
  - permissions: [read_exercises, use_ai, ...]
  - paid_by: professional_id
  - expires_at:同步 a la suscripción del terapeuta
         │
         ▼
[Ana descarga la app]
  - Se autentica
  - LIC verifica token
  - Ana tiene acceso completo a la app
  - No paga nada
```

### 7.3. Flujo — Modelo Compartido

```
[Paciente "Carlos" descarga la app]
         │
         ├── Se registra
         ├── Selecciona plan Behavioral Individual ($149/mes)
         ├── Paga a través de BCE (Stripe/Mercado Pago)
         │
         ▼
[LIC genera token para Carlos]
  - plan: "pat_individual"
  - role: patient
  - permissions: [read_exercises, use_ai, ...]
  - paid_by: self
  - expires_at: 30 días desde el pago
         │
         ▼
[Carlos accede a la app]
  - LIC verifica token
  - Acceso completo según su plan
```

### 7.4. Coexistencia de Modelos

Un terapeuta puede tener pacientes en ambos modelos simultáneamente:
- Pacientes "incluidos" (la licencia la paga el terapeuta)
- Pacientes "compartidos" (la licencia la paga el paciente)

El sistema LIC mantiene un registro claro de quién pagó cada licencia para:
- Facturación correcta (BCE)
- Métricas de uso (BIP)
- Gestión de expiración (si el terapeuta cancela, sus pacientes incluidos pierden acceso)

---

## 8. Integración con el Ecosistema

### 8.1. BCE → LIC

| Evento BCE | Acción LIC |
|-----------|-----------|
| Pago exitoso (nueva suscripción) | Generar token con permisos del plan |
| Renovación exitosa | Generar nuevo token, revocar anterior |
| Upgrade de plan | Generar token con permisos expandidos |
| Downgrade de plan | Generar token con permisos reducidos |
| Cancelación | Programar revocación al final del período |
| Pago fallido | Iniciar período de gracia |
| Reembolso | Revocar token inmediatamente |

### 8.2. BCMS → LIC

| Evento BCMS | Acción LIC |
|-----------|-----------|
| Terapeuta asigna paciente | Si modelo incluido → generar token para paciente |
| Terapeuta elimina paciente | Revocar token del paciente |
| Cambio de terapeuta | Transferir licencia al nuevo terapeuta |

### 8.3. BCOE → LIC

| Evento BCOE | Acción LIC |
|-----------|-----------|
| Consentimiento firmado | Habilitar permisos de datos clínicos |
| Consentimiento revocado | Revocar permisos de datos clínicos |
| Consentimiento expirado | Limitar acceso a datos sensibles |

### 8.4. Stripe/Mercado Pago → LIC

| Webhook | Acción LIC |
|---------|-----------|
| `payment_intent.succeeded` | Generar/renovar token |
| `customer.subscription.deleted` | Revocar token |
| `invoice.payment_failed` | Iniciar período de gracia |
| `charge.refunded` | Revocar token |

---

## 9. Seguridad

### 9.1. Claves de Firma

- **Algoritmo**: RS256 (RSA con SHA-256)
- **Rotación de claves**: Cada 90 días
- **Clave privada**: Almacenada en vault (no en código)
- **Clave pública**: Distribuida a todos los servicios backend
- **Kid (Key ID)**: Incluido en el header del JWT para identificar la versión

### 9.2. Protección contra Abuso

| Amenaza | Mitigación |
|---------|-----------|
| Token robado | TTL corto (30 días), revocación inmediata, detección de usos anómalos |
| Token compartido entre usuarios | `sub` (user_id) validado contra la base de datos |
| Fuerza bruta contra endpoints | Rate limiting (100 req/min por IP) |
| Token expirado sin renovar | Período de gracia (3 días), notificaciones |
| Manipulación de claims | Firma RS256, verificación en cada endpoint |

### 9.3. Auditoría

Cada verificación de acceso genera un registro:

```sql
CREATE TABLE license_audit_log (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_type      VARCHAR(50) NOT NULL,  -- issued, verified, revoked, expired, suspended
    license_id      UUID REFERENCES licenses(id),
    user_id         UUID NOT NULL,
    token_jti       VARCHAR(100),
    ip_address      INET,
    user_agent      TEXT,
    details         JSONB DEFAULT '{}',
    created_at      TIMESTAMPTZ DEFAULT NOW()
);
```

---

## 10. Criterios de Validación

| Criterio | Métrica | Verificación |
|----------|---------|-------------|
| Velocidad de verificación | < 50ms por request | Benchmark del middleware |
| Revocación inmediata | < 1 minuto hasta efectividad | Prueba de integración Redis |
| Firma válida | 100% tokens verificables | Prueba de generación/verificación |
| Permisos correctos | 0% accesos no autorizados | Pruebas de RBAC |
| Expiración | 0% tokens activos después de expiración | Prueba de TTL |
| Auditoría | 100% eventos registrados | Prueba de logging |
| Modelo dual | Soporte para incluido y compartido | Prueba de integración BCE-LIC |
| Rotación de claves | Sin interrupción durante rotación | Prueba de rotación |

---

## 11. Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| **1.0.0** | **2026-07-14** | **Arquitectura Comercial** | **Creación del documento. Definición del Sistema de Licencias y Acceso (LIC): generación de tokens JWT con expiración, RBAC completo (7 roles, 20+ permisos), verificador de acceso (middleware FastAPI), suspensión/revocación inmediata, integración con BCE/BCMS/BCOE/Stripe, modelo dual de licenciamiento (incluido vs. compartido), auditoría de seguridad.** |
