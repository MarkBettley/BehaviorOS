---
id: ONT-001
title: Ontología Formal del Comportamiento
version: 2.0.0
status: Stable
owner: Arquitectura & Psicología Clínica
last_updated: 2026-08-07
depends_on:
  - PHI-001 (Filosofía)
  - PRN-001 (Principios)
exports:
  - Metamodelo de Entidades y Relaciones
  - Taxonomía de Procesos Psicológicos (PBT) — 18 dominios
  - Taxonomía de Marcos Relacionales (RFT)
  - Taxonomía de Operaciones Motivacionales y Estímulos
  - Especificación de Grafos Computacionales (Nodos, Aristas, Atributos)
  - Reglas de Inferencia y Actualización
used_by:
  - BPO (Behavioral Process Ontology)
  - AAO (Adaptive Assessment Orchestrator)
  - BERL (Behavioral Exercise Research Lab)
  - BSC (Behavioral Science Cloud)
  - BKGE (Behavioral Knowledge Graph Engine)
  - BWM (Behavioral World Model)
  - Behavioral Twin
  - RFT Engine
  - MPO (Meta-Process Orchestrator)
---

# BehavioralOS – Ontología Formal del Comportamiento

> *"La ontología no es un catálogo de conceptos. Es el lenguaje en el que el sistema piensa sobre el comportamiento humano. Si la ontología es incorrecta, todo lo que construyamos sobre ella será frágil."*

---

## 1. Propósito y Alcance

### 1.1. Propósito
Este documento define el **modelo de conocimiento compartido** de todo el BehavioralOS. Especifica:

- **Qué entidades** existen en el universo del comportamiento (Organismo, Contexto, Evento, Conducta, Consecuencia, etc.).
- **Qué relaciones** pueden darse entre ellas (causa, mantiene, generaliza, transforma, etc.).
- **Qué procesos psicológicos** son relevantes (dominios y procesos específicos de PBT, ACT, FAP, DBT, etc.).
- **Qué marcos relacionales** (RFT) modelan el lenguaje y la cognición.
- **Cómo se representa computacionalmente** todo esto (grafos, atributos, versionado, incertidumbre).

### 1.2. Alcance
La ontología cubre tres niveles de abstracción:

1. **Nivel Filosófico**: El contextualismo funcional y sus implicaciones (el comportamiento es una interacción organismo-contexto; la unidad de análisis es la relación funcional).
2. **Nivel Científico**: Los constructos de la psicología basada en procesos (PBT), el Análisis Experimental de la Conducta (AEC), la Teoría de los Marcos Relacionales (RFT) y la neuropsicología funcional.
3. **Nivel Computacional**: La representación en grafos (nodos y aristas tipadas con atributos), las reglas de inferencia (actualización bayesiana, propagación de confianza) y los contratos de integración con los motores.

### 1.3. Principio Fundamental
La ontología se rige por el **contextualismo funcional**: el comportamiento no puede entenderse fuera del contexto en el que ocurre. Por lo tanto, **ninguna entidad se define de forma aislada**; siempre se define en relación con otras entidades y con el contexto.

---

## 2. Fundamentos Teóricos

### 2.1. Contextualismo Funcional (Hayes, 1993)
- La verdad de una afirmación sobre el comportamiento se juzga por su **utilidad** para predecir e influir en el comportamiento, no por su correspondencia con una realidad interna.
- La unidad de análisis es la **interacción organismo-contexto** en un momento dado.
- El objetivo de la ciencia es desarrollar **reglas que aumenten la precisión, el alcance y la profundidad** de nuestra comprensión y acción.

### 2.2. Análisis Experimental de la Conducta (AEC) (Skinner, 1938; Catania, 1998)
- La conducta es una función de sus **consecuencias** (reforzamiento, castigo, extinción) y de los **estímulos antecedentes** que la discriminan.
- Las **operaciones motivacionales** (EO, AO) alteran el valor reforzante de las consecuencias y la probabilidad de la conducta.
- La **historia de aprendizaje** (contingencias pasadas) es la base de los repertorios actuales.

### 2.3. Teoría de los Marcos Relacionales (RFT) (Hayes, Barnes-Holmes, Roche, 2001)
- El lenguaje y la cognición humana se basan en la capacidad de **derivar relaciones arbitrarias** entre estímulos.
- Los **marcos relacionales** (coordinación, distinción, oposición, comparación, temporalidad, espacialidad, jerarquía, deícticos, causales, condicionales, analógicos) son las unidades de esta capacidad.
- Las relaciones pueden ser **derivadas** (mutua implicación, implicación combinatoria) y **transforman funciones** (un estímulo adquiere la función de otro por su relación).

### 2.4. Psicología Basada en Procesos (PBT) (Hayes, Hofmann, et al., 2019)
- Los trastornos psicológicos no son categorías discretas, sino **patrones de procesos** que interactúan dinámicamente.
- Los procesos se organizan en **dominios** (cognitivo, afectivo, atencional, motivacional, conductual, interpersonal, biológico).
- La intervención debe dirigirse a modificar **procesos específicos**, no a tratar "trastornos" como entidades estáticas.

### 2.5. Extended Evolutionary Meta-Model (EEMM) (Hayes, 2022)
- Integra AEC, RFT y PBT en un modelo de **evolución biológica, cultural y conductual**.
- Incluye seis dimensiones: **Cognición, Afecto, Atención, Self, Motivación, Conducta**.
- Cada dimensión es un sistema dinámico que interactúa con las demás y con el contexto.

