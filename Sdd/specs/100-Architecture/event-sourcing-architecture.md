---
id: ESA-001
title: Arquitectura de Event Sourcing y Datos Derivados
version: 1.0.0
status: Draft
owner: Arquitectura de Software & Backend
last_updated: 2026-07-14
depends_on:
  - 100-Architecture/system-architecture.md (BEA)
  - 200-Backend (FastAPI, Redis, PostgreSQL)
exports:
  - Event Stream como System of Record
  - Patrón de Datos Derivados (Derived Data)
  - Estrategia de migración Strangler Fig
  - Contratos de Database Views como API pública
  - Filosofía de Deep Modules (Ousterhout)
  - Stack tecnológico: Redis Streams, FastAPI BackgroundTasks, PostgreSQL LISTEN/NOTIFY
used_by:
  - BIK (Behavioral Intelligence Kernel)
  - BPO (Behavioral Process Ontology)
  - BPG (Behavioral Process Graph)
  - Todos los motores clínicos que consumen eventos
  - BRIL (Behavioral Runtime Integration Layer)
  - BPOS (Behavioral Practice OS)
  - BARS (Behavioral Analytics & Reporting System)
---

# BehavioralOS — Arquitectura de Event Sourcing y Datos Derivados

> *"En lugar de que el backend intente calcular el estado mental, guardar el historial y actualizar los juegos del paciente en un solo paso síncrono, el sistema funcionará de forma asíncrona mediante un Flujo Vivo de Eventos."*

---

## 1. Propósito y Alcance

### 1.1. Propósito

Este documento define la **arquitectura de datos del BehavioralOS** basada en Event Sourcing y el patrón de Datos Derivados. Establece:

- El **Event Stream** como System of Record (fuente de verdad inmutable)
- **Motores especializados** que observan el flujo de eventos y extraen datos derivados de forma asíncrona
- Una **estrategia de migración incremental** usando el patrón Strangler Fig
- **Database Views** como contrato público para evitar Breaking Changes
- **Deep Modules** (filosofía Ousterhout) para encapsular complejidad

### 1.2. Alcance

El documento cubre:

- Arquitectura del Event Stream (fuente de verdad)
- Patrón de Datos Derivados (motores que observan el flujo)
- Stack tecnológico (Redis Streams, FastAPI, PostgreSQL)
- Garantías ante fallos parciales, mantenibilidad y escalabilidad
- Estrategia de migración incremental (Strangler Fig)
- Vistas de Base de Datos como contrato público
- Filosofía de diseño: Deep Modules

### 1.3. Principio Fundamental

> **"El Event Stream es la única fuente de verdad. Todo lo demás son vistas derivadas de ese stream. Si pierdes una vista, la regeneras. Si pierdes el stream, pierdes la verdad."**

---

## 2. Event Stream como System of Record

### 2.1. Concepto

El Event Stream es un **log inmutable** de todos los eventos conductuales, clínicos y operativos del sistema. Cada interacción del paciente (chat, juego, evaluación, EMA, wearable) emite un evento al stream. Los motores especializados observan este stream y extraen lo que necesitan sin afectarse entre sí.

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        EVENT STREAM (System of Record)                  │
│                        ─── Log Inmutable ───                            │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  evt_001  evt_002  evt_003  evt_004  evt_005  evt_006  evt_007  ...   │
│  ───────  ───────  ───────  ───────  ───────  ───────  ───────        │
│  Chat     Juego    EMA      Chat     Evaluac. Sensor   Chat           │
│  casual   BERL     diario   continuo MPFI     wearable continuo       │
│                                                                         │
│  Cada evento es:                                                        │
│  • Inmutable (nunca se modifica)                                       │
│  • Secuencial (orden total)                                            │
│  • Autodescriptivo (contiene todo su contexto)                         │
│  • Trazable (id, timestamp, source, patient_id)                        │
│                                                                         │
├─────────────────────────────────────────────────────────────────────────┤
│  SISTEMAS DERIVADOS que observan el stream:                            │
│                                                                         │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌────────────┐ │
│  │ RFT Engine   │  │ ACT Hexaflex │  │ FAP CRB      │  │ BPG Updater│ │
│  │ (grafos RFT) │  │ (puntuaciones)│  │ (conductas)  │  │ (grafo)    │ │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘  └─────┬──────┘ │
│         │                 │                 │                │         │
│         ▼                 ▼                 ▼                ▼         │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌────────────┐ │
│  │ Neo4j /      │  │ PostgreSQL   │  │ PostgreSQL   │  │ PostgreSQL │ │
│  │ PostgreSQL   │  │ (scores)     │  │ (CRBs)       │  │ (grafo)    │ │
│  │ (grafos)     │  │              │  │              │  │            │ │
│  └──────────────┘  └──────────────┘  └──────────────┘  └────────────┘ │
│                                                                         │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐                 │
│  │ Behavioral   │  │ BXE          │  │ BARS         │                 │
│  │ Twin Updater │  │ (Explicab.)  │  │ (Analytics)  │                 │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘                 │
│         │                 │                 │                          │
│         ▼                 ▼                 ▼                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐                 │
│  │ PostgreSQL   │  │ PostgreSQL   │  │ DuckDB/S3    │                 │
│  │ (Twin JSONB) │  │ (trazas)     │  │ (OLAP)       │                 │
│  └──────────────┘  └──────────────┘  └──────────────┘                 │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### 2.2. Estructura de un Evento

