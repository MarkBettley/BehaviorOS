---
id: ACC-001
title: Accesibilidad y Adaptación Cognitiva
version: 1.0.0
status: Stable
owner: Diseño UX/UI & Frontend Engineering
last_updated: 2026-07-01
depends_on:
  - 000-Core/philosophy.md (Filosofía - dignidad, respeto, autonomía)
  - 000-Core/principles.md (Principios - accesibilidad como principio)
  - 300-Frontend/design-system.md (BDS - tokens, componentes)
  - 300-Frontend/ui-graph.md (UI Graph - navegación)
  - 300-Frontend/ahee-implementation.md (AHEE - adaptación)
exports:
  - Directrices WCAG 2.1 AA y AAA aplicables
  - Adaptaciones cognitivas (TEA, TDAH, dislexia, etc.)
  - Adaptaciones sensoriales (daltonismo, baja visión, etc.)
  - Adaptaciones por edad (niños, adultos mayores)
  - Integración con AHEE para personalización dinámica
  - Estrategias de implementación (ARIA, teclado, etc.)
  - Herramientas de testing y validación
used_by:
  - Frontend Engineers (implementación de accesibilidad)
  - QA (pruebas de accesibilidad)
  - UX Designers (diseño inclusivo)
  - AHEE (motor de adaptación)
  - BQAS (validación automática)
---

# BehavioralOS – Accesibilidad y Adaptación Cognitiva

> *"La accesibilidad no es una característica. Es un derecho. El BehavioralOS existe para ayudar a las personas a desarrollar habilidades psicológicas, y eso solo es posible si todas las personas, independientemente de sus capacidades, pueden acceder a la plataforma. Diseñar para la diversidad humana es diseñar para la excelencia."*

---

## 1. Propósito y Alcance

### 1.1. Propósito
Este documento define las **directrices de accesibilidad y adaptación cognitiva** del BehavioralOS. Su objetivo es:

- **Garantizar que todas las interfaces** del BehavioralOS (paciente, terapeuta, administrador) sean utilizables por personas con discapacidades visuales, motoras, cognitivas y sensoriales.
- **Cumplir con los estándares internacionales** de accesibilidad (WCAG 2.1 AA, y en lo posible AAA).
- **Proveer adaptaciones específicas** para trastornos del neurodesarrollo (TEA, TDAH, dislexia), adultos mayores y otras condiciones.
- **Integrar la accesibilidad con el motor adaptativo AHEE** para personalizar la interfaz en tiempo real según las necesidades del usuario.
- **Establecer un proceso de validación** continuo para garantizar que la accesibilidad se mantenga a lo largo del desarrollo.

### 1.2. Alcance
El documento cubre:

- **WCAG 2.1**: Principios, criterios de éxito y niveles de conformidad (AA y AAA).
- **Adaptaciones cognitivas**: TEA, TDAH, dislexia, discapacidad intelectual, daño cerebral adquirido.
- **Adaptaciones sensoriales**: Daltonismo, baja visión, ceguera, hipoacusia, sordera.
- **Adaptaciones motoras**: Dificultades de motricidad fina, uso de dispositivos asistivos.
- **Adaptaciones por edad**: Niños (6-12), adolescentes (13-18), adultos mayores (65+).
- **Integración con AHEE**: Variables de adaptación, mecanismos de cambio, personalización dinámica.
- **Estrategias de implementación**: ARIA, navegación por teclado, focus management, etiquetas, etc.
- **Herramientas de testing**: axe-core, Lighthouse, NVDA, VoiceOver, etc.
- **Criterios de validación**: Métricas y objetivos de cumplimiento.

### 1.3. Principio Fundamental
> **"La accesibilidad no es un destino, es un proceso continuo. Cada nueva característica, cada nuevo componente, cada nueva interacción debe ser evaluada desde una perspectiva de inclusión. Diseñar para el usuario promedio es diseñar para nadie. Diseñar para el usuario en el extremo es diseñar para todos."**

---

## 2. Filosofía y Principios de Accesibilidad

### 2.1. Los 7 Principios de Accesibilidad del BehavioralOS

