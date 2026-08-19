---
id: BDS-001
title: Behavioral Design System (BDS)
version: 2.0.0
status: Stable
owner: Diseño UX/UI & Frontend Engineering
last_updated: 2026-07-14
depends_on:
  - 000-Core/philosophy.md (Filosofía)
  - 000-Core/principles.md (Principios)
  - 000-Core/vocabulary.md (Lenguaje)
  - 100-Architecture/system-architecture.md (BEA)
  - 100-Architecture/behavioral-twin.md (Behavioral Twin)
  - 300-Frontend/ahee-implementation.md (Adaptación AHEE)
exports:
  - Tokens de diseño (colores, tipografía, espaciado, iconografía)
  - Biblioteca de componentes (base y compuestos)
  - Patrones de interacción y microinteracciones
  - Guías de estilo diferenciadas: Nintendo (paciente) y Apple (terapeuta)
  - Principios Nintendo: charm, juicy feedback, curiosidad, descubrimiento
  - Principios Apple: claridad, productividad, deferencia
  - Adaptación dinámica del tema según proceso del paciente
  - Vocabulario controlado del BPO para la interfaz
  - Directrices de accesibilidad y adaptación
  - Estrategia de implementación técnica (React, Tailwind, Framer Motion)
used_by:
  - Patient App (Experiencia Nintendo)
  - Therapist App (Experiencia Apple)
  - Admin Dashboard
  - Component Library (Storybook)
  - BQAS (Pruebas de accesibilidad y consistencia visual)
---

# BehavioralOS – Behavioral Design System (BDS) (v2.0.0)

> *"El diseño no es solo cómo se ve algo. Es cómo funciona, cómo se siente, cómo comunica y cómo moldea la conducta. Cada píxel, cada animación, cada sonido debe estar al servicio del aprendizaje psicológico, la motivación y la información clínica."*

---

## 1. Propósito y Alcance

### 1.1. Propósito
El Behavioral Design System (BDS) es el **lenguaje visual e interactivo** unificado de todo el BehavioralOS. Su objetivo es:

- **Garantizar coherencia** visual y de interacción en todas las interfaces (paciente, terapeuta, administrador).
- **Materializar la filosofía del producto** (curiosidad, autonomía, competencia, etc.) en cada elemento de la interfaz.
- **Proveer una base técnica escalable** que permita evolucionar el diseño sin romper la consistencia.
- **Facilitar la accesibilidad** y la adaptación (AHEE) desde el diseño.
- **Diferenciar claramente** la experiencia del paciente (Nintendo) de la del terapeuta (Apple), manteniendo una base común.

### 1.2. Alcance
El BDS cubre:

- **Tokens de diseño**: Colores, tipografía, espaciado, iconografía, sombras, bordes, etc.
- **Componentes base**: Botones, inputs, tarjetas, modales, navegación, etc.
- **Componentes compuestos**: Tarjetas de misión, gráficos de procesos, dashboards, etc.
- **Patrones de interacción**: Feedback, microinteracciones, animaciones, transiciones.
- **Guías de estilo diferenciadas**: Nintendo (paciente) y Apple (terapeuta).
- **Accesibilidad**: WCAG 2.1 AA, adaptaciones cognitivas y sensoriales.
- **Integración con AHEE**: Variables de adaptación y mecanismos de cambio.
- **Principios de diseño Nintendo**: Charm, juicy feedback, curiosidad, descubrimiento.
- **Principios de diseño Apple**: Claridad, productividad, deferencia.
- **Adaptación dinámica del tema**: Según proceso del paciente y contexto clínico.
- **Vocabulario controlado BPO**: Lenguaje unificado para toda la interfaz.

### 1.3. Principio Fundamental
> **"Cada elemento de diseño debe responder a tres preguntas: ¿Qué emoción queremos evocar? ¿Qué conducta queremos facilitar? ¿Qué información clínica queremos comunicar? Si una decisión de diseño no responde a estas preguntas, no pertenece al BDS."**

---

## 2. Filosofía y Principios de Diseño

### 2.1. Los 12 Principios del BDS

