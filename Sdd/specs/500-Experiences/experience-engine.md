---
id: BERL-001
title: Behavioral Exercise Research Lab (BERL)
version: 2.0.0
status: Stable
owner: "Diseño de Juegos & Psicología Clínica"
last_updated: 2026-07-14
depends_on:
  - 000-Core/ontology.md (Ontología - procesos, conductas)
  - 000-Core/philosophy.md (Filosofía - aprendizaje experiencial)
  - 400-AI/adaptive-orchestrator.md (AAO - evaluación de procesos)
  - 400-AI/rag-knowledge-graph.md (BKGE - conocimiento científico)
  - 100-Architecture/behavioral-twin.md (Behavioral Twin - perfil del paciente)
  - 300-Frontend/patient-app.md (Experiencia Nintendo - ejecución de ejercicios)
  - 000-Infrastructure/selection.md (Infraestructura - Godot, jsPsych gratuitos)
  - 500-Experiencies/ideographic-game-engine.md (Motor de juegos ideográficos 3D)
  - 000-Core/bpo.md (BPO - ontología de procesos)
  - 000-Core/bpg.md (BPG - grafo de procesos del paciente)
exports:
  - Arquitectura del BERL (componentes, flujos)
  - Genoma del ejercicio (estructura completa)
  - Ciclo de vida de un ejercicio (diseño → validación → despliegue → mejora)
  - Sistema de telemetría (variables, fuentes, almacenamiento)
  - Motor de adaptación (dificultad, narrativa, duración)
  - Integración con Godot y jsPsych (técnica)
  - Validación científica (ASC)
  - Catálogo inicial de ejercicios (ejemplos)
  - Criterios de validación y métricas de éxito
used_by:
  - Patient App (ejecución de ejercicios)
  - AAO (telemetría para evaluación)
  - AHEE (adaptación de ejercicios)
  - BSC (investigación y mejora)
  - MPO (planificación de intervenciones)
  - Ideographic Game Engine (generación dinámica de minijuegos)
---

# BehavioralOS – Behavioral Exercise Research Lab (BERL) v2.0.0

> *"El BERL no es un simple repositorio de ejercicios. Es un laboratorio vivo donde cada ejercicio es una hipótesis experimental, cada interacción genera datos, y cada iteración mejora la efectividad clínica. Desde v2.0.0, el BERL consume directamente del BPO: los ejercicios se organizan por PROCESOS, no por terapias. Un proceso como 'Defusión' puede ser entrenado por ejercicios que pertenecen a ACT, FAP, DBT y PBT simultáneamente."*

---

## Cambios v2.0.0 (Resumen)

| Aspecto | v1.0.0 | v2.0.0 |
|---------|--------|--------|
| **Organización** | Por terapia (ACT, FAP, DBT) | **Por proceso** (Defusión, Aceptación, Valores) |
| **Fuente de verdad** | Ontología genérica | **BPO** (ontología de procesos computacional) |
| **Grafo del paciente** | Behavioral Twin plano | **BPG** (grafo dirigido dinámico por paciente) |
| **Mecánicas** | 42 mecánicas por familia | **40+ mecánicas por proceso que entrenan** |
| **Minijuegos** | Escenas fijas en Godot | **Generación dinámica ideográfica (DSL JSON)** |
| **Renderizado** | Godot 4.3 WebAssembly | **Three.js + Godot híbrido** |
| **Terapia de pareja** | Sin soporte | **Juegos cooperativos, Gottman, TIP** |
| **Terapia familiar** | Sin soporte | **Misiones familiares, telemetría grupal** |
| **Niveles** | Individual | **Individual, diádico, familiar, grupal** |

---

## 1. Propósito y Alcance

### 1.1. Propósito
Este documento define el **Behavioral Exercise Research Lab (BERL) v2.0.0**, el motor de diseño, ejecución y validación de ejercicios terapéuticos gamificados del BehavioralOS. Su objetivo es:

- **Diseñar ejercicios terapéuticos** basados en **procesos psicológicos del BPO** (no en terapias). Cada ejercicio mapea a procesos específicos, y cada proceso puede ser entrenado por múltiples intervenciones (ACT, FAP, DBT, PBT, etc.).
- **Ejecutar ejercicios** en el frontend (Patient App) a través de Three.js (3D), Godot y jsPsych, con telemetría en tiempo real.
- **Generar minijuegos ideográficos dinámicos** que se adaptan al perfil del paciente según su BPG (grafo de procesos).
- **Recopilar y analizar telemetría** para evaluar la efectividad de cada ejercicio y actualizar el BPG del paciente.
- **Validar científicamente** los ejercicios mediante el Adaptive Scientific Council (ASC) y el Behavioral Research OS (BROS).
- **Versionar y evolucionar** los ejercicios basándose en la evidencia acumulada.

### 1.2. Alcance
El documento cubre:

- **Arquitectura del BERL v2.0.0**: Componentes, flujos de datos, integración con BPO y BPG.
- **Genoma del ejercicio v2.0.0**: La estructura completa con mapeo a procesos del BPO.
- **Flujo Proceso → Intervención → Ejercicios**: La nueva arquitectura de consumo del BPO.
- **Sistema de telemetría**: Variables recogidas, fuentes de datos, almacenamiento y análisis.
- **Motor de adaptación**: Ajuste de dificultad, narrativa y duración en tiempo real (AHEE).
- **Integración con Three.js y Godot**: Implementación técnica de los ejercicios.
- **Integración con el Ideographic Game Engine**: Generación dinámica de minijuegos.
- **Catálogo inicial**: Ejemplos de ejercicios para diferentes procesos.
- **Criterios de validación**: Métricas de efectividad, engagement, seguridad y escalabilidad.

### 1.3. Principio Fundamental
> **"Un ejercicio no es una actividad. Es una hipótesis experimental. Cada vez que un paciente realiza un ejercicio, está generando datos que validan o refutan esa hipótesis. El BERL es el laboratorio que convierte la práctica clínica en ciencia. Y desde v2.0.0, la pregunta nunca es '¿qué terapia utiliza?' sino '¿qué procesos debo modificar?'"**

---

## 2. Filosofía del BERL v2.0.0

### 2.1. El Cambio Paradigmático: Procesos > Terapias

En v1.0.0 los ejercicios se organizaban por terapia:

```
ACT → Defusión → Ejercicios
ACT → Aceptación → Ejercicios
FAP → CRB1 → Ejercicios
```

**En v2.0.0 se invierte la dirección:**

```
Proceso: Defusión
  ├── ACT → Ejercicio 1, Ejercicio 2, Ejercicio 3
  ├── FAP → Ejercicio 2
  ├── DBT → Ejercicio 1
  └── PBT → Ejercicio 1

Proceso: Aceptación
  ├── ACT → Ejercicio 1
  ├── DBT → Ejercicio 1, Ejercicio 2
  ├── PBT → Ejercicio 1
  └── TIP → Ejercicio 1

Proceso: Regulación Emocional
  ├── DBT → Ejercicio 1, Ejercicio 2, Ejercicio 3
  ├── ACT → Ejercicio 1
  ├── Gottman → Ejercicio 1
  └── TIP → Ejercicio 1
```

**¿Por qué?** Porque un mismo proceso (ej. "Aceptación") aparece en múltiples terapias. Si organizamos por terapia, duplicamos lógica y perdemos la capacidad de descubrir qué intervención funciona mejor para un proceso dado.

### 2.2. Principios de Diseño de Ejercicios

| # | Principio | Descripción | Manifestación |
|---|-----------|-------------|---------------|
| 1 | **Proceso-centrado** | Cada ejercicio mapea a procesos del BPO, no a terapias. | El genoma del ejercicio lista procesos BPO con UUID. |
| 2 | **Hipótesis primero** | Cada ejercicio responde a una hipótesis funcional. | El genoma del ejercicio incluye una hipótesis explícita. |
| 3 | **Mecánicas reutilizables** | Los ejercicios se construyen combinando mecánicas universales (BML). | Uso de la Behavioral Mechanics Library. |
| 4 | **Ideográfico** | Cada paciente recibe una experiencia única según su BPG. | Integración con el Ideographic Game Engine. |
| 5 | **Narrativa inmersiva** | Cada ejercicio tiene una historia que engancha al usuario. | Inspirado en Nintendo: "El Bosque de la Incertidumbre". |
| 6 | **Feedback inmediato** | El usuario recibe feedback continuo (visual, auditivo, háptico). | Animaciones, sonidos, partículas, vibración. |
| 7 | **Adaptación dinámica** | La dificultad, duración y narrativa se ajustan al BPG del paciente. | Integración con AHEE y BPG. |
| 8 | **Telemetría completa** | Cada interacción genera datos para evaluación y mejora. | Variables: latencia, errores, persistencia, etc. |
| 9 | **Multi-nivel** | Ejercicios para individual, diádico, familiar y grupal. | Cada ejercicio declara su nivel de interacción. |
| 10 | **Validación científica** | Los ejercicios se validan antes y después de su despliegue. | Ciclo de validación del ASC. |

### 2.3. El Ciclo de Vida de un Ejercicio (v2.0.0)

```
┌─────────────────────────────────────────────────────────────────────┐
│ Ciclo de Vida de un Ejercicio v2.0.0                                │
├─────────────────────────────────────────────────────────────────────┤
│ 1. Consulta al BPO                                                   │
│    • Identificar proceso(s) objetivo(s) por UUID                     │
│    • Obtener definiciones operacionales del proceso                   │
│    • Consultar intervenciones asociadas al proceso                    │
├─────────────────────────────────────────────────────────────────────┤
│ 2. Diseño Conceptual                                                │
│    • Formular hipótesis funcional                                    │
│    • Seleccionar mecánicas de la BML                                 │
│    • Definir narrativa y estética                                    │
│    • Seleccionar nivel (individual/diadico/familiar/grupal)          │
├─────────────────────────────────────────────────────────────────────┤
│ 3. Especificación (Genoma)                                           │
│    • Crear el genoma completo con mapeo BPO                          │
│    • Definir variables de telemetría                                 │
│    • Especificar reglas de adaptación                                │
│    • Generar DSL para el Ideographic Game Engine                     │
├─────────────────────────────────────────────────────────────────────┤
│ 4. Implementación Técnica                                            │
│    • Desarrollar en Three.js (3D) o Godot (WebAssembly)             │
│    • Integrar jsPsych para telemetría cognitiva                      │
│    • Conectar con BRIL para envío de datos                           │
├─────────────────────────────────────────────────────────────────────┤
│ 5. Validación Interna                                                │
│    • Pruebas de usabilidad                                           │
│    • Validación clínica por psicólogos                                │
│    • Ajustes iterativos                                              │
├─────────────────────────────────────────────────────────────────────┤
│ 6. Revisión Científica (ASC)                                         │
│    • Evaluación por el Adaptive Scientific Council                   │
│    • Aprobación o rechazo con recomendaciones                        │
├─────────────────────────────────────────────────────────────────────┤
│ 7. Despliegue Controlado (Canary)                                    │
│    • Desplegar a un pequeño grupo de pacientes                       │
│    • Monitorear telemetría y feedback                                │
├─────────────────────────────────────────────────────────────────────┤
│ 8. Evaluación de Resultados                                          │
│    • Analizar datos agregados (BSC)                                  │
│    • Comparar con hipótesis                                          │
│    • Calcular tamaño del efecto                                      │
├─────────────────────────────────────────────────────────────────────┤
│ 9. Actualización del BPG                                              │
│    • Los resultados actualizan el BPG del paciente                   │
│    • El BPG modifica las recomendaciones futuras                      │
├─────────────────────────────────────────────────────────────────────┤
│ 10. Mejora y Versionado                                              │
│    • Iterar basado en resultados                                     │
│    • Crear nueva versión                                             │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 3. Arquitectura del BERL v2.0.0

### 3.1. Visión General

```
┌─────────────────────────────────────────────────────────────────────────┐
│ Behavioral Exercise Research Lab (BERL) v2.0.0                         │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐     │
│ │ Process-Aware Exercise Design Studio                            │     │
│ │ • Consulta al BPO para procesos y definiciones                  │     │
│ │ • Constructor de genomas con mapeo BPO                          │     │
│ │ • Biblioteca de mecánicas (BML)                                 │     │
│ │ • Editor de narrativas                                          │     │
│ └─────────────────────────────────────────────────────────────────┘     │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐     │
│ │ Exercise Runtime Engine                                         │     │
│ │ • Ejecución en Three.js (3D) y Godot (WebAssembly)             │     │
│ │ • Telemetría en tiempo real (jsPsych)                           │     │
│ │ • Adaptación dinámica (AHEE + BPG)                              │     │
│ │ • Envío de datos a BRIL                                         │     │
│ └─────────────────────────────────────────────────────────────────┘     │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐     │
│ │ Ideographic Game Integration                                    │     │
│ │ • DSL JSON para generación dinámica de minijuegos               │     │
│ │ • Gemma 4 escribe configuración, Three.js renderiza             │     │
│ │ • Adaptación por perfil del BPG del paciente                    │     │
│ │ • Mecánicas: absorber, soltar, equilibrar, recolectar           │     │
│ └─────────────────────────────────────────────────────────────────┘     │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐     │
│ │ Exercise Validation Engine                                      │     │
│ │ • Validación de genomas contra BPO                              │     │
│ │ • Análisis de telemetría                                        │     │
│ │ • Cálculo de efectividad por proceso                            │     │
│ └─────────────────────────────────────────────────────────────────┘     │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐     │
│ │ Exercise Repository                                             │     │
│ │ • Catálogo de ejercicios (versionado)                           │     │
│ │ • Metadatos BPO (procesos, evidencia, efectividad)              │     │
│ │ • Assets (sprites, sonidos, escenas, modelos 3D)                │     │
│ └─────────────────────────────────────────────────────────────────┘     │
└─────────────────────────────────────────────────────────────────────────┘
```

### 3.2. Flujo Proceso → Intervención → Ejercicios

Este es el flujo central de v2.0.0. La dirección cambió:

```
ANTES (v1.0.0):
ACT → Defusión → Ejercicios

AHORA (v2.0.0):
Defusión (BPO-CTX-000032)
  ├── Consultar BPO → definición operacional
  ├── Consultar BPG del paciente → estado actual (confianza: 0.35)
  ├── Intervenciones disponibles:
  │   ├── ACT: Ejercicios A1, A2, A3
  │   ├── FAP: Ejercicio B2
  │   ├── DBT: Ejercicio C1
  │   └── PBT: Ejercicio D1
  ├── Seleccionar según:
  │   ├── BPG del paciente (procesos débiles primero)
  │   ├── AHEE (edad, preferencias, nivel)
  │   ├── Historial (qué ya completó)
  │   └── Efectividad (BSC: qué funciona mejor)
  └── Ejercicio seleccionado → Ejecución → Telemetría → Actualizar BPG
```

### 3.3. Componentes del BERL v2.0.0

| Componente | Descripción | Tecnología |
|------------|-------------|------------|
| **Process-Aware Design Studio** | Diseña ejercicios consultando el BPO. | React + Python (FastAPI) |
| **Exercise Runtime Engine** | Ejecuta ejercicios en Three.js y Godot. | Three.js + Godot 4.3 + jsPsych |
| **Ideographic Game Integration** | Genera minijuegos dinámicos según el BPG. | Gemma 4 + DSL JSON + Three.js |
| **Exercise Validation Engine** | Valida ejercicios contra el BPO. | Python (FastAPI), scikit-learn |
| **Exercise Repository** | Catálogo versionado con metadatos BPO. | Supabase (Storage) |

---

## 4. El Genoma del Ejercicio v2.0.0

### 4.1. Estructura del Genoma

Cada ejercicio tiene un **genoma** que define su identidad, propósito, mecánicas, telemetría y adaptación. En v2.0.0, el genoma mapea explícitamente a procesos del BPO.

```json
{
  "id": "EXE-001",
  "version": "2.0.0",
  "status": "stable",
  "name": "El Bosque de la Incertidumbre",
  "description": "Aprende a observar tus pensamientos sin fusionarte con ellos.",
  "level": "individual",
  "objective": {
    "bpo_processes": [
      {
        "uuid": "BPO-CTX-000032",
        "name": "Defusión Cognitiva",
        "role": "primary"
      },
      {
        "uuid": "BPO-CTX-000031",
        "name": "Aceptación",
        "role": "secondary"
      },
      {
        "uuid": "BPO-CTX-000034",
        "name": "Contacto con el Presente",
        "role": "tertiary"
      }
    ],
    "interventions": ["ACT", "PBT"],
    "hypothesis": "La práctica de defusión mediante metáforas visuales reduce la fusión cognitiva en contextos de incertidumbre.",
    "expected_outcome": "Aumento de la flexibilidad psicológica."
  },
  "mechanics": {
    "primary": "observe",
    "secondary": ["compare", "classify"],
    "bml_mapping": ["MEC-001", "MEC-003", "MEC-004"]
  },
  "narrative": {
    "theme": "forest",
    "tone": "curious",
    "characters": ["el guardián del bosque"],
    "metaphor": "Los pensamientos son como hojas que caen."
  },
  "interaction": {
    "duration": 5,
    "difficulty": 3,
    "modality": "touch",
    "platform": ["web", "mobile"]
  },
  "telemetry": {
    "variables": [
      {"name": "latency", "type": "numeric", "unit": "ms"},
      {"name": "errors", "type": "numeric", "unit": "count"},
      {"name": "persistence", "type": "numeric", "unit": "seconds"},
      {"name": "retries", "type": "numeric", "unit": "count"},
      {"name": "path_length", "type": "numeric", "unit": "steps"},
      {"name": "abandonment", "type": "boolean", "unit": ""}
    ],
    "frequency": "real-time"
  },
  "adaptation": {
    "difficulty": {
      "algorithm": "fuzzy",
      "parameters": ["errors", "latency", "persistence"]
    },
    "bpg_driven": true
  },
  "ideographic_config": {
    "dsl_template": "balloon_burst",
    "customizable_fields": ["stimuli_text", "color_palette", "victory_condition"],
    "source": "BPG patient profile"
  },
  "target_audience": {
    "min_age": 12,
    "max_age": 99,
    "languages": ["es", "en"]
  },
  "assets": {
    "engine": "three.js",
    "godot_scene": "forest_defusion.tscn",
    "jspsych_tasks": ["latency_test", "error_tracking"],
    "audio": "forest_ambient.ogg",
    "3d_models": ["leaf_01.glb", "tree_01.glb"]
  },
  "validation": {
    "evidence_level": "preliminary",
    "effect_size": 0.0,
    "sample_size": 0,
    "last_validated": null
  },
  "created_by": "equipo_clinico",
  "created_at": "2026-07-14T10:00:00Z",
  "updated_at": "2026-07-14T10:00:00Z"
}
```

### 4.2. Diferencias Clave del Genoma v2.0.0

| Campo | v1.0.0 | v2.0.0 |
|-------|--------|--------|
| `objective.processes` | Lista de strings ("defusion") | **Lista de objetos con UUID BPO** |
| `objective.interventions` | No existía | **Lista de intervenciones que entrenan estos procesos** |
| `level` | No existía | **individual / diadico / familiar / grupal** |
| `bml_mapping` | No existía | **IDs de la BML para trazabilidad** |
| `ideographic_config` | No existía | **Config para el Ideographic Game Engine** |
| `adaptation.bpg_driven` | No existía | **Boolean: si la adaptación consulta el BPG** |

---

## 5. Catálogo Inicial de Ejercicios (v2.0.0)

Los ejercicios ahora se listan **por proceso**, no por terapia:

### Proceso: Defusión Cognitiva (BPO-CTX-000032)

| ID | Nombre | Intervención base | Mecánica | Nivel | Duración |
|----|--------|-------------------|----------|-------|----------|
| EXE-001 | El Bosque de la Incertidumbre | ACT | Observar | Individual | 5 min |
| EXE-006 | La Tormenta de la Defusión | ACT/DBT | Soltar | Individual | 4 min |
| EXE-009 | Globos de los Pensamientos | ACT (ideographic) | Estallir globos | Individual | 3 min |
| EXE-010 | Río de la Defusión | PBT | Flotar | Individual | 4 min |

### Proceso: Aceptación (BPO-CTX-000031)

| ID | Nombre | Intervención base | Mecánica | Nivel | Duración |
|----|--------|-------------------|----------|-------|----------|
| EXE-004 | El Laberinto de la Aceptación | ACT | Permanecer | Individual | 6 min |
| EXE-011 | Escudo de Resistencia | ACT/DBT (ideographic) | Sostener escudo | Individual | 5 min |
| EXE-012 | Jardín de la Apertura | PBT | Regar y cuidar | Individual | 4 min |

### Proceso: Acción Comprometida (BPO-CTX-000036)

| ID | Nombre | Intervención base | Mecánica | Nivel | Duración |
|----|--------|-------------------|----------|-------|----------|
| EXE-002 | La Montaña de los Valores | ACT | Elegir | Individual | 8 min |
| EXE-008 | La Expedición de la Flexibilidad | ACT/PBT | Explorar | Individual | 9 min |
| EXE-013 | Misiones Pikmin | ACT (ideographic) | Recolectar + action | Individual | 5 min |

### Proceso: Regulación Emocional (BPO-EMO-000004)

| ID | Nombre | Intervención base | Mecánica | Nivel | Duración |
|----|--------|-------------------|----------|-------|----------|
| EXE-003 | El Faro del Equilibrio | DBT | Respirar | Individual | 3 min |
| EXE-007 | El Espejo de la Autocompasión | DBT/ACT | Construir | Individual | 6 min |

### Proceso: Validación (Pareja) (BPO-REL-000003)

| ID | Nombre | Intervención base | Mecánica | Nivel | Duración |
|----|--------|-------------------|----------|-------|----------|
| EXE-020 | Puente de la Conexión | Gottman/TIP | Escuchar + Validar | **Diádico** | 10 min |
| EXE-021 | Jardín Compartido | Gottman | Cuidar jardín juntos | **Diádico** | 8 min |

### Proceso: Cohesión Familiar (BPO-FAM-000001)

| ID | Nombre | Intervención base | Mecánica | Nivel | Duración |
|----|--------|-------------------|----------|-------|----------|
| EXE-030 | Reino Familiar | Sistémico/PBT | Construir + cooperar | **Familiar** | 15 min |
| EXE-031 | Misiones de Equipo | Sistémico | Completar objetivos | **Grupal** | 12 min |

---

## 6. Integración con el Ideographic Game Engine

### 6.1. Flujo de Generación Dinámica

```
Paciente abre la app
  → BPG del paciente se carga (procesos, confianzas, historial)
  → Motor de Recomendación selecciona proceso objetivo
  → BERL genera configuración DSL JSON (o Gemma 4 la genera)
  → Three.js recibe el DSL y renderiza el minijuego 3D
  → Paciente juega
  → Telemetría se envía al BPG
  → BPG se actualiza
```

### 6.2. Ejemplo: Paciente con Fusión Cognitiva Alta

**BPG del paciente:**
- Fusión Cognitiva: 0.82 (alta)
- Aceptación: 0.24 (baja)
- Valores: 0.61 (media)

**Configuración generada (DSL JSON):**

```json
{
  "mecanica_principal": "estallir_globos",
  "estimulos_textuales": [
    "No sirvo para nada",
    "Siempre fracaso",
    "No puedo con esto"
  ],
  "paleta_colores": ["#1a2a6c", "#b21f1f", "#fdbb2d"],
  "condicion_victoria": "Estallar cada globo con el pensamiento y verlo desaparecer, permitiendo que la música recupere su ritmo natural.",
  "dificultad_base": 3,
  "adaptacion_bpg": true
}
```

**Three.js renderiza:** Globos 3D flotantes con el texto del paciente. Al tocar/golpear cada globo, explota con efecto de partículas y sonido satisfactorio (juicy feedback). El cielo se aclara progresivamente.

---

## 7. Sistema de Telemetría (v2.0.0)

### 7.1. Variables Recogidas

Las mismas que v1.0.0, más nuevas para el nivel de interacción:

| Categoría | Variables | Descripción | Unidad |
|-----------|-----------|-------------|--------|
| Rendimiento | latency, errors, retries, completion_time | Métricas de rendimiento | ms, count, seconds |
| Comportamiento | persistence, abandonment, path_length, variability | Patrones de interacción | seconds, boolean, steps |
| Emocional | frustration, engagement | Estimación emocional | numeric (0-1) |
| Adaptación | difficulty_used, duration_used, narrative_used | Parámetros aplicados | numeric, seconds, string |
| Contexto | device, time_of_day, interaction_level | Contexto de uso | string |
| **BPG Impact** | **process_before, process_after, delta_confidence** | **Cambio en procesos del BPG** | **UUID, numeric** |
| **Nivel** | **interaction_type (individual/diadico/familiar/grupal)** | **Nivel de interacción** | **enum** |

### 7.2. Flujo de Telemetría al BPG

```
Ejercicio completado
  → Telemetría enviada a BRIL
  → BRIL almacena en Supabase (TimescaleDB)
  → Motor de Procesos actualiza BPG del paciente
  → BPG recalcula confianzas
  → Dashboard del terapeuta se actualiza
  → Motor de Recomendación ajusta siguientes ejercicios
```

---

## 8. Integración con el Ecosistema v2.0.0

| Motor | Relación con BERL v2.0.0 |
|-------|---------------------------|
| **BPO** | BERL **consume** el BPO para mapear ejercicios a procesos. Cada ejercicio declara UUID de procesos BPO. |
| **BPG** | BERL **lee** el BPG del paciente para seleccionar ejercicios y **actualiza** el BPG con telemetría. |
| **BML** | BERL **utiliza** la BML como paleta de mecánicas reutilizables. |
| **AHEE** | BERL **recibe** adaptación de AHEE (edad, preferencias) y **envía** telemetría. |
| **AAO** | BERL **alimenta** al AAO con telemetría para actualizar evaluaciones. |
| **TCCN** | BERL **recibe** sugerencias del TCCN sobre qué ejercicios recomendar. |
| **BSC** | BERL **alimenta** al BSC con datos agregados para investigación. |
| **Ideographic Game Engine** | BERL **genera** configuraciones DSL que el IDE renderiza en Three.js. |
| **BCMS** | BERL **recibe** prescripciones del terapeuta desde el BCMS. |

---

## 9. Criterios de Validación y Cumplimiento

| Criterio | Métrica | Herramienta |
|----------|---------|-------------|
| **Mapeo BPO** | 100% de ejercicios con UUID de procesos BPO | Validación automática |
| **Efectividad clínica** | Tamaño del efecto > 0.3 (Cohen's d) | Análisis estadístico |
| **Impacto en BPG** | Cambio medible en confianza del proceso objetivo | Análisis de BPG |
| **Seguridad** | 0% de efectos adversos reportados | Monitoreo de seguridad |
| **Usabilidad** | Tasa de abandono < 10% | Analítica de uso |
| **Engagement** | Puntuación > 4/5 | Encuestas in-app |
| **Adaptación** | Ajuste correcto ≥ 80% | Análisis de telemetría |

---

## 10. El Manifiesto del BERL v2.0.0

> *"El BERL no es un repositorio de ejercicios. Es un laboratorio vivo.*
>
> *Cada ejercicio es una hipótesis experimental. Cada interacción genera datos. Cada iteración mejora la efectividad clínica.*
>
> *Desde v2.0.0, la pregunta nunca es '¿qué terapia utiliza?' sino '¿qué procesos debo modificar?'. Los ejercicios se organizan por procesos, no por terapias. Un proceso como la Defusión puede ser entrenado por ACT, FAP, DBT y PBT simultáneamente.*
>
> *Cada paciente recibe una experiencia única. Los minijuegos se generan dinámicamente según su grafo de procesos. No hay dos pacientes que jueguen lo mismo.*
>
> *La gamificación no es un truco de retención. Es un amplificador de aprendizaje.*
>
> *Nuestra responsabilidad es garantizar que cada ejercicio sea seguro, efectivo, adaptativo y científicamente validado. Que cada minuto de juego sea un minuto de crecimiento."*

---

## 11. Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2026-07-01 | Arquitectura de Gamificación | Creación del documento. |
| 2.0.0 | 2026-07-14 | Arquitectura de Gamificación | Reorganización por procesos (BPO). Integración con BPG. Mapeo a intervenciones múltiples. Soporte para niveles individual/diadico/familiar/grupal. Integración con Ideographic Game Engine. Nuevo genoma v2.0.0 con UUID de procesos BPO. Catálogo reorganizado por proceso. |

---

**Fin del documento `experience-engine.md` v2.0.0**
