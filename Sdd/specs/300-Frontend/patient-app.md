---
id: PAT-001
title: Experiencia Nintendo – App del Paciente
version: 2.0.0
status: Stable
owner: Diseño UX/UI & Frontend Engineering
last_updated: 2026-07-14
depends_on:
  - 000-Core/philosophy.md (Filosofía - explorador)
  - 000-Core/principles.md (Principios - Nintendo)
  - 000-Core/vocabulary.md (Lenguaje - explorador, misión, descubrimiento)
  - 300-Frontend/design-system.md (BDS - tokens Nintendo)
  - 300-Frontend/ui-graph.md (UI Graph - navegación paciente)
  - 300-Frontend/accessibility.md (Accesibilidad - adaptaciones)
  - 300-Frontend/ahee-implementation.md (AHEE - personalización)
  - 300-Frontend/pwa-architecture.md (PWA - Service Worker, Three.js)
  - 400-AI/ai-core.md (Motor de IA - Gemma 4 + vLLM)
  - 400-AI/companion.md (TCCN - compañero)
  - 400-AI/adaptive-orchestrator.md (AAO - evaluación)
  - 500-Experiencies/experience-engine.md (BERL - ejercicios)
exports:
  - Filosofía de la experiencia Nintendo
  - Arquitectura de navegación (bottom nav, gestos, transiciones)
  - Especificación de pantallas clave (Atlas, Misiones, Compañero, Inventario, Perfil)
  - Flujos de usuario completos (onboarding, misión, chat, videoterapia)
  - Principios de gamificación ética (recompensas funcionales, sin manipulación)
  - Integración con Behavioral Twin, TCCN, AAO, BERL y AHEE
  - Integración PWA + Three.js para gráficos 3D
  - Streaming SSE para chat en tiempo real
  - Funcionamiento offline con IndexedDB
  - Preparación Capacitor para migración nativa
  - Criterios de validación y métricas de éxito
used_by:
  - Frontend Engineers (implementación de la app)
  - UX/UI Designers (diseño de pantallas y flujos)
  - QA (pruebas de experiencia de usuario)
  - Psicólogos clínicos (validación de la experiencia terapéutica)
---

# BehavioralOS – Experiencia Nintendo: App del Paciente (v2.0.0)

> *"El paciente no es un caso clínico. Es un explorador que se adentra en el territorio de su propia conducta para descubrir patrones, aprender nuevas rutas y construir una vida más valiosa. La app es su mapa, su brújula y su compañero de viaje."*

---

## 1. Filosofía de la Experiencia Nintendo

### 1.1. La Fantasía Central: El Explorador de su Propia Conducta

La experiencia del paciente se basa en una **fantasía central** poderosa y coherente con la ciencia contextual:

> **El usuario no está "en terapia". Está explorando el territorio de su propio comportamiento para descubrir patrones, aprender nuevas rutas y construir una vida más valiosa.**

Esta fantasía se traduce en:

| Concepto clínico | Metáfora Nintendo | Manifestación en la app |
|------------------|-------------------|-------------------------|
| **Procesos psicológicos** | Regiones de un mapa (Atención, Acción, Perspectiva, Relaciones, Significado, Equilibrio) | El Atlas muestra regiones que se iluminan al explorar. |
| **Ejercicios terapéuticos** | Misiones o expediciones | Cada misión tiene una narrativa (ej. "El Bosque de la Incertidumbre") y una recompensa (descubrimiento). |
| **Progreso** | El mapa que se revela | El Atlas se ilumina gradualmente; el Diario de Descubrimientos registra los hallazgos. |
| **Habilidades desarrolladas** | Objetos en el inventario | "Escudo de Aceptación", "Brújula de Valores", etc. |
| **IA (TCCN)** | Compañero de viaje | Un personaje persistente (calmo, curioso, observador) que acompaña al explorador. |
| **Recaída** | Información nueva en el mapa | La recaída no oscurece el mapa; añade nueva información ("Interesante, este patrón apareció en un contexto diferente"). |
| **Alta terapéutica** | Explorador avanzado | El usuario entra en modo mantenimiento, con nuevas misiones de entrenamiento continuo. |