| # | Principio | Descripción | Manifestación en diseño |
|---|-----------|-------------|-------------------------|
| 1 | **Toda pantalla debe provocar una conducta** | Nunca mostrar información pasivamente. | Cada pantalla tiene un CTA claro o una pregunta abierta. |
| 2 | **Reducir fricción, no esfuerzo** | Eliminar barreras para empezar, pero mantener desafío. | El usuario puede iniciar cualquier experiencia en ≤3 segundos. |
| 3 | **El feedback siempre debe enseñar** | Nunca decir "Correcto/Incorrecto". | Feedback observacional: "Observa cómo cambió tu respuesta". |
| 4 | **La incertidumbre debe generar curiosidad** | Usar preguntas abiertas y lenguaje exploratorio. | IA usa frases como "Interesante...", "¿Qué crees que pasaría si...?". |
| 5 | **El progreso debe ser funcional** | Mostrar cambio conductual observable. | Progreso en términos de conductas, no puntos. |
| 6 | **Las recompensas deben reforzar aprendizaje** | No monedas ni diamantes. | Recompensas son descubrimientos en el Diario. |
| 7 | **La IA nunca es protagonista** | El usuario es el centro. | IA habla en segunda persona, nunca en primera. |
| 8 | **Cada interacción debe respetar la autonomía** | Siempre hay opción de pausar, cambiar, posponer. | Botones de "saltar", "más tarde" o "cambiar". |
| 9 | **El error es información, no fracaso** | El error reduce incertidumbre. | Errores como "información nueva" en el Behavioral Twin. |
| 10 | **La experiencia termina en el mundo real** | El objetivo es una conducta fuera de la app. | Cada ejercicio termina con "misión en el mundo real". |
| 11 | **El tiempo de pantalla debe ser el mínimo necesario** | La app no busca retener; busca autonomía. | IA puede sugerir "Ya es suficiente por hoy". |
| 12 | **La plataforma debe hacerse innecesaria** | El éxito es la autonomía del usuario. | Modo mantenimiento de baja frecuencia después del alta. |

### 2.2. Principios Nintendo (Paciente) — Charm, Juicy Feedback, Curiosidad, Descubrimiento

| # | Principio | Descripción | Manifestación |
|---|-----------|-------------|---------------|
| 1 | **Charm (Encanto)** | Cada elemento debe tener personalidad y calidez visual. | Avatares expresivos, tipografía redondeada, colores cálidos, ilustraciones de personajes. |
| 2 | **Juicy Feedback** | Cada interacción debe producir una respuesta satisfactoria (visual, sonora, háptica). | Animaciones de partículas al completar, sonidos de "descubrimiento", vibración en móvil. |
| 3 | **Curiosidad** | El diseño debe invitar a explorar, nunca obligar. | Preguntas abiertas en lugar de instrucciones, mensajes que despiertan interés. |
| 4 | **Descubrimiento** | El progreso se experimenta como hallazgo personal, no como logro externo. | "Descubriste que tu evitación disminuye cuando respiras" en lugar de "+10 XP". |
| 5 | **Narrativa** | Cada pantalla es parte de una historia continua. | Misiones con narrativa, compagnon con personalidad, Atlas que evoluciona. |
| 6 | **Sin castigos** | Los errores se validan y transforman en aprendizaje. | "Interesante... ¿qué nos dice eso?" en lugar de "Error". |
| 7 | **Flow automático** | La dificultad se ajusta para mantener al usuario en su zona óptima. | AHEE ajusta complejidad según rendimiento y estado emocional. |

### 2.3. Principios Apple (Terapeuta) — Claridad, Productividad, Deferencia

| # | Principio | Descripción | Manifestación |
|---|-----------|-------------|---------------|
| 1 | **Claridad** | La información debe ser inmediatamente comprensible. | Tipografía precisa, jerarquía visual clara, espaciado generoso. |
| 2 | **Productividad** | El terapeuta debe realizar tareas complejas con mínimo esfuerzo. | Atajos de teclado, acciones rápidas, información densa pero organizada. |
| 3 | **Deferencia** | El diseño se hace a un lado para que el contenido brille. | Interface minimalista, sin decoración excesiva, colores neutros. |
| 4 | **Profesionalismo** | Cada elemento comunica seriedad y confianza clínica. | Paleta fría, tipografía moderna, sin gamificación visible. |
| 5 | **Eficiencia cognitiva** | Minimizar la carga mental del terapeuta. | Dashboards preconfigurados, alertas contextuales, auto-llenado. |

### 2.4. Adaptación Dinámica del Tema

El BDS soporta **cambio dinámico de tema** según el contexto clínico del paciente:

| Contexto | Tema aplicado | Cambios |
|----------|---------------|---------|
| **Sesión normal** | Nintendo estándar | Colores cálidos, animaciones completas |
| **Mood bajo detectado** | Nintendo suave | Colores más suaves, menos estímulos, tipografía más grande |
| **Crisis activa** | Interfaz de emergencia | Colores neutros, sin gamificación, información de emergencia prominente |
| **Sesión de terapeuta** | Apple completo | Interface profesional, densa, con datos clínicos |
| **Modo nocturno** | Tema oscuro automático | Detección de `prefers-color-scheme`, colores adaptados |

### 2.5. Vocabulario Controlado del BPO

Todos los textos de la interfaz deben usar el vocabulario controlado definido en `000-Core/vocabulary.md`:

| Contexto | Prohibido | Permitido | Ejemplo |
|----------|-----------|-----------|---------|
| **General** | Paciente | Explorador | "El explorador completó la misión" |
| **Misiones** | Ejercicio, Tarea | Misión, Expedición | "Inicia la expedición de regulación" |
| **Progreso** | Síntoma | Patrón, Señal | "Observamos un patrón de sueño" |
| **Resultado** | Fracaso, Error | Experimento | "El experimento nos dio información" |
| **Logro** | Cumplir, Completar | Descubrir, Explorar | "Descubriste un nuevo patrón" |
| **Evolución** | Mejoría | Crecimiento, Flexibilidad | "Desarrollaste la habilidad de..." |
| **Recaída** | Recaída | Nuevo aprendizaje | "Apareció un patrón conocido en nuevo contexto" |
| **Cierre** | Alta | Transición, Nueva etapa | "El explorador entra en entrenamiento continuo" |

---

## 3. Tokens de Diseño

### 3.1. Paleta de Colores

#### 3.1.1. Colores Base (Compartidos)

| Token | Hex | Uso |
|-------|-----|-----|
| `--color-primary` | `#4A6CF7` | Acciones principales, enlaces |
| `--color-primary-hover` | `#3A56C7` | Hover de acciones principales |
| `--color-secondary` | `#6C5CE7` | Acciones secundarias, destacados |
| `--color-success` | `#00B894` | Éxito, confirmación |
| `--color-warning` | `#FDCB6E` | Advertencia, atención |
| `--color-danger` | `#E17055` | Error, peligro |
| `--color-surface` | `#FFFFFF` | Fondo de superficies |
| `--color-background` | `#F8F9FA` | Fondo general |
| `--color-text-primary` | `#2D3436` | Texto principal |
| `--color-text-secondary` | `#636E72` | Texto secundario |
| `--color-text-muted` | `#B2BEC3` | Texto desactivado |

#### 3.1.2. Colores Experiencia Paciente (Nintendo)

| Token | Hex | Uso | Justificación |
|-------|-----|-----|---------------|
| `--color-nintendo-primary` | `#FF6B6B` | Botones principales, acentos | Calidez, energía, emoción |
| `--color-nintendo-secondary` | `#FECA57` | Destacados, logros, recompensas | Alegría, optimismo, descubrimiento |
| `--color-nintendo-tertiary` | `#48DBFB` | Elementos interactivos, exploración | Curiosidad, apertura, calma |
| `--color-nintendo-background` | `#FFF8E7` | Fondos de pantalla | Cálido, acogedor, no clínico |
| `--color-nintendo-surface` | `#FFFFFF` | Tarjetas, paneles | Limpio, sombras suaves |
| `--color-nintendo-text` | `#2D3436` | Texto principal | Legible, alto contraste |
| `--color-nintendo-glow` | `#FFD93D` | Efectos de glow, partículas | Sensación de magia, descubrimiento |

#### 3.1.3. Colores Experiencia Terapeuta (Apple)

| Token | Hex | Uso | Justificación |
|-------|-----|-----|---------------|
| `--color-apple-primary` | `#007AFF` | Acciones principales | Confianza, profesionalismo, claridad |
| `--color-apple-secondary` | `#5856D6` | Acciones secundarias | Profundidad, seriedad |
| `--color-apple-background` | `#F5F5F7` | Fondo general | Neutro, minimalista, elegante |
| `--color-apple-surface` | `#FFFFFF` | Tarjetas, paneles | Limpio, sombras sutiles |
| `--color-apple-text` | `#1C1C1E` | Texto principal | Alto contraste, legible |
| `--color-apple-text-secondary` | `#8E8E93` | Texto secundario | Suave, informativo |
| `--color-apple-divider` | `#C6C6C8` | Separadores | Sutil, no intrusivo |

