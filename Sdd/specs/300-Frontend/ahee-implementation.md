---
id: AHEE-001
title: Integración del Motor Adaptativo (AHEE)
version: 1.0.0
status: Stable
owner: Diseño UX/UI & Frontend Engineering
last_updated: 2026-07-01
depends_on:
  - 000-Core/philosophy.md (Filosofía - personalización)
  - 000-Core/principles.md (Principios - autonomía, adaptación)
  - 300-Frontend/design-system.md (BDS - tokens adaptables)
  - 300-Frontend/ui-graph.md (UI Graph - navegación adaptativa)
  - 300-Frontend/accessibility.md (Accesibilidad - adaptaciones)
  - 300-Frontend/patient-app.md (Experiencia Nintendo - adaptación)
  - 300-Frontend/therapist-app.md (Experiencia Apple - adaptación)
  - 400-AI/adaptive-orchestrator.md (AAO - estado emocional y procesos)
  - 100-Architecture/behavioral-twin.md (Behavioral Twin - perfil del usuario)
  - 500-Experiencies/ahee-engine.md (Motor AHEE - lógica de adaptación)
exports:
  - Variables de adaptación (edad, estado emocional, fatiga, preferencias, etc.)
  - Mecanismos de cambio (colores, tipografía, animaciones, complejidad, narrativa, duración)
  - Estrategia de implementación técnica (CSS variables, React Context, hooks, etc.)
  - Integración con Behavioral Twin y AAO (fuentes de datos)
  - Casos de uso y ejemplos de adaptación
  - Criterios de validación y métricas de éxito
used_by:
  - Frontend Engineers (implementación de la adaptación)
  - UX/UI Designers (diseño de adaptaciones)
  - QA (pruebas de adaptación)
  - Psicólogos clínicos (validación de la personalización)
---

# BehavioralOS – Integración del Motor Adaptativo (AHEE)

> *"La experiencia no debe ser la misma para todos. Cada persona es única: su edad, su estado emocional, su nivel de fatiga, sus preferencias y su historia de aprendizaje moldean cómo percibe y responde a la interfaz. AHEE es el motor que convierte la uniformidad en personalización, haciendo que cada interacción se sienta diseñada específicamente para ese usuario en ese momento."*

---

## 1. Propósito y Alcance

### 1.1. Propósito
Este documento define la **integración del motor adaptativo AHEE (Adaptive Human Experience Engine)** con el frontend del BehavioralOS. Su objetivo es:

- **Especificar las variables de adaptación** que AHEE utiliza para personalizar la experiencia del usuario.
- **Definir los mecanismos de cambio** (colores, tipografía, animaciones, complejidad de la interfaz, narrativa, duración de misiones, etc.) que AHEE puede modificar en tiempo real.
- **Establecer la estrategia de implementación técnica** (CSS variables, React Context, hooks, etc.) para que el frontend reaccione a los cambios de AHEE de manera eficiente.
- **Integrar AHEE con el Behavioral Twin y el AAO** para obtener datos sobre el perfil del usuario, su estado emocional y sus preferencias.
- **Proveer ejemplos de adaptación** y casos de uso concretos.
- **Definir criterios de validación** para garantizar que la adaptación sea efectiva y ética.

### 1.2. Alcance
El documento cubre:

- **Fuentes de datos**: Behavioral Twin (perfil, procesos, valores), AAO (estado emocional, fatiga, cognición), preferencias explícitas (configuración del usuario).
- **Variables de adaptación**: Edad, estado emocional, fatiga, nivel de habilidad, preferencias (colores, tipografía, animaciones, etc.), dispositivo, hora del día.
- **Mecanismos de cambio**: Tamaño de fuente, contraste, animaciones, complejidad de la interfaz, narrativa, duración de misiones, lenguaje (concreto/abstracto), tipografía (dislexia), modo oscuro/claro.
- **Estrategia de implementación**: CSS custom properties, React Context, hooks (`useAHEE`), almacenamiento local, sincronización con el backend.
- **Casos de uso**: Ejemplos de adaptación en tiempo real para diferentes perfiles.
- **Criterios de validación**: Métricas de satisfacción, usabilidad, adherencia, accesibilidad.

### 1.3. Principio Fundamental
> **"La adaptación no es un lujo. Es una necesidad para garantizar que la experiencia del BehavioralOS sea inclusiva, efectiva y ética. AHEE no solo personaliza la interfaz; también respeta la autonomía del usuario, permitiéndole ajustar manualmente las configuraciones cuando lo desee."**