| # | Principio | Descripción | Manifestación |
|---|-----------|-------------|---------------|
| 1 | **Universalidad** | La plataforma debe ser utilizable por todas las personas, sin necesidad de adaptaciones especiales. | Diseño base accesible; las adaptaciones son mejoras, no requisitos. |
| 2 | **Inclusividad** | La diversidad humana es la norma, no la excepción. | Las adaptaciones se diseñan desde el inicio, no como parches. |
| 3 | **Flexibilidad** | La interfaz debe adaptarse a las preferencias y necesidades del usuario. | AHEE ajusta colores, tamaño de texto, animaciones, etc. |
| 4 | **Simplicidad** | La interfaz debe ser fácil de entender y usar, independientemente de la capacidad cognitiva. | Lenguaje claro, navegación intuitiva, feedback consistente. |
| 5 | **Perceptibilidad** | La información debe ser presentada en múltiples formatos (visual, auditivo, textual). | Texto alternativo para imágenes, subtítulos para audio, etc. |
| 6 | **Tolerancia al error** | La interfaz debe minimizar las consecuencias de los errores. | Confirmaciones antes de acciones destructivas, opción de deshacer. |
| 7 | **Autonomía** | El usuario debe tener control sobre su experiencia. | Configuraciones de accesibilidad, personalización. |

### 2.2. Enfoque de "Diseño Inclusivo por Defecto"

El BehavioralOS adopta un enfoque de **diseño inclusivo por defecto**:

- **Contraste suficiente**: Relación de contraste ≥ 4.5:1 para texto normal, ≥ 3:1 para texto grande (WCAG AA).
- **Textos alternativos**: Todas las imágenes, iconos y elementos no textuales tienen descripciones alternativas.
- **Navegación por teclado**: Todas las funcionalidades son accesibles mediante teclado.
- **Etiquetas claras**: Todos los campos de formulario, botones y elementos interactivos tienen etiquetas descriptivas.
- **Feedback multimodal**: Las respuestas del sistema se presentan en al menos dos modalidades (ej. visual + auditiva).

---

## 3. WCAG 2.1: Principios, Criterios y Niveles

### 3.1. Los 4 Principios de WCAG

| Principio | Descripción | Aplicación en BehavioralOS |
|-----------|-------------|----------------------------|
| **Perceptible** | La información y los componentes de la interfaz deben ser presentados de forma que los usuarios puedan percibirlos. | Contraste de color, texto alternativo, subtítulos, audio descriptivo. |
| **Operable** | Los componentes de la interfaz y la navegación deben ser operables. | Navegación por teclado, tiempo suficiente, evitar ataques epilépticos. |
| **Comprensible** | La información y el funcionamiento de la interfaz deben ser comprensibles. | Lenguaje claro, consistencia, ayuda contextual, validación de entradas. |
| **Robusto** | El contenido debe ser suficientemente robusto como para ser interpretado por una amplia variedad de agentes de usuario, incluyendo tecnologías de asistencia. | HTML semántico, ARIA, compatibilidad con lectores de pantalla. |

### 3.2. Criterios de Éxito WCAG 2.1 AA (Obligatorios)

