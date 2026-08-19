---
id: API-001
title: API Graph – Contratos y Servicios
version: 1.1.0
status: Stable
owner: Backend & Arquitectura de Software
last_updated: 2026-08-12
depends_on:
  - 000-Core (Ontología, Principios)
  - 100-Architecture/system-architecture.md (BEA)
  - 100-Architecture/behavioral-twin.md (Behavioral Twin)
  - 100-Architecture/data-model.md (Modelo de Datos)
exports:
  - Catálogo completo de APIs REST y WebSockets
  - Contratos de entrada/salida (schemas)
  - Políticas de autenticación y autorización (JWT + RLS)
  - Estrategia de versionado semántico
  - Documentación OpenAPI 3.0 (generada automáticamente)
used_by:
  - Frontend (Patient App, Therapist App, Admin Dashboard)
  - BRIL (Integración y eventos)
  - Integraciones externas (Google Meet, Stripe, Mercado Pago, etc.)
  - BQAS (Pruebas de integración y contract testing)
---

# BehavioralOS – API Graph

> *"Una API bien diseñada no es solo un medio de comunicación técnica. Es un contrato que define cómo los diferentes mundos (clínico, comercial, operacional, científico) se hablan entre sí. Una API clara, versionada y documentada es la base de un ecosistema que puede crecer sin romperse."*

---

## 1. Propósito y Alcance

### 1.1. Propósito
Este documento define el **catálogo completo de APIs** del BehavioralOS. Su objetivo es:

- **Establecer un contrato claro** entre el backend y todos los consumidores (frontend, motores, integraciones externas).
- **Especificar la estructura** de las peticiones y respuestas (schemas) para cada dominio.
- **Garantizar la seguridad** mediante autenticación (JWT), autorización (RLS) y políticas de rate limiting.
- **Facilitar la evolución** mediante versionado semántico y estrategias de deprecación.
- **Proveer documentación viva** (OpenAPI 3.0) que se mantenga sincronizada con el código.

### 1.2. Alcance
El API Graph cubre:

- **APIs REST** para operaciones síncronas (CRUD, consultas, comandos).
- **WebSockets** para comunicación en tiempo real (chat, videoterapia, HUD, telemetría en vivo).
- **Webhooks** para integraciones externas (Stripe, Mercado Pago, Facturapi, etc.).
- **Autenticación y autorización** (JWT, OAuth2, WebAuthn, RLS).
- **Versionado semántico** (v1, v2, etc.) y estrategias de deprecación.
- **Documentación** (OpenAPI 3.0) generada automáticamente desde el código.

### 1.3. Principio Fundamental
> **"Toda API debe ser autodescriptiva, segura y versionada. Un cliente debe poder entender qué hace un endpoint sin necesidad de leer documentación externa. La API es el contrato entre el BehavioralOS y el mundo."**

---

## 2. Estructura General de las APIs

### 2.1. Base URL y Entorno

| Entorno | URL | Propósito |
|---------|-----|-----------|
| **Desarrollo** | `https://dev-api.behavioralos.com` | Pruebas internas y desarrollo. |
| **Staging** | `https://staging-api.behavioralos.com` | Validación previa a producción. |
| **Producción** | `https://api.behavioralos.com` | Entorno en vivo. |

### 2.2. Versionado

- **Formato**: `/api/v{MAJOR}/{resource}`
- **Ejemplo**: `https://api.behavioralos.com/api/v1/patients`
- **Política**: 
  - **MAJOR**: Cambios incompatibles (ej. cambio de schema, eliminación de endpoint).
  - **MINOR**: Adición de nuevos endpoints o campos (compatibles).
  - **PATCH**: Correcciones de errores y mejoras de rendimiento (sin cambios en la API).
- **Deprecación**: Las versiones antiguas se mantienen activas durante al menos 12 meses después del anuncio de deprecación.

### 2.3. Autenticación y Autorización

| Método | Descripción | Uso |
|--------|-------------|-----|
| **JWT (Bearer Token)** | Token de acceso (corto plazo, 15-60 minutos). | Todas las APIs REST y WebSockets. |
| **Refresh Token** | Token de larga duración (7-30 días) para renovar el JWT. | Endpoint `/api/v1/auth/refresh`. |
| **OAuth2** | Autenticación con Google, Microsoft, etc. | Login social. |
| **WebAuthn** | Autenticación biométrica (passkeys). | Login sin contraseña (opcional). |
| **RLS (Row Level Security)** | Políticas en PostgreSQL que restringen el acceso a nivel de fila. | Capa adicional de autorización (tenant + rol). |
| **API Keys** | Claves para integraciones externas (servicios, webhooks). | Endpoints de webhooks y servicios externos. |