```json
{
  "event_id": "evt_7f3a2b1c-4d5e-6f78-9a0b-c1d2e3f4a5b6",
  "event_type": "CONVERSATION_MESSAGE",
  "event_version": "1.0.0",
  "timestamp": "2026-07-14T14:30:00.123Z",
  "stream_id": "patient:pat_abc123",
  "sequence": 42,
  "source": {
    "engine": "TCCN",
    "version": "2.1.0",
    "session_id": "sess_9z8y7x"
  },
  "payload": {
    "message": "Siento que no sirvo para nada y evito salir",
    "language": "es-MX",
    "modality": "text",
    "context": {
      "time_of_day": "afternoon",
      "device": "mobile",
      "location": "home"
    }
  },
  "metadata": {
    "schema_version": "1.0.0",
    "correlation_id": "corr_abc123",
    "causation_id": "evt_prev_001"
  }
}
```

### 2.3. Tipos de Eventos

| Categoría | Evento | Fuente | Frecuencia |
|-----------|--------|--------|------------|
| **Conductual** | `CONVERSATION_MESSAGE` | TCCN (chat) | En tiempo real |
| **Conductual** | `CONVERSATION_ANALYZED` | TCCN (post-análisis) | Tras cada interacción |
| **Terapéutico** | `EXERCISE_STARTED` | BERL | Por sesión de juego |
| **Terapéutico** | `EXERCISE_TELEMETRY` | BERL | Continuo durante juego |
| **Terapéutico** | `EXERCISE_FINISHED` | BERL | Al completar juego |
| **Evaluación** | `ASSESSMENT_STARTED` | BCAS/BAD | Al iniciar evaluación |
| **Evaluación** | `ASSESSMENT_COMPLETED` | BCAS/BAD | Al completar evaluación |
| **Evaluación** | `ASSESSMENT_ITEM_RESPONSE` | BCAS/BAD | Por reactivo |
| **Clínico** | `SESSION_COMPLETED` | BCMS | Al finalizar sesión |
| **Clínico** | `HYPOTHESIS_UPDATED` | BDSS/BARS | Tras nueva evidencia |
| **Clínico** | `INTERVENTION_PRESCRIBED` | BIMS | Al prescribir intervención |
| **Operativo** | `APPOINTMENT_CREATED` | BCMS | Al agendar cita |
| **Operativo** | `PATIENT_REGISTERED` | BCI | Al registrar paciente |
| **EMA** | `EMA_RESPONSE` | Patient App | Diario / varias veces |
| **Sensor** | `SENSOR_DATA` | Wearables | Continuo |
| **Terapeuta** | `THERAPIST_FEEDBACK` | BPOS | Tras cada sesión |

### 2.4. Propiedades del Event Stream

| Propiedad | Descripción | Garantía |
|-----------|-------------|----------|
| **Inmutabilidad** | Una vez escrito, un evento nunca se modifica ni elimina | Append-only log |
| **Orden total** | Los eventos tienen un orden secuencial por stream | Sequence numbers |
| **Autodescriptivo** | Cada evento contiene todo su contexto | Schema validado |
| **Idempotencia** | Procesar el mismo evento dos veces no causa efectos duplicados | Event ID único |
| **Trazabilidad** | Cada evento puede rastrearse hasta su fuente | Source metadata |

---

## 3. Patrón de Datos Derivados

### 3.1. Concepto

Los **Datos Derivados** son el resultado de procesar el Event Stream para extraer información específica. Cada motor especializado observa el stream, procesa los eventos relevantes, y genera datos derivados que almacena en su propio almacén.

