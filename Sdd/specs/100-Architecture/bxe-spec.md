---
id: BXE-001
title: Behavioral Explainability Engine (BXE) — Motor de Explicabilidad y Trazabilidad
version: 1.0.0
status: Draft
owner: Arquitectura de Software & Psicología Clínica
last_updated: 2026-07-14
depends_on:
  - BPG (Behavioral Process Graph)
  - 400-AI (Gemma, RAG, BKGE)
exports:
  - Arquitectura de 14 submotores de explicabilidad
  - Explainability Graph (grafo de trazabilidad)
  - Explainability Dashboard para el psicólogo
  - Explainability Timeline (por sesión)
  - Explainability Score (métrica compuesta)
  - Explainability API (contrato público)
  - Explainability Report Generator
used_by:
  - BCI (Behavioral Clinical Intake)
  - BAD (Behavioral Assessment Designer)
  - BCDSL (Behavioral Clinical DSL)
  - BKC (Behavioral Knowledge Compiler)
  - BKS (Behavioral Knowledge Simulator)
  - BESS (Behavioral Evidence Scenario Set)
  - BPO (Behavioral Process Ontology)
  - BPG (Behavioral Process Graph)
  - BERL (Behavioral Exercise Research Lab)
  - BCAS (Behavioral Clinical Assessment System)
  - BCMS (Behavioral Clinical Management System)
  - BIMS (Behavioral Intervention Management System)
  - BPAS (Behavioral Personalization & Adaptation System)
  - BDSS (Behavioral Decision Support System)
  - BTVE (Behavioral Theoretical Validation Engine)
  - BCCE (Behavioral Clinical Consistency Engine)
  - BARS (Behavioral Analytics & Reporting System)
  - BIK (Behavioral Intelligence Kernel)
---

# BehavioralOS — Behavioral Explainability Engine (BXE)

> *"El BXE no decide ni valida; explica. Cada vez que la IA genera una hipótesis, recomienda un ejercicio, selecciona una intervención o detecta una inconsistencia, el BXE construye una justificación trazable en lenguaje natural."*

---

## 1. Propósito y Alcance

### 1.1. Propósito

El Behavioral Explainability Engine (BXE) es el **motor de explicabilidad y trazabilidad clínica** que documenta, reconstruye y comunica el razonamiento utilizado por la IA en cada evaluación, formulación, recomendación, ejercicio, adaptación o alerta generada dentro del ecosistema.

El BXE convierte cada decisión del sistema en una **cadena transparente y verificable**. No modifica decisiones. No reemplaza el juicio clínico. No genera nuevas hipótesis. Simplemente explica cómo se llegó a ellas.

### 1.2. Alcance

El BXE cubre la explicabilidad de:

- Resultados de preentrevistas
- Análisis funcionales
- Hipótesis clínicas
- Procesos psicológicos detectados
- Priorización de procesos
- Selección de ejercicios
- Selección de intervenciones
- Adaptación de videojuegos
- Adaptación de dificultad
- Recomendaciones al terapeuta
- Alertas clínicas, de consistencia y teóricas

### 1.3. Filosofía Fundamental

> **"Toda decisión clínica automatizada debe poder responder: ¿Qué información utilizó la IA? ¿Qué datos consideró más relevantes? ¿Qué procesos identificó? ¿Qué reglas clínicas aplicó? ¿Qué evidencia respaldó esa decisión? ¿Qué otras alternativas descartó? ¿Qué nivel de confianza tiene? Si el sistema no puede responder estas preguntas, el terapeuta nunca debería confiar plenamente en él."**

---

## 2. Arquitectura: 14 Submotores