**Flujo de autenticación típico**:
1. El cliente envía credenciales a `/api/v1/auth/login`.
2. El servidor valida las credenciales y devuelve un `access_token` (JWT) y un `refresh_token`.
3. El cliente incluye el `access_token` en el header `Authorization: Bearer <token>` en cada petición.
4. El servidor valida el JWT (firma, expiración, permisos) y aplica RLS.
5. Si el JWT expira, el cliente usa el `refresh_token` en `/api/v1/auth/refresh` para obtener uno nuevo.
6. Si el `refresh_token` expira, el cliente debe autenticarse nuevamente.

### 2.4. Headers Comunes

| Header | Descripción | Obligatorio |
|--------|-------------|-------------|
| `Authorization: Bearer <token>` | Token JWT para autenticación. | Sí (excepto endpoints públicos). |
| `Content-Type: application/json` | Formato de la petición. | Sí (para POST/PUT/PATCH). |
| `Accept: application/json` | Formato de la respuesta esperado. | Sí. |
| `X-Idempotency-Key: <UUID>` | Clave de idempotencia para operaciones críticas. | Para POST/PUT en endpoints transaccionales. |
| `X-Tenant-ID: <UUID>` | Identificador del tenant (clínica/organización). | Obligatorio para endpoints multi-tenant. |
| `X-Request-ID: <UUID>` | Identificador único de la petición (para trazabilidad). | Recomendado. |

### 2.5. Códigos de Estado HTTP

| Código | Significado | Uso |
|--------|-------------|-----|
| 200 OK | Petición exitosa (GET, PUT, DELETE). | Respuesta estándar. |
| 201 Created | Recurso creado exitosamente (POST). | Creación de nuevos recursos. |
| 204 No Content | Petición exitosa sin contenido en la respuesta. | DELETE, PUT sin cambios. |
| 400 Bad Request | Error en la petición (validación fallida, formato incorrecto). | Validación de schema. |
| 401 Unauthorized | Falta autenticación o token inválido. | JWT faltante o expirado. |
| 403 Forbidden | Autenticación correcta pero sin permisos. | RLS o rol insuficiente. |
| 404 Not Found | Recurso no encontrado. | Endpoint o ID inexistente. |
| 409 Conflict | Conflicto con el estado actual (ej. duplicado). | Creación de recurso duplicado. |
| 422 Unprocessable Entity | Error de validación de negocio (ej. datos inconsistentes). | Reglas de negocio. |
| 429 Too Many Requests | Límite de peticiones excedido. | Rate limiting. |
| 500 Internal Server Error | Error interno del servidor. | Fallo inesperado. |

---

## 3. Organización por Dominios

Las APIs se organizan por **dominios** que reflejan la arquitectura de capas y bounded contexts de la BEA. Cada dominio tiene su propio conjunto de recursos y endpoints.

/api/v1/
├── auth/ # Autenticación y gestión de usuarios
├── clinical/ # Datos clínicos (pacientes, sesiones, evaluaciones, etc.)
├── commerce/ # Suscripciones, pagos, facturas, productos
├── practice/ # Agenda, videoterapia, CRM, workflows
├── analytics/ # Dashboards, KPI, predicciones, investigación
├── exercises/ # Ejercicios (BERL), telemetría, gamificación
├── ai/ # IA (TCCN, AAO, RAG, modelos)
├── admin/ # Administración del sistema (usuarios, tenants, configuraciones)
└── webhooks/ # Webhooks para integraciones externas


### 3.1. Dominio `auth` (Autenticación y Usuarios)

| Método | Endpoint | Descripción | Autenticación |
|--------|----------|-------------|---------------|
| POST | `/auth/login` | Iniciar sesión con email/contraseña. | Público |
| POST | `/auth/register` | Registrar un nuevo usuario (paciente o terapeuta). | Público |
| POST | `/auth/refresh` | Renovar JWT usando refresh token. | Público (con refresh token) |
| POST | `/auth/logout` | Cerrar sesión (invalidar refresh token). | Requiere JWT |
| POST | `/auth/oauth/{provider}` | Iniciar sesión con OAuth2 (Google, Microsoft). | Público |
| POST | `/auth/webauthn/register` | Registrar dispositivo para WebAuthn. | Requiere JWT |
| POST | `/auth/webauthn/login` | Iniciar sesión con WebAuthn (passkey). | Público |
| POST | `/auth/password-reset/request` | Solicitar restablecimiento de contraseña. | Público |
| POST | `/auth/password-reset/confirm` | Confirmar restablecimiento de contraseña con token. | Público |
| GET | `/auth/me` | Obtener información del usuario autenticado. | Requiere JWT |
| PUT | `/auth/me` | Actualizar perfil del usuario autenticado. | Requiere JWT |