### 3.2. Tipografía

- **Paciente (Nintendo)**: `"Quicksand", "Nunito", sans-serif` – Redondeada, amigable, cálida.
- **Terapeuta (Apple)**: `"Inter", "SF Pro Display", sans-serif` – Moderna, limpia, precisa.
- **Base (compartida)**: `system-ui, -apple-system, sans-serif` (fallback).

#### Escala Tipográfica

| Token | Tamaño | Peso | Uso |
|-------|--------|------|-----|
| `--font-size-xs` | 12px | 400 | Notas al pie |
| `--font-size-sm` | 14px | 400 | Texto secundario |
| `--font-size-base` | 16px | 400 | Texto base |
| `--font-size-md` | 18px | 500 | Subtítulos, tarjetas |
| `--font-size-lg` | 24px | 600 | Títulos de sección |
| `--font-size-xl` | 32px | 700 | Títulos principales |
| `--font-size-2xl` | 40px | 800 | Títulos de pantalla |
| `--font-size-3xl` | 56px | 800 | Títulos hero |

### 3.3. Espaciado (Escala de 4px)

| Token | Valor | Uso |
|-------|-------|-----|
| `--space-1` | 4px | Muy pequeño |
| `--space-2` | 8px | Pequeño |
| `--space-3` | 12px | Medio pequeño |
| `--space-4` | 16px | Medio |
| `--space-5` | 24px | Medio grande |
| `--space-6` | 32px | Grande |
| `--space-7` | 48px | Muy grande |
| `--space-8` | 64px | Extra grande |

### 3.4. Sombras y Bordes

| Token | Valor | Uso |
|-------|-------|-----|
| `--shadow-sm` | `0 1px 3px rgba(0,0,0,0.12)` | Sutil |
| `--shadow-md` | `0 4px 12px rgba(0,0,0,0.15)` | Medio |
| `--shadow-lg` | `0 8px 24px rgba(0,0,0,0.20)` | Grande |
| `--shadow-xl` | `0 16px 48px rgba(0,0,0,0.25)` | Extra grande |
| `--radius-sm` | 4px | Esquinas ligeras |
| `--radius-md` | 8px | Estándar |
| `--radius-lg` | 16px | Redondeado pronunciado |
| `--radius-xl` | 24px | Muy redondeado (gamificación) |
| `--radius-full` | 9999px | Circular |

---

## 4. Componentes Base

### 4.1. Botones

| Variante | Uso | Estilo (Paciente) | Estilo (Terapeuta) |
|----------|-----|-------------------|---------------------|
| **Primario** | Acción principal | Fondo nintendo-primary, sombra, escala hover | Fondo apple-primary |
| **Secundario** | Acción secundaria | Borde nintendo-secondary | Borde apple-secondary |
| **Terciario** | Acción sutil | Texto sin fondo | Texto sin fondo |
| **Destructivo** | Eliminar, cancelar | Fondo danger | Fondo danger |
| **Gamificado** | Desbloqueos | Gradiente + brillo + confeti | No aplica |

### 4.2. Inputs y Formularios

| Componente | Estilo (Paciente) | Estilo (Terapeuta) |
|------------|-------------------|---------------------|
| Input texto | Borde redondeado, sombra suave | Borde cuadrado, borde gris |
| Textarea | Igual + altura mín 80px | Igual + altura mín 100px |
| Select | Nativo mejorado con flecha | Nativo mejorado |
| Checkbox | Animación de "marca" | Animación sutil |
| Slider | Estilo gamificado con colores | Minimalista con etiquetas |

### 4.3. Tarjetas

| Componente | Estilo (Paciente) | Estilo (Terapeuta) |
|------------|-------------------|---------------------|
| Tarjeta de misión | Borde radius-xl, sombra-md, ilustración | Borde radius-md, sombra-sm, información densa |
| Tarjeta de paciente | Foto, nombre, última interacción | Foto, nombre, último proceso, riesgo |

---

## 5. Microinteracciones y Animaciones

### 5.1. Feedback Inmediato (Nintendo)