```
┌─────────────────────────────────────────────────────────────────────────┐
│              BEHAVIORAL EXPLAINABILITY ENGINE (BXE)                     │
│              ─── Capa Transversal de Transparencia ───                  │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  ┌─────────────────────┐  ┌──────────────────────┐  ┌───────────────┐ │
│  │ 1. Decision Trace    │  │ 2. Evidence           │  │ 3. Rule       │ │
│  │    Engine            │  │    Attribution Engine  │  │    Explanation│ │
│  └──────────┬──────────┘  └──────────┬───────────┘  └───────┬───────┘ │
│             │                        │                      │          │
│  ┌──────────┴──────────┐  ┌─────────┴────────────┐  ┌──────┴───────┐ │
│  │ 4. Process          │  │ 5. Clinical Narrative │  │ 6. Alternative│ │
│  │    Explanation      │  │    Generator          │  │    Reasoning  │ │
│  └──────────┬──────────┘  └──────────┬───────────┘  └───────┬───────┘ │
│             │                        │                      │          │
│  ┌──────────┴──────────┐  ┌─────────┴────────────┐  ┌──────┴───────┐ │
│  │ 7. Confidence       │  │ 8. Knowledge Trace    │  │ 9. Graph     │ │
│  │    Explanation      │  │    Engine             │  │    Explanation│ │
│  └──────────┬──────────┘  └──────────┬───────────┘  └───────┬───────┘ │
│             │                        │                      │          │
│  ┌──────────┴──────────┐  ┌─────────┴────────────┐  ┌──────┴───────┐ │
│  │ 10. Timeline        │  │ 11. AI Transparency  │  │ 12. Explain- │ │
│  │     Reconstruction  │  │     Layer            │  │     ability  │ │
│  └──────────┬──────────┘  └──────────┬───────────┘  └───────┬───────┘ │
│             │                        │                      │          │
│  ┌──────────┴──────────┐  ┌─────────┴────────────┐                   │
│  │ 13. Explainability  │  │ 14. Audit Trace      │                   │
│  │     Report Generator│  │     Manager          │                   │
│  └─────────────────────┘  └──────────────────────┘                   │
│                                                                         │
├─────────────────────────────────────────────────────────────────────────┤
│  Fuentes de datos:                                                     │
│  BPO, BPG, BPG-M, BKC, BKS, BESS, BCDSL, BTVE, BCCE,                │
│  BCAS, BIMS, BPAS, BDSS, BERL, BCI, BAD, BARS                        │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 3. Descripción de Cada Submotor

### 3.1. Decision Trace Engine

| Atributo | Valor |
|----------|-------|
| **Propósito** | Reconstruir toda decisión tomada por la IA como una cadena lineal de pasos. |
| **Entrada** | Evento de decisión (cualquier motor que genera una salida) |
| **Salida** | Cadena de trazabilidad: Preentrevista → Evaluaciones → Análisis funcional → Procesos → Objetivos → Intervenciones → Ejercicios → Feedback |
| **Almacenamiento** | Tabla `decision_traces` en PostgreSQL + grafo en BKGE |

**Estructura de una traza:**

```json
{
  "trace_id": "trc_abc123",
  "decision_type": "exercise_selection",
  "patient_id": "pat_xyz",
  "chain": [
    {"step": 1, "source": "BCI", "action": "preintake_completed", "timestamp": "2026-07-01T10:00:00Z"},
    {"step": 2, "source": "BCAS", "action": "assessment_mpfi_scored", "timestamp": "2026-07-01T10:30:00Z"},
    {"step": 3, "source": "BPG", "action": "processes_detected", "data": ["evitación", "fusión_cognitiva"]},
    {"step": 4, "source": "BDSS", "action": "intervention_prioritized", "data": "defusión_cognitiva"},
    {"step": 5, "source": "BERL", "action": "exercise_selected", "data": "balloon_defusion_01"}
  ],
  "final_decision": "Ejercicio de defusión con globo (BERL)"
}
```

### 3.2. Evidence Attribution Engine

| Atributo | Valor |
|----------|-------|
| **Propósito** | Toda conclusión debe tener evidencia. Nunca: "La IA cree..." siempre: "La IA concluye X porque Y, Z, W." |
| **Entrada** | Conclusión del sistema + fuentes de datos utilizadas |
| **Salida** | Lista de evidencias con peso y origen |
| **Fuentes** | MPFI, entrevista, frecuencia conductual, BERL, seguimiento, EMA |

**Ejemplo de salida:**

```json
{
  "conclusion": "Alta evitación experiencial",
  "evidence": [
    {"source": "MPFI", "metric": "AAQ-II score", "value": 38, "weight": 0.35},
    {"source": "BCI", "metric": "entrevista_inicial", "finding": "evita conversaciones difíciles", "weight": 0.25},
    {"source": "BERL", "metric": "frecuencia_conductual", "value": "2/7 días actividad social", "weight": 0.20},
    {"source": "EMA", "metric": "auto-reporte_diario", "value": "evitación en 5/7 días", "weight": 0.20}
  ]
}
```

### 3.3. Rule Explanation Engine

| Atributo | Valor |
|----------|-------|
| **Propósito** | Explica qué reglas del Behavioral Clinical DSL fueron utilizadas en cada decisión. |
| **Entrada** | Referencia a regla del BCDSL |
| **Salida** | Regla legible: "Regla PBT-204: Alta evitación → Priorizar aceptación" |
| **Conexión** | BKC (Knowledge Compiler) para obtener la definición de la regla |

### 3.4. Process Explanation Engine

| Atributo | Valor |
|----------|-------|
| **Propósito** | Explica por qué se eligió un proceso psicológico específico. |
| **Entrada** | Proceso detectado + datos que lo respaldan |
| **Salida** | Justificación: "Proceso dominante = Fusión Cognitiva porque 78% de las respuestas presentaron literalidad, rigidez y evitación" |
| **Conexión** | BPO (ontología de procesos) + BPG (grafo de relaciones) |

### 3.5. Clinical Narrative Generator

| Atributo | Valor |
|----------|-------|
| **Propósito** | Convierte datos cuantitativos en lenguaje clínico profesional. |
| **Entrada** | Datos numéricos + procesos + evidencia |
| **Salida** | Narrativa: "La evidencia disponible sugiere que la evitación experiencial constituye el principal proceso de mantenimiento del problema actual. Esta conclusión se apoya en los patrones observados durante la entrevista, las respuestas al MPFI y el desempeño conductual registrado en los ejercicios interactivos." |
| **Motor de generación** | Gemma (on-device) con prompt clínico especializado |

### 3.6. Alternative Reasoning Engine

| Atributo | Valor |
|----------|-------|
| **Propósito** | Explica qué opciones fueron descartadas y por qué. |
| **Entrada** | Decisión final + alternativas evaluadas |
| **Salida** | "Se evaluó Defusión → Descartada porque la evidencia fue insuficiente (confianza: 0.35)" |
| **Valor clínico** | Permite al terapeuta evaluar si el sistema descartó algo válido |

### 3.7. Confidence Explanation Engine

| Atributo | Valor |
|----------|-------|
| **Propósito** | No basta decir "95%". Debe explicar por qué ese nivel de confianza. |
| **Entrada** | Nivel de confianza + factores que lo componen |
| **Salida** | "Confianza 95%: Alta consistencia + Tres fuentes independientes + Sin contradicciones + Seguimiento consistente" |
| **Métricas** | Número de fuentes, consistencia entre fuentes, tiempo de observación, calidad de datos |

### 3.8. Knowledge Trace Engine

| Atributo | Valor |
|----------|-------|
| **Propósito** | Se conecta con BKC para indicar exactamente qué conocimiento científico utilizó. |
| **Entrada** | Referencia a regla o principio del BKC |
| **Salida** | "Repositorio: ACT → Versión: 2.1 → Capítulo: Flexibilidad → Regla: ACT-114" |
| **Conexión** | BKC (Knowledge Compiler) + BESS (Evidence Scenarios) + BTVE (Theoretical Validation) |

### 3.9. Graph Explanation Engine

| Atributo | Valor |
|----------|-------|
| **Propósito** | Trabaja sobre BPG y BPG-M para generar explicaciones del grafo de procesos. |
| **Entrada** | Subgrafo relevante de BPG |
| **Salida** | "La evitación conecta directamente con la reducción de actividades valiosas, lo que incrementa el aislamiento social y mantiene el malestar emocional." |
| **Visualización** | Renderiza el subgrafo relevante en el Explainability Dashboard |

### 3.10. Timeline Reconstruction Engine

| Atributo | Valor |
|----------|-------|
| **Propósito** | Reconstruye toda la evolución del paciente a lo largo del tratamiento. |
| **Entrada** | Historial de eventos del Behavioral Twin |
| **Salida** | Línea temporal: Sesión 1 (Alta evitación) → Sesión 4 (Mayor aceptación) → Sesión 8 (Acción comprometida) |
| **Granularidad** | Por sesión, por semana, por mes |

### 3.11. AI Transparency Layer

| Atributo | Valor |
|----------|-------|
| **Propósito** | Toda respuesta de la IA puede desplegar un botón "¿Por qué?" |
| **Entrada** | Cualquier salida de IA (Gemma, BDSS, BPAS, etc.) |
| **Salida** | Panel expandible con toda la cadena de razonamiento |
| **UX** | Botón "¿Por qué?" en cada respuesta del sistema, tanto para el terapeuta como (en modo simplificado) para el paciente |

### 3.12. Explainability API

| Atributo | Valor |
|----------|-------|
| **Propósito** | Todos los módulos pueden solicitar explicaciones de cualquier decisión. |
| **Protocolo** | REST API |

**Endpoints:**

```
POST /api/v1/bxe/explain/intervention
POST /api/v1/bxe/explain/assessment
POST /api/v1/bxe/explain/hypothesis
POST /api/v1/bxe/explain/exercise
POST /api/v1/bxe/explain/alert
GET  /api/v1/bxe/trace/{decision_id}
GET  /api/v1/bxe/timeline/{patient_id}
GET  /api/v1/bxe/score/{decision_id}
```

**Ejemplo de respuesta:**

```json
{
  "proceso": "Flexibilidad Psicológica",
  "reglas": ["PBT-201", "ACT-104"],
  "evidencia": ["MPFI", "Entrevista", "BERL"],
  "alternativas_descartadas": [
    {"name": "Regulación Emocional", "reason": "Insuficiente evidencia", "confidence": 0.35}
  ],
  "confianza": 0.94,
  "narrativa": "La selección del ejercicio de defusión se basa en...",
  "graph_url": "/bxe/graph/trc_abc123"
}
```

### 3.13. Explainability Report Generator

| Atributo | Valor |
|----------|-------|
| **Propósito** | Produce reportes completos de explicabilidad para una decisión, un paciente o un período. |
| **Formatos** | PDF, JSON, HTML interactivo |
| **Contenido** | Decisión → Justificación → Reglas utilizadas → Evidencia → Confianza → Alternativas → Timeline |

**Estructura del reporte:**

```
┌─────────────────────────────────────────┐
│         EXPLAINABILITY REPORT           │
├─────────────────────────────────────────┤
│ Decisión: Ejercicio de Defusión         │
│ Justificación: Alta Fusión Cognitiva    │
│ Reglas utilizadas: ACT-104              │
│ Evidencia: MPFI + Entrevista + BERL     │
│ Confianza: 96%                          │
│ Alternativas descartadas: 2             │
│ Fecha: 2026-07-14                       │
│ Versiones: BKC 2.1, DSL 1.3, BTVE 1.0  │
└─────────────────────────────────────────┘
```

### 3.14. Audit Trace Manager

| Atributo | Valor |
|----------|-------|
| **Propósito** | Cada explicación queda versionada con metadatos de auditoría. |
| **Metadatos** | Fecha, versión del modelo, versión del BKC, versión del DSL, versión del BTVE, hash del razonamiento |
| **Retención** | 10 años (datos clínicos) |
| **Inmutabilidad** | Las trazas de auditoría no pueden ser modificadas una vez creadas |

---

## 4. Explainability Graph (Grafo de Trazabilidad)

Toda decisión se representa como un grafo dirigido que conecta datos → procesos → hipótesis → objetivos → intervenciones → ejercicios → resultados.

```
┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
│  DATOS   │───►│ PROCESOS │───►│HIPÓTESIS │───►│ OBJETIVOS│
│          │    │          │    │          │    │          │
│ MPFI     │    │ Evitación│    │ Refuerzo │    │ Aumentar │
│ Entrev.  │    │ Fusión   │    │ negativo │    │ aceptación│
│ BERL     │    │ Acept.   │    │          │    │          │
│ EMA      │    │          │    │          │    │          │
└──────────┘    └──────────┘    └──────────┘    └─────┬────┘
                                                       │
