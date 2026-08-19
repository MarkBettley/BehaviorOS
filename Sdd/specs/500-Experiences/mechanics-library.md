---
id: BML-001
title: Behavioral Mechanics Library (BML)
version: 2.0.0
status: Stable
owner: "Diseño de Juegos & Psicología Clínica"
last_updated: 2026-07-14
depends_on:
  - 000-Core/ontology.md (Ontología - procesos)
  - 000-Core/bpo.md (BPO - ontología de procesos computacional)
  - 000-Core/bpg.md (BPG - grafo de procesos del paciente)
  - 500-Experiencies/experience-engine.md (BERL v2.0.0 - genoma)
  - 500-Experiencies/process-engine.md (Motor de procesos v2.0.0)
  - 100-Architecture/behavioral-twin.md (Behavioral Twin - perfil del usuario)
  - 500-Experiencies/ideographic-game-engine.md (Motor de juegos ideográficos 3D)
  - 000-Infrastructure/selection.md (Infraestructura - Godot gratuito)
exports:
  - Catálogo completo de mecánicas (≈40-60) organizadas por PROCESO
  - Estructura de cada mecánica (nombre, familia, procesos, niveles, afinidades)
  - Familias de mecánicas (7 familias)
  - Afinidades y combinaciones entre mecánicas
  - Niveles de profundidad de cada mecánica
  - Mecánicas 3D (balloon burst, resistance shield, Pikmin missions)
  - Mecánicas diádicas, familiares y grupales
  - Integración con BERL v2.0.0, BPO, BPG y motor de procesos
  - Criterios de validación
used_by:
  - BERL v2.0.0 (diseño de ejercicios)
  - Process Engine v2.0.0 (mapeo a procesos)
  - Experience Composer (construcción de experiencias)
  - AHEE (adaptación de dificultad por mecánica)
  - Ideographic Game Engine (generación dinámica de minijuegos)
  - BML Registry (catálogo versionado)
---

# BehavioralOS – Behavioral Mechanics Library (BML) v2.0.0

> *"Las mecánicas no son solo interacciones. Son el alfabeto del cambio conductual. Cada mecánica es una unidad de aprendizaje que, combinada con otras, puede construir experiencias terapéuticas completas. Como Nintendo, no diseñamos niveles; diseñamos mecánicas. Los niveles emergen de su combinación. Desde v2.0.0, cada mecánica mapea explícitamente a procesos del BPO, y existen mecánicas 3D y de interacción multi-nivel (diádica, familiar, grupal)."*

---

## Cambios v2.0.0 (Resumen)

| Aspecto | v1.0.0 | v2.0.0 |
|---------|--------|--------|
| **Organización** | Por familias (7 familias) | **Por familias + mapeo explícito a procesos BPO** |
| **Fuente de verdad** | Procesos genéricos | **UUID de procesos BPO** |
| **Mecánicas 3D** | Sin soporte | **Balloon Burst, Resistance Shield, Pikmin Missions, River Float** |
| **Interacción multi-nivel** | Individual únicamente | **Individual, diádico, familiar, grupal** |
| **Integración BPG** | Sin soporte | **Cada mecánica declara su impacto en procesos del BPG** |
| **Mecánicas sociales** | 6 mecánicas básicas | **8+ mecánicas con soporte Gottman/TIP/FAP** |
| **Mecánicas familiares** | Sin soporte | **Cooperativas, de cohesión, de roles** |

---

## 1. Propósito y Alcance

### 1.1. Propósito
Este documento define la **Behavioral Mechanics Library (BML) v2.0.0**, el catálogo universal de mecánicas de juego del BehavioralOS. Su objetivo es:

- **Proveer un lenguaje común** para diseñar ejercicios terapéuticos gamificados.
- **Garantizar la reutilización** de mecánicas en múltiples ejercicios (como LEGO).
- **Asegurar la conexión** entre cada mecánica y los procesos psicológicos del BPO que entrena.
- **Facilitar la adaptación** (AHEE) ajustando el nivel de profundidad de cada mecánica.
- **Inspirar la creatividad** de los diseñadores al ofrecer un vocabulario estructurado.
- **Soportar mecánicas 3D** para el Ideographic Game Engine (balloon burst, resistance shield, Pikmin).
- **Soportar interacción multi-nivel** (diádica, familiar, grupal).

### 1.2. Alcance
El documento cubre:

- **Estructura de una mecánica**: Nombre, familia, descripción, procesos BPO (UUID), niveles, afinidades, variantes, ejemplos.
- **Las 7 familias de mecánicas**: Exploración, Conciencia, Flexibilidad, Acción, Regulación, Sociales, Integración.
- **Catálogo detallado** de 40+ mecánicas con mapeo a procesos BPO.
- **Mecánicas 3D**: Balloon Burst (defusión), Resistance Shield (aceptación), Pikmin Missions (acción comprometida), River Float (defusión pasiva).
- **Mecánicas multi-nivel**: Diádicas (pareja), familiares y grupales.
- **Afinidades y combinaciones**: Cómo se combinan las mecánicas para crear ejercicios.
- **Niveles de profundidad**: Cada mecánica tiene niveles de dificultad/profundidad (1-5).
- **Integración con el ecosistema**: Conexión con BERL v2.0.0, BPO, BPG, motor de procesos e Ideographic Game Engine.
- **Criterios de validación**: Métricas de calidad para las mecánicas.

### 1.3. Principio Fundamental
> **"Una mecánica no es un botón. Es una oportunidad de aprendizaje. Cada interacción debe entrenar un proceso psicológico específico del BPO, y cada nivel de profundidad debe aumentar el desafío sin romper el flow del usuario. Las mecánicas 3D deben sentirse como un videojuego de Nintendo, no como una tarea clínica."**

---

## 2. Filosofía de las Mecánicas

### 2.1. Inspiración en Nintendo

| Principio Nintendo | Aplicación en BML v2.0.0 |
|-------------------|--------------------------|
| **Una buena mecánica puede sostener cientos de niveles.** | Una mecánica como "Observar" puede usarse en defusión, mindfulness, y FAP. |
| **El verbo principal define el juego.** | Nuestros verbos principales son: Observar, Elegir, Acercarse, Soltar, Construir, Conectar, Persistir. |
| **El aprendizaje es orgánico.** | Los niveles de profundidad permiten que el usuario aprenda la mecánica gradualmente. |
| **La curiosidad es el motor.** | Las mecánicas están diseñadas para despertar curiosidad, no para ser instrucciones. |
| **El 3D inmersivo engancha.** | Mecánicas como balloon burst y resistance shield usan Three.js para crear experiencias viscerales. |

### 2.2. Principios de Diseño de Mecánicas

| # | Principio | Descripción | Manifestación |
|---|-----------|-------------|---------------|
| 1 | **Psicológicamente fundamentada** | Cada mecánica mapea a procesos del BPO con UUID explícito. | Mapeo a BPO-CTX-000032 (Defusión), no solo "defusión" como string. |
| 2 | **Reutilizable** | Una mecánica debe poder usarse en múltiples contextos y ejercicios. | Una mecánica como "Elegir" puede usarse en Valores, Exposición, y FAP. |
| 3 | **Escalable** | Cada mecánica tiene niveles de profundidad para adaptarse a diferentes habilidades. | Nivel 1: Detectar una emoción. Nivel 5: Discriminar función. |
| 4 | **Intuitiva** | La mecánica debe ser comprensible sin instrucciones extensas. | Aprendizaje por exploración (como en Mario). |
| 5 | **Feedback inmediato** | Cada interacción debe producir una respuesta (visual, auditiva, háptica). | Feedback visual en cada paso. En 3D: partículas, sonidos, vibración. |
| 6 | **Combinable** | Las mecánicas deben poder combinarse para crear experiencias complejas. | Observar + Comparar + Elegir = Discriminación contextual. |
| 7 | **Impacto en BPG** | Cada mecánica declara qué procesos del BPG modifica y en qué dirección. | "Estallar globos" → reduce Fusión Cognitiva, aumenta Aceptación. |
| 8 | **Multi-nivel** | Las mecánicas deben funcionar en individual, diádico, familiar y grupal. | "Escuchar" funciona individualmente y en pareja. |

### 2.3. Estructura de una Mecánica (v2.0.0)

| Campo | Descripción | Obligatorio |
|-------|-------------|-------------|
| `id` | Identificador único (ej. MEC-001). | Sí |
| `name` | Nombre de la mecánica (ej. "Observar"). | Sí |
| `family` | Familia a la que pertenece (ej. "Exploración"). | Sí |
| `description` | Descripción breve (máx. 100 caracteres). | Sí |
| `long_description` | Descripción detallada y fundamento. | Recomendado |
| `processes` | **Lista de procesos BPO (UUID + nombre) que entrena.** | **Sí (v2.0.0)** |
| `levels` | Niveles de profundidad (1-5) con descripción. | Recomendado |
| `variants` | Variantes de la mecánica (ej. visual, auditiva, **3D**). | Opcional |
| `affinities` | Mecánicas con las que combina bien. | Recomendado |
| `incompatibilities` | Mecánicas con las que no combina bien. | Opcional |
| `examples` | Ejemplos de uso en ejercicios. | Recomendado |
| `user_experience` | Cómo se siente la mecánica para el usuario. | Recomendado |
| `cognitive_load` | Carga cognitiva estimada (1-5). | Recomendado |
| `interaction_levels` | **Niveles de interacción: individual, diadico, familiar, grupal.** | **Recomendado (v2.0.0)** |
| `bpg_impact` | **Procesos del BPG que modifica y dirección (+/-).** | **Recomendado (v2.0.0)** |
| `3d_implementation` | **Nombre de la escena/mejicánica 3D en Three.js (si aplica).** | **Opcional (v2.0.0)** |

