---
id: AI-007
title: Soporte y Atención por IA (Support Chat)
version: 1.1.0
status: Specified
owner: Arquitectura de IA & Frontend Engineering
last_updated: 2026-08-12
depends_on:
  - 400-AI/ai-core.md (AI-001 - motor de inferencia on-device Gemma + MediaPipe)
  - 400-AI/guardrails.md (AI-004 - guardrails clínicos y Crisis Interceptor)
  - 400-AI/event-sourcing-ai.md (AI-006 - event sourcing y motores derivados)
  - 200-Backend/api-graph.md (API-001 - endpoints de escalación y feedback)
  - 200-Backend/database-graph.md (DB-001 - support_tickets, consent_log)
  - 100-Architecture/data-model.md (DM-001 - modelo de datos)
  - 600-Commerce/service-landing.md (SLS-001 - widget en la landing)
  - 300-Frontend/pwa-architecture.md (PWA-001 - streaming SSE)
exports:
  - Canal de soporte por IA para reporte de errores y propuestas de mejora
  - Clasificación de intents: soporte vs. compañero terapéutico (AI-002)
  - Flujo de ticket de error estructurado (categoría, severidad, pasos, contexto)
  - Flujo de propuesta de mejora (improvement intake)
  - Escalamiento a soporte humano vía POST /api/v1/ai/escalation
  - Registro de consentimiento de diagnóstico en consent_log
  - Integración con guardrails (AI-004) y event sourcing (AI-006)
used_by:
  - SLS-001 (widget de soporte en la landing)
  - Patient App (reporte de errores desde la app)
  - Therapist App (reporte de errores y mejoras)
  - Soporte humano (tickets, paneles)
---

# BehavioralOS – Soporte y Atención por IA (Support Chat)

> *"El soporte no es un chatbot de ventas ni un psicólogo. Es el canal por el cual la comunidad cuida el producto: reporta errores, propone mejoras y recibe respuesta. Corre sobre el mismo runtime de IA on-device del BehavioralOS — los datos nunca salen del dispositivo."*

> **⚠️ AMENDMENT v1.1.0 (2026-08-12) — Runtime On-Device (Norma Vinculante)**
>
> El Support Chat corre sobre el runtime **on-device** de `AI-001` (Gemma + MediaPipe
> en el dispositivo del usuario). Este amendment **SUPERSEDE** la decisión previa de
> runtime sobre servidor privado (Gemma 4 + vLLM) documentada en la v1.0.0: ya no
> existe inferencia en servidor privado (vLLM/Ollama) ni embebida en navegador
> (WebGPU/ONNX). El streaming SSE/WebSocket (PWA-001) se conserva, originado desde el
> runtime on-device. Las secciones §1.1, §1.3, §2.1 y §8 quedan corregidas por esta norma.

---

## 1. Propósito y Alcance

### 1.1. Propósito

El **Support Chat (AI-007)** es el canal conversacional de soporte del BehavioralOS.
Su objetivo es capturar **reportes de errores** y **propuestas de mejora** de los
usuarios (pacientes, terapeutas y visitantes de la landing) de forma estructurada,
trazable y respetuosa de la privacidad. Corre sobre el motor de inferencia on-device
Gemma + MediaPipe de `AI-001`, se sirve vía streaming SSE/WebSocket (PWA-001)
originado desde el runtime del dispositivo y cumple todos los guardrails de `AI-004`.

**NO es:** un chatbot comercial, un compañero terapéutico (eso es `AI-002` TCCN),
ni un canal de atención clínica.

### 1.2. Alcance

- **Superficies:** widget en la landing (`SLS-001-REC-006`), Patient App y Therapist App.
- **Intents soportados:** `error` (reporte de fallo) e `improvement` (propuesta de mejora).
- **Persistencia:** tickets en `support_tickets`; consentimiento en `consent_log`; leads comerciales en `leads` (no se mezclan).
- **Escalamiento:** derivación a soporte humano cuando el ticket lo requiere.

### 1.3. Fuera de alcance

