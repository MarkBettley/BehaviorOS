---
id: EVT-001
title: Eventos y Workflows – Comunicación Asíncrona
version: 1.0.0
status: Stable
owner: Backend & Arquitectura de Software
last_updated: 2026-07-01
depends_on:
  - 000-Core (Ontología, Principios)
  - 100-Architecture/system-architecture.md (BEA)
  - 100-Architecture/engines-overview.md (BREO)
  - 100-Architecture/data-model.md (Modelo de Datos)
  - 200-Backend/api-graph.md (API Graph)
  - 200-Backend/database-graph.md (Database Graph)
exports:
  - Catálogo completo de eventos del sistema
  - Especificación del Event Bus (Redis Streams / NATS)
  - Patrones de publicación/suscripción y entrega
  - Definición de workflows largos (Temporal.io)
  - Sagas y compensaciones para transacciones distribuidas
  - Políticas de reintentos, circuit breakers y dead letter queues
  - Estrategias de idempotencia y consistencia eventual
used_by:
  - BRIL (Behavioral Runtime Integration Layer)
  - Todos los motores (AAO, BERL, TCCN, AHEE, MPO, BSC, BCE, BPOS, etc.)
  - BQAS (Pruebas de integración y resiliencia)
  - CI/CD (Despliegue y monitoreo)
---

# BehavioralOS – Eventos y Workflows

> *"Un sistema basado en eventos no es solo una arquitectura técnica. Es una filosofía de diseño donde cada acción genera una reacción, cada cambio se propaga y cada proceso largo se orquesta con precisión. Los eventos son el lenguaje en el que los motores del BehavioralOS se comunican entre sí sin acoplarse."*

---

## 1. Propósito y Alcance

### 1.1. Propósito
Este documento define el **sistema de comunicación asíncrona** del BehavioralOS. Su objetivo es:

- **Establecer un catálogo de eventos** que representan todas las acciones y cambios de estado significativos en el ecosistema.
- **Especificar el Event Bus** (Redis Streams / NATS) que orquesta la publicación y suscripción de eventos.
- **Definir workflows largos** (Temporal.io) para procesos de negocio complejos (pagos, onboarding, seguimiento, etc.).
- **Implementar Sagas y compensaciones** para garantizar la consistencia en transacciones distribuidas.
- **Establecer políticas de resiliencia**: reintentos, circuit breakers, dead letter queues y retrasos exponenciales.
- **Garantizar la idempotencia** y la entrega confiable de eventos.

### 1.2. Alcance
El sistema de eventos y workflows cubre:

- **Eventos del sistema**: Todos los eventos que pueden ocurrir en el BehavioralOS, organizados por dominio.
- **Event Bus**: Infraestructura de mensajería (Redis Streams / NATS) con canales lógicos.
- **Workflows largos**: Procesos orquestados con Temporal.io (ej. compra, facturación, onboarding).
- **Sagas y compensaciones**: Mecanismos para manejar fallos en transacciones distribuidas.
- **Resiliencia**: Políticas de reintentos, circuit breakers, dead letter queues y retrasos exponenciales.
- **Idempotencia**: Estrategias para garantizar que los eventos se procesen una sola vez.
- **Observabilidad**: Métricas, trazabilidad y logs de eventos.

### 1.3. Principio Fundamental
> **"Un evento no es solo un mensaje. Es una promesa de que algo ha ocurrido en el sistema. Cada evento debe ser trazable, idempotente y procesable de forma asíncrona. El sistema debe ser resiliente a fallos: si un motor falla, el evento debe poder reprocesarse sin duplicar efectos."**

---

## 2. Filosofía de la Arquitectura de Eventos

### 2.1. Principios de Diseño

| # | Principio | Descripción | Criterio de cumplimiento |
|---|-----------|-------------|---------------------------|
| 1 | **Event-Driven First** | La comunicación entre motores es principalmente asíncrona mediante eventos. | Ningún motor llama directamente a otro; todo pasa por el Event Bus. |
| 2 | **Idempotencia** | Cada evento debe poder procesarse múltiples veces sin efectos secundarios. | Cada evento tiene un `idempotency_key` (UUID v7). Los handlers verifican si el evento ya fue procesado. |
| 3 | **Entrega confiable** | Los eventos no se pierden. Si un suscriptor falla, el evento se reintenta o se envía a DLQ. | Políticas de reintentos con backoff exponencial y Dead Letter Queue (DLQ). |
| 4 | **Desacoplamiento** | Los publicadores no conocen a los suscriptores. | El Event Bus maneja el enrutamiento; los suscriptores se registran en canales. |
| 5 | **Trazabilidad** | Cada evento tiene metadatos de origen (quién, cuándo, qué versión). | Campos `source`, `correlation_id`, `causation_id`, `timestamp`, `version`. |
| 6 | **Consistencia eventual** | El sistema tolera consistencia eventual entre motores. | Las actualizaciones del Behavioral Twin pueden tener latencia de < 1 s. |
| 7 | **Escalabilidad** | El Event Bus debe escalar horizontalmente. | Redis Streams / NATS con particionado por tenant o tipo de evento. |
| 8 | **Seguridad** | Los eventos contienen información sensible; deben estar cifrados en tránsito. | TLS 1.3 y autenticación de productores/suscriptores. |

