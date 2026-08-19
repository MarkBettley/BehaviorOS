---
id: AI-003
title: Orquestador de Evaluación Adaptativa (AAO)
version: 1.0.0
status: Stable
owner: Arquitectura de IA & Psicología Clínica
last_updated: 2026-07-01
depends_on:
  - 000-Core/ontology.md (Ontología - procesos, relaciones)
  - 000-Core/philosophy.md (Filosofía - evaluación idiográfica)
  - 400-AI/ai-core.md (Motor de inferencia local - Gemma, Whisper)
  - 400-AI/companion.md (TCCN - análisis de conversación)
  - 100-Architecture/behavioral-twin.md (Behavioral Twin - modelo del paciente)
  - 500-Experiencies/experience-engine.md (BERL - telemetría de ejercicios)
  - 700-PracticeOS/practice-os.md (BPOS - sesiones y agenda)
  - 000-Infrastructure/selection.md (Infraestructura - opciones gratuitas)
exports:
  - Fuentes de evidencia (multimodalidad)
  - Confidence Engine (actualización bayesiana)
  - Selección adaptativa de la siguiente mejor evidencia
  - Integración con Behavioral Twin
  - Pipeline de procesamiento de datos
  - Criterios de validación y métricas de éxito
used_by:
  - Behavioral Twin (actualización continua)
  - TCCN (contexto conversacional)
  - BERL (selección de ejercicios)
  - AHEE (adaptación de experiencia)
  - MPO (planificación de procesos)
  - BSC (investigación y mejora de modelos)
---

# BehavioralOS – Orquestador de Evaluación Adaptativa (AAO)

> *"El AAO no es un test. No es un cuestionario. No es una batería de pruebas. Es un sistema vivo que observa, integra y aprende de cada interacción del paciente, construyendo un modelo dinámico y preciso de su comportamiento. No pregunta porque sí; pregunta solo cuando hacerlo reduce la incertidumbre clínica. Es el científico empírico del BehavioralOS."*

---

## 1. Propósito y Alcance

### 1.1. Propósito
Este documento define el **Adaptive Assessment Orchestrator (AAO)**, el motor de evaluación continua, multimodal e idiográfica del BehavioralOS. Su objetivo es:

- **Integrar múltiples fuentes de evidencia** (conversación, gameplay, voz, cámara, agenda, sesiones, neuropsicología) para construir un perfil dinámico del paciente.
- **Reducir la incertidumbre clínica** mediante la selección adaptativa de la siguiente mejor evidencia.
- **Actualizar el Behavioral Twin** en tiempo real con nuevas estimaciones de procesos y confianzas.
- **Minimizar la carga del paciente**, realizando evaluaciones de forma no intrusiva y solo cuando sea necesario.
- **Proveer un modelo idiográfico** que refleje la singularidad de cada persona.

### 1.2. Alcance
El documento cubre:

- **Fuentes de evidencia**: 10 fuentes de datos (conversación, gameplay, voz, cámara, agenda, sesiones, neuropsicología, etc.) y su integración.
- **Confidence Engine**: Actualización bayesiana de hipótesis y procesos, propagación de confianza en el grafo.
- **Selección adaptativa de evidencia**: Motor que decide qué pregunta, tarea o ejercicio realizar para reducir la incertidumbre.
- **Integración con Behavioral Twin**: Actualización en tiempo real del modelo del paciente.
- **Pipeline de procesamiento**: Flujo de datos desde la entrada hasta la actualización del Twin.
- **Criterios de validación**: Métricas de precisión, reducción de incertidumbre, carga del paciente y escalabilidad.

### 1.3. Principio Fundamental
> **"El AAO no evalúa para juzgar; evalúa para comprender. Cada pregunta, cada observación, cada dato recogido es una pieza de un rompecabezas que el sistema construye para ayudar al paciente y al terapeuta a ver el cuadro completo. La incertidumbre no es un error; es información sobre lo que aún no sabemos."**

---

