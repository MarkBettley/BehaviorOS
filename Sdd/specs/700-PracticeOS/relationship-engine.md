---
id: BRE-001
title: Behavioral Relationship Engine (BRE)
version: 1.0.0
status: Stable
owner: Práctica Clínica & Experiencia del Paciente
last_updated: 2026-07-02
depends_on:
  - 000-Core/philosophy.md (Filosofía - relación terapéutica)
  - 000-Core/principles.md (Principios - autonomía, respeto)
  - 100-Architecture/behavioral-twin.md (Behavioral Twin - perfil del paciente)
  - 400-AI/adaptive-orchestrator.md (AAO - análisis de la relación)
  - 400-AI/companion.md (TCCN - comunicación con el paciente)
  - 700-PracticeOS/practice-os.md (BPOS - agenda, EHR, CRM)
  - 700-PracticeOS/automation-studio.md (BAS - workflows de relación)
  - 800-Analytics/outcomes-analytics.md (BIP - métricas de relación)
  - 000-Infrastructure/selection.md (Infraestructura - opciones gratuitas)
exports:
  - Arquitectura del Relationship Engine
  - Modelo de relación terapéutica (alianza, satisfacción, confianza)
  - Gestión de la comunicación paciente-terapeuta
  - Análisis de la alianza terapéutica (WAI, etc.)
  - Gestión de la satisfacción del paciente (NPS, CSAT)
  - Seguimiento de la evolución de la relación
  - Alertas y notificaciones de relación
  - Integración con el ecosistema (BPOS, AAO, TCCN, BIP, BAS)
  - Criterios de validación
used_by:
  - Terapeutas (gestión de la relación con pacientes)
  - BPOS (CRM y seguimiento)
  - AAO (análisis de la alianza terapéutica)
  - TCCN (comunicación y empatía)
  - BIP (métricas de relación)
  - BAS (workflows de relación)
---

# BehavioralOS – Behavioral Relationship Engine (BRE)

> *"La relación terapéutica es el corazón de la psicoterapia. No es solo un medio para el cambio; es el cambio mismo. El Behavioral Relationship Engine ayuda a los terapeutas a cultivar, medir y fortalecer la alianza terapéutica con sus pacientes, proporcionando insights y herramientas para una conexión más profunda y efectiva."*

---

## 1. Propósito y Alcance

### 1.1. Propósito
Este documento define el **Behavioral Relationship Engine (BRE)** , un motor de gestión de relaciones terapéuticas que va más allá del CRM tradicional para incluir el análisis de la alianza, la satisfacción del paciente y la evolución de la relación a lo largo del tiempo. Su objetivo es:

- **Gestionar la relación terapéutica** de manera integral, desde el primer contacto hasta el alta y más allá.
- **Medir y analizar la alianza terapéutica** utilizando instrumentos validados (WAI, etc.) y análisis de lenguaje.
- **Monitorear la satisfacción del paciente** (NPS, CSAT, encuestas periódicas).
- **Facilitar la comunicación** entre paciente y terapeuta, asegurando que sea efectiva y empática.
- **Alertar al terapeuta** sobre cambios en la relación (deterioro de la alianza, insatisfacción, riesgo de abandono).
- **Proveer insights** para fortalecer la relación y mejorar los resultados terapéuticos.

### 1.2. Alcance
El documento cubre:

- **Arquitectura del Relationship Engine**: Componentes, flujos de datos, integración con el ecosistema.
- **Modelo de relación terapéutica**: Dimensiones de la alianza, satisfacción, confianza, compromiso.
- **Gestión de la comunicación**: Seguimiento de interacciones, análisis de lenguaje, empatía.
- **Análisis de la alianza terapéutica**: Instrumentos validados (WAI, etc.), análisis de lenguaje y prosodia.
- **Gestión de la satisfacción del paciente**: NPS, CSAT, encuestas periódicas, análisis de feedback.
- **Seguimiento de la evolución de la relación**: Trayectorias de alianza, puntos de inflexión.
- **Alertas y notificaciones**: Detección de deterioro de la alianza, insatisfacción, riesgo de abandono.
- **Integración con el ecosistema**: BPOS, AAO, TCCN, BIP, BAS.
- **Criterios de validación**: Métricas de precisión, usabilidad y satisfacción.