### 2.2. Flujo de Eventos Típico

1. **Un motor publica un evento** (ej. `EXERCISE_COMPLETED`) en el Event Bus a través de BRIL.
2. **El Event Bus recibe el evento**, lo valida (schema, formato) y lo enruta a los canales correspondientes.
3. **Los suscriptores registrados** (ej. AAO, BSC, BPOS) reciben el evento y lo procesan de forma asíncrona.
4. **Cada suscriptor actualiza su estado** (ej. AAO actualiza el Behavioral Twin, BSC registra la telemetría, BPOS actualiza el dashboard del paciente).
5. **Si un suscriptor falla**, el sistema reintenta según la política (ej. backoff exponencial) o envía a DLQ.
6. **Se registra la traza** del evento para auditoría y monitoreo.

---

## 3. Catálogo de Eventos

Los eventos se organizan por **dominio** (clinical, commerce, practice, exercises, ai, analytics, system) y se clasifican en **eventos de estado** (notifican un cambio) y **eventos de comando** (solicitan una acción).

### 3.1. Dominio `clinical` (Eventos Clínicos)

| Evento | Descripción | Publicado por | Suscriptores |
|--------|-------------|---------------|--------------|
| `PATIENT_REGISTERED` | Nuevo paciente registrado en el sistema. | BPOS (onboarding) | AAO, BSC, BCE, BPOS (CRM) |
| `PATIENT_UPDATED` | Datos del paciente actualizados (perfil, terapeuta, etc.). | BPOS, API | AAO, BSC, Behavioral Twin |
| `PATIENT_DISCHARGED` | Paciente dado de alta (modo mantenimiento). | BPOS (terapeuta) | AAO, BSC, TCCN, AHEE |
| `SESSION_CREATED` | Nueva sesión programada. | BPOS (agenda) | AAO, BSC, Analytics |
| `SESSION_STARTED` | Sesión iniciada (videoterapia). | BPOS (videoterapia) | AAO, TCCN, HUD Engine |
| `SESSION_COMPLETED` | Sesión finalizada y notas guardadas. | BPOS | AAO, BSC, Behavioral Twin, Analytics, TCCN |
| `SESSION_CANCELLED` | Sesión cancelada. | BPOS | AAO, Analytics |
| `ASSESSMENT_COMPLETED` | Evaluación (AAO) completada. | AAO | BSC, Behavioral Twin, MPO, BPOS |
| `ASSESSMENT_ITEM_RESPONDED` | Respuesta a un ítem de evaluación (para evaluaciones adaptativas). | AAO | AAO (siguiente ítem), Behavioral Twin |
| `HYPOTHESIS_CREATED` | Nueva hipótesis funcional generada. | AAO, Terapeuta | Behavioral Twin, MPO, TCCN, BSC |
| `HYPOTHESIS_UPDATED` | Hipótesis actualizada (confianza, estado). | AAO, Terapeuta | Behavioral Twin, MPO, TCCN |
| `HYPOTHESIS_CONFIRMED` | Hipótesis confirmada con alta confianza. | AAO, Terapeuta | Behavioral Twin, MPO, BSC (investigación) |
| `VALUE_UPDATED` | Valor (ACT) actualizado. | Terapeuta, Paciente | Behavioral Twin, AHEE, TCCN |
| `GOAL_UPDATED` | Objetivo terapéutico actualizado. | Terapeuta, Paciente | Behavioral Twin, MPO, AHEE |
| `BEHAVIORAL_TWIN_UPDATED` | El Behavioral Twin ha sido actualizado. | AAO, BERL, TCCN, etc. | MPO, AHEE, BSC, BPOS (dashboard) |

### 3.2. Dominio `exercises` (Eventos de Ejercicios)