---

## 3. Metamodelo de Entidades Fundamentales

### 3.1. Nivel 0: El Sujeto (Organismo)

| Atributo | Tipo | Descripción | Ejemplo |
|----------|------|-------------|---------|
| `id` | UUID | Identificador único del organismo. | `org_001` |
| `phylogenetic_history` | JSON | Historia evolutiva (especie, genética, etc.). | `{"species": "homo_sapiens", "genetic_markers": [...]}` |
| `ontogenetic_history` | JSON | Historia de aprendizaje (eventos, contingencias). | Referencia a entidades `Evento` y `Conducta`. |
| `cultural_history` | JSON | Historia cultural (lenguaje, normas, valores). | `{"language": "es", "cultural_contexts": [...]}` |
| `capacities` | JSON | Capacidades sensoriales, motoras, cognitivas. | `{"vision": "normal", "audition": "normal", "motor_skills": "normal"}` |
| `state` | JSON | Estado fisiológico actual (energía, sueño, etc.). | `{"energy": 0.7, "sleep_quality": 0.4}` |
| `contextual_state` | JSON | Estado contextual actual (ubicación, compañía, etc.). | `{"location": "home", "social_company": "alone"}` |

### 3.2. Contexto

| Atributo | Tipo | Descripción | Ejemplo |
|----------|------|-------------|---------|
| `id` | UUID | Identificador único del contexto. | `ctx_001` |
| `type` | Enum | `físico`, `temporal`, `interpersonal`, `verbal`, `digital`, `terapéutico`, `virtual`. | `"interpersonal"` |
| `features` | JSON | Características específicas del contexto. | `{"persons_present": 2, "activity": "therapy_session"}` |
| `time` | Timestamp | Momento en el que ocurre el evento. | `2026-07-01T14:30:00Z` |
| `duration` | Integer | Duración en segundos (si aplica). | `1800` |

### 3.3. Evento

| Atributo | Tipo | Descripción | Ejemplo |
|----------|------|-------------|---------|
| `id` | UUID | Identificador único del evento. | `evt_001` |
| `type` | Enum | `público`, `privado`, `ambiental`, `social`, `verbal`, `fisiológico`. | `"verbal"` |
| `organism_ref` | UUID | Referencia al organismo que experimenta el evento. | `org_001` |
| `context_ref` | UUID | Referencia al contexto en el que ocurre. | `ctx_001` |
| `content` | JSON | Contenido del evento (ej. un pensamiento, una palabra, una acción). | `{"thought": "No soy suficiente"}` |
| `intensity` | Float (0-1) | Intensidad de la respuesta (ej. emocional). | `0.85` |
| `latency` | Integer | Tiempo de latencia desde el antecedente (ms). | `350` |
| `confidence` | Float (0-1) | Nivel de confianza en la observación. | `0.92` |

### 3.4. Conducta

| Atributo | Tipo | Descripción | Ejemplo |
|----------|------|-------------|---------|
| `id` | UUID | Identificador único de la conducta. | `beh_001` |
| `type` | Enum | `respondiente`, `operante`, `verbal`, `encubierta`, `motora`, `social`, `digital`. | `"operante"` |
| `organism_ref` | UUID | Referencia al organismo que emite la conducta. | `org_001` |
| `context_ref` | UUID | Referencia al contexto en el que ocurre. | `ctx_001` |
| `antecedent_ref` | UUID | Evento o estímulo que precede a la conducta (opcional). | `evt_001` |
| `consequence_ref` | UUID | Evento o estímulo que sigue a la conducta (opcional). | `evt_002` |
| `function` | Enum | `escape`, `avoidance`, `attention`, `sensory`, `tangible`, `social`, `automatic`. | `"avoidance"` |
| `probability` | Float (0-1) | Probabilidad de ocurrencia en el contexto dado. | `0.78` |
| `duration` | Integer | Duración en segundos. | `120` |
| `frequency` | Integer | Frecuencia observada (ej. por día). | `3` |
| `variability` | Float (0-1) | Grado de variabilidad en la ejecución. | `0.35` |
| `generalization` | Float (0-1) | Grado en que la conducta se generaliza a otros contextos. | `0.62` |
| `confidence` | Float (0-1) | Nivel de confianza en la observación. | `0.88` |

### 3.5. Consecuencia (Evento que modifica la conducta)

| Atributo | Tipo | Descripción | Ejemplo |
|----------|------|-------------|---------|
| `id` | UUID | Identificador único de la consecuencia. | `cns_001` |
| `type` | Enum | `reforzamiento_positivo`, `reforzamiento_negativo`, `castigo_positivo`, `castigo_negativo`, `extinción`, `automática`, `social`, `demorada`. | `"reforzamiento_negativo"` |
| `value` | Float (0-1) | Valor funcional de la consecuencia (ej. magnitud del reforzador). | `0.85` |
| `probability` | Float (0-1) | Probabilidad de que la consecuencia siga a la conducta. | `0.95` |
| `delay` | Integer | Demora en milisegundos desde la conducta. | `500` |
| `scheduled` | Boolean | Si la consecuencia es programada (vs. natural). | `False` |
| `schedule` | JSON | Especificación del programa de reforzamiento (FR, VR, FI, VI, etc.). | `{"type": "VR", "ratio": 10}` |
| `context_ref` | UUID | Contexto en el que ocurre. | `ctx_001` |
| `confidence` | Float (0-1) | Nivel de confianza en la observación. | `0.91` |

### 3.6. Operación Motivacional (MO)

