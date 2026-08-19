---
id: BPO-001
title: Behavioral Process Ontology (BPO)
version: 1.0.0
status: Stable
owner: Arquitectura & Psicología Clínica
last_updated: 2026-07-14
depends_on:
  - BPE-001 (Behavioral Process Engine)
  - 000-Core (Ontología base, Principios)
exports:
  - Ontología Formal de Procesos Psicológicos
  - UUID scheme: BPO-{DOMINIO}-{NÚMERO}
  - Representación YAML por proceso
  - Definiciones múltiples por proceso
  - Relaciones entre procesos
  - Variables observables y latentes
  - Instrumentos asociados
  - Niveles de evidencia científica
used_by:
  - BPE-001 (Behavioral Process Engine)
  - BPG-001 (Behavioral Process Graph)
  - BXE (Behavioral Explainability Engine)
  - BERL (Behavioral Exercise Research Lab)
  - AHEE (Adaptive Human Experience Engine)
  - TCCN (Behavioral Companion)
  - BIP (Behavioral Intelligence Platform)
  - BSC (Behavioral Science Cloud)
  - BROS (Behavioral Research Outcomes System)
  - BCMS (Behavioral Clinical Management System)
  - BRIL (Behavioral Runtime Integration Layer)
---

# BehavioralOS – Behavioral Process Ontology (BPO)

> *"El BPO no es solo una ontología. Es el lenguaje común que utilizarán absolutamente todos los módulos del ecosistema. Donde otros ven una lista de procesos, nosotros vemos un universo computacional reutilizable."*

---

## 1. Propósito y Alcance

### 1.1. Propósito

El Behavioral Process Ontology (BPO) es el **modelo semántico oficial** del ecosistema BehavioralOS. Su función es que **todos los componentes** — IA, videojuegos, cuestionarios, dashboards, análisis funcional, reportes, motores de recomendación, programas de tratamiento y analítica — **hablen el mismo idioma**.

El BPO convierte cada proceso psicológico en un **objeto computacional reutilizable**. En lugar de que cada módulo tenga su propia definición de "Aceptación", "Flexibilidad Psicológica" o "Memoria de Trabajo", toda la plataforma consulta el BPO.

### 1.2. Objetivos

El BPO debe permitir:

1. **Unificar terminología** — Eliminar ambigüedades entre módulos.
2. **Eliminar duplicación de lógica** — Una sola fuente de verdad por proceso.
3. **Facilitar entrenamiento de IA** — La IA consulta el BPO, no definiciones dispersas.
4. **Automatizar recomendaciones** — Reglas basadas en la ontología.
5. **Facilitar investigación** — Comparar procesos, no terapias.
6. **Mantener trazabilidad científica** — Cada proceso tiene evidencia vinculada.
7. **Versionar definiciones** — Nunca sobrescribir; siempre preservar.
8. **Incorporar nuevas terapias sin reescribir el sistema** — El BPO es agnóstico a marcos.

### 1.3. Filosofía

```
Proceso → ACT → FAP → DBT → PBT → TIP → Neuropsicología → Ejercicios → IA → Reportes
```

El sistema **no gira alrededor de terapias. Gira alrededor de procesos.**

---

## 2. UUID Scheme

Cada proceso tiene un identificador único que **jamás cambia**, aunque cambie la definición.

### 2.1. Formato

```
BPO-{DOMINIO}-{NÚMERO}
```

| Componente | Descripción | Ejemplo |
|-----------|-------------|---------|
| `BPO` | Prefijo fijo (Behavioral Process Ontology) | `BPO` |
| `{DOMINIO}` | Código del dominio (3 letras) | `CTX` |
| `{NÚMERO}` | Número secuencial de 5 dígitos | `000031` |

### 2.2. Códigos de Dominio