**Principio clave**: Si pierdes un dato derivado, lo regeneras re-procesando el Event Stream. Si pierdes el Event Stream, pierdes la verdad.

### 3.2. Motores Derivados Principales

#### 3.2.1. RFT Engine (Relational Frame Theory)

| Atributo | Valor |
|----------|-------|
| **Eventos que consume** | `CONVERSATION_MESSAGE`, `CONVERSATION_ANALYZED` |
| **Dato derivado** | Grafos de marcos relacionales del paciente |
| **Almacenamiento** | Neo4j o PostgreSQL (JSONB) |
| **Frecuencia de actualización** | Tras cada conversación |
| **Procesamiento** | Extracción de marcos (coordinación, distinción, oposición) + propagación de funciones |

```python
# Ejemplo: procesador derivado RFT
async def procesar_derivado_rft(evento: dict):
    """Deriva datos hacia la base de grafos RFT."""
    # 1. Extraer marcos relacionales del texto
    marcos = extraer_marcos(evento['payload']['message'])
    # 2. Actualizar grafo del paciente
    for marco in marcos:
        await actualizar_grafo_rft(
            patient_id=evento['stream_id'],
            nodo_origen=marco.source,
            nodo_destino=marco.target,
            tipo=marco.type,
            fuerza=marco.strength
        )
    # 3. Propagar funciones relacionales
    await propagar_funciones(evento['stream_id'])
```

#### 3.2.2. ACT Hexaflex Engine

| Atributo | Valor |
|----------|-------|
| **Eventos que consume** | `CONVERSATION_ANALYZED`, `EXERCISE_FINISHED`, `ASSESSMENT_COMPLETED`, `EMA_RESPONSE` |
| **Dato derivado** | Puntuaciones del Hexaflex (6 procesos: aceptación, defusión, presente, yo como contexto, valores, acción comprometida) |
| **Almacenamiento** | PostgreSQL (tabla `hexaflex_scores`) |
| **Frecuencia de actualización** | Tras cada evento relevante |
| **Procesamiento** | Normalización psicométrica + actualización bayesiana |

```python
# Ejemplo: procesador derivado ACT Hexaflex
async def procesar_derivado_act_hexaflex(evento: dict, analisis: dict):
    """Calcula y actualiza la matriz numérica del Hexaflex."""
    # 1. Extraer puntuaciones del análisis
    procesos = analisis.get('procesos_emmi', {})
    # 2. Aplicar normalización psicométrica
    scores_normalizados = normalizar_psicometricamente(procesos)
    # 3. Actualizar scores en base de datos
    await actualizar_hexaflex(
        patient_id=evento['stream_id'],
        scores=scores_normalizados,
        confidence=calcular_confianza(evento),
        source=evento['source']['engine']
    )
```

#### 3.2.3. FAP CRB Engine (Functional Analytic Psychotherapy)

| Atributo | Valor |
|----------|-------|
| **Eventos que consume** | `CONVERSATION_ANALYZED`, `SESSION_COMPLETED` |
| **Dato derivado** | Clasificación de Conductas Clínicamente Relevantes (CRB1, CRB2, CRB3) |
| **Almacenamiento** | PostgreSQL (tabla `crb_classifications`) |
| **Frecuencia de actualización** | Tras cada conversación o sesión |
| **Procesamiento** | Clasificación de secuencias de texto en busca de CRBs |

#### 3.2.4. BPG Updater (Behavioral Process Graph)

| Atributo | Valor |
|----------|-------|
| **Eventos que consume** | `ASSESSMENT_COMPLETED`, `EXERCISE_FINISHED`, `HYPOTHESIS_UPDATED`, `INTERVENTION_PRESCRIBED` |
| **Dato derivado** | Grafo global de procesos del paciente (actualización del BPG) |
| **Almacenamiento** | PostgreSQL (JSONB) + NetworkX (en memoria para análisis) |
| **Frecuencia de actualización** | Tras cada evento clínico relevante |
| **Procesamiento** | Recálculo de relaciones entre procesos + detección de ciclos + priorización |

#### 3.2.5. Behavioral Twin Updater

| Atributo | Valor |
|----------|-------|
| **Eventos que consume** | Todos los eventos clínicos relevantes |
| **Dato derivado** | Snapshot actualizado del Behavioral Twin |
| **Almacenamiento** | PostgreSQL (tabla `behavioral_twin`) |
| **Frecuencia de actualización** | Tras cada evento clínico |
| **Procesamiento** | Actualización de las 9 capas del Twin + propagación bayesiana |