---

## 3. Las 7 Familias de Mecánicas

| # | Familia | Descripción | Ejemplos | Procesos BPO típicos |
|---|---------|-------------|----------|----------------------|
| 1 | **Exploración** | Obtener información, detectar patrones. | Observar, Detectar, Comparar, Clasificar, Identificar, Explorar, Registrar, Localizar. | Flexibilidad atencional, Discriminación, Conciencia. |
| 2 | **Conciencia** | Contacto con la experiencia presente. | Observar sin intervenir, Describir, Etiquetar, Respirar, Escaneo, Diferenciar, Contacto sensorial. | Mindfulness, Atención flexible, Desfusión. |
| 3 | **Flexibilidad** | Modificar la relación con eventos privados. | Renombrar, Cambiar perspectiva, Repetición, Metáforas, Yo como contexto, Distanciamiento, Cambio de marco. | Defusión, Aceptación, Perspectiva. |
| 4 | **Acción** | Comportamiento observable guiado por valores. | Elegir, Acercarse, Permanecer, Iniciar, Continuar, Persistir, Romper evitación, Acción opuesta, Microacción, Exposición. | Acción comprometida, Activación conductual, Exposición. |
| 5 | **Regulación** | Modificar la interacción con emociones y sensaciones. | Respirar, TIPP, Relajación, Pausa, Ritmo, Autocompasión, Validación, Aceptación, Descanso. | Regulación emocional, Tolerancia al malestar, Autocompasión. |
| 6 | **Sociales** | Interacciones interpersonales. | Escuchar, Validar, Pedir, Negociar, Compartir, Rechazar, Agradecer, Reparar, Conversación difícil, Vulnerabilidad, Feedback, DEAR MAN, GIVE, FAST. | Conexión social, Asertividad, Validación. |
| 7 | **Integración** | Consolidar el aprendizaje y generalizar. | Reflexionar, Generalizar, Extraer principios, Comparar experiencias, Revisar hipótesis, Actualizar el Atlas, Registrar descubrimientos, Conectar con valores, Planificar. | Generalización, Transferencia, Mantenimiento. |

---

## 4. Catálogo Detallado de Mecánicas (v2.0.0 — por proceso BPO)

Los ejercicios ahora se organizan **por familia**, pero cada mecánica declara sus procesos BPO. Se incluyen las mecánicas 3D y multi-nivel.

### 4.1. Familia 1: Exploración

#### MEC-001: Observar

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-001 |
| **Nombre** | Observar |
| **Familia** | Exploración |
| **Descripción** | Notar y registrar estímulos o eventos. |
| **Procesos BPO** | BPO-CTX-000034 (Contacto con el Presente), BPO-CTX-000032 (Defusión Cognitiva), BPO-CTX-000010 (Atención Flexible) |
| **Niveles** | 1. Detectar una sensación. 2. Detectar una emoción. 3. Detectar pensamiento + emoción. 4. Detectar antecedente + emoción + conducta. 5. Detectar función. |
| **Variantes** | Visual, Auditiva, Táctil, Olfativa, Gustativa, Interoceptiva, **3D (bosque de hojas)**. |
| **Afinidades** | Describir, Comparar, Diferenciar. |
| **Incompatibilidades** | Ninguna. |
| **Ejemplos** | "El Bosque de la Incertidumbre": Observar pensamientos como hojas. |
| **User Experience** | Curiosidad, calma, descubrimiento. |
| **Cognitive Load** | 2/5 |
| **Interaction Levels** | Individual, Diádico, Familiar, Grupal |
| **BPG Impact** | +Contacto con el Presente, +Defusión Cognitiva |

#### MEC-002: Detectar

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-002 |
| **Nombre** | Detectar |
| **Familia** | Exploración |
| **Descripción** | Identificar la presencia de un estímulo o patrón específico. |
| **Procesos BPO** | BPO-CTX-000010 (Atención Flexible), BPO-NEU-000001 (Atención Selectiva), BPO-CTX-000032 (Defusión Cognitiva) |
| **Niveles** | 1. Detectar un estímulo simple. 2. Detectar un patrón. 3. Detectar un cambio en el patrón. 4. Detectar un patrón en contexto. 5. Detectar la función del patrón. |
| **Variantes** | Visual, Auditiva, Interoceptiva. |
| **Afinidades** | Observar, Comparar, Clasificar. |
| **Ejemplos** | "El Faro del Equilibrio": Detectar cambios en la respiración. |
| **User Experience** | Curiosidad, alerta, logro. |
| **Cognitive Load** | 3/5 |
| **Interaction Levels** | Individual, Diádico, Grupal |
| **BPG Impact** | +Atención Flexible, +Defusión Cognitiva |

#### MEC-003: Comparar

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-003 |
| **Nombre** | Comparar |
| **Familia** | Exploración |
| **Descripción** | Contrastar dos o más estímulos o eventos. |
| **Procesos BPO** | BPO-NEU-000003 (Flexibilidad Cognitiva), BPO-CTX-000040 (Metacognición), BPO-CTX-000011 (Discriminación) |
| **Niveles** | 1. Comparar dos estímulos simples. 2. Comparar dos emociones. 3. Comparar pensamiento y emoción. 4. Comparar antecedentes. 5. Comparar funciones. |
| **Variantes** | Visual, Auditiva, Textual. |
| **Afinidades** | Observar, Clasificar, Identificar. |
| **Ejemplos** | "La Montaña de los Valores": Comparar acciones alineadas vs. no alineadas con valores. |
| **User Experience** | Curiosidad, reflexión, claridad. |
| **Cognitive Load** | 3/5 |
| **Interaction Levels** | Individual, Diádico, Familiar |
| **BPG Impact** | +Flexibilidad Cognitiva, +Metacognición |

#### MEC-004: Clasificar

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-004 |
| **Nombre** | Clasificar |
| **Familia** | Exploración |
| **Descripción** | Agrupar estímulos o eventos según criterios. |
| **Procesos BPO** | BPO-CTX-000011 (Discriminación), BPO-NEU-000003 (Flexibilidad Cognitiva), BPO-CTX-000041 (Organización) |
| **Niveles** | 1. Clasificar por atributo simple. 2. Clasificar por categoría. 3. Clasificar según contexto. 4. Clasificar según función. 5. Clasificar según valor. |
| **Variantes** | Visual, Auditiva, Textual. |
| **Afinidades** | Observar, Comparar, Identificar. |
| **Ejemplos** | "El Laberinto de la Aceptación": Clasificar pensamientos como útiles o no útiles. |
| **User Experience** | Orden, claridad, logro. |
| **Cognitive Load** | 3/5 |
| **Interaction Levels** | Individual, Familiar, Grupal |
| **BPG Impact** | +Discriminación, +Flexibilidad Cognitiva |

#### MEC-005: Identificar Patrones

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-005 |
| **Nombre** | Identificar Patrones |
| **Familia** | Exploración |
| **Descripción** | Reconocer regularidades en el comportamiento o en el contexto. |
| **Procesos BPO** | BPO-CTX-000040 (Metacognición), BPO-CON-000005 (Análisis Funcional), BPO-CTX-000042 (Planeación) |
| **Niveles** | 1. Identificar un patrón simple. 2. Identificar un patrón con contexto. 3. Identificar la función del patrón. 4. Identificar patrones alternativos. 5. Identificar patrones de generalización. |
| **Variantes** | Visual, Auditiva, Textual. |
| **Afinidades** | Observar, Detectar, Comparar. |
| **Ejemplos** | "La Expedición de la Flexibilidad": Identificar patrones de evitación. |
| **User Experience** | Descubrimiento, insight, empoderamiento. |
| **Cognitive Load** | 4/5 |
| **Interaction Levels** | Individual, Diádico, Familiar |
| **BPG Impact** | +Metacognición, +Análisis Funcional |

#### MEC-006: Explorar

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-006 |
| **Nombre** | Explorar |
| **Familia** | Exploración |
| **Descripción** | Investigar un entorno o situación sin juicio previo. |
| **Procesos BPO** | BPO-CTX-000034 (Contacto con el Presente), BPO-CTX-000033 (Apertura), BPO-CTX-000010 (Atención Flexible) |
| **Niveles** | 1. Explorar un entorno simple. 2. Explorar un entorno con variables. 3. Explorar un entorno con incertidumbre. 4. Explorar un entorno emocional. 5. Explorar un entorno social. |
| **Variantes** | Virtual (Godot/Three.js), Narrativa, Guiada. |
| **Afinidades** | Observar, Detectar, Comparar. |
| **Ejemplos** | "El Mapa del Momento Presente": Explorar una isla virtual mientras se practica mindfulness. |
| **User Experience** | Aventura, descubrimiento, curiosidad. |
| **Cognitive Load** | 3/5 |
| **Interaction Levels** | Individual, Familiar, Grupal |
| **BPG Impact** | +Contacto con el Presente, +Apertura |

---

### 4.2. Familia 2: Conciencia

