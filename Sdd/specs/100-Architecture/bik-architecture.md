---
id: BIK-001
title: Behavioral Intelligence Kernel (BIK) — Arquitectura del Núcleo de Inteligencia
version: 1.0.0
status: Draft
owner: Arquitectura de Software & Psicología Clínica
last_updated: 2026-07-14
depends_on:
  - BPE (Behavioral Platform Engine)
  - BPO (Behavioral Process Ontology)
  - BPG (Behavioral Process Graph)
  - BXE (Behavioral Explainability Engine)
  - 100-Architecture/system-architecture.md (BEA)
  - 200-Backend (FastAPI, Redis, PostgreSQL)
  - 400-AI (Gemma, MediaPipe, RAG)
  - 500-Experiences (Patient App, Therapist App)
exports:
  - Diagrama de interacción entre motores del núcleo
  - Flujo de datos end-to-end: paciente → motores → dashboards
  - Protocolos de comunicación entre motores
  - Contratos de interfaz del Kernel API
  - Catálogo de submotores del BIK
used_by:
  - Todos los módulos clínicos (BCAS, BCMS, BIMS, BCIE, BCOE)
  - Clinical Knowledge Layer (BPO, BPG, BPG-M, BIDO, BTPL, BESS)
  - Data Layer (BDF, BARS)
  - Adaptive Intelligence (BPAS, BDTE)
  - Decision Intelligence (BDSS)
  - Explainability (BXE)
  - Governance & Security (BCGS, BLES)
  - Extension Platform (BDIS)
  - BERL y motores especializados
---

# BehavioralOS — Behavioral Intelligence Kernel (BIK)

> *"El BIK no hace terapia. No hace diagnósticos. No genera tratamientos. No toma decisiones. Hace algo mucho más importante: orquesta toda la inteligencia de la plataforma. Es el equivalente a un Kernel de un sistema operativo."*

---

## 1. Propósito y Alcance

### 1.1. Propósito

El Behavioral Intelligence Kernel (BIK) es el **núcleo central de inteligencia** del ecosistema Behavioral. Su responsabilidad no es procesar datos clínicos directamente, sino **coordinar, sincronizar, contextualizar y gobernar** el funcionamiento de todos los motores clínicos, analíticos, adaptativos y operativos.

Sin el BIK, el sistema tendría decenas de motores inteligentes aislados. Con él, funcionan como un **único sistema operativo conductual coherente**.

### 1.2. Alcance

El BIK cubre:

- **Orquestación**: Determina qué motores participan, en qué orden, y con qué contexto.
- **Contexto compartido**: Mantiene un estado cognitivo unificado para todos los motores.
- **Resolución de conflictos**: Cuando dos motores proponen cosas distintas, el BIK las presenta al terapeuta sin decidir por sí mismo.
- **Gobernanza de políticas**: Garantiza que todas las acciones respeten reglas clínicas, organizacionales y de permisos.
- **Gestión de confianza**: Integra niveles de confianza de múltiples motores para decidir cuándo se requiere más información.
- **Coordinación multi-agente**: Administra el ciclo de vida de agentes de IA especializados.

### 1.3. Filosofía Fundamental

> **"El BIK nunca reemplaza módulos. Los coordina. No contiene todo el conocimiento. Sabe dónde está. No responde todo. Sabe quién debe responder."**

---

## 2. Diagrama de Interacción entre Motores