┌──────────┐    ┌──────────┐    ┌──────────┐          │
│ RESULTADO│◄───│EJERCICIOS│◄───│INTERV.   │◄─────────┘
│          │    │          │    │          │
│ Score    │    │ Globo    │    │ Defusión │
│ Adherenc.│    │ Zelda    │    │ Aceptac. │
│ Progreso │    │ Pikmin   │    │          │
└──────────┘    └──────────┘    └──────────┘
```

### 4.1. Representación en PostgreSQL

```sql
CREATE TABLE explainability_graphs (
    id UUID PRIMARY KEY,
    patient_id UUID NOT NULL,
    decision_id UUID NOT NULL,
    nodes JSONB NOT NULL,      -- [{id, type, label, source_engine, confidence}]
    edges JSONB NOT NULL,      -- [{source, target, relation, weight}]
    created_at TIMESTAMPTZ DEFAULT NOW(),
    version INTEGER DEFAULT 1
);

CREATE INDEX idx_eg_patient ON explainability_graphs(patient_id);
CREATE INDEX idx_eg_decision ON explainability_graphs(decision_id);
```

### 4.2. Nodos del Grafo

| Tipo de nodo | Ejemplo | Fuente |
|-------------|---------|--------|
| `data` | MPFI score: 38 | BCAS |
| `process` | Fusión Cognitiva: 0.82 | BPG |
| `hypothesis` | Refuerzo negativo mantiene evitación | BDSS |
| `goal` | Aumentar aceptación a 0.70 | BIMS |
| `intervention` | Ejercicio de defusión | BERL |
| `result` | Score 0.72, adherencia 85% | BERL |

### 4.3. Aristas del Grafo

| Tipo de arista | Descripción |
|---------------|-------------|
| `supports` | Los datos respaldan el proceso |
| `leads_to` | El proceso lleva a la hipótesis |
| `justifies` | La hipótesis justifica el objetivo |
| `prescribes` | El objetivo prescribe la intervención |
| `produces` | La intervención produce el resultado |
| `contradicts` | Un dato contradice una hipótesis |
| `alternative_to` | Una alternativa fue descartada a favor de otra |

---

## 5. Explainability Dashboard (para el Psicólogo)

### 5.1. Estructura

```
┌─────────────────────────────────────────────────────────────┐
│  EXPLAINABILITY DASHBOARD — Paciente: María López           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────┐  ┌─────────────────────────────────┐  │
│  │ Explainability   │  │  Cadena de Razonamiento         │  │
│  │ Score: 94%       │  │                                 │  │
│  │                  │  │  1. MPFI (score: 38)            │  │
│  │ Explicabilidad   │  │     ↓                           │  │
│  │ ████████████░ 98%│  │  2. Evitación detectada         │  │
│  │ Trazabilidad     │  │     ↓                           │  │
│  │ ████████████ 100%│  │  3. Regla PBT-204 aplicada     │  │
│  │ Evidencia        │  │     ↓                           │  │
│  │ ███████████░░ 96%│  │  4. Defusión priorizada         │  │
│  │ Consistencia     │  │     ↓                           │  │
│  │ ████████████ 99% │  │  5. Ejercicio seleccionado      │  │
│  │ Transparencia    │  │                                 │  │
│  │ ████████████ 100%│  │  [Ver grafo completo]          │  │
│  └─────────────────┘  └─────────────────────────────────┘  │
│                                                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  EXPLAINABILITY TIMELINE                              │  │
│  │                                                       │  │
│  │  S1 ──── S2 ──── S3 ──── S4 ──── S5 ──── S6 ────   │  │
│  │  │       │       │       │       │       │          │  │
│  │  Evit.   Evit.   Evit↓   Acep↑   Acep↑   Acción↑   │  │
│  │  0.85    0.80    0.72    0.58    0.45    0.30       │  │
│  │                                                       │  │
│  │  [Seleccionar sesión para ver detalle]                │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  EVIDENCIA UTILIZADA                                  │  │
│  │                                                       │  │
│  │  Fuente         │ Métrica        │ Valor  │ Peso     │  │
│  │  ────────────── │ ────────────── │ ────── │ ───────  │  │
│  │  MPFI           │ AAQ-II score   │ 38     │ 35%      │  │
│  │  Entrevista     │ Evitación      │ Alta   │ 25%      │  │
│  │  BERL           │ Frecuencia     │ 2/7    │ 20%      │  │
│  │  EMA            │ Auto-reporte   │ 5/7    │ 20%      │  │
│  │                                                       │  │
│  │  [Ver reglas aplicadas]  [Ver alternativas]           │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  ALTERNATIVAS DESCARTADAS                             │  │
│  │                                                       │  │
│  │  Defusión Cognitiva: SELECCIONADA (confianza: 0.82)  │  │
│  │  Regulación Emocional: descartada (insuficiente ev.)  │  │
│  │  Acción Comprometida: diferida (requiere aceptación)  │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                             │
│  [Exportar reporte PDF]  [Copiar JSON]  [Compartir]        │
└─────────────────────────────────────────────────────────────┘
```

---

## 6. Explainability Timeline (por Sesión)

Cada sesión terapéutica tiene una línea temporal de explicabilidad:

```
Sesión 4 — 2026-07-14
──────────────────────────────────────────────────────