| # | Criterio | Nivel | Implementación en BehavioralOS |
|---|----------|-------|--------------------------------|
| 1 | **1.1.1 Contenido no textual** | A | Todas las imágenes, iconos y gráficos tienen texto alternativo. Los gráficos clínicos (Hexaflex, etc.) tienen descripciones textuales. |
| 2 | **1.2.2 Subtítulos (grabados)** | A | Todos los videos (psicoeducación, tutoriales) tienen subtítulos. |
| 3 | **1.3.1 Información y relaciones** | A | La estructura semántica (HTML) refleja la jerarquía de la información. Uso de `h1`, `h2`, `nav`, `main`, `aside`, etc. |
| 4 | **1.4.1 Uso del color** | A | El color no es el único medio para transmitir información (ej. gráficos con patrones o etiquetas). |
| 5 | **1.4.3 Contraste (mínimo)** | AA | Relación de contraste ≥ 4.5:1 para texto normal, ≥ 3:1 para texto grande. |
| 6 | **1.4.4 Redimensionar texto** | AA | El texto puede redimensionarse hasta 200% sin pérdida de contenido o funcionalidad. |
| 7 | **1.4.10 Reflujo** | AA | El contenido se ajusta sin pérdida de información al cambiar el tamaño de la ventana (responsive). |
| 8 | **1.4.11 Contraste de componentes no textuales** | AA | Los componentes interactivos (botones, campos) tienen contraste ≥ 3:1. |
| 9 | **1.4.12 Espaciado de texto** | AA | Se puede ajustar el espaciado entre líneas, palabras y letras sin pérdida de contenido. |
| 10 | **2.1.1 Teclado** | A | Todas las funcionalidades son accesibles mediante teclado. |
| 11 | **2.1.2 Sin trampa para el teclado** | A | El foco no queda atrapado en ningún elemento. |
| 12 | **2.2.1 Ajuste de tiempo** | A | El usuario puede ajustar o desactivar límites de tiempo (ej. en evaluaciones). |
| 13 | **2.3.1 Tres destellos o menos** | A | Ningún contenido destella más de 3 veces por segundo (seguridad epiléptica). |
| 14 | **2.4.1 Saltar bloques** | A | Enlaces de "saltar al contenido principal" en todas las páginas. |
| 15 | **2.4.2 Títulos de página** | A | Cada página tiene un título descriptivo. |
| 16 | **2.4.3 Orden del foco** | A | El orden del foco es lógico y preserva el significado. |
| 17 | **2.4.4 Propósito del enlace (en contexto)** | A | Los enlaces tienen texto descriptivo (no "clic aquí"). |
| 18 | **2.4.6 Encabezados y etiquetas** | AA | Los encabezados y etiquetas describen el contenido. |
| 19 | **2.4.7 Enfoque visible** | AA | El foco del teclado es visible. |
| 20 | **2.5.3 Etiqueta por nombre** | A | La etiqueta visible de un elemento coincide con su nombre accesible. |
| 21 | **3.1.1 Idioma de la página** | A | El idioma de la página está definido (`lang="es"`). |
| 22 | **3.2.1 Al recibir el foco** | A | Los cambios de contexto no ocurren al recibir el foco. |
| 23 | **3.2.2 Al recibir entrada** | A | Los cambios de contexto no ocurren al cambiar un valor de entrada (ej. no enviar automáticamente). |
| 24 | **3.3.1 Identificación de errores** | A | Los errores de entrada se describen claramente al usuario. |
| 25 | **3.3.2 Etiquetas o instrucciones** | A | Las etiquetas o instrucciones se proporcionan cuando el contenido requiere entrada del usuario. |
| 26 | **3.3.3 Sugerencias ante errores** | AA | Se proporcionan sugerencias para corregir errores. |
| 27 | **3.3.4 Prevención de errores (legal, financiero, datos)** | AA | Las acciones que tienen consecuencias legales o financieras (ej. pagos) requieren confirmación. |

### 3.3. Criterios de Éxito WCAG 2.1 AAA (Opcionales, pero buscados)

| # | Criterio | Nivel | Implementación en BehavioralOS |
|---|----------|-------|--------------------------------|
| 1 | **1.2.6 Lengua de señas (grabadas)** | AAA | Videos de psicoeducación incluyen interpretación en lengua de señas (opcional). |
| 2 | **1.4.6 Contraste (mejorado)** | AAA | Relación de contraste ≥ 7:1 para texto normal, ≥ 4.5:1 para texto grande. |
| 3 | **1.4.8 Presentación visual** | AAA | El usuario puede ajustar el ancho de línea, espaciado y colores de fondo/texto. |
| 4 | **2.1.3 Teclado (sin excepciones)** | AAA | Todas las funcionalidades son accesibles mediante teclado (sin excepciones). |
| 5 | **2.2.3 Sin tiempos** | AAA | No hay límites de tiempo (o se pueden desactivar completamente). |
| 6 | **2.3.2 Tres destellos** | AAA | Ningún contenido destella más de 3 veces por segundo (más estricto). |
| 7 | **2.4.8 Ubicación actual** | AAA | El usuario siempre sabe dónde está en la navegación (breadcrumbs, indicadores). |
| 8 | **2.4.9 Propósito del enlace (solo enlace)** | AAA | Los enlaces tienen texto descriptivo incluso fuera de contexto. |
| 9 | **3.1.3 Mecanismos para palabras inusuales** | AAA | Se proporcionan definiciones para palabras inusuales o jerga. |
| 10 | **3.2.5 Cambio a petición** | AAA | Los cambios de contexto son iniciados solo por el usuario. |
| 11 | **3.3.5 Ayuda contextual** | AAA | Se proporciona ayuda contextual para formularios y tareas complejas. |
| 12 | **3.3.6 Prevención de errores (todos)** | AAA | Se permite deshacer o corregir errores en todas las entradas. |

---

## 4. Adaptaciones Cognitivas

### 4.1. Trastorno del Espectro Autista (TEA)