#### MEC-007: Observar sin Intervenir

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-007 |
| **Nombre** | Observar sin Intervenir |
| **Familia** | Conciencia |
| **Descripción** | Notar estímulos sin intentar cambiarlos. |
| **Procesos BPO** | BPO-CTX-000034 (Contacto con el Presente), BPO-CTX-000031 (Aceptación), BPO-CTX-000032 (Defusión Cognitiva) |
| **Niveles** | 1. Observar una sensación. 2. Observar una emoción. 3. Observar un pensamiento. 4. Observar la interacción entre emociones y pensamientos. 5. Observar sin juicio durante un período prolongado. |
| **Variantes** | Visual, Auditiva, Interoceptiva. |
| **Afinidades** | Describir, Respirar, Etiquetar. |
| **Ejemplos** | "El Bosque de la Incertidumbre": Observar pensamientos como hojas sin aferrarse a ellas. |
| **User Experience** | Calma, aceptación, presencia. |
| **Cognitive Load** | 2/5 |
| **Interaction Levels** | Individual, Diádico, Familiar, Grupal |
| **BPG Impact** | +Aceptación, +Defusión Cognitiva |

#### MEC-008: Describir

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-008 |
| **Nombre** | Describir |
| **Familia** | Conciencia |
| **Descripción** | Nombrar verbalmente o por escrito un estímulo o evento. |
| **Procesos BPO** | BPO-CTX-000034 (Contacto con el Presente), BPO-CTX-000032 (Defusión Cognitiva), BPO-CTX-000040 (Metacognición) |
| **Niveles** | 1. Describir una sensación. 2. Describir una emoción. 3. Describir un pensamiento. 4. Describir la relación entre pensamiento y emoción. 5. Describir la función de un patrón. |
| **Variantes** | Escrita, Hablada, Táctil. |
| **Afinidades** | Observar, Etiquetar, Reflexionar. |
| **Ejemplos** | "El Diario del Explorador": Describir una emoción después de una misión. |
| **User Experience** | Claridad, organización, conciencia. |
| **Cognitive Load** | 3/5 |
| **Interaction Levels** | Individual, Diádico, Familiar |
| **BPG Impact** | +Defusión Cognitiva, +Metacognición |

#### MEC-009: Etiquetar

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-009 |
| **Nombre** | Etiquetar |
| **Familia** | Conciencia |
| **Descripción** | Asignar una palabra o categoría a un estímulo o evento. |
| **Procesos BPO** | BPO-CTX-000032 (Defusión Cognitiva), BPO-CTX-000034 (Contacto con el Presente), BPO-EMO-000004 (Regulación Emocional) |
| **Niveles** | 1. Etiquetar una emoción. 2. Etiquetar un pensamiento. 3. Etiquetar una sensación. 4. Etiquetar una combinación de emociones y pensamientos. 5. Etiquetar un patrón funcional. |
| **Variantes** | Visual, Auditiva, Textual. |
| **Afinidades** | Observar, Describir, Clasificar. |
| **Ejemplos** | "El Mapa de las Emociones": Etiquetar emociones en una ruleta. |
| **User Experience** | Claridad, control, comprensión. |
| **Cognitive Load** | 2/5 |
| **Interaction Levels** | Individual, Familiar, Grupal |
| **BPG Impact** | +Defusión Cognitiva, +Regulación Emocional |

#### MEC-010: Respirar

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-010 |
| **Nombre** | Respirar |
| **Familia** | Conciencia |
| **Descripción** | Prestar atención consciente a la respiración. |
| **Procesos BPO** | BPO-EMO-000004 (Regulación Emocional), BPO-CTX-000034 (Contacto con el Presente), BPO-EMO-000007 (Tolerancia al Malestar) |
| **Niveles** | 1. Respirar con guía de 3 segundos. 2. Respirar con guía de 10 segundos. 3. Respirar sin guía, 1 minuto. 4. Respirar en contexto de estrés. 5. Respirar como ancla en situaciones difíciles. |
| **Variantes** | Guiada, Visual (animación), Sonora (tono), **3D (respiración sincronizada con Three.js)**. |
| **Afinidades** | Observar, Pausar, Permanecer. |
| **Ejemplos** | "El Faro del Equilibrio": Ejercicio de respiración 4-7-8. |
| **User Experience** | Calma, equilibrio, presencia. |
| **Cognitive Load** | 1/5 |
| **Interaction Levels** | Individual, Diádico, Familiar, Grupal |
| **BPG Impact** | +Regulación Emocional, +Tolerancia al Malestar |

#### MEC-011: Escaneo Corporal

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-011 |
| **Nombre** | Escaneo Corporal |
| **Familia** | Conciencia |
| **Descripción** | Dirigir la atención sistemáticamente a diferentes partes del cuerpo. |
| **Procesos BPO** | BPO-CTX-000034 (Contacto con el Presente), BPO-EMO-000004 (Regulación Emocional), BPO-FIS-000003 (Conciencia Corporal) |
| **Niveles** | 1. Escaneo de 3 zonas. 2. Escaneo detallado de 10 zonas. 3. Escaneo con identificación de sensaciones. 4. Escaneo en contexto de malestar. 5. Escaneo como práctica diaria. |
| **Variantes** | Guiada, Autónoma. |
| **Afinidades** | Observar, Respirar, Relajación. |
| **Ejemplos** | "El Mapa del Momento Presente": Escaneo corporal guiado. |
| **User Experience** | Conexión corporal, calma, presencia. |
| **Cognitive Load** | 2/5 |
| **Interaction Levels** | Individual, Familiar |
| **BPG Impact** | +Contacto con el Presente, +Regulación Emocional |

#### MEC-012: Contacto Sensorial

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-012 |
| **Nombre** | Contacto Sensorial |
| **Familia** | Conciencia |
| **Descripción** | Conectar con los cinco sentidos en el momento presente. |
| **Procesos BPO** | BPO-CTX-000034 (Contacto con el Presente), BPO-CTX-000031 (Aceptación), BPO-EMO-000004 (Regulación Emocional) |
| **Niveles** | 1. Contactar con un sentido. 2. Contactar con dos sentidos. 3. Contactar con tres sentidos en contexto. 4. Contactar con sentidos en situación de malestar. 5. Contactar como práctica de anclaje. |
| **Variantes** | Visual, Auditiva, Táctil, Olfativa, Gustativa. |
| **Afinidades** | Observar, Respirar, Pausar. |
| **Ejemplos** | "El Faro del Equilibrio": Ejercicio 5-4-3-2-1. |
| **User Experience** | Conexión, presencia, calma. |
| **Cognitive Load** | 2/5 |
| **Interaction Levels** | Individual, Diádico, Familiar |
| **BPG Impact** | +Contacto con el Presente, +Aceptación |

---

### 4.3. Familia 3: Flexibilidad

#### MEC-013: Renombrar

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-013 |
| **Nombre** | Renombrar |
| **Familia** | Flexibilidad |
| **Descripción** | Cambiar la etiqueta verbal de un pensamiento o evento. |
| **Procesos BPO** | BPO-CTX-000032 (Defusión Cognitiva), BPO-NEU-000003 (Flexibilidad Cognitiva), BPO-CTX-000035 (Perspectiva de Contexto) |
| **Niveles** | 1. Renombrar una emoción. 2. Renombrar un pensamiento. 3. Renombrar un patrón. 4. Renombrar una situación. 5. Renombrar la identidad de uno mismo. |
| **Variantes** | Verbal, Escrita, Visual. |
| **Afinidades** | Describir, Etiquetar, Distanciamiento. |
| **Ejemplos** | "El Espejo de la Autocompasión": Renombrar un pensamiento autocrítico como "una historia que me cuento". |
| **User Experience** | Liberación, perspectiva, alivio. |
| **Cognitive Load** | 3/5 |
| **Interaction Levels** | Individual, Diádico, Familiar |
| **BPG Impact** | +Defusión Cognitiva, +Flexibilidad Cognitiva |

#### MEC-014: Cambiar Perspectiva

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-014 |
| **Nombre** | Cambiar Perspectiva |
| **Familia** | Flexibilidad |
| **Descripción** | Adoptar un punto de vista alternativo. |
| **Procesos BPO** | BPO-NEU-000003 (Flexibilidad Cognitiva), BPO-CTX-000035 (Perspectiva de Contexto), BPO-CTX-000039 (Autocompasión) |
| **Niveles** | 1. Cambiar perspectiva desde uno mismo a otro. 2. Cambiar perspectiva desde el presente al futuro. 3. Cambiar perspectiva desde el pasado al presente. 4. Cambiar perspectiva a un observador compasivo. 5. Cambiar perspectiva contextual. |
| **Variantes** | Visual, Narrativa, Guiada, **3D (cámara en tercera persona)**. |
| **Afinidades** | Distanciamiento, Renombrar, Reflexionar. |
| **Ejemplos** | "El Espejo de la Autocompasión": Ver una situación desde la perspectiva de un amigo compasivo. |
| **User Experience** | Compasión, comprensión, alivio. |
| **Cognitive Load** | 3/5 |
| **Interaction Levels** | Individual, Diádico, Familiar |
| **BPG Impact** | +Flexibilidad Cognitiva, +Perspectiva de Contexto |