10:00  ──► Paciente inicia juego de defusión (BERL)
           BXE: Ejercicio seleccionado porque Fusión Cognitiva = 0.82
           Regla: ACT-104

10:05  ──► Telemetría: tiempo de permanencia 45s, 2 errores
           BXE: Progreso moderado, adherencia al protocolo: 80%

10:08  ──► Paciente completa ejercicio
           BXE: Score 0.72, confianza 85%
           Impacto en Behavioral Twin: Fusión → 0.78 (↑0.04)

10:10  ──► TCCN envía feedback validador
           BXE: Respuesta generada porque scores > 0.60
           Regla: FEEDBACK-003

10:15  ──► BCCE verifica consistencia
           BXE: Sin inconsistencias detectadas
           Confianza en formulación: 92%
```

---

## 7. Explainability Score (Métrica Compuesta)

Cada decisión recibe un puntaje compuesto de explicabilidad:

| Dimensión | Peso | Cálculo | Descripción |
|-----------|------|---------|-------------|
| **Explicabilidad** | 25% | % de pasos con justificación legible | ¿Cada paso de la cadena tiene una explicación en lenguaje natural? |
| **Trazabilidad** | 25% | % de pasos con fuente identificada | ¿Cada paso puede rastrearse hasta una fuente de datos? |
| **Evidencia** | 20% | Número de fuentes independientes / mínimo requerido | ¿Hay suficiente evidencia de múltiples fuentes? |
| **Consistencia** | 15% | % de fuentes que no se contradicen | ¿Las fuentes son consistentes entre sí? |
| **Transparencia** | 15% | % de decisiones con "¿Por qué?" disponible | ¿El terapeuta puede acceder al razonamiento? |

**Fórmula:**

```
Explainability Score = (Explicabilidad × 0.25) +
                       (Trazabilidad × 0.25) +
                       (Evidencia × 0.20) +
                       (Consistencia × 0.15) +
                       (Transparencia × 0.15)