## 2. Filosofía de la Evaluación Adaptativa

### 2.1. Paradigma Tradicional vs. Paradigma AAO

| Aspecto | Evaluación Tradicional | AAO (BehavioralOS) |
|---------|------------------------|---------------------|
| **Frecuencia** | Episódica (cada mes o trimestre) | Continua (cada interacción) |
| **Formato** | Cuestionarios largos y fijos | Micro-evaluaciones contextuales |
| **Carga del paciente** | Alta (60-90 minutos) | Muy baja (5-30 segundos) |
| **Fuentes de datos** | Auto-reporte únicamente | Multimodal (texto, voz, gameplay, agenda, etc.) |
| **Adaptabilidad** | Fija (todos responden lo mismo) | Adaptativa (se elige la siguiente mejor pregunta) |
| **Modelo** | Nomotético (comparación con normas) | Idiográfico (el paciente es su propia referencia) |
| **Resultado** | Puntuaciones estáticas | Modelo dinámico con niveles de confianza |

### 2.2. Principios del AAO

| # | Principio | Descripción | Manifestación |
|---|-----------|-------------|---------------|
| 1 | **Multimodalidad** | La evaluación se basa en múltiples fuentes de datos (no solo auto-reporte). | Texto, voz, gameplay, agenda, sesiones, etc. |
| 2 | **No intrusividad** | La evaluación no debe interrumpir la experiencia del usuario. | Las preguntas se integran en la conversación, el juego, o la agenda. |
| 3 | **Adaptatividad** | La siguiente evaluación se elige para reducir la incertidumbre del modelo. | El AAO selecciona la pregunta o tarea con mayor valor informativo. |
| 4 | **Idiograficidad** | El modelo es específico del paciente; no se usan normas poblacionales. | La confianza se basa en la historia del paciente, no en comparaciones con otros. |
| 5 | **Transparencia** | El sistema explica por qué evalúa lo que evalúa. | El terapeuta y el paciente pueden ver el razonamiento del AAO. |
| 6 | **Consentimiento** | El paciente controla qué datos se recogen y cómo se usan. | Consentimientos granulares (BCPOS). |

---

## 3. Arquitectura del AAO

### 3.1. Visión General
┌─────────────────────────────────────────────────────────────────────────┐
│ Fuentes de Evidencia │
├─────────────┬─────────────┬─────────────┬─────────────┬─────────────┤
│ Conversación│ Gameplay │ Voz │ Cámara │ Agenda │
│ (TCCN) │ (BERL) │ (Whisper) │ (Face Mesh) │ (BPOS) │
├─────────────┼─────────────┼─────────────┼─────────────┼─────────────┤
│ Sesiones │ Neuropsi- │ Auto-reporte│ Terapeuta │ Sensores │
│ (BPOS) │ cología │ (EMA) │ (Feedback) │ (Wearables) │
│ │ (jsPsych) │ │ │ (opcional) │
└─────────────┴─────────────┴─────────────┴─────────────┴─────────────┘
│
▼
┌───────────────────────────────┐
│ Behavioral Evidence Fusion │
│ Engine (BEFE) │
│ • Normalización de datos │
│ • Fusión multimodal │
│ • Cálculo de confianza │
└───────────────────────────────┘
│
▼
┌───────────────────────────────┐
│ Confidence Engine │
│ • Actualización bayesiana │
│ • Propagación de confianza │
└───────────────────────────────┘
│
▼
┌───────────────────────────────┐
│ Adaptive Evidence Selector │
│ (AES) │
│ • Selección de la siguiente │
│ mejor evidencia │
└───────────────────────────────┘
│
▼
┌───────────────────────────────┐
│ Behavioral Twin Update │
│ • Actualización de procesos │
│ • Generación de hipótesis │
└───────────────────────────────┘


### 3.2. Componentes del AAO