| Característica | Desafío | Adaptación en BehavioralOS |
|----------------|---------|----------------------------|
| **Sensibilidad sensorial** | Sobrecarga por colores brillantes, sonidos, animaciones. | **Modo baja estimulación**: Reduce colores, elimina animaciones, minimiza sonidos, interfaz más suave. |
| **Dificultades sociales y de comunicación** | Interpretación literal del lenguaje, dificultad con ironía o metáforas. | **Lenguaje claro y literal**: El TCCN evita metáforas complejas, usa frases directas. |
| **Necesidad de predictibilidad** | Ansiedad ante cambios inesperados. | **Rutinas y estructuras**: La app muestra la estructura del día (ej. "hoy harás una misión de 5 minutos"). Transiciones claras. |
| **Intereses restringidos** | Dificultad para cambiar de tema o tarea. | **Personalización**: El usuario puede elegir temas de interés (ej. dinosaurios, espacio) para las narrativas de las misiones. |
| **Dificultades con la abstracción** | Problemas para entender conceptos abstractos (ej. "defusión"). | **Visualización concreta**: Los conceptos se representan visualmente (ej. pensamientos como globos). |

**Adaptaciones específicas**:
- **Modo TEA**: Activa automáticamente el modo baja estimulación, lenguaje literal y estructura predecible.
- **Navegación visual**: El mapa del Atlas utiliza colores suaves y patrones claros.
- **Feedback predecible**: Las respuestas del TCCN siguen una estructura consistente (validación + observación + invitación).

### 4.2. Trastorno por Déficit de Atención e Hiperactividad (TDAH)

| Característica | Desafío | Adaptación en BehavioralOS |
|----------------|---------|----------------------------|
| **Distractibilidad** | Dificultad para mantener la atención. | **Modo concentración**: Elimina distracciones visuales (animaciones, iconos no esenciales), reduce opciones en pantalla. |
| **Impulsividad** | Tendencia a acciones rápidas sin reflexión. | **Pausas obligatorias**: Algunas misiones incluyen pausas para reflexionar (ej. "Tómate 5 segundos antes de continuar"). |
| **Dificultad con tareas largas** | Abandono de tareas largas. | **Micro-misiones**: Las misiones largas se dividen en pasos cortos (2-3 minutos cada uno) con recompensas intermedias. |
| **Problemas de organización** | Dificultad para planificar y priorizar. | **Estructura visual clara**: El mapa del Atlas muestra el progreso de forma visual y las misiones se organizan por prioridad. |

**Adaptaciones específicas**:
- **Modo TDAH**: Activa el modo concentración, reduce la duración de las misiones y añade pausas.
- **Feedback inmediato**: Las recompensas son frecuentes (cada paso completado) para mantener el engagement.
- **Recordatorios visuales**: El mapa muestra el progreso con barras de avance claras.

### 4.3. Dislexia

| Característica | Desafío | Adaptación en BehavioralOS |
|----------------|---------|----------------------------|
| **Dificultades de lectura** | Lectura lenta, confusión de letras, problemas de ortografía. | **Tipografía para dislexia**: Uso de OpenDyslexic o tipografía con formas diferenciadas. |
| **Fatiga visual** | Cansancio al leer textos largos. | **Textos cortos**: Resumir información, usar viñetas y listas. Opción de audio (narración). |
| **Problemas de comprensión** | Dificultad para entender instrucciones escritas. | **Instrucciones multimodales**: Texto + audio + imágenes. |

**Adaptaciones específicas**:
- **Modo Dislexia**: Activa la tipografía OpenDyslexic, aumenta el espaciado entre líneas y palabras, reduce el ancho de línea.
- **Narración automática**: Las instrucciones y textos clave se narran automáticamente (opcional).
- **Contraste mejorado**: Fondo de lectura con contraste suave (ej. papel amarillo).

### 4.4. Discapacidad Intelectual

| Característica | Desafío | Adaptación en BehavioralOS |
|----------------|---------|----------------------------|
| **Dificultad con conceptos abstractos** | Problemas para entender ideas complejas. | **Lenguaje concreto**: Usar ejemplos concretos, evitar jerga clínica. |
| **Tiempo de procesamiento más lento** | Necesidad de más tiempo para leer y comprender. | **Sin límites de tiempo**: Desactivar límites de tiempo en misiones y evaluaciones. |
| **Dificultad con tareas complejas** | Problemas para seguir instrucciones de varios pasos. | **Instrucciones paso a paso**: Cada misión se divide en pasos simples con instrucciones claras. |

**Adaptaciones específicas**:
- **Modo Simplificado**: Interfaz minimalista, solo los elementos esenciales.
- **Instrucciones paso a paso**: Cada paso se muestra individualmente, con botones "Siguiente" y "Anterior".
- **Feedback visual**: Recompensas visuales claras (ej. estrellas, checkmarks).

### 4.5. Daño Cerebral Adquirido (DCA)