### 1.3. Principio Fundamental
> *"La relación terapéutica no es un accesorio de la terapia; es la terapia. El Behavioral Relationship Engine proporciona a los terapeutas las herramientas para cultivar, medir y fortalecer esta relación, porque sabemos que una alianza sólida es el mejor predictor de resultados positivos."*

---

## 2. Filosofía del Relationship Engine

### 2.1. Principios de Diseño

| # | Principio | Descripción | Manifestación |
|---|-----------|-------------|---------------|
| 1 | **La relación es el centro** | La relación terapéutica es el foco principal del BRE. | Todas las métricas y análisis giran en torno a la calidad de la relación. |
| 2 | **Medición continua** | La alianza se mide de forma continua, no solo al inicio o al final. | Análisis de lenguaje en sesiones y chats, evaluaciones periódicas. |
| 3 | **Insights accionables** | Los datos se transforman en recomendaciones concretas para el terapeuta. | Sugerencias para fortalecer la alianza, abordar rupturas, etc. |
| 4 | **Empatía y calidez** | La comunicación debe ser empática y cálida, reflejando los valores del BehavioralOS. | El TCCN y las comunicaciones automáticas están diseñadas para ser empáticas. |
| 5 | **Privacidad y confidencialidad** | La relación terapéutica es sagrada; los datos están protegidos. | Cifrado de comunicaciones, consentimientos granulares. |
| 6 | **Transparencia** | El paciente debe sentir que la relación es auténtica y que el terapeuta está presente. | El terapeuta tiene acceso a insights para mejorar la relación, no para manipular. |

### 2.2. Inspiración

El BRE se inspira en:

- **Modelos de alianza terapéutica**: Bordin (1979), Hatcher & Barends (2006).
- **CRM especializados**: Salesforce Health Cloud, SimplePractice, TherapyNotes.
- **Análisis de lenguaje**: LIWC, análisis de prosodia, análisis de sentimiento.
- **Plataformas de feedback**: NPS, CSAT, encuestas de experiencia.

---

## 3. Arquitectura del Relationship Engine

### 3.1. Visión General

┌─────────────────────────────────────────────────────────────────────────┐
│ Behavioral Relationship Engine (BRE) │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ Relationship Model │ │
│ │ • Alianza terapéutica (Bond, Goals, Tasks - Bordin) │ │
│ │ • Satisfacción del paciente (NPS, CSAT) │ │
│ │ • Confianza y compromiso │ │
│ │ • Evolución de la relación a lo largo del tiempo │ │
│ └─────────────────────────────────────────────────────────────────┘ │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ Communication & Interaction Manager │ │
│ │ • Seguimiento de interacciones (sesiones, chats, correos) │ │
│ │ • Análisis de lenguaje (empatía, validación, etc.) │ │
│ │ • Análisis de prosodia (voz, tono, ritmo) │ │
│ └─────────────────────────────────────────────────────────────────┘ │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ Alliance & Satisfaction Analytics │ │
│ │ • WAI (Working Alliance Inventory) adaptativo │ │
│ │ • NPS y CSAT periódicos │ │
│ │ • Análisis de sentimiento en comunicaciones │ │
│ │ • Detección de rupturas de alianza │ │
│ └─────────────────────────────────────────────────────────────────┘ │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ Alerts & Recommendations │ │
│ │ • Alertas de deterioro de alianza │ │
│ │ • Alertas de insatisfacción │ │
│ │ • Sugerencias para fortalecer la relación │ │
│ └─────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────┘


### 3.2. Componentes del BRE