### 1.2. Principios de Diseño Nintendo

| # | Principio | Descripción | Manifestación en la app |
|---|-----------|-------------|-------------------------|
| 1 | **Curiosidad primero** | La entrada nunca es una instrucción. Es una invitación a descubrir. | La pantalla de inicio no dice "Haz este ejercicio". Dice "Hay algo interesante que descubrimos hoy". |
| 2 | **Feedback inmediato** | Cada interacción produce una respuesta (sonido, vibración, animación). | Al completar un paso, hay una animación de "partículas de logro" y un sonido de "descubrimiento". |
| 3 | **Narrativa envolvente** | No hay ejercicios aislados. Hay una historia continua. | El usuario tiene un "viaje" con capítulos. Cada misión tiene una narrativa coherente. |
| 4 | **Recompensas funcionales** | El progreso no son puntos, sino descubrimientos sobre uno mismo. | La recompensa principal es un "descubrimiento" registrado en el Diario. |
| 5 | **Zona de Flow** | La dificultad se ajusta automáticamente (ni aburrido, ni frustrante). | AHEE ajusta la dificultad de las misiones en tiempo real. |
| 6 | **Exploración libre** | El usuario puede navegar por el mapa, revisar descubrimientos pasados y elegir qué misión realizar. | Navegación flexible; el usuario no está obligado a seguir un orden lineal. |
| 7 | **Personalidad del compañero** | La IA tiene una identidad estable (calma, curiosa, respetuosa). | El compañero tiene un avatar consistente, un tono de voz y una personalidad definida. |

### 1.3. El Lenguaje del Paciente (Vocabulario Controlado)

| Prohibido | Permitido | Ejemplo |
|-----------|-----------|---------|
| Paciente | Explorador | "El explorador completó la misión." |
| Ejercicio, Tarea | Misión, Expedición, Práctica | "Inicia la expedición de regulación." |
| Síntoma | Patrón, Señal, Indicador | "Observamos un patrón de sueño interrumpido." |
| Fracaso, Error | Experimento, Información nueva | "El experimento nos dio información inesperada." |
| Cumplir, Completar | Descubrir, Explorar | "Descubriste un nuevo patrón en tu comportamiento." |
| Mejoría | Crecimiento, Flexibilidad | "Desarrollaste la habilidad de permanecer en situaciones incómodas." |
| Recaída | Nuevo aprendizaje, Información sobre el contexto | "Apareció un patrón conocido en un nuevo contexto." |
| Alta | Transición, Nueva etapa | "El explorador entra en la etapa de entrenamiento continuo." |

---

## 2. Arquitectura PWA + Three.js (NUEVO v2.0.0)

### 2.1. Visión General de la PWA

La app del paciente es una **Progressive Web App (PWA)** que combina HTML5, CSS3, TypeScript y Three.js para ofrecer una experiencia nativa sin depender de tiendas de aplicaciones. La PWA permite:

- **Instalación directa**: El paciente instala la app desde el navegador con un clic.
- **Funcionamiento offline**: Service Workers cachearán assets críticos y IndexedDB almacenará datos locales.
- **Gráficos 3D**: Three.js renderiza el Hub Central, personajes y micro-juegos estilo Nintendo.
- **Streaming en tiempo real**: Server-Sent Events (SSE) para chat fluido con el companion.

### 2.2. Arquitectura de Capas

```
┌─────────────────────────────────────────────────────────────────────────┐
│             CAPA DE INTERFAZ DE USUARIO (UI)                           │
│       (HTML5 + CSS + Canvas de 3D con Three.js)                        │
└───────────────────────────┬─────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────────────┐
│             CAPA DE ABSTRACCIÓN DE HARDWARE                            │
│         (Service Workers para PWA / Capacitor)                         │
└───────────────────────────┬─────────────────────────────────────────────┘
                            │ (Llamadas API seguras / HTTPS)
                            ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                   BACKEND DE IA                                         │
│         (Servidor privado con Gemma 4 + Python)                        │
└─────────────────────────────────────────────────────────────────────────┘
```