- Terapia o contenido clínico (prohibido; pasa por guardrails).
- Venta, precios o captura de leads comerciales (la landing redirige al formulario SLS-001).
- Inferencia en navegador (WebGPU/ONNX) o en servidor privado (vLLM/Ollama): **toda inferencia corre on-device vía AI-001 (Gemma + MediaPipe)**.

---

## 2. Arquitectura y Runtime

### 2.1. Runtime (Vinculante)

La inferencia del Support Chat corre **exclusivamente on-device** vía
`AI-001` (Gemma + MediaPipe, constrained decoding JSON, streaming SSE desde el runtime
del dispositivo). **No hay inferencia embebida en el navegador** (ni WebGPU ni ONNX)
**ni runtime en servidor privado** (ni vLLM ni Ollama). El pipeline es:

```
Widget/App → Gemma on-device (MediaPipe) → POST /api/v1/ai/chat (stream SSE) → JSON →
clasificación de intent → ticket / escalación / respuesta
```

### 2.2. Clasificación de Intent

Cada mensaje MUST ser clasificado por el modelo con constrained decoding JSON en uno
de estos intents:

| Intent | Descripción | Acción |
|--------|-------------|--------|
| `error` | Reporte de un fallo o comportamiento inesperado | Ticket de error estructurado |
| `improvement` | Propuesta de mejora o sugerencia | Ticket de mejora (intake) |
| `support_info` | Pregunta sobre soporte/estado de un ticket | Respuesta + consulta de estado |
| `commercial` | Consulta de precios/contratación | Redirige al formulario de leads (SLS-001) |
| `therapeutic` | Petición de ayuda emocional/clínica | NO se atiende; pasa a crisis/guardrails y redirige al TCCN (AI-002) |

Los intents `commercial` y `therapeutic` MUST NOT resolverse dentro del Support Chat:
el primero redirige al formulario y el segundo a guardrails/AI-002.

### 2.3. Configuración de Modelo

- Modelo: Gemma (configurado en `AI-001`, on-device vía MediaPipe).
- Decodificación: constrained JSON (siempre).
- Prompt del sistema: perfil de "soporte técnico no clínico"; nunca ofrece consejo
  terapéutico ni promete resultados.
- Shadow deployments y prompt versioning según `AI-001`.

---

## 3. Requisitos Funcionales

Los requisitos usan palabras clave RFC 2119 (MUST/SHOULD/MAY).

### 3.1. AI-007-REC-001: Reporte de error estructurado

| Atributo | Valor |
|----------|-------|
| Descripción | El usuario describe un error; el sistema estructura un ticket con categoría, severidad, pasos de reproducción, contexto de app y consentimiento. |
| Criterio de aceptación | Ticket persistido en `support_tickets` con todos los campos obligatorios; 201 en creación; referencia de seguimiento devuelta al usuario. |

#### Escenarios

- **GIVEN** un usuario reporta un error **WHEN** el sistema clasifica el intent como `error` **THEN** se crea un ticket con `category='error'`, `severity` inferida (low/medium/high/critical) y se devuelve un ID de seguimiento.
- **GIVEN** un reporte de error sin contexto suficiente **WHEN** se intenta persistir **THEN** el sistema solicita los pasos de reproducción antes de cerrar el ticket (`status='awaiting_reproduction'`).
- **GIVEN** una petición sin consentimiento de diagnóstico **WHEN** se crea el ticket **THEN** el sistema guarda el ticket con el consentimiento registrado en `consent_log`; sin consentimiento el ticket se crea sin datos personales.

### 3.2. AI-007-REC-002: Propuesta de mejora (intake)

| Atributo | Valor |
|----------|-------|
| Descripción | El usuario propone una mejora; el sistema clasifica el intent como `improvement` y persiste un ticket de mejora. |
| Criterio de aceptación | Ticket `category='improvement'` persistido; confirmación visible; vinculación opcional con área del producto. |

#### Escenarios

- **GIVEN** un usuario sugiere una mejora **WHEN** el intent es `improvement` **THEN** se crea el ticket y se confirma el agradecimiento.
- **GIVEN** la mejora es ambigua **WHEN** el modelo no puede extraer el área **THEN** se guarda con `category='improvement'` y `area=NULL` para revisión humana.