| Componente | Descripción | Tecnología | Notas (Gratuito) |
|------------|-------------|------------|------------------|
| **Relationship Model** | Modelo de datos para la relación terapéutica. | Supabase (PostgreSQL) | Plan gratuito |
| **Communication & Interaction Manager** | Seguimiento y análisis de interacciones. | Python (FastAPI) + NLP | Open source |
| **Alliance & Satisfaction Analytics** | Análisis de alianza y satisfacción. | Python (scikit-learn, NLP) + Supabase | Open source |
| **Alerts & Recommendations** | Generación de alertas y recomendaciones. | Python (FastAPI) + BRIL | Open source |

---

## 4. Modelo de Relación Terapéutica

### 4.1. Dimensiones de la Relación (Basado en Bordin)

| Dimensión | Descripción | Indicadores |
|-----------|-------------|-------------|
| **Bond** | Vínculo emocional entre paciente y terapeuta. | Confianza, respeto, aceptación, calidez. |
| **Goals** | Acuerdo sobre los objetivos de la terapia. | Claridad de objetivos, alineación, compromiso. |
| **Tasks** | Acuerdo sobre las tareas y métodos de la terapia. | Colaboración, entendimiento de las intervenciones, adherencia. |

### 4.2. Métricas Clave de Relación

| Métrica | Descripción | Fuente de datos |
|---------|-------------|-----------------|
| **Working Alliance (WAI)** | Medida de la alianza terapéutica (Working Alliance Inventory). | Cuestionario WAI adaptativo (AAO). |
| **NPS (Net Promoter Score)** | Probabilidad de recomendar el terapeuta/plataforma. | Encuesta post-sesión o periódica. |
| **CSAT (Customer Satisfaction Score)** | Satisfacción general con la terapia. | Encuesta post-sesión. |
| **Confianza** | Nivel de confianza del paciente en el terapeuta. | Análisis de lenguaje, cuestionario breve. |
| **Compromiso** | Nivel de compromiso del paciente con la terapia. | Asistencia a sesiones, adherencia a ejercicios, participación en chat. |
| **Empatía percibida** | Percepción del paciente de la empatía del terapeuta. | Análisis de lenguaje, cuestionario breve. |

### 4.3. Evolución de la Relación

- **Trayectoria de alianza**: La alianza tiende a aumentar en las primeras sesiones, estabilizarse y luego mantenerse o aumentar gradualmente.
- **Puntos de inflexión**: Eventos que pueden afectar la alianza (ej. rupturas, reparaciones, logros terapéuticos).
- **Deterioro de la alianza**: Señales de que la alianza se está debilitando (ej. aumento de evitación, disminución de la colaboración).

---

## 5. Gestión de la Comunicación

### 5.1. Seguimiento de Interacciones

| Tipo de interacción | Descripción | Datos recogidos |
|---------------------|-------------|-----------------|
| **Sesiones** | Sesiones de terapia (presenciales u online). | Transcripción, duración, frecuencia, participación. |
| **Chats** | Mensajes entre paciente y terapeuta (TCCN). | Texto, frecuencia, tiempo de respuesta, sentimiento. |
| **Correos** | Correos electrónicos entre paciente y terapeuta. | Texto, frecuencia, tiempo de respuesta. |
| **Notas** | Notas del terapeuta sobre la relación. | Texto libre (ej. observaciones sobre la alianza). |

### 5.2. Análisis de Lenguaje

| Análisis | Descripción | Herramienta |
|----------|-------------|-------------|
| **Empatía** | Detección de expresiones empáticas en el lenguaje del terapeuta. | NLP (modelo de empatía). |
| **Validación** | Detección de expresiones de validación. | NLP (modelo de validación). |
| **Sentimiento** | Análisis de sentimiento (positivo, negativo, neutral). | NLP (análisis de sentimiento). |
| **Emociones** | Detección de emociones (alegría, tristeza, ansiedad, etc.). | NLP (modelo de emociones). |
| **Prosodia** | Análisis de voz (tono, ritmo, pausas) en videoterapia. | Whisper + análisis acústico. |