| Interacción | Animación | Propósito |
|-------------|-----------|-----------|
| Click en botón | Escala 0.95→1.0 (100ms) + sonido | Confirmar acción |
| Completar misión | Confeti + badge + sonido logro | Reforzar éxito |
| Error en ejercicio | Vibración suave + "Interesante..." | Reducir frustración |
| Desbloquear habilidad | Brillo alrededor + sonido nivel up | Celebrar progreso |
| Pasar pantalla | Transición slide con aceleración | Mantener fluidez |

### 5.2. Feedback Discreto (Apple)

| Interacción | Animación | Propósito |
|-------------|-----------|-----------|
| Click en botón | Cambio de color sutil (150ms) | Confirmar sin distraer |
| Guardar nota | Indicador "guardado" que se desvanece | Confirmar sin interrupción |
| Actualizar datos | Spinner → checkmark | Comunicar progreso |
| Pasar pantalla | Transición fade (200ms) | Mantener enfoque |

### 5.3. Transiciones

| Transición | Duración | Easing | Uso |
|------------|----------|--------|-----|
| Fade | 200ms | ease-in-out | Cambios sutiles |
| Slide | 300ms | cubic-bezier(0.4,0,0.2,1) | Navegación |
| Scale | 200ms | ease-out | Modales, tarjetas |
| Spring | 500ms | spring | Gamificación |

---

## 6. Accesibilidad y Adaptación (AHEE)

### 6.1. WCAG 2.1 AA

| Criterio | Implementación |
|----------|----------------|
| Contraste | ≥4.5:1 texto normal, ≥3:1 texto grande |
| Navegación teclado | Todos los interactivos accesibles (Tab, Enter, Space) |
| Lectores de pantalla | Etiquetas ARIA correctas |
| Tamaño texto | Escalable con rem/em |
| Movimiento reducido | Soporte `prefers-reduced-motion` |
| Enfoque visible | Outline claro en enfocados |

### 6.2. Adaptaciones Cognitivas

| Adaptación | Implementación | Activación |
|------------|----------------|------------|
| Alto Contraste | Aumenta contraste, elimina fondos sutiles | Automático (AHEE) o manual |
| Baja Estimulación | Reduce animaciones, colores suaves | Automático (AHEE) o manual |
| Dislexia | OpenDyslexic, espaciado aumentado | Manual |
| TDAH | Reduce distracciones, simplifica interfaz | Automático (AHEE) o manual |
| Adulto Mayor | Tipografía grande, botones grandes | Automático (AHEE) o manual |
| Daltonismo | Paleta adaptada (deuteranopía, protanopía, tritanopía) | Automático (AHEE) o manual |

---

## 7. Implementación Técnica

### 7.1. Stack

| Componente | Tecnología |
|------------|------------|
| Framework | React 19 |
| Lenguaje | TypeScript |
| Estilos | Tailwind CSS 4.0 |
| Animaciones | Framer Motion 11 |
| Iconos | Lucide Icons |
| Componentes | Radix UI |
| Estado | Zustand |
| Formularios | React Hook Form + Zod |
| Gráficos | Recharts / D3.js |
| Storybook | Storybook 8 |
| 3D | Three.js |
| PWA | Service Workers, IndexedDB |
| Migración nativa | Capacitor |

---

## 8. Criterios de Validación

| Criterio | Métrica | Herramienta |
|----------|---------|-------------|
| Accesibilidad | 100% componentes WCAG AA | axe-core, Lighthouse |
| Consistencia visual | 0% regresiones visuales | Chromatic (Storybook) |
| Rendimiento | <2s carga en 3G | Lighthouse, Web Vitals |
| Adaptación AHEE | Interfaz cambia según variables | Pruebas integración |
| Vocabulario controlado | 0% palabras prohibidas | Linter UI |
| Gamificación ética | Recompensas funcionales, no adictivas | Revisión diseño |

---

## 9. Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2026-07-01 | Diseño UX/UI | Creación inicial: tokens, componentes, microinteracciones, guías diferenciadas, accesibilidad. |
| 2.0.0 | 2026-07-14 | Diseño UX/UI | Agregado: Principios Nintendo (charm, juicy feedback, curiosidad, descubrimiento), Principios Apple (claridad, productividad, deferencia), adaptación dinámica de tema, vocabulario controlado BPO integrado. |

---

**Fin del documento `design-system.md`**