---

## 2. Fuentes de Datos para la Adaptación

AHEE obtiene información de múltiples fuentes para construir un **perfil de adaptación** del usuario. Este perfil se actualiza en tiempo real a medida que el usuario interactúa con el sistema.

### 2.1. Behavioral Twin (Perfil del Usuario)

| Variable | Fuente | Descripción | Rango/Ejemplo |
|----------|--------|-------------|---------------|
| **Edad** | Perfil del usuario (registro) | Edad en años. | 6-12 (niño), 13-18 (adolescente), 19-64 (adulto), 65+ (adulto mayor). |
| **Procesos psicológicos** | AAO, evaluaciones | Estado de los procesos (Aceptación, Defusión, etc.). | 0-100% (ej. "Aceptación: 65%"). |
| **Valores** | Perfil del usuario, sesiones | Valores ACT del usuario. | Array de valores (ej. ["Conexión familiar", "Crecimiento"]). |
| **Hipótesis activas** | AAO, terapeuta | Hipótesis funcionales activas. | Array de hipótesis. |
| **Nivel de habilidad** | BERL, ejercicios | Nivel de competencia en habilidades psicológicas. | 1-5 (estrellas). |

### 2.2. AAO (Estado Emocional y Cognitivo)

| Variable | Fuente | Descripción | Rango/Ejemplo |
|----------|--------|-------------|---------------|
| **Estado emocional** | AAO (análisis de lenguaje, prosodia, EMA) | Estado emocional estimado del usuario. | `calm`, `anxious`, `sad`, `angry`, `happy`, `neutral`. |
| **Nivel de fatiga** | AAO (telemetría, EMA) | Nivel de fatiga estimado del usuario. | 0-100 (0 = sin fatiga, 100 = fatiga extrema). |
| **Nivel de estrés** | AAO (análisis de lenguaje, prosodia) | Nivel de estrés estimado. | 0-100. |
| **Estado de sueño** | AAO (EMA, wearables) | Calidad del sueño reportada. | 0-100. |
| **Cognición** | AAO (jsPsych, Godot) | Funciones ejecutivas estimadas (atención, memoria, inhibición). | 0-100 (ej. "Control inhibitorio: 70%"). |

### 2.3. Preferencias Explícitas del Usuario

| Variable | Fuente | Descripción | Rango/Ejemplo |
|----------|--------|-------------|---------------|
| **Tema visual** | Configuración del usuario | Tema claro u oscuro. | `light`, `dark`. |
| **Tamaño de fuente** | Configuración del usuario | Tamaño de fuente preferido. | `small`, `medium`, `large`, `x-large`. |
| **Modo de accesibilidad** | Configuración del usuario | Modo activado (ej. "Dislexia", "Alto contraste", "TEA"). | Array de modos. |
| **Preferencia de animaciones** | Configuración del usuario | Nivel de animaciones preferido. | `full` (todas), `reduced` (reducidas), `none` (sin animaciones). |
| **Idioma** | Configuración del usuario | Idioma de la interfaz. | `es`, `en`, etc. |
| **Preferencia de metáforas** | Configuración del usuario | Tipo de metáforas preferidas. | `nature`, `space`, `technology`, `fantasy`, `sports`. |

### 2.4. Datos Contextuales

| Variable | Fuente | Descripción | Rango/Ejemplo |
|----------|--------|-------------|---------------|
| **Hora del día** | Reloj del dispositivo | Hora actual. | `morning`, `afternoon`, `evening`, `night`. |
| **Dispositivo** | Detección automática | Tipo de dispositivo. | `mobile`, `tablet`, `desktop`. |
| **Día de la semana** | Calendario | Día actual. | `monday`, `tuesday`, etc. |
| **Tiempo de uso** | Analítica de uso | Tiempo que el usuario ha estado usando la app hoy. | 0-∞ minutos. |

---

## 3. Mecanismos de Cambio (Adaptaciones)

AHEE puede modificar los siguientes aspectos de la interfaz en tiempo real:

### 3.1. Visuales (CSS y Estilos)