### 3.3. AI-007-REC-003: Escalamiento a soporte humano

| Atributo | Valor |
|----------|-------|
| Descripción | Los tickets con `severity='high'|'critical'` o tras intentos fallidos de auto-resolución se escalan vía `POST /api/v1/ai/escalation`. |
| Criterio de aceptación | Escalamiento → ticket en `support_tickets` con `status='escalated'`; canales públicos de contacto mostrados cuando no hay consentimiento; 201 al persistir. |

#### Escenarios

- **GIVEN** un error con `severity='critical'` **WHEN** el sistema registra el ticket **THEN** se escalada automáticamente y se notifica al equipo de soporte.
- **GIVEN** un usuario sin consentimiento solicita ayuda humana **WHEN** se intenta escalar **THEN** se muestran los canales públicos de contacto y se registra `consent_log.granted=false`.
- **GIVEN** el escalamiento se completa con consentimiento **THEN** la respuesta es `201` con el ticket persistido y `retry=false`; sin consentimiento el cliente puede reintentar tras registrar consentimiento.

### 3.4. AI-007-REC-004: Guardrails y límites

| Atributo | Valor |
|----------|-------|
| Descripción | Toda respuesta pasa por el pipeline de guardrails (`AI-004`); el Crisis Interceptor aplica a cualquier input/output, aunque sea "soporte". |
| Criterio de aceptación | 100% de respuestas validadas por guardrails; contenido clínico rechazado o derivado; crisis activa protocolo de contención. |

#### Escenarios

- **GIVEN** un mensaje con ideación suicida **WHEN** se procesa **THEN** el Crisis Interceptor activa el protocolo de contención y notifica al psicólogo (nunca se responde como ticket de soporte).
- **GIVEN** un mensaje pidiendo consejo terapéutico **WHEN** se detecta el intent `therapeutic` **THEN** el sistema responde que eso no es soporte y redirige al TCCN (AI-002), sin dar consejo.

### 3.5. AI-007-REC-005: Consentimiento de diagnóstico

| Atributo | Valor |
|----------|-------|
| Descripción | El envío de datos de diagnóstico (logs, contexto de app, pasos de reproducción) requiere consentimiento explícito registrado en `consent_log` (scope `diagnostics`). |
| Criterio de aceptación | Todo ticket con datos personales tiene fila en `consent_log` (granted_at); revocación posible (revoked_at) que desvincula los datos. |

#### Escenarios

- **GIVEN** un ticket con datos de diagnóstico **WHEN** se persiste **THEN** existe `consent_log` con `scope='diagnostics'`, `granted_at`, y referencia al ticket.
- **GIVEN** un usuario revoca el consentimiento **WHEN** solicita la eliminación **THEN** se setea `revoked_at` y el ticket se anonimiza.

### 3.6. AI-007-REC-006: Event sourcing y feedback

| Atributo | Valor |
|----------|-------|
| Descripción | La interacción con el Support Chat emite eventos al Event Stream (`AI-006`) y el feedback de utilidad se envía vía `POST /ai/chat/{id}/feedback` (API-001). |
| Criterio de aceptación | Eventos emitidos (support.ticket_created, support.ticket_escalated, support.feedback); feedback persistido; dashboard de soporte usa las vistas derivadas. |

#### Escenarios

- **GIVEN** un ticket creado **WHEN** se persiste **THEN** se emite el evento `support.ticket_created` al Event Stream.
- **GIVEN** el usuario califica la utilidad de una respuesta **WHEN** envía feedback **THEN** `POST /ai/chat/{id}/feedback` persiste la calificación para los motores derivados.

---

## 4. Modelo de Datos

### 4.1. `support_tickets` (dominio commerce, DB-001 §4.3.7)