| Código | Dominio | Ejemplo de UUID |
|--------|---------|-----------------|
| `COG` | Cognitivos | `BPO-COG-000001` |
| `EMO` | Emocionales | `BPO-EMO-000001` |
| `MOT` | Motivacionales | `BPO-MOT-000001` |
| `CON` | Conductuales | `BPO-CON-000001` |
| `CTX` | Contextuales/ACT | `BPO-CTX-000031` |
| `INT` | Interpersonales/FAP | `BPO-INT-000001` |
| `REL` | Relacionales | `BPO-REL-000001` |
| `FIS` | Fisiológicos | `BPO-FIS-000001` |
| `NEU` | Neuropsicológicos | `BPO-NEU-000001` |
| `SOC` | Sociales | `BPO-SOC-000001` |
| `EVO` | Evolutivos | `BPO-EVO-000001` |
| `APR` | Aprendizaje | `BPO-APR-000001` |
| `RFT` | Marco Relacional | `BPO-RFT-000001` |
| `PAR` | Pareja/Gottman | `BPO-PAR-000001` |
| `FAM` | Familiares | `BPO-FAM-000001` |
| `SAL` | Salud | `BPO-SAL-000001` |
| `EXI` | Existenciales | `BPO-EXI-000001` |
| `ORG` | Organizacionales | `BPO-ORG-000001` |

---

## 3. Metadatos por Proceso

Cada proceso en el BPO posee la siguiente estructura de metadatos:

```yaml
uuid: "BPO-CTX-000031"
name: "Acceptance"
aliases:
  - "Aceptación"
  - "Apertura"
domain: "Contextual"
subdomain: "Flexibilidad Psicológica"
level: "Individual"          # Individual | Diádico | Familiar | Grupal | Organizacional
status: "stable"             # stable | experimental | deprecated | draft
version: "1.2.0"             # Versionado semántico
author: "Arquitectura & Psicología Clínica"
created: "2026-07-14"
last_revision: "2026-07-14"
language: "es"
synonyms:
  - "Apertura experiencial"
  - "Recepción"
antonyms:
  - "Evitación experiencial"
related_to:
  - "BPO-CTX-000032"  # Cognitive Defusion
  - "BPO-CTX-000033"  # Values
  - "BPO-CTX-000040"  # Experiential Avoidance
parent: "BPO-CTX-000000"    # Flexibilidad Psicológica (proceso padre)
children: []
evidence_level: "high"       # very_high | high | moderate | low | experimental
```

---

## 4. Definiciones Múltiples

Cada proceso tiene **seis definiciones**, cada una servida a un módulo distinto:

### 4.1. Tipos de Definición

| Tipo | Audiencia | Ejemplo (Aceptación) |
|------|-----------|---------------------|
| **Operacional** | Investigación | "Capacidad de abrirse a experimentar pensamientos, emociones y sensaciones corporales sin intentar controlarlos, modificando el comportamiento en dirección a los valores, medida por el CompACT o MPFI" |
| **Clínica** | Terapeuta | "Cuando un paciente puede estar presente con el malestar sin huir, está practicando aceptación. No es resignación; es disposición a experimentar lo que sea necesario para vivir según sus valores" |
| **Computacional** | Backend/Sistema | "Proceso contextual que incrementa la tolerancia a estímulos aversivos internos, reduciendo la latencia de exposición y aumentando la persistencia conductual en presencia de malestar" |
| **Educativa** | Estudiantes | "La aceptación es como abrir una puerta en lugar de empujarla. No cambias lo que sientes; cambias tu relación con ello, permitiéndote avanzar a pesar del malestar" |
| **Para IA** | Gemma/Modelos | "Detectar si el usuario muestra apertura a experiencias internas o evitación. Indicadores: uso de lenguaje de apertura ('estoy bien con sentir esto'), permanencia en exposición, ausencia de estrategias de escape" |
| **Para Videojuegos** | BERL/Game Design | "Mecánica de resistencia pasiva: el jugador sostiene una acción (botón de escudo) durante una ráfaga de malestar emocional representado visualmente. La recompensa es la supervivencia y el descubrimiento, no la eliminación del estímulo" |

### 4.2. Ejemplo Completo