| Evento | Descripción | Publicado por | Suscriptores |
|--------|-------------|---------------|--------------|
| `EXERCISE_STARTED` | Paciente inicia un ejercicio (minijuego). | Patient App (Godot) | AAO, BERL, Analytics |
| `EXERCISE_COMPLETED` | Ejercicio finalizado con éxito. | Patient App (Godot) | AAO, BERL, BSC, Behavioral Twin, Analytics, MPO, AHEE |
| `EXERCISE_ABANDONED` | Ejercicio abandonado antes de completar. | Patient App (Godot) | AAO, BERL, Behavioral Twin, Analytics |
| `EXERCISE_TELEMETRY` | Datos de telemetría en tiempo real (durante el ejercicio). | Godot (vía BRIL) | AAO, BERL, BSC, Analytics |
| `EXERCISE_ADAPTED` | Ejercicio adaptado automáticamente (dificultad, narrativa). | AHEE, BERL | AAO, Behavioral Twin, Analytics |
| `MECHANIC_UNLOCKED` | Nueva mecánica de juego desbloqueada (gamificación). | BERL | AHEE, Patient App (inventario) |
| `ACHIEVEMENT_UNLOCKED` | Logro desbloqueado (ej. "10 ejercicios completados"). | BERL | AHEE, Patient App (gamificación) |

### 3.3. Dominio `commerce` (Eventos Comerciales)

| Evento | Descripción | Publicado por | Suscriptores |
|--------|-------------|---------------|--------------|
| `SUBSCRIPTION_CREATED` | Nueva suscripción iniciada (pago pendiente). | BCE (checkout) | BPOS (CRM), Analytics |
| `SUBSCRIPTION_ACTIVATED` | Suscripción activada (primer pago exitoso). | BCE (Stripe/MercadoPago webhook) | BPOS (activar servicios), AAO (evaluación inicial), Patient App, Analytics |
| `SUBSCRIPTION_RENEWED` | Suscripción renovada automáticamente. | BCE (Stripe/MercadoPago webhook) | BPOS, Analytics |
| `SUBSCRIPTION_CANCELED` | Suscripción cancelada (por usuario). | BCE (API) | BPOS (CRM), Analytics, TCCN (mensaje de despedida) |
| `SUBSCRIPTION_EXPIRED` | Suscripción expirada (sin renovación). | BCE (sistema) | BPOS (limitar acceso), Analytics |
| `PAYMENT_SUCCEEDED` | Pago completado con éxito. | BCE (Stripe/MercadoPago webhook) | BPOS (facturación), Analytics |
| `PAYMENT_FAILED` | Pago fallido (tarjeta rechazada, etc.). | BCE (webhook) | BPOS (notificar al paciente), TCCN (mensaje de soporte) |
| `INVOICE_ISSUED` | Factura emitida (CFDI generada). | BCE (Facturapi) | BPOS (enviar al paciente), Analytics |
| `INVOICE_PAID` | Factura pagada. | BCE | BPOS (actualizar estado), Analytics |
| `COUPON_REDEEMED` | Cupón de descuento utilizado. | BCE (checkout) | Analytics (seguimiento de promociones) |
| `PRODUCT_PURCHASED` | Producto digital comprado (marketplace). | BCE | BPOS (entregar producto), Analytics |

### 3.4. Dominio `ai` (Eventos de IA)

| Evento | Descripción | Publicado por | Suscriptores |
|--------|-------------|---------------|--------------|
| `CHAT_MESSAGE_SENT` | Mensaje enviado al TCCN (compañero). | Patient App, Therapist App | TCCN (procesar), AAO (análisis), BSC (investigación) |
| `CHAT_RESPONSE_GENERATED` | Respuesta del TCCN generada y enviada. | TCCN | Patient App, Therapist App, Behavioral Twin, Analytics |
| `RAG_QUERY_EXECUTED` | Consulta RAG ejecutada (búsqueda semántica). | TCCN, Terapeuta | BSC (registro de consulta), Analytics |
| `AI_MODEL_INFERRED` | Inferencia de IA realizada (Gemma, etc.). | AI Engine | AAO, TCCN, Behavioral Twin, Analytics |
| `GUARDRAIL_TRIGGERED` | Guardrail activado (prompt bloqueado por razones clínicas o éticas). | AI Engine (guardrails) | BCGS (auditoría), BPOS (notificar terapeuta) |

### 3.5. Dominio `practice` (Eventos Operacionales)