#### MEC-015: Repetición Semántica

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-015 |
| **Nombre** | Repetición Semántica |
| **Familia** | Flexibilidad |
| **Descripción** | Repetir una palabra o frase hasta que pierda su significado. |
| **Procesos BPO** | BPO-CTX-000032 (Defusión Cognitiva), BPO-NEU-000003 (Flexibilidad Cognitiva) |
| **Niveles** | 1. Repetir una palabra simple (10 veces). 2. Repetir una palabra con carga emocional. 3. Repetir una frase autocrítica. 4. Repetir una frase en contexto de malestar. 5. Repetir una palabra y cambiar el tono. |
| **Variantes** | Verbal, Escrita. |
| **Afinidades** | Observar, Renombrar, Distanciamiento. |
| **Ejemplos** | "El Bosque de la Incertidumbre": Repetir "fracaso" hasta que pierda su poder. |
| **User Experience** | Liberación, distanciamiento, humor. |
| **Cognitive Load** | 2/5 |
| **Interaction Levels** | Individual, Familiar |
| **BPG Impact** | +Defusión Cognitiva |

#### MEC-016: Distanciamiento

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-016 |
| **Nombre** | Distanciamiento |
| **Familia** | Flexibilidad |
| **Descripción** | Crear distancia psicológica de un pensamiento o emoción. |
| **Procesos BPO** | BPO-CTX-000032 (Defusión Cognitiva), BPO-CTX-000039 (Autocompasión), BPO-CTX-000035 (Perspectiva de Contexto) |
| **Niveles** | 1. Visualizar un pensamiento como una nube. 2. Visualizar un pensamiento como un objeto externo. 3. Visualizar un pensamiento como una película. 4. Visualizar un pensamiento en una pantalla. 5. Visualizar un pensamiento como parte de un paisaje. |
| **Variantes** | Visual, Narrativa, Guiada, **3D (pensamiento como objeto flotante)**. |
| **Afinidades** | Observar, Renombrar, Cambiar Perspectiva. |
| **Ejemplos** | "El Bosque de la Incertidumbre": Pensamientos como hojas en un río. |
| **User Experience** | Libertad, perspectiva, alivio. |
| **Cognitive Load** | 3/5 |
| **Interaction Levels** | Individual, Diádico, Familiar |
| **BPG Impact** | +Defusión Cognitiva, +Autocompasión |

#### MEC-017: Yo como Contexto

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-017 |
| **Nombre** | Yo como Contexto |
| **Familia** | Flexibilidad |
| **Descripción** | Experimentar el "yo" como el contenedor de la experiencia, no como el contenido. |
| **Procesos BPO** | BPO-CTX-000036 (Yo como Contexto), BPO-CTX-000032 (Defusión Cognitiva), BPO-CTX-000010 (Atención Flexible) |
| **Niveles** | 1. Identificar sensaciones corporales. 2. Identificar emociones. 3. Identificar pensamientos como eventos. 4. Diferenciar entre el "yo observador" y el "yo pensante". 5. Practicar el yo como contexto en situaciones difíciles. |
| **Variantes** | Guiada, Narrativa, Meditativa. |
| **Afinidades** | Observar, Describir, Distanciamiento. |
| **Ejemplos** | "El Mapa del Momento Presente": Práctica de "yo soy la conciencia que observa". |
| **User Experience** | Expansión, libertad, presencia. |
| **Cognitive Load** | 4/5 |
| **Interaction Levels** | Individual, Diádico |
| **BPG Impact** | +Yo como Contexto, +Defusión Cognitiva |

#### MEC-018: Metáfora Interactiva

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-018 |
| **Nombre** | Metáfora Interactiva |
| **Familia** | Flexibilidad |
| **Descripción** | Usar una metáfora como herramienta de exploración conductual. |
| **Procesos BPO** | BPO-CTX-000032 (Defusión Cognitiva), BPO-CTX-000031 (Aceptación), BPO-CTX-000037 (Clarificación de Valores), BPO-CTX-000035 (Perspectiva de Contexto) |
| **Niveles** | 1. Explorar una metáfora simple. 2. Explorar una metáfora compleja. 3. Interactuar con una metáfora gamificada. 4. Crear una metáfora personalizada. 5. Aplicar la metáfora a situaciones de la vida real. |
| **Variantes** | Visual, Narrativa, **Gamificada (Three.js 3D)**. |
| **Afinidades** | Observar, Reflexionar, Generalizar. |
| **Ejemplos** | "El Bosque de la Incertidumbre": Metáfora de las hojas. |
| **User Experience** | Insight, comprensión, curiosidad. |
| **Cognitive Load** | 3/5 |
| **Interaction Levels** | Individual, Diádico, Familiar |
| **BPG Impact** | +Defusión Cognitiva, +Aceptación, +Valores |

---

### 4.4. Familia 4: Acción

#### MEC-019: Elegir

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-019 |
| **Nombre** | Elegir |
| **Familia** | Acción |
| **Descripción** | Seleccionar una opción entre varias alternativas. |
| **Procesos BPO** | BPO-CTX-000038 (Acción Comprometida), BPO-CTX-000037 (Clarificación de Valores), BPO-MOT-000001 (Autonomía) |
| **Niveles** | 1. Elegir entre dos opciones simples. 2. Elegir entre múltiples opciones. 3. Elegir basado en valores. 4. Elegir en situación de incertidumbre. 5. Elegir y comprometerse con la acción. |
| **Variantes** | Visual, Textual, Situacional. |
| **Afinidades** | Valores, Persistir, Actuar. |
| **Ejemplos** | "La Montaña de los Valores": Elegir un camino basado en valores. |
| **User Experience** | Autonomía, empoderamiento, decisión. |
| **Cognitive Load** | 3/5 |
| **Interaction Levels** | Individual, Diádico, Familiar |
| **BPG Impact** | +Acción Comprometida, +Valores |

#### MEC-020: Acercarse

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-020 |
| **Nombre** | Acercarse |
| **Familia** | Acción |
| **Descripción** | Moverse hacia un estímulo, situación o experiencia. |
| **Procesos BPO** | BPO-CON-000004 (Exposición), BPO-CON-000003 (Aproximación), BPO-CON-000001 (Activación Conductual) |
| **Niveles** | 1. Acercarse a un estímulo neutral. 2. Acercarse a un estímulo ligeramente incómodo. 3. Acercarse a un estímulo moderadamente incómodo. 4. Acercarse en contexto de malestar. 5. Acercarse como práctica de exposición. |
| **Variantes** | Virtual (Three.js/Godot), Física (con guía), Narrativa. |
| **Afinidades** | Permanecer, Elegir, Persistir. |
| **Ejemplos** | "El Puente de las Relaciones": Acercarse a una conversación difícil en una simulación. |
| **User Experience** | Coraje, logro, empoderamiento. |
| **Cognitive Load** | 4/5 |
| **Interaction Levels** | Individual, Diádico, Familiar |
| **BPG Impact** | +Exposición, -Evitación |

#### MEC-021: Permanecer

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-021 |
| **Nombre** | Permanecer |
| **Familia** | Acción |
| **Descripción** | Mantenerse en una situación o experiencia sin escapar. |
| **Procesos BPO** | BPO-EMO-000007 (Tolerancia al Malestar), BPO-CON-000004 (Exposición), BPO-CTX-000031 (Aceptación) |
| **Niveles** | 1. Permanecer 5 segundos. 2. Permanecer 30 segundos. 3. Permanecer 2 minutos. 4. Permanecer en contexto de malestar. 5. Permanecer como práctica de exposición prolongada. |
| **Variantes** | Virtual (Three.js/Godot), Física (con guía), Temporal (cronómetro). |
| **Afinidades** | Acercarse, Respirar, Persistir. |
| **Ejemplos** | "El Laberinto de la Aceptación": Permanecer en una situación incómoda y observarla. |
| **User Experience** | Resistencia, logro, empoderamiento. |
| **Cognitive Load** | 4/5 |
| **Interaction Levels** | Individual, Diádico, Familiar |
| **BPG Impact** | +Tolerancia al Malestar, +Aceptación |

#### MEC-022: Iniciar

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-022 |
| **Nombre** | Iniciar |
| **Familia** | Acción |
| **Descripción** | Comenzar una tarea o acción sin demora. |
| **Procesos BPO** | BPO-CON-000001 (Activación Conductual), BPO-CTX-000038 (Acción Comprometida), BPO-MOT-000003 (Persistencia) |
| **Niveles** | 1. Iniciar una tarea simple. 2. Iniciar una tarea con esfuerzo moderado. 3. Iniciar una tarea con incertidumbre. 4. Iniciar una tarea en contexto de malestar. 5. Iniciar como hábito. |
| **Variantes** | Virtual (Three.js/Godot), Temporal (cronómetro). |
| **Afinidades** | Elegir, Persistir, Actuar. |
| **Ejemplos** | "La Expedición de la Flexibilidad": Iniciar un diálogo con un NPC en un juego. |
| **User Experience** | Motivación, logro, empoderamiento. |
| **Cognitive Load** | 3/5 |
| **Interaction Levels** | Individual, Familiar, Grupal |
| **BPG Impact** | +Activación Conductual, +Acción Comprometida |