### 2.3. Service Worker y Caché

El Service Worker implementa una estrategia **Cache-First** para assets estáticos:

| Recurso | Estrategia | Almacenamiento |
|---------|------------|----------------|
| Assets de Three.js (texturas, modelos) | Cache-First | Cache API |
| Efectos de sonido estilo Nintendo | Cache-First | Cache API |
| Hojas de estilo CSS | Cache-First | Cache API |
| HTML shell | Cache-First | Cache API |
| API del chat (SSE) | Network-First | No cachear |
| Datos de usuario | Offline-First | IndexedDB |

### 2.4. IndexedDB para Almacenamiento Offline

**Estructura de datos local:**

| Store | Propósito | Datos |
|-------|-----------|-------|
| `cola_mensajes` | Cola de mensajes pendientes de sincronización | `{id, mensaje, historial, fecha}` |
| `descubrimientos_cache` | Descubrimientos offline | `{id, titulo, contenido, fecha}` |
| `misiones_pendientes` | Misiones no completadas | `{id, mision, progreso}` |
| `configuracion_local` | Preferencias del usuario | `{tema, idioma, notificaciones}` |

### 2.5. Background Sync

Cuando el dispositivo pierde conexión, los mensajes se almacenan en IndexedDB. Al recuperar conexión:

1. El Service Worker detecta el evento `sync` con tag `'sincronizar-charla-pbp'`.
2. Lee los mensajes pendientes de `cola_mensajes`.
3. Envía cada mensaje al backend vía `POST /api/chat/stream`.
4. Elimina los mensajes sincronizados exitosamente.
5. Si el servidor falla, detiene el bucle y reintenta en el próximo evento `sync`.

### 2.6. Streaming SSE para Chat

La comunicación con el backend de IA utiliza **Server-Sent Events (SSE)**:

```
[Paciente envía mensaje]
         │
         ▼
┌───────────────────────────────────────────────────┐
│     CAPA DE CONTROL LOCAL (Service Worker)        │ ── (Almacena copia en IndexedDB)
└────────────────┬──────────────────────────────────┘
                 │ (Envío vía WebSockets / HTTPS)
                 ▼
┌───────────────────────────────────────────────────┐
│        ORQUESTADOR CENTRAL (vLLM + Gemma 4)       │
└────────────────┬─────────────────┬────────────────┘
                 │                 │
                 │ (Streaming)     │ (Decodificación Restringida JSON)
                 ▼                 ▼
  [Respuesta casual al Chat]     [Motor Clínico / Eventos Derivados]
```

**Características del streaming:**
- Latencia objetivo: < 200ms entre envío y primera respuesta.
- Formato: JSON estructurado con `texto_paciente` (visible) y `analisis_psicologo` (interno).
- Separación de carga: El usuario ve la respuesta mientras el backend procesa el análisis clínico en paralelo.

### 2.7. Hub Central / Jardín Virtual 3D

El Hub Central es un **mundo 3D interactivo** renderizado con Three.js que representa el progreso del paciente:

| Elemento 3D | Representación | Interacción |
|-------------|----------------|-------------|
| **Jardín Virtual** | Progreso general del paciente | Click en plantas/regiones para ver detalles |
| **Personaje/Mascota** | Animal Crossing-style que evoluciona | Interacción directa, respuestas contextuales |
| **Regiones del mapa** | Procesos psicológicos (Hexaflex) | Click para explorar cada proceso |
| **Objetos desbloqueados** | Habilidades del inventario | Recolección y visualización |
| **Estación del día** | Estado emocional actual | Cambia según contexto clínico |

### 2.8. Migración a Nativo con Capacitor

La PWA está preparada para migración futura a iOS/Android mediante **Capacitor**:

```json
{
  "appId": "com.behavioralos.coterapeuta.pbp",
  "appName": "Gimnasio Fluidez Emocional",
  "webDir": "www",
  "bundledWebRuntime": false,
  "server": {
    "androidScheme": "https"
  },
  "plugins": {
    "LocalNotifications": {
      "smallIcon": "ic_stat_icon_config",
      "iconColor": "#488AFF"
    }
  }
}
```

