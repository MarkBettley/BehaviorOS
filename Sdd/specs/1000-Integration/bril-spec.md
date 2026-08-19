---
id: BRIL-001
title: Behavioral Runtime Integration Layer (BRIL)
version: 1.0.0
status: Stable
owner: Arquitectura de Integración & DevOps
last_updated: 2026-07-01
depends_on:
  - 000-Core/philosophy.md (Filosofía - desacoplamiento)
  - 100-Architecture/system-architecture.md (BEA - integración)
  - 200-Backend/api-graph.md (API Graph - endpoints)
  - 200-Backend/database-graph.md (Database Graph - persistencia de eventos)
  - 200-Backend/events-and-workflows.md (Eventos - catálogo)
  - 300-Frontend/therapist-app.md (Therapist App - WebSockets)
  - 300-Frontend/patient-app.md (Patient App - WebSockets)
  - 400-AI/adaptive-orchestrator.md (AAO - eventos de evaluación)
  - 400-AI/companion.md (TCCN - eventos de chat)
  - 500-Experiencies/experience-engine.md (BERL - telemetría)
  - 600-Commerce/business-model.md (BCE - webhooks)
  - 700-PracticeOS/practice-os.md (BPOS - eventos de agenda)
  - 800-Analytics/outcomes-analytics.md (BIP - eventos de analítica)
  - 900-Security/security.md (BSOS - autenticación de eventos)
  - 000-Infrastructure/selection.md (Infraestructura - Redis, NATS)
exports:
  - Arquitectura de BRIL (componentes, flujos)
  - Event Bus (Redis Streams / NATS, canales, particionado)
  - Adaptadores de integración (Stripe, Google Calendar, WhatsApp, etc.)
  - Colas de trabajo (BullMQ / Temporal, tareas, prioridades)
  - Sincronización en tiempo real (WebSockets, Server-Sent Events)
  - Monitorización de salud de motores (health checks, circuit breakers)
  - Políticas de reintentos y Dead Letter Queue (DLQ)
  - Trazabilidad de eventos (correlation_id, causation_id)
  - Integración con el ecosistema
  - Criterios de validación y métricas de éxito
used_by:
  - Todos los motores y servicios (publicación y suscripción de eventos)
  - Frontend (comunicación en tiempo real)
  - Admin Dashboard (monitorización)
  - DevOps (health checks, monitoreo)
---

# BehavioralOS – Behavioral Runtime Integration Layer (BRIL)

> *"BRIL no es solo un bus de eventos. Es el sistema nervioso del BehavioralOS. Cada motor, cada servicio, cada frontend se comunica a través de él, sin acoplamientos directos, sin dependencias circulares. BRIL es la garantía de que el ecosistema puede crecer añadiendo nuevos motores sin romper la arquitectura existente."*

---

## 1. Propósito y Alcance

### 1.1. Propósito
Este documento define el **Behavioral Runtime Integration Layer (BRIL)** , el sistema de integración y orquestación en tiempo real del BehavioralOS. Su objetivo es:

- **Desacoplar los motores** (AAO, BERL, TCCN, etc.) mediante comunicación basada en eventos.
- **Orquestar la comunicación** entre servicios, frontends y sistemas externos (Stripe, Google, WhatsApp, etc.).
- **Garantizar la entrega confiable** de eventos con políticas de reintentos, circuit breakers y dead letter queues.
- **Proveer sincronización en tiempo real** con frontends mediante WebSockets y Server-Sent Events (SSE).
- **Monitorear la salud** de todos los motores y servicios para detectar fallos tempranamente.
- **Trazar los eventos** a través del sistema para facilitar la depuración y la auditoría.

### 1.2. Alcance
El documento cubre:

