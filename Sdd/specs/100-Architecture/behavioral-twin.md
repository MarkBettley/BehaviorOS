---
id: BT-001
title: Behavioral Twin
version: 1.0.0
status: Stable
owner: Arquitectura de Software & Psicología Clínica
last_updated: 2026-07-01
depends_on:
  - 000-Core/ontology.md (Ontología)
  - 100-Architecture/system-architecture.md (BEA)
  - 100-Architecture/engines-overview.md (BREO)
exports:
  - Estructura del Behavioral Twin (capas, componentes, atributos)
  - Mecanismos de actualización (eventos, reglas de inferencia)
  - APIs de consulta (sincrónicas y asíncronas)
  - Representación computacional (grafos, versionado, persistencia)
  - Estrategias de sincronización y consistencia
used_by:
  - AAO (Adaptive Assessment Orchestrator)
  - BERL (Behavioral Exercise Research Lab)
  - TCCN (Therapeutic Cognitive Companion)
  - AHEE (Adaptive Human Experience Engine)
  - MPO (Meta-Process Orchestrator)
  - BWM (Behavioral World Model)
  - BSC (Behavioral Science Cloud)
  - BPOS (Behavioral Practice OS)
  - BIP (Behavioral Intelligence Platform)
---

# BehavioralOS – Behavioral Twin

> *"El Behavioral Twin no es un expediente. Es un organismo digital que respira, aprende y cambia con el paciente. No almacena lo que el paciente *dice* que es; almacena lo que el paciente *hace*, en cada contexto, en cada momento, a lo largo del tiempo."*

---

## 1. Propósito y Alcance

### 1.1. Propósito
El Behavioral Twin es el **modelo computacional dinámico** que representa el estado funcional de un paciente en tiempo real. Su propósito es:

- **Integrar toda la información clínica** (entrevistas, evaluaciones, telemetría de ejercicios, sesiones, observaciones del terapeuta) en un único modelo coherente.
- **Proveer una fuente de verdad** para todos los motores clínicos (AAO, BERL, TCCN, MPO, etc.).
- **Actualizarse continuamente** con cada interacción del paciente, reflejando su estado actual y su trayectoria de cambio.
- **Representar hipótesis funcionales** con niveles de confianza explícitos, permitiendo que el sistema y el terapeuta tomen decisiones informadas.
- **Simular escenarios futuros** (junto con el BWM) para predecir trayectorias de cambio y riesgo de abandono.

### 1.2. Alcance
El Behavioral Twin cubre:

- **Historia de aprendizaje**: Contingencias pasadas, eventos significativos, patrones de conducta.
- **Repertorios conductuales**: Habilidades, frecuencia, variabilidad, generalización.
- **Redes RFT**: Marcos relacionales que organizan el lenguaje y la cognición.
- **Procesos psicológicos** (PBT): Estados actuales y trayectorias de cada proceso.
- **Contingencias activas**: Relaciones antecedente-conducta-consecuencia que mantienen patrones.
- **Hipótesis funcionales**: Explicaciones del comportamiento con niveles de confianza.
- **Valores** (ACT): Direcciones de vida y su coherencia con la conducta.
- **Niveles de confianza**: Para cada inferencia y estimación.
- **Contexto actual**: Variables situacionales (ubicación, compañía, hora, actividad).

### 1.3. Principio Fundamental
> **"El Behavioral Twin no juzga. No etiqueta. No diagnostica. Observa, modela y actualiza sus hipótesis con cada nuevo dato. Es un científico empírico que aprende sobre el paciente, no un juez que lo clasifica."**

---

## 2. Filosofía y Principios

### 2.1. Inspiración
El Behavioral Twin se inspira en:

| Fuente | Principio aplicado | Manifestación en el Twin |
|--------|---------------------|--------------------------|
| **Análisis Funcional (Skinner)** | El comportamiento es función de antecedentes y consecuencias. | Cada conducta se modela con su contexto y función. |
| **RFT (Hayes, Barnes-Holmes)** | El lenguaje organiza la cognición mediante marcos relacionales. | El Twin modela redes RFT como grafos dinámicos. |
| **PBT (Hayes, Hofmann)** | Los procesos son la unidad de análisis. | El Twin rastrea la evolución de procesos específicos. |
| **Terapia Basada en Procesos** | La intervención se dirige a procesos, no a diagnósticos. | El Twin prioriza procesos sobre categorías. |
| **Digital Twin (Industria 4.0)** | Modelo virtual que refleja un sistema físico. | El Twin refleja el estado funcional del paciente. |
| **Modelos Bayesianos** | La incertidumbre es explícita y se actualiza con evidencia. | Cada estimación tiene un nivel de confianza. |
| **Idiographic Approach** | Cada persona es única; no hay promedios. | El Twin es específico para cada paciente. |

### 2.2. Principios del Behavioral Twin

| # | Principio | Descripción | Criterio de cumplimiento |
|---|-----------|-------------|---------------------------|
| 1 | **Vivo y dinámico** | El Twin se actualiza con cada interacción (ejercicio, sesión, EMA, etc.). | El Twin tiene un timestamp de última actualización; la latencia de actualización es < 1 s. |
| 2 | **Probabilístico y con confianza** | Cada inferencia tiene un nivel de confianza explícito (0-1). | Todas las estimaciones incluyen un campo `confidence`. |
| 3 | **Contextual** | El Twin siempre considera el contexto de la conducta. | Cada nodo de conducta tiene una referencia al contexto. |
| 4 | **Idiográfico** | No hay plantillas fijas; el Twin se adapta a cada paciente. | Los procesos y relaciones son específicos del paciente. |
| 5 | **Trazable** | Cada actualización es auditada (quién, cuándo, qué datos). | El Twin mantiene un historial de cambios. |
| 6 | **Explicable** | El Twin puede explicar por qué tiene una cierta confianza en una hipótesis. | Cada hipótesis tiene evidencia a favor y en contra. |
| 7 | **Predictivo** | El Twin (junto con el BWM) puede simular escenarios futuros. | El Twin expone APIs de simulación. |
| 8 | **Ético y privado** | El Twin nunca almacena información identificable sin cifrar. | Todos los datos están cifrados y anonimizados para investigación. |

---

## 3. Estructura del Behavioral Twin

El Behavioral Twin se organiza en **9 capas** o **dimensiones**, cada una con sus propios componentes y atributos. Estas capas se actualizan con diferentes frecuencias y fuentes de datos.

┌─────────────────────────────────────────────────────────────────────────┐
│ Behavioral Twin (Vista Conceptual) │
├─────────────────────────────────────────────────────────────────────────┤
│ 1. Identidad y Datos Demográficos (estables, baja frecuencia) │
├─────────────────────────────────────────────────────────────────────────┤
│ 2. Historia de Aprendizaje (acumulativa, actualización incremental) │
├─────────────────────────────────────────────────────────────────────────┤
│ 3. Contextos (actualización dinámica, alta frecuencia) │
├─────────────────────────────────────────────────────────────────────────┤
│ 4. Repertorios Conductuales (actualización tras cada ejercicio/sesión) │
├─────────────────────────────────────────────────────────────────────────┤
│ 5. Procesos Psicológicos (PBT) (actualización tras cada evaluación) │
├─────────────────────────────────────────────────────────────────────────┤
│ 6. Redes RFT (actualización tras conversaciones y ejercicios RFT) │
├─────────────────────────────────────────────────────────────────────────┤
│ 7. Hipótesis Funcionales (actualización continua, bayesiana) │
├─────────────────────────────────────────────────────────────────────────┤
│ 8. Valores y Objetivos (actualización tras sesiones y reflexiones) │
├─────────────────────────────────────────────────────────────────────────┤
│ 9. Estado Actual y Predictivo (actualización en tiempo real) │
└─────────────────────────────────────────────────────────────────────────┘