| Componente | Descripción | Tecnología | Notas (Gratuito) |
|------------|-------------|------------|------------------|
| **BEFE (Behavioral Evidence Fusion Engine)** | Normaliza y fusiona datos de múltiples fuentes. | Python (FastAPI), Pandas, NumPy | Open source |
| **Confidence Engine** | Actualiza confianzas de procesos y hipótesis (Bayesiano). | Python (FastAPI), NumPy, scipy | Open source |
| **Adaptive Evidence Selector (AES)** | Selecciona la siguiente mejor evidencia (reglas difusas + modelos). | Python (FastAPI), fuzzylogic, scikit-learn | Open source |
| **Behavioral Twin Update** | Actualiza el modelo del paciente en Supabase. | Supabase (PostgreSQL) | Plan gratuito (500 MB) |

---

## 4. Fuentes de Evidencia

### 4.1. Lista de Fuentes

| # | Fuente | Descripción | Datos extraídos | Frecuencia | Tecnología |
|---|--------|-------------|-----------------|------------|------------|
| 1 | **Conversación (TCCN)** | Diálogo con el compañero. | Marcos RFT, procesos (Aceptación, Defusión, etc.), emociones, valores. | Cada interacción | Gemma (NLP) |
| 2 | **Gameplay (BERL)** | Minijuegos y misiones. | Tiempo de reacción, errores, persistencia, abandono, variabilidad. | Cada ejercicio | Godot + jsPsych |
| 3 | **Voz (Whisper)** | Audio de conversaciones o ejercicios. | Prosodia (pausas, ritmo, intensidad), emociones. | Cada sesión/ejercicio | Whisper (on-device) |
| 4 | **Cámara (Face Mesh)** | Video (con consentimiento). | Fatiga, atención, microexpresiones. | Opcional | MediaPipe Face Mesh |
| 5 | **Agenda (BPOS)** | Citas y actividades. | Adherencia a citas, patrones de asistencia. | Diario | BPOS |
| 6 | **Sesiones (BPOS)** | Notas de sesión (SOAP/DAP). | Progreso en procesos, hipótesis confirmadas/rechazadas. | Cada sesión | BPOS |
| 7 | **Neuropsicología (jsPsych)** | Tareas cognitivas (Stroop, Go/NoGo, etc.). | Funciones ejecutivas, atención, memoria. | Evaluación específica | jsPsych + Godot |
| 8 | **Auto-reporte (EMA)** | Preguntas cortas en la app. | Estado de ánimo, energía, sueño. | Diario o según necesidad | Patient App |
| 9 | **Terapeuta (Feedback)** | Observaciones del terapeuta. | CRB (FAP), hipótesis, cambios en el plan. | Cada sesión | BPOS |
| 10 | **Sensores (Wearables)** | Dispositivos vestibles (opcional). | Frecuencia cardíaca, actividad física, sueño. | Continuo | Integración externa |

### 4.2. Fusión Multimodal (BEFE)

El BEFE normaliza los datos de todas las fuentes y los combina en un formato unificado para el Confidence Engine.

**Estructura de evidencia normalizada**:

```json
{
  "patient_id": "pat_001",
  "source": "conversation",
  "timestamp": "2026-07-01T14:30:00Z",
  "process": "Aceptación",
  "value": 0.65,          // Estimación del proceso (0-1)
  "confidence": 0.82,     // Confianza en la estimación
  "context": {
    "session_id": "ses_001",
    "message_id": "msg_012"
  },
  "metadata": {
    "model_version": "gemma-2b-q4",
    "guardrails_ok": true
  }
}

Fusión de confianzas (ponderada por la calidad de la fuente):

Fuente	Peso por defecto	Justificación
Conversación (TCCN)	0.7	Alta, pero depende del contexto.
Gameplay (BERL)	0.85	Alta (datos objetivos de comportamiento).
Voz (Whisper)	0.6	Media (depende de la calidad del audio).
Cámara (Face Mesh)	0.5	Media-baja (indicador exploratorio).
Agenda (BPOS)	0.8	Alta (datos objetivos).
Sesiones (BPOS)	0.9	Muy alta (juicio clínico).
Neuropsicología (jsPsych)	0.85	Alta (tareas estandarizadas).
Auto-reporte (EMA)	0.6	Media (sesgo de auto-reporte).
Terapeuta (Feedback)	0.95	Muy alta (juicio profesional).
Sensores (Wearables)	0.7	Media-alta (datos objetivos).
5. Confidence Engine
5.1. Modelo de Confianza
El Confidence Engine mantiene un modelo probabilístico de cada proceso psicológico del paciente. La confianza de un proceso se actualiza con cada nueva evidencia usando inferencia bayesiana.

Estado de un proceso:

{
  "process_name": "Aceptación",
  "value": 0.65,           // Estimación actual (0-1)
  "confidence": 0.82,      // Confianza en la estimación (0-1)
  "last_updated": "2026-07-01T14:30:00Z",
  "history": [
    {"timestamp": "2026-06-01T10:00:00Z", "value": 0.45, "confidence": 0.75},
    {"timestamp": "2026-06-15T12:00:00Z", "value": 0.55, "confidence": 0.80}
  ],
  "trend": "ascendente",   // ascendente, descendente, estable
  "sources": ["AAO", "BERL", "TCCN"] // Fuentes que han contribuido
}

5.2. Actualización Bayesiana
Cuando llega una nueva evidencia, la confianza del proceso se actualiza con el teorema de Bayes:
P(proceso | evidencia) = (P(evidencia | proceso) * P(proceso)) / P(evidencia)

P(proceso): Confianza previa.

P(evidencia | proceso): Probabilidad de la evidencia dado el proceso (estimada por el motor clínico).

P(evidencia): Probabilidad de la evidencia (normalización).

Ejemplo:

Confianza previa en Aceptación: 0.50 (baja).

Nueva evidencia (gameplay): El paciente completó una misión de aceptación con alta persistencia.

P(evidencia | Aceptación) = 0.85.

P(evidencia) = 0.60 (normalización).

Confianza posterior = (0.85 * 0.50) / 0.60 = 0.71.

Nueva confianza: 0.71 (moderada).

5.3. Propagación de Confianza
Cuando un proceso cambia su confianza, la confianza de los procesos relacionados se actualiza mediante reglas de propagación (definidas en la ontología):

Facilitación (facilitates): Si A facilita B, y A aumenta su confianza, B recibe un incremento proporcional.

Inhibición (inhibits): Si A inhibe B, y A aumenta su confianza, B disminuye.

Generalización (generalizes_to): Si A se generaliza a B, la confianza en B se actualiza con un factor de transferencia.

Ejemplo:

Aceptación facilita Flexibilidad.

Si Aceptación sube de 0.65 a 0.75 (confianza 0.82), Flexibilidad sube de 0.55 a 0.60 (confianza 0.75).

6. Adaptive Evidence Selector (AES)
6.1. Propósito
El AES decide qué evidencia recopilar a continuación para reducir la incertidumbre del modelo de manera eficiente y con la mínima carga para el paciente.

6.2. Estrategia
El AES utiliza una combinación de reglas difusas y modelos de aprendizaje activo para seleccionar la siguiente mejor evidencia.

Pasos:

Identificar procesos con baja confianza: El Confidence Engine identifica los procesos con menor confianza (ej. < 0.6).

Calcular el valor informativo de cada posible acción: Cada fuente de evidencia (ej. una pregunta, un minijuego, una tarea neuropsicológica) tiene un costo (tiempo, carga) y un valor informativo potencial (reducción esperada de la incertidumbre).

Seleccionar la acción con mejor relación costo/beneficio: El AES elige la acción que maximiza la reducción de incertidumbre por unidad de carga del paciente.

Ejemplo de selección:

Proceso	Confianza	Acciones posibles	Costo	Valor informativo esperado	Relación
Aceptación	0.45	Pregunta EMA (5s)	0.1	0.30	3.0
Aceptación	0.45	Misión de respiración (3 min)	0.6	0.45	0.75
Defusión	0.55	Misión de defusión (5 min)	0.8	0.50	0.63
Valores	0.80	Pregunta EMA (5s)	0.1	0.05	0.5
Selección: El AES selecciona la pregunta EMA sobre Aceptación (relación costo/beneficio más alta).

6.3. Reglas Difusas para Selección Contextual
El AES también utiliza reglas difusas basadas en el contexto:

Si el usuario está cansado (fatiga > 70) → Usar solo micro-preguntas (no misiones).

Si el usuario está ansioso (estado emocional = 'ansioso') → Priorizar preguntas sobre regulación emocional.

Si el usuario ha completado muchas misiones hoy (> 3) → Reducir la frecuencia de evaluación.

Si la confianza en un proceso es muy baja (< 0.3) → Priorizar la recogida de evidencia para ese proceso.

6.4. Integración con el Flujo del Usuario
El AES no interrumpe al usuario; las evaluaciones se integran en el flujo natural:

Durante la conversación: El TCCN puede hacer preguntas que también sirven como evaluación (ej. "¿Cómo te sientes hoy con respecto a la aceptación?").

Durante el juego: Las misiones incluyen tareas que también evalúan procesos (ej. una misión de defusión que mide latencia y errores).

En la agenda: Se pueden programar micro-evaluaciones (EMA) en momentos de baja actividad.

7. Integración con el Behavioral Twin
7.1. Actualización en Tiempo Real
El AAO actualiza el Behavioral Twin después de cada interacción significativa:

Recepción de evidencia: El AAO recibe una nueva evidencia de una de las fuentes (ej. conversación, gameplay).

Fusión y normalización: El BEFE normaliza la evidencia.

Actualización de confianza: El Confidence Engine actualiza la confianza del proceso correspondiente.

Propagación: Se actualizan los procesos relacionados.

Generación de hipótesis: Si se detecta un cambio significativo, el AAO genera nuevas hipótesis o actualiza las existentes.

Persistencia: El Twin actualizado se guarda en Supabase (gratis).

7.2. Generación de Hipótesis
El AAO genera hipótesis funcionales basadas en patrones detectados en los datos:

Patrón: El paciente muestra baja Aceptación (0.35) y alta Evitación (0.75) en contextos sociales.

Hipótesis: "La evitación social se mantiene por reforzamiento negativo (alivio de la ansiedad) y está mediada por marcos de coordinación 'yo = fracaso'." (confianza: 0.68).

Estructura de una hipótesis generada (ver ontología para detalles):

{
  "id": "hyp_001",
  "description": "La evitación social se mantiene por reforzamiento negativo...",
  "antecedents": ["crítica social", "evaluación"],
  "behavior": "evitación de interacciones sociales",
  "consequences": ["alivio inmediato", "aislamiento"],
  "processes": ["avoidance_experiential", "fusion_cognitiva"],
  "relational_frames": [{"source": "yo", "target": "fracaso", "type": "coordinación"}],
  "confidence": 0.68,
  "evidence_for": [{"source": "AAO", "confidence": 0.82}],
  "evidence_against": [],
  "status": "activa"
}

7.3. Notificación al Terapeuta
Si el AAO detecta cambios significativos o riesgos (ej. riesgo de abandono > 70%), envía una notificación al terapeuta a través del BPOS (dashboard, correo, push).

8. Pipeline de Procesamiento
8.1. Flujo de Datos
Entrada: El usuario interactúa con el sistema (ej. envía un mensaje al TCCN, completa un ejercicio).

Extracción de evidencia: El componente correspondiente (TCCN, BERL, etc.) extrae datos relevantes y los envía al AAO a través de BRIL (evento EVIDENCE_COLLECTED).

Normalización: El BEFE normaliza la evidencia en el formato unificado.

Fusión: Se combina con evidencia previa (ponderada por fuente).

Actualización de confianza: El Confidence Engine actualiza los procesos y propaga cambios.

Selección de siguiente evidencia: El AES decide si es necesario recopilar más evidencia (y qué tipo).

Actualización del Twin: El Twin se actualiza en Supabase.

Generación de eventos: Se publica un evento BEHAVIORAL_TWIN_UPDATED para que otros motores (MPO, AHEE, etc.) reaccionen.

8.2. Ejemplo de Flujo (Conversación)
Usuario: "Hoy no pude hacer nada. Me sentí muy abrumado."

TCCN: Procesa el mensaje, detecta baja activación y posible evitación. Envía evidencia al AAO.

AAO:

Normaliza: proceso = 'Activación', valor = 0.30, confianza = 0.75.

Actualiza el Twin: Activación baja (0.30).

Propaga: Evitación sube (0.70).

Genera hipótesis: "La baja activación se mantiene por evitación experiencial."

AES: Decide hacer una pregunta EMA (5s) sobre estado de ánimo.

TCCN: Hace la pregunta ("¿Cómo te sientes en este momento?").

Usuario: Responde ("Triste y sin energía.").

AAO: Actualiza el Twin con la nueva evidencia (estado emocional = 'triste').

9. Escalabilidad y Rendimiento
9.1. Optimización
Procesamiento asíncrono: El AAO procesa la evidencia de forma asíncrona (eventos) para no bloquear la experiencia del usuario.

Cache de confianzas: Las confianzas de procesos se cachean en Redis (gratis) para acceso rápido.

Batch processing: Si hay múltiples evidencias en un corto período, se procesan en lotes.

9.2. Métricas de Rendimiento
Métrica	Objetivo	Herramienta
Tiempo de procesamiento de evidencia	< 100 ms (por evento)	Monitoreo de rendimiento
Actualización del Twin	< 1 s (desde el evento hasta la persistencia)	Monitoreo de rendimiento
Carga del paciente (evaluaciones diarias)	< 3 minutos por día	Analítica de uso
Uso de memoria (Cache)	< 1 GB (para 1000 pacientes activos)	Monitoreo de memoria
10. Criterios de Validación y Cumplimiento
Criterio	Métrica	Herramienta
Precisión clínica	Concordancia entre las estimaciones del AAO y el juicio del terapeuta ≥ 0.7 (correlación).	Revisión clínica
Reducción de incertidumbre	Reducción de confianza promedio de procesos después de 10 interacciones ≥ 20%.	Monitoreo de confianzas
Carga del paciente	Tiempo total de evaluación diario < 3 minutos.	Analítica de uso
Escalabilidad	Soporte para > 10,000 pacientes activos.	Pruebas de carga (k6)
Adaptatividad	El AES selecciona la evidencia correcta (juicio del terapeuta) ≥ 80%.	Revisión clínica
Privacidad	100% de los datos de evaluación se procesan de acuerdo con los consentimientos del paciente.	Auditoría de consentimientos
11. El Manifiesto del AAO
"El AAO no evalúa para juzgar; evalúa para comprender.

Cada pregunta, cada observación, cada dato recogido es una pieza de un rompecabezas que el sistema construye para ayudar al paciente y al terapeuta a ver el cuadro completo.

La incertidumbre no es un error; es información sobre lo que aún no sabemos.

El AAO es el científico empírico del BehavioralOS: observa, hipotetiza, experimenta y aprende. No se cansa, no se aburre, no juzga.

Su objetivo es reducir la incertidumbre clínica para que el terapeuta pueda tomar mejores decisiones y el paciente pueda recibir una intervención más personalizada.

Nuestra responsabilidad es garantizar que el AAO sea preciso, ético, no intrusivo y siempre al servicio del paciente."

12. Historial de Cambios
Versión	Fecha	Autor	Cambios
1.0.0	2026-07-01	Arquitectura de IA	Creación del documento. Definición de fuentes de evidencia, Confidence Engine, Adaptive Evidence Selector, integración con Behavioral Twin, pipeline de procesamiento y criterios de validación.
Fin del documento adaptive-orchestrator.md