```

**Semáforo de calidad:**

| Score | Nivel | Acción |
|-------|-------|--------|
| ≥ 0.90 | Excelente | Decisión confiable, mostrar al terapeuta |
| 0.70 - 0.89 | Bueno | Decisión aceptable, marcar con advertencia menor |
| 0.50 - 0.69 | Insuficiente | Requiere revisión humana antes de aplicar |
| < 0.50 | Crítico | No ejecutar; escalar al terapeuta obligatoriamente |

---

## 8. Integración con el Ecosistema

### 8.1. Mapa de Integración

| Módulo consumidor | Tipo de integración | Qué solicita al BXE |
|-------------------|--------------------|--------------------|
| **BCI** | Escritura (emite eventos) | El BXE captura la cadena intake → hipótesis |
| **BAD** | Escritura + Lectura | BXE explica por qué se sugirió cierta evaluación |
| **BCDSL** | Lectura | BXE indica qué reglas del DSL se aplicaron |
| **BKC** | Lectura | BXE consulta la definición de reglas utilizadas |
| **BKS** | Lectura | BXE muestra qué escenarios de referencia se usaron |
| **BESS** | Lectura | BXE enlaza con escenarios de evidencia similares |
| **BPO** | Lectura | BXE consulta definiciones de procesos |
| **BPG** | Lectura | BXE consulta relaciones entre procesos |
| **BERL** | Escritura + Lectura | BXE justifica selección de ejercicios |
| **BCAS** | Escritura + Lectura | BXE explica resultados de evaluaciones |
| **BCMS** | Lectura | BXE muestra trazabilidad en expediente |
| **BIMS** | Escritura + Lectura | BXE explica por qué se eligió una intervención |
| **BPAS** | Escritura + Lectura | BXE explica adaptaciones de dificultad/narrativa |
| **BDSS** | Escritura + Lectura | BXE documenta razonamiento de decisiones de soporte |
| **BTVE** | Lectura | BXE enlaza con reglas teóricas que respaldan |
| **BCCE** | Lectura | BXE muestra verificaciones de consistencia |
| **BARS** | Lectura | BXE exporta indicadores de explicabilidad para dashboards |
| **BIK** | Bidireccional | BIK coordina a BXE vía Explainability Coordinator |

### 8.2. Flujo de Integración Típico

```
1. Motor X genera una decisión
        │
        ▼