#### MEC-023: Continuar

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-023 |
| **Nombre** | Continuar |
| **Familia** | Acción |
| **Descripción** | Mantener una acción a pesar de la dificultad. |
| **Procesos BPO** | BPO-MOT-000003 (Persistencia), BPO-CON-000001 (Activación Conductual), BPO-CTX-000038 (Acción Comprometida) |
| **Niveles** | 1. Continuar 30 segundos. 2. Continuar 2 minutos. 3. Continuar 5 minutos. 4. Continuar en contexto de malestar. 5. Continuar como práctica de persistencia. |
| **Variantes** | Virtual (Three.js/Godot), Temporal (cronómetro). |
| **Afinidades** | Iniciar, Persistir, Acercarse. |
| **Ejemplos** | "La Montaña de los Valores": Continuar subiendo una montaña virtual a pesar del cansancio. |
| **User Experience** | Resistencia, logro, empoderamiento. |
| **Cognitive Load** | 3/5 |
| **Interaction Levels** | Individual, Diádico, Familiar |
| **BPG Impact** | +Persistencia, +Acción Comprometida |

#### MEC-024: Persistir

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-024 |
| **Nombre** | Persistir |
| **Familia** | Acción |
| **Descripción** | Mantener una acción a pesar de obstáculos y dificultades. |
| **Procesos BPO** | BPO-MOT-000003 (Persistencia), BPO-CTX-000038 (Acción Comprometida), BPO-EMO-000007 (Tolerancia al Malestar) |
| **Niveles** | 1. Persistir 1 minuto. 2. Persistir 5 minutos. 3. Persistir en tarea con obstáculos. 4. Persistir en contexto de malestar. 5. Persistir como práctica de resiliencia. |
| **Variantes** | Virtual (Three.js/Godot), Temporal (cronómetro). |
| **Afinidades** | Continuar, Acercarse, Permanecer. |
| **Ejemplos** | "La Expedición de la Flexibilidad": Persistir en una tarea de exposición virtual. |
| **User Experience** | Resiliencia, logro, empoderamiento. |
| **Cognitive Load** | 4/5 |
| **Interaction Levels** | Individual, Diádico, Familiar, Grupal |
| **BPG Impact** | +Persistencia, +Tolerancia al Malestar |

#### MEC-025: Acción Opuesta

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-025 |
| **Nombre** | Acción Opuesta |
| **Familia** | Acción |
| **Descripción** | Realizar una acción contraria a la tendencia automática. |
| **Procesos BPO** | BPO-EMO-000004 (Regulación Emocional), BPO-CON-000004 (Exposición), BPO-NEU-000003 (Flexibilidad Cognitiva) |
| **Niveles** | 1. Realizar una acción opuesta simple. 2. Realizar una acción opuesta en contexto de malestar. 3. Realizar una acción opuesta sostenida. 4. Realizar una acción opuesta en situación social. 5. Realizar como práctica de flexibilidad. |
| **Variantes** | Virtual (Three.js/Godot), Guiada. |
| **Afinidades** | Elegir, Acercarse, Permanecer. |
| **Ejemplos** | "El Puente de las Relaciones": Acción opuesta a la evitación social en una simulación. |
| **User Experience** | Desafío, logro, empoderamiento. |
| **Cognitive Load** | 4/5 |
| **Interaction Levels** | Individual, Diádico, Familiar |
| **BPG Impact** | +Regulación Emocional, -Evitación |

#### MEC-026: Microacción

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-026 |
| **Nombre** | Microacción |
| **Familia** | Acción |
| **Descripción** | Realizar una acción muy pequeña y manejable. |
| **Procesos BPO** | BPO-CON-000001 (Activación Conductual), BPO-CON-000002 (Evitación), BPO-CON-000009 (Formación de Hábitos) |
| **Niveles** | 1. Microacción de 30 segundos. 2. Microacción de 2 minutos. 3. Microacción de 5 minutos. 4. Microacción en contexto de malestar. 5. Microacción como práctica de activación. |
| **Variantes** | Virtual (Three.js/Godot), Guiada. |
| **Afinidades** | Iniciar, Continuar, Elegir. |
| **Ejemplos** | "El Faro del Equilibrio": Hacer una microacción como levantarse y estirarse. |
| **User Experience** | Logro, motivación, empoderamiento. |
| **Cognitive Load** | 2/5 |
| **Interaction Levels** | Individual, Familiar, Grupal |
| **BPG Impact** | +Activación Conductual, -Evitación |

---

### 4.5. Familia 5: Regulación

#### MEC-027: Pausar

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-027 |
| **Nombre** | Pausar |
| **Familia** | Regulación |
| **Descripción** | Detener la acción y tomar un momento de respiro. |
| **Procesos BPO** | BPO-EMO-000004 (Regulación Emocional), BPO-CTX-000034 (Contacto con el Presente), BPO-EMO-000007 (Tolerancia al Malestar) |
| **Niveles** | 1. Pausar 5 segundos. 2. Pausar 30 segundos. 3. Pausar 2 minutos. 4. Pausar en contexto de malestar. 5. Pausar como práctica de autorregulación. |
| **Variantes** | Temporal (cronómetro), Guiada. |
| **Afinidades** | Respirar, Observar, Relajación. |
| **Ejemplos** | "El Faro del Equilibrio": Pausar y observar la respiración. |
| **User Experience** | Calma, control, presencia. |
| **Cognitive Load** | 1/5 |
| **Interaction Levels** | Individual, Diádico, Familiar, Grupal |
| **BPG Impact** | +Regulación Emocional |

#### MEC-028: Relajación

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-028 |
| **Nombre** | Relajación |
| **Familia** | Regulación |
| **Descripción** | Reducir la tensión física y mental mediante técnicas específicas. |
| **Procesos BPO** | BPO-EMO-000004 (Regulación Emocional), BPO-EMO-000007 (Tolerancia al Malestar), BPO-FIS-000001 (Activación Autonómica) |
| **Niveles** | 1. Relajación muscular simple. 2. Relajación guiada (5 min). 3. Relajación autónoma (5 min). 4. Relajación en contexto de malestar. 5. Relajación como práctica diaria. |
| **Variantes** | Guiada (audio), Autónoma. |
| **Afinidades** | Respirar, Pausar, Escaneo. |
| **Ejemplos** | "El Faro del Equilibrio": Práctica de relajación muscular progresiva. |
| **User Experience** | Calma, bienestar, alivio. |
| **Cognitive Load** | 2/5 |
| **Interaction Levels** | Individual, Familiar, Grupal |
| **BPG Impact** | +Regulación Emocional, +Activación Autonómica |

#### MEC-029: Autocompasión

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-029 |
| **Nombre** | Autocompasión |
| **Familia** | Regulación |
| **Descripción** | Tratarse a uno mismo con amabilidad y comprensión. |
| **Procesos BPO** | BPO-CTX-000039 (Autocompasión), BPO-EMO-000004 (Regulación Emocional), BPO-CTX-000031 (Aceptación) |
| **Niveles** | 1. Practicar una frase compasiva. 2. Practicar un diálogo compasivo. 3. Practicar autocompasión en contexto de malestar. 4. Practicar autocompasión prolongada. 5. Practicar autocompasión como hábito. |
| **Variantes** | Guiada (audio), Autónoma (texto). |
| **Afinidades** | Validación, Aceptación, Renombrar. |
| **Ejemplos** | "El Espejo de la Autocompasión": Ejercicio de autocompasión guiada. |
| **User Experience** | Calidez, alivio, consuelo. |
| **Cognitive Load** | 3/5 |
| **Interaction Levels** | Individual, Diádico, Familiar |
| **BPG Impact** | +Autocompasión, +Aceptación |

#### MEC-030: Validación

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-030 |
| **Nombre** | Validación |
| **Familia** | Regulación |
| **Descripción** | Reconocer y aceptar una emoción o experiencia como válida. |
| **Procesos BPO** | BPO-CTX-000031 (Aceptación), BPO-EMO-000004 (Regulación Emocional), BPO-CTX-000039 (Autocompasión) |
| **Niveles** | 1. Validar una emoción simple. 2. Validar una emoción compleja. 3. Validar una experiencia dolorosa. 4. Validar en contexto social. 5. Validar como práctica de aceptación. |
| **Variantes** | Verbal, Escrita, Guiada. |
| **Afinidades** | Autocompasión, Aceptación, Reflexionar. |
| **Ejemplos** | "El Espejo de la Autocompasión": Escribir una carta de validación a uno mismo. |
| **User Experience** | Aceptación, alivio, comprensión. |
| **Cognitive Load** | 3/5 |
| **Interaction Levels** | Individual, Diádico, Familiar, Grupal |
| **BPG Impact** | +Aceptación, +Regulación Emocional |

#### MEC-031: Aceptación

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-031 |
| **Nombre** | Aceptación |
| **Familia** | Regulación |
| **Descripción** | Permitir que los eventos privados estén presentes sin intentar cambiarlos. |
| **Procesos BPO** | BPO-CTX-000031 (Aceptación), BPO-EMO-000007 (Tolerancia al Malestar), BPO-CTX-000032 (Defusión Cognitiva) |
| **Niveles** | 1. Aceptar una sensación simple. 2. Aceptar una emoción. 3. Aceptar un pensamiento. 4. Aceptar en contexto de malestar. 5. Aceptar como práctica de flexibilidad. |
| **Variantes** | Guiada (audio), Autónoma (texto), **3D (escudo de resistencia)**. |
| **Afinidades** | Observar, Permanecer, Validación. |
| **Ejemplos** | "El Laberinto de la Aceptación": Ejercicio de aceptación de emociones. "Escudo de Resistencia" (3D): Sostener un escudo contra ráfagas de malestar. |
| **User Experience** | Libertad, alivio, presencia. |
| **Cognitive Load** | 3/5 |
| **Interaction Levels** | Individual, Diádico, Familiar |
| **BPG Impact** | +Aceptación, +Tolerancia al Malestar |