| Evento | Descripción | Publicado por | Suscriptores |
|--------|-------------|---------------|--------------|
| `APPOINTMENT_CREATED` | Nueva cita programada. | BPOS (agenda) | Analytics, Notificaciones |
| `APPOINTMENT_UPDATED` | Cita modificada (fecha, hora, modalidad). | BPOS | Analytics, Notificaciones |
| `APPOINTMENT_CANCELLED` | Cita cancelada. | BPOS | Analytics, Notificaciones, TCCN (mensaje) |
| `MESSAGE_SENT` | Mensaje enviado en el chat (paciente ↔ terapeuta). | BPOS (chat) | TCCN, Analytics, Notificaciones |
| `MESSAGE_READ` | Mensaje marcado como leído. | BPOS | Notificaciones, Analytics |
| `REPORT_GENERATED` | Informe clínico generado (ej. FBR). | BPOS | Analytics, Storage (PDF), Notificaciones |
| `REPORT_SIGNED` | Informe firmado por el terapeuta. | BPOS | Storage (versión final), Analytics |
| `VIDEOCALL_STARTED` | Videollamada iniciada. | BPOS (videoterapia) | TCCN, AAO, HUD Engine |
| `VIDEOCALL_ENDED` | Videollamada finalizada. | BPOS | AAO (resumen), Analytics, Storage (grabación, si existe) |

### 3.6. Dominio `analytics` (Eventos de Análisis)

| Evento | Descripción | Publicado por | Suscriptores |
|--------|-------------|---------------|--------------|
| `PROCESS_TRAJECTORY_UPDATED` | Nueva medición de un proceso psicológico agregada. | AAO, BERL | BIP (dashboards), BSC (investigación) |
| `PREDICTION_GENERATED` | Nueva predicción (ej. riesgo de abandono) generada. | BWM, BIP | BPOS (alertas), AAO, TCCN |
| `KPI_UPDATED` | KPIs diarios actualizados (tenant, terapeuta). | Analytics Engine (job programado) | BPOS (dashboard), Admin Dashboard |
| `RESEARCH_DATA_EXPORTED` | Datos anonimizados exportados para investigación (BSC). | BSC | Research Storage |

### 3.7. Dominio `system` (Eventos de Sistema)

| Evento | Descripción | Publicado por | Suscriptores |
|--------|-------------|---------------|--------------|
| `SYSTEM_STARTUP` | Sistema iniciado (después de despliegue). | BOS | Todos los motores (recargar configuración) |
| `SYSTEM_SHUTDOWN` | Sistema apagado (mantenimiento). | BOS | Todos los motores (guardar estado) |
| `HEALTH_CHECK_OK` | Health check de un motor exitoso. | Motor correspondiente | BRIL, Monitoreo (Prometheus) |
| `HEALTH_CHECK_FAIL` | Health check de un motor fallido. | Motor correspondiente | BRIL (modo degradado), Monitoreo (alerta) |
| `ERROR_OCCURRED` | Error crítico en un motor (no recuperable). | Motor correspondiente | BRIL (DLQ), Monitoreo (alerta) |
| `FEATURE_FLAG_CHANGED` | Feature flag activada/desactivada. | Admin Panel | Todos los motores (reaccionar) |

### 3.8. Estructura del Evento (Schema)

Todos los eventos comparten una estructura común para garantizar trazabilidad y consistencia.

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
  "payload": {
    "patient_id": "pat_001",
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
    "session_id": "ses_001",
    "ip": "192.168.1.1",
    "user_agent": "Mozilla/5.0 ..."
  },
  "signature": "sha256_hash"
}

Campo	Descripción	Obligatorio
id	UUID del evento (generado por el publicador).	Sí
event_type	Tipo de evento (ej. "EXERCISE_COMPLETED").	Sí
version	Versión del schema del evento (semver).	Sí
timestamp	Fecha y hora en que se generó el evento (ISO 8601).	Sí
source	Origen del evento (ej. "AAO", "BERL", "PatientApp").	Sí
correlation_id	ID para correlacionar eventos de un mismo flujo (ej. una transacción).	Recomendado
causation_id	ID del evento que causó este (para trazabilidad de causa-efecto).	Opcional
tenant_id	ID del tenant (organización).	Sí
payload	Datos específicos del evento (depende del tipo).	Sí
metadata	Información adicional (usuario, sesión, IP, etc.).	Opcional
signature	Firma HMAC del contenido para verificar integridad.	Recomendado
4. Event Bus (Infraestructura de Mensajería)
4.1. Tecnología
El BehavioralOS utiliza Redis Streams como Event Bus principal, con soporte para NATS como alternativa para alta disponibilidad y escalabilidad.

Componente	Tecnología	Propósito
Event Bus	Redis Streams (con Redis 7+) / NATS	Enrutamiento y entrega de eventos.
Colas de trabajo	Redis Streams / BullMQ	Procesamiento asíncrono de tareas (notificaciones, correos, etc.).
Workflows	Temporal.io	Orquestación de procesos largos (pagos, onboarding, etc.).
Monitoreo	Prometheus + Grafana	Métricas de eventos (tasa, latencia, errores).
Logs	ELK Stack (Elasticsearch, Logstash, Kibana)	Logs de eventos para auditoría.
4.2. Canales Lógicos (Streams)
Los eventos se organizan en canales lógicos (streams) para facilitar la suscripción y el particionado.