#### 3.2.6. BXE Processor (Explainability)

| Atributo | Valor |
|----------|-------|
| **Eventos que consume** | `DECISION_MADE` (de cualquier motor) |
| **Dato derivado** | Trazas de explicabilidad, narrativas, grafos de trazabilidad |
| **Almacenamiento** | PostgreSQL (tablas `decision_traces`, `explainability_graphs`) |
| **Frecuencia de actualización** | Tras cada decisión clínica |

#### 3.2.7. BARS Aggregator (Analytics)

| Atributo | Valor |
|----------|-------|
| **Eventos que consume** | Todos los eventos (agregados) |
| **Dato derivado** | KPIs diarios, métricas de adherencia, dashboards |
| **Almacenamiento** | DuckDB / Parquet en S3 (OLAP) |
| **Frecuencia de actualización** | Batch diario + micro-batch horario |

---

## 4. Garantías del Sistema

### 4.1. Fiabilidad ante Fallos Parciales

> **"Si el servidor de grafos Neo4j o el módulo de cálculo numérico sufre una caída, la IA (Gemma 4) puede seguir hablando perfectamente con el paciente a través de la PWA. Los eventos quedan guardados de forma segura en el log y se procesarán en cuanto los sistemas derivados se recuperen."**

| Fallo | Impacto | Recuperación |
|-------|---------|--------------|
| Neo4j cae | No se actualizan grafos RFT | Replay del stream al recuperar |
| PostgreSQL cae | No se guardan scores Hexaflex | Replay del stream + caché Redis |
| BXE cae | No se generan explicaciones | Replay al recuperar, datos no se pierden |
| BARS cae | No se actualizan dashboards | Batch reprocesado al recuperar |
| **Event Stream cae** | **CRÍTICO: se pierde la verdad** | **Backup + replicación síncrona** |

### 4.2. Mantenibilidad

> **"Si mañana deseas agregar el módulo de Análisis de Cadena Conductual de DBT o el de Perfil Cognitivo de Neuropsicología, no tienes que tocar el código del chat. Simplemente agregas una nueva función que escuche el evento de dominio independiente."**

```python
# Agregar un nuevo motor derivado es trivial:
async def procesar_derivado_dbt_chain_analysis(evento: dict):
    """Nuevo motor: análisis de cadena conductual de DBT."""
    # 1. Filtrar eventos relevantes
    if evento['event_type'] not in ['CONVERSATION_ANALYZED', 'SESSION_COMPLETED']:
        return
    # 2. Procesar
    chain = analizar_cadena_conductual(evento['payload'])
    # 3. Almacenar resultado derivado
    await guardar_cadena_dbt(patient_id=evento['stream_id'], chain=chain)

# Registrar el nuevo motor en el orquestador
background_tasks.add_task(procesar_derivado_dbt_chain_analysis, evento)
```

### 4.3. Escalabilidad

| Componente | Estrategia de escalabilidad |
|------------|---------------------------|
| Event Stream (Redis Streams) | Particionado por `stream_id` (patient_id), múltiples consumers |
| RFT Engine | Horizontal: múltiples workers consumiendo diferentes particiones |
| ACT Hexaflex | Stateless: cada worker maneja pacientes independientes |
| PostgreSQL | Read replicas para consultas, write primary para escrituras |
| BARS (analytics) | Batch processing con DuckDB/Parquet, separado del OLTP |

---

## 5. Estrategia Strangler Fig para Migración Incremental

### 5.1. Concepto