### 3.2. Dominio `clinical` (Datos Clínicos)

| Método | Endpoint | Descripción | Autenticación |
|--------|----------|-------------|---------------|
| GET | `/clinical/patients` | Listar pacientes (con filtros). | Terapeuta/Admin |
| POST | `/clinical/patients` | Crear un nuevo paciente. | Terapeuta/Admin |
| GET | `/clinical/patients/{id}` | Obtener detalles de un paciente (incluye Behavioral Twin). | Terapeuta/Paciente (propio) |
| PUT | `/clinical/patients/{id}` | Actualizar información del paciente. | Terapeuta/Admin |
| DELETE | `/clinical/patients/{id}` | Dar de baja un paciente (soft delete). | Admin |
| GET | `/clinical/patients/{id}/sessions` | Listar sesiones de un paciente. | Terapeuta/Paciente (propio) |
| POST | `/clinical/patients/{id}/sessions` | Crear una nueva sesión. | Terapeuta |
| GET | `/clinical/patients/{id}/sessions/{session_id}` | Obtener detalles de una sesión. | Terapeuta/Paciente (propio) |
| PUT | `/clinical/patients/{id}/sessions/{session_id}` | Actualizar una sesión (notas, estado, etc.). | Terapeuta |
| POST | `/clinical/patients/{id}/sessions/{session_id}/notes` | Añadir nota de sesión (SOAP/DAP). | Terapeuta |
| GET | `/clinical/patients/{id}/assessments` | Listar evaluaciones de un paciente. | Terapeuta/Paciente (propio) |
| POST | `/clinical/patients/{id}/assessments` | Iniciar una nueva evaluación (AAO). | Terapeuta/Paciente |
| GET | `/clinical/patients/{id}/assessments/{assessment_id}` | Obtener resultado de una evaluación. | Terapeuta/Paciente (propio) |
| GET | `/clinical/patients/{id}/hypotheses` | Listar hipótesis funcionales del paciente. | Terapeuta |
| POST | `/clinical/patients/{id}/hypotheses` | Añadir una nueva hipótesis (terapeuta). | Terapeuta |
| PUT | `/clinical/patients/{id}/hypotheses/{hypothesis_id}` | Actualizar hipótesis (confianza, estado). | Terapeuta |
| GET | `/clinical/patients/{id}/twin` | Obtener el Behavioral Twin completo del paciente. | Terapeuta/Paciente (propio) |
| PUT | `/clinical/patients/{id}/twin` | Forzar actualización del Twin (uso clínico). | Terapeuta |
| GET | `/clinical/patients/{id}/values` | Listar valores del paciente (ACT). | Terapeuta/Paciente (propio) |
| POST | `/clinical/patients/{id}/values` | Añadir un nuevo valor. | Terapeuta/Paciente |
| GET | `/clinical/patients/{id}/goals` | Listar objetivos terapéuticos. | Terapeuta/Paciente (propio) |
| POST | `/clinical/patients/{id}/goals` | Crear un nuevo objetivo. | Terapeuta |

### 3.3. Dominio `commerce` (Suscripciones, Pagos, Facturas)

| Método | Endpoint | Descripción | Autenticación |
|--------|----------|-------------|---------------|
| GET | `/commerce/plans` | Listar planes de suscripción disponibles. | Público |
| GET | `/commerce/plans/{id}` | Obtener detalles de un plan. | Público |
| POST | `/commerce/subscriptions` | Crear una nueva suscripción (iniciar pago). | Paciente |
| GET | `/commerce/subscriptions/current` | Obtener suscripción activa del paciente. | Paciente |
| PUT | `/commerce/subscriptions/{id}` | Cancelar o modificar suscripción. | Paciente |
| GET | `/commerce/invoices` | Listar facturas del paciente. | Paciente |
| GET | `/commerce/invoices/{id}` | Obtener detalles de una factura (PDF/XML). | Paciente |
| POST | `/commerce/invoices/{id}/pay` | Realizar pago de una factura pendiente. | Paciente |
| GET | `/commerce/products` | Listar productos del marketplace. | Público |
| POST | `/commerce/products/{id}/purchase` | Comprar un producto digital. | Paciente |
| POST | `/leads` | Crear un lead de la landing (SLS-001-REC-003, validación + deduplicación + consentimiento). | Público |
| POST | `/commerce/webhooks/stripe` | Webhook de Stripe (eventos de pago). | Público (verificado con firma) |
| POST | `/commerce/webhooks/mercadopago` | Webhook de Mercado Pago (eventos de pago). | Público (verificado con firma) |
| POST | `/commerce/webhooks/facturapi` | Webhook de Facturapi (estado de factura). | Público (verificado con firma) |