### 3.1. Capa 1: Identidad y Datos Demográficos

| Atributo | Tipo | Descripción | Fuente | Frecuencia de actualización |
|----------|------|-------------|--------|----------------------------|
| `id` | UUID | Identificador único del paciente. | Registro | Una vez |
| `name` | String (cifrado) | Nombre del paciente. | Registro | Una vez |
| `age` | Integer | Edad en años. | Registro | Anual |
| `gender` | Enum | Identidad de género (opcional). | Registro | Una vez |
| `language` | String | Idioma principal. | Registro | Una vez |
| `timezone` | String | Zona horaria. | Registro | Una vez |
| `therapist_ref` | UUID | Identificador del terapeuta principal. | Registro | Variable |
| `organization_ref` | UUID | Identificador de la clínica/tenant. | Registro | Una vez |
| `created_at` | Timestamp | Fecha de creación del Twin. | Sistema | Una vez |
| `updated_at` | Timestamp | Fecha de última actualización. | Sistema | Cada actualización |

### 3.2. Capa 2: Historia de Aprendizaje

Esta capa almacena **eventos significativos** que han moldeado el repertorio del paciente. No es un registro cronológico exhaustivo, sino una selección de eventos funcionalmente relevantes.

| Atributo | Tipo | Descripción | Fuente | Frecuencia de actualización |
|----------|------|-------------|--------|----------------------------|
| `events` | Array de `Event` | Eventos significativos (pérdidas, mudanzas, logros, traumas, etc.). | Entrevista inicial, sesiones | Por sesión |
| `patterns` | Array de `Pattern` | Patrones de conducta recurrentes (ej. "evitación social después de críticas"). | AAO, análisis funcional | Cada evaluación |
| `learning_history` | JSON | Resumen de contingencias pasadas (ej. "reforzamiento negativo de evitación"). | Análisis funcional | Cada sesión |
| `milestones` | Array de `Milestone` | Hitos terapéuticos (ej. "primera exposición completada"). | BERL, BPOS | Tras cada hito |