| Atributo | Tipo | Descripción | Ejemplo |
|----------|------|-------------|---------|
| `id` | UUID | Identificador único de la MO. | `mo_001` |
| `type` | Enum | `EO` (establecedora), `AO` (abolidora), `CMO-R` (relacional), `CMO-S` (señal), `CMO-T` (transformacional). | `"EO"` |
| `effect` | JSON | Efecto sobre el valor del reforzador y la probabilidad de la conducta. | `{"reinforcer_value": 0.9, "behavior_probability": 0.7}` |
| `context_ref` | UUID | Contexto en el que opera. | `ctx_001` |
| `duration` | Integer | Duración de la MO en segundos. | `3600` |
| `confidence` | Float (0-1) | Nivel de confianza en la inferencia. | `0.79` |

### 3.7. Estímulo

| Atributo | Tipo | Descripción | Ejemplo |
|----------|------|-------------|---------|
| `id` | UUID | Identificador único del estímulo. | `stm_001` |
| `type` | Enum | `SD` (discriminativo), `SΔ` (delta), `condicionado`, `incondicionado`, `neutral`, `contextual`, `compuesto`. | `"SD"` |
| `modality` | Enum | `visual`, `auditiva`, `táctil`, `olfativa`, `gustativa`, `verbal`, `interna`. | `"verbal"` |
| `content` | JSON | Contenido del estímulo. | `{"phrase": "¿Estás seguro de que puedes hacerlo?"}` |
| `function` | Enum | `apetitiva`, `aversiva`, `neutral`, `informativa`. | `"aversiva"` |
| `context_ref` | UUID | Contexto en el que aparece. | `ctx_001` |
| `confidence` | Float (0-1) | Nivel de confianza en la identificación. | `0.84` |

### 3.8. Marco Relacional (RFT)

| Atributo | Tipo | Descripción | Ejemplo |
|----------|------|-------------|---------|
| `id` | UUID | Identificador único del marco relacional. | `rft_001` |
| `type` | Enum | `coordinación`, `distinción`, `oposición`, `comparación`, `temporalidad`, `espacialidad`, `jerarquía`, `deíctico`, `causal`, `condicional`, `analógico`, `metafórico`. | `"comparación"` |
| `nodes` | JSON | Nodos del marco (estímulos, eventos, conceptos). | `{"A": "yo", "B": "fracaso"}` |
| `relations` | JSON | Relaciones entre nodos (dirigidas, ponderadas). | `[{"source": "yo", "target": "fracaso", "relation": "coordinación", "weight": 0.85}]` |
| `derived` | Boolean | Si la relación es derivada (vs. entrenada directamente). | `True` |
| `transformation` | JSON | Transformación de funciones asociada. | `{"source": "fracaso", "target": "vergüenza", "function": "apetitiva->aversiva"}` |
| `context_ref` | UUID | Contexto en el que se activa el marco. | `ctx_001` |
| `strength` | Float (0-1) | Fuerza de la relación. | `0.78` |
| `flexibility` | Float (0-1) | Capacidad de cambiar el marco bajo nuevas contingencias. | `0.42` |
| `evidence` | JSON | Evidencia que respalda la existencia del marco. | `{"sources": ["conversation", "gameplay"], "confidence": 0.88}` |
| `history` | JSON | Historial de cambios en la fuerza y flexibilidad. | `[{"timestamp": "2026-06-01", "strength": 0.80}, {"timestamp": "2026-07-01", "strength": 0.78}]` |

### 3.9. Hipótesis Funcional

| Atributo | Tipo | Descripción | Ejemplo |
|----------|------|-------------|---------|
| `id` | UUID | Identificador único de la hipótesis. | `hyp_001` |
| `description` | String | Descripción narrativa de la hipótesis. | `"La evitación social se mantiene por reforzamiento negativo (alivio de la ansiedad)"` |
| `antecedents` | JSON | Antecedentes implicados. | `[{"type": "SD", "content": "crítica social"}]` |
| `behavior` | JSON | Conducta objetivo. | `{"type": "operante", "function": "avoidance"}` |
| `consequences` | JSON | Consecuencias que mantienen la conducta. | `[{"type": "reforzamiento_negativo", "value": 0.85}]` |
| `processes` | JSON | Procesos psicológicos implicados. | `["avoidance_experiential", "fusion_cognitiva"]` |
| `relational_frames` | JSON | Marcos relacionales relevantes. | `[{"type": "coordinación", "nodes": {"A": "yo", "B": "fracaso"}}]` |
| `evidence_for` | JSON | Evidencia a favor. | `[{"source": "AAO", "confidence": 0.82}]` |
| `evidence_against` | JSON | Evidencia en contra. | `[{"source": "BERL", "confidence": 0.21}]` |
| `confidence` | Float (0-1) | Nivel de confianza global. | `0.68` |
| `predictions` | JSON | Predicciones verificables. | `[{"if": "aumentar_aceptacion", "then": "disminuir_evitacion", "expected_effect": 0.5}]` |
| `status` | Enum | `activa`, `confirmada`, `rechazada`, `en_revision`. | `"activa"` |
| `history` | JSON | Historial de actualizaciones. | `[{"timestamp": "2026-06-01", "confidence": 0.55}, {"timestamp": "2026-07-01", "confidence": 0.68}]` |

### 3.10. Valor (en el sentido de ACT)