- **Arquitectura de BRIL**: Componentes, flujos de datos, integración con el ecosistema.
- **Event Bus**: Tecnología (Redis Streams / NATS), canales lógicos, particionado por tenant y tipo de evento.
- **Adaptadores de integración**: Conectores para servicios externos (Stripe, Google Calendar, WhatsApp, etc.) con política de fallback y circuit breakers.
- **Colas de trabajo**: Procesamiento asíncrono de tareas (BullMQ / Temporal), prioridades, timeouts, reintentos.
- **Sincronización en tiempo real**: WebSockets para chat y HUD, Server-Sent Events (SSE) para notificaciones y dashboards.
- **Monitorización de salud**: Health checks de cada motor, circuit breakers para integraciones externas, alertas automáticas.
- **Políticas de reintentos y DLQ**: Manejo de fallos en la entrega de eventos, dead letter queue para eventos no procesables.
- **Trazabilidad de eventos**: `correlation_id` y `causation_id` para rastrear flujos completos de eventos.
- **Integración con el ecosistema**: Cómo BRIL se conecta con AAO, BERL, TCCN, BCE, BPOS, BIP, BSC, etc.
- **Criterios de validación**: Métricas de latencia, disponibilidad, resiliencia y escalabilidad.

### 1.3. Principio Fundamental
> **"BRIL no es un simple bus de eventos. Es el sistema nervioso del BehavioralOS. Cada motor, cada servicio, cada frontend se comunica a través de él, sin acoplamientos directos, sin dependencias circulares. BRIL es la garantía de que el ecosistema puede crecer añadiendo nuevos motores sin romper la arquitectura existente."**

---

## 2. Filosofía de BRIL

### 2.1. Principios de Integración

| # | Principio | Descripción | Manifestación |
|---|-----------|-------------|---------------|
| 1 | **Desacoplamiento** | Los motores no se conocen entre sí; solo conocen BRIL. | No hay llamadas directas entre motores; todo pasa por el Event Bus. |
| 2 | **Entrega confiable** | Los eventos no se pierden; se entregan al menos una vez (at-least-once). | Políticas de reintentos, DLQ, y confirmación de entrega (ACK). |
| 3 | **Escalabilidad** | El Event Bus debe escalar horizontalmente. | Redis Streams con particionado por tenant, NATS con clustering. |
| 4 | **Resiliencia** | El sistema debe seguir funcionando en modo degradado si un motor falla. | Circuit breakers, fallbacks, health checks. |
| 5 | **Trazabilidad** | Cada evento es trazable a través del sistema. | `correlation_id`, `causation_id`, logs de auditoría. |
| 6 | **Tiempo real** | La comunicación debe ser casi instantánea cuando sea necesario. | WebSockets para latencia < 100 ms, SSE para notificaciones. |
| 7 | **Observabilidad** | El sistema debe ser fácil de monitorear y depurar. | Métricas de eventos, logs, dashboards de salud. |

### 2.2. Arquitectura de Referencia
┌─────────────────────────────────────────────────────────────────────────┐
│ Behavioral Runtime Integration Layer │
│ (BRIL) │
├─────────────────────────────────────────────────────────────────────────┤
│ │
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ Event Bus (Redis Streams / NATS) │ │
│ │ • Canales: clinical, exercise, commerce, practice, ai, etc. │ │
│ │ • Particionado por tenant │ │
│ └─────────────────────────────────────────────────────────────────┘ │
│ │
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ Integration Adapters │ │
│ │ • Stripe Adapter • Google Calendar Adapter • WhatsApp │ │
│ │ • Mercado Pago Adapter • Facturapi Adapter • Zoom │ │
│ │ • Jitsi Adapter • Twilio Adapter • SendGrid Adapter │ │
│ └─────────────────────────────────────────────────────────────────┘ │
│ │
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ Work Queues (BullMQ / Temporal) │ │
│ │ • Notificaciones • Procesamiento de telemetría │ │
│ │ • Generación de reportes • Workflows de pago │ │
│ └─────────────────────────────────────────────────────────────────┘ │
│ │
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ Real-time Sync (WebSockets / SSE) │ │
│ │ • Chat (paciente ↔ terapeuta) │ │
│ │ • HUD Clínico (videoterapia) │ │
│ │ • Telemetría en tiempo real (ejercicios) │ │
│ │ • Notificaciones y alertas │ │
│ └─────────────────────────────────────────────────────────────────┘ │
│ │
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ Health & Monitoring Engine │ │
│ │ • Health checks de cada motor │ │
│ │ • Circuit breakers para integraciones │ │
│ │ • Métricas (Prometheus) y logs (ELK) │ │
│ └─────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────┘