### 5.3. Métricas de Comunicación

| Métrica | Descripción | Fuente de datos |
|---------|-------------|-----------------|
| **Tiempo de respuesta del terapeuta** | Tiempo promedio en responder a mensajes del paciente. | Chat, correo. |
| **Proporción de mensajes del terapeuta** | Porcentaje de mensajes del terapeuta vs. del paciente. | Chat. |
| **Frecuencia de comunicación** | Número de interacciones por semana. | Chat, correo. |
| **Empatía del terapeuta** | Nivel de empatía en el lenguaje del terapeuta. | Análisis de lenguaje. |
| **Validación del terapeuta** | Nivel de validación en el lenguaje del terapeuta. | Análisis de lenguaje. |

---

## 6. Análisis de la Alianza Terapéutica

### 6.1. WAI (Working Alliance Inventory)

- **Propósito**: Medir la alianza terapéutica desde la perspectiva del paciente.
- **Formato**: Cuestionario breve (12 ítems) adaptativo (AAO).
- **Frecuencia**: Inicio de la terapia, cada 4-6 sesiones, y al finalizar.
- **Dimensiones**: Bond, Goals, Tasks.
- **Interpretación**: Puntuación de 1 a 7 (más alto = mejor alianza).

### 6.2. Análisis Automático de la Alianza

| Análisis | Descripción | Fuente de datos |
|----------|-------------|-----------------|
| **Lenguaje de alianza** | Detección de lenguaje que indica alianza fuerte o débil. | Transcripciones de sesiones, chat. |
| **Prosodia de alianza** | Análisis de voz para detectar señales de alianza (ej. tono, ritmo). | Grabaciones de videoterapia. |
| **Patrones de interacción** | Análisis de turnos de palabra, interrupciones, etc. | Transcripciones. |
| **Rupturas de alianza** | Detección de momentos de ruptura (ej. desacuerdo, evitación). | Análisis de lenguaje y prosodia. |

### 6.3. Rupturas y Reparaciones

- **Ruptura**: Deterioro de la alianza (ej. desacuerdo sobre objetivos, tensión emocional).
- **Reparación**: Intento de restaurar la alianza (ej. validación, disculpa, ajuste de objetivos).
- **Detección**: El sistema identifica posibles rupturas y sugiere estrategias de reparación al terapeuta.

---

## 7. Gestión de la Satisfacción del Paciente

### 7.1. NPS (Net Promoter Score)

- **Pregunta**: "En una escala del 0 al 10, ¿qué tan probable es que recomiendes a tu terapeuta a un amigo o familiar?"
- **Frecuencia**: Después de la primera sesión, cada 3 meses, y al finalizar la terapia.
- **Interpretación**: Promotores (9-10), Pasivos (7-8), Detractores (0-6).

### 7.2. CSAT (Customer Satisfaction Score)

- **Pregunta**: "En una escala del 1 al 5, ¿qué tan satisfecho estás con la terapia?"
- **Frecuencia**: Después de cada sesión (opcional) o cada 3 meses.
- **Interpretación**: Muy satisfecho (5), Satisfecho (4), Neutral (3), Insatisfecho (1-2).

### 7.3. Análisis de Feedback

- **Feedback abierto**: Comentarios de los pacientes sobre su experiencia.
- **Análisis**: NLP para identificar temas recurrentes (ej. "el terapeuta me escucha", "siento que no progreso").

---

## 8. Alertas y Notificaciones

### 8.1. Tipos de Alertas

| Alerta | Descripción | Disparador |
|--------|-------------|------------|
| **Deterioro de alianza** | La alianza ha disminuido significativamente. | WAI bajo, análisis de lenguaje negativo. |
| **Insatisfacción del paciente** | El paciente ha expresado insatisfacción (NPS, CSAT bajo). | Encuestas, feedback abierto. |
| **Ruptura de alianza** | Se ha detectado una ruptura en la alianza. | Análisis de lenguaje y prosodia. |
| **Riesgo de abandono** | El paciente muestra señales de posible abandono. | Adherencia baja, feedback negativo, WAI bajo. |
| **Comunicación deficiente** | El terapeuta no ha respondido a mensajes en tiempo razonable. | Tiempo de respuesta alto. |