### 2.1. Posición del BIK en la Arquitectura

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    BEHAVIORAL INTELLIGENCE KERNEL (BIK)                 │
│                    ─── Director de Orquesta ───                        │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  ┌─────────────────┐  ┌──────────────────┐  ┌─────────────────────┐   │
│  │  Intelligence    │  │ Cognitive Context │  │ Behavioral Memory   │   │
│  │  Orchestrator    │  │ Engine            │  │ Manager             │   │
│  └────────┬────────┘  └────────┬─────────┘  └──────────┬──────────┘   │
│           │                    │                        │              │
│  ┌────────┴────────┐  ┌───────┴──────────┐  ┌─────────┴──────────┐   │
│  │  Reasoning       │  │ Knowledge Fusion │  │ Global State       │   │
│  │  Router          │  │ Engine           │  │ Manager            │   │
│  └────────┬────────┘  └────────┬─────────┘  └──────────┬──────────┘   │
│           │                    │                        │              │
│  ┌────────┴────────┐  ┌───────┴──────────┐  ┌─────────┴──────────┐   │
│  │  Coordination    │  │ Goal Management  │  │ Cognitive Workflow │   │
│  │  Bus             │  │ Engine           │  │ Engine             │   │
│  └────────┬────────┘  └────────┬─────────┘  └──────────┬──────────┘   │
│           │                    │                        │              │
│  ┌────────┴────────┐  ┌───────┴──────────┐  ┌─────────┴──────────┐   │
│  │  Multi-Agent     │  │ Explainability   │  │ Conflict           │   │
│  │  Coordination    │  │ Coordinator      │  │ Resolution         │   │
│  └────────┬────────┘  └────────┬─────────┘  └──────────┬──────────┘   │
│           │                    │                        │              │
│  ┌────────┴────────┐  ┌───────┴──────────┐  ┌─────────┴──────────┐   │
│  │  Policy          │  │ Trust &          │  │ Resource           │   │
│  │  Enforcement     │  │ Confidence       │  │ Allocation         │   │
│  └────────┬────────┘  └────────┬─────────┘  └──────────┬──────────┘   │
│           │                    │                        │              │
│  ┌────────┴────────┐  ┌───────┴──────────┐  ┌─────────┴──────────┐   │
│  │  Learning        │  │ Intelligence     │  │ Kernel Monitoring  │   │
│  │  Governance      │  │ Registry         │  │ Engine             │   │
│  └────────┬────────┘  └────────┬─────────┘  └──────────┬──────────┘   │
│           │                    │                        │              │
│  ┌────────┴────────┐  ┌───────┴──────────┐                         │
│  │  Behavioral AI   │  │ Kernel API       │                         │
│  │  Runtime         │  │                  │                         │
│  └─────────────────┘  └──────────────────┘                         │
│                                                                         │
├─────────────────────────────────────────────────────────────────────────┤
│  MOTORES COORDINADOS POR EL BIK:                                       │
│                                                                         │
│  Clinical Core        │ Clinical Knowledge    │ Data & Analytics       │
│  ─────────────        │ ──────────────────    │ ──────────────────     │
│  BCI  - Intake        │ BPO  - Ontología      │ BDF  - Data Fabric     │
│  BCAS - Evaluación    │ BPG  - Grafo Procesos │ BARS - Analytics       │
│  BCMS - Expedientes   │ BPG-M - Grafo Meta    │ BKGE - Knowledge Graph │
│  BIMS - Intervenciones│ BIDO - Intervenciones │ BWM  - World Model     │
│  BCIE - Caseload      │ BTPL - Plantillas     │                        │
│  BCOE - Operaciones   │ BESS - Escenarios     │ Adaptive Intelligence  │
│  BSI  - Scheduling    │ BKC  - Knowledge Cmp. │ ──────────────────     │
│                       │ BTVE - Validación Evo.│ BPAS - Personalización │
│                       │ BCCE - Consistencia   │ BDTE - Decisión Exp.   │
│                       │                        │ BDSS - Decision Supp.  │
│  Explainability       │ Governance            │ Extension              │
│  ─────────────        │ ────────────          │ ──────────────         │
│  BXE  - Explicabilidad│ BCGS - Compliance     │ BDIS - Ext Platform    │
│                       │ BLES - Licencias      │                        │
│                       │ BERL - Research Lab    │                        │
└─────────────────────────────────────────────────────────────────────────┘
```

### 2.2. Jerarquía de Coordinación

```
Solicitud (evento o comando)
        │
        ▼
┌───────────────────┐
│     BIK API        │  ← Puerta de entrada única para coordinación
└────────┬──────────┘
         │
         ▼