---

### 4.6. Familia 6: Sociales

#### MEC-032: Escuchar

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-032 |
| **Nombre** | Escuchar |
| **Familia** | Sociales |
| **Descripción** | Prestar atención activa a lo que el otro dice. |
| **Procesos BPO** | BPO-INT-000001 (Conexión Social), BPO-INT-000003 (Validación), BPO-INT-000004 (Empatía) |
| **Niveles** | 1. Escuchar una frase. 2. Escuchar un párrafo. 3. Escuchar y parafrasear. 4. Escuchar en contexto de conflicto. 5. Escuchar como práctica de conexión. |
| **Variantes** | Presencial, Virtual (simulación). |
| **Afinidades** | Validar, Preguntar, Conectar. |
| **Ejemplos** | "El Puente de las Relaciones": Escuchar a un NPC y parafrasear su mensaje. |
| **User Experience** | Conexión, comprensión, presencia. |
| **Cognitive Load** | 3/5 |
| **Interaction Levels** | Individual, **Diádico**, Familiar, Grupal |
| **BPG Impact** | +Conexión Social, +Empatía |

#### MEC-033: Validar (Social)

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-033 |
| **Nombre** | Validar (Social) |
| **Familia** | Sociales |
| **Descripción** | Reconocer y aceptar la experiencia del otro. |
| **Procesos BPO** | BPO-INT-000001 (Conexión Social), BPO-INT-000003 (Validación), BPO-INT-000004 (Empatía) |
| **Niveles** | 1. Validar una emoción simple del otro. 2. Validar una emoción compleja. 3. Validar una experiencia dolorosa. 4. Validar en contexto de conflicto. 5. Validar como práctica de conexión. |
| **Variantes** | Verbal, Escrita, Virtual (simulación). |
| **Afinidades** | Escuchar, Conectar, Preguntar. |
| **Ejemplos** | "El Puente de las Relaciones": Validar la perspectiva de un NPC. |
| **User Experience** | Conexión, comprensión, intimidad. |
| **Cognitive Load** | 3/5 |
| **Interaction Levels** | Individual, **Diádico**, Familiar, Grupal |
| **BPG Impact** | +Conexión Social, +Validación |

#### MEC-034: Pedir

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-034 |
| **Nombre** | Pedir |
| **Familia** | Sociales |
| **Descripción** | Expresar una necesidad o deseo a otra persona. |
| **Procesos BPO** | BPO-INT-000010 (Comunicación Asertiva), BPO-INT-000001 (Conexión Social), BPO-MOT-000001 (Autonomía) |
| **Niveles** | 1. Pedir algo simple. 2. Pedir algo con impacto emocional. 3. Pedir en contexto de conflicto. 4. Pedir con vulnerabilidad. 5. Pedir como práctica de asertividad. |
| **Variantes** | Verbal, Escrita, Virtual (simulación). |
| **Afinidades** | Negociar, Conectar, Vulnerabilidad. |
| **Ejemplos** | "El Puente de las Relaciones": Pedir ayuda a un NPC en una simulación. |
| **User Experience** | Empoderamiento, conexión, logro. |
| **Cognitive Load** | 4/5 |
| **Interaction Levels** | Individual, **Diádico**, Familiar |
| **BPG Impact** | +Comunicación Asertiva, +Conexión Social |

#### MEC-035: Negociar

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-035 |
| **Nombre** | Negociar |
| **Familia** | Sociales |
| **Descripción** | Buscar un acuerdo mutuamente beneficioso. |
| **Procesos BPO** | BPO-INT-000010 (Comunicación Asertiva), BPO-INT-000001 (Conexión Social), BPO-INT-000008 (Cooperación) |
| **Niveles** | 1. Negociar un tema simple. 2. Negociar un tema con impacto emocional. 3. Negociar en contexto de conflicto. 4. Negociar con múltiples partes. 5. Negociar como práctica de flexibilidad. |
| **Variantes** | Verbal, Virtual (simulación). |
| **Afinidades** | Pedir, Conectar, Validar. |
| **Ejemplos** | "El Puente de las Relaciones": Negociar un acuerdo con un NPC. |
| **User Experience** | Empoderamiento, conexión, logro. |
| **Cognitive Load** | 4/5 |
| **Interaction Levels** | Individual, **Diádico**, **Familiar**, **Grupal** |
| **BPG Impact** | +Comunicación Asertiva, +Cooperación |

#### MEC-036: Compartir

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-036 |
| **Nombre** | Compartir |
| **Familia** | Sociales |
| **Descripción** | Expresar pensamientos, sentimientos o experiencias con otros. |
| **Procesos BPO** | BPO-INT-000001 (Conexión Social), BPO-INT-000002 (Vulnerabilidad), BPO-INT-000005 (Intimidad) |
| **Niveles** | 1. Compartir un hecho simple. 2. Compartir una emoción. 3. Compartir una experiencia significativa. 4. Compartir en contexto de vulnerabilidad. 5. Compartir como práctica de conexión. |
| **Variantes** | Verbal, Escrita, Virtual (simulación). |
| **Afinidades** | Validar, Conectar, Vulnerabilidad. |
| **Ejemplos** | "El Puente de las Relaciones": Compartir una experiencia personal con un NPC. |
| **User Experience** | Conexión, intimidad, alivio. |
| **Cognitive Load** | 3/5 |
| **Interaction Levels** | Individual, **Diádico**, **Familiar**, **Grupal** |
| **BPG Impact** | +Conexión Social, +Vulnerabilidad |

#### MEC-037: Conversación Difícil

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-037 |
| **Nombre** | Conversación Difícil |
| **Familia** | Sociales |
| **Descripción** | Mantener una conversación sobre un tema emocionalmente cargado. |
| **Procesos BPO** | BPO-INT-000010 (Comunicación Asertiva), BPO-INT-000009 (Reparación Interpersonal), BPO-EMO-000004 (Regulación Emocional) |
| **Niveles** | 1. Conversación sobre un tema neutro. 2. Conversación sobre un tema ligeramente incómodo. 3. Conversación sobre un tema emocional. 4. Conversación en contexto de conflicto. 5. Conversación como práctica de habilidades. |
| **Variantes** | Virtual (simulación con NPC). |
| **Afinidades** | Escuchar, Validar, Pedir, Negociar. |
| **Ejemplos** | "El Puente de las Relaciones": Simulación de una conversación difícil con un NPC. |
| **User Experience** | Desafío, logro, empoderamiento. |
| **Cognitive Load** | 5/5 |
| **Interaction Levels** | Individual, **Diádico**, Familiar |
| **BPG Impact** | +Comunicación Asertiva, +Reparación Interpersonal |

#### MEC-038: Reparar (Social)

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-038 |
| **Nombre** | Reparar (Social) |
| **Familia** | Sociales |
| **Descripción** | Restaurar la conexión después de un conflicto o ruptura. |
| **Procesos BPO** | BPO-INT-000009 (Reparación Interpersonal), BPO-INT-000001 (Conexión Social), BPO-REL-000003 (Sincronía) |
| **Niveles** | 1. Reconocer que hubo un conflicto. 2. Ofrecer una disculpa simple. 3. Realizar un acto de reparación simbólico. 4. Reparar en contexto de conflicto activo. 5. Reparar como práctica relacional. |
| **Variantes** | Verbal, Virtual (simulación), **3D (reparar un objeto juntos)**. |
| **Afinidades** | Escuchar, Validar, Compartir. |
| **Ejemplos** | "Puente de la Conexión" (diádico): Reparar un puente roto cooperativamente. |
| **User Experience** | Conexión, alivio, esperanza. |
| **Cognitive Load** | 4/5 |
| **Interaction Levels** | **Diádico**, **Familiar** |
| **BPG Impact** | +Reparación Interpersonal, +Conexión Social |

---

### 4.7. Familia 7: Integración

#### MEC-039: Reflexionar

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-039 |
| **Nombre** | Reflexionar |
| **Familia** | Integración |
| **Descripción** | Pensar sobre una experiencia para extraer aprendizajes. |
| **Procesos BPO** | BPO-CTX-000040 (Metacognición), BPO-CTX-000043 (Generalización), BPO-CTX-000044 (Transferencia) |
| **Niveles** | 1. Reflexionar sobre una experiencia simple. 2. Reflexionar sobre una emoción. 3. Reflexionar sobre un patrón. 4. Reflexionar sobre el cambio. 5. Reflexionar sobre la identidad. |
| **Variantes** | Escrita, Verbal, Guiada. |
| **Afinidades** | Observar, Describir, Generalizar. |
| **Ejemplos** | "El Diario del Explorador": Reflexión guiada después de una misión. |
| **User Experience** | Insight, comprensión, crecimiento. |
| **Cognitive Load** | 3/5 |
| **Interaction Levels** | Individual, Diádico, Familiar, Grupal |
| **BPG Impact** | +Metacognición, +Generalización |