### 3.4. Dominio `practice` (Agenda, Videoterapia, CRM)

| Método | Endpoint | Descripción | Autenticación |
|--------|----------|-------------|---------------|
| GET | `/practice/appointments` | Listar citas (con filtros de fecha). | Terapeuta/Paciente |
| POST | `/practice/appointments` | Crear una nueva cita. | Terapeuta/Paciente |
| PUT | `/practice/appointments/{id}` | Actualizar cita (cambiar fecha, cancelar). | Terapeuta/Paciente |
| GET | `/practice/appointments/available` | Obtener horarios disponibles del terapeuta. | Público (para agenda) |
| GET | `/practice/appointments/{id}/videocall` | Obtener URL de videollamada (Google Meet/Zoom). | Terapeuta/Paciente |
| POST | `/practice/messages` | Enviar un mensaje (paciente ↔ terapeuta). | Paciente/Terapeuta |
| GET | `/practice/messages` | Obtener conversaciones (con paginación). | Paciente/Terapeuta |
| GET | `/practice/messages/{id}` | Obtener mensaje específico. | Paciente/Terapeuta |
| PUT | `/practice/messages/{id}/read` | Marcar mensaje como leído. | Paciente/Terapeuta |
| GET | `/practice/reports` | Listar informes generados del paciente. | Terapeuta/Paciente |
| POST | `/practice/reports` | Generar un nuevo informe (ej. FBR). | Terapeuta |
| GET | `/practice/reports/{id}` | Descargar informe (PDF). | Terapeuta/Paciente |
| GET | `/practice/templates` | Listar plantillas de documentos. | Terapeuta |
| POST | `/practice/templates` | Crear nueva plantilla. | Terapeuta |
| GET | `/practice/analytics` | Obtener KPIs del terapeuta (citas, ingresos, etc.). | Terapeuta/Admin |

### 3.5. Dominio `exercises` (BERL – Ejercicios y Gamificación)

| Método | Endpoint | Descripción | Autenticación |
|--------|----------|-------------|---------------|
| GET | `/exercises` | Listar ejercicios disponibles (catálogo). | Paciente/Terapeuta |
| GET | `/exercises/{id}` | Obtener detalles de un ejercicio. | Paciente/Terapeuta |
| POST | `/exercises/{id}/start` | Iniciar un ejercicio (crear sesión de ejercicio). | Paciente |
| POST | `/exercises/{id}/complete` | Finalizar ejercicio (enviar telemetría). | Paciente |
| GET | `/exercises/sessions` | Listar sesiones de ejercicio del paciente. | Paciente/Terapeuta |
| GET | `/exercises/sessions/{id}` | Obtener detalles de una sesión de ejercicio (con telemetría). | Paciente/Terapeuta |
| GET | `/exercises/catalog` | Obtener catálogo completo de ejercicios (para el terapeuta). | Terapeuta |
| POST | `/exercises/catalog` | Crear un nuevo ejercicio (BERL – solo equipo interno). | Admin/BERL |
| PUT | `/exercises/catalog/{id}` | Actualizar un ejercicio (versionado). | Admin/BERL |
| GET | `/exercises/telemetry` | Obtener telemetría agregada (para análisis). | Terapeuta/Admin |
| POST | `/exercises/{id}/adapt` | Forzar adaptación del ejercicio (AHEE). | Sistema (interno) |

### 3.6. Dominio `ai` (IA – TCCN, AAO, RAG, Soporte)