┌───────────────────┐
│  Intelligence      │  ← Analiza la solicitud y determina qué motores participan
│  Orchestrator      │
└────────┬──────────┘
         │
    ┌────┴────┐
    ▼         ▼
┌────────┐ ┌────────┐
│Contexto│ │Estado  │  ← Carga contexto compartido y estado global
│Engine  │ │Manager │
└────┬───┘ └────┬───┘
     │          │
     ▼          ▼
┌───────────────────┐
│  Reasoning Router  │  ← Decide a qué motor enviar cada necesidad
└────────┬──────────┘
         │
    ┌────┼────┬────────┐
    ▼    ▼    ▼        ▼
  BCAS  BDSS  BPAS   BCIE  ← Motores que procesan en paralelo
    │    │    │        │
    └────┼────┴────────┘
         ▼
┌───────────────────┐
│ Knowledge Fusion   │  ← Integra resultados de múltiples motores
│ Engine             │
└────────┬──────────┘
         │
         ▼
┌───────────────────┐
│ Explainability     │  ← Construye cadena de razonamiento trazable
│ Coordinator        │
└────────┬──────────┘
         │
         ▼
┌───────────────────┐
│  Respuesta al      │  ← Devuelve resultado explicado al terapeuta/paciente
│  Terapeuta/Paciente│
└───────────────────┘
```

---

## 3. Flujo de Datos End-to-End

### 3.1. Flujo: Paciente → Motores → Dashboards

```
┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
│ PACIENTE  │    │ FUENTES  │    │  EVENT   │    │   BIK    │
│           │    │ DE DATOS │    │  STREAM  │    │ KERNEL   │
└─────┬────┘    └─────┬────┘    └─────┬────┘    └─────┬────┘
      │               │               │               │
      │  Chat casual  │               │               │
      │──────────────►│               │               │
      │               │  Evento       │               │
      │               │  conductual   │               │
      │               │──────────────►│               │
      │  Juegos       │               │               │
      │──────────────►│  Telemetría   │               │
      │               │──────────────►│               │
      │  Evaluaciones │               │               │
      │──────────────►│  Respuestas   │               │
      │               │──────────────►│               │
      │  EMA/Wearables│               │               │
      │──────────────►│  Señales      │               │
      │               │──────────────►│               │
      │               │               │  Distribuye   │
      │               │               │──────────────►│
      │               │               │               │
      │               │               │    ┌──────────┴──────────┐
      │               │               │    │   SUBMOTORES BIK    │
      │               │               │    │                     │
      │               │               │    │  ┌───────────────┐  │
      │               │               │    │  │ RFT Engine    │  │
      │               │               │    │  │ (grafos RFT)  │  │
      │               │               │    │  └───────────────┘  │
      │               │               │    │  ┌───────────────┐  │
      │               │               │    │  │ ACT Hexaflex  │  │
      │               │               │    │  │ (puntuaciones)│  │
      │               │               │    │  └───────────────┘  │
      │               │               │    │  ┌───────────────┐  │
      │               │               │    │  │ FAP CRB       │  │
      │               │               │    │  │ (conductas)   │  │
      │               │               │    │  └───────────────┘  │
      │               │               │    │  ┌───────────────┐  │
      │               │               │    │  │ BPG Updater   │  │
      │               │               │    │  │ (grafo global)│  │
      │               │               │    │  └───────────────┘  │
      │               │               │    └──────────┬──────────┘
      │               │               │               │
      │               │               │    Resultados │
      │               │               │    derivados  │
      │               │               │◄──────────────│
      │               │               │               │
      │               │               │  Actualiza    │
      │               │               │  Behavioral   │
      │               │               │  Twin         │
      │               │               │──────────────►│
      │               │               │               │
      │               │               │    ┌──────────┴──────────┐
      │               │               │    │  DASHBOARDS         │
      │               │               │    │                     │
      │               │               │    │  ┌───────────────┐  │
      │               │               │    │  │ BARS (Análisis)│  │
      │               │               │    │  └───────────────┘  │
      │               │               │    │  ┌───────────────┐  │
      │               │               │    │  │ BXE (Explain) │  │
      │               │               │    │  └───────────────┘  │
      │               │               │    │  ┌───────────────┐  │
      │               │               │    │  │ BCIE (Caseload│  │
      │               │               │    │  └───────────────┘  │
      │               │               │    └─────────────────────┘
      │               │               │
      │◄──────────────│◄──────────────│
      │  Notificaciones,              │
      │  ejercicios,                  │
      │  feedback                     │
      └───────────────┘
```

### 3.2. Fuentes de Eventos

| Fuente | Tipo de Evento | Ejemplo | Frecuencia |
|--------|---------------|---------|------------|
| Chat del paciente (TCCN) | `CONVERSATION_MESSAGE` | "Siento que no sirvo para nada" | En tiempo real |
| Juegos (Godot/BERL) | `EXERCISE_TELEMETRY` | Tiempo de permanencia, errores, puntuación | Por sesión de juego |
| Evaluaciones (AAO/BAD) | `ASSESSMENT_COMPLETED` | MPFI, AAQ-II, CompACT | Tras cada evaluación |
| EMA (auto-reporte) | `EMA_RESPONSE` | Estado de ánimo, estrés, sueño | Diario / varias veces |
| Wearables (opcional) | `SENSOR_DATA` | Acelerómetro, GPS, frecuencia cardíaca | Continuo |
| Terapeuta (BPOS) | `THERAPIST_FEEDBACK` | Notas, observaciones, cambios de plan | Tras cada sesión |
| Agenda (BCMS) | `APPOINTMENT_EVENT` | Cita programada, cancelada, completada | Variable |

### 3.3. Contrato de Evento Estándar

```json
{
  "event_id": "evt_7f3a2b1c",
  "event_type": "EXERCISE_TELEMETRY",
  "timestamp": "2026-07-14T14:30:00Z",
  "source_engine": "BERL",
  "patient_id": "pat_abc123",
  "tenant_id": "tenant_clinica_xyz",
  "payload": {
    "exercise_id": "defusion_balloon_01",
    "duration_ms": 45000,
    "completion": true,
    "score": 0.72,
    "telemetry": {
      "time_to_first_action_ms": 3200,
      "errors": 2,
      "hesitation_events": 1
    }
  },
  "metadata": {
    "schema_version": "1.0.0",
    "confidence": 0.85,
    "session_id": "sess_9z8y7x"
  }
}
```

---

## 4. Submotores del BIK — Contratos de Interfaz

### 4.1. Intelligence Orchestrator

| Atributo | Valor |
|----------|-------|
| **Propósito** | Scheduler del sistema. Recibe solicitudes y determina qué motores necesitan participar. |
| **Entrada** | Solicitud (evento o comando) + contexto del paciente |
| **Salida** | Plan de ejecución: lista ordenada de motores a invocar con sus parámetros |
| **Ejemplo** | Nuevo paciente → [BCI, BCAS, BDF, BPAS, BDSS] |
| **Protocolo** | Síncrono (REST) o asíncrono (evento `EXECUTION_PLAN_CREATED`) |

### 4.2. Cognitive Context Engine

| Atributo | Valor |
|----------|-------|
| **Propósito** | Mantiene un contexto compartido para todos los motores durante una sesión o workflow. |
| **Datos gestionados** | Motivo de consulta, formulación funcional, proceso activo, intervención actual, organización, permisos, idioma |
| **Protocolo** | Consulta asíncrona vía `GET /bik/context/{session_id}` |
| **Garantía** | Todos los motores trabajan con el mismo contexto; no hay divergencia. |

### 4.3. Behavioral Memory Manager

| Atributo | Valor |
|----------|-------|
| **Propósito** | Memoria del sistema (no del paciente). Almacena estado de ejecuciones, decisiones temporales, contexto entre procesos, sesiones activas, caché semántica. |
| **No sustituye** | Al expediente clínico (BPOS/BCMS) ni al Behavioral Twin |
| **Protocolo** | Lectura/escritura vía `GET/PUT /bik/memory/{scope}` |
| **Retención** | TTL configurable por tipo de dato (sesiones: 24h, caché semántica: 1h) |

### 4.4. Behavioral Reasoning Router

| Atributo | Valor |
|----------|-------|
| **Propósito** | Decide a qué motor enviar cada necesidad de razonamiento. |
| **Reglas de enrutamiento** | Consulta sobre adherencia → BCIE; Simulación → BDTE; Reporte → BARS; Planificación → BDSS |
| **Protocolo** | Interno al BIK (no expuesto externamente) |
| **Extensible** | Nuevos motores se registran en el Intelligence Registry y el router los descubre automáticamente. |

### 4.5. Knowledge Fusion Engine

| Atributo | Valor |
|----------|-------|
| **Propósito** | Integra conocimiento distribuido de múltiples fuentes sin duplicar información. |
| **Fuentes** | BPO, BPG, BIDO, BTPL, BESS, patrones clínicos, reglas organizacionales |
| **Protocolo** | Consulta vía `POST /bik/knowledge/fuse` con lista de fuentes y query |
| **Salida** | Conocimiento fusionado con nivel de confianza agregado |

### 4.6. Global State Manager

| Atributo | Valor |
|----------|-------|
| **Propósito** | Mantiene el estado global de la plataforma: casos abiertos, sesiones activas, simulaciones en curso, tareas pendientes. |
| **Protocolo** | Event-driven: escucha `STATE_CHANGED` de todos los motores |
| **Almacenamiento** | Redis (caché) + PostgreSQL (persistencia) |

### 4.7. Intelligence Coordination Bus

| Atributo | Valor |
|----------|-------|
| **Propósito** | Bus interno de inteligencia. Transporta solicitudes coordinadas entre motores (no datos clínicos completos). |
| **Protocolo** | Redis Streams / FastAPI BackgroundTasks |
| **Garantía** | Los datos clínicos nunca viajan completos por el bus; solo las solicitudes y metadatos. |

### 4.8. Goal Management Engine

| Atributo | Valor |
|----------|-------|
| **Propósito** | Entiende los objetivos del sistema en cada momento (preparar sesión, crear tratamiento, evaluar progreso). |
| **Protocolo** | Consulta vía `GET /bik/goals/active` |
| **Entrada** | Workflow actual + contexto del paciente |
| **Salida** | Lista priorizada de objetivos con motores asociados |

### 4.9. Cognitive Workflow Engine

| Atributo | Valor |
|----------|-------|
| **Propósito** | Orquesta procesos complejos multi-paso: Ingreso → Evaluación → Formulación → Tratamiento → Seguimiento. |
| **Protocolo** | Workflow definitions (Python) + Temporal.io para ejecución distribuida |
| **Garantía** | Cada paso es idempotente; fallos parciales no corrompen el estado. |

### 4.10. Multi-Agent Coordination Engine

| Atributo | Valor |
|----------|-------|
| **Propósito** | Coordina múltiples agentes de IA especializados: análisis funcional, neuropsicológico, de pareja, familiar, documentación, administrativo. |
| **Protocolo** | Registro vía Intelligence Registry + asignación vía Orchestrator |
| **Ciclo de vida** | Creación → Asignación → Ejecución → Resultado → Cleanup |

### 4.11. Explainability Coordinator

| Atributo | Valor |
|----------|-------|
| **Propósito** | Centraliza la explicación de decisiones. Reutiliza la infraestructura del BXE. |
| **Protocolo** | Delega a BXE: `POST /bxe/explain` con el contexto de la decisión |
| **Garantía** | Toda salida inteligente puede reconstruir su cadena de razonamiento. |

### 4.12. Conflict Resolution Engine

| Atributo | Valor |
|----------|-------|
| **Propósito** | Detecta cuando dos motores proponen cosas distintas y las presenta al terapeuta. |
| **Ejemplo** | BPAS sugiere reducir carga; BDSS considera oportuno mantenerla → BIK identifica el conflicto, muestra ambas alternativas y sus fundamentos. |
| **Regla** | **Nunca decide por sí mismo.** Siempre escala al terapeuta. |

### 4.13. Policy Enforcement Engine

| Atributo | Valor |
|----------|-------|
| **Propósito** | Garantiza que todas las acciones respeten reglas clínicas, políticas organizacionales, licencias (BLES) y permisos (BCGS). |
| **Protocolo** | Interceptor: toda acción pasa por este motor antes de ejecutarse |
| **Fallo** | Si una política bloquea la acción, se genera un evento `POLICY_VIOLATION` y se notifica al terapeuta. |

### 4.14. Trust & Confidence Manager

| Atributo | Valor |
|----------|-------|
| **Propósito** | Integra niveles de confianza de múltiples motores. Si el contexto es insuficiente, indica "Se requiere más información." |
| **Protocolo** | Consulta vía `GET /bik/trust/{patient_id}/{decision_type}` |
| **Umbral** | Confianza < 0.5 → requiere intervención humana; 0.5-0.7 → sugiere; > 0.7 → ejecuta. |

### 4.15. Resource Allocation Engine

| Atributo | Valor |
|----------|-------|
| **Propósito** | Optimiza uso de recursos computacionales: priorizar procesos interactivos, diferir análisis pesados, reutilizar resultados previos. |
| **Protocolo** | Interno al BIK, consulta vía `GET /bik/resources/available` |

### 4.16. Learning Governance Engine

| Atributo | Valor |
|----------|-------|
| **Propósito** | Gestiona la evolución de modelos. **No permite aprendizaje automático del comportamiento clínico.** |
| **Regla** | Nuevos modelos, reglas o versiones deben ser validados y publicados por el equipo antes de entrar en producción. |
| **Protocolo** | Publicación vía `POST /bik/governance/publish` con aprobación obligatoria. |

### 4.17. Intelligence Registry

| Atributo | Valor |
|----------|-------|
| **Propósito** | Catálogo de todos los motores inteligentes: versión, capacidades, dependencias, estado. |
| **Protocolo** | Registro vía `POST /bik/registry/register`; consulta vía `GET /bik/registry/{engine_id}` |
| **Garantía** | El Kernel siempre sabe qué componentes existen. |

### 4.18. Kernel Monitoring Engine

| Atributo | Valor |
|----------|-------|
| **Propósito** | Monitorea rendimiento, tiempos de respuesta, disponibilidad, errores y coordinación entre motores. |
| **Protocolo** | Exporta métricas vía OpenTelemetry → Prometheus → Grafana |
| **Alertas** | Latencia > 500ms, tasa de error > 1%, motor no disponible |

### 4.19. Behavioral AI Runtime

| Atributo | Valor |
|----------|-------|
| **Propósito** | Entorno donde viven los agentes de IA. Gestiona ciclo de vida, aislamiento, comunicación y recursos. |
| **No contiene** | Lógica clínica (eso vive en los motores especializados) |
| **Protocolo** | Integración con Gemma, MediaPipe, Whisper via BRIL adapters |

### 4.20. Kernel API

| Atributo | Valor |
|----------|-------|
| **Propósito** | Única puerta de entrada para procesos inteligentes complejos que requieren coordinación multi-motor. |
| **Protocolo** | REST (`/api/v1/bik/...`) + WebSocket para tiempo real |
| **Versiónado** | Semántico (MAJOR.MINOR.PATCH), rutas versionadas |

---

## 5. Protocolos de Comunicación entre Motores

### 5.1. Comunicación Directa vs. Coordinada por BIK

| Tipo | Cuándo se usa | Ejemplo |
|------|---------------|---------|
| **Directa (mismo dominio)** | Motores del mismo dominio clínico que no requieren coordinación global | BCI → BCAS (intake genera evaluación) |
| **Coordinada por BIK** | Operaciones que involucran múltiples dominios o requieren contexto global | Nuevo paciente → BIK coordina BCI + BCAS + BDF + BPAS |

### 5.2. Protocolos Soportados

| Protocolo | Uso | Ejemplo |
|-----------|-----|---------|
| **REST síncrono** | Consultas inmediatas, comandos con respuesta | `GET /bik/context/{id}` |
| **Eventos asíncronos** | Actualizaciones de estado, notificaciones | `TWIN_UPDATED`, `ASSESSMENT_COMPLETED` |
| **WebSocket** | Comunicación en tiempo real | Chat con TCCN, HUD de videoterapia |
| **Redis Streams** | Bus de coordinación interna del BIK | `bik:coordination:bus` |

### 5.3. Contratos de Interfaz entre Módulos

```
┌──────────────┐     REST/WS      ┌──────────────┐
│  Módulo A     │◄───────────────►│  BIK API      │
│  (ej. BCAS)   │                  │               │
└──────────────┘                  └──────┬───────┘
                                         │
                                    Redis Streams
                                         │
                                  ┌──────┴───────┐
                                  │  Motor B      │
                                  │  (ej. BDSS)   │
                                  └──────────────┘
```

**Regla**: Los módulos pueden interactuar directamente cuando la comunicación es intra-dominio. Las operaciones que requieren coordinación multi-motor pasan por el BIK.

---

## 6. Filosofía: BCA (Behavioral Cognitive Architecture)

El BIK es la **implementación** del BCA (Behavioral Cognitive Architecture). El BCA es el **marco conceptual** que define:

- Cómo se comparte el contexto
- Cómo se representan los objetivos
- Cómo se intercambian explicaciones
- Cómo se resuelven conflictos
- Cómo se manejan niveles de confianza
- Cómo colaboran los agentes especializados

Analogía:
- TCP/IP define cómo se comunican las redes
- POSIX define cómo interactúan los sistemas Unix
- **BCA define cómo piensa Behavioral**

El BCA no es un módulo ejecutable. Es el documento fundacional que permite incorporar nuevos motores sin romper la coherencia del ecosistema.

---

## 7. Integración con el Ecosistema

| Capa/Domain | Motores | Tipo de coordinación |
|-------------|---------|---------------------|
| **Clinical Core** | BCI, BCAS, BCMS, BIMS, BCIE, BCOE | Orquestación directa vía BIK |
| **Clinical Knowledge** | BPO, BPG, BPG-M, BIDO, BTPL, BTC, BML, BPL, BESS | Knowledge Fusion Engine |
| **Data Layer** | BDF, BARS | Global State Manager + Monitoring |
| **Adaptive Intelligence** | BPAS, BDTE | Reasoning Router + Goal Management |
| **Decision Intelligence** | BDSS | Conflict Resolution + Trust Manager |
| **Explainability** | BXE | Explainability Coordinator |
| **Governance** | BCGS, BLES | Policy Enforcement Engine |
| **Extension** | BDIS | Intelligence Registry + AI Runtime |
| **Research** | BERL, BSC | Learning Governance Engine |

---

## 8. Criterios de Validación

| Criterio | Métrica | Herramienta |
|----------|---------|-------------|
| Coordinación | Todos los motores son alcanzables vía BIK | Health checks automatizados |
| Latencia | Coordinación multi-motor < 500ms end-to-end | Monitoreo de rendimiento |
| Trazabilidad | Cada decisión coordinada tiene evento registrado | Auditoría automática |
| Resiliencia | Si un motor falla, el sistema funciona en modo degradado | Chaos engineering |
| Extensibilidad | Nuevo motor registrado y disponible en < 5 minutos | Pruebas de integración |

---

## 9. El Manifiesto del BIK

> *"Un hospital sin dirección médica es un caos de especialistas aislados.*
>
> *El BIK no es un especialista más. Es la dirección médica del ecosistema.*
>
> *No reemplaza el juicio del terapeuta. Lo potencia, coordinando toda la inteligencia disponible para que cada decisión clínica esté respaldada por el conocimiento completo del sistema.*
>
> *Si la arquitectura es el plano del hospital, el BIK es su sistema nervioso central."*

---

## 10. Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2026-07-14 | Arquitectura Jefe | Creación del documento. Definición de 20 submotores, diagrama de interacción, flujo de datos, protocolos de comunicación y contratos de interfaz. |

---

**Fin del documento `bik-architecture.md`**