| Mecanismo | Variables de AHEE | Implementación Técnica | Ejemplo de Cambio |
|-----------|-------------------|------------------------|-------------------|
| **Tamaño de fuente** | `fontSize` | CSS custom properties (`--font-size-base`) | `medium` → `large` (para adultos mayores). |
| **Contraste de color** | `contrast` | CSS custom properties (`--color-text`, `--color-background`) | `normal` → `high-contrast` (para baja visión). |
| **Paleta de colores** | `colorTheme` | CSS custom properties (`--color-primary`, `--color-secondary`, etc.) | `default` → `dyslexia` (para dislexia, fondo amarillo). |
| **Espaciado** | `spacing` | CSS custom properties (`--space-1` a `--space-8`) | `normal` → `large` (para dificultades de lectura). |
| **Modo oscuro/claro** | `theme` | CSS custom properties + `prefers-color-scheme` | `light` → `dark` (por preferencia o hora del día). |
| **Animaciones** | `animations` | CSS (`animation`, `transition`) + Framer Motion | `full` → `reduced` (para TEA, TDAH, fatiga). |
| **Redondez de bordes** | `borderRadius` | CSS custom properties (`--radius-sm`, `--radius-md`, etc.) | `normal` → `rounded` (para niños). |
| **Tipografía** | `fontFamily` | CSS custom properties (`--font-family`) | `Inter` → `OpenDyslexic` (para dislexia). |

### 3.2. Interacción y Navegación

| Mecanismo | Variables de AHEE | Implementación Técnica | Ejemplo de Cambio |
|-----------|-------------------|------------------------|-------------------|
| **Complejidad de la interfaz** | `complexity` | Mostrar/ocultar elementos UI (botones, menús, información). | `full` → `simplified` (para TEA, discapacidad intelectual). |
| **Duración de misiones** | `missionDuration` | Ajustar la duración de las misiones. | `normal` (5-8 min) → `short` (2-3 min) (para niños, TDAH, fatiga). |
| **Feedback** | `feedbackIntensity` | Intensidad del feedback (visual, auditivo, háptico). | `high` → `medium` (para TEA, fatiga). |
| **Navegación** | `navigationStyle` | Estilo de navegación (bottom nav, sidebar, etc.). | `default` → `simple` (para niños, adultos mayores). |
| **Gestos** | `gestures` | Gestos activados/desactivados. | `full` → `basic` (solo tap y deslizar). |

### 3.3. Contenido y Narrativa

| Mecanismo | Variables de AHEE | Implementación Técnica | Ejemplo de Cambio |
|-----------|-------------------|------------------------|-------------------|
| **Lenguaje** | `languageComplexity` | Complejidad del lenguaje en textos y diálogos del TCCN. | `abstract` → `concrete` (para niños, discapacidad intelectual). |
| **Metáforas** | `metaphorType` | Tipo de metáforas utilizadas en las narrativas. | `nature` → `space` (por preferencias del usuario). |
| **Narrativa** | `storyTheme` | Tema de la narrativa (ej. "Bosque", "Montaña", "Ciudad"). | `default` → `fantasy` (para niños). |
| **Personajes** | `characterStyle` | Estilo visual de los personajes (ej. compañero). | `realistic` → `cartoon` (para niños). |

### 3.4. Gamificación

| Mecanismo | Variables de AHEE | Implementación Técnica | Ejemplo de Cambio |
|-----------|-------------------|------------------------|-------------------|
| **Frecuencia de recompensas** | `rewardFrequency` | Frecuencia de las recompensas (descubrimientos, habilidades). | `normal` → `frequent` (para niños, TDAH). |
| **Dificultad de misiones** | `missionDifficulty` | Dificultad de las misiones (ajustada por AHEE). | `normal` → `easy` (para adultos mayores, fatiga). |
| **Tipo de recompensa** | `rewardType` | Tipo de recompensa (descubrimiento, habilidad, mensaje del compañero). | `discovery` → `skill` (por preferencias del usuario). |

---

## 4. Estrategia de Implementación Técnica

### 4.1. Arquitectura de Adaptación
┌─────────────────────────────────────────────────────────────────────────┐
│ Frontend (React) │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ AHEE Provider (React Context) │ │
│ │ • Almacena el perfil de adaptación actual. │ │
│ │ • Escucha cambios en el Behavioral Twin y el AAO. │ │
│ │ • Aplica cambios al DOM mediante CSS variables. │ │
│ └─────────────────────────────────────────────────────────────────┘ │
│ │
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ useAHEE Hook (React) │ │
│ │ • Proporciona acceso al perfil de adaptación. │ │
│ │ • Permite a los componentes reaccionar a cambios. │ │
│ └─────────────────────────────────────────────────────────────────┘ │
│ │
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ AHEE Service (API) │ │
│ │ • Obtiene datos del Behavioral Twin y el AAO. │ │
│ │ • Calcula el perfil de adaptación. │ │
│ │ • Almacena preferencias explícitas del usuario. │ │
│ └─────────────────────────────────────────────────────────────────┘ │
│ │
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ AHEE Engine (Backend) │ │
│ │ • Lógica de adaptación (reglas difusas, algoritmos). │ │
│ │ • Decisión de cambios. │ │
│ └─────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────┘