| Método | Endpoint | Descripción | Autenticación |
|--------|----------|-------------|---------------|
| POST | `/ai/chat` | Enviar mensaje al TCCN (compañero). | Paciente |
| GET | `/ai/chat/history` | Obtener historial de conversaciones con el TCCN. | Paciente |
| POST | `/ai/chat/{id}/feedback` | Enviar feedback sobre la respuesta del TCCN. | Paciente |
| POST | `/ai/assess/adaptive` | Iniciar evaluación adaptativa (AAO). | Paciente |
| GET | `/ai/assess/{assessment_id}/status` | Obtener estado de una evaluación en curso. | Paciente |
| POST | `/ai/assess/{assessment_id}/response` | Enviar respuesta a una pregunta de la evaluación. | Paciente |
| GET | `/ai/rag/query` | Búsqueda semántica en la base de conocimiento (RAG). | Terapeuta/Admin |
| POST | `/ai/models/gemma/infer` | Realizar inferencia con Gemma (uso interno). | Sistema (interno) |
| GET | `/ai/models/status` | Obtener estado de los modelos de IA (Gemma, MediaPipe). | Admin |
| POST | `/ai/guardrails/validate` | Validar un prompt contra los guardrails clínicos. | Sistema (interno) |
| POST | `/ai/escalation` | Crear un ticket de soporte (escalamiento AI-007) → 201 al persistir; canales públicos cuando no hay consentimiento. | Público/Paciente/Terapeuta |
| GET | `/ai/escalation/{ticket_id}` | Obtener estado de un ticket de soporte (seguimiento por ID). | Paciente/Terapeuta/Soporte |
| GET | `/ai/escalation` | Listar tickets de soporte (equipo de soporte / admin). | Admin/Soporte |

### 3.7. Dominio `analytics` (Dashboards y KPI)

| Método | Endpoint | Descripción | Autenticación |
|--------|----------|-------------|---------------|
| GET | `/analytics/dashboard/therapist` | Obtener KPIs del terapeuta (pacientes activos, ingresos, etc.). | Terapeuta |
| GET | `/analytics/dashboard/admin` | Obtener KPIs administrativos (globales). | Admin |
| GET | `/analytics/dashboard/patient` | Obtener KPIs del paciente (progreso, adherencia). | Paciente |
| GET | `/analytics/processes/{patient_id}` | Obtener trayectorias de procesos de un paciente. | Terapeuta/Paciente (propio) |
| GET | `/analytics/predictions/{patient_id}` | Obtener predicciones del sistema (riesgo de abandono, recaída). | Terapeuta |
| GET | `/analytics/research` | Obtener datos anonimizados para investigación (BSC). | Investigador |
| POST | `/analytics/research/export` | Exportar dataset anonimizado (con consentimiento). | Investigador |

### 3.8. Dominio `admin` (Administración del Sistema)

| Método | Endpoint | Descripción | Autenticación |
|--------|----------|-------------|---------------|
| GET | `/admin/users` | Listar usuarios del sistema. | Admin |
| POST | `/admin/users` | Crear un nuevo usuario (admin/terapeuta). | Admin |
| PUT | `/admin/users/{id}` | Actualizar usuario (roles, permisos). | Admin |
| GET | `/admin/tenants` | Listar tenants (organizaciones). | Super Admin |
| POST | `/admin/tenants` | Crear un nuevo tenant (clínica/organización). | Super Admin |
| PUT | `/admin/tenants/{id}` | Actualizar configuración del tenant. | Super Admin |
| GET | `/admin/audit/logs` | Consultar logs de auditoría. | Admin/Super Admin |
| GET | `/admin/health` | Health check del sistema. | Público |
| GET | `/admin/metrics` | Métricas técnicas (Prometheus). | Admin/Super Admin |
| POST | `/admin/feature-flags` | Activar/desactivar feature flags. | Admin |
| GET | `/admin/feature-flags` | Obtener estado de feature flags. | Admin |

### 3.9. Dominio `webhooks` (Webhooks para Integraciones)

| Método | Endpoint | Descripción | Autenticación |
|--------|----------|-------------|---------------|
| POST | `/webhooks/stripe` | Webhook de Stripe (eventos de pago). | Público (verificado con firma) |
| POST | `/webhooks/mercadopago` | Webhook de Mercado Pago. | Público (verificado con firma) |
| POST | `/webhooks/facturapi` | Webhook de Facturapi (estado de factura). | Público (verificado con firma) |
| POST | `/webhooks/google/meet` | Webhook de Google Meet (eventos de videollamada). | Público (verificado con firma) |
| POST | `/webhooks/zoom` | Webhook de Zoom. | Público (verificado con firma) |
| POST | `/webhooks/whatsapp` | Webhook de WhatsApp Business. | Público (verificado con firma) |

---

## 4. WebSockets (Comunicación en Tiempo Real)

### 4.1. Conexión

