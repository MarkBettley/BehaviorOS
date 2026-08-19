---
id: VOC-001
title: Lenguaje del Ecosistema (Vocabulario Controlado)
version: 1.0.0
status: Stable
owner: Arquitectura & Psicología Clínica
last_updated: 2026-07-01
depends_on:
  - PHI-001 (Filosofía)
  - PRN-001 (Principios)
exports:
  - Diccionario de Términos Permitidos y Prohibidos
  - Reglas de Estilo para la IA (TCCN)
  - Reglas de Estilo para la UI (BDS)
used_by:
  - TCCN (Companion)
  - BDS (Design System)
  - Patient App
  - Therapist App
  - BERL (Exercise Narratives)
  - AHEE (Adaptive Language)
---

# BehavioralOS – Lenguaje del Ecosistema (Vocabulario Controlado)

> *"No se trata de censura. Se trata de precisión clínica y dignidad humana. La palabra que usamos para describir a una persona moldea la realidad que esa persona habita."*

---

## 1. Propósito de este documento

El lenguaje no es neutral. En psicoterapia, las palabras pueden:
- **Reducir el estigma** (vs. reforzarlo).
- **Empoderar** (vs. patologizar).
- **Generar curiosidad** (vs. provocar defensa).
- **Fortalecer la alianza terapéutica** (vs. erosionarla).

Este documento establece un **diccionario controlado** para todo el ecosistema. Define:
- **Palabras prohibidas**: Términos que nunca deben usarse en la interfaz, en la comunicación de la IA ni en los materiales del producto.
- **Palabras permitidas**: Términos alternativos que deben usarse en su lugar, con su justificación clínica y funcional.
- **Reglas de estilo**: Cómo debe estructurarse la comunicación (longitud, tono, tiempo verbal).

Este vocabulario aplica a:
- El **Compañero IA** (TCCN) en sus diálogos.
- La **UI/UX** (textos de botones, títulos, notificaciones).
- Los **materiales educativos** y psicoeducativos.
- Los **informes clínicos** (cuando están dirigidos al paciente o a sus familias).

---

## 2. Filosofía del Lenguaje

El BehavioralOS adopta una postura de **contextualismo funcional**. Esto significa:

1.  **Evitamos etiquetas estáticas**: Las personas no *son* ansiosas o depresivas; tienen patrones de comportamiento que pueden cambiar.
2.  **Priorizamos la agencia**: El lenguaje debe reflejar que la persona es el agente de su cambio, no un receptor pasivo de un tratamiento.
3.  **Fomentamos la curiosidad**: Las preguntas abiertas y el lenguaje exploratorio son preferibles a las afirmaciones categóricas.
4.  **Normalizamos la experiencia humana**: El malestar no es una anomalía; es una parte de la experiencia humana que podemos aprender a manejar.

---

## 3. Diccionario: Palabras Prohibidas ↔ Palabras Permitidas

### 3.1. Categoría: Identidad y Estado Clínico

| Prohibido | Permitido | Justificación Clínica | Ejemplo en contexto |
|-----------|-----------|------------------------|----------------------|
| Paciente (en contexto de la app) | Explorador, Persona, Usuario | "Paciente" implica pasividad y enfermedad. "Explorador" implica agencia y descubrimiento. | ❌ "El paciente completó el ejercicio." → ✅ "El explorador completó la misión." |
| Deprimido, Ansioso (como adjetivo de persona) | Está atravesando un periodo de baja activación / Está experimentando alta alerta | No etiquetamos a la persona; describimos su estado funcional actual. | ❌ "Eres una persona ansiosa." → ✅ "En este momento, tu sistema está en alerta alta. Eso es una respuesta, no una identidad." |
| Trastorno, Enfermedad mental | Patrón de comportamiento, Proceso psicológico | La ciencia contextual (PBT) habla de procesos, no de entidades estáticas. | ❌ "Tiene un trastorno de ansiedad." → ✅ "Presenta un patrón de evitación ante situaciones de incertidumbre." |
| Síntoma | Patrón, Señal, Indicador | Los síntomas son consecuencias de procesos; los patrones son observables y modificables. | ❌ "Reporta síntomas de insomnio." → ✅ "Observamos un patrón de sueño interrumpido." |
| Recaída | Nuevo aprendizaje, Información sobre el contexto, Retroceso temporal | La recaída no es un fracaso; es una oportunidad para aprender qué mantiene el cambio. | ❌ "El paciente recayó." → ✅ "Apareció un patrón conocido en un nuevo contexto. Eso nos da información valiosa." |

### 3.2. Categoría: Interacción y Tareas