| Atributo | Tipo | Descripción | Ejemplo |
|----------|------|-------------|---------|
| `id` | UUID | Identificador único del valor. | `val_001` |
| `name` | String | Nombre del valor. | `"Conexión familiar"` |
| `domain` | Enum | `trabajo`, `familia`, `pareja`, `amigos`, `salud`, `crecimiento`, `ocio`, `espiritualidad`, `educación`, `comunidad`. | `"familia"` |
| `behaviors` | JSON | Conductas asociadas al valor. | `["llamar a mis padres", "asistir a reuniones familiares", "compartir emociones"]` |
| `barriers` | JSON | Barreras que impiden la conducta valorada. | `["evitación social", "crítica interna"]` |
| `natural_reinforcers` | JSON | Reforzadores naturales asociados. | `["sentimiento de pertenencia", "calidez emocional"]` |
| `costs` | JSON | Costos asociados a la conducta valorada. | `["esfuerzo emocional", "tiempo"]` |
| `coherence` | Float (0-1) | Grado de coherencia con otras conductas y valores. | `0.82` |
| `confidence` | Float (0-1) | Nivel de confianza en la identificación. | `0.91` |
| `history` | JSON | Historial de cambios en la coherencia. | `[{"timestamp": "2026-06-01", "coherence": 0.75}]` |

---

## 4. Taxonomía de Procesos Psicológicos (PBT)

### 4.1. Dominios y Procesos

La ontología organiza los procesos psicológicos en dieciocho dominios, cada uno con procesos específicos, indicadores observables y relación con otros procesos.