Canal	Descripción	Eventos incluidos	Particionado
clinical-stream	Eventos clínicos (pacientes, sesiones, evaluaciones, hipótesis).	PATIENT_*, SESSION_*, ASSESSMENT_*, HYPOTHESIS_*, VALUE_*, GOAL_*, BEHAVIORAL_TWIN_*	Por tenant_id
exercise-stream	Eventos de ejercicios (telemetría, completados, etc.).	EXERCISE_*, MECHANIC_*, ACHIEVEMENT_*	Por patient_id
commerce-stream	Eventos comerciales (suscripciones, pagos, facturas).	SUBSCRIPTION_*, PAYMENT_*, INVOICE_*, COUPON_*, PRODUCT_*	Por tenant_id
practice-stream	Eventos operacionales (citas, mensajes, informes).	APPOINTMENT_*, MESSAGE_*, REPORT_*, VIDEOCALL_*	Por tenant_id
ai-stream	Eventos de IA (chat, RAG, guardrails).	CHAT_*, RAG_*, AI_MODEL_*, GUARDRAIL_*	Por tenant_id
analytics-stream	Eventos de análisis (trayectorias, predicciones, KPIs).	PROCESS_TRAJECTORY_*, PREDICTION_*, KPI_*, RESEARCH_*	Por tenant_id
system-stream	Eventos de sistema (startup, shutdown, health, errores).	SYSTEM_*, HEALTH_*, ERROR_*, FEATURE_FLAG_*	Global
4.3. Publicación de Eventos
Desde el código (ej. BERL):
# Ejemplo de publicación de evento desde BERL
from behavioralos.event_bus import EventBus
from behavioralos.events import ExerciseCompletedEvent

event = ExerciseCompletedEvent(
    patient_id="pat_001",
    exercise_id="exc_001",
    duration=120,
    score=85,
    difficulty_level=3,
    telemetry_summary={...}
)

event_bus = EventBus()
event_bus.publish(
    channel="exercise-stream",
    event=event,
    key=event.tenant_id  # particionado por tenant
)

4.4. Suscripción a Eventos
Desde el código (ej. AAO):

# Ejemplo de suscripción desde AAO
from behavioralos.event_bus import EventBus
from behavioralos.events import ExerciseCompletedEvent

def handle_exercise_completed(event: ExerciseCompletedEvent):
    # Procesar el evento: actualizar Behavioral Twin, evaluar procesos, etc.
    update_behavioral_twin(event.patient_id, event.exercise_id)
    update_process_trajectories(event.patient_id)

event_bus = EventBus()
event_bus.subscribe(
    channel="exercise-stream",
    event_type="EXERCISE_COMPLETED",
    handler=handle_exercise_completed,
    consumer_group="aao-consumers"
)

4.5. Políticas de Entrega y Reintentos
Política	Descripción	Configuración
Entrega	At-least-once (garantiza entrega, puede haber duplicados).	Redis Streams con ACK y CLAIM.
Reintentos	Backoff exponencial (2^retry * 100ms, cap 60s).	max_retries: 5
DLQ (Dead Letter Queue)	Eventos que fallan después de max_retries se envían a DLQ.	Canal dlq-stream con metadatos de error.
Circuit Breaker	Si un suscriptor falla repetidamente, se abre el circuito y se redirige a DLQ.	5 fallos consecutivos en 1 minuto.
Timeouts	Tiempo máximo de procesamiento de un evento.	30 segundos (con timeout y retry).
Ejemplo de política de reintentos (backoff exponencial):

retry_policy = {
    "max_retries": 5,
    "backoff": "exponential",
    "initial_delay": 100,  # ms
    "multiplier": 2,
    "max_delay": 60000,  # ms (60s)
    "retry_on": ["ConnectionError", "TimeoutError", "DatabaseError"]
}


5. Workflows y Sagas (Temporal.io)
5.1. Tecnología: Temporal.io
El BehavioralOS utiliza Temporal.io para orquestar workflows largos y transacciones distribuidas (Sagas). Temporal proporciona:

Durabilidad: Los workflows se recuperan automáticamente después de fallos.

Visibilidad: Paneles de control para monitorear workflows en ejecución.

Reintentos automáticos: Manejo de fallos con políticas configurables.

Sagas: Patrón de compensación para transacciones distribuidas.

Escalabilidad: Workers pueden escalarse horizontalmente.