**Ventajas de Capacitor con Three.js:**
- WebGL se ejecuta nativamente en el WebView de iOS/Android.
- Acceso a hardware: micrófono (notas de voz), notificaciones push nativas.
- Los gráficos 3D del jardín virtual funcionan idéntico en web y nativo.
- Migración incremental: un solo comando genera proyectos Xcode y Android Studio.

---

## 3. Arquitectura de Navegación

### 3.1. Bottom Navigation (5 Pestañas)

| Pestaña | Icono | Descripción | Comportamiento |
|---------|-------|-------------|----------------|
| **Mapa (Atlas)** | 🗺️ | Pantalla principal. Muestra el mapa interactivo del comportamiento del usuario. | Click → abre el Atlas. |
| **Misiones** | 📋 | Lista de misiones disponibles, organizadas por proceso y nivel. | Click → abre la lista de misiones. |
| **Compañero** | 💬 | Chat con el TCCN (compañero IA). | Click → abre la conversación. |
| **Inventario** | 🎒 | Habilidades desbloqueadas (objetos). | Click → abre la mochila. |
| **Perfil** | 👤 | Información personal, configuraciones, diario de descubrimientos. | Click → abre el perfil. |

### 3.2. Gestos y Navegación

| Gesto | Acción | Uso |
|-------|--------|-----|
| **Deslizar izquierda/derecha** | Cambiar entre pestañas | Navegación rápida |
| **Deslizar hacia arriba** | Abrir chat del compañero | Acceso rápido |
| **Deslizar hacia abajo** | Cerrar chat o volver | Cerrar modales |
| **Tap en el mapa** | Abrir detalle de región | Exploración del Atlas |
| **Tap largo** | Acciones contextuales | Funcionalidades avanzadas |

### 3.3. Transiciones

| Transición | Animación | Duración | Uso |
|------------|-----------|----------|-----|
| Entre pestañas | Slide horizontal | 300ms | Navegación entre pantallas |
| Apertura de detalle | Fade + scale up | 200ms | Click en región o tarjeta |
| Inicio de misión | Fade out UI → fade in juego | 300ms | Carga de Three.js/Godot |
| Finalización de misión | Slide up con confeti | 500ms | Vuelta a mapa/misiones |
| Apertura de chat | Slide up desde inferior | 300ms | Click en avatar |

---

## 4. Pantallas Principales

### 4.1. Atlas (Pantalla Principal)

El Atlas es un mapa interactivo 3D (renderizado con Three.js) que representa el comportamiento del paciente a través de 6 regiones:

| Región | Proceso | Visualización |
|--------|---------|---------------|
| 🌱 Atención | Atención plena | Se ilumina al explorar |
| 🌊 Acción | Acción comprometida | Cresce con misiones completadas |
| 🌿 Perspectiva | Yo contexto | Cambia de forma según progreso |
| ❤️ Relaciones | Procesos de relación | Se expande socialmente |
| 🔥 Significado | Valores | Brillantez según claridad |
| 🌙 Equilibrio | Regulación | Fluctúa con estabilidad |

**Estados del Atlas:**
- **Región iluminada** (>70%): Color vibrante, icono de brillo
- **Región parcialmente iluminada** (30-70%): Color suave, barra visible
- **Región difuminada** (<30%): Color grisáceo, icono de candado
- **Región parpadeante**: Nuevo descubrimiento disponible
- **Región con icono de misión**: Misión disponible

### 4.2. Misiones

Lista de ejercicios terapéuticos gamificados, organizados por proceso y dificultad:

| Elemento | Descripción |
|----------|-------------|
| Filtros | Por proceso y estado (disponible, completada, bloqueada) |
| Tarjeta de misión | Icono, título, procesos, duración, narrativa |
| Progreso semanal | Barra de avance |
| Estados | Disponible, Completada, Bloqueada, Destacada |

### 4.3. Compañero (TCCN)