- **Endpoint**: `wss://api.behavioralos.com/ws`
- **Autenticación**: El cliente debe enviar el token JWT en el parámetro `?token=<jwt>` al establecer la conexión.
- **Heartbeat**: El servidor envía un ping cada 30 segundos. El cliente debe responder con un pong para mantener la conexión activa.

### 4.2. Canales y Eventos

| Canal | Evento | Descripción |
|-------|--------|-------------|
| `chat` | `message.new` | Nuevo mensaje en el chat (paciente ↔ terapeuta). |
| `chat` | `message.read` | Mensaje marcado como leído. |
| `chat` | `message.typing` | Indicador de escritura. |
| `videocall` | `call.start` | Inicio de videollamada. |
| `videocall` | `call.end` | Fin de videollamada. |
| `videocall` | `call.screen_share` | Inicio/fin de compartir pantalla. |
| `hud` | `hud.update` | Actualización del HUD clínico (en videoterapia). |
| `hud` | `hud.process_change` | Cambio en un proceso psicológico (ej. aumento de aceptación). |
| `hud` | `hud.hypothesis` | Nueva hipótesis detectada. |
| `telemetry` | `telemetry.exercise` | Datos de telemetría de ejercicio en tiempo real. |
| `telemetry` | `telemetry.sensor` | Datos de sensores (wearables, si están disponibles). |
| `notifications` | `notification.new` | Nueva notificación (recordatorio, alerta, logro). |
| `twin` | `twin.updated` | El Behavioral Twin del paciente ha sido actualizado. |
| `system` | `system.maintenance` | Aviso de mantenimiento programado. |
| `system` | `system.error` | Error del sistema (para administradores). |

### 4.3. Ejemplo de Mensaje WebSocket