| Dominio | Procesos | Definición Operacional | Indicadores |
|---------|----------|------------------------|-------------|
| **Cognitivo** | Defusión cognitiva | Capacidad de observar pensamientos como eventos mentales, no como hechos. | Distancia en la relación pensamiento-conducta; latencia de fusión. |
| | Aceptación radical | Disposición a experimentar eventos privados sin intentar cambiarlos. | Tiempo de permanencia en experiencias incómodas; uso de evitación. |
| | Flexibilidad atencional | Capacidad de dirigir y mantener la atención en el presente. | Variabilidad atencional; tiempo de enfoque en tarea. |
| | Metacognición | Capacidad de reflexionar sobre los propios procesos cognitivos. | Uso de lenguaje metacognitivo; precisión en autorreportes. |
| **Afectivo** | Regulación emocional (funcional) | Capacidad de modificar la respuesta emocional de manera flexible según el contexto. | Cambio en intensidad emocional; variabilidad en estrategias. |
| | Autocompasión | Tratarse a uno mismo con amabilidad y comprensión. | Uso de lenguaje compasivo; frecuencia de autocrítica. |
| | Tolerancia al malestar | Capacidad de permanecer en contacto con emociones difíciles. | Duración de exposición; evitación conductual. |
| **Atencional** | Conciencia del momento presente | Contacto con el aquí y ahora, sin distracción. | Precisión en tareas de mindfulness; vagabundeo mental. |
| | Control atencional | Capacidad de dirigir y sostener la atención. | Tiempo de reacción; precisión en tareas de atención sostenida. |
| **Motivacional** | Clarificación de valores | Identificación de direcciones de vida importantes. | Consistencia entre valores reportados y conductas. |
| | Acción comprometida | Conducta guiada por valores, incluso con malestar. | Frecuencia de acciones coherentes con valores. |
| | Sensibilidad a contingencias | Capacidad de aprender de las consecuencias de la conducta. | Cambio en la conducta ante cambios en consecuencias. |
| **Conductual** | Evitación experiencial | Intentos de evitar o escapar de eventos privados. | Frecuencia de evitación; uso de conductas de escape. |
| | Variabilidad conductual | Rango de respuestas en un contexto dado. | Número de estrategias utilizadas; flexibilidad en la elección. |
| | Persistencia | Mantenimiento de la conducta a pesar de la dificultad. | Duración de la conducta; número de intentos. |
| **Interpersonal** | Conexión social | Capacidad de establecer y mantener relaciones significativas. | Frecuencia de interacciones; calidad percibida. |
| | Asertividad | Capacidad de expresar necesidades y límites de manera clara. | Uso de lenguaje asertivo; frecuencia de concesiones. |
| | Validación | Capacidad de reconocer y aceptar las experiencias del otro. | Uso de lenguaje validante; respuesta a la vulnerabilidad. |
| **Biológico** | Regulación fisiológica | Capacidad de modular la activación autonómica. | Variabilidad de la frecuencia cardíaca; conductancia de la piel. |
| | Sueño y descanso | Patrones de sueño y recuperación. | Duración del sueño; calidad del sueño. |
| | Nutrición y ejercicio | Patrones de alimentación y actividad física. | Frecuencia de ejercicio; ingesta nutricional. |
| **Self / Identidad** | Self-as-context | Capacidad de observar el yo como contexto estable, no como contenido. | Uso de perspectiva deíctica; flexibilidad en auto-referencia. |
| | Autoconcepto | Representación del self que integra experiencias pasadas y presentes. | Coherencia narrativa; consistencia entre auto-reporte y conducta. |
| | Autoestima funcional | Valoración del self basada en valores, no en comparaciones. | Ratio autocrítica/autocompasión; respuesta ante retroalimentación. |
| **Trauma y Resiliencia** | Procesamiento de trauma | Integración de experiencias traumáticas sin evitación ni sobrecarga. | Ventana de tolerancia; latencia de respuesta ante activadores. |
| | Regulación de la ventana de tolerancia | Capacidad de mantener la activación dentro de un rango funcional. | Tiempo en zona de hiper/hipo activación; recuperación post-activación. |
| | Resiliencia | Capacidad de recuperarse y crecer ante la adversidad. | Tiempo de recuperación; búsqueda de apoyo; reenfoque en valores. |
| **Hábitos y Rutinas** | Automaticidad conductual | Conductas ejecutadas sin deliberación consciente. | Frecuencia estable; bajo costo atencional; resistencia a distracción. |
| | Ciclo hábito (señala-rutina-recompensa) | Secuencia automática desencadenada por una señal interna o externa. | Identificación de señales; variabilidad en rutinas; valor de recompensa. |
| | Construcción de hábitos | Capacidad de establecer nuevas rutinas funcionales. | Adherencia a nuevas conductas a los 30/60/90 días; auto-eficacia. |
| **Sueño y Ritmos Circadianos** | Higiene del sueño | Conductas que promueven un sueño reparador. | Regularidad de horarios; ambiente de sueño; consumo de estimulantes. |
| | Regulación circadiana | Sincronización de los ritmos biológicos con el ciclo luz-oscuro. | Exposición a luz natural; horarios de comida; consistencia de rutina. |
| | Insomnio conductual | Dificultad para conciliar o mantener el sueño con patrones disfuncionales. | Latencia de sueño; despertares nocturnos; somnolencia diurna. |
| **Dolor y Condiciones Crónicas** | Aceptación del dolor | Capacidad de experimentar dolor sin evitación ni catastrofización. | Nivel de evitación; catastrofismo; funcionamiento a pesar del dolor. |
| | Flexibilidad psicológica ante enfermedad | Capacidad de vivir con una condición crónica manteniendo valores. | Adherencia a tratamiento; participación en actividades valoradas. |
| | Regulación del dolor | Estrategias conductuales y cognitivas para modular la experiencia del dolor. | Uso de estrategias no-farmacológicas; percepción de control. |
| **Sustancias y Adicciones** | Motivación al cambio | Etapas de preparación para modificar el uso de sustancias. | Estadio de cambio; ambivalencia; autoeficacia percibida. |
| | Gestión del craving | Capacidad de experimentar deseo sin actuar en consecuencia. | Latencia entre craving y acción; uso de estrategias de afrontamiento. |
| | Recuperación funcional | Reconstrucción de un repertorio conductual alternativo al uso. | Abstinencia sostenida; engagement en actividades no compatibles con uso. |
| **Sexualidad e Intimidad** | Intimidad emocional | Capacidad de establecer conexión profunda y vulnerable con otro. | Apertura emocional; comunicación de necesidades; respuesta a vulnerabilidad. |
| | Funcionamiento sexual funcional | Respuesta sexual adaptada al contexto y al deseo propio. | Satisfacción sexual; ausencia de evitación; comunicación sexual. |
| | Orientación y expresión | Exploración y aceptación de la propia identidad sexual y de género. | Autoaceptación; expresión auténtica; manejo de estigma. |
| **Desarrollo y Maduración** | Adaptación al ciclo vital | Ajuste de conductas y expectativas a las demandas de cada etapa. | Flexibilidad en roles; integración de pérdidas y ganancias. |
| | Duelo y pérdida | Procesamiento de la pérdida de personas, roles o capacidades. | Intensidad y duración del duelo; integración de la pérdida. |
| | Sabiduría experiencial | Uso reflexivo de la experiencia para guiar decisiones. | Calidad del juicio; apertura a perspectivas múltiples. |
| **Funciones Ejecutivas** | Inhibición conductual | Capacidad de suprimir respuestas prepotentes. | Tiempo de inhibición; errores de perseveración; control de impulsos. |
| | Flexibilidad cognitiva | Capacidad de cambiar de estrategia o perspectiva. | Cambios exitosos de tarea; adaptación a reglas cambiantes. |
| | Planificación y organización | Capacidad de secuenciar acciones hacia una meta. | Completación de tareas multietapa; uso de estrategias de organización. |
| | Memoria de trabajo | Capacidad de mantener y manipular información temporalmente. | Span de memoria; precisión en tareas dual-task. |
| **Cultura y Contexto** | Adaptación cultural | Ajuste de la conducta a normas y valores culturales. | Competencia cultural; reducción de estrés aculturativo. |
| | Contextualización de la conducta | Capacidad de entender la conducta en su contexto sociocultural. | Uso de lenguaje contextualizado; ajuste de intervenciones. |
| | Pluralismo de valores | Aceptación de marcos de valores múltiples y diferentes. | Tolerancia a la diversidad; flexibilidad ética. |
| **Digital y Virtual** | Conducta mediada por tecnología | Procesos psicológicos que operan en entornos digitales. | Patrones de uso; engagement; regulación del tiempo en pantalla. |
| | Bienestar digital | Equilibrio entre uso tecnológico y bienestar subjetivo. | Satisfacción con el uso; impacto en sueño y relaciones. |
| | Alfabetización digital crítica | Capacidad de evaluar y navegar información en entornos digitales. | Pensamiento crítico ante contenido digital; manejo de desinformación. |

### 4.2. Relaciones entre Procesos

La ontología define relaciones causales y correlacionales entre procesos. Estas relaciones se actualizan dinámicamente con la evidencia.