### 4.2. CSS Custom Properties (Variables de Adaptación)

Las variables de adaptación se definen como **CSS custom properties** en el nivel `:root` y se actualizan dinámicamente a través de JavaScript.

```css
:root {
  /* Variables de tamaño de fuente */
  --font-size-xs: 12px;
  --font-size-sm: 14px;
  --font-size-base: 16px;
  --font-size-md: 18px;
  --font-size-lg: 24px;
  --font-size-xl: 32px;
  --font-size-2xl: 40px;
  --font-size-3xl: 56px;

  /* Variables de contraste */
  --color-text: #2D3436;
  --color-background: #F8F9FA;
  --color-surface: #FFFFFF;
  --color-primary: #4A6CF7;

  /* Variables de espaciado */
  --space-1: 4px;
  --space-2: 8px;
  --space-3: 12px;
  --space-4: 16px;
  --space-5: 24px;
  --space-6: 32px;
  --space-7: 48px;
  --space-8: 64px;

  /* Variables de animación */
  --animation-duration: 0.3s;
  --animation-easing: ease-in-out;

  /* Variables de tipografía */
  --font-family: "Inter", system-ui, sans-serif;

  /* Variables de bordes */
  --radius-sm: 4px;
  --radius-md: 8px;
  --radius-lg: 16px;
  --radius-xl: 24px;
  --radius-full: 9999px;
}

Actualización dinámica (desde JavaScript):

// Aplicar perfil de adaptación
function applyAdaptationProfile(profile) {
  const root = document.documentElement;

  // Tamaño de fuente
  const fontSizes = {
    small: { '--font-size-base': '14px', '--font-size-lg': '20px' },
    medium: { '--font-size-base': '16px', '--font-size-lg': '24px' },
    large: { '--font-size-base': '18px', '--font-size-lg': '28px' },
    xlarge: { '--font-size-base': '20px', '--font-size-lg': '32px' }
  };
  Object.entries(fontSizes[profile.fontSize]).forEach(([key, value]) => {
    root.style.setProperty(key, value);
  });

  // Contraste
  const contrastLevels = {
    normal: { '--color-text': '#2D3436', '--color-background': '#F8F9FA' },
    high: { '--color-text': '#1A1A1A', '--color-background': '#FFFFFF' }
  };
  Object.entries(contrastLevels[profile.contrast]).forEach(([key, value]) => {
    root.style.setProperty(key, value);
  });

  // Paleta de colores para daltonismo
  if (profile.colorTheme === 'dyslexia') {
    root.style.setProperty('--color-background', '#FFF9E6');
    root.style.setProperty('--color-text', '#1A1A1A');
    root.style.setProperty('--color-primary', '#4A6CF7');
  }

  // Animaciones
  if (profile.animations === 'reduced') {
    root.style.setProperty('--animation-duration', '0.01s');
    root.style.setProperty('--animation-easing', 'linear');
  } else if (profile.animations === 'none') {
    root.style.setProperty('--animation-duration', '0s');
    root.style.setProperty('--animation-easing', 'linear');
  } else {
    root.style.setProperty('--animation-duration', '0.3s');
    root.style.setProperty('--animation-easing', 'ease-in-out');
  }

  // Tipografía para dislexia
  if (profile.fontFamily === 'dyslexic') {
    root.style.setProperty('--font-family', '"OpenDyslexic", "Inter", system-ui, sans-serif');
  } else {
    root.style.setProperty('--font-family', '"Inter", system-ui, sans-serif');
  }

  // Espaciado
  const spacings = {
    small: { '--space-4': '12px', '--space-6': '24px', '--space-8': '48px' },
    normal: { '--space-4': '16px', '--space-6': '32px', '--space-8': '64px' },
    large: { '--space-4': '24px', '--space-6': '48px', '--space-8': '80px' }
  };
  Object.entries(spacings[profile.spacing]).forEach(([key, value]) => {
    root.style.setProperty(key, value);
  });
}

4.3. React Context y Hooks
AHEE Context:
// ahee-context.js
import React, { createContext, useContext, useState, useEffect } from 'react';
import { fetchAdaptationProfile, subscribeToProfileChanges } from '../services/ahee';

const AHEEContext = createContext();

export const AHEEProvider = ({ children }) => {
  const [profile, setProfile] = useState(null);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    // Cargar perfil inicial
    const loadProfile = async () => {
      const initialProfile = await fetchAdaptationProfile();
      setProfile(initialProfile);
      setIsLoading(false);
    };
    loadProfile();

    // Suscribirse a cambios en el perfil (desde Behavioral Twin o AAO)
    const unsubscribe = subscribeToProfileChanges((updatedProfile) => {
      setProfile(updatedProfile);
      applyAdaptationProfile(updatedProfile);
    });

    return () => unsubscribe();
  }, []);

  return (
    <AHEEContext.Provider value={{ profile, isLoading }}>
      {children}
    </AHEEContext.Provider>
  );
};

export const useAHEE = () => {
  const context = useContext(AHEEContext);
  if (!context) {
    throw new Error('useAHEE must be used within an AHEEProvider');
  }
  return context;
};

Hook de adaptación en componentes:

// mission-card.js
import React from 'react';
import { useAHEE } from '../ahee-context';

const MissionCard = ({ mission }) => {
  const { profile } = useAHEE();

  // Obtener tamaño de fuente dinámico
  const getFontSize = () => {
    switch (profile.fontSize) {
      case 'small': return 'text-sm';
      case 'large': return 'text-lg';
      case 'xlarge': return 'text-xl';
      default: return 'text-base';
    }
  };

  // Obtener tamaño de tarjeta dinámico
  const getCardSize = () => {
    if (profile.complexity === 'simplified') {
      return 'p-4 mb-2';
    }
    return 'p-6 mb-4';
  };

  // Obtener duración de misión (simplificada)
  const getMissionDuration = () => {
    if (profile.missionDuration === 'short') {
      return `${Math.min(3, mission.duration)} min`;
    }
    return `${mission.duration} min`;
  };

  return (
    <div className={`card ${getCardSize()} ${getFontSize()}`}>
      <h3>{mission.title}</h3>
      <p>{mission.description}</p>
      <p>Duración: {getMissionDuration()}</p>
      <button className="btn-primary">Iniciar</button>
    </div>
  );
};

4.4. Servicio AHEE (Backend)
El servicio AHEE en el backend calcula el perfil de adaptación basado en:

Perfil del usuario (Behavioral Twin): edad, procesos, nivel de habilidad.

Estado emocional y cognitivo (AAO): estado emocional, fatiga, estrés.

Preferencias explícitas (base de datos): tema, tamaño de fuente, modos de accesibilidad.

Datos contextuales (dispositivo, hora del día).

Lógica de decisión (reglas difusas):

# ahee_engine.py
from fuzzy import FuzzyLogic

class AHEEEngine:
    def __init__(self, twin, aao, preferences, context):
        self.twin = twin
        self.aao = aao
        self.preferences = preferences
        self.context = context

    def calculate_profile(self):
        profile = {
            'fontSize': 'medium',
            'contrast': 'normal',
            'animations': 'full',
            'complexity': 'full',
            'missionDuration': 'normal',
            'languageComplexity': 'abstract',
            'metaphorType': 'nature',
            'colorTheme': 'default',
            'fontFamily': 'default',
            'spacing': 'normal',
            'theme': 'light',
        }

        # 1. Ajuste por edad
        if self.twin.age < 13:
            profile['fontSize'] = 'large'
            profile['languageComplexity'] = 'concrete'
            profile['metaphorType'] = 'fantasy'
            profile['missionDuration'] = 'short'
            profile['complexity'] = 'simplified'
        elif self.twin.age >= 65:
            profile['fontSize'] = 'xlarge'
            profile['contrast'] = 'high'
            profile['missionDuration'] = 'short'

        # 2. Ajuste por estado emocional (AAO)
        if self.aao.emotion == 'anxious':
            profile['animations'] = 'reduced'
            profile['complexity'] = 'simplified'
            profile['missionDuration'] = 'short'
        elif self.aao.emotion == 'sad':
            profile['animations'] = 'reduced'
            profile['languageComplexity'] = 'concrete'
            profile['metaphorType'] = 'nature'

        # 3. Ajuste por fatiga
        if self.aao.fatigue > 70:
            profile['animations'] = 'reduced'
            profile['complexity'] = 'simplified'
            profile['missionDuration'] = 'short'
        elif self.aao.fatigue > 50:
            profile['animations'] = 'reduced'
            profile['missionDuration'] = 'short'

        # 4. Ajuste por preferencias explícitas
        if self.preferences.get('dyslexia'):
            profile['fontFamily'] = 'dyslexic'
            profile['fontSize'] = 'large'
            profile['spacing'] = 'large'
        if self.preferences.get('high_contrast'):
            profile['contrast'] = 'high'
        if self.preferences.get('tea'):
            profile['animations'] = 'reduced'
            profile['complexity'] = 'simplified'
            profile['languageComplexity'] = 'concrete'
        if self.preferences.get('adhd'):
            profile['animations'] = 'reduced'
            profile['complexity'] = 'simplified'
            profile['missionDuration'] = 'short'

        # 5. Ajuste por hora del día
        if self.context.hour in ['night', 'evening']:
            profile['theme'] = 'dark'
            profile['animations'] = 'reduced'

        # 6. Ajuste por dispositivo
        if self.context.device == 'mobile':
            profile['complexity'] = 'simplified'
            profile['fontSize'] = 'medium'

        return profile

5. Casos de Uso y Ejemplos de Adaptación
5.1. Caso 1: Usuario Niño (8 años) con TEA
Perfil:

Edad: 8 años.

Diagnóstico: TEA (sensibilidad sensorial, necesidad de predictibilidad).

Estado emocional: Ansiedad moderada.

Preferencias: Metáforas de fantasía (dragones, castillos).

Adaptación AHEE:

Interfaz: Simplificada (menos elementos, botones grandes).

Colores: Suaves, baja saturación (modo baja estimulación).

Animaciones: Reducidas o eliminadas.

Tipografía: Grande (18px).

Lenguaje: Concreto, literal.

Metáforas: Fantasía (dragones, castillos).

Misiones: Cortas (2-3 minutos).

Narrativa: Estructurada y predecible.

Recompensas: Frecuentes (cada paso completado).

5.2. Caso 2: Usuario Adolescente (16 años) con TDAH
Perfil:

Edad: 16 años.

Diagnóstico: TDAH (distractibilidad, impulsividad).

Estado emocional: Fatiga moderada.

Preferencias: Metáforas de tecnología (hackers, sistemas).

Adaptación AHEE:

Interfaz: Simplificada (menos distracciones visuales).

Colores: Vibrantes pero sin excesos.

Animaciones: Reducidas.

Tipografía: Mediana (16px).

Lenguaje: Abstracto pero con ejemplos concretos.

Metáforas: Tecnología (hackers, sistemas).

Misiones: Cortas (3-5 minutos) con pausas.

Narrativa: Interactiva, con desafíos.

Recompensas: Frecuentes (cada paso).

5.3. Caso 3: Usuario Adulto Mayor (72 años) con Baja Visión
Perfil:

Edad: 72 años.

Diagnóstico: Baja visión (necesita alto contraste y textos grandes).

Estado emocional: Calmado.

Preferencias: Metáforas de naturaleza (jardín, bosque).

Adaptación AHEE:

Interfaz: Simplificada, botones grandes.

Colores: Alto contraste (texto negro sobre fondo blanco/amarillo).

Animaciones: Reducidas (para evitar mareos).

Tipografía: Muy grande (24px).

Lenguaje: Claro, sin jerga.

Metáforas: Naturaleza (jardín, bosque).

Misiones: Cortas (3-5 minutos).

Narrativa: Tranquila, sin prisas.

Recompensas: Mensajes de validación del compañero.

5.4. Caso 4: Usuario Adulto (35 años) con Ansiedad Aguda
Perfil:

Edad: 35 años.

Diagnóstico: Ansiedad aguda (momento de crisis).

Estado emocional: Ansiedad alta.

Preferencias: Metáforas de calma (océano, nubes).

Adaptación AHEE:

Interfaz: Muy simplificada (solo lo esencial).

Colores: Suaves (azules, verdes).

Animaciones: Muy reducidas.

Tipografía: Mediana (18px).

Lenguaje: Calmado, validante.

Metáforas: Calma (océano, nubes).

Misiones: Muy cortas (2-3 minutos) de regulación.

Narrativa: Validante ("Estás haciendo un gran esfuerzo").

Recompensas: Mensajes de apoyo y validación.

6. Integración con el Frontend (React)
6.1. Estructura de la Aplicación con AHEE

frontend/
├── src/
│   ├── app/
│   │   ├── App.js
│   │   └── index.js
│   ├── ahee/
│   │   ├── AHEEProvider.js        # Provider de React Context
│   │   ├── useAHEE.js             # Hook para consumir el contexto
│   │   ├── aheeService.js         # Servicio para comunicarse con el backend
│   │   └── aheeUtils.js           # Funciones auxiliares (aplicación de estilos)
│   ├── components/
│   │   ├── common/
│   │   │   ├── Button.js          # Adaptable (tamaño, contraste)
│   │   │   ├── Card.js            # Adaptable (tamaño, espaciado)
│   │   │   └── Typography.js      # Adaptable (tamaño, contraste, tipografía)
│   │   ├── patient/
│   │   │   ├── Atlas.js           # Adaptable (colores, complejidad)
│   │   │   ├── MissionCard.js     # Adaptable (tamaño, duración)
│   │   │   └── Companion.js      # Adaptable (lenguaje, metáforas)
│   │   └── therapist/
│   │       ├── Dashboard.js       # Adaptable (complejidad, tamaño)
│   │       └── PatientProfile.js  # Adaptable (presentación de datos)
│   ├── hooks/
│   │   └── useAHEE.js             # Hook de adaptación
│   ├── styles/
│   │   ├── base.css              # Estilos base con CSS variables
│   │   └── themes.css            # Temas (claro, oscuro, alto contraste, etc.)
│   └── utils/
│       └── applyAHEE.js          # Función para aplicar estilos al DOM

6.2. Aplicación de Estilos Dinámicos
Función applyAHEE.js:

// utils/applyAHEE.js

export function applyAHEE(profile) {
  const root = document.documentElement;

  // Aplicar variables de fuente (tamaño)
  const fontSizes = {
    small: { '--font-size-base': '14px', '--font-size-lg': '20px', '--font-size-xl': '28px' },
    medium: { '--font-size-base': '16px', '--font-size-lg': '24px', '--font-size-xl': '32px' },
    large: { '--font-size-base': '18px', '--font-size-lg': '28px', '--font-size-xl': '36px' },
    xlarge: { '--font-size-base': '20px', '--font-size-lg': '32px', '--font-size-xl': '40px' }
  };
  const sizeVars = fontSizes[profile.fontSize] || fontSizes.medium;
  Object.entries(sizeVars).forEach(([key, value]) => {
    root.style.setProperty(key, value);
  });

  // Aplicar contraste
  const contrastLevels = {
    normal: { '--color-text': '#2D3436', '--color-background': '#F8F9FA', '--color-surface': '#FFFFFF' },
    high: { '--color-text': '#000000', '--color-background': '#FFFFFF', '--color-surface': '#F5F5F5' }
  };
  const contrastVars = contrastLevels[profile.contrast] || contrastLevels.normal;
  Object.entries(contrastVars).forEach(([key, value]) => {
    root.style.setProperty(key, value);
  });

  // Aplicar tema (claro/oscuro)
  if (profile.theme === 'dark') {
    root.style.setProperty('--color-background', '#1A1A2E');
    root.style.setProperty('--color-surface', '#16213E');
    root.style.setProperty('--color-text', '#EAEAEA');
    root.style.setProperty('--color-text-secondary', '#AAAAAA');
  } else {
    root.style.setProperty('--color-background', '#F8F9FA');
    root.style.setProperty('--color-surface', '#FFFFFF');
    root.style.setProperty('--color-text', '#2D3436');
    root.style.setProperty('--color-text-secondary', '#636E72');
  }

  // Aplicar animaciones
  if (profile.animations === 'reduced') {
    root.style.setProperty('--animation-duration', '0.01s');
    root.style.setProperty('--animation-easing', 'linear');
  } else if (profile.animations === 'none') {
    root.style.setProperty('--animation-duration', '0s');
    root.style.setProperty('--animation-easing', 'linear');
  } else {
    root.style.setProperty('--animation-duration', '0.3s');
    root.style.setProperty('--animation-easing', 'ease-in-out');
  }

  // Aplicar tipografía para dislexia
  if (profile.fontFamily === 'dyslexic') {
    root.style.setProperty('--font-family', '"OpenDyslexic", "Inter", system-ui, sans-serif');
  } else {
    root.style.setProperty('--font-family', '"Inter", system-ui, sans-serif');
  }

  // Aplicar espaciado
  const spacings = {
    small: { '--space-4': '12px', '--space-6': '24px', '--space-8': '48px' },
    normal: { '--space-4': '16px', '--space-6': '32px', '--space-8': '64px' },
    large: { '--space-4': '24px', '--space-6': '48px', '--space-8': '80px' }
  };
  const spacingVars = spacings[profile.spacing] || spacings.normal;
  Object.entries(spacingVars).forEach(([key, value]) => {
    root.style.setProperty(key, value);
  });

  // Aplicar complejidad (clase CSS)
  if (profile.complexity === 'simplified') {
    root.classList.add('ahee-simplified');
  } else {
    root.classList.remove('ahee-simplified');
  }
}

6.3. Componentes Adaptables (Ejemplo)
Button.js (adaptable en tamaño y contraste):

// components/common/Button.js
import React from 'react';
import { useAHEE } from '../../ahee/useAHEE';

const Button = ({ children, onClick, variant = 'primary', ...props }) => {
  const { profile } = useAHEE();

  const getSizeClass = () => {
    if (profile.fontSize === 'xlarge' || profile.fontSize === 'large') {
      return 'btn-large';
    }
    if (profile.fontSize === 'small') {
      return 'btn-small';
    }
    return 'btn-medium';
  };

  const getContrastClass = () => {
    if (profile.contrast === 'high') {
      return 'btn-high-contrast';
    }
    return '';
  };

  return (
    <button
      className={`btn btn-${variant} ${getSizeClass()} ${getContrastClass()}`}
      onClick={onClick}
      {...props}
    >
      {children}
    </button>
  );
};

export default Button;

MissionCard.js (adaptable en duración y complejidad):

// components/patient/MissionCard.js
import React from 'react';
import { useAHEE } from '../../ahee/useAHEE';

const MissionCard = ({ mission }) => {
  const { profile } = useAHEE();

  const getFontSizeClass = () => {
    switch (profile.fontSize) {
      case 'small': return 'text-sm';
      case 'large': return 'text-lg';
      case 'xlarge': return 'text-xl';
      default: return 'text-base';
    }
  };

  const getCardSizeClass = () => {
    if (profile.complexity === 'simplified') {
      return 'p-4 mb-2';
    }
    return 'p-6 mb-4';
  };

  const getDuration = () => {
    if (profile.missionDuration === 'short') {
      return `${Math.min(3, mission.duration)} min`;
    }
    return `${mission.duration} min`;
  };

  const getComplexityClass = () => {
    if (profile.complexity === 'simplified') {
      return 'mission-card-simplified';
    }
    return '';
  };

  return (
    <div className={`mission-card ${getCardSizeClass()} ${getComplexityClass()}`}>
      <h3 className={getFontSizeClass()}>{mission.title}</h3>
      {profile.complexity !== 'simplified' && (
        <p className={getFontSizeClass()}>{mission.description}</p>
      )}
      <p className={getFontSizeClass()}>Duración: {getDuration()}</p>
      <button className="btn-primary btn-medium">Iniciar</button>
    </div>
  );
};

7. Criterios de Validación y Cumplimiento
Criterio	Métrica	Herramienta
Tiempo de adaptación	< 500 ms desde el cambio de perfil hasta la aplicación de estilos.	Monitoreo de rendimiento.
Satisfacción del usuario	≥ 4.5/5 en encuestas de personalización.	Encuestas in-app.
Usabilidad	≥ 90% de los usuarios pueden completar tareas sin asistencia.	Pruebas de usabilidad.
Adherencia	≥ 20% de mejora en adherencia con adaptación activa.	Analítica de uso.
Accesibilidad	Cumple WCAG 2.1 AA en todas las configuraciones.	axe-core, Lighthouse.
Consistencia	La interfaz se adapta sin pérdida de contenido o funcionalidad.	Pruebas de regresión visual.
Ética	El usuario puede desactivar la adaptación automática en cualquier momento.	Revisión de diseño.
8. El Manifiesto de la Adaptación
"La adaptación no es un truco de personalización. Es una necesidad para garantizar que la experiencia del BehavioralOS sea inclusiva, efectiva y ética.

Cada persona es única: su edad, su estado emocional, su nivel de fatiga, sus preferencias y su historia de aprendizaje moldean cómo percibe y responde a la interfaz.

AHEE es el motor que convierte la uniformidad en personalización, haciendo que cada interacción se sienta diseñada específicamente para ese usuario en ese momento.

Pero la adaptación nunca debe ser opaca ni forzada. El usuario siempre debe tener el control, poder ajustar manualmente las configuraciones y entender por qué la interfaz cambia.

La personalización no es un lujo. Es una responsabilidad."

9. Historial de Cambios
Versión	Fecha	Autor	Cambios
1.0.0	2026-07-01	Diseño UX/UI	Creación del documento. Definición de fuentes de datos, mecanismos de cambio, estrategia de implementación (CSS variables, React Context), casos de uso y criterios de validación.
Fin del documento ahee-implementation.md