```yaml
definitions:
  operational: >
    Capacidad de abrirse a experimentar pensamientos, emociones y
    sensaciones corporales sin intentar controlarlos, modificando el
    comportamiento en dirección a los valores. Medida por CompACT,
    MPFI o FIT-60.
  clinical: >
    Cuando un paciente puede estar presente con el malestar sin huir,
    está practicando aceptación. No es resignación; es disposición a
    experimentar lo que sea necesario para vivir según sus valores.
  computational: >
    Proceso contextual que incrementa la tolerancia a estímulos
    aversivos internos, reduciendo la latencia de exposición y
    aumentando la persistencia conductual en presencia de malestar.
  educational: >
    La aceptación es como abrir una puerta en lugar de empujarla.
    No cambias lo que sientes; cambias tu relación con ello.
  ai: >
    Detectar si el usuario muestra apertura a experiencias internas
    o evitación. Indicadores: lenguaje de apertura, permanencia en
    exposición, ausencia de estrategias de escape.
  videogame: >
    Mecánica de resistencia pasiva: el jugador sostiene una acción
    durante una ráfaga de malestar emocional. La recompensa es la
    supervivencia y el descubrimiento.
```

---

## 5. Relaciones entre Procesos

### 5.1. Tipos de Relación

| Tipo | Representación | Ejemplo |
|------|----------------|---------|
| **Facilita** | `A → incrementa B` | Aceptación → Facilita Acción Comprometida |
| **Inhibe** | `A ─| B` | Evitación → Inhibe Aceptación |
| **Bidireccional** | `A ↔ B` | Fusión ↔ Rumiación |
| **Modera** | `A modifica la fuerza de B→C` | Autoeficacia modera la relación entre Exposición y Reducción de ansiedad |
| **Media** | `A → B → C` | Aceptación media la relación entre Valores y Acción Comprometida |
| **Predice** | `A predice B` | Rigidez predice Inestabilidad emocional |
| **Depende de** | `A requiere B` | Acción Comprometida requiere Clarificación de Valores |

### 5.2. Ejemplo de Red de Relaciones

```
Aceptación
  ↓ facilita
Flexibilidad Psicológica
  ↓ facilita
Acción Comprometida
  ↑ requiere
Clarificación de Valores
  ↓ inhibe
Evitación Experiencial
  ↑ facilita
Fusión Cognitiva
  ↓ facilita
Rumiación
  ↑ facilita
Inercia Emocional
```

### 5.3. Estructura YAML de Relaciones

```yaml
relations:
  - target: "BPO-CTX-000032"
    type: "facilitates"
    weight: 0.85
    confidence: 94
    evidence:
      - source: "meta_analysis"
        count: 12
      - source: "rct"
        count: 8

  - target: "BPO-CTX-000040"
    type: "inhibits"
    weight: 0.72
    confidence: 89
    evidence:
      - source: "meta_analysis"
        count: 15
```

---

## 6. Variables Observables y Latentes

### 6.1. Variables Observables

Cada proceso define **qué puede observarse directamente**:

```yaml
observables:
  - name: "verbal_acceptance"
    description: "Uso de lenguaje de apertura y disposición"
    measurement: "Codificación lingüística del chat"
    source: "TCCN/IA"

  - name: "persistence"
    description: "Tiempo de permanencia en tareas aversivas"
    measurement: "Telemetría de juegos/ejercicios"
    source: "BERL"

  - name: "exposure_completion"
    description: "Porcentaje de completitud de exposiciones"
    measurement: "Registro de actividades"
    source: "BERL"

  - name: "self_report_score"
    description: "Puntuación en instrumentos estandarizados"
    measurement: "Cuestionarios"
    source: "BAD"
```

### 6.2. Variables Latentes

Nunca se observan directamente. **La IA las infiere**:

```yaml
latents:
  - name: "rigidity"
    description: "Grado de inflexibilidad del sistema de procesamiento"
    inferred_from: ["fusion", "avoidance", "perseveration"]

  - name: "psychological_flexibility"
    description: "Capacidad global de adaptación del individuo"
    inferred_from: ["acceptance", "defusion", "values", "committed_action"]

  - name: "contextual_control"
    description: "Grado en que el comportamiento está gobernado por el contexto presente"
    inferred_from: ["contact_present_moment", "self_as_context"]

  - name: "sensitivity"
    description: "Reactividad a estímulos aversivos internos"
    inferred_from: ["avoidance", "distress_tolerance", "emotional_recovery"]
```

---

## 7. Instrumentos Asociados

Cada proceso tiene instrumentos de medición vinculados:

### 7.1. Ejemplo: Aceptación