| Relación | Descripción | Ejemplo |
|----------|-------------|---------|
| `facilitates` | Un proceso aumenta la probabilidad de otro. | Defusión → Aceptación |
| `inhibits` | Un proceso disminuye la probabilidad de otro. | Evitación experiencial → Aceptación |
| `mediates` | Un proceso es un mecanismo a través del cual otro produce cambio. | Flexibilidad atencional → Regulación emocional |
| `moderates` | Un proceso modifica la fuerza de la relación entre otros dos. | Autocompasión → (Evitación → Aceptación) |
| `predicts` | Un proceso predice la ocurrencia de otro. | Clarificación de valores → Acción comprometida |
| `generalizes_to` | El aprendizaje en un contexto se extiende a otro. | Defusión en terapia → Defusión en trabajo |

---

## 5. Taxonomía de Marcos Relacionales (RFT)

### 5.1. Tipos de Marcos

| Tipo | Definición | Ejemplo | Transformación de función típica |
|------|------------|---------|----------------------------------|
| Coordinación | A = B | "Soy fracasado" | Función de "fracaso" se transfiere a "yo" |
| Distinción | A ≠ B | "Yo no soy mi ansiedad" | Disminuye fusión |
| Oposición | A ↔ No A | "Fracaso ↔ Éxito" | Cambio de valencia afectiva |
| Comparación | A > B / A < B | "Soy peor que los demás" | Aumento de autocrítica |
| Temporalidad | Antes/Después | "Antes de la terapia, ahora…" | Cambio de perspectiva |
| Espacialidad | Aquí/Allí | "La ansiedad está aquí, yo estoy allí" | Desidentificación |
| Jerarquía | Parte de / Pertenece a | "La ansiedad es parte de mí, no todo yo" | Reducción de fusión |
| Deícticos | Yo/Tú; Aquí/Allí; Ahora/Entonces | Cambio de perspectiva interpersonal | Aumento de flexibilidad |
| Causal | Si… entonces… | "Si fracaso, entonces no valgo" | Condicionamiento de valencia |
| Condicional | Si X, entonces Y | "Si estoy tranquilo, entonces puedo actuar" | Planificación de conducta |
| Analógico | A es como B | "La ansiedad es como una ola" | Reducción de evitación |
| Metafórico | A se relaciona con B como C con D | "La vida es como un río" | Cambio de marco semántico |

### 5.2. Propiedades de los Marcos

| Propiedad | Definición | Métrica |
|-----------|------------|---------|
| **Fuerza (strength)** | Grado de activación o aplicabilidad del marco. | Float (0-1) |
| **Flexibilidad (flexibility)** | Capacidad de cambiar el marco ante nuevas contingencias. | Float (0-1) |
| **Derivación** | Si la relación es derivada vs. entrenada directamente. | Boolean |
| **Contexto** | Contextos en los que se activa el marco. | Array de UUID |
| **Historia** | Historial de cambios en fuerza y flexibilidad. | JSON |
| **Evidencia** | Fuentes y confianza de la evidencia que respalda el marco. | JSON |

---

## 6. Representación Computacional (Grafos)

### 6.1. Especificación del Grafo

La ontología se implementa como un **grafo dirigido y etiquetado** donde:

- **Nodos**: Representan entidades (Organismo, Contexto, Evento, Conducta, Consecuencia, MO, Estímulo, Marco Relacional, Hipótesis, Valor, Proceso, etc.).
- **Aristas**: Representan relaciones semánticas (causa, mantiene, generaliza, facilita, inhibe, etc.).
- **Atributos**: Cada nodo y arista tiene atributos (id, tipo, confianza, evidencia, versión, etc.).

### 6.2. Tipos de Nodos

| Tipo | Descripción | Atributos clave |
|------|-------------|-----------------|
| `Organism` | El sujeto de la conducta. | `id`, `ontogenetic_history`, `cultural_history`, `capacities`, `state`. |
| `Context` | El entorno en el que ocurre la conducta. | `id`, `type`, `features`, `time`, `duration`. |
| `Event` | Un fenómeno observable o no observable. | `id`, `type`, `content`, `intensity`, `latency`, `confidence`. |
| `Behavior` | Una conducta operante, respondiente, verbal, etc. | `id`, `type`, `function`, `probability`, `duration`, `frequency`, `variability`, `generalization`, `confidence`. |
| `Consequence` | Una consecuencia que modifica la conducta. | `id`, `type`, `value`, `probability`, `delay`, `schedule`, `confidence`. |
| `MotivationalOperation` | Una MO que altera el valor del reforzador. | `id`, `type`, `effect`, `duration`, `confidence`. |
| `Stimulus` | Un estímulo discriminativo, delta, condicionado, etc. | `id`, `type`, `modality`, `content`, `function`, `confidence`. |
| `RelationalFrame` | Un marco relacional RFT. | `id`, `type`, `nodes`, `relations`, `derived`, `transformation`, `strength`, `flexibility`, `confidence`. |
| `Hypothesis` | Una hipótesis funcional sobre la conducta. | `id`, `description`, `antecedents`, `behavior`, `consequences`, `processes`, `relational_frames`, `confidence`, `predictions`, `status`. |
| `Value` | Un valor ACT (dirección de vida). | `id`, `name`, `domain`, `behaviors`, `barriers`, `natural_reinforcers`, `costs`, `coherence`. |
| `Process` | Un proceso psicológico (PBT). | `id`, `name`, `domain`, `definition`, `indicators`, `confidence`. |

### 6.3. Tipos de Aristas