---

## 3. Event Bus (Redis Streams / NATS)

### 3.1. Tecnología

| Componente | Tecnología | Propósito | Notas (Gratuito) |
|------------|------------|-----------|------------------|
| **Event Bus** | Redis Streams (con Redis 7+) / NATS | Enrutamiento y entrega de eventos. | Redis (gratis), NATS (open source) |
| **Persistencia** | Redis Streams (AOF) / NATS (JetStream) | Almacenamiento persistente de eventos. | Redis AOF (gratis), NATS JetStream (gratis) |
| **Particionado** | Redis Streams (por tenant) / NATS (por subject) | Escalabilidad horizontal. | Gratuito |

### 3.2. Canales Lógicos (Streams)

| Canal | Descripción | Eventos incluidos | Particionado |
|-------|-------------|-------------------|--------------|
| `clinical-stream` | Eventos clínicos (pacientes, sesiones, evaluaciones, hipótesis). | `PATIENT_*`, `SESSION_*`, `ASSESSMENT_*`, `HYPOTHESIS_*`, `BEHAVIORAL_TWIN_*` | Por `tenant_id` |
| `exercise-stream` | Eventos de ejercicios (telemetría, completados, etc.). | `EXERCISE_*`, `MECHANIC_*`, `ACHIEVEMENT_*` | Por `patient_id` |
| `commerce-stream` | Eventos comerciales (suscripciones, pagos, facturas). | `SUBSCRIPTION_*`, `PAYMENT_*`, `INVOICE_*`, `COUPON_*`, `PRODUCT_*` | Por `tenant_id` |
| `practice-stream` | Eventos operacionales (citas, mensajes, informes). | `APPOINTMENT_*`, `MESSAGE_*`, `REPORT_*`, `VIDEOCALL_*` | Por `tenant_id` |
| `ai-stream` | Eventos de IA (chat, RAG, guardrails). | `CHAT_*`, `RAG_*`, `AI_MODEL_*`, `GUARDRAIL_*` | Por `tenant_id` |
| `analytics-stream` | Eventos de análisis (trayectorias, predicciones, KPIs). | `PROCESS_TRAJECTORY_*`, `PREDICTION_*`, `KPI_*`, `RESEARCH_*` | Por `tenant_id` |
| `system-stream` | Eventos de sistema (startup, shutdown, health, errores). | `SYSTEM_*`, `HEALTH_*`, `ERROR_*`, `FEATURE_FLAG_*` | Global |

### 3.3. Estructura de un Evento