| Instrumento | Tipo | Preguntas | Fiabilidad | Proceso medido |
|-------------|------|-----------|------------|----------------|
| **MPFI** | Autorreporte | 30 | α = 0.89 | Flexibilidad Psicológica global |
| **CompACT** | Autorreporte | 18 | α = 0.85 | Aceptación, Defusión, Presencia, Valores |
| **FIT-60** | Autorreporte | 60 | α = 0.92 | Flexibilidad Psicológica completa |
| **AAQ-II** | Autorreporte | 10 | α = 0.88 | Evitación experiencial (inverso de Aceptación) |

### 7.2. Ejemplo: Neuropsicología

| Instrumento | Tipo | Proceso medido |
|-------------|------|----------------|
| **Digit Span** | Tarea computarizada | Memoria de trabajo |
| **Corsi** | Tarea computarizada | Memoria visuoespacial |
| **Stroop** | Tarea computarizada | Inhibición cognitiva |
| **WCST** | Tarea computarizada | Flexibilidad cognitiva |
| **TMT A/B** | Tarea computarizada | Velocidad, Shifting |
| **Go/NoGo** | Tarea computarizada | Inhibición motora |
| **N-Back** | Tarea computarizada | Memoria de trabajo |
| **ANT** | Tarea computarizada | Atención ejecutiva |

### 7.3. Estructura YAML

```yaml
instruments:
  - id: "INST-MPFI-001"
    name: "Multidimensional Psychological Flexibility Inventory"
    type: "self_report"
    items: 30
    reliability: 0.89
    measures: ["acceptance", "defusion", "present_moment", "values"]
    administration: ["pre", "mid", "post", "follow_up"]
```

---

## 8. Videojuegos y Ejercicios Asociados

Cada proceso conoce qué juegos y ejercicios lo entrenan:

```yaml
games:
  - id: "GAME-FOREST-001"
    name: "Bosque de los Pensamientos"
    platform: "Godot/Three.js"
    genre: "Exploración/Puzzle"
    processes: ["BPO-CTX-000031", "BPO-CTX-000032"]  # Aceptación, Defusión
    mechanics: ["resistencia pasiva", "defusión visual"]
    telemetry: ["tiempo_permanencia", "reintentos", "completitud"]
    difficulty: "adaptive"
    rewards: ["descubrimientos", "progreso_jardin"]

  - id: "GAME-RIVER-001"
    name: "Río de la Defusión"
    platform: "Godot/Three.js"
    genre: "Reflexión"
    processes: ["BPO-CTX-000032"]  # Defusión
    mechanics: ["soltar_pensamientos", "fluir"]
    telemetry: ["distancia_cognitiva", "latencia"]
    difficulty: "adaptive"
    rewards: ["paz_interior", "expansion_rio"]

  - id: "GAME-KIRBY-001"
    name: "Modo Kirby"
    platform: "Godot/Three.js"
    genre: "Acción/Tolerancia"
    processes: ["BPO-CTX-000040", "BPO-EMO-000008"]  # Evitación, Tolerancia
    mechanics: ["absorber_malestar", "transformar"]
    telemetry: ["absorciones", "tolerancia", "tiempo"]
    difficulty: "adaptive"
    rewards: ["poderes", "crecimiento"]

  - id: "GAME-GUARDIAN-001"
    name: "Reflejos del Guardián"
    platform: "Godot/Three.js"
    genre: "Acción/Reflejos"
    processes: ["BPO-COG-000006", "BPO-COG-000007"]  # Inhibición motora, cognitiva
    mechanics: ["stop/go", "inhibición", "respuesta selectiva"]
    telemetry: ["tiempo_reaccion", "errores", "persistencia"]
    difficulty: "adaptive"
    rewards: ["puntos", "desbloqueo"]
```

---

## 9. Nivel de Evidencia Científica

### 9.1. Escala de Evidencia

| Nivel | Descripción | Criterio |
|-------|-------------|----------|
| **Muy Alta** | Múltiples meta-análisis y RCTs consistentes | ≥ 5 meta-análisis, ≥ 20 RCTs |
| **Alta** | Meta-análisis o múltiples RCTs | ≥ 1 meta-análisis o ≥ 5 RCTs |
| **Moderada** | Estudios controlados con resultados consistentes | ≥ 3 estudios controlados |
| **Baja** | Estudios observacionales o series de caso | Estudios limitados |
| **Experimental** | Evidencia preliminary, estudios en curso | Datos preliminares |