Persistencia de tickets de soporte. Campos principales:

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `id` | UUID | PK |
| `user_id` | UUID NULL | Usuario autenticado (NULL para visitantes de la landing) |
| `category` | enum | `error` \| `improvement` |
| `severity` | enum | `low` \| `medium` \| `high` \| `critical` |
| `status` | enum | `new` \| `awaiting_reproduction` \| `in_progress` \| `escalated` \| `resolved` \| `closed` |
| `description` | text | Descripción del reporte |
| `reproduction_steps` | text NULL | Pasos de reproducción (errores) |
| `app_context` | jsonb NULL | Contexto de la app (versión, plataforma, pantalla) |
| `source` | enum | `landing` \| `patient_app` \| `therapist_app` |
| `consent_id` | UUID NULL | Referencia a `consent_log` (diagnósticos) |
| `created_at` / `updated_at` | timestamptz | Timestamps |

### 4.2. `consent_log` (dominio commerce, DB-001 §4.3.8)

Registro de consentimiento de diagnóstico:

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `id` | UUID | PK |
| `user_key` | text | Identificador del usuario o visitante (anónimo si no hay cuenta) |
| `scope` | text | `diagnostics` (y otros) |
| `granted_at` | timestamptz | Momento de aceptación |
| `revoked_at` | timestamptz NULL | Momento de revocación |

> **Nota de implementación:** ambas tablas ya existen en el codebase implementado
> (slice T2.6 del change `landing-ia-atencion`); este spec formaliza su contrato.

---

## 5. APIs

### 5.1. `POST /api/v1/ai/escalation`

Crea un ticket de soporte (escalamiento) → `201` con el ticket persistido y
`{retry, public_channels}` cuando no hay consentimiento.

### 5.2. `GET /api/v1/ai/escalation/{ticket_id}`

Estado de un ticket de soporte (seguimiento por ID).

### 5.3. `GET /api/v1/ai/escalation`

Listado de tickets de soporte (equipo de soporte / admin).

### 5.4. `POST /ai/chat/{id}/feedback`

Feedback de utilidad de la respuesta (ya definido en API-001 §3.6).

---

## 6. Criterios de Validación

| Criterio | Métrica | Herramienta |
|----------|---------|-------------|
| Clasificación de intent | ≥90% precisión en intents error/improvement | Evaluación de conjunto de pruebas |
| Guardrails | 100% de respuestas pasan el pipeline | BQAS |
| Crisis | Recall del Crisis Interceptor >99% | Evaluación clínica (AI-004) |
| Latencia primera respuesta | <200ms (streaming SSE) | Métricas backend (AI-001) |
| Persistencia | 100% de tickets con consentimiento en `consent_log` | Pruebas de integración |
| Privacidad | 0 datos sin consentimiento en tickets | Auditoría |

---

## 7. Métricas de Éxito

| Métrica | Objetivo |
|---------|----------|
| Tickets de error resueltos automáticamente | ≥70% (información de referencia) |
| Feedback útil (rating ≥4/5) | ≥80% |
| Tiempo hasta escalamiento humano | < 5 min en severidad alta/crítica |
| Reducción de tickets duplicados | ≤10% duplicados tras deduplicación |

---

## 8. Trazabilidad

- Delta spec: `landing-ia-atencion` (obs #262) → AI-007 (materialización slice 2).
- Aristas: `AI-007 → AI-001` (runtime), `AI-007 → AI-004` (guardrails), `AI-007 → AI-006` (eventos), `AI-007 → API-001` (endpoints), `AI-007 → DB-001/DM-001` (tablas), `SLS-001 → AI-007` (widget landing).
- Guardrail de runtime: **inferencia on-device vía AI-001 (Gemma + MediaPipe)**; no WebGPU/ONNX ni servidor privado (vLLM/Ollama).

---

## 9. Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2026-08-12 | Arquitectura de IA & Frontend Engineering | Creación del spec AI-007 (change `landing-ia-atencion`, slice 2). |
| 1.1.0 | 2026-08-12 | Arquitectura de IA & Frontend Engineering | AMENDMENT: runtime estandarizado a **on-device (Gemma + MediaPipe vía AI-001)**. SUPERSEDE la decisión previa de servidor privado (Gemma 4 + vLLM) documentada en v1.0.0; el streaming SSE/WebSocket se conserva originado desde el runtime del dispositivo. |