Siguiendo el patrón de Sam Newman (*Monolith to Microservices*), el código PWA web inicial funciona como la **estructura base (tronco)**. Conforme se crean nuevos motores y flujos, los **interceptores redirigen el tráfico** hacia las nuevas funcionalidades de forma incremental.

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    PATRÓN STRANGLER FIG                                 │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  FASE 1: Monolito inicial                                              │
│  ┌──────────────────────────────────────────────┐                      │
│  │  Backend Monolítico (FastAPI + SQLite)        │                      │
│  │  - Chat del paciente                          │                      │
│  │  - Cálculos clínicos                          │                      │
│  │  - Almacenamiento                             │                      │
│  └──────────────────────────────────────────────┘                      │
│                                                                         │
│  FASE 2: Strangler Fig — primer corte                                  │
│  ┌────────────────────┐  ┌──────────────────────┐                      │
│  │  Nuevo: Streaming   │  │  Monolito (tronco)   │                      │
│  │  SSE + Gemma 4      │  │  - Cálculos restantes │                      │
│  │  (higuera nueva)    │  │  - Almacenamiento     │                      │
│  └────────────────────┘  └──────────────────────┘                      │
│  Feature flag: usarNuevoStreamingPBP = true                             │
│                                                                         │
│  FASE 3: Más ramas de la higuera                                       │
│  ┌────────────┐ ┌────────────┐ ┌────────────┐ ┌──────────────────┐    │
│  │ Streaming   │ │ Event      │ │ RFT Engine │ │ Monolito          │    │
│  │ SSE         │ │ Sourcing   │ │ (grafos)   │ │ (lo que queda)    │    │
│  └────────────┘ └────────────┘ └────────────┘ └──────────────────┘    │
│                                                                         │
│  FASE 4: Monolito completamente estrangulado                           │
│  ┌────────────┐ ┌────────────┐ ┌────────────┐ ┌────────────┐         │
│  │ Streaming   │ │ Event      │ │ RFT Engine │ │ ACT Hexaflex│        │
│  │ SSE         │ │ Sourcing   │ │            │ │             │        │
│  └────────────┘ └────────────┘ └────────────┘ └────────────┘         │
│  ┌────────────┐ ┌────────────┐ ┌────────────┐ ┌────────────┐         │
│  │ FAP CRB    │ │ BPG Updater│ │ Twin       │ │ BXE         │        │
│  │            │ │            │ │ Updater    │ │             │        │
│  └────────────┘ └────────────┘ └────────────┘ └────────────┘         │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### 5.2. Implementación: StranglerRouter

```javascript
// router.js - Implementación del Patrón Strangler Fig en el Frontend
class StranglerRouter {
  constructor() {
    this.featureFlags = {
      usarNuevoStreamingPBP: true,       // Redirigido a la higuera nueva
      usarEventSourcing: true,           // Event Sourcing activo
      usarCalculoHexaflexAntiguo: false  // Sigue en el tronco original
    };
  }

  async enrutarPeticion(endpoint, datosPayload) {
    // Streaming SSE — redirigido al nuevo motor
    if (endpoint === '/api/chat' && this.featureFlags.usarNuevoStreamingPBP) {
      console.log("[Strangler Fig] Interceptando tráfico de chat. Desviando al nuevo motor de Streaming SSE.");
      return fetch('http://localhost:8000/api/chat/stream', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(datosPayload)
      });
    }

    // Event Sourcing — emitir evento en lugar de procesar directamente
    if (endpoint === '/api/behavioral/event' && this.featureFlags.usarEventSourcing) {
      console.log("[Strangler Fig] Evento dirigido al Event Stream.");
      return fetch('http://localhost:8000/api/events/emit', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(datosPayload)
      });
    }

    // Ruta por defecto: tráfico hacia el sistema base
    console.log("[Strangler Fig] Tráfico dirigido al tronco de la infraestructura base.");
    return fetch(`http://localhost:8000${endpoint}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(datosPayload)
    });
  }
}

const enrutadorClinico = new StranglerRouter();
```

### 5.3. Criterios de Migración

| Criterio | Condición para migrar del tronco a la higuera |
|----------|----------------------------------------------|
| **Estabilidad** | El nuevo motor pasa 2 semanas en producción sin incidentes |
| **Paridad funcional** | El nuevo motor cubre al menos el 95% de los casos del tronco |
| **Rendimiento** | Latencia ≤ a la del tronco |
| **Testing** | Cobertura de tests ≥ 80% |
| **Rollback** | Feature flag permite volver al tronco en < 1 minuto |

---

## 6. Database Views como Contrato Público (Zero Breaking Changes)

### 6.1. Concepto

Para evitar acoplamiento peligroso entre servicios, el backend central expone **Vistas Virtuales** como contrato público. Si el formato de almacenamiento cambia, solo se actualiza la vista; los consumidores siguen usando el mismo contrato sin enterarse del cambio.

> **"Si el formato de almacenamiento del psicólogo cambia, solo se actualiza la vista a nivel de base de datos; la IA y los microservicios externos seguirán consumiendo el mismo contrato sin enterarse del cambio (Zero Breaking Changes)."**

### 6.2. Implementación

```sql
-- database_vistas.py - Contrato de Datos mediante Vistas lógicas