| Prohibido | Permitido | Justificación Clínica | Ejemplo en contexto |
|-----------|-----------|------------------------|----------------------|
| Ejercicio, Tarea, Actividad | Misión, Experiencia, Expedición, Práctica | "Ejercicio" suena a deber escolar. "Misión" suena a descubrimiento y aventura. | ❌ "Completa el ejercicio de respiración." → ✅ "Inicia la expedición de regulación." |
| Cumplir, Completar (como objetivo) | Descubrir, Explorar, Experimentar | El éxito no es terminar; es aprender. | ❌ "Completaste el 80% de las tareas." → ✅ "Descubriste un nuevo patrón en tu comportamiento." |
| Fracaso, Error | Experimento, Información nueva, Dato | El error es una fuente de información para el modelo, no un juicio sobre la persona. | ❌ "Fallaste en la misión." → ✅ "El experimento nos dio información inesperada. ¿Qué podemos aprender de esto?" |
| Tienes que, Debes, Necesitas | ¿Te gustaría?, ¿Qué tal si..., Podríamos... | La autonomía es clave para la motivación intrínseca. | ❌ "Tienes que hacer la práctica de hoy." → ✅ "Hoy podríamos explorar una nueva estrategia. ¿Te parece?" |
| Seguimiento (como obligación) | Acompañamiento, Próximo paso | El proceso terapéutico es un viaje compartido, no una auditoría. | ❌ "Te recordamos tu seguimiento." → ✅ "Tu próximo acompañamiento está listo para cuando tú quieras." |

### 3.3. Categoría: Progreso y Resultados

| Prohibido | Permitido | Justificación Clínica | Ejemplo en contexto |
|-----------|-----------|------------------------|----------------------|
| Mejoría (como reducción de síntomas) | Crecimiento, Flexibilidad, Desarrollo de habilidades | El objetivo no es eliminar el malestar; es aumentar la capacidad de vivir bien a pesar de él. | ❌ "Tu ansiedad bajó un 20%." → ✅ "Desarrollaste la habilidad de permanecer en situaciones incómodas el doble de tiempo que la semana pasada." |
| Puntuación, Calificación | Evidencia, Descubrimiento, Perfil | No evaluamos a la persona; observamos su comportamiento. | ❌ "Obtuviste 42 puntos en ansiedad." → ✅ "La evidencia sugiere que en contextos sociales tu activación aumenta. Eso es información útil." |
| Mejor que, Peor que (comparación) | Diferente a, Comparado con tu línea base | La comparación social es dañina. Solo importa la trayectoria individual. | ❌ "Estás mejor que el promedio." → ✅ "Comparado con tus propias mediciones de hace un mes, has ampliado tu repertorio de acciones." |
| Alta (como en "Alta clínica") | Transición, Nueva etapa, Consolidación | El "alta" suena a fin de contrato. La "transición" suena a evolución natural. | ❌ "El paciente recibió el alta." → ✅ "El explorador entra en la etapa de entrenamiento continuo." |

### 3.4. Categoría: IA y Tecnología

| Prohibido | Permitido | Justificación Clínica | Ejemplo en contexto |
|-----------|-----------|------------------------|----------------------|
| Chatbot, IA, Inteligencia Artificial | Compañero, Guía digital, Investigador | Humanizamos la interacción sin engañar. | ❌ "Habla con la IA." → ✅ "Tu compañero de investigación tiene una observación." |
| Algoritmo, Modelo | Sistema de apoyo, Herramienta de exploración | Evitamos el lenguaje frío y técnico. | ❌ "El algoritmo detectó un patrón." → ✅ "Hemos observado un patrón que podría interesarte." |
| Datos (en contexto de la app) | Huellas, Evidencia, Pistas | Los datos son más personales y significativos. | ❌ "Tus datos de sueño indican..." → ✅ "Las pistas sobre tu sueño sugieren..." |

---

## 4. Reglas de Estilo para la Comunicación

### 4.1. Reglas Generales (Aplican a toda la interfaz y a la IA)

| # | Regla | Explicación | Ejemplo |
|---|-------|-------------|---------|
| 1 | **Segunda persona del singular** | Siempre tratar al usuario como "tú". Es más cálido y directo. | ❌ "El usuario debe completar..." → ✅ "Tú puedes explorar..." |
| 2 | **Tiempo verbal en presente o pasado reciente** | Evitar el futuro incierto o el condicional excesivo. | ❌ "Podrías sentir..." → ✅ "Has notado que..." |
| 3 | **Frases cortas y directas** | Máximo 15 palabras por frase en la app. Para textos largos (psicoeducación), usar párrafos cortos. | ❌ "En este ejercicio vas a practicar la habilidad de observar tus pensamientos sin fusionarte con ellos para aumentar tu flexibilidad psicológica." → ✅ "Vas a observar tus pensamientos. Sin juzgarlos. Solo notarlos." |
| 4 | **Evitar jerga técnica innecesaria** | Si se usa un término técnico (ej. "defusión"), debe ir acompañado de una explicación sencilla. | ❌ "Practica defusión cognitiva." → ✅ "Observa tus pensamientos como si fueran nubes. No los empujes, solo míralos pasar." |
| 5 | **Preguntas en lugar de afirmaciones** | Las preguntas abiertas fomentan la reflexión y la curiosidad. | ❌ "La ansiedad es normal." → ✅ "¿Qué crees que está tratando de decirte tu ansiedad en este momento?" |
| 6 | **Validación antes de desafío** | Primero reconocer el esfuerzo o la emoción, luego ofrecer una nueva perspectiva. | ❌ "Deberías hacer esto." → ✅ "Entiendo que es difícil. ¿Qué tal si lo intentamos desde otro ángulo?" |