| Característica | Desafío | Adaptación en BehavioralOS |
|----------------|---------|----------------------------|
| **Fatiga cognitiva** | Cansancio mental rápido. | **Misiones cortas**: Misiones de 3-5 minutos. Pausas sugeridas. |
| **Dificultades de memoria** | Problemas para recordar instrucciones o información. | **Repetición de instrucciones**: Las instrucciones se repiten al inicio y durante la misión. |
| **Problemas de atención** | Dificultad para mantener el enfoque. | **Modo concentración**: Reduce distracciones. |
| **Cambios emocionales** | Frustración, ansiedad. | **Tono calmado del TCCN**: Validación frecuente, evitación de lenguaje presionante. |

**Adaptaciones específicas**:
- **Modo DCA**: Activa misiones cortas, repetición de instrucciones y feedback calmado.
- **Pausas automáticas**: El sistema sugiere pausas cada 5 minutos.
- **Recordatorios de progreso**: El mapa del Atlas muestra el progreso visualmente para reducir la ansiedad.

---

## 5. Adaptaciones Sensoriales

### 5.1. Daltonismo

| Tipo | Desafío | Adaptación en BehavioralOS |
|------|---------|----------------------------|
| **Deuteranopía** (verde-rojo) | Dificultad para distinguir rojo y verde. | **Paleta adaptada**: Uso de colores azul y amarillo, además de rojo/verde. Patrones para gráficos. |
| **Protanopía** (rojo-verde) | Dificultad con rojo y verde. | **Paleta adaptada**: Similar a deuteranopía. |
| **Tritanopía** (azul-amarillo) | Dificultad con azul y amarillo. | **Paleta adaptada**: Uso de rojo y verde como sustitutos. |

**Adaptaciones específicas**:
- **Modo Daltonismo**: Aplica una paleta de colores adaptada (testeada con simuladores de daltonismo).
- **Patrones en gráficos**: Los gráficos clínicos (Hexaflex, redes RFT) utilizan patrones (líneas, puntos, etc.) además de colores.
- **Etiquetas textuales**: Los colores no son el único medio para transmitir información; se usan etiquetas textuales.

### 5.2. Baja Visión y Ceguera

| Característica | Desafío | Adaptación en BehavioralOS |
|----------------|---------|----------------------------|
| **Baja visión** | Dificultad para leer texto pequeño o ver detalles. | **Modo alto contraste**: Aumenta el contraste y el tamaño de fuente. |
| **Ceguera** | Incapacidad para ver la interfaz. | **Compatibilidad con lectores de pantalla**: ARIA, etiquetas, roles, estado. Navegación por teclado. |

**Adaptaciones específicas**:
- **Modo Alto Contraste**: Activa colores de alto contraste, tamaño de fuente grande, eliminación de fondos sutiles.
- **Textos alternativos**: Todas las imágenes, iconos y gráficos tienen texto alternativo descriptivo.
- **Etiquetas ARIA**: Todos los elementos interactivos tienen etiquetas ARIA y roles correctos.
- **Navegación por teclado**: Todas las funcionalidades son accesibles mediante teclado, con indicadores de foco visibles.
- **Compatibilidad con lectores de pantalla**: NVDA, VoiceOver, TalkBack.

### 5.3. Hipoacusia y Sordera

| Característica | Desafío | Adaptación en BehavioralOS |
|----------------|---------|----------------------------|
| **Hipoacusia** | Dificultad para escuchar audio. | **Subtítulos**: Todos los videos y audios tienen subtítulos. |
| **Sordera** | Incapacidad para escuchar. | **Transcripción completa**: Conversaciones con TCCN se muestran por texto. |

**Adaptaciones específicas**:
- **Subtítulos**: Todos los videos (psicoeducación, tutoriales) tienen subtítulos en español.
- **Transcripción en tiempo real**: Durante la videoterapia, la transcripción de la conversación se muestra en pantalla.
- **Alertas visuales**: Las notificaciones importantes (ej. "Nueva misión") se muestran visualmente, no solo con sonido.

### 5.4. Trastornos de Movimiento (Motricidad Fina)

| Característica | Desafío | Adaptación en BehavioralOS |
|----------------|---------|----------------------------|
| **Dificultades de motricidad fina** | Problemas para hacer clic en elementos pequeños o realizar gestos precisos. | **Botones grandes**: Área táctil amplia (≥ 44px). Espacio entre elementos. |
| **Temblores** | Movimientos involuntarios que dificultan el control. | **Tiempo de respuesta ampliado**: Mayor tiempo para completar tareas que requieren precisión. |
| **Uso de dispositivos asistivos** | Navegación con switch, puntero, etc. | **Compatibilidad con dispositivos asistivos**: Navegación por teclado, soporte para switch. |