### 8.2. Recomendaciones

- **Sugerencias para fortalecer la alianza**: "Parece que la alianza ha disminuido. Considera explorar los objetivos de la terapia con el paciente en la próxima sesión."
- **Sugerencias para reparar rupturas**: "Se ha detectado una posible ruptura. Prueba a validar la emoción del paciente y preguntar sobre su experiencia."
- **Sugerencias para mejorar la comunicación**: "El tiempo de respuesta ha aumentado. Considera establecer expectativas claras sobre la frecuencia de comunicación."

---

## 9. Integración con el Ecosistema

### 9.1. BPOS (Práctica Clínica)
- **Lectura**: El BRE lee datos del BPOS (pacientes, sesiones, notas, agenda).
- **Escritura**: El BRE escribe análisis de relación en el perfil del paciente y genera alertas en el dashboard del terapeuta.

### 9.2. AAO (Evaluación Adaptativa)
- **Lectura**: El BRE utiliza las evaluaciones del AAO para medir la alianza (WAI adaptativo).
- **Escritura**: El AAO recibe eventos del BRE para ajustar la evaluación.

### 9.3. TCCN (Compañero)
- **Lectura**: El BRE analiza las conversaciones del TCCN para evaluar la relación.
- **Escritura**: El TCCN puede recibir instrucciones del BRE para ser más empático o validante.

### 9.4. BIP (Analítica)
- **Lectura**: El BIP utiliza métricas de relación del BRE para análisis avanzados.
- **Escritura**: El BRE no actualiza el BIP; el BIP consume datos del BRE.

### 9.5. BAS (Automatización)
- **Lectura**: El BAS puede utilizar disparadores del BRE (ej. "deterioro de alianza").
- **Escritura**: El BAS puede enviar alertas al terapeuta o al paciente.

---

## 10. Criterios de Validación y Cumplimiento

| Criterio | Métrica | Herramienta |
|----------|---------|-------------|
| **Precisión de la detección de alianza** | Correlación entre el análisis automático y las evaluaciones WAI ≥ 0.7. | Análisis estadístico |
| **Precisión de detección de rupturas** | Concordancia con evaluación clínica ≥ 0.75. | Revisión clínica |
| **Satisfacción del terapeuta** | ≥ 4.0/5 en encuestas de utilidad del BRE. | Encuestas in-app |
| **Mejora en la alianza** | Aumento promedio de WAI después de 10 sesiones ≥ 0.3. | Análisis de datos |
| **Reducción del abandono** | Reducción del abandono en ≥ 10% para pacientes con alertas tempranas. | Análisis de datos |

---

## 11. El Manifiesto del BRE

> *"La relación terapéutica es el corazón de la psicoterapia. No es solo un medio para el cambio; es el cambio mismo.*
>
> *El Behavioral Relationship Engine ayuda a los terapeutas a cultivar, medir y fortalecer la alianza terapéutica con sus pacientes, proporcionando insights y herramientas para una conexión más profunda y efectiva.*
>
> *No se trata de reemplazar la intuición clínica; se trata de potenciarla con datos. No se trata de juzgar al terapeuta; se trata de apoyarlo.*
>
> *Nuestra responsabilidad es garantizar que el BRE sea preciso, ético, empático y útil. Que cada alerta sea una oportunidad para mejorar la relación, y cada recomendación sea un paso hacia una terapia más efectiva."*

---

## 12. Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2026-07-02 | Arquitectura de Práctica Clínica | Creación del documento. Definición del Behavioral Relationship Engine: modelo de relación terapéutica, gestión de comunicación, análisis de alianza y satisfacción, alertas y recomendaciones, integración con el ecosistema y criterios de validación. |

---

**Fin del documento `relationship-engine.md`**