5.2. Catálogo de Workflows
Workflow	Descripción	Duración típica	Sagas/Compensaciones
OnboardingWorkflow	Registro y configuración inicial de un paciente.	1-2 horas (asíncrono)	Si falla la creación de cuenta, rollback de datos.
SubscriptionWorkflow	Compra y activación de suscripción.	5 minutos	Si Stripe/MercadoPago falla, compensar y notificar.
PaymentWorkflow	Procesamiento de un pago y generación de factura.	30 segundos - 2 minutos	Si Facturapi falla, compensar y reintentar.
AssessmentWorkflow	Evaluación adaptativa completa (AAO).	5-15 minutos	Si el paciente abandona, guardar progreso parcial.
SessionFollowUpWorkflow	Seguimiento post-sesión (recordatorios, ejercicios).	1-7 días	Si el paciente no responde, escalar al terapeuta.
RecoveryWorkflow	Reactivación de un paciente que abandonó.	7-30 días	Si el paciente no responde, cerrar workflow.
DataExportWorkflow	Exportación de datos anonimizados para investigación.	10 minutos - 1 hora	Si falla la exportación, reintentar.
5.3. Ejemplo: SubscriptionWorkflow (Saga)
Descripción: Procesa la compra de una suscripción, activando servicios y generando factura.

Pasos:

Iniciar pago con Stripe/MercadoPago (llamada externa).

Esperar webhook de confirmación de pago (actividad asíncrona).

Crear suscripción en la base de datos (tabla subscriptions).

Generar factura (Facturapi / SAT).

Enviar correo de confirmación al paciente.

Activar servicios (ej. acceso a ejercicios, chat con TCCN).

Actualizar estado del paciente (BPOS, Behavioral Twin).

Saga (compensaciones):

Si paso 1 falla (pago rechazado): No hay compensación, se notifica al paciente.

Si paso 2 falla (webhook no llega): Se reintenta con backoff; si falla después de N intentos, se cancela la suscripción y se reversa el pago (reembolso).

Si paso 4 falla (Facturapi): Se marca la factura como pendiente y se reintenta en segundo plano (no se revierte el pago).

Si paso 5 falla (correo no enviado): Se registra el error y se reintenta; el paciente no se ve afectado.

Implementación con Temporal.io (Python):

from temporalio import workflow
from temporalio.common import RetryPolicy
from datetime import timedelta

@workflow.defn
class SubscriptionWorkflow:
    @workflow.run
    async def run(self, patient_id: str, plan_id: str, payment_method: str):
        # Paso 1: Iniciar pago
        payment_result = await workflow.execute_activity(
            initiate_payment,
            patient_id, plan_id, payment_method,
            start_to_close_timeout=timedelta(seconds=30),
            retry_policy=RetryPolicy(maximum_attempts=3)
        )

        # Paso 2: Esperar confirmación del pago (webhook)
        payment_confirmation = await workflow.execute_activity(
            wait_for_payment_confirmation,
            payment_result.payment_id,
            start_to_close_timeout=timedelta(minutes=5),
            retry_policy=RetryPolicy(maximum_attempts=5, backoff_coefficient=2.0)
        )

        # Paso 3: Crear suscripción en BD
        subscription_id = await workflow.execute_activity(
            create_subscription,
            patient_id, plan_id, payment_confirmation.payment_id,
            start_to_close_timeout=timedelta(seconds=10)
        )

        # Paso 4: Generar factura (Saga con compensación)
        invoice_id = None
        try:
            invoice_id = await workflow.execute_activity(
                generate_invoice,
                patient_id, subscription_id,
                start_to_close_timeout=timedelta(seconds=30),
                retry_policy=RetryPolicy(maximum_attempts=3)
            )
        except Exception as e:
            # Compensación: marcar factura como pendiente y notificar
            await workflow.execute_activity(
                mark_invoice_pending,
                subscription_id,
                start_to_close_timeout=timedelta(seconds=10)
            )
            # Notificar al paciente
            await workflow.execute_activity(
                notify_patient_payment_issue,
                patient_id,
                start_to_close_timeout=timedelta(seconds=10)
            )

        # Paso 5: Enviar correo de confirmación (reintentar si falla)
        await workflow.execute_activity(
            send_confirmation_email,
            patient_id, subscription_id,
            start_to_close_timeout=timedelta(seconds=30),
            retry_policy=RetryPolicy(maximum_attempts=5, backoff_coefficient=2.0)
        )

        # Paso 6: Activar servicios
        await workflow.execute_activity(
            activate_services,
            patient_id, subscription_id,
            start_to_close_timeout=timedelta(seconds=30),
            retry_policy=RetryPolicy(maximum_attempts=3)
        )

        # Paso 7: Actualizar estado del paciente
        await workflow.execute_activity(
            update_patient_status,
            patient_id, "active",
            start_to_close_timeout=timedelta(seconds=10)
        )

        return {"subscription_id": subscription_id, "status": "active"}