2. Motor X emite evento DECISION_MADE con payload
        │
        ▼
3. BIK (Explainability Coordinator) recibe el evento
        │
        ▼
4. BIK invoca a BXE: POST /bxe/explain con contexto
        │
        ▼
5. BXE ejecuta sus 14 submotores en paralelo:
   ├── Decision Trace reconstruye la cadena
   ├── Evidence Attribution identifica fuentes
   ├── Rule Explanation consulta BKC
   ├── Process Explanation consulta BPO/BPG
   ├── Clinical Narrative genera texto clínico
   ├── Alternative Reasoning lista descartadas
   ├── Confidence Explanation descompone confianza
   ├── Knowledge Trace conecta con BKC
   ├── Graph Explanation renderiza subgrafo
   ├── Timeline Reconstruction ubica en línea temporal
   ├── AI Transparency genera botón "¿Por qué?"
   ├── Explainability API expone el resultado
   ├── Report Generator prepara PDF/JSON
   └── Audit Trace versiona con hash
        │
        ▼
6. BXE devuelve resultado completo al BIK
        │
        ▼
7. BIK entrega la explicación al módulo que la solicita
   (o la almacena para el Explainability Dashboard)
```

---

## 9. Criterios de Validación

| Criterio | Métrica | Herramienta |
|----------|---------|-------------|
| Cobertura | 100% de decisiones clínicas tienen traza | Auditoría automática |
| Latencia | Generación de explicación < 200ms | Monitoreo de rendimiento |
| Legibilidad | Narrativas generadas son comprensibles por psicólogos | Validación con usuarios |
| Trazabilidad | Cada traza tiene al menos 3 fuentes | Pruebas de integridad |
| Inmutabilidad | Las trazas de auditoría no pueden ser modificadas | Pruebas de seguridad |
| Disponibilidad | BXE disponible 99.9% del tiempo | Health checks |

---

## 10. El Manifiesto del BXE

> *"La transparencia no es un lujo en un sistema de salud mental. Es un requisito ético.*
>
> *El BXE existe porque el terapeuta tiene derecho a saber por qué la IA llegó a una conclusión. Y el paciente tiene derecho a confiar en que esa conclusión fue alcanzada con rigor, evidencia y trazabilidad.*
>
> *Si una IA no puede explicar su razonamiento clínico, entonces no debería estar tomando decisiones clínicas.*
>
> *El BXE convierte cada decisión en una cadena de cristal: transparente, verificable e inmutable."*

---

## 11. Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2026-07-14 | Arquitectura Jefe | Creación del documento. Definición de 14 submotores, Explainability Graph, Dashboard, Timeline, Score, API, Report Generator y Audit Trace Manager. |

---

**Fin del documento `bxe-spec.md`**