```json
{
  "channel": "chat",
  "event": "message.new",
  "payload": {
    "message_id": "msg_001",
    "sender_id": "user_123",
    "receiver_id": "user_456",
    "content": "Hola, ¿cómo te fue con el ejercicio de ayer?",
    "timestamp": "2026-07-01T14:30:00Z",
    "attachments": []
  },
  "metadata": {
    "tenant_id": "tenant_001",
    "session_id": "session_789"
  }
}

5. Schemas y Modelos (Ejemplos)
5.1. Paciente (Schema)

{
  "id": "pat_001",
  "user_id": "usr_001",
  "therapist_id": "thp_001",
  "tenant_id": "ten_001",
  "first_name": "María",
  "last_name": "González",
  "age": 34,
  "gender": "femenino",
  "status": "activo",
  "created_at": "2026-06-01T10:00:00Z",
  "updated_at": "2026-06-30T15:20:00Z"
}

5.2. Sesión (Schema)

{
  "id": "ses_001",
  "patient_id": "pat_001",
  "therapist_id": "thp_001",
  "start_time": "2026-07-01T10:00:00Z",
  "end_time": "2026-07-01T11:00:00Z",
  "modality": "online",
  "status": "completada",
  "notes": {
    "soap": {
      "subjective": "Paciente reporta disminución de ansiedad...",
      "objective": "Se observa mayor contacto visual...",
      "assessment": "Progreso en aceptación...",
      "plan": "Continuar con ejercicios de defusión..."
    },
    "dap": {
      "data": "...",
      "assessment": "...",
      "plan": "..."
    }
  },
  "created_at": "2026-06-01T10:00:00Z",
  "updated_at": "2026-06-01T11:00:00Z"
}

5.3. Evaluación (Schema)

{
  "id": "eva_001",
  "patient_id": "pat_001",
  "type": "AAQ-II",
  "score": 42,
  "interpretation": {
    "flexibility": 0.35,
    "avoidance": 0.78,
    "confidence": 0.85
  },
  "administered_at": "2026-06-15T09:00:00Z",
  "confidence": 0.90,
  "items": [
    {"item_id": 1, "response": 4, "timestamp": "2026-06-15T09:00:05Z"},
    {"item_id": 2, "response": 3, "timestamp": "2026-06-15T09:00:12Z"}
  ]
}

5.4. Hipótesis Funcional (Schema)

{
  "id": "hyp_001",
  "patient_id": "pat_001",
  "description": "La evitación social se mantiene por reforzamiento negativo (alivio de la ansiedad) y está mediada por marcos de coordinación 'yo = fracaso'.",
  "antecedents": [
    {"type": "SD", "content": "crítica social"}
  ],
  "behavior": {
    "type": "operante",
    "function": "avoidance"
  },
  "consequences": [
    {"type": "reforzamiento_negativo", "value": 0.85}
  ],
  "processes": ["avoidance_experiential", "fusion_cognitiva"],
  "confidence": 0.68,
  "status": "activa",
  "evidence_for": [
    {"source": "AAO", "confidence": 0.82, "date": "2026-06-15"}
  ],
  "evidence_against": [
    {"source": "sesion_4", "confidence": 0.30, "date": "2026-06-10"}
  ],
  "predictions": [
    {"if": "aumentar_aceptacion", "then": "disminuir_evitacion", "expected_effect": 0.5}
  ],
  "created_at": "2026-06-15T14:00:00Z",
  "updated_at": "2026-06-30T10:00:00Z"
}

5.5. Suscripción (Schema)

{
  "id": "sub_001",
  "patient_id": "pat_001",
  "plan_id": "pln_001",
  "status": "activa",
  "start_date": "2026-06-01T00:00:00Z",
  "end_date": "2026-07-01T23:59:59Z",
  "auto_renew": true,
  "price": 700,
  "currency": "MXN",
  "interval": "mensual",
  "features": {
    "sessions_per_month": 4,
    "ai_chat": true,
    "exercises": "all",
    "neuropsychology": false
  }
}

5.6. Factura (Schema)

{
  "id": "inv_001",
  "patient_id": "pat_001",
  "subscription_id": "sub_001",
  "amount": 700,
  "tax": 112,
  "total": 812,
  "currency": "MXN",
  "status": "pagada",
  "cfdi_xml": "<xml>...</xml>",
  "cfdi_pdf": "https://storage.behavioralos.com/invoices/inv_001.pdf",
  "issued_at": "2026-06-01T00:00:00Z",
  "paid_at": "2026-06-01T00:05:00Z"
}

5.7. Mensaje (Schema)

{
  "id": "msg_001",
  "sender_id": "usr_001",
  "receiver_id": "usr_002",
  "content": "Hola, ¿cómo te fue con el ejercicio de ayer?",
  "is_read": false,
  "sent_at": "2026-07-01T14:30:00Z",
  "attachments": [
    {"type": "image", "url": "https://storage...", "name": "captura.png"}
  ]
}

6. Rate Limiting y Seguridad
6.1. Rate Limiting
Endpoint	Límite	Período	Estrategia
/auth/login	5 intentos	15 minutos	Bloqueo temporal.
/auth/register	3 intentos	24 horas	Prevención de spam.
/commerce/*	10 peticiones	1 minuto	Prevención de abuso en pagos.
/clinical/* (GET)	100 peticiones	1 minuto	Consultas de datos.
/clinical/* (POST/PUT)	50 peticiones	1 minuto	Escritura de datos.
/ai/chat	30 mensajes	1 minuto	Control de uso de IA.
/exercises/*	50 peticiones	1 minuto	Control de telemetría.
Público (general)	100 peticiones	1 minuto	Prevención de ataques.
Política de respuesta: Cuando se excede el límite, se devuelve el código 429 Too Many Requests con un header Retry-After: <seconds>.

6.2. Seguridad Adicional
CORS: Configurado para permitir solo orígenes autorizados (dominios de la app).

TLS 1.3: Todas las conexiones usan TLS 1.3 con cifrado fuerte.

Rate Limiting por IP: Se aplica rate limiting por IP para endpoints públicos.

Webhook Verificación: Los webhooks externos (Stripe, Mercado Pago, etc.) se verifican mediante firmas HMAC-SHA256.

Sanitización de Entrada: Todas las entradas se sanitizan para evitar XSS e inyección SQL.

Logs de Seguridad: Todos los intentos de acceso no autorizados se registran en el sistema de auditoría.

7. Documentación OpenAPI 3.0
El BehavioralOS utiliza OpenAPI 3.0 para documentar todas las APIs. La documentación se genera automáticamente a partir de las anotaciones en el código (FastAPI) y se sirve en:

JSON: https://api.behavioralos.com/openapi.json

UI Interactiva (Swagger): https://api.behavioralos.com/docs

UI Alternativa (ReDoc): https://api.behavioralos.com/redoc

7.1. Estructura de la Documentación

openapi: 3.0.0
info:
  title: BehavioralOS API
  description: API del ecosistema BehavioralOS para psicoterapia gamificada.
  version: 1.0.0
  contact:
    name: Soporte BehavioralOS
    email: support@behavioralos.com
servers:
  - url: https://api.behavioralos.com/api/v1
    description: Servidor de producción
  - url: https://staging-api.behavioralos.com/api/v1
    description: Servidor de staging
security:
  - bearerAuth: []
components:
  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT
  schemas:
    Patient:
      type: object
      properties:
        id:
          type: string
          format: uuid
        first_name:
          type: string
        last_name:
          type: string
        age:
          type: integer
        status:
          type: string
          enum: [activo, alta, transferido]
    # ... más schemas
paths:
  /clinical/patients:
    get:
      summary: Listar pacientes
      security:
        - bearerAuth: []
      parameters:
        - name: status
          in: query
          schema:
            type: string
            enum: [activo, alta, transferido]
        - name: therapist_id
          in: query
          schema:
            type: string
            format: uuid
      responses:
        '200':
          description: Lista de pacientes
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/Patient'
    post:
      summary: Crear un nuevo paciente
      security:
        - bearerAuth: []
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/PatientCreate'
      responses:
        '201':
          description: Paciente creado
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Patient'
  # ... más paths

7.2. Estrategia de Versionado en OpenAPI
Cada versión de la API tiene su propio endpoint: /api/v1/..., /api/v2/....

La documentación de cada versión está disponible en: https://api.behavioralos.com/api/v1/docs, https://api.behavioralos.com/api/v2/docs.

Los clientes deben especificar la versión deseada en la URL.

Las versiones antiguas se mantienen durante al menos 12 meses después de la deprecación.

8. Estrategia de Deprecación y Migración
Versión	Estado	Fecha de deprecación	Fecha de desactivación
v1	Activa	N/A	N/A
v2	En desarrollo	TBD	TBD
Política de deprecación:

Anuncio: Se anuncia la deprecación con 6 meses de antelación mediante:

Header Deprecation: true en las respuestas de la API.

Documentación actualizada.

Comunicación a los clientes (email, dashboard).

Migración: Se proporciona una guía de migración con los cambios necesarios.

Desactivación: La versión antigua se desactiva después de 12 meses (o más, según la comunidad).

9. Monitoreo y Observabilidad
Métrica	Herramienta	Propósito
Latencia de API	Prometheus + Grafana	Monitorear tiempos de respuesta por endpoint.
Tasa de error	Prometheus + Grafana	Detectar aumentos en errores 5xx y 4xx.
Tasa de autenticación	Prometheus + Grafana	Detectar intentos de autenticación fallidos.
Uso de rate limiting	Prometheus + Grafana	Monitorear usuarios que exceden límites.
Trazas distribuidas	OpenTelemetry + Jaeger	Rastrear peticiones a través de servicios.
Logs de auditoría	ELK Stack (Elasticsearch, Logstash, Kibana)	Almacenar y consultar logs de seguridad.
10. Criterios de Validación y Cumplimiento
Criterio	Métrica	Herramienta
Documentación completa	100% de endpoints documentados en OpenAPI.	Validación automática en CI/CD.
Versionado	Todas las APIs tienen versión explícita.	Revisión de código.
Autenticación	100% de endpoints (excepto públicos) requieren JWT.	Pruebas de seguridad.
Rate limiting	Todos los endpoints tienen límites definidos.	Pruebas de carga.
Trazabilidad	Cada petición tiene un X-Request-ID y se registra en auditoría.	Auditoría automática.
Seguridad	CORS configurado, TLS 1.3, sanitización de entrada.	Análisis de seguridad (OWASP ZAP).
11. El Manifiesto de las APIs
"Una API no es un simple mecanismo de comunicación. Es un contrato que define cómo los diferentes mundos del BehavioralOS se hablan entre sí.

Una API clara reduce el acoplamiento, acelera el desarrollo y facilita la evolución del sistema.

Una API documentada es una API que se puede mantener y mejorar sin miedo.

Nuestra responsabilidad es ofrecer APIs que sean seguras, consistentes, versionadas y autodescriptivas. Cada endpoint debe ser un punto de encuentro confiable entre el cliente y el sistema."

12. Historial de Cambios
Versión	Fecha	Autor	Cambios
1.0.0	2026-07-01	Arquitectura Backend	Creación del documento. Definición de estructura general, autenticación, versionado, dominios, endpoints, schemas, WebSockets, rate limiting, seguridad y documentación OpenAPI.
1.1.0	2026-08-12	Arquitectura Backend	Añadidos endpoints del change `landing-ia-atencion` (slice 2): `POST /leads` (dominio commerce, SLS-001) y `POST /ai/escalation`, `GET /ai/escalation/{ticket_id}`, `GET /ai/escalation` (dominio ai, AI-007).
Fin del documento api-graph.md