5.4. Sagas (Compensaciones)
Las Sagas garantizan la consistencia en transacciones distribuidas mediante compensaciones (acciones que revierten los efectos de un paso fallido).

Ejemplo de Saga para PaymentWorkflow:

Paso	Acción	Compensación (si falla)
1	Cargar tarjeta (Stripe/MercadoPago).	No hay compensación (reembolso automático si falla).
2	Crear suscripción en BD.	Eliminar suscripción (soft delete) y marcar como fallida.
3	Generar factura (Facturapi).	Marcar factura como pendiente; no compensar (se reintenta).
4	Enviar correo de confirmación.	Registrar error; no compensar (se reintenta).
Implementación de compensación:

Implementación de compensación:

@activity.defn
async def create_subscription(patient_id: str, plan_id: str, payment_id: str) -> str:
    # Crear suscripción en BD
    subscription_id = await db.create_subscription(patient_id, plan_id, payment_id)
    return subscription_id

# Compensación
@activity.defn
async def compensate_subscription_creation(subscription_id: str):
    # Revertir la creación de la suscripción
    await db.delete_subscription(subscription_id)  # soft delete

6. Políticas de Resiliencia
6.1. Reintentos y Backoff
Componente	Política de reintentos	Backoff	Límite
Event Bus (suscriptores)	5 intentos	Exponencial (2^retry * 100ms, cap 60s)	DLQ después de 5 fallos.
Workflows (Temporal)	Configurable por actividad	Exponencial (coeficiente 2.0)	Máximo 5 intentos.
Integraciones externas (Stripe, Facturapi)	3 intentos	Exponencial (100ms, 200ms, 400ms)	Circuit breaker después de 5 fallos consecutivos.
Base de datos (consultas)	3 intentos	Backoff fijo (100ms)	Error crítico después de 3 fallos.
6.2. Circuit Breaker
Propósito: Evitar que un servicio externo o motor fallido sature el sistema.

Implementación: Se usa un patrón de circuit breaker (ej. con circuit-breaker-js o implementación propia en Python).

Estados:

Cerrado: Las peticiones fluyen normalmente.

Abierto: Las peticiones fallan inmediatamente (sin intentar).

Medio-abierto: Se permite una petición de prueba; si tiene éxito, se cierra el circuito.

Configuración:

Umbral de fallos: 5 fallos consecutivos en 1 minuto.

Tiempo de espera para medio-abierto: 30 segundos.

Tiempo de recuperación: 60 segundos.

6.3. Dead Letter Queue (DLQ)
Propósito: Almacenar eventos que no pudieron procesarse después de múltiples reintentos.

Almacenamiento: Canal dlq-stream en Redis (o en PostgreSQL para persistencia).

Contenido:

Evento original (completo).

Metadatos de error: motivo, timestamp, número de intentos, stack trace (opcional).

Gestión:

Los eventos en DLQ se revisan manualmente por el equipo de operaciones.

Se pueden reprocesar (reintentar) después de corregir la causa del error.

Se puede archivar después de 30 días.

6.4. Idempotencia
Propósito: Garantizar que un evento se procese una sola vez, incluso si se entrega múltiples veces.

Implementación:

Cada evento tiene un idempotency_key (UUID v7).

El handler verifica si la clave ya fue procesada en una tabla de idempotencia (idempotency_keys).

Si ya fue procesada, el handler ignora el evento (devuelve éxito sin efectos).

La tabla de idempotencia tiene un TTL (ej. 7 días) para evitar crecimiento infinito.

Tabla de idempotencia:
CREATE TABLE system.idempotency_keys (
    idempotency_key UUID PRIMARY KEY,
    event_type VARCHAR(100) NOT NULL,
    processed_at TIMESTAMP DEFAULT NOW(),
    result JSONB NULL,
    expires_at TIMESTAMP DEFAULT NOW() + INTERVAL '7 days'
);

Ejemplo de handler idempotente:

async def handle_exercise_completed(event: ExerciseCompletedEvent):
    # Verificar idempotencia
    if await db.idempotency_key_exists(event.id):
        return  # Ya procesado, ignorar
    # Procesar evento
    await update_behavioral_twin(event.patient_id, event.exercise_id)
    # Registrar clave de idempotencia
    await db.store_idempotency_key(event.id, "EXERCISE_COMPLETED")