### 9.2. Fuentes de Evidencia

```yaml
evidence:
  level: "high"
  sources:
    - type: "meta_analysis"
      count: 12
      latest_year: 2024
      key_authors: ["Hayes", "Kashdan", "Gloster"]

    - type: "rct"
      count: 45
      populations: ["anxiety", "depression", "chronic_pain", "substance_use"]

    - type: "single_case"
      count: 120

    - type: "time_series"
      count: 850

    - type: "idiographic_studies"
      count: 340

  references:
    - doi: "10.1016/j.jcbs.2022.01.001"
      title: "ACT processes and outcomes: A meta-analysis"
      year: 2022
```

---

## 10. Niveles de Evidencia por Instrumento

| Instrumento | Validez de Constructo | Fiabilidad | Sensibilidad al Cambio | Población |
|-------------|----------------------|------------|----------------------|-----------|
| **MPFI** | Alta (CFI > 0.90) | α = 0.89 | Alta | Adultos |
| **CompACT** | Alta (CFI > 0.92) | α = 0.85 | Moderada | Adultos |
| **AAQ-II** | Moderada (debates sobre unidimensionalidad) | α = 0.88 | Alta | Adultos |
| **FIT-60** | Alta (CFI > 0.91) | α = 0.92 | Alta | Adultos |
| **Digit Span** | Muy Alta | Test-retest: 0.83 | Moderada | 6-89 años |
| **WCST** | Alta | Test-retest: 0.75-0.90 | Moderada | 6-89 años |

---

## 11. Versionado Semántico

### 11.1. Reglas

El BPO **nunca sobrescribe información**. Cada cambio genera una nueva versión:

```
v1.0.0 → v1.0.1 → v1.1.0 → v1.2.0 → v2.0.0
```

| Componente | Significado |
|-----------|-------------|
| **MAJOR** | Cambio en la definición del proceso, nuevas relaciones que rompen compatibilidad |
| **MINOR** | Adición de definiciones, instrumentos o relaciones nuevas |
| **PATCH** | Correcciones de erratas, actualización de evidencia |

### 11.2. Preservación Histórica

```yaml
version_history:
  - version: "1.0.0"
    date: "2026-07-14"
    author: "Arquitectura & Psicología Clínica"
    changes:
      - "Creación inicial del proceso"
      - "Definición operacional, clínica, computacional, educativa, para IA y videojuegos"
      - "Relaciones con Defusión, Valores, Evitación"

  - version: "1.1.0"
    date: "2026-08-15"
    author: "Arquitectura & Psicología Clínica"
    changes:
      - "Agregada definición para videojuegos actualizada"
      - "Nueva relación con Mindfulness"
      - "Actualización de evidencia (2 meta-análisis nuevos)"
```

La IA puede reproducir investigaciones antiguas utilizando exactamente la misma ontología vigente en ese momento.

---

## 12. Representación YAML Completa de un Proceso