-- 1. Tabla Troncal Monolítica (System of Record - Inmutable)
CREATE TABLE IF NOT EXISTS registro_conductual_bruto (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    paciente_id TEXT,
    texto_sesion TEXT,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. PATRÓN DATABASE VIEW: Vista virtual para la IA
CREATE VIEW IF NOT EXISTS vista_analisis_contextual AS
SELECT
    id AS evento_id,
    paciente_id AS anonimato_id,
    texto_sesion AS corpus_linguistico
FROM registro_conductual_bruto;

-- 3. Vista para el RFT Engine
CREATE VIEW IF NOT EXISTS vista_rft_input AS
SELECT
    id AS evento_id,
    paciente_id,
    texto_sesion AS texto_analizar,
    fecha_registro AS timestamp
FROM registro_conductual_bruto
WHERE texto_sesion IS NOT NULL;

-- 4. Vista para el ACT Hexaflex
CREATE VIEW IF NOT EXISTS vista_hexaflex_input AS
SELECT
    id AS evento_id,
    paciente_id,
    texto_sesion,
    fecha_registro
FROM registro_conductual_bruto;

-- 5. Vista para analytics (agregada, anonymized)
CREATE VIEW IF NOT EXISTS vista_analytics_input AS
SELECT
    paciente_id AS patient_anon,
    DATE(fecha_registro) AS day,
    COUNT(*) AS events_per_day
FROM registro_conductual_bruto
GROUP BY paciente_id, DATE(fecha_registro);
```

### 6.3. Garantía de Zero Breaking Changes

```
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│ Consumidor A  │    │ Consumidor B  │    │ Consumidor C  │
│ (RFT Engine)  │    │ (ACT Engine)  │    │ (BXE)         │
└──────┬───────┘    └──────┬───────┘    └──────┬───────┘
       │                   │                   │
       ▼                   ▼                   ▼
┌──────────────────────────────────────────────────────┐
│              DATABASE VIEWS (Contrato Público)        │
│  vista_rft_input    vista_hexaflex_input    vista_... │
└──────────────────────────┬───────────────────────────┘
                           │
                    Si cambia el esquema interno,
                    solo se actualiza la Vista.
                    Los consumidores no se enteran.
                           │
                           ▼
┌──────────────────────────────────────────────────────┐
│           TABLA TRONCAL (System of Record)            │
│           registro_conductual_bruto                   │
└──────────────────────────────────────────────────────┘
```

---

## 7. Deep Modules (Filosofía Ousterhout)

### 7.1. Principio

Siguiendo *A Philosophy of Software Design* de John Ousterhout:

> **"Un módulo es 'profundo' cuando ofrece un beneficio inmenso (funcionalidad) a un costo muy bajo (una interfaz pública diminuta)."**

### 7.2. Aplicación en BehavioralOS

| Módulo | Complejidad oculta | Interfaz pública |
|--------|-------------------|-----------------|
| **Pantalla3D** | Three.js, WebGL, cámaras, luces, mallas, bucles de renderizado | `.mostrarMensaje(texto)`, `.iniciarJuego(config)` |
| **Event Stream** | Redis Streams, particionado, replicación, replay | `.emitirEvento(evento)`, `.suscribirEventos(filtro)` |
| **RFT Engine** | NetworkX, extracción de marcos, propagación de funciones | `.analizarTexto(texto) → grafo` |
| **ACT Hexaflex** | Normalización psicométrica, actualización bayesiana | `.calcularScores(datos) → scores` |
| **BXE** | 14 submotores, grafos de trazabilidad, narrativa clínica | `.explicarDecision(contexto) → explicación` |

### 7.3. Regla de Diseño

> **"Ocultaremos las decisiones de diseño del motor gráfico. Si mañana decides cambiar Three.js por otra librería, no tendrás que modificar el chat del paciente ni el backend de eventos. El cambio será completamente local."**

---

## 8. Stack Tecnológico

### 8.1. Componentes

| Componente | Tecnología | Rol |
|------------|-----------|-----|
| **Event Stream** | Redis Streams | Log inmutable de eventos conductuales |
| **Orquestación** | FastAPI BackgroundTasks | Encolado de tareas derivadas |
| **Notificación** | PostgreSQL LISTEN/NOTIFY | Alertas en tiempo real entre servicios |
| **Almacenamiento relacional** | PostgreSQL (Supabase) | Datos estructurados + vistas |
| **Grafos** | NetworkX (en memoria) + PostgreSQL (persistencia) | RFT, BPG, ontología |
| **Analytics** | DuckDB / Parquet en S3 | Consultas OLAP sobre datos derivados |
| **Caché** | Redis | Estado de sesiones, caché semántica |
| **Workflows largos** | Temporal.io | Sagas, compensaciones, flujos multi-paso |

### 8.2. Diagrama de Implementación

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         FASTAPI APPLICATION                              │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  @app.post("/api/chat/stream")                                         │
│  async def stream_coterapeuta(body, background_tasks):                 │
│      │                                                                 │
│      ├── 1. Streaming SSE hacia la PWA (baja latencia)                │
│      │      yield f"data: {token}\n\n"                                │
│      │                                                                 │
│      ├── 2. Al completar: emitir_evento_dominio()                     │
│      │      │                                                          │
│      │      ├── background_tasks.add_task(rft_engine, evento)         │
│      │      ├── background_tasks.add_task(act_hexaflex, evento)       │
│      │      ├── background_tasks.add_task(fap_crb, evento)            │
│      │      ├── background_tasks.add_task(bpg_updater, evento)        │
│      │      ├── background_tasks.add_task(twin_updater, evento)       │
│      │      ├── background_tasks.add_task(bxe_processor, evento)      │
│      │      └── background_tasks.add_task(bars_aggregator, evento)    │
│      │                                                                 │
│      └── 3. Retornar StreamingResponse                                │
│                                                                         │
├─────────────────────────────────────────────────────────────────────────┤
│  REDIS STREAMS (Event Store)                                           │
│  ├── behavioral:events:main        (stream principal)                  │
│  ├── behavioral:events:patient:*   (stream por paciente)               │
│  └── behavioral:coordination:bus   (bus interno del BIK)               │
├─────────────────────────────────────────────────────────────────────────┤
│  POSTGRESQL (Supabase)                                                 │
│  ├── clinical.*               (datos clínicos)                        │
│  ├── commerce.*               (datos comerciales)                     │
│  ├── audit.*                  (logs de auditoría)                     │
│  └── VISTAS PÚBLICAS          (contrato para consumidores)            │
├─────────────────────────────────────────────────────────────────────────┤
│  POSTGRESQL LISTEN/NOTIFY                                              │
│  ├── notify 'twin_updated'      → suscriptores del Behavioral Twin    │
│  ├── notify 'assessment_done'   → motores que dependen de eval.       │
│  └── notify 'crisis_detected'   → alertas de seguridad                │
└─────────────────────────────────────────────────────────────────────────┘
```

### 8.3. Código de Ejemplo: Event Emitter

```python
import json
import asyncio
from datetime import datetime
from fastapi import FastAPI, BackgroundTasks
from fastapi.responses import StreamingResponse

app = FastAPI(title="BehavioralOS Event-Driven Backend")

# --- PROCESADORES DE DATOS DERIVADOS (ASÍNCRONOS) ---

async def procesar_derivado_rft(evento: dict):
    """Deriva datos hacia la base de grafos RFT."""
    await asyncio.sleep(0.01)  # Simula latencia de red
    print(f"[RFT Engine] Propagando funciones para: '{evento['payload']['message'][:30]}...'")

async def procesar_derivado_act_hexaflex(evento: dict, analisis: dict):
    """Calcula y actualiza puntuaciones del Hexaflex."""
    print(f"[ACT Engine] Recalculando puntuaciones del Hexaflex.")

async def procesar_derivado_fap_crb(analisis: dict):
    """Clasifica conductas clínicamente relevantes."""
    print(f"[FAP Engine] Clasificando en busca de CRB1, CRB2 o CRB3.")

async def procesar_derivado_bpg_updater(evento: dict):
    """Actualiza el grafo global de procesos."""
    print(f"[BPG Updater] Actualizando relaciones entre procesos.")

async def procesar_derivado_twin_updater(evento: dict, analisis: dict):
    """Actualiza el Behavioral Twin."""
    print(f"[Twin Updater] Actualizando las 9 capas del Twin.")

# --- ORQUESTADOR DE EVENTOS PRINCIPAL ---

def emitir_evento_dominio(background_tasks: BackgroundTasks, mensaje: str, analisis: dict):
    """
    Patrón Event-Driven: Publica un evento inmutable en el sistema.
    Los sistemas derivados reaccionan de manera independiente sin bloquear al usuario.
    """
    evento = {
        "id": f"evt_{int(asyncio.get_event_loop().time())}",
        "timestamp": datetime.utcnow().isoformat(),
        "event_type": "CONVERSATION_ANALYZED",
        "payload": {"message": mensaje},
        "analysis": analisis
    }

    # El sistema de registro almacena el hecho bruto de manera segura
    print(f"[System of Record] Evento {evento['id']} guardado de forma inmutable.")

    # Se encolan las tareas en segundo plano (Sistemas Derivados)
    background_tasks.add_task(procesar_derivado_rft, evento)
    background_tasks.add_task(procesar_derivado_act_hexaflex, evento, analisis)
    background_tasks.add_task(procesar_derivado_fap_crb, analisis)
    background_tasks.add_task(procesar_derivado_bpg_updater, evento)
    background_tasks.add_task(procesar_derivado_twin_updater, evento, analisis)

# --- ENDPOINT CON STREAMING ---

@app.post("/api/chat/stream")
async def stream_coterapeuta_intensivo(body: dict, background_tasks: BackgroundTasks):
    mensaje_paciente = body.get("mensaje", "")

    async def generador_eventos_sse():
        # 1. Streaming de baja latencia hacia la PWA
        # (Aquí iría la llamada a Gemma 4 con streaming)
        yield f"data: {{'respuesta': 'Procesando...'}}\n\n"

        # 2. Al finalizar, emitir evento de dominio
        analisis = {"procesos_emmi": {"evitacion": 0.75, "fusion": 0.82}}
        emitir_evento_dominio(background_tasks, mensaje_paciente, analisis)

    return StreamingResponse(generador_eventos_sse(), media_type="text/event-stream")
```

---

## 9. Estrategia de Migración Completa

### 9.1. Fases

| Fase | Descripción | Duración estimada |
|------|-------------|-------------------|
| **Fase 1** | Backend monolítico funcional (FastAPI + SQLite/PostgreSQL) | Semanas 1-4 |
| **Fase 2** | Strangler Fig: primer corte (Streaming SSE + Event Emitter) | Semanas 5-8 |
| **Fase 3** | Event Sourcing completo (Redis Streams + Derived Data) | Semanas 9-16 |
| **Fase 4** | Motores derivados especializados (RFT, ACT, FAP, BPG) | Semanas 17-24 |
| **Fase 5** | Database Views como contrato público | Semanas 25-28 |
| **Fase 6** | Monolito completamente estrangulado | Semanas 29-32 |

### 9.2. Rollback por Fase

Cada fase tiene un **feature flag** que permite volver a la fase anterior:

```javascript
const featureFlags = {
  fase1_monolito: true,           // Siempre activo como fallback
  fase2_streaming_sse: true,      // Streaming alternativo
  fase3_event_sourcing: false,    // Activar en Fase 3
  fase4_derived_engines: false,   // Activar en Fase 4
  fase5_database_views: false,    // Activar en Fase 5
  fase6_full_strangler: false     // Activar en Fase 6
};
```

---

## 10. Criterios de Validación

| Criterio | Métrica | Herramienta |
|----------|---------|-------------|
| Inmutabilidad | 0 eventos modificados o eliminados del stream | Auditoría de integridad |
| Tolerancia a fallos | Sistema sigue funcionando con 1 motor derivado caído | Chaos engineering |
| Latencia de streaming | < 200ms desde evento hasta procesamiento derivado | Monitoreo de rendimiento |
| Mantenibilidad | Nuevo motor derivado funcional en < 1 día | Pruebas de integración |
| Zero Breaking Changes | Consumidores no afectados por cambios en esquema interno | Pruebas de contratos |
| Escalabilidad | Soporte para > 10,000 eventos/segundo | Pruebas de carga (k6) |

---

## 11. El Manifiesto de Event Sourcing

> *"El Event Stream es la memoria inmutable del BehavioralOS.*
>
> *Cada chat, cada juego, cada evaluación, cada latido de wearable queda grabado en ese flujo. No se borra. No se modifica. Solo se lee.*
>
> *Los motores derivados son los científicos que observan ese flujo y extraen conocimiento. Si uno falla, lo reemplazas. Si pierdes su output, lo regeneras.*
>
> *Pero si pierdes el stream, pierdes la verdad.*
>
> *Por eso el Event Stream es la pieza más protegida, más replicada y más crítica de toda la arquitectura."*

---

## 12. Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2026-07-14 | Arquitectura Jefe | Creación del documento. Definición de Event Stream, Datos Derivados, Strangler Fig, Database Views, Deep Modules y stack tecnológico. |

---

**Fin del documento `event-sourcing-architecture.md`**