Chat con la IA en tiempo real mediante **SSE streaming**:

| Tipo de mensaje | Propósito | Ejemplo |
|-----------------|-----------|---------|
| Observación | Patrón detectado | "He notado que evitaste la reunión" |
| Validación | Reconocer esfuerzo | "Has avanzado mucho esta semana" |
| Pregunta exploratoria | Profundizar | "¿Qué crees que fue lo más difícil?" |
| Invitación a misión | Sugerir ejercicio | "¿Exploramos esto con una misión?" |
| Psicoeducación | Explicar concepto | "La defusión es como observar nubes" |
| Cierre | Finalizar conversación | "¿Mañana exploramos las Relaciones?" |

### 4.4. Inventario (Mochila)

Colección de habilidades desbloqueadas representadas como objetos:

| Objeto | Habilidad | Proceso |
|--------|-----------|---------|
| 🛡️ Escudo de Aceptación | Tolerar malestar | Aceptación |
| 🧭 Brújula de Valores | Claridad direccional | Valores |
| 🔍 Lupa de Defusión | Distancia de pensamientos | Defusión |
| 💡 Faro del Equilibrio | Regulación emocional | Equilibrio |
| 🗺️ Mapa del Momento | Presencia | Atención |
| 🔗 Kit de Relaciones | Conexión social | Relaciones |

### 4.5. Perfil

| Elemento | Descripción |
|----------|-------------|
| Avatar y nombre | Foto personalizada y nombre del usuario |
| Estadísticas | Días activos, nivel, habilidades |
| Diario de Descubrimientos | Lista cronológica de insights |
| Configuración | Idioma, notificaciones, tema, accesibilidad |
| Ayuda y soporte | FAQ, contacto con terapeuta, guía de instalación de la app (PWA-001 §7) |

---

## 5. Flujos de Usuario Clave

### 5.1. Onboarding

1. **Bienvenida animada**: Presentación del viaje con ilustraciones 3D
2. **Selección de avatar**: Personalización del avatar y del compañero
3. **Preferencias**: Edad, intereses, nivel de experiencia con videojuegos
4. **Conexión con terapeuta**: Vinculación o mensaje de espera
5. **Primera misión**: Misión introductoria (muy fácil)
6. **Home**: Atlas con primera región iluminada

### 5.2. Realización de Misión

1. **Detalle de misión**: Descripción, duración, procesos, recompensa
2. **Click "Iniciar"**: Carga del ejercicio (Three.js/Godot)
3. **Experiencia de juego**: Interacción con minijuego, telemetría en tiempo real
4. **Finalización**: Resumen con puntuación y descubrimiento
5. **Actualización del Atlas**: Iluminación de regiones trabajadas
6. **Diario**: Guardado del descubrimiento

### 5.3. Chat con Compañero

1. **Inicio**: TCCN inicia con observación basada en Behavioral Twin
2. **Respuesta del usuario**: Texto o selección rápida
3. **Procesamiento**: Análisis, actualización del Twin, nueva respuesta
4. **Respuesta del compañero**: Validación + observación + invitación
5. **Cierre**: Invitación a futura exploración

### 5.4. Videoterapia

1. **Notificación**: 15 minutos antes de la sesión
2. **Entrar**: Abre pantalla de videollamada integrada
3. **Durante**: Video + chat lateral + HUD clínico simplificado
4. **Fin**: Resumen de sesión (opcional)
5. **Post-sesión**: Actualización del Behavioral Twin

---

## 6. Gamificación Ética

### 6.1. Principios

| # | Principio | Manifestación |
|---|-----------|---------------|
| 1 | No monedas ni XP | Progreso medido con descubrimientos y habilidades |
| 2 | No leaderboards | Progreso personal e idiográfico |
| 3 | No castigos | Misiones no completadas permanecen disponibles |
| 4 | Recompensas funcionales | Descubrimientos con significado clínico |
| 5 | Curiosidad como motor | Motivación intrínseca por autodescubrimiento |
| 6 | Autonomía | Navegación no lineal, elección libre |
| 7 | Progreso visible | Atlas se ilumina gradualmente |