| Tipo | Descripción | Direccionalidad |
|------|-------------|-----------------|
| `causes` | A causa B (relación causal directa). | A → B |
| `maintains` | A mantiene B (relación de mantenimiento). | A → B |
| `evokes` | A evoca B (A provoca la ocurrencia de B). | A → B |
| `strengthens` | A fortalece B (aumenta la probabilidad o intensidad). | A → B |
| `weakens` | A debilita B (disminuye la probabilidad o intensidad). | A → B |
| `belongs_to` | A pertenece a B (taxonomía). | A → B |
| `generalizes_to` | El aprendizaje de A se generaliza a B. | A → B |
| `derived_from` | A se deriva de B (relación RFT). | A → B |
| `measured_by` | A se mide mediante B (instrumento). | A → B |
| `supported_by` | A está respaldado por B (evidencia). | A → B |
| `contradicted_by` | A es contradicho por B (evidencia). | A → B |
| `implements` | A implementa B (intervención → proceso). | A → B |
| `requires` | A requiere B (prerrequisito). | A → B |
| `predicts` | A predice B (modelo predictivo). | A → B |
| `transforms` | A transforma la función de B (RFT). | A → B |
| `inhibits` | A inhibe B (disminuye la probabilidad). | A → B |
| `facilitates` | A facilita B (aumenta la probabilidad). | A → B |
| `contextualizes` | A contextualiza B (B ocurre en el contexto de A). | A → B |
| `reinforces` | A refuerza B (consecuencia → conducta). | A → B |
| `punishes` | A castiga B (consecuencia → conducta). | A → B |
| `modulates` | A modula la relación entre B y C. | A → (B,C) |
| `shares_process_with` | A comparte proceso con B. | A ↔ B |
| `part_of` | A es parte de B. | A → B |
| `instance_of` | A es una instancia de B. | A → B |

### 6.4. Atributos Comunes a Todos los Nodos y Aristas

| Atributo | Tipo | Descripción | Obligatorio |
|----------|------|-------------|-------------|
| `id` | UUID | Identificador único. | Sí |
| `version` | String | Versión semántica (ej. "1.2.0"). | Sí |
| `status` | Enum | `draft`, `active`, `deprecated`, `superseded`. | Sí |
| `created_at` | Timestamp | Fecha de creación. | Sí |
| `updated_at` | Timestamp | Fecha de última actualización. | Sí |
| `created_by` | UUID | Quién creó la entidad. | Sí |
| `updated_by` | UUID | Quién actualizó la entidad. | Sí |
| `confidence` | Float (0-1) | Nivel de confianza en la entidad/relación. | Sí |
| `evidence` | JSON | Evidencia que respalda la entidad/relación. | No |
| `history` | JSON | Historial de cambios. | No |
| `context_ref` | UUID | Contexto en el que es aplicable. | No |
| `tags` | Array | Etiquetas para búsqueda y filtrado. | No |

---

## 7. Reglas de Inferencia y Actualización

### 7.1. Actualización Bayesiana de Hipótesis

Cuando nueva evidencia E llega al sistema, la confianza de una hipótesis H se actualiza mediante el teorema de Bayes:

P(H|E) = [P(E|H) * P(H)] / P(E)

Donde:
- `P(H)`: Confianza previa.
- `P(E|H)`: Probabilidad de la evidencia dado que H es verdadera (estimada por el motor clínico).
- `P(E)`: Probabilidad de la evidencia (normalización).

### 7.2. Propagación de Confianza en el Grafo

Cuando un nodo cambia su confianza, la confianza de los nodos relacionados se actualiza mediante reglas de propagación:

- **Causal directa (`causes`)**: Si A → B, y A aumenta su confianza, B recibe un incremento proporcional, atenuado por la fuerza de la relación.
- **Inhibición (`inhibits`)**: Si A inhibe B, un aumento en A disminuye B, con una ponderación proporcional a la fuerza de la relación.
- **Generalización (`generalizes_to`)**: Si A se generaliza a B, la confianza en B se actualiza con un factor de transferencia (0-1).

### 7.3. Transformación de Funciones (RFT)

Cuando un marco relacional se activa, las funciones de los nodos se transforman según las reglas de RFT:

- **Coordinación** (A = B): La función de A se transfiere a B, y viceversa.
- **Distinción** (A ≠ B): Las funciones se mantienen separadas.
- **Oposición** (A ↔ No A): La función de A se invierte en B.
- **Comparación** (A > B): La función de A se intensifica, la de B se atenúa.
- **Jerarquía** (A parte de B): La función de B se aplica a A, pero no al revés (a menos que haya derivación).

### 7.4. Generalización y Transferencia

La generalización de una conducta o proceso de un contexto a otro se calcula mediante:

Generalization_Index = Σ (P(conducta|contexto_i) - P(conducta|contexto_base)) / n


Donde `n` es el número de contextos observados. El índice varía de 0 a 1.

---

## 8. Integración con los Motores del Ecosistema

### 8.1. AAO (Adaptive Assessment Orchestrator)
- Utiliza la ontología para seleccionar qué procesos evaluar, basándose en la incertidumbre actual (confianza baja en un proceso, la ontología sugiere qué preguntas o tareas reducirán esa incertidumbre).
- Mapea los resultados de las evaluaciones a nodos de la ontología (ej. puntuación de un cuestionario → proceso de Aceptación).

### 8.2. BERL (Behavioral Exercise Research Lab)
- Cada ejercicio se vincula a uno o varios procesos de la ontología (ej. "ejercicio de defusión" → nodo `Process` de tipo `Defusion`).
- La telemetría del ejercicio actualiza los indicadores de los procesos (ej. latencia → Flexibilidad atencional).