#### MEC-040: Generalizar

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-040 |
| **Nombre** | Generalizar |
| **Familia** | Integración |
| **Descripción** | Aplicar un aprendizaje a otros contextos. |
| **Procesos BPO** | BPO-CTX-000043 (Generalización), BPO-CTX-000044 (Transferencia), BPO-CTX-000042 (Planeación) |
| **Niveles** | 1. Generalizar a un contexto similar. 2. Generalizar a un contexto diferente. 3. Generalizar a múltiples contextos. 4. Generalizar a situaciones de la vida real. 5. Generalizar como práctica de aprendizaje. |
| **Variantes** | Escrita, Verbal, Guiada. |
| **Afinidades** | Reflexionar, Conectar, Transferir. |
| **Ejemplos** | "La Expedición de la Flexibilidad": Generalizar una habilidad a un contexto nuevo. |
| **User Experience** | Empoderamiento, crecimiento, aplicación. |
| **Cognitive Load** | 3/5 |
| **Interaction Levels** | Individual, Diádico, Familiar |
| **BPG Impact** | +Generalización, +Transferencia |

#### MEC-041: Conectar con Valores

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-041 |
| **Nombre** | Conectar con Valores |
| **Familia** | Integración |
| **Descripción** | Vincular una acción o experiencia con los valores personales. |
| **Procesos BPO** | BPO-CTX-000037 (Clarificación de Valores), BPO-CTX-000038 (Acción Comprometida), BPO-MOT-000004 (Orientación a Metas) |
| **Niveles** | 1. Identificar un valor. 2. Identificar una acción alineada con valores. 3. Realizar una acción alineada con valores. 4. Reflexionar sobre la coherencia con valores. 5. Vivir según valores como práctica. |
| **Variantes** | Escrita, Verbal, Guiada. |
| **Afinidades** | Elegir, Reflexionar, Actuar. |
| **Ejemplos** | "La Montaña de los Valores": Vincular una decisión con un valor personal. |
| **User Experience** | Sentido, propósito, coherencia. |
| **Cognitive Load** | 3/5 |
| **Interaction Levels** | Individual, Diádico, Familiar, Grupal |
| **BPG Impact** | +Valores, +Acción Comprometida |

#### MEC-042: Registrar Descubrimientos

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-042 |
| **Nombre** | Registrar Descubrimientos |
| **Familia** | Integración |
| **Descripción** | Documentar aprendizajes y patrones. |
| **Procesos BPO** | BPO-CTX-000040 (Metacognición), BPO-CTX-000043 (Generalización), BPO-CTX-000042 (Planeación) |
| **Niveles** | 1. Registrar un hecho. 2. Registrar una emoción. 3. Registrar un patrón. 4. Registrar un aprendizaje significativo. 5. Registrar como práctica de autoconocimiento. |
| **Variantes** | Escrita, Visual. |
| **Afinidades** | Reflexionar, Generalizar, Conectar. |
| **Ejemplos** | "El Diario del Explorador": Registrar un descubrimiento después de una misión. |
| **User Experience** | Crecimiento, memoria, autoconocimiento. |
| **Cognitive Load** | 3/5 |
| **Interaction Levels** | Individual, Familiar |
| **BPG Impact** | +Metacognición, +Generalización |

#### MEC-043: Planificar

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-043 |
| **Nombre** | Planificar |
| **Familia** | Integración |
| **Descripción** | Diseñar un plan de acción basado en aprendizajes. |
| **Procesos BPO** | BPO-CTX-000038 (Acción Comprometida), BPO-CTX-000042 (Planeación), BPO-MOT-000001 (Autonomía) |
| **Niveles** | 1. Planificar una acción simple. 2. Planificar una secuencia de acciones. 3. Planificar para un contexto específico. 4. Planificar para múltiples contextos. 5. Planificar como práctica de autonomía. |
| **Variantes** | Escrita, Verbal, Guiada. |
| **Afinidades** | Reflexionar, Conectar, Actuar. |
| **Ejemplos** | "La Expedición de la Flexibilidad": Planificar el siguiente paso en el viaje. |
| **User Experience** | Empoderamiento, dirección, propósito. |
| **Cognitive Load** | 3/5 |
| **Interaction Levels** | Individual, Diádico, Familiar |
| **BPG Impact** | +Acción Comprometida, +Planeación |

---

## 5. Mecánicas 3D (Nuevas en v2.0.0)

Estas mecánicas están diseñadas específicamente para el Ideographic Game Engine y se renderizan en Three.js.

### 5.1. Balloon Burst (Estallir Globos)

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-3D-001 |
| **Nombre** | Balloon Burst (Estallir Globos) |
| **Familia** | Flexibilidad |
| **Descripción** | El paciente escribe pensamientos rígidos que se convierten en globos 3D. Debe estallar cada globo con una resortera digital para restarle credibilidad. |
| **Procesos BPO** | BPO-CTX-000032 (Defusión Cognitiva) |
| **Mecánica base** | Distanciamiento (MEC-016) + Repetición Semántica (MEC-015) |
| **Implementación** | Three.js: globos flotantes con texto, partículas al explotar, sonido satisfactorio (juicy feedback). |
| **BPG Impact** | -Fusión Cognitiva, +Defusión Cognitiva |

### 5.2. Resistance Shield (Escudo de Resistencia)

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-3D-002 |
| **Nombre** | Resistance Shield (Escudo de Resistencia) |
| **Familia** | Regulación |
| **Descripción** | Mini-juego estilo Zelda donde el paciente sostiene presionado un "botón de escudo" (respiración consciente) para tolerar ráfagas de malestar emocional sin huir. |
| **Procesos BPO** | BPO-CTX-000031 (Aceptación), BPO-EMO-000007 (Tolerancia al Malestar) |
| **Mecánica base** | Permanecer (MEC-021) + Respirar (MEC-010) |
| **Implementación** | Three.js: escudo 3D que se activa con respiración, ráfagas de viento con colores的情绪ales, feedback háptico. |
| **BPG Impact** | +Aceptación, +Tolerancia al Malestar, -Evitación |

### 5.3. Pikmin Missions (Misiones Pikmin)

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-3D-003 |
| **Nombre** | Pikmin Missions (Misiones Pikmin) |
| **Familia** | Acción |
| **Descripción** | Micro-misiones en el mundo real alineadas con los valores del paciente. Al completarse, hacen crecer plantas en un Jardín Virtual que refleja la flexibilidad psicológica. |
| **Procesos BPO** | BPO-CTX-000038 (Acción Comprometida), BPO-CTX-000037 (Clarificación de Valores) |
| **Mecánica base** | Elegir (MEC-019) + Microacción (MEC-026) + Conectar con Valores (MEC-041) |
| **Implementación** | Three.js: jardín 3D que crece con cada misión completada, plantas que representan procesos. |
| **BPG Impact** | +Acción Comprometida, +Valores, +Activación Conductual |

### 5.4. River Float (Flotar en el Río)

| Atributo | Valor |
|----------|-------|
| **ID** | MEC-3D-004 |
| **Nombre** | River Float (Flotar en el Río) |
| **Familia** | Flexibilidad |
| **Descripción** | Pensamientos aparecen como hojas en un río. El paciente observa cómo flotan y se van sin aferrarse a ellos. Pasiva, sin interacción activa. |
| **Procesos BPO** | BPO-CTX-000032 (Defusión Cognitiva), BPO-CTX-000034 (Contacto con el Presente) |
| **Mecánica base** | Observar sin Intervenir (MEC-007) + Distanciamiento (MEC-016) |
| **Implementación** | Three.js: río 3D con hojas flotantes, música ambiental, transición de colores de oscuro a claro. |
| **BPG Impact** | +Defusión Cognitiva, +Contacto con el Presente |

---

## 6. Mecánicas Multi-Nivel (Nuevas en v2.0.0)

### 6.1. Mecánicas Diádicas (Pareja)

| ID | Nombre | Procesos BPO | Descripción |
|----|--------|--------------|-------------|
| MEC-D-001 | Jardín Compartido | BPO-REL-000003 (Sincronía), BPO-INT-000009 (Reparación) | Ambos miembros cuidan un jardín virtual juntos, tomando decisiones cooperativas. |
| MEC-D-002 | Conversación del Puente | BPO-INT-000010 (Comunicación Asertiva), BPO-INT-000003 (Validación) | Simulación de conversación difícil donde ambos practican escuchar y validar. |
| MEC-D-003 | Escudo de Pareja | BPO-EMO-000004 (Regulación), BPO-REL-000001 (Coregulación) | Ambos sostienen un escudo juntos contra ráfagas de estrés, practicando coregulación. |

### 6.2. Mecánicas Familiares

| ID | Nombre | Procesos BPO | Descripción |
|----|--------|--------------|-------------|
| MEC-F-001 | Reino Familiar | BPO-FAM-000001 (Cohesión), BPO-FAM-000002 (Adaptabilidad) | Toda la familia construye un reino virtual juntos, asignando roles y cooperando. |
| MEC-F-002 | Misiones de Equipo | BPO-FAM-000003 (Comunicación), BPO-INT-000008 (Cooperación) | Misiones que requieren que cada miembro aporte una habilidad diferente. |
| MEC-F-003 | Árbol de Valores | BPO-FAM-000005 (Valores Compartidos), BPO-CTX-000037 (Valores) | La familia planta un árbol donde cada rama representa un valor familiar. |

### 6.3. Mecánicas Grupales