### 6.2. Sistema de Recompensas

| Recompensa | Disparador |
|------------|------------|
| Descubrimiento | Completar misión, reflexión en chat, post-sesión |
| Habilidad desbloqueada | Alcanzar nivel de exploración en proceso |
| Región iluminada | Completar misiones en región específica |
| Mensaje del compañero | Alcanzar hito (ej. 10 misiones) |
| Nivel del explorador | Acumular habilidades desbloqueadas |

### 6.3. Gestión de Momentum (no Streaks)

En lugar de rachas que generan ansiedad, el sistema mide la **dirección del cambio**:

- **Definición**: "Has tenido un buen momentum esta semana: completaste 4 misiones y practicaste la respiración 3 veces."
- **Visualización**: Barra de momentum en perfil/mapa (positivo, neutral, descendente)
- **Propósito**: Reflexión sobre dirección del cambio, no ansiedad por perder racha

---

## 7. Integración con Motores del Ecosistema

| Motor | Lectura | Escritura |
|-------|---------|-----------|
| **Behavioral Twin** | Atlas se basa en estado del Twin | Cada misión y chat actualiza el Twin |
| **TCCN** | Lee Twin para generar observaciones | Chat actualiza Twin (nuevos marcos RFT) |
| **AAO** | Lee Twin para ajustar evaluaciones | Evaluaciones actualizan Twin |
| **BERL** | Lee Twin para seleccionar misiones | Misiones actualizan Twin (telemetría) |
| **AHEE** | Lee Twin y preferencias para ajustar interfaz | Solo lee, no escribe |

---

## 8. Criterios de Validación

| Criterio | Métrica | Herramienta |
|----------|---------|-------------|
| Engagement | ≥70% completan 1 misión/semana | Analítica |
| Curiosidad | ≥80% interactúan con companion 1x/semana | Analítica |
| Adherencia | ≥60% continúan después de 30 días | Analítica |
| Satisfacción | ≥4.5/5 NPS | Encuestas |
| Descubrimientos | ≥2 promedio/semana | Analítica |
| Navegación | ≤3 clics a cualquier pantalla | Usabilidad |
| Tiempo de carga | <2s en 3G | Lighthouse |
| Accesibilidad | WCAG 2.1 AA | axe-core |
| Gamificación ética | 0% quejas sobre manipulación | Encuestas |
| Offline | Funcionamiento sin conexión verificado | Pruebas manuales |
| Streaming | Latencia <200ms en chat | Métricas backend |

---

## 9. El Manifiesto de la Experiencia Nintendo

> *"La experiencia del paciente no es una interfaz. Es un viaje.*
>
> *El usuario no es un caso clínico. Es un explorador que se adentra en el territorio de su propia conducta.*
>
> *El mapa del Atlas no es un dashboard. Es un mundo que se revela, región por región, descubrimiento por descubrimiento.*
>
> *El compañero no es un chatbot. Es un guía curioso, respetuoso y observador.*
>
> *El inventario no es una lista de logros. Es una colección de habilidades que el usuario ha cultivado.*
>
> *La gamificación no es una estrategia de retención. Es una herramienta para hacer que la práctica terapéutica sea intrínsecamente motivante.*
>
> *Nuestra responsabilidad es diseñar una experiencia que sea tan atractiva como un gran videojuego, pero tan rigurosa como la ciencia del comportamiento.*
>
> *Que el usuario quiera volver no porque tenga que hacerlo, sino porque está descubriendo algo nuevo sobre sí mismo."*

---

## 10. Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2026-07-01 | Diseño UX/UI | Creación inicial: filosofía Nintendo, navegación, pantallas, flujos, gamificación ética. |
| 2.0.0 | 2026-07-14 | Diseño UX/UI | Agregado: Arquitectura PWA + Three.js, Service Worker offline-first, IndexedDB, Background Sync, streaming SSE, Hub Central/Jardín Virtual 3D, migración Capacitor, integración con vLLM. |

---

**Fin del documento `patient-app.md`**