```yaml
# ============================================================
# BehavioralOS - Behavioral Process Ontology (BPO)
# Proceso: Acceptance
# UUID: BPO-CTX-000031
# ============================================================

uuid: "BPO-CTX-000031"
name: "Acceptance"
aliases:
  - "Aceptación"
  - "Apertura experiencial"
  - "Recepción"
domain: "Contextual"
subdomain: "Flexibilidad Psicológica"
level: "Individual"
status: "stable"
version: "1.2.0"
author: "Arquitectura & Psicología Clínica"
created: "2026-07-14"
last_revision: "2026-07-14"
language: "es"
synonyms:
  - "Apertura"
  - "Recepción experiencial"
antonyms:
  - "Evitación experiencial"
  - "Control experiencial"
related_to:
  - "BPO-CTX-000032"  # Cognitive Defusion
  - "BPO-CTX-000033"  # Present Moment Contact
  - "BPO-CTX-000034"  # Self as Context
  - "BPO-CTX-000035"  # Values
  - "BPO-CTX-000036"  # Committed Action
  - "BPO-CTX-000040"  # Experiential Avoidance
parent: "BPO-CTX-000000"  # Psychological Flexibility
children: []
evidence_level: "high"

constructs:
  - "Psychological Flexibility"
  - "Experiential Openness"
  - "Willingness"

definitions:
  operational: >
    Capacidad de abrirse a experimentar pensamientos, emociones y
    sensaciones corporales sin intentar controlarlos, modificando el
    comportamiento en dirección a los valores. Medida por CompACT,
    MPFI o FIT-60.
  clinical: >
    Cuando un paciente puede estar presente con el malestar sin huir,
    está practicando aceptación. No es resignación; es disposición a
    experimentar lo que sea necesario para vivir según sus valores.
  computational: >
    Proceso contextual que incrementa la tolerancia a estímulos
    aversivos internos, reduciendo la latencia de exposición y
    aumentando la persistencia conductual en presencia de malestar.
  educational: >
    La aceptación es como abrir una puerta en lugar de empujarla.
    No cambias lo que sientes; cambias tu relación con ello,
    permitiéndote avanzar a pesar del malestar.
  ai: >
    Detectar si el usuario muestra apertura a experiencias internas
    o evitación. Indicadores: uso de lenguaje de apertura ('estoy
    bien con sentir esto'), permanencia en exposición, ausencia de
    estrategias de escape.
  videogame: >
    Mecánica de resistencia pasiva: el jugador sostiene una acción
    (botón de escudo) durante una ráfaga de malestar emocional
    representado visualmente. La recompensa es la supervivencia y
    el descubrimiento, no la eliminación del estímulo.

relations:
  - target: "BPO-CTX-000032"
    type: "facilitates"
    weight: 0.85
    confidence: 94
    evidence:
      - source: "meta_analysis"
        count: 12
      - source: "rct"
        count: 8

  - target: "BPO-CTX-000040"
    type: "inhibits"
    weight: 0.72
    confidence: 89
    evidence:
      - source: "meta_analysis"
        count: 15

  - target: "BPO-CTX-000036"
    type: "facilitates"
    weight: 0.68
    confidence: 82
    evidence:
      - source: "rct"
        count: 10

observables:
  - name: "verbal_acceptance"
    description: "Uso de lenguaje de apertura y disposición"
    measurement: "Codificación lingüística del chat"
    source: "TCCN/IA"

  - name: "persistence"
    description: "Tiempo de permanencia en tareas aversivas"
    measurement: "Telemetría de juegos/ejercicios"
    source: "BERL"

  - name: "exposure_completion"
    description: "Porcentaje de completitud de exposiciones"
    measurement: "Registro de actividades"
    source: "BERL"

  - name: "self_report_score"
    description: "Puntuación en instrumentos estandarizados"
    measurement: "Cuestionarios"
    source: "BAD"

latents:
  - name: "psychological_flexibility"
    description: "Capacidad global de adaptación"
    inferred_from: ["acceptance", "defusion", "values", "committed_action"]

  - name: "willingness"
    description: "Disposición a experimentar"
    inferred_from: ["acceptance", "distress_tolerance"]

instruments:
  - id: "INST-MPFI-001"
    name: "Multidimensional Psychological Flexibility Inventory"
    type: "self_report"
    items: 30
    reliability: 0.89
    measures: ["acceptance", "defusion", "present_moment", "values"]
    administration: ["pre", "mid", "post", "follow_up"]

  - id: "INST-COMPACKT-001"
    name: "Comprehensive Assessment of ACT Processes"
    type: "self_report"
    items: 18
    reliability: 0.85
    measures: ["acceptance", "defusion", "present_moment"]

  - id: "INST-AAQII-001"
    name: "Acceptance and Action Questionnaire-II"
    type: "self_report"
    items: 10
    reliability: 0.88
    measures: ["experiential_avoidance"]  # Inverso de aceptación

games:
  - id: "GAME-FOREST-001"
    name: "Bosque de los Pensamientos"
    platform: "Godot/Three.js"
    genre: "Exploración/Puzzle"
    mechanics: ["resistencia pasiva", "defusión visual"]
    telemetry: ["tiempo_permanencia", "reintentos", "completitud"]
    difficulty: "adaptive"
    rewards: ["descubrimientos", "progreso_jardin"]

  - id: "GAME-RIVER-001"
    name: "Río de la Defusión"
    platform: "Godot/Three.js"
    genre: "Reflexión"
    mechanics: ["soltar_pensamientos", "fluir"]
    telemetry: ["distancia_cognitiva", "latencia"]
    difficulty: "adaptive"
    rewards: ["paz_interior", "expansion_rio"]

exercises:
  - id: "BERL-ACT-001"
    name: "Defusión con globo virtual"
    type: "videogame"
    processes: ["BPO-CTX-000031", "BPO-CTX-000032"]
    duration: "5-10 min"
    difficulty: "adaptive"

  - id: "BERL-ACT-002"
    name: "Escudo de Zelda (respiración)"
    type: "videogame"
    processes: ["BPO-CTX-000031", "BPO-EMO-000008"]
    duration: "3-5 min"
    difficulty: "adaptive"

interventions:
  - framework: "ACT"
    exercises: ["BERL-ACT-001", "BERL-ACT-002"]

  - framework: "PBT"
    exercises: ["BERL-PBT-001"]

  - framework: "FAP"
    exercises: ["BERL-FAP-001"]

services:
  - individual: true
  - couple: true
  - family: true
  - neuropsychology: false
  - training: true
  - research: true

inference_rules:
  - condition: "acceptance_score < 40 AND avoidance_score > 70"
    recommendation: "Prioritize acceptance exercises and defusion"
    confidence: 0.85

  - condition: "acceptance_score > 70 AND committed_action < 40"
    recommendation: "Shift focus to values clarification and committed action"
    confidence: 0.78

telemetry:
  metrics:
    - "completion_rate"
    - "latency"
    - "retries"
    - "progression"
    - "engagement_time"

evidence:
  level: "high"
  sources:
    - type: "meta_analysis"
      count: 12
      latest_year: 2024
    - type: "rct"
      count: 45
      populations: ["anxiety", "depression", "chronic_pain"]
    - type: "single_case"
      count: 120
  references:
    - doi: "10.1016/j.jcbs.2022.01.001"
      title: "ACT processes and outcomes: A meta-analysis"
      year: 2022

version_history:
  - version: "1.0.0"
    date: "2026-07-14"
    changes:
      - "Creación inicial del proceso"
      - "Definiciones múltiples"
      - "Relaciones con Defusión, Valores, Evitación"
  - version: "1.2.0"
    date: "2026-07-14"
    changes:
      - "Actualización de evidencia"
      - "Agregada relación con Mindfulness"
```