| ID | Nombre | Procesos BPO | Descripción |
|----|--------|--------------|-------------|
| MEC-G-001 | Círculo de Confianza | BPO-INT-000001 (Conexión Social), BPO-INT-000006 (Confianza) | Grupo construye un círculo de confianza donde cada persona comparte algo vulnerable. |
| MEC-G-002 | Torre Colectiva | BPO-INT-000008 (Cooperación), BPO-MOT-000003 (Persistencia) | Grupo construye una torre donde cada pieza representa una habilidad de un miembro. |

---

## 7. Afinidades y Combinaciones

### 7.1. Matriz de Afinidades (Ejemplos)

| Mecánica | Combina bien con | Combina mal con |
|----------|------------------|------------------|
| Observar | Describir, Comparar, Reflexionar | Actuar (sin observación previa) |
| Elegir | Valores, Persistir, Acercarse | Ninguna |
| Acercarse | Permanecer, Persistir, Respirar | Evitar |
| Respirar | Pausar, Escaneo, Observar | Movimiento rápido |
| Reflexionar | Generalizar, Conectar, Registrar | Acción impulsiva |
| Balloon Burst | Distanciamiento, Renombrar | Permanecer (sin acción previa) |
| Resistance Shield | Respirar, Aceptación | Explorar (sin regulación previa) |

### 7.2. Combinaciones Típicas para Ejercicios

| Ejercicio | Mecánicas combinadas | Proceso BPO objetivo |
|-----------|----------------------|----------------------|
| "El Bosque de la Incertidumbre" | Observar + Distanciamiento + Reflexionar | Defusión (BPO-CTX-000032) |
| "La Montaña de los Valores" | Elegir + Conectar con Valores + Persistir | Valores + Acción Comprometida |
| "El Faro del Equilibrio" | Respirar + Escaneo + Pausar | Regulación Emocional (BPO-EMO-000004) |
| "El Laberinto de la Aceptación" | Observar + Aceptación + Permanecer | Aceptación (BPO-CTX-000031) |
| "El Puente de las Relaciones" | Escuchar + Validar + Compartir | Conexión Social (BPO-INT-000001) |
| "La Tormenta de la Defusión" | Repetición + Renombrar + Observar | Defusión (BPO-CTX-000032) |
| "El Espejo de la Autocompasión" | Autocompasión + Validación + Reflexionar | Autocompasión (BPO-CTX-000039) |
| "La Expedición de la Flexibilidad" | Explorar + Elegir + Generalizar | Flexibilidad Psicológica |
| **"Globos de los Pensamientos" (3D)** | **Balloon Burst + Distanciamiento** | **Defusión (BPO-CTX-000032)** |
| **"Escudo de Resistencia" (3D)** | **Resistance Shield + Respirar** | **Aceptación (BPO-CTX-000031)** |
| **"Misiones Pikmin" (3D)** | **Pikmin Missions + Elegir + Valores** | **Acción Comprometida (BPO-CTX-000038)** |

---

## 8. Niveles de Profundidad

Cada mecánica tiene **5 niveles de profundidad** que permiten ajustar la dificultad y la complejidad según el perfil del usuario (AHEE). Los niveles se basan en:

- **Complejidad cognitiva**: Simple → Compleja.
- **Carga emocional**: Baja → Alta.
- **Duración**: Corta → Larga.
- **Contexto**: Neutral → Emocionalmente cargado.

### 8.1. Ejemplo: Niveles de "Observar"

| Nivel | Descripción | Contexto | Carga cognitiva | Carga emocional |
|-------|-------------|----------|-----------------|-----------------|
| 1 | Detectar una sensación física. | Neutral | Baja | Baja |
| 2 | Detectar una emoción. | Neutral | Media | Baja |
| 3 | Detectar pensamiento + emoción. | Moderado | Media | Media |
| 4 | Detectar antecedente + emoción + conducta. | Emocional | Alta | Alta |
| 5 | Detectar función de un patrón. | Emocional | Alta | Alta |

### 8.2. Asignación de Niveles por AHEE

| Perfil del usuario | Nivel típico de "Observar" | Razonamiento |
|--------------------|----------------------------|--------------|
| Niño (6-12 años) | Nivel 1-2 | Desarrollo cognitivo, necesidad de concreción. |
| Adolescente (13-18 años) | Nivel 2-3 | Mayor capacidad de abstracción, pero aún en desarrollo. |
| Adulto (19-64 años) | Nivel 3-4 | Capacidad de abstracción y manejo emocional. |
| Adulto mayor (65+) | Nivel 2-3 | Posible declive cognitivo, necesidad de simplicidad. |
| Usuario con TEA | Nivel 1-2 | Necesidad de predictibilidad y concreción. |
| Usuario con TDAH | Nivel 2-3 | Necesidad de estructura pero con retos moderados. |
| Usuario ansioso | Nivel 2-3 (con mayor validación) | Evitar sobrecarga emocional. |
| **Pareja** | **Nivel 2-3** | **Coordinación entre dos, validar ambos ritmos.** |
| **Familia** | **Nivel 1-2** **(niños), 3-4 (adultos)** | **Adaptar por edad de cada miembro.** |

---

## 9. Integración con el Ecosistema

### 9.1. Con BERL v2.0.0

El BERL v2.0.0 utiliza la BML para construir ejercicios. Cada ejercicio combina una mecánica principal con mecánicas secundarias, y asigna niveles de profundidad según el perfil del usuario (AHEE). Desde v2.0.0, el BERL consume directamente del BPO.

### 9.2. Con el BPO

Cada mecánica mapea a procesos del BPO con UUID explícito. Esto permite:
- Validar que una mecánica cubre los procesos correctos.
- Buscar mecánicas por proceso (no por terapia).
- Evitar duplicación de lógica.

### 9.3. Con el BPG

Cada mecánica declara su impacto en procesos del BPG (dirección + o -). El motor de procesos utiliza esta información para:
- Recomendar mecánicas que impacten procesos débiles del paciente.
- Calcular el impacto acumulado de las mecánicas en el BPG.

### 9.4. Con AHEE

AHEE utiliza los niveles de profundidad de cada mecánica para ajustar la dificultad en tiempo real. Si el usuario muestra baja tolerancia al malestar, AHEE puede reducir el nivel de profundidad.

### 9.5. Con el Ideographic Game Engine

Las mecánicas 3D (Balloon Burst, Resistance Shield, Pikmin Missions, River Float) se renderizan en Three.js. El IDE recibe configuraciones DSL JSON que definen parámetros como texto de estímulos, colores, condiciones de victoria, etc.

### 9.6. Con el Experience Composer (BEC)

El Experience Composer utiliza la BML como paleta de mecánicas para diseñar nuevas experiencias. Los diseñadores pueden arrastrar y soltar mecánicas para crear ejercicios personalizados.

---

## 10. Criterios de Validación de Mecánicas

| Criterio | Métrica | Herramienta |
|----------|---------|-------------|
| **Cobertura BPO** | Cada mecánica debe mapear a al menos un proceso del BPO con UUID. | Validación automática |
| **Usabilidad** | Usuarios pueden entender la mecánica sin instrucciones (≥ 90%). | Pruebas de usabilidad |
| **Curva de aprendizaje** | Los niveles de profundidad son progresivos y no frustrantes. | Analítica de abandono |
| **Feedback** | La mecánica proporciona feedback inmediato en cada interacción. | Pruebas de usuario |
| **Reutilización** | La mecánica se usa en al menos 3 ejercicios diferentes. | Análisis de uso |
| **Adaptabilidad** | Los niveles de profundidad se ajustan correctamente a diferentes perfiles (AHEE). | Pruebas de adaptación |
| **Impacto BPG** | La mecánica produce un cambio medible en los procesos del BPG. | Análisis de BPG |
| **3D Engagement** | Las mecánicas 3D mantienen engagement ≥ 80% durante la sesión. | Analítica de uso |

---

## 11. El Manifiesto de las Mecánicas

> *"Las mecánicas no son solo interacciones. Son el alfabeto del cambio conductual.*
>
> *Cada mecánica es una unidad de aprendizaje que, combinada con otras, puede construir experiencias terapéuticas completas.*
>
> *Como Nintendo, no diseñamos niveles; diseñamos mecánicas. Los niveles emergen de su combinación.*
>
> *Una buena mecánica puede sostener cientos de ejercicios. Una mala mecánica aburre al usuario y no produce cambio.*
>
> *Desde v2.0.0, cada mecánica habla el mismo idioma que el BPO. Cada interacción tiene un UUID de proceso. Cada juego tiene un impacto medible en el grafo del paciente.*
>
> *Las mecánicas 3D no son un adorno. Son la diferencia entre una tarea clínica y una experiencia de Nintendo.*
>
> *Nuestra responsabilidad es diseñar mecánicas que sean psicológicamente fundamentadas, intuitivas, reutilizables, escalables, combinables y que impacten procesos del BPO. Que cada interacción sea una oportunidad de crecimiento."*

---

## 12. Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2026-07-01 | Arquitectura de Gamificación | Creación del documento. 7 familias, 42 mecánicas, niveles de profundidad, afinidades. |
| 2.0.0 | 2026-07-14 | Arquitectura de Gamificación | Mapeo explícito a procesos BPO (UUID). Mecánicas 3D: Balloon Burst, Resistance Shield, Pikmin Missions, River Float. Mecánicas multi-nivel: diádicas, familiares, grupales. Impacto BPG declarado en cada mecánica. Integración con Ideographic Game Engine. |

---

**Fin del documento `mechanics-library.md` v2.0.0**