**Adaptaciones específicas**:
- **Botones grandes**: Área de clic ≥ 44px, con espacio suficiente entre elementos.
- **Tiempo de respuesta ampliado**: En misiones que requieren precisión (ej. arrastrar objetos), el tiempo de respuesta se amplía.
- **Compatibilidad con switch**: La navegación es posible con switch (usando teclado como base).

---

## 6. Adaptaciones por Edad

### 6.1. Niños (6-12 años)

| Característica | Desafío | Adaptación en BehavioralOS |
|----------------|---------|----------------------------|
| **Desarrollo cognitivo** | Pensamiento concreto, dificultad con abstracciones. | **Metáforas visuales**: Conceptos como "defusión" se representan con globos, nubes, etc. |
| **Atención limitada** | Dificultad para mantener el enfoque por mucho tiempo. | **Misiones cortas**: 2-5 minutos. |
| **Lectura** | Lectura emergente. | **Textos cortos y grandes**: Frases simples, iconos grandes. |
| **Motricidad fina** | Aún en desarrollo. | **Botones grandes**: Área táctil ≥ 48px. |

**Adaptaciones específicas**:
- **Modo Niños**: Activa automáticamente textos grandes, iconos grandes, misiones cortas y lenguaje concreto.
- **Personajes y aventuras**: La narrativa es más lúdica, con personajes y mundos de fantasía.
- **Recompensas inmediatas**: Estrellas, confeti, badges.

### 6.2. Adolescentes (13-18 años)

| Característica | Desafío | Adaptación en BehavioralOS |
|----------------|---------|----------------------------|
| **Búsqueda de identidad** | Sensibilidad a la imagen social, necesidad de personalización. | **Personalización**: Avatares, temas visuales, personalización del compañero. |
| **Presión social** | Comparación con otros. | **Sin comparación social**: No hay leaderboards ni comparación con otros usuarios. |
| **Lenguaje** | Mayor capacidad de abstracción. | **Lenguaje más complejo**: Se pueden usar metáforas más sofisticadas. |
| **Impulsividad** | Mayor riesgo de impulsividad (TDAH). | **Pausas de reflexión**: En misiones importantes, pausas para reflexionar. |

**Adaptaciones específicas**:
- **Modo Adolescentes**: Activa la personalización y el lenguaje más sofisticado.
- **Referencias culturales**: Narrativas que conectan con la cultura juvenil (ej. redes sociales, música, etc.).
- **Control de autonomía**: El usuario puede elegir qué misiones hacer y en qué orden.

### 6.3. Adultos Mayores (65+ años)

| Característica | Desafío | Adaptación en BehavioralOS |
|----------------|---------|----------------------------|
| **Declive visual** | Dificultad para ver texto pequeño y detalles. | **Textos grandes**: Tamaño de fuente ≥ 18px. Alto contraste. |
| **Declive motor** | Movimientos más lentos, temblores. | **Botones grandes**: Área táctil ≥ 48px. Tiempo de respuesta ampliado. |
| **Declive cognitivo** | Memoria, velocidad de procesamiento más lenta. | **Instrucciones claras y repetidas**. Sin límites de tiempo. |
| **Familiaridad tecnológica** | Pueden tener menos experiencia con tecnología. | **Onboarding guiado**. Interfaz minimalista. |

**Adaptaciones específicas**:
- **Modo Adulto Mayor**: Activa textos grandes (≥ 18px), alto contraste, botones grandes (≥ 48px), sin límites de tiempo.
- **Onboarding guiado**: Tutoriales paso a paso con explicaciones claras y pausas.
- **Interfaz minimalista**: Solo los elementos esenciales, sin distracciones.

---

## 7. Integración con AHEE (Motor Adaptativo)

### 7.1. Variables de Adaptación

El AHEE (Adaptive Human Experience Engine) utiliza las siguientes variables para ajustar la accesibilidad en tiempo real:

| Variable | Fuente | Adaptación |
|----------|--------|------------|
| **Edad** | Perfil del usuario | Modo Niños, Adolescentes, Adulto Mayor. |
| **Diagnóstico funcional** | Behavioral Twin | Modo TEA, TDAH, Dislexia, etc. |
| **Estado emocional** | AAO (estimado) | Modo baja estimulación (si ansiedad alta), modo concentración (si fatiga). |
| **Nivel de fatiga** | Telemetría, EMA | Reducción de animaciones, misiones más cortas. |
| **Preferencias explícitas** | Configuración del usuario | Tema visual, tamaño de fuente, activación de narración, etc. |
| **Rendimiento en tareas** | BERL, jsPsych | Ajuste de dificultad visual (tamaño de elementos, colores). |
| **Dispositivo** | Detección automática | Adaptación para pantalla pequeña (móvil) vs. grande (desktop). |