**Estructura de un `Evento`**:
```json
{
  "id": "evt_001",
  "type": "pérdida",
  "description": "Fallecimiento del padre",
  "age_at_event": 12,
  "impact": "alto",
  "context": "familiar",
  "confidence": 0.95,
  "sources": ["entrevista_inicial", "sesion_3"]
}

Estructura de un Pattern:

{
  "id": "pat_001",
  "description": "Evitación de conversaciones difíciles con figuras de autoridad",
  "antecedents": ["crítica", "evaluación"],
  "behavior": "evitación",
  "consequences": ["alivio_inmediato", "aislamiento_largo_plazo"],
  "contexts": ["laboral", "familiar"],
  "confidence": 0.82,
  "evidence": ["sesion_2", "ejercicio_7", "EMA_14"]
}

3.3. Capa 3: Contextos
Esta capa modela los contextos relevantes para la conducta del paciente. Cada contexto tiene sus propias contingencias y procesos.

Atributo	Tipo	Descripción	Fuente	Frecuencia de actualización
contexts	Array de Context	Lista de contextos (trabajo, casa, pareja, familia, social, ocio, etc.).	Entrevista, AAO	Por evaluación
current_context	UUID	Contexto actual (si se conoce).	Sensores, agenda	Tiempo real
Estructura de un Context:

{
  "id": "ctx_001",
  "name": "Trabajo",
  "type": "laboral",
  "features": {
    "persons_present": ["jefe", "compañeros"],
    "activity": "reuniones",
    "stress_level": "alto"
  },
  "contingencies": [
    {
      "antecedent": "crítica del jefe",
      "behavior": "evitación de participación",
      "consequence": "alivio inmediato",
      "function": "reforzamiento_negativo"
    }
  ],
  "processes": {
    "avoidance": 0.85,
    "acceptance": 0.20,
    "defusion": 0.15
  },
  "confidence": 0.78
}

3.4. Capa 4: Repertorios Conductuales
Esta capa modela las habilidades y conductas del paciente, su frecuencia, variabilidad y generalización.

Atributo	Tipo	Descripción	Fuente	Frecuencia de actualización
repertoires	Array de Repertoire	Lista de repertorios (ej. asertividad, regulación emocional, etc.).	AAO, BERL	Tras cada ejercicio
generalization_index	Float (0-1)	Índice de generalización global.	Cálculo del sistema	Diario
Estructura de un Repertoire:

{
  "id": "rep_001",
  "name": "Asertividad",
  "behaviors": [
    {"description": "Expresar necesidades", "frequency": 0.6, "contexts": ["trabajo", "familia"]},
    {"description": "Decir 'no'", "frequency": 0.3, "contexts": ["trabajo"]}
  ],
  "frequency": 0.45,
  "variability": 0.60,
  "generalization": 0.50,
  "history": [
    {"timestamp": "2026-06-01", "frequency": 0.30},
    {"timestamp": "2026-06-15", "frequency": 0.45}
  ],
  "confidence": 0.72
}

3.5. Capa 5: Procesos Psicológicos (PBT)
Esta capa rastrea el estado de cada proceso psicológico (dominios y procesos específicos de PBT) y su evolución en el tiempo.

Atributo	Tipo	Descripción	Fuente	Frecuencia de actualización
processes	Array de ProcessState	Estado actual de cada proceso.	AAO, evaluaciones	Tras cada evaluación
trajectories	JSON	Series temporales de cada proceso.	AAO, BIP	Tras cada evaluación
Estructura de un ProcessState:

{
  "id": "proc_001",
  "name": "Aceptación",
  "domain": "Afectivo",
  "value": 0.65,
  "confidence": 0.82,
  "trajectory": [
    {"timestamp": "2026-06-01", "value": 0.45},
    {"timestamp": "2026-06-08", "value": 0.55},
    {"timestamp": "2026-06-15", "value": 0.65}
  ],
  "trend": "ascendente",
  "sources": ["MPFI", "ejercicio_12", "sesion_4"],
  "predictions": {
    "next_week": 0.72,
    "confidence": 0.65
  }
}

3.6. Capa 6: Redes RFT
Esta capa modela los marcos relacionales (RFT) que organizan el lenguaje y la cognición del paciente. Se representa como un grafo dirigido.

Atributo	Tipo	Descripción	Fuente	Frecuencia de actualización
nodes	Array de Node	Nodos del grafo (estímulos, eventos, conceptos).	RFT Engine	Tras cada conversación
edges	Array de Edge	Relaciones entre nodos (coordinación, distinción, etc.).	RFT Engine	Tras cada conversación
derived_relations	Array de DerivedRelation	Relaciones derivadas (mutua implicación, combinatoria).	RFT Engine	Tras cada conversación
Estructura de un Node:

{
  "id": "n_001",
  "label": "Yo",
  "type": "self",
  "attributes": {"valence": 0.3, "activation": 0.7}
}

Estructura de un Edge:

{
  "id": "e_001",
  "source": "n_001",
  "target": "n_002",
  "type": "coordinación",
  "strength": 0.85,
  "flexibility": 0.40,
  "confidence": 0.88,
  "history": [
    {"timestamp": "2026-06-01", "strength": 0.90},
    {"timestamp": "2026-06-15", "strength": 0.85}
  ]
}

3.7. Capa 7: Hipótesis Funcionales
Esta capa almacena las hipótesis funcionales activas sobre el comportamiento del paciente, con sus niveles de confianza y evidencia.

Atributo	Tipo	Descripción	Fuente	Frecuencia de actualización
hypotheses	Array de Hypothesis	Lista de hipótesis funcionales.	AAO, Análisis funcional	Tras cada evaluación/sesión
active_hypothesis	UUID	Hipótesis con mayor confianza (prioritaria).	Sistema	Tras cada actualización

Estructura de una Hypothesis (ver ontología para detalles completos):

{
  "id": "hyp_001",
  "description": "La evitación social se mantiene por reforzamiento negativo (alivio de la ansiedad) y está mediada por marcos de coordinación 'yo = fracaso'.",
  "antecedents": ["crítica social", "evaluación"],
  "behavior": "evitación de interacciones sociales",
  "consequences": ["alivio inmediato", "aislamiento"],
  "processes": ["avoidance_experiential", "fusion_cognitiva"],
  "relational_frames": [
    {"source": "yo", "target": "fracaso", "type": "coordinación", "strength": 0.85}
  ],
  "confidence": 0.68,
  "evidence_for": [
    {"source": "AAO", "confidence": 0.82, "date": "2026-06-15"},
    {"source": "BERL", "confidence": 0.65, "date": "2026-06-14"}
  ],
  "evidence_against": [
    {"source": "sesion_4", "confidence": 0.30, "date": "2026-06-10"}
  ],
  "status": "activa",
  "predictions": [
    {"if": "aumentar_aceptacion", "then": "disminuir_evitacion", "expected_effect": 0.5}
  ]
}

3.8. Capa 8: Valores y Objetivos (ACT)
Esta capa modela los valores del paciente y su coherencia con la conducta, así como los objetivos terapéuticos acordados.

Atributo	Tipo	Descripción	Fuente	Frecuencia de actualización
values	Array de Value	Lista de valores (ACT).	Sesiones, ejercicios	Tras cada sesión
goals	Array de Goal	Objetivos terapéuticos acordados.	Sesiones	Tras cada sesión
coherence_index	Float (0-1)	Índice de coherencia entre valores y conducta.	Cálculo del sistema	Tras cada ejercicio

Estructura de un Value (ver ontología):

{
  "id": "val_001",
  "name": "Conexión familiar",
  "domain": "familia",
  "behaviors": ["llamar a mis padres", "asistir a reuniones"],
  "barriers": ["evitación social", "crítica interna"],
  "coherence": 0.82,
  "confidence": 0.91
}

Estructura de un Goal:

{
  "id": "goal_001",
  "description": "Aumentar la frecuencia de contactos sociales significativos",
  "target_behavior": "iniciar conversaciones con familiares",
  "frequency": 3,
  "unit": "veces/semana",
  "progress": 0.6,
  "deadline": "2026-08-01",
  "confidence": 0.75
}

3.9. Capa 9: Estado Actual y Predictivo
Esta capa proporciona una foto instantánea del estado del paciente y sus predicciones a corto plazo.

Atributo	Tipo	Descripción	Fuente	Frecuencia de actualización
current_state	JSON	Estado actual (energía, sueño, estrés, motivación).	EMA, sensores	En tiempo real
risk	JSON	Riesgos estimados (abandono, recaída, crisis).	BWM, AAO	Diario
predictions	JSON	Predicciones a corto plazo (ej. adherencia en 7 días).	BWM, BIP	Diario
momentum	Float (0-1)	Índice de momentum (dirección del cambio).	Cálculo del sistema	Diario
fatigue	Float (0-1)	Nivel de fatiga estimado.	Telemetría, EMA	En tiempo real

Estructura de current_state:

{
  "energy": 0.7,
  "sleep_quality": 0.4,
  "stress": 0.6,
  "motivation": 0.8,
  "mood": 0.5,
  "last_updated": "2026-07-01T14:30:00Z",
  "confidence": 0.85
}

Estructura de risk:

{
  "dropout_risk": 0.25,
  "relapse_risk": 0.35,
  "crisis_risk": 0.10,
  "last_updated": "2026-07-01T14:30:00Z",
  "confidence": 0.72
}

Estructura de predictions:

{
  "adherence_7d": 0.65,
  "adherence_30d": 0.50,
  "process_improvement": {
    "acceptance": 0.08,
    "defusion": 0.12
  },
  "confidence": 0.60,
  "last_updated": "2026-07-01T14:30:00Z"
}

4. Mecanismos de Actualización
El Behavioral Twin se actualiza mediante un sistema de eventos que garantiza consistencia, trazabilidad y baja latencia.

4.1. Fuentes de Actualización
Fuente	Frecuencia	Evento	Actualización
AAO (Evaluación)	Tras cada evaluación	ASSESSMENT_COMPLETED	Actualiza capas 5, 6, 7
BERL (Ejercicio)	Tras cada ejercicio	EXERCISE_FINISHED	Actualiza capas 4, 5, 9
TCCN (Conversación)	Tras cada interacción	CONVERSATION_ANALYZED	Actualiza capas 6, 7
BPOS (Sesión)	Tras cada sesión	SESSION_COMPLETED	Actualiza capas 2, 7, 8
EMA (Auto-reporte)	Diario o varias veces al día	EMA_RESPONDED	Actualiza capa 9
Sensores (opcional)	Tiempo real	SENSOR_DATA	Actualiza capa 9
Terapeuta	Tras cada sesión	THERAPIST_FEEDBACK	Actualiza capas 7, 8, 9
4.2. Proceso de Actualización
Recepción del evento: BRIL recibe el evento de la fuente correspondiente.

Validación: Se valida que el evento esté completo y sea consistente con la ontología.

Actualización del Twin: El Behavioral Twin actualiza las capas correspondientes:

Actualización directa: Se actualiza el valor de un atributo (ej. puntuación de un proceso).

Inferencia: Se calculan nuevas estimaciones (ej. actualización bayesiana de una hipótesis).

Propagación: Se actualizan nodos relacionados (ej. si aumenta la aceptación, puede disminuir la evitación).

Registro de auditoría: Se registra quién, cuándo, qué datos y qué versión del Twin se actualizó.

Notificación: Se publica un evento TWIN_UPDATED para que otros motores (ej. MPO, AHEE) reaccionen.

4.3. Reglas de Inferencia
Actualización bayesiana: Las hipótesis se actualizan con el teorema de Bayes.

Propagación de confianza: La confianza de un nodo se propaga a los nodos relacionados (ej. si un proceso tiene alta confianza, los procesos relacionados reciben un incremento moderado).

Generalización: Si una conducta se generaliza a un nuevo contexto, el índice de generalización del repertorio aumenta.

Transformación RFT: Si se detecta un nuevo marco relacional, se añade al grafo y se actualiza la transformación de funciones.

4.4. Consistencia y Versionado
Versionado semántico: Cada actualización del Twin genera una nueva versión (MAJOR.MINOR.PATCH).

Consistencia eventual: Para actualizaciones de alta frecuencia (ej. telemetría), el Twin puede tener consistencia eventual.

Consistencia fuerte: Para actualizaciones clínicas críticas (ej. nueva hipótesis confirmada), se garantiza consistencia fuerte mediante transacciones ACID.

Historial: El Twin mantiene un historial completo de todas las versiones, permitiendo auditoría y retroceso.

5. Representación Computacional
5.1. Almacenamiento
El Behavioral Twin se almacena en varias capas de datos:

Capa	Tecnología	Propósito
Relacional	PostgreSQL (Supabase)	Almacenar atributos estructurados (identidad, contexto, valores, etc.).
Grafo	NetworkX (serializado en JSON) + PostgreSQL (para persistencia)	Almacenar redes RFT y relaciones entre procesos.
Series temporales	PostgreSQL (TimescaleDB) + InfluxDB (opcional)	Almacenar trayectorias de procesos y predicciones.
Vectorial	pgvector (PostgreSQL)	Almacenar embeddings de conversaciones y textos para RAG.
Documentos	Supabase Storage (S3)	Almacenar informes, notas y documentos clínicos.
5.2. APIs de Consulta
El Behavioral Twin expone APIs para que otros motores consulten su estado.

5.2.1. Consulta de Procesos

GET /api/v1/twin/{patient_id}/processes/{process_name}

Respuesta:

{
  "process": "Aceptación",
  "value": 0.65,
  "confidence": 0.82,
  "trajectory": [...],
  "trend": "ascendente",
  "sources": [...]
}

5.2.2. Consulta de Hipótesis

GET /api/v1/twin/{patient_id}/hypotheses/active

Respuesta:

{
  "active_hypothesis": {
    "id": "hyp_001",
    "description": "La evitación social se mantiene por reforzamiento negativo...",
    "confidence": 0.68,
    "evidence_for": [...],
    "evidence_against": [...]
  },
  "other_hypotheses": [...]
}

5.2.3. Consulta de Estado Actual

GET /api/v1/twin/{patient_id}/state/current

Respuesta:

{
  "energy": 0.7,
  "stress": 0.6,
  "motivation": 0.8,
  "risk": {
    "dropout_risk": 0.25,
    "relapse_risk": 0.35
  },
  "momentum": 0.55,
  "last_updated": "2026-07-01T14:30:00Z"
}

5.2.4. Consulta de Predicciones

GET /api/v1/twin/{patient_id}/predictions?horizon=7d

respuesta:

{
  "adherence_7d": 0.65,
  "process_improvement": {
    "acceptance": 0.08,
    "defusion": 0.12
  },
  "confidence": 0.60
}

6. Integración con los Motores del Ecosistema
6.1. AAO (Adaptive Assessment Orchestrator)
Uso: Lee el estado de los procesos (capa 5) para decidir qué evaluar (procesos con baja confianza).

Actualización: Después de una evaluación, el AAO envía un evento ASSESSMENT_COMPLETED que actualiza las capas 5, 6 y 7.

6.2. BERL (Behavioral Exercise Research Lab)
Uso: Lee los repertorios (capa 4) y procesos (capa 5) para seleccionar ejercicios adaptativos.

Actualización: Después de un ejercicio, BERL envía EXERCISE_FINISHED, actualizando capas 4, 5 y 9.

6.3. TCCN (Therapeutic Cognitive Companion)
Uso: Lee las hipótesis (capa 7) y valores (capa 8) para generar diálogos terapéuticos.

Actualización: Después de una conversación, TCCN envía CONVERSATION_ANALYZED, actualizando capas 6 y 7.

6.4. AHEE (Adaptive Human Experience Engine)
Uso: Lee el estado actual (capa 9) y procesos (capa 5) para adaptar la interfaz (colores, animaciones, dificultad, narrativa).

Actualización: AHEE no actualiza el Twin; solo lo consulta.

6.5. MPO (Meta-Process Orchestrator)
Uso: Lee todas las capas para decidir qué proceso priorizar y qué secuencia de intervención seguir.

Actualización: MPO no actualiza el Twin; solo lo consulta para la toma de decisiones.

6.6. BWM (Behavioral World Model)
Uso: Lee el Twin para simular escenarios futuros (ej. "¿qué pasaría si aumentamos la aceptación?").

Actualización: BWM no actualiza el Twin; genera predicciones que se almacenan en la capa 9.

6.7. BSC (Behavioral Science Cloud)
Uso: Lee datos anonimizados del Twin para investigación y mejora de modelos.

Actualización: BSC no actualiza el Twin; solo consume datos agregados y anonimizados.

6.8. BPOS (Behavioral Practice OS)
Uso: Muestra el Twin al terapeuta en el dashboard (visualizaciones de procesos, redes RFT, hipótesis).

Actualización: BPOS no actualiza el Twin; solo muestra la información.

7. Ejemplos de Uso (Casos Clínicos)
7.1. Ejemplo 1: Evaluación Inicial
Paso 1: El paciente completa una entrevista inicial con TCCN. Se extraen eventos significativos y se crean las primeras hipótesis funcionales (capa 2 y 7).

Paso 2: El paciente realiza una batería de evaluaciones (AAO). Se actualizan los procesos (capa 5) con confianzas iniciales (ej. aceptación = 0.30, defusión = 0.25).

Paso 3: El sistema genera un mapa de procesos y lo muestra al terapeuta. El terapeuta valida las hipótesis y añade observaciones.

Paso 4: El Twin está listo para guiar las siguientes intervenciones.

7.2. Ejemplo 2: Seguimiento de un Ejercicio
Paso 1: El paciente inicia un ejercicio de defusión en Godot. BERL envía telemetría en tiempo real (latencia, errores, tiempo de permanencia).

Paso 2: Al finalizar, BERL envía EXERCISE_FINISHED con los resultados (ej. "defusion_score": 0.65).

Paso 3: El Twin actualiza la capa 5 (Defusión: 0.65, confianza: 0.75) y la capa 9 (momentum: 0.55).

Paso 4: El sistema recalcula las predicciones y el riesgo de abandono.

Paso 5: Si la defusión ha mejorado, el TCCN envía un mensaje de validación: "¡Observo que cada vez te resulta más fácil observar tus pensamientos sin fusionarte!"

7.3. Ejemplo 3: Recaída Detectada
Paso 1: El paciente reporta (vía EMA) que ha evitado una reunión familiar. El AAO detecta un aumento en evitación y una caída en acción comprometida.

Paso 2: El Twin actualiza la capa 5 (Aceptación: 0.55, Evitación: 0.75) y reduce la confianza en la generalización.

Paso 3: El sistema actualiza la hipótesis activa (capa 7) con nueva evidencia en contra.

Paso 4: El MPO prioriza intervenciones de aceptación y exposición.

Paso 5: El TCCN inicia una conversación: "He notado que has evitado la reunión. ¿Qué fue lo más difícil? ¿Qué valor se vio afectado?"

8. Criterios de Validación y Cumplimiento
Criterio	Métrica	Herramienta
Latencia de actualización	< 1 s desde el evento hasta la actualización del Twin.	Monitoreo de rendimiento
Consistencia	El Twin no tiene datos contradictorios (ej. dos fuentes no pueden dar valores incompatibles).	Reglas de validación en BQAS
Trazabilidad	Cada actualización tiene metadatos (quién, cuándo, qué datos, qué versión).	Auditoría automática
Confiabilidad de hipótesis	Las hipótesis con confianza < 0.5 no se usan para decisiones críticas.	Reglas de negocio en MPO
Privacidad	El Twin no almacena datos identificables sin cifrar.	Inspección de seguridad
Escalabilidad	El Twin soporta > 10,000 pacientes concurrentes.	Pruebas de carga (k6)
9. El Manifiesto del Behavioral Twin
"El Behavioral Twin no es un expediente. No es un perfil. No es un diagnóstico.

Es el eco digital de la vida conductual de una persona.

No juzga. No etiqueta. No clasifica.

Observa. Modela. Aprende. Evoluciona.

Es un científico empírico que estudia el comportamiento, no un juez que lo sentencia.

Cada actualización es una oportunidad para comprender mejor, para refinar hipótesis, para ofrecer una intervención más precisa.

El Behavioral Twin es el corazón del BehavioralOS. Si late correctamente, todo el ecosistema respira."

10. Historial de Cambios
Versión	Fecha	Autor	Cambios
1.0.0	2026-07-01	Arquitectura Jefe	Creación del documento. Definición de capas, atributos, mecanismos de actualización, APIs, integración con motores y casos de uso.
Fin del documento behavioral-twin.md