```json
{
  "id": "evt_001",
  "event_type": "EXERCISE_COMPLETED",
  "version": "1.0.0",
  "timestamp": "2026-07-01T14:30:00Z",
  "source": "PatientApp-Godot",
  "correlation_id": "corr_001",
  "causation_id": "evt_000",
  "tenant_id": "ten_001",
  "patient_id": "pat_001",
  "session_id": "ses_001",
  "payload": {
    "exercise_id": "exc_001",
    "duration": 120,
    "score": 85,
    "difficulty_level": 3,
    "telemetry_summary": {
      "latency_avg": 350,
      "errors": 2,
      "retries": 1
    }
  },
  "metadata": {
    "user_id": "usr_001",
    "ip": "192.168.1.1",
    "user_agent": "Mozilla/5.0"
  },
  "signature": "sha256_hash"
}

3.4. Publicación y Suscripción
Publicación (desde un motor):

# Ejemplo de publicación desde BERL
from bril import EventBus

event = {
    "event_type": "EXERCISE_COMPLETED",
    "tenant_id": "ten_001",
    "patient_id": "pat_001",
    "payload": {...}
}

event_bus = EventBus()
event_bus.publish(
    channel="exercise-stream",
    event=event,
    key=event["tenant_id"]  # particionado por tenant
)

Suscripción (desde un motor):

# Ejemplo de suscripción desde AAO
from bril import EventBus

def handle_exercise_completed(event):
    # Procesar el evento: actualizar Behavioral Twin, evaluar procesos, etc.
    update_behavioral_twin(event["patient_id"], event["payload"]["exercise_id"])

event_bus = EventBus()
event_bus.subscribe(
    channel="exercise-stream",
    event_type="EXERCISE_COMPLETED",
    handler=handle_exercise_completed,
    consumer_group="aao-consumers"
)

3.5. Particionado y Escalabilidad
Particionado por tenant: Cada tenant tiene su propio stream (o partición) para aislar datos y garantizar rendimiento.

Particionado por tipo de evento: Eventos de alta frecuencia (telemetría) se particionan por paciente para evitar cuellos de botella.

Escalabilidad: Redis Streams con MAXLEN para limitar el tamaño del stream; NATS con clustering para alta disponibilidad.

4. Adaptadores de Integración
4.1. Propósito
Los adaptadores conectan BRIL con servicios externos, traduciendo las APIs externas al formato de eventos de BRIL y viceversa. Cada adaptador tiene:

Configuración: Credenciales, URLs, timeouts.

Política de reintentos: Número de intentos y backoff.

Circuit breaker: Fallos consecutivos → apertura del circuito.

Fallback: Respuesta de respaldo en caso de fallo.

4.2. Lista de Adaptadores
Adaptador	Servicio externo	Propósito	Configuración
Stripe Adapter	Stripe API	Procesar pagos, suscripciones, webhooks.	Stripe Secret Key, Webhook Secret.
Mercado Pago Adapter	Mercado Pago API	Procesar pagos locales (México/Latam).	Mercado Pago Access Token.
Facturapi Adapter	Facturapi API	Generación de facturas CFDI 4.0.	Facturapi API Key.
Google Calendar Adapter	Google Calendar API	Sincronización de citas.	OAuth2 credentials.
Outlook Adapter	Microsoft Graph API	Sincronización de citas con Outlook.	OAuth2 credentials.
Google Meet Adapter	Google Meet API	Generación de enlaces de videollamada.	OAuth2 credentials.
Zoom Adapter	Zoom API	Generación de enlaces de videollamada (Zoom).	Zoom API Key, JWT.
Jitsi Adapter	Jitsi (self-hosted)	Videollamada open source.	URL del servidor Jitsi.
WhatsApp Adapter	WhatsApp Business API	Envío de mensajes y recordatorios.	WhatsApp Business API Key.
Twilio Adapter	Twilio API	Envío de SMS y notificaciones.	Twilio Account SID, Auth Token.
SendGrid Adapter	SendGrid API	Envío de correos electrónicos transaccionales.	SendGrid API Key.
Resend Adapter	Resend API	Envío de correos electrónicos transaccionales.	Resend API Key.
4.3. Política de Reintentos y Circuit Breaker
Adaptador	Reintentos	Backoff	Circuit Breaker
Stripe	3 intentos	Exponencial (1s, 2s, 4s)	5 fallos en 1 minuto
Mercado Pago	3 intentos	Exponencial (1s, 2s, 4s)	5 fallos en 1 minuto
Facturapi	3 intentos	Exponencial (2s, 4s, 8s)	5 fallos en 1 minuto
Google Calendar	3 intentos	Exponencial (1s, 2s, 4s)	5 fallos en 1 minuto
WhatsApp	2 intentos	Exponencial (2s, 4s)	5 fallos en 1 minuto
Twilio	2 intentos	Exponencial (2s, 4s)	5 fallos en 1 minuto
SendGrid	2 intentos	Exponencial (2s, 4s)	5 fallos en 1 minuto

4.4. Ejemplo de Adaptador (Stripe)

python
# bril/adapters/stripe_adapter.py
import stripe
from bril import Adapter

class StripeAdapter(Adapter):
    def __init__(self, config):
        self.config = config
        stripe.api_key = config["secret_key"]

    def create_subscription(self, patient_id, plan_id, payment_method):
        try:
            subscription = stripe.Subscription.create(
                customer=patient_id,
                items=[{"price": plan_id}],
                default_payment_method=payment_method,
                expand=["latest_invoice.payment_intent"]
            )
            return subscription
        except stripe.error.StripeError as e:
            self.log_error(e)
            raise

    def handle_webhook(self, payload, signature):
        try:
            event = stripe.Webhook.construct_event(
                payload, signature, self.config["webhook_secret"]
            )
            return event
        except stripe.error.SignatureVerificationError as e:
            self.log_error(e)
            raise


5. Colas de Trabajo (BullMQ / Temporal)
5.1. Propósito
Las colas de trabajo permiten el procesamiento asíncrono de tareas que no requieren respuesta inmediata, como notificaciones, generación de reportes, procesamiento de telemetría por lotes, y workflows largos (como pagos y onboarding).

5.2. Tecnología
Componente	Tecnología	Propósito	Notas (Gratuito)
Colas de trabajo	BullMQ (basado en Redis)	Procesamiento asíncrono de tareas cortas.	Redis (gratis)
Workflows largos	Temporal.io	Orquestación de workflows con Sagas.	Temporal (open source)
5.3. Tipos de Tareas
Cola	Descripción	Prioridad	Ejemplos
Notificaciones	Envío de correos, push, SMS.	Alta	Recordatorios de citas, confirmaciones de pago.
Telemetría	Procesamiento de telemetría de ejercicios.	Media	Actualización de Behavioral Twin, generación de KPIs.
Reportes	Generación de reportes (FBR, informes, etc.).	Baja	Informes de progreso, facturas.
Workflows	Procesos largos y transaccionales (Sagas).	Alta	Onboarding, pago + facturación, reactivación.

5.4. Ejemplo de Cola de Trabajo (BullMQ)

Python

# bril/queues/notification_queue.py
from bullmq import Queue, Worker

# Definir la cola
notification_queue = Queue("notifications", connection=redis_connection)

# Añadir tarea a la cola
async def send_notification(user_id, message, channel):
    await notification_queue.add(
        "send_notification",
        {"user_id": user_id, "message": message, "channel": channel},
        {
            "attempts": 3,
            "backoff": {"type": "exponential", "delay": 2000},
            "removeOnComplete": True,
            "removeOnFail": False
        }
    )

# Worker para procesar tareas
worker = Worker("notifications", async (job) => {
    const { user_id, message, channel } = job.data;
    await send_email(user_id, message); // o push, SMS
}, { connection: redis_connection });


6. Sincronización en Tiempo Real (WebSockets / SSE)
6.1. Propósito
La sincronización en tiempo real permite la comunicación instantánea entre el backend y los frontends, así como entre usuarios (paciente ↔ terapeuta).

6.2. Tecnología
Componente	Tecnología	Propósito	Notas (Gratuito)
WebSockets	Socket.IO / WS	Comunicación bidireccional en tiempo real.	Socket.IO (open source)
Server-Sent Events (SSE)	EventSource API	Notificaciones unidireccionales (servidor → cliente).	Nativo (gratis)
6.3. Canales y Eventos en Tiempo Real
Canal	Evento	Descripción
chat	message.new	Nuevo mensaje en el chat (paciente ↔ terapeuta).
chat	message.read	Mensaje marcado como leído.
chat	message.typing	Indicador de escritura.
videocall	call.start	Inicio de videollamada.
videocall	call.end	Fin de videollamada.
videocall	call.screen_share	Inicio/fin de compartir pantalla.
hud	hud.update	Actualización del HUD clínico (procesos, CRB).
hud	hud.process_change	Cambio en un proceso psicológico.
telemetry	telemetry.exercise	Datos de telemetría de ejercicio en tiempo real.
notifications	notification.new	Nueva notificación (recordatorio, alerta, logro).
twin	twin.updated	El Behavioral Twin ha sido actualizado.
system	system.maintenance	Aviso de mantenimiento programado.

6.4. Ejemplo de WebSocket (Socket.IO)

// Frontend (Patient App)
const socket = io('https://api.behavioralos.com');

socket.on('connect', () => {
    console.log('Conectado a BRIL');
});

// Enviar mensaje de chat
socket.emit('message.send', {
    channel: 'chat',
    event: 'message.new',
    payload: {
        patient_id: 'pat_001',
        therapist_id: 'thp_001',
        message: 'Hola, doctor.'
    }
});

// Recibir mensajes de chat
socket.on('chat', (data) => {
    if (data.event === 'message.new') {
        appendMessage(data.payload);
    }
});

7. Monitorización de Salud
7.1. Health Checks
Endpoint: /health para cada servicio y motor.

Frecuencia: Cada 30 segundos (para servicios críticos, cada 10 segundos).

Contenido: Estado del servicio, latencia, dependencias (base de datos, caché, etc.).

Ejemplo de respuesta de health check:

{
  "status": "healthy",
  "service": "bril",
  "version": "1.0.0",
  "timestamp": "2026-07-01T14:30:00Z",
  "dependencies": {
    "redis": {
      "status": "healthy",
      "latency": 5
    },
    "supabase": {
      "status": "healthy",
      "latency": 12
    }
  }
}


7.2. Circuit Breakers
Propósito: Evitar que fallos en servicios externos o motores saturen el sistema.

Implementación: Patrón de circuit breaker para cada adaptador y cada suscriptor de eventos.

Configuración: 5 fallos consecutivos en 1 minuto → circuito abierto → espera de 30 segundos → medio abierto → prueba.

7.3. Métricas y Alertas
Métrica	Herramienta	Umbral de alerta
Latencia del Event Bus	Prometheus + Grafana	> 100 ms (p99)
Tasa de errores en adaptadores	Prometheus + Grafana	> 5% en 5 minutos
Tamaño de colas (BullMQ)	Prometheus + Grafana	> 1000 tareas pendientes
Health checks fallidos	Prometheus + Grafana	2 fallos consecutivos
Circuit breakers abiertos	Prometheus + Grafana	> 1 circuito abierto
8. Políticas de Reintentos y Dead Letter Queue (DLQ)
8.1. Política de Reintentos
Tipo de evento	Reintentos	Backoff	Motivo de fallo
Eventos críticos (pagos, clínicos)	5 intentos	Exponencial (100ms, 200ms, 400ms, 800ms, 1600ms)	Cualquier error
Eventos de telemetría	3 intentos	Exponencial (100ms, 200ms, 400ms)	Cualquier error
Notificaciones	3 intentos	Exponencial (200ms, 400ms, 800ms)	Cualquier error
8.2. Dead Letter Queue (DLQ)
Propósito: Almacenar eventos que no se pudieron procesar después de todos los reintentos.

Almacenamiento: Canal dlq-stream en Redis Streams (o tabla en PostgreSQL para mayor persistencia).

Contenido: Evento original + metadatos de error (motivo, timestamp, número de intentos).

Gestión: Los eventos en DLQ se revisan manualmente por el equipo de operaciones; se pueden reprocesar (reintentar) o archivar.

Estructura de un evento en DLQ:

{
  "original_event": { ... },
  "error": {
    "message": "Connection timeout",
    "timestamp": "2026-07-01T14:30:00Z",
    "attempts": 5
  }
}

9. Trazabilidad de Eventos
9.1. Metadata de Trazabilidad
Campo	Descripción	Obligatorio
id	ID único del evento (UUID).	Sí
correlation_id	ID para correlacionar eventos de un mismo flujo (ej. una transacción).	Recomendado
causation_id	ID del evento que causó este (para trazabilidad de causa-efecto).	Opcional
source	Origen del evento (ej. "AAO", "BERL", "PatientApp").	Sí
timestamp	Fecha y hora en que se generó el evento.	Sí
9.2. Trazabilidad en la Práctica
Ejemplo de flujo trazable:

El paciente completa un ejercicio → Evento EXERCISE_COMPLETED con correlation_id = "corr_001".

AAO recibe el evento → Genera un nuevo evento ASSESSMENT_UPDATED con causation_id = "EXERCISE_COMPLETED" y correlation_id = "corr_001".

BSC recibe el evento → Genera un nuevo evento TRAJECTORY_UPDATED con causation_id = "ASSESSMENT_UPDATED" y correlation_id = "corr_001".

Consulta de trazabilidad:

SELECT * FROM audit_logs WHERE correlation_id = 'corr_001' ORDER BY timestamp;

10. Integración con el Ecosistema
10.1. AAO (Evaluación Adaptativa)
Publica: ASSESSMENT_COMPLETED, ASSESSMENT_ITEM_RESPONDED.

Suscribe: EXERCISE_COMPLETED, SESSION_COMPLETED, CHAT_MESSAGE_SENT.

10.2. BERL (Ejercicios)
Publica: EXERCISE_STARTED, EXERCISE_COMPLETED, EXERCISE_ABANDONED, EXERCISE_TELEMETRY.

Suscribe: EXERCISE_ADAPTED (desde AHEE).

10.3. TCCN (Compañero)
Publica: CHAT_MESSAGE_SENT, CHAT_RESPONSE_GENERATED.

Suscribe: EXERCISE_COMPLETED, SESSION_COMPLETED.

10.4. BCE (Comercio)
Publica: PAYMENT_SUCCEEDED, PAYMENT_FAILED, SUBSCRIPTION_CREATED, SUBSCRIPTION_CANCELED.

Suscribe: Webhooks externos (Stripe, Mercado Pago, Facturapi).

10.5. BPOS (Práctica Clínica)
Publica: APPOINTMENT_CREATED, APPOINTMENT_UPDATED, SESSION_STARTED, SESSION_COMPLETED.

Suscribe: SUBSCRIPTION_ACTIVATED (desde BCE).

10.6. BIP (Analítica)
Publica: KPI_UPDATED, PREDICTION_GENERATED.

Suscribe: Todos los eventos que generan datos (EXERCISE_, SESSION_, PAYMENT_*, etc.).

10.7. BSC (Ciencia)
Publica: RESEARCH_DATA_EXPORTED.

Suscribe: Eventos anonimizados para investigación.

11. Criterios de Validación y Cumplimiento
Criterio	Métrica	Herramienta
Latencia del Event Bus	< 50 ms (p99) para enrutamiento de eventos.	Monitoreo de rendimiento
Disponibilidad de BRIL	99.9% de uptime (excluyendo mantenimiento programado).	Monitoreo de uptime
Tasa de entrega de eventos	> 99.9% de eventos entregados al menos una vez.	Auditoría de eventos
Tiempo de procesamiento de colas	< 5 segundos para colas de alta prioridad, < 1 minuto para baja prioridad.	Monitoreo de colas
Tiempo de respuesta de WebSockets	< 100 ms para mensajes de chat.	Monitoreo de rendimiento
Recuperación de fallos	El sistema se recupera automáticamente de fallos de motores en < 60 segundos.	Chaos engineering
Trazabilidad	100% de los eventos tienen correlation_id.	Auditoría automática
12. El Manifiesto de BRIL
"BRIL no es un simple bus de eventos. Es el sistema nervioso del BehavioralOS.

Cada motor, cada servicio, cada frontend se comunica a través de él, sin acoplamientos directos, sin dependencias circulares.

BRIL es la garantía de que el ecosistema puede crecer añadiendo nuevos motores sin romper la arquitectura existente.

Cada evento es una promesa de que la información fluirá, que los datos llegarán a su destino, y que el sistema seguirá funcionando incluso si algo falla.

Nuestra responsabilidad es garantizar que BRIL sea rápido, confiable, escalable y observable. Que los eventos nunca se pierdan, que las colas nunca se atasquen, y que cada motor pueda comunicarse con los demás sin esfuerzo."

13. Historial de Cambios
Versión	Fecha	Autor	Cambios
1.0.0	2026-07-01	Arquitectura de Integración	Creación del documento. Definición de BRIL: Event Bus, adaptadores, colas de trabajo, sincronización en tiempo real, monitorización, políticas de reintentos y DLQ, trazabilidad de eventos e integración con el ecosistema.

Fin del documento bril-spec.md