### 4.2. Reglas para la IA (TCCN - Compañero)

- **Tono**: Calmo, curioso, respetuoso, observador. Nunca sarcástico, paternalista ni excesivamente alegre.
- **Longitud de respuesta**: Promedio de 2 a 4 oraciones. Nunca párrafos largos a menos que el usuario pida más información.
- **Frecuencia**: No interrumpe; espera a que el usuario termine de hablar o escribir.
- **Estructura típica de una respuesta**:
    1.  **Reconocimiento** (validación de lo que el usuario dijo).
    2.  **Observación** (patrón detectado o información relevante).
    3.  **Invitatación** (pregunta abierta o sugerencia).

    *Ejemplo:*
    > Usuario: "Hoy no pude hacer nada."
    >
    > IA: *"Entiendo que a veces las cosas se sienten pesadas. He notado que en días como este, sueles recuperar energía haciendo algo muy pequeño. ¿Qué tal si intentamos una micro-acción de solo 2 minutos?"*

### 4.3. Reglas para la UI (Paciente y Terapeuta)

- **Botones y CTAs**: Usar verbos de acción específicos y atractivos.
    - ❌ "Continuar" → ✅ "Seguir explorando" / "Ver descubrimiento"
    - ❌ "Enviar" → ✅ "Guardar reflexión" / "Compartir con mi guía"
    - ❌ "Cerrar" → ✅ "Volver al mapa" / "Pausar expedición"
- **Notificaciones**: Usar lenguaje invitacional, no imperativo.
    - ❌ "Recordatorio: practica hoy." → ✅ "Hoy hay una nueva pista sobre tu patrón de sueño. ¿Quieres verla?"
- **Títulos y encabezados**: Deben despertar curiosidad.
    - ❌ "Ejercicio de Respiración" → ✅ "El Poder de una Pausa"
    - ❌ "Registro de Estado de Ánimo" → ✅ "¿Qué está pasando hoy?"
- **Mensajes de carga/espera**: Convertir la espera en curiosidad.
    - ❌ "Cargando..." → ✅ "Preparando tu próxima expedición..." / "Analizando tus pistas..."

---

## 5. Implementación en el Ecosistema

### 5.1. Integración con el BDS (Design System)
- El BDS debe incluir un **validador léxico** que revise automáticamente los textos de la interfaz contra este diccionario. Si un texto contiene una palabra prohibida, el linter lo marcará como error.

### 5.2. Integración con el TCCN (Companion)
- El sistema de prompts de la IA debe incluir explícitamente estas reglas de vocabulario como parte de su "personalidad" y "guardrails".
- El guardrail de lenguaje verificará que la IA no use términos prohibidos, incluso si el usuario los usa (la IA puede reflejar, pero no adoptar el lenguaje patologizante).

### 5.3. Integración con el AHEE (Adaptación)
- El vocabulario se adapta por edad y contexto:
    - **Niños (6-12)**: Lenguaje más concreto, metáforas de juegos y criaturas.
    - **Adolescentes (13-18)**: Lenguaje más coloquial, referencias a la identidad y redes sociales.
    - **Adultos**: Lenguaje funcional, metáforas profesionales o de vida cotidiana.
    - **Adultos mayores**: Lenguaje claro, pausado, con metáforas de experiencia de vida.

### 5.4. Integración con el BQAS (Testing)
- Las pruebas de regresión incluirán una verificación de que ningún texto nuevo en la interfaz contenga palabras prohibidas. Esto se automatizará mediante scripts de análisis léxico.

---

## 6. El Manifiesto del Lenguaje

> *"Cada palabra que usamos es un pacto con el usuario.*
>
> *Una promesa de que lo vemos como un todo, no como un diagnóstico.*
>
> *Una promesa de que su viaje es de descubrimiento, no de corrección.*
>
> *Una promesa de que cada interacción, incluso las difíciles, es una oportunidad para aprender.*
>
> *No se trata de ser políticamente correctos. Se trata de ser clínicamente precisos y humanamente respetuosos."*

---

## 7. Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2026-07-01 | Arquitectura Jefe | Creación del documento. Definición de diccionario prohibido/permitido, reglas de estilo para IA y UI, y pautas de implementación. |

---

**Fin del documento `vocabulary.md`**