### 8.3. BSC (Behavioral Science Cloud) y BKGE (Behavioral Knowledge Graph Engine)
- La ontología es el esquema del grafo de conocimiento. Todos los artículos, hipótesis, intervenciones y resultados se almacenan como nodos y aristas de la ontología.
- Las consultas de la IA (RAG) se realizan sobre este grafo, usando la ontología para navegar y filtrar.

### 8.4. Behavioral Twin
- El Behavioral Twin es una instancia del grafo para un paciente específico. Contiene los nodos y aristas que describen su historia de aprendizaje, repertorios, procesos, valores, hipótesis, etc.
- Se actualiza continuamente mediante la propagación de confianza y la actualización bayesiana.

### 8.5. TCCN (Therapeutic Cognitive Companion)
- El lenguaje de la IA se genera a partir de la ontología: al seleccionar un nodo de proceso o valor, el TCCN consulta los atributos y las relaciones para construir respuestas clínicamente coherentes.
- La personalidad del compañero se define en parte por los marcos relacionales que utiliza (ej. más deícticos para fomentar la perspectiva).

---

## 9. Ejemplos de Uso (Casos Clínicos Simulados)

### 9.1. Ejemplo 1: Evaluación Inicial de un Paciente con Ansiedad Social

**Paso 1: Entrevista inicial (AAO)**
- La IA realiza preguntas abiertas y extrae nodos de `Evento` (ej. "pensamiento de que otros me juzgan"), `Conducta` (ej. "evitar fiestas") y `Contexto` (ej. "social").
- La confianza inicial en estos nodos es alta (0.9) porque provienen del autorreporte.

**Paso 2: Juego de exposición (BERL)**
- El paciente juega un minijuego donde debe mantener una conversación virtual. La telemetría muestra latencia alta al responder, evitación de ciertos temas y abandono temprano.
- Estos datos actualizan los nodos de `Conducta` (ej. "evitación social") y `Proceso` (ej. "evitación experiencial") con confianza 0.85.

**Paso 3: Actualización de hipótesis**
- La hipótesis inicial ("la ansiedad social se mantiene por reforzamiento negativo") recibe evidencia a favor (0.82) y se mantiene activa.
- Se genera una nueva hipótesis ("la autocrítica mediada por marcos de coordinación 'yo = fracaso'") con confianza 0.68, basada en el análisis de los marcos relacionales extraídos del diálogo.

**Paso 4: Plan de intervención**
- El sistema sugiere trabajar primero en la defusión cognitiva (para reducir la fusión con "yo = fracaso") y luego en la exposición graduada.

### 9.2. Ejemplo 2: Seguimiento de un Paciente en Mantenimiento

**Paso 1: Momento de recaída**
- El paciente reporta (vía EMA) que ha evitado una reunión familiar. El AAO detecta un aumento en la evitación y una disminución en la acción comprometida.
- El Behavioral Twin actualiza los nodos correspondientes y reduce la confianza en la generalización de la exposición (de 0.78 a 0.62).

**Paso 2: Intervención del sistema**
- El TCCN pregunta: "He notado que has evitado la reunión. ¿Qué fue lo más difícil? ¿Podemos explorar qué valor se vio afectado?"
- El sistema sugiere un ejercicio de defusión específico, basado en el marco relacional detectado (coordinación "yo = fracaso").

**Paso 3: Actualización del aprendizaje**
- El paciente completa el ejercicio y reporta una disminución en la autocrítica. El sistema actualiza el nodo de `Proceso` (Autocompasión) y la hipótesis sobre el mantenimiento de la evitación.

---

## 10. Validación Científica y Criterios de Actualización

### 10.1. Validación Interna
- Cada nuevo proceso, relación o marco relacional debe ser propuesto por un clínico experto y pasar por el Comité Científico (ASC) antes de ser añadido a la ontología base.
- Los cambios se validan mediante simulaciones con Behavioral Twins sintéticos.

### 10.2. Validación con Evidencia Científica
- La ontología se actualiza automáticamente cuando el BSC detecta nueva evidencia científica (ej. meta-análisis, nuevos estudios) que soporta o refuta un proceso o relación.
- Los cambios se revisan manualmente antes de ser aprobados.

### 10.3. Criterios de Actualización
- **Nivel de evidencia**: Meta-análisis > RCT > estudios observacionales > consenso de expertos > hipótesis.
- **Replicabilidad**: El proceso o relación debe haber sido replicado en al menos 3 estudios independientes.
- **Utilidad clínica**: Debe demostrar que añadir o modificar el proceso mejora los resultados clínicos (ej. tamaño del efecto > 0.3).

---

## 11. El Manifiesto Ontológico

> *"La ontología no es una lista de conceptos. Es el contrato entre la ciencia y el software.*
>
> *Es la promesa de que cada proceso que entrenamos tiene sentido clínico.*
>
> *Es la garantía de que cada relación que modelamos refleja la complejidad del comportamiento humano.*
>
> *Sin una ontología rigurosa, el sistema es una máquina de ejercicios vacíos.*
>
> *Con una ontología viva, el sistema se convierte en un verdadero asistente clínico."*

---

## 12. Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2026-07-01 | Arquitectura Jefe | Creación del documento. Definición del metamodelo, taxonomía de procesos, marcos relacionales, representación computacional, reglas de inferencia e integración con motores. |
| 2.0.0 | 2026-08-07 | Arquitectura de Software | Extensión de la taxonomía PBT a 18 dominios (foundation-ontology-extension), registro de BPO en used_by y bump de versión del frontmatter. |

---

**Fin del documento `ontology.md`**