### 7.2. Mecanismos de Cambio

| Cambio | Mecanismo | Disparador |
|--------|-----------|------------|
| **Tamaño de fuente** | Aumento/reducción de `font-size` en CSS. | Edad, preferencias explícitas. |
| **Contraste** | Cambio de paleta de colores (modo alto contraste). | Daltonismo, baja visión, preferencias. |
| **Animaciones** | Reducción o eliminación de animaciones (`prefers-reduced-motion`). | TEA, TDAH, fatiga, preferencias. |
| **Complejidad de la interfaz** | Ocultar/mostrar elementos no esenciales. | TDAH, discapacidad intelectual. |
| **Duración de misiones** | Ajuste de la duración de las misiones. | Edad, fatiga. |
| **Lenguaje** | Uso de lenguaje concreto vs. abstracto (a través del TCCN). | Edad, discapacidad intelectual. |
| **Narrativa** | Uso de metáforas visuales vs. textuales. | Edad, TEA. |
| **Tipografía** | Cambio a OpenDyslexic. | Dislexia. |

### 7.3. Implementación Técnica

- **CSS Variables**: Las variables de estilo (colores, tamaños, etc.) se controlan mediante CSS custom properties que AHEE modifica en tiempo real.
- **Contexto React**: El estado de accesibilidad se gestiona en el contexto global de React, permitiendo que todos los componentes reaccionen a los cambios.
- **Preferencias del usuario**: Se almacenan en la base de datos y se cargan al inicio de la sesión.
- **Detección automática**: El sistema detecta automáticamente el dispositivo y las preferencias del sistema operativo (ej. `prefers-reduced-motion`).

---

## 8. Estrategias de Implementación

### 8.1. HTML Semántico

- **Encabezados**: Uso correcto de `h1` a `h6` para jerarquía de contenido.
- **Navegación**: Uso de `<nav>` para menús de navegación.
- **Contenido principal**: Uso de `<main>` para el contenido principal de la página.
- **Secciones**: Uso de `<section>`, `<article>`, `<aside>` para organización.
- **Formularios**: Uso de `<label>` asociado a `<input>` mediante `for` e `id`.
- **Tablas**: Uso de `<caption>`, `<th>` con `scope` para tablas de datos.

### 8.2. ARIA (Accessible Rich Internet Applications)

| Atributo | Uso | Ejemplo |
|----------|-----|---------|
| `aria-label` | Proporciona una etiqueta accesible cuando no hay texto visible. | `<button aria-label="Cerrar modal">✕</button>` |
| `aria-labelledby` | Asocia un elemento a otro que actúa como etiqueta. | `<div role="dialog" aria-labelledby="modal-title">...</div>` |
| `aria-describedby` | Proporciona una descripción adicional. | `<input aria-describedby="email-help">` |
| `aria-required` | Indica que un campo es obligatorio. | `<input aria-required="true">` |
| `aria-invalid` | Indica que un campo tiene un error. | `<input aria-invalid="true">` |
| `aria-live` | Indica que el contenido se actualizará dinámicamente. | `<div aria-live="polite">` (para notificaciones). |
| `aria-atomic` | Indica que el contenido debe ser leído como un bloque. | `<div aria-live="assertive" aria-atomic="true">` |
| `role` | Define el rol de un elemento. | `<div role="button" tabindex="0">` |

### 8.3. Navegación por Teclado

- **Orden de foco lógico**: El orden de los elementos en el DOM debe seguir el orden visual.
- **Enlaces de "saltar"**: Un enlace visible o invisible al principio de la página para saltar al contenido principal.
- **Indicadores de foco visibles**: Los elementos enfocados deben tener un indicador visible (outline o cambio de color).
- **Atajos de teclado** (para el terapeuta): `Cmd+K` para búsqueda, `Cmd+1` a `Cmd+9` para navegación rápida.
- **Gestión de foco**: Al abrir modales, el foco se mueve al modal; al cerrar, vuelve al elemento que lo activó.

### 8.4. Textos Alternativos

- **Imágenes**: Todas las imágenes tienen un `alt` descriptivo (si son funcionales) o `alt=""` (si son decorativas).
- **Iconos**: Los iconos que transmiten información tienen un `aria-label` o un texto oculto con `sr-only`.
- **Gráficos**: Los gráficos clínicos (Hexaflex, etc.) tienen una descripción textual de los datos que representan.