7. Observabilidad y Monitoreo
7.1. Métricas de Eventos
Métrica	Descripción	Herramienta
event_published_total	Número total de eventos publicados por tipo.	Prometheus
event_processed_total	Número total de eventos procesados por suscriptor.	Prometheus
event_processing_duration	Tiempo de procesamiento de eventos (histograma).	Prometheus
event_retry_total	Número de reintentos por evento.	Prometheus
event_dlq_total	Número de eventos enviados a DLQ.	Prometheus
workflow_execution_count	Número de workflows ejecutados.	Temporal UI + Prometheus
workflow_duration	Duración de workflows (histograma).	Temporal UI + Prometheus
saga_compensation_count	Número de compensaciones ejecutadas.	Prometheus
7.2. Trazabilidad Distribuida
OpenTelemetry: Se inyecta un trace_id en cada evento y workflow.

Correlación: correlation_id permite rastrear un flujo completo (ej. desde la compra hasta la activación de servicios).

Jaeger: Visualización de trazas distribuidas para depuración.

Ejemplo de traza:

[Purchase] trace_id=abc123
  -> SubscriptionWorkflow started
  -> Activity: initiate_payment (Stripe) duration=200ms
  -> Activity: wait_for_payment_confirmation duration=5s
  -> Activity: create_subscription (DB) duration=50ms
  -> Activity: generate_invoice (Facturapi) duration=2s
  -> Activity: send_confirmation_email (SendGrid) duration=500ms
  -> Activity: activate_services duration=100ms
  -> SubscriptionWorkflow completed duration=8s

7.3. Alertas
Alerta	Condición	Gravedad	Acción
EventProcessingLatencyHigh	Latencia media > 5s durante 5 minutos.	Alta	Revisar rendimiento de suscriptores.
EventDLQGrowth	Número de eventos en DLQ > 100 en 1 hora.	Media	Revisar eventos fallidos.
WorkflowFailureRateHigh	Tasa de fallos de workflows > 10% en 10 minutos.	Alta	Revisar logs de Temporal.
CircuitBreakerOpen	Circuit breaker abierto para una integración externa.	Alta	Revisar servicio externo.
8. Estrategia de Despliegue y Evolución
8.1. Versionado de Eventos
Versionado semántico: Los eventos tienen un campo version (ej. 1.0.0, 2.0.0).

Compatibilidad hacia atrás: Los cambios menores y de parche son compatibles (se añaden campos opcionales).

Cambios mayores: Se crea una nueva versión del evento (ej. EXERCISE_COMPLETED_V2) y se mantiene la versión antigua durante un período de transición.

Deprecación: Las versiones antiguas se deprecan con 6 meses de antelación y se eliminan después de 12 meses.

8.2. Despliegue Canary
Nuevos suscriptores: Se despliegan en modo canary (solo un pequeño porcentaje de eventos) para validar su funcionamiento.

Rollback: Si se detectan errores, se revierte el despliegue automáticamente.

8.3. Migración de Workflows
Workflows en ejecución: Temporal.io permite versionar workflows; las versiones antiguas siguen ejecutándose hasta completarse.

Nuevas versiones: Se registran con un nuevo nombre (ej. SubscriptionWorkflowV2) y se migran gradualmente.

9. Criterios de Validación y Cumplimiento
Criterio	Métrica	Herramienta
Disponibilidad del Event Bus	99.9% de uptime.	Monitoreo (Prometheus).
Latencia de eventos	< 100 ms (p99) desde publicación hasta suscripción.	Monitoreo.
Tasa de reintentos	< 5% de eventos requieren reintentos.	Monitoreo.
Tasa de fallos de workflows	< 2% de fallos en workflows críticos (ej. pagos).	Temporal UI.
Cobertura de idempotencia	100% de eventos críticos tienen idempotencia.	Revisión de código.
Trazabilidad	100% de los eventos tienen correlation_id.	Auditoría automática.
10. El Manifiesto de los Eventos y Workflows
"Un evento no es un simple mensaje. Es una promesa de que algo ha ocurrido, una huella digital de la acción.

Los eventos son el lenguaje en el que los motores del BehavioralOS se comunican sin acoplarse. Cada evento debe ser claro, trazable y procesable de forma asíncrona.

Los workflows son la coreografía de los procesos largos. Cada paso debe ser resiliente, cada compensación debe ser justa.

Nuestra responsabilidad es construir un sistema de eventos que sea confiable, escalable y transparente. Que los fallos sean la excepción, no la norma. Que cada evento cuente su historia, y que cada workflow tenga un final feliz."

11. Historial de Cambios
Versión	Fecha	Autor	Cambios
1.0.0	2026-07-01	Arquitectura Backend	Creación del documento. Definición de catálogo de eventos, Event Bus, workflows con Temporal.io, Sagas, políticas de resiliencia, idempotencia, observabilidad y despliegue.
Fin del documento events-and-workflows.md