---

## 13. Integración con el Ecosistema

| Módulo | Cómo consulta el BPO |
|--------|---------------------|
| **BERL** | Selecciona ejercicios basados en procesos del BPO |
| **AHEE** | Adapta el contenido según edad, desarrollo y contexto del proceso |
| **TCCN** | Detecta procesos durante la sesión y consulta definiciones para IA |
| **BXP** | Construye experiencias terapéuticas personalizadas |
| **BPOS** | Documenta el análisis funcional usando terminología del BPO |
| **BIP** | Genera analítica longitudinal comparando procesos del BPO |
| **BROS** | Construye reportes clínicos con definiciones del BPO |
| **BSC** | Seguimiento continuo del progreso usando métricas del BPO |
| **BEC** | Compone programas usando la ontología del BPO |
| **BRIL** | Expone los procesos como servicios reutilizables |
| **BXE** | Explica al terapeuta el razonamiento detrás de las recomendaciones |

---

## 14. Estructura del Repositorio

```
docs/
  ontology/
    index.md
    taxonomy.md
    relationships.md
    lifecycle.md
    evidence_levels.md
    process_schema.yaml
    versioning.md
    quality_rules.md
    processes/
      acceptance.md
      cognitive_defusion.md
      values.md
      committed_action.md
      working_memory.md
      inhibitory_control.md
      ...
```

---

## 15. Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2026-07-14 | Arquitectura & Psicología Clínica | Creación del documento. UUID scheme, metadatos, definiciones múltiples, relaciones, variables, instrumentos, evidencia, representación YAML completa. |

---

**Fin del documento `bpo-ontology.md`**