### 8.5. Subtítulos y Transcripciones

- **Videos**: Todos los videos (psicoeducación, tutoriales) tienen subtítulos en español.
- **Audios**: Los audios (meditaciones, respiraciones) tienen transcripción textual.
- **Videoterapia**: Transcripción en tiempo real de la conversación (opcional).

---

## 9. Herramientas de Testing y Validación

### 9.1. Testing Automatizado

| Herramienta | Propósito | Integración |
|-------------|-----------|-------------|
| **axe-core** | Pruebas automáticas de accesibilidad WCAG. | Integrado en las pruebas unitarias y de integración (BQAS). |
| **Lighthouse** | Auditoría de accesibilidad en el navegador. | Ejecutado en CI/CD para cada despliegue. |
| **Pa11y** | Pruebas de accesibilidad en línea de comandos. | Usado en el pipeline de CI/CD. |
| **Jest + axe-core** | Pruebas unitarias con validación de accesibilidad. | Para cada componente React. |

### 9.2. Testing Manual

| Herramienta | Propósito | Frecuencia |
|-------------|-----------|------------|
| **NVDA** | Lector de pantalla para Windows. | Pruebas manuales en cada sprint. |
| **VoiceOver** | Lector de pantalla para Mac/iOS. | Pruebas manuales en cada sprint. |
| **TalkBack** | Lector de pantalla para Android. | Pruebas manuales en cada sprint. |
| **Simuladores de daltonismo** | Chrome DevTools, Colorblindly. | Pruebas manuales en cada sprint. |
| **Navegación por teclado** | Solo teclado (sin mouse). | Pruebas manuales en cada sprint. |

### 9.3. Pruebas con Usuarios

- **Usuarios con discapacidades**: Pruebas de usabilidad con personas con discapacidades visuales, motoras, cognitivas y sensoriales.
- **Adultos mayores**: Pruebas con usuarios de 65+ años.
- **Niños**: Pruebas con niños de 6-12 años.

---

## 10. Criterios de Validación y Cumplimiento

| Criterio | Objetivo | Herramienta |
|----------|----------|-------------|
| **Conformidad WCAG 2.1 AA** | 100% de criterios AA cumplidos. | axe-core, Lighthouse. |
| **Conformidad WCAG 2.1 AAA** | ≥ 90% de criterios AAA cumplidos (cuando sea aplicable). | axe-core, Lighthouse. |
| **Compatibilidad con lectores de pantalla** | Todas las funcionalidades son accesibles con NVDA, VoiceOver, TalkBack. | Pruebas manuales. |
| **Navegación por teclado** | 100% de las funcionalidades accesibles con teclado. | Pruebas manuales. |
| **Contraste de color** | Relación de contraste ≥ 4.5:1 para texto normal, ≥ 3:1 para texto grande. | axe-core, Lighthouse. |
| **Texto alternativo** | 100% de imágenes y gráficos tienen texto alternativo. | axe-core. |
| **Subtítulos** | 100% de videos tienen subtítulos. | Revisión manual. |
| **Tiempo de respuesta** | Sin límites de tiempo obligatorios (o con opción de desactivarlos). | Pruebas manuales. |
| **Adaptaciones AHEE** | Las adaptaciones se activan correctamente según las variables de entrada. | Pruebas de integración. |

---

## 11. El Manifiesto de la Accesibilidad

> *"La accesibilidad no es un requisito que cumplir. Es una oportunidad para diseñar mejor.*
>
> *Cuando diseñamos para personas con discapacidad visual, mejoramos el contraste para todos.*
> *Cuando diseñamos para personas con TEA, simplificamos la interfaz para todos.*
> *Cuando diseñamos para personas con dislexia, hacemos el lenguaje más claro para todos.*
> *Diseñar para la diversidad humana es diseñar para la excelencia.*
>
> *El BehavioralOS existe para ayudar a las personas a desarrollar habilidades psicológicas. Eso solo es posible si todas las personas, independientemente de sus capacidades, pueden acceder a la plataforma.*
>
> *La accesibilidad es un derecho. Y es nuestra responsabilidad garantizarlo."*

---

## 12. Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2026-07-01 | Diseño UX/UI | Creación del documento. Definición de principios de accesibilidad, WCAG 2.1 AA/AAA, adaptaciones cognitivas (TEA, TDAH, dislexia, etc.), adaptaciones sensoriales, adaptaciones por edad, integración con AHEE, estrategias de implementación, herramientas de testing y criterios de validación. |

---

**Fin del documento `accessibility.md`**