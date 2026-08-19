---
id: BPE-001
title: Behavioral Process Engine (BPE)
version: 1.0.0
status: Stable
owner: Arquitectura & Psicología Clínica
last_updated: 2026-07-14
depends_on:
  - 000-Core (Ontología, Principios)
exports:
  - Motor Central de Procesos Psicológicos
  - Pipeline de procesos por prioridad clínica
  - Contrato de integración con BPO, BPG, BERL, AHEE, TCCN, BIP, BSC
used_by:
  - BPO (Behavioral Process Ontology)
  - BPG (Behavioral Process Graph)
  - BERL (Behavioral Exercise Research Lab)
  - AHEE (Adaptive Human Experience Engine)
  - TCCN (Behavioral Companion)
  - BIP (Behavioral Intelligence Platform)
  - BSC (Behavioral Science Cloud)
  - BROS (Behavioral Research Outcomes System)
  - BCMS (Behavioral Clinical Management System)
  - BXP (Behavioral Experience Platform)
  - BPOS (Behavioral Practice OS)
---

# BehavioralOS – Behavioral Process Engine (BPE)

> *"No diseñamos módulos aislados. Diseñamos el corazón del cual dependen todos los demás. El BPE es ese corazón: el motor científico que centraliza, orquesta y conecta todos los procesos psicológicos conocidos."*

---

## 1. Propósito y Alcance

### 1.1. Propósito

El Behavioral Process Engine (BPE) es el **motor central de procesos psicológicos** del BehavioralOS. No es un módulo más entre muchos; es el **eje** alrededor del cual gira toda la plataforma.

Su función fundamental es **centralizar TODOS los procesos psicológicos conocidos** — no solamente los de ACT, ni solamente los de PBT, ni solamente de neuropsicología — sino todos los dominios científicamente validados que pueden intervenir en la vida de una persona.

### 1.2. Alcance

El BPE define y administra **18 dominios de procesos psicológicos**, cada uno con:

- Definiciones operacionales, clínicas, computacionales, educativas, para IA y para videojuegos.
- Conexiones con ejercicios (BERL), juegos, evaluaciones e IA.
- Variables observables y latentes.
- Instrumentos de medición asociados.
- Relaciones con otros procesos (facilitación, inhibición, mediación, moderación, predicción).

### 1.3. Filosofía

```
ACT → Procesos → Ejercicios → Resultados
```

**Esto NO es correcto.** La arquitectura correcta es:

```
Proceso → ACT → FAP → DBT → PBT → TIP → Neuropsicología → Ejercicios → IA → Reportes
```

El sistema **no gira alrededor de terapias. Gira alrededor de procesos.** Cada proceso conoce las terapias donde aparece, los ejercicios que lo entrenan, los instrumentos que lo miden, los juegos que lo refuerzan, los indicadores que la IA analiza y los gráficos que genera.

---

## 2. Los 18 Dominios de Procesos Psicológicos

### 2.1. Tabla Maestra de Dominios

| # | Dominio | Código | Nivel | Ejemplo de Proceso |
|---|---------|--------|-------|--------------------|
| I | **Cognitivos** | COG | Individual | Atención, Memoria, Flexibilidad Cognitiva, Inhibición, Razonamiento, Metacognición |
| II | **Emocionales** | EMO | Individual | Identificación, Conciencia, Regulación, Expresión, Tolerancia al malestar |
| III | **Motivacionales** | MOT | Individual | Motivación intrínseca/extrínseca, Persistencia, Autoeficacia, Valores |
| IV | **Conductuales** | CON | Individual | Activación conductual, Evitación, Exposición, Reforzamiento, Extinción, Hábitos |
| V | **Contextuales (ACT/CBS)** | CTX | Individual | Flexibilidad Psicológica (Hexaflex), Rigidez Psicológica |
| VI | **Interpersonales (FAP)** | INT | Diádico | CRB1, CRB2, CRB3, Intimidad, Vulnerabilidad, Validación, Empatía, Mentalización |
| VII | **Relacionales** | REL | Diádico/Familiar | Sincronía, Coregulación, Coordinación, Apego, Patrones coercitivos, Límites |
| VIII | **Fisiológicos** | FIS | Individual | Activación autonómica, VFC, Respiración, Sueño, Fatiga, Dolor |
| IX | **Neuropsicológicos** | NEU | Individual | Funciones ejecutivas, Lenguaje, Praxias, Gnosias, Cognición social, Fluidez verbal |
| X | **Sociales** | SOC | Grupal | Cooperación, Conducta prosocial, Aprendizaje observacional, Identidad social |
| XI | **Evolutivos** | EVO | Transversal | Aprendizaje, Adaptación, Variación, Selección, Retención, Plasticidad |
| XII | **Aprendizaje** | APR | Transversal | Condicionamiento clásico/operante, Equivalencia de estímulos, Aprendizaje relacional |
| XIII | **RFT (Marco Relacional)** | RFT | Transversal | Derivación relacional, Marcos de coordinación/distinción/oposición, Deixis |
| XIV | **Pareja (Gottman/TIP)** | PAR | Diádico | Regulación fisiológica, Reparación, Admiración, Cuatro Jinetes |
| XV | **Familiares** | FAM | Familiar | Cohesión, Adaptabilidad, Jerarquía, Comunicación, Coaliciones, Roles |
| XVI | **Salud** | SAL | Individual | Adherencia, Autocuidado, Sueño, Ejercicio, Alimentación, Consumo de sustancias |
| XVII | **Existenciales** | EXI | Individual | Sentido, Propósito, Esperanza, Identidad, Espiritualidad, Trascendencia |
| XVIII | **Organizacionales** | ORG | Organizacional | Liderazgo, Burnout, Engagement, Clima laboral, Resiliencia organizacional |

### 2.2. Detalle por Dominio

#### I. Dominio Cognitivos (COG)

| Proceso | Definición Operacional | Indicadores Observables |
|---------|----------------------|------------------------|
| Atención selectiva | Capacidad de enfocar estímulos relevantes e ignorar irrelevantes | Tiempo de reacción, Errores de distracción, Precisión |
| Atención sostenida | Mantenimiento del foco atencional por períodos prolongados | Tiempo hasta fatiga atencional, Variabilidad de RT |
| Atención dividida | Procesamiento simultáneo de múltiples fuentes | Precisión dual-tarea, Costo de switch |
| Atención alternante | Alternar el foco entre tareas o estímulos | Tiempo de alternancia, Errores de perseveración |
| Atención ejecutiva | Control atencional de alto nivel vinculado a funciones ejecutivas | Precisión en tareas de control, Eficiencia de inhibición |
| Memoria de trabajo | Retención y manipulación temporal de información | Span (Digit Span, Corsi), Tiempo de latencia |
| Memoria episódica | Recuerdo de eventos personales con contexto temporal/espacial | Tasa de recuerdo libre, Reconocimiento |
| Memoria semántica | Conocimiento general del mundo | Fluidez verbal, Categorización |
| Memoria procedimental | Habilidades aprendidas y automatizadas | Tiempo de ejecución, Errores de procedimiento |
| Memoria prospectiva | Recuerdo de intenciones futuras | Tasa de cumplimiento, Tiempo de demora |
| Flexibilidad cognitiva | Capacidad de cambiar de reglas, perspectivas o estrategias | WCST: perseveraciones, Tiempo de cambio |
| Inhibición motora | Supresión de respuestas automáticas | Go/NoGo: omisiones, Comisiones |
| Inhibición cognitiva | Supresión de información irrelevante en memoria | Proactive interference, Think/No-Think |
| Inhibición emocional | Regulación de la interferencia emocional en el rendimiento | Stroop emocional: Interferencia |
| Razonamiento deductivo | Inferencia de conclusiones a partir de premisas | Precisión, Tiempo de resolución |
| Razonamiento inductivo | Generalización a partir de observaciones | Tasa de acierto, Velocidad |
| Razonamiento analógico | Identificación de relaciones entre pares conceptuales | Precisión, Tiempo |
| Razonamiento probabilístico | Evaluación de probabilidades y riesgo | Sesgos identificados, Precisión |
| Solución de problemas | Encontrar soluciones a situaciones novedosas | Tiempo, Número de intentos, Precisión |
| Toma de decisiones | Selección entre alternativas con información incompleta | Calidad de decisión, Sesgos detectados |
| Metacognición | Conocimiento y regulación de los propios procesos cognitivos | Calibración de confianza, Estrategias informadas |
| Monitoreo cognitivo | Supervisión en tiempo real del rendimiento cognitivo | Sensibilidad, Especificidad |
| Planeación | Organización secuencial de pasos para alcanzar un objetivo | Completitud del plan, Eficiencia |
| Organización | Estructuración sistemática de información y recursos | Eficiencia, Errores de omisión |

#### II. Dominio Emocionales (EMO)

| Proceso | Definición Operacional | Indicadores Observables |
|---------|----------------------|------------------------|
| Identificación emocional | Capacidad de nombrar y reconocer emociones propias | Precisión en etiquetado, Latencia |
| Conciencia emocional | Percepción de la presencia y naturaleza de las emociones | Frecuencia de reporte, Diferenciación |
| Diferenciación emocional | Distinguir entre emociones con valencia o arousal similar | Precisión en discriminación, Granularidad |
| Regulación emocional | Estrategias para modificar la experiencia y expresión emocional | Uso de estrategias adaptativas, Eficacia |
| Expresión emocional | Comunicación no verbal de estados emocionales | Concordancia expresión-interno, Latencia |
| Validación emocional | Reconocimiento de la legitimidad de las propias y ajenas emociones | Autovalidación, Validación interpersonal |
| Tolerancia al malestar | Capacidad de soportar emociones negativas sin reactividad | Tiempo de permanencia, Reactividad conductual |
| Recuperación emocional | Velocidad de retorno a un estado basal tras una emoción intensa | Tiempo de recuperación, Pendiente de recuperación |
| Inercia emocional | Rigidez en la persistencia de estados emocionales | Tasa de cambio, Autocorrelación temporal |

#### III. Dominio Motivacionales (MOT)

| Proceso | Definición Operacional | Indicadores Observables |
|---------|----------------------|------------------------|
| Motivación intrínseca | Realización de conductas por gratificación inherente | Frecuencia autodirigida, Persistencia sin reforzamiento externo |
| Motivación extrínseca | Realización de conductas por consecuencias externas | Sensibilidad a recompensas, Dependencia de refuerzo |
| Persistencia | Mantenimiento de la conducta frente a obstáculos | Tiempo hasta abandono, Número de reintentos |
| Compromiso | Grado de vinculación con metas o valores | Cumplimiento de objetivos, Calidad de compromiso |
| Autoeficacia | Creencia en la capacidad de ejecutar conductas necesarias | Puntuación en escalas, Concordancia creencia-desempeño |
| Orientación a metas | Tendencia a establecer y perseguir objetivos | Calidad de metas, Progreso medible |
| Valores | Principios guía que dan dirección a la conducta | Claridad, Coherencia, Acción alineada |
| Motivación por aproximación | Tendencia a acercarse a estímulos positivos | Frecuencia de aproximación, Energía |
| Motivación por evitación | Tendencia a huir de estímulos aversivos | Frecuencia de evitación, Reactividad |

#### IV. Dominio Conductuales (CON)

| Proceso | Definición Operacional | Indicadores Observables |
|---------|----------------------|------------------------|
| Activación conductual | Inicio y ejecución de conductas dirigidas a metas | Frecuencia, Intensidad, Calidad |
| Evitación | Alejamiento de estímulos aversivos o internos | Frecuencia, Generalización, Intensidad |
| Escape | Terminación de exposición a estímulos aversivos | Frecuencia, Latencia, Función mantenedora |
| Aproximación | Acercamiento a estímulos o situaciones deseables | Frecuencia, Persistencia |
| Exposición | Permanencia voluntaria frente a estímulos temidos | Completitud, Tolerancia, Cambio en respuesta |
| Moldeamiento | Formación gradual de conductas mediante aproximaciones sucesivas | Tasa de approximación, Tiempo hasta conducta objetivo |
| Reforzamiento | Aumento de probabilidad de conducta por consecuente | Frecuencia de respuesta, Tasa de respuesta |
| Extinción | Disminución de conducta por ausencia de consecuente | Tasa de decremento, Extinction burst |
| Discriminación | Selección de conductas según propiedades del estímulo | Precisión, Generalización |
| Generalización | Transferencia de conducta a contextos nuevos | Tasa de transferencia, Amplitud |
| Formación de hábitos | Automatización de conductas por repetición | Frecuencia, Automaticidad, Estabilidad |
| Conducta gobernada por reglas | Conducta regulada por reglas verbales explícitas | Adherencia a reglas, Flexibilidad |
| Conducta moldeada por contingencias | Conducta regulada por historias de reforzamiento | Sensibilidad a contingencias, Resiliencia |

#### V. Dominio Contextuales / ACT (CTX)

| Proceso | Definición Operacional | Indicadores Observables |
|---------|----------------------|------------------------|
| **Flexibilidad Psicológica** | Capacidad de estar en contacto con el presente y cambiar o persistir según las demandas del contexto y los valores | MPFI, CompACT, FIT-60 |
| Aceptación | Apertura a experimentar pensamientos y emociones sin intentar controlarlos | Escala de apertura, Permanencia en exposición |
| Defusión cognitiva | Relacionarse con los pensamientos como eventos mentales, no como verdades | Distancia observador, Resonancia de pensamientos |
| Contacto con el momento presente | Atención plena al aquí y ahora | SCS, FFMQ, Precisión atencional |
| Yo como contexto | Observar la experiencia desde un sentido del self estable | Descentración, Desidentificación |
| Clarificación de valores | Identificar qué es verdaderamente importante | Claridad de valores, Direccionalidad |
| Acción comprometida | Conducta guiada por valores en presencia de obstáculos | Completitud de tareas, Calidad de acciones |
| **Rigidez Psicológica** | Patrones de evitación, fusión y desconexión de valores | AAQ-II (inverso), CPAI (inverso) |
| Evitación experiencial | Intentos de suprimir o evitar experiencias internas aversivas | AAQ-II, Frecuencia de evitación |
| Fusión cognitiva | Tratar pensamientos como eventos literales y reales | CFQ, Prevalencia de lenguaje literal |
| Dominancia del pasado/futuro | Atención desbordada por eventos pasados o futuros | Rumiación, Preocupación |
| Yo conceptualizado | Identificación rígida con historias del self | Rigidness self-narrative |
| Desconexión de valores | Falta de dirección o significado en la conducta | Dirección de vida, Alineación conducta-valores |
| Inacción o impulsividad | Falta de acción comprometida o acción reactiva | Ratio acción-plan, Impulsividad conductual |

#### VI. Dominio Interpersonales / FAP (INT)

| Proceso | Definición Operacional | Indicadores Observables |
|---------|----------------------|------------------------|
| CRB1 (Conductas Problema) | Conductas que el paciente muestra espontáneamente en sesión | Frecuencia, Intensidad, Contexto |
| CRB2 (Conducta Mejorada) | Mejoras en el repertorio conductual del paciente durante la sesión | Frecuencia, Novedad, Calidad |
| CRB3 (Conducta Terapéutica del Terapeuta) | Respuestas del terapeuta que modelan habilidades interpersonales | Frecuencia, Timing, Idoneidad |
| Intimidad | Capacidad de apertura y cercanía emocional | Profundidad de auto-revelación |
| Vulnerabilidad | Disposición a mostrarse sin defensas | Frecuencia, Contexto |
| Validación | Reconocimiento experiencial del otro | Frecuencia, Sinceridad percibida |
| Empatía | Comprensión experiencial del estado del otro | Precisión, Expresión |
| Mentalización | Capacidad de inferir estados mentales propios y ajenos | Precisión, Reflexividad |
| Cooperación | Trabajo conjunto hacia metas compartidas | Frecuencia, Calidad |
| Reciprocidad | Intercambio equilibrado de conductas sociales | Equilibrio, Recencia |
| Reparación interpersonal | Resolución de rupturas en la relación | Velocidad de reparación, Calidad |
| Confianza | Disposición a depender de otro en vulnerabilidad | Nivel de apertura, Consistencia |
| Comunicación asertiva | Expresión de necesidades y límites sin agresividad | Calidad, Frecuencia |

#### VII. Dominio Relacionales (REL)

| Proceso | Definición Operacional | Indicadores Observables |
|---------|----------------------|------------------------|
| Sincronía | Coordinación temporal de conductas entre miembros | Concordancia, Timing |
| Coregulación | Proceso por el cual los miembros modulan mutuamente sus estados emocionales | Estabilidad emocional conjunta, Resiliencia relacional |
| Coordinación | Alineación de acciones y objetivos compartidos | Eficiencia, Concordancia |
| Flexibilidad relacional | Capacidad del sistema de adaptarse a cambios | Variabilidad adaptativa, Rigidez |
| Apego | Patrón de vinculación emocional entre figuras significativas | Estilo de apego, Seguridad percibida |
| Diferenciación del self | Capacidad de mantener identidad propia dentro de la relación | Autonomía en relación, Límites |
| Patrones coercitivos | Ciclos de interacción aversiva que se mantienen por negatividad recíproca | Frecuencia de escalada, Intensidad |
| Triangulación | Inclusión de un tercero en conflictos diádicos | Frecuencia, Impacto |
| Límites | Reglas explícitas e implícitas sobre acceso y privacidad | Claridad, Flexibilidad |
| Roles familiares | Posiciones funcionales dentro del sistema familiar | Consistencia, Adaptabilidad |

#### VIII. Dominio Fisiológicos (FIS)

| Proceso | Definición Operacional | Indicadores Observables |
|---------|----------------------|------------------------|
| Activación autonómica | Nivel general de excitación del sistema nervioso autónomo | Conductancia skin, HRV |
| Variabilidad de frecuencia cardíaca (VFC) | Variación en los intervalos R-R del ECG | RMSSD, SDNN, LF/HF ratio |
| Respiración | Patrón respiratorio y su regulación | Frecuencia, Profundidad, Regularidad |
| Sueño | Calidad, duración y arquitectura del sueño | Horas, Eficiencia, Latencia, Despertares |
| Fatiga | Nivel de agotamiento físico o cognitivo | Reporte subjetivo, Rendimiento |
| Dolor | Experiencia sensorial y emocional asociada a daño tisular | Intensidad (EVA), Localización, Calidad |
| Activación simpática | Nivel de excitación de la rama simpática | GSR, Frecuencia cardíaca, Tono muscular |
| Recuperación fisiológica | Velocidad de retorno a basal tras excitación | Tiempo de recuperación, Pendiente |

#### IX. Dominio Neuropsicológicos (NEU)

| Proceso | Definición Operacional | Instrumentos Asociados |
|---------|----------------------|----------------------|
| Atención (selectiva, sostenida, dividida) | Procesamiento atencional | Stroop, ANT, Conners |
| Memoria (trabajo, episódica, semántica, procedimental) | Sistemas de memoria | Digit Span, Corsi, RAVLT, Rey |
| Funciones ejecutivas (inhibición, shifting, planning) | Control ejecutivo | WCST, TMT, Stroop, Go/NoGo |
| Lenguaje (comprensión, expresión, fluidez verbal) | Procesamiento lingüístico | FAS, Token Test, Boston |
| Praxias | Ejecución de movimientos complejos | Praxias ideomotrices, constructivas |
| Gnosias | Reconocimiento sensorial | Categorización visual, auditiva |
| Cognición social | Interpretación de intenciones sociales | RMET, Faux Pas |
| Velocidad de procesamiento | Rapidez de procesamiento de información | TMT A, Velocidad de codificación |
| Fluidez verbal | Producción verbal fluida | FAS, Semántica |
| Visoconstrucción | Capacidad de construir representaciones visuoespaciales | Rey (copia), Figuras complejas |

#### X. Dominio Sociales (SOC)

| Proceso | Definición Operacional | Indicadores Observables |
|---------|----------------------|------------------------|
| Cooperación | Acción conjunta para alcanzar metas compartidas | Frecuencia, Calidad, Eficiencia |
| Conducta prosocial | Acciones destinadas a beneficiar a otros | Frecuencia, Diversidad, Spontaneity |
| Aprendizaje observacional | Adquisición de conductas por observación de modelos | Fidelidad, Adaptación |
| Influencia social | Efecto de la presencia o conducta de otros en la propia | Conformidad, Asertividad |
| Conformidad | Ajuste de conducta a normas grupales | Grado, Persistencia |
| Normas sociales | Reglas implícitas que regulan la conducta grupal | Adherencia, Flexibilidad |
| Identidad social | Pertenencia a grupos significativos | Claridad, Integración |
| Pertenencia | Sentido de conexión con un grupo | Calidad, Frecuencia |

#### XI. Dominio Evolutivos (EVO)

| Proceso | Definición Operacional | Indicadores Observables |
|---------|----------------------|------------------------|
| Aprendizaje | Cambio conductual por experiencia | Tasa de cambio, Estabilidad |
| Adaptación | Ajuste a nuevas condiciones ambientales | Velocidad, Calidad |
| Variación | Diversidad de conductas emitidas | Amplitud, Novedad |
| Selección | Preferencia por conductas con consecuencias favorables | Eficiencia, Consistencia |
| Retención | Mantenimiento de conductas seleccionadas | Duración, Estabilidad |
| Plasticidad | Capacidad de cambio en respuesta a nuevas condiciones | Velocidad de aprendizaje, Rango de adaptación |

#### XII. Dominio de Aprendizaje (APR)

| Proceso | Definición Operacional | Indicadores Observables |
|---------|----------------------|------------------------|
| Condicionamiento clásico | Asociación entre estímulo neutro y estímulo incondicionado | Fuerza de asociación, Extinción |
| Condicionamiento operante | Modulación de conducta por consecuencias | Tasa de respuesta, Sensibilidad a programas |
| Aprendizaje observacional | Adquisición de conductas por observación | Fidelidad, Generalización |
| Equivalencia de estímulos | Emergencia de relaciones derivadas entre estímulos | Precisión de derivación, Velocidad |
| Aprendizaje relacional | Formación de marcos relacionales | Complejidad, Flexibilidad |
| Aprendizaje verbal | Adquisición de conducta verbal por reglas y relaciones | Repertorio verbal, Generatividad |

#### XIII. Dominio RFT (RFT)

| Proceso | Definición Operacional | Indicadores Observables |
|---------|----------------------|------------------------|
| Derivación relacional | Emergencia de relaciones no entrenadas entre estímulos | Precisión, Velocidad, Contexto |
| Marcos de coordinación | Relaciones de igualdad entre estímulos | Precisión, Estabilidad |
| Distinción | Capacidad de diferenciar estímulos | Precisión, Velocidad |
| Comparación | Evaluación relativa entre estímulos | Calidad de comparación, Consistencia |
| Oposición | Relaciones de contraste entre estímulos | Precisión, Intensidad |
| Jerarquía | Relaciones de orden entre estímulos | Precisión, Complejidad |
| Temporalidad | Relaciones temporales entre estímulos | Precisión, Flexibilidad |
| Deixis | Referencia a contexto temporal, espacial o personal | Precisión, Flexibilidad |
| Transformación de functions | Cambio en la función de un estímulo por relación con otro | Magnitud, Velocidad, Diversidad |

#### XIV. Dominio de Pareja / Gottman (PAR)

| Proceso | Definición Operacional | Indicadores Observables |
|---------|----------------------|------------------------|
| Regulación fisiológica | Coordinación de estados fisiológicos durante interacción | VFC conjunta, Sincronía |
| Validación | Reconocimiento experiencial del partner | Frecuencia, Calidad |
| Reparación | Intentos de resolver conflictos durante la interacción | Éxito de intentos, Latencia |
| Admiración | Expresiones de aprecio y afecto positivo | Frecuencia, Sinceridad |
| Afecto positivo | Proporción de interacciones positivas vs. negativas | Ratio P/N, Estabilidad |
| Manejo del conflicto | Habilidades para navegar desacuerdos | Productividad, Escalada |
| Influencia mutua | Capacidad de impactar positivamente al otro | Frecuencia, Reciprocidad |
| Sueños compartidos | Visión conjunta del futuro | Coherencia, Compromiso |
| Significado compartido | Valores y rituales comunes | Riqueza, Estabilidad |
| **Cuatro Jinetes (negativos)** | **Patrones destructivos de interacción** | |
| Crítica | Ataques al carácter del partner | Frecuencia, Intensidad |
| Desprecio | Superioridad moral, burla, sarcasmo | Frecuencia, Calidad |
| Actitud defensiva | Rechazo de responsabilidad | Frecuencia, Intensidad |
| Amurallamiento (Stonewalling) | Desconexión emocional total | Frecuencia, Duración |

#### XV. Dominio Familiares (FAM)

| Proceso | Definición Operacional | Indicadores Observables |
|---------|----------------------|------------------------|
| Cohesión | Grado de conexión emocional entre miembros | Proximidad, Apoyo |
| Adaptabilidad | Capacidad del sistema de cambiar sus reglas | Flexibilidad, Respuesta al cambio |
| Jerarquía | Estructura de poder y liderazgo | Claridad, Funcionalidad |
| Comunicación | Flujo de información entre miembros | Calidad, Apertura, Asertividad |
| Coaliciones | Alianzas entre miembros contra un tercero | Frecuencia, Estabilidad |
| Triangulación | Involucramiento de un tercero en conflictos diádicos | Frecuencia, Impacto |
| Alianzas | Vínculos de apoyo entre miembros | Calidad, Reciprocidad |
| Flexibilidad | Capacidad de adaptar reglas y roles | Variabilidad, Funcionalidad |
| Valores compartidos | Principios guía del sistema familiar | Coherencia, Adherencia |

#### XVI. Dominio de Salud (SAL)

| Proceso | Definición Operacional | Indicadores Observables |
|---------|----------------------|------------------------|
| Adherencia | Cumplimiento de recomendaciones de salud | Tasa de cumplimiento, Consistencia |
| Autocuidado | Conductas dirigidas al mantenimiento de la salud | Frecuencia, Calidad, Diversidad |
| Sueño | Higiene y calidad del sueño | Horas, Calidad, Regularidad |
| Ejercicio | Actividad física regular | Frecuencia, Intensidad, Duración |
| Alimentación | Patrones alimentarios saludables | Calidad dietética, Regularidad |
| Consumo de sustancias | Uso/abuso de sustancias psicoactivas | Frecuencia, Cantidad, Dependencia |
| Manejo del estrés | Estrategias para reducir el impacto del estrés | Repertorio, Eficacia |

#### XVII. Dominio Existenciales (EXI)

| Proceso | Definición Operacional | Indicadores Observables |
|---------|----------------------|------------------------|
| Sentido | Percepción de que la vida tiene significado | MLQ, Claridad |
| Propósito | Dirección y metas en la vida | Direccionalidad, Motivación |
| Esperanza | Expectativa positiva sobre el futuro | HOPE, Optimismo |
| Identidad | Sentido estable del quién soy | Coherencia, Flexibilidad |
| Espiritualidad | Conexión con algo trascendente | Conexión, Práctica |
| Trascendencia | Experiencia de ir más allá del yo limitado | Frecuencia, Profundidad |

#### XVIII. Dominio Organizacionales (ORG)

| Proceso | Definición Operacional | Indicadores Observables |
|---------|----------------------|------------------------|
| Liderazgo | Capacidad de influir y guiar equipos | Estilo, Eficacia, Satisfacción del equipo |
| Burnout | Agotamiento emocional, despersonalización y baja realización | MBI, Síntomas, Duración |
| Engagement | Compromiso vital con el trabajo | Utrecht Work Engagement Scale |
| Trabajo en equipo | Coordinación y colaboración grupal | Eficiencia, Cohesión, Comunicación |
| Clima laboral | Percepción compartida del ambiente de trabajo | Satisfacción, Seguridad, Confianza |
| Resiliencia organizacional | Capacidad de recuperación ante adversidades | Velocidad de recuperación, Adaptabilidad |

---

## 3. Arquitectura del BPE

### 3.1. Diagrama de Arquitectura

```
Behavioral Process Engine (BPE)
│
├── Process Registry (Registro de Procesos)
│   ├── 18 Dominios
│   ├── ~200 Procesos
│   ├── Definiciones múltiples
│   └── Relaciones entre procesos
│
├── Process Router (Enrutador de Procesos)
│   ├── Priorización clínica
│   ├── Selección por perfil
│   └── Adaptación contextual
│
├── Process Orchestrator (Orquestador)
│   ├── Ejecución secuencial/paralela
│   ├── Sincronización entre dominios
│   └── Gestión de dependencias
│
├── Process Evaluator (Evaluador)
│   ├── Medición de procesos
│   ├── Comparación pre-post
│   └── Detección de cambios
│
└── Process Connector (Conector)
    ├── → BPO (ontología formal)
    ├── → BPG (grafo dinámico)
    ├── → BERL (ejercicios)
    ├── → AHEE (adaptación)
    ├── → TCCN (IA companion)
    ├── → BIP (analítica)
    └── → BSC (seguimiento)
```

### 3.2. Flujo de Datos

```
Entrada del Paciente (chat, juego, evaluación, wearable)
        │
        ▼
┌─────────────────────────────────┐
│    BPE: Extracción de Procesos   │
│    (clasificación por dominio)   │
└──────────┬──────────────────────┘
           │
           ▼
┌─────────────────────────────────┐
│    BPO: Consulta de Ontología    │
│    (definiciones, instrumentos,  │
│     relaciones, evidencia)       │
└──────────┬──────────────────────┘
           │
           ▼
┌─────────────────────────────────┐
│    BPG: Actualización del Grafo  │
│    (nodos, aristas, pesos,       │
│     snapshots temporales)        │
└──────────┬──────────────────────┘
           │
     ┌─────┴─────┐
     ▼           ▼
┌─────────┐  ┌─────────┐
│  BERL   │  │  TCCN   │
│(ejerc.) │  │  (IA)   │
└────┬────┘  └────┬────┘
     ▼           ▼
┌─────────────────────────────────┐
│    Dashboard del Psicólogo       │
│    (red interactiva, Hexaflex,   │
│     series temporales)           │
└─────────────────────────────────┘
           │
           ▼
┌─────────────────────────────────┐
│    App del Paciente              │
│    (ecosistema Nintendo,         │
│     juegos, ejercicios)          │
└─────────────────────────────────┘
```

### 3.3. Contrato de Integración

#### BPE → BPO

```yaml
request:
  operation: "query_process"
  process_id: "BPO-CTX-000031"
  fields: [definitions, instruments, relations, evidence, exercises]

response:
  process:
    id: "BPO-CTX-000031"
    name: "Acceptance"
    domain: "Contextual"
    definitions:
      operational: "Capacidad de abrirse a experimentar..."
      clinical: "..."
      computational: "..."
      ai: "..."
      videogame: "..."
    instruments: ["MPFI", "CompACT", "AAQ-II"]
    relations:
      facilitates: ["BPO-CTX-000032", "BPO-CTX-000033"]
      inhibits: ["BPO-CTX-000040"]
    evidence:
      level: "high"
      meta_analyses: 12
      rcts: 45
    exercises:
      - id: "BERL-ACT-001"
        name: "Bosque de la Aceptación"
        type: "videogame"
```

#### BPE → BPG

```yaml
event:
  type: "process_update"
  source: "patient_session"
  timestamp: "2026-07-14T10:30:00Z"
  updates:
    - node_id: "BPO-CTX-000031"
      old_value: 45
      new_value: 62
      confidence: 87
      evidence_source: "MPFI_session_12"
    - node_id: "BPO-CTX-000040"
      old_value: 78
      new_value: 71
      confidence: 72
      evidence_source: "AAQ-II_session_12"
```

---

## 4. Ejemplos de Conexión: Cómo Funciona el BPE en la Práctica

### 4.1. Ejemplo 1: Flexibilidad Psicológica

| Campo | Valor |
|-------|-------|
| **Proceso** | Flexibilidad Psicológica |
| **Está relacionado con** | ACT, PBT, Hexaflex |
| **Se mide mediante** | MPFI, CompACT, FIT-60 |
| **Ejercicios** | Defusión, Aceptación, Yo como contexto, Valores, Acción comprometida |
| **Minijuegos** | Bosque de los Pensamientos, Río de la Defusión, Modo Kirby, Modo Persona |
| **IA (Gemma)** | Detecta rigidez, evitación, literalidad |
| **Dashboard** | Flexibilidad: ████████░░ 82% |

### 4.2. Ejemplo 2: Memoria de Trabajo

| Campo | Valor |
|-------|-------|
| **Dominio** | Neuropsicología |
| **Instrumentos** | Digit Span, Corsi, N-Back |
| **Ejercicios** | n-back, Secuencias, Juegos cognitivos |
| **Telemetría** | Tiempo, Errores, Curva de aprendizaje |
| **IA** | Puede inferir deterioro cognitivo |

### 4.3. Ejemplo 3: Validación Emocional

| Campo | Valor |
|-------|-------|
| **Pertenece a** | TIP, Gottman, FAP, Terapia Familiar |
| **Ejercicios** | Conversaciones guiadas, Videojuegos cooperativos |
| **IA** | Detecta validación, invalidación, crítica, defensividad |

---

## 5. Reglas de Inferencia para IA

El BPE expone reglas que la IA (Gemma) consulta antes de responder:

```yaml
inference_rules:
  - rule: "SI Fusión > 80 Y Aceptación < 40 ENTONCES Recomendar Defusión + Aceptación"
    confidence: 0.85
    evidence: "Meta-análisis ACT 2024"

  - rule: "SI Evitación > 70 Y Acción Comprometida < 30 ENTONCES Priorizar Exposición Gradual"
    confidence: 0.78
    evidence: "RCT Exposición 2023"

  - rule: "SI CRB1 > 5 en sesión Y CRB2 = 0 ENTONCES Reforzar CRB2 en próxima sesión"
    confidence: 0.92
    evidence: "Protocolo FAP manual"
```

---

## 6. Organización por Procesos (no por Terapia)

El cambio fundamental que introduce el BPE es que los ejercicios dejan de organizarse por terapia:

**ANTES:**
```
ACT → Aceptación → Ejercicios
```

**AHORA:**
```
Aceptación → ACT → FAP → DBT → PBT → TIP → Neuropsicología → Ejercicios
```

Esto significa que un mismo ejercicio puede estar conectado con múltiples marcos terapéuticos, y la IA puede recomendarlo sin importar qué enfoque use el terapeuta.

---

## 7. Integración con el Resto del Ecosistema

| Módulo | Cómo se conecta con el BPE |
|--------|---------------------------|
| **BERL** | Selecciona ejercicios basados en procesos del BPE |
| **AHEE** | Adapta el contenido según edad, desarrollo y contexto del proceso |
| **TCCN** | Detecta procesos durante la sesión en tiempo real |
| **BXP** | Construye experiencias terapéuticas personalizadas |
| **BPOS** | Documenta el análisis funcional y planifica intervenciones |
| **BIP** | Genera analítica longitudinal e investigación |
| **BROS** | Construye reportes clínicos centrados en procesos |
| **BSC** | Seguimiento continuo del progreso del paciente |
| **BEC** | Compone programas y rutas terapéuticas |
| **BRIL** | Expone los procesos como servicios reutilizables |

---

## 8. Validaciones y Reglas de Calidad

| Regla | Verificación |
|-------|-------------|
| Todo ejercicio del BERL debe mapear al menos un proceso del BPE | `exercise.process_ids.length >= 1` |
| Todo proceso debe tener al menos una definición operacional | `process.definitions.operational != null` |
| Todo proceso debe tener al menos un instrumento asociado | `process.instruments.length >= 1` |
| Las relaciones entre procesos deben ser bidireccionales en la ontología | `BPO validates symmetric relations` |
| La IA nunca debe recomendar intervenciones sin consultar el BPE | `TCCN → BPE before any recommendation` |

---

## 9. Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2026-07-14 | Arquitectura & Psicología Clínica | Creación del documento. Definición de los 18 dominios, arquitectura, contratos de integración y ejemplos de conexión. |

---

**Fin del documento `behavioral-process-engine.md`**
