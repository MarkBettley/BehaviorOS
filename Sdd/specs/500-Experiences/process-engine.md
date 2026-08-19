---
id: PE-001
title: Motor de Procesos Psicológicos
version: 2.0.0
status: Stable
owner: Psicología Clínica & Arquitectura de IA
last_updated: 2026-07-14
depends_on:
  - 000-Core/ontology.md (Ontología - procesos, relaciones)
  - 000-Core/bpo.md (BPO - ontología de procesos computacional)
  - 000-Core/bpg.md (BPG - grafo de procesos del paciente)
  - 500-Experiencies/mechanics-library.md (BML v2.0.0 - mecánicas por proceso)
  - 500-Experiencies/experience-engine.md (BERL v2.0.0 - genoma)
  - 100-Architecture/behavioral-twin.md (Behavioral Twin - perfil del paciente)
  - 400-AI/adaptive-orchestrator.md (AAO - evaluación de procesos)
  - 400-AI/rag-knowledge-graph.md (BKGE - conocimiento científico)
  - 000-Infrastructure/selection.md (Infraestructura - NetworkX gratuito)
exports:
  - Learning Graph por proceso (nodos, aristas, caminos) consultado desde BPG
  - Mapeo de mecánicas BML a procesos BPO (con UUID)
  - Algoritmos de recomendación basados en BPG del paciente
  - Soporte multi-nivel: individual, diádico, familiar, grupal
  - Cálculo de progresión y dominio de habilidades
  - Integración con BERL v2.0.0, AAO, AHEE, BSC, BCMS
  - Criterios de validación y métricas de éxito
used_by:
  - BERL v2.0.0 (selección de ejercicios)
  - AAO (evaluación de procesos)
  - BCMS (planificación de intervenciones)
  - AHEE (adaptación de dificultad y contenido)
  - BSC (investigación de efectividad)
  - Ideographic Game Engine (generación dinámica de minijuegos)
---

# BehavioralOS – Motor de Procesos Psicológicos v2.0.0

> *"El motor de procesos no es un simple mapeo de mecánicas a procesos. Es el cerebro que entiende cómo aprende una persona: qué habilidades necesita desarrollar primero, cuáles son los prerrequisitos, y cómo se conectan los procesos entre sí. Desde v2.0.0, consulta directamente el BPG del paciente para tomar decisiones, y soporta experiencias de interacción individual, diádica, familiar y grupal."*

---

## Cambios v2.0.0 (Resumen)

| Aspecto | v1.0.0 | v2.0.0 |
|---------|--------|--------|
| **Fuente de verdad** | Procesos genéricos de la ontología | **BPO** (ontología computacional con UUID) |
| **Grafo del paciente** | Behavioral Twin plano | **BPG** (MultiDiGraph dinámico por paciente) |
| **Recomendación** | Basada en confianza genérica | **Basada en BPG: aristas del grafo del paciente** |
| **Multi-nivel** | Individual únicamente | **Individual, diádico, familiar, grupal** |
| **Mecánicas** | 20 mecánicas mapeadas | **47+ mecánicas mapeadas a UUID de procesos BPO** |
| **Learning Graph** | Estático por defecto | **Dinámico: se adapta al BPG de cada paciente** |
| **Integraciones** | BERL, AAO, MPO, AHEE, BSC | **+ BPO, BPG, BCMS, Ideographic Game Engine** |

---

## 1. Propósito y Alcance

### 1.1. Propósito
Este documento define el **Motor de Procesos Psicológicos v2.0.0** del BehavioralOS. Su objetivo es:

- **Conectar las mecánicas de juego** (BML v2.0.0) con los procesos psicológicos del **BPO** (con UUID).
- **Gestionar el Learning Graph dinámico**: un grafo de habilidades y procesos que se adapta al **BPG del paciente**.
- **Personalizar la experiencia** de cada usuario adaptando los ejercicios según su BPG y perfil idiográfico.
- **Recomendar ejercicios** basándose en el BPG del paciente (procesos débiles primero, con verificación de prerrequisitos).
- **Soportar interacción multi-nivel**: individual, diádico, familiar y grupal.
- **Calcular la progresión y el dominio** de habilidades a lo largo del tiempo.

### 1.2. Alcance
El documento cubre:

- **Learning Graph dinámico**: Estructura, nodos (procesos BPO, habilidades, micro-habilidades), aristas (prerrequisitos, facilitación, inhibición) y caminos de aprendizaje, con adaptación por BPG.
- **Mapeo de mecánicas a procesos BPO**: Tablas de relación entre mecánicas de la BML v2.0.0 y procesos del BPO (con UUID).
- **Algoritmos de recomendación basados en BPG**: Cómo el motor selecciona el siguiente ejercicio óptimo consultando el grafo del paciente.
- **Soporte multi-nivel**: Recomendación para interacción individual, diádica, familiar y grupal.
- **Personalización idiográfica**: Integración con BPG y Behavioral Twin para ajustar la ruta de aprendizaje.
- **Cálculo de dominio**: Métricas de progresión por proceso (nivel de habilidad, confianza, generalización).
- **Integración con el ecosistema**: BERL v2.0.0, AAO, AHEE, BCMS, BSC, Ideographic Game Engine.
- **Criterios de validación**: Métricas de efectividad, precisión de recomendaciones y satisfacción del usuario.

### 1.3. Principio Fundamental
> **"El aprendizaje no es lineal. Cada persona tiene su propia ruta de desarrollo de habilidades psicológicas. El motor de procesos no impone un camino único; descubre la ruta óptima para cada individuo basándose en su BPG: el grafo vivo de sus procesos, sus fortalezas y sus áreas de crecimiento."**

---

## 2. Filosofía del Motor de Procesos v2.0.0

### 2.1. El Cambio Paradigmático: BPG como Centro de Decisión

En v1.0.0 el motor usaba un Behavioral Twin plano con confianzas genéricas. En v2.0.0, el centro de decisión es el **BPG (Behavioral Process Graph)**:

```
ANTES (v1.0.0):
Behavioral Twin → Confianzas planas → Recomendación

AHORA (v2.0.0):
BPG del paciente (MultiDiGraph)
  ├── Nodos: procesos BPO con UUID y confianza
  ├── Aristas: relaciones entre procesos (peso = fuerza)
  ├── Consulta: ¿qué procesos están débiles?
  ├── Verificación: ¿están los prerrequisitos dominados?
  └── Recomendación: ejercicio que impacte el proceso débil más relevante
```

### 2.2. Principios de Aprendizaje

| # | Principio | Descripción | Manifestación |
|---|-----------|-------------|---------------|
| 1 | **Idiográfico** | La ruta de aprendizaje es única para cada persona. | El Learning Graph se personaliza según el BPG del paciente. |
| 2 | **Basado en prerrequisitos** | Algunas habilidades deben desarrollarse antes que otras. | El Learning Graph define dependencias entre procesos del BPO. |
| 3 | **Progresión gradual** | Las habilidades se desarrollan en niveles de complejidad creciente. | Niveles de profundidad de las mecánicas (1-5). |
| 4 | **Transferencia y generalización** | El aprendizaje debe aplicarse a nuevos contextos. | Ejercicios que fomentan la generalización (MEC-040). |
| 5 | **Refuerzo continuo** | La práctica espaciada y la variabilidad fortalecen el aprendizaje. | El sistema varía ejercicios para evitar la habituación. |
| 6 | **Motivación intrínseca** | El aprendizaje debe ser autónomo y significativo. | Los ejercicios se alinean con los valores del usuario (MEC-041). |
| 7 | **Multi-nivel** | El aprendizaje ocurre en múltiples contextos sociales. | Ejercicios para individual, diádico, familiar y grupal. |

---

## 3. Arquitectura del Motor de Procesos v2.0.0

### 3.1. Visión General

```
┌─────────────────────────────────────────────────────────────────────────┐
│ Motor de Procesos Psicológicos v2.0.0                                   │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐     │
│ │ BPG Consultation Engine                                         │     │
│ │ • Lee el BPG del paciente (MultiDiGraph)                        │     │
│ │ • Identifica procesos débiles (confianza < umbral)              │     │
│ │ • Verifica prerrequisitos del Learning Graph                    │     │
│ │ • Selecciona proceso objetivo con mayor impacto                 │     │
│ └─────────────────────────────────────────────────────────────────┘     │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐     │
│ │ Learning Graph Engine                                           │     │
│ │ • Gestión del grafo de aprendizaje (NetworkX)                   │     │
│ │ • Nodos: procesos BPO (UUID), habilidades, micro-habilidades    │     │
│ │ • Aristas: prerrequisitos, facilitación, inhibición, multi-nivel│     │
│ │ • Caminos de aprendizaje adaptados por BPG                      │     │
│ └─────────────────────────────────────────────────────────────────┘     │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐     │
│ │ Mechanic-Process Mapper                                         │     │
│ │ • Mapeo de mecánicas BML (v2.0.0) a procesos BPO               │     │
│ │ • Cálculo de efectividad de cada mecánica por proceso           │     │
│ │ • Soporte para mecánicas 3D y multi-nivel                       │     │
│ └─────────────────────────────────────────────────────────────────┘     │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐     │
│ │ Exercise Recommender Engine                                     │     │
│ │ • Selección del siguiente ejercicio óptimo                      │     │
│ │ • Basado en BPG del paciente (procesos débiles primero)         │     │
│ │ • Basado en Learning Graph (prerrequisitos verificados)         │     │
│ │ • Basado en AHEE (edad, preferencias, nivel)                    │     │
│ │ • Soporte multi-nivel (individual/diadico/familiar/grupal)      │     │
│ └─────────────────────────────────────────────────────────────────┘     │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐     │
│ │ Skill Progression Engine                                        │     │
│ │ • Cálculo del nivel de dominio de cada proceso BPO              │     │
│ │ • Actualización de confianzas desde BPG                         │     │
│ │ • Detección de mesetas y estancamientos                         │     │
│ │ • Progresión multi-nivel (cada nivel tiene su propio tracking)  │     │
│ └─────────────────────────────────────────────────────────────────┘     │
└─────────────────────────────────────────────────────────────────────────┘
```

### 3.2. Componentes

| Componente | Descripción | Tecnología |
|------------|-------------|------------|
| **BPG Consultation Engine** | Lee y consulta el BPG del paciente para tomar decisiones. | NetworkX + PostgreSQL (BPG storage) |
| **Learning Graph Engine** | Gestiona el grafo de aprendizaje y sus relaciones. | NetworkX + PostgreSQL (JSONB) |
| **Mechanic-Process Mapper** | Conecta mecánicas BML v2.0.0 con procesos BPO. | Python (FastAPI) |
| **Exercise Recommender Engine** | Recomienda ejercicios según BPG, Learning Graph y AHEE. | Python (FastAPI), scikit-learn |
| **Skill Progression Engine** | Calcula el dominio de habilidades y detecta mesetas. | Python (FastAPI), NumPy |

---

## 4. Learning Graph Dinámico (v2.0.0)

### 4.1. Estructura

El Learning Graph es un **grafo dirigido y ponderado** donde:

- **Nodos**: Representan procesos BPO (con UUID), habilidades y micro-habilidades.
- **Aristas**: Representan relaciones entre nodos (prerrequisitos, facilitación, inhibición).
- **Pesos**: Representan la fuerza de la relación (0-1).
- **Adaptación**: El Learning Graph se **cruza** con el BPG del paciente para generar una ruta personalizada.

### 4.2. Tipos de Nodos

| Tipo | Descripción | Ejemplo |
|------|-------------|---------|
| **Proceso BPO** | Proceso de la ontología BPO (con UUID). | BPO-CTX-000032 (Defusión Cognitiva) |
| **Habilidad** | Habilidad compuesta por múltiples micro-habilidades. | Flexibilidad psicológica |
| **Micro-habilidad** | Componente básico (entrenable mediante una mecánica). | "Detectar pensamientos" |
| **Mecánica BML** | Mecánica de la BML v2.0.0 (nodo de entrada). | MEC-001 (Observar) |
| **Ejercicio BERL** | Ejercicio específico del BERL v2.0.0. | EXE-001 ("El Bosque de la Incertidumbre") |

### 4.3. Tipos de Aristas

| Tipo | Descripción | Dirección | Peso típico |
|------|-------------|-----------|-------------|
| `prerequisite_of` | A es un prerrequisito para B. | A → B | 0.7-1.0 |
| `facilitates` | A facilita el desarrollo de B. | A → B | 0.5-0.9 |
| `inhibits` | A inhibe el desarrollo de B. | A → B | -0.5 a -0.9 |
| `generalizes_to` | El aprendizaje de A se generaliza a B. | A → B | 0.3-0.7 |
| `part_of` | A es parte de B. | A → B | 1.0 |
| `requires` | A requiere B para ser efectivo. | A → B | 0.8-1.0 |
| `co_regulates` | **(Nuevo v2.0.0)** A y B se regulan mutuamente (niveles diádicos). | A ↔ B | 0.6-0.9 |

### 4.4. Ejemplo de Learning Graph (Segmento por Proceso BPO)

```
[MEC-001: Observar] (BPO-CTX-000034)
  ↓ (prerequisite_of)
[Micro: Detectar Pensamientos]
  ↓ (prerequisite_of)
[BPO-CTX-000032: Defusión Cognitiva]
  ↓ (facilitates)
[BPO-CTX-000031: Aceptación]
  ↓ (part_of)
[Habilidad: Flexibilidad Psicológica]

[MEC-019: Elegir] (BPO-CTX-000038)
  ↓ (prerequisite_of)
[Micro: Conectar con Valores]
  ↓ (prerequisite_of)
[BPO-CTX-000037: Clarificación de Valores]
  ↓ (part_of)
[Habilidad: Flexibilidad Psicológica]

[BPO-CTX-000031: Aceptación]
  ↓ (co_regulates — nivel diádico)
[BPO-REL-000003: Sincronía de Pareja]
```

### 4.5. Representación Computacional

```json
{
  "nodes": [
    {
      "id": "LG-001",
      "type": "micro_habilidad",
      "name": "Detectar Pensamientos",
      "bpo_uuid": "BPO-CTX-000032",
      "process_name": "Defusión Cognitiva",
      "level": 2,
      "confidence": 0.75
    },
    {
      "id": "LG-002",
      "type": "process_bpo",
      "name": "Defusión Cognitiva",
      "bpo_uuid": "BPO-CTX-000032",
      "level": 3,
      "confidence": 0.68
    }
  ],
  "edges": [
    {
      "source": "LG-001",
      "target": "LG-002",
      "type": "prerequisite_of",
      "weight": 0.85,
      "confidence": 0.90
    }
  ],
  "interaction_levels": ["individual", "diadico", "familiar", "grupal"]
}
```

### 4.6. Cruce Learning Graph × BPG del Paciente

El punto clave de v2.0.0: el Learning Graph se cruza con el BPG del paciente para generar una **ruta personalizada**:

```python
def cruzar_learning_graph_con_bpg(learning_graph, bpg_paciente):
    """
    Cruza el Learning Graph global con el BPG del paciente
    para generar una ruta personalizada.
    """
    ruta_personalizada = []
    
    for nodo in learning_graph.nodos_proceso():
        uuid = nodo.bpo_uuid
        confianza_bpg = bpg_paciente.get_confianza(uuid)
        confianza_lg = nodo.confidence
        
        # El camino óptimo usa el MENOR valor (más débil)
        confianza_efectiva = min(confianza_bpg, confianza_lg)
        
        if confianza_efectiva < UMBRAL_DEBIL:
            # Verificar prerrequisitos
            prereqs = learning_graph.get_prerequisitos(uuid)
            prereqs_dominados = all(
                bpg_paciente.get_confianza(p) >= 0.7 
                for p in prereqs
            )
            
            ruta_personalizada.append({
                "uuid": uuid,
                "nombre": nodo.name,
                "confianza": confianza_efectiva,
                "prereqs_ok": prereqs_dominados,
                "impacto_estimado": calcular_impacto(uuid, bpg_paciente)
            })
    
    # Ordenar por confianza ascendente (más débil primero)
    # Solo incluir procesos cuyos prerrequisitos estén dominados
    candidatos = [r for r in ruta_personalizada if r["prereqs_ok"]]
    candidatos.sort(key=lambda r: r["confianza"])
    
    return candidatos
```

---

## 5. Mapeo de Mecánicas BML a Procesos BPO

### 5.1. Tabla de Mapeo (Selección — con UUID BPO)

| Mecánica BML | Procesos BPO entrenados (UUID) | Nivel de profundidad |
|-------------|-------------------------------|---------------------|
| MEC-001: Observar | BPO-CTX-000034 (Contacto Presente), BPO-CTX-000032 (Defusión), BPO-CTX-000010 (Atención Flexible) | 1-5 |
| MEC-007: Observar sin Intervenir | BPO-CTX-000034 (Contacto Presente), BPO-CTX-000031 (Aceptación) | 1-5 |
| MEC-010: Respirar | BPO-EMO-000004 (Regulación Emocional), BPO-CTX-000034 (Contacto Presente), BPO-EMO-000007 (Tolerancia Malestar) | 1-5 |
| MEC-013: Renombrar | BPO-CTX-000032 (Defusión), BPO-NEU-000003 (Flexibilidad Cognitiva) | 1-5 |
| MEC-016: Distanciamiento | BPO-CTX-000032 (Defusión), BPO-CTX-000039 (Autocompasión) | 1-5 |
| MEC-019: Elegir | BPO-CTX-000038 (Acción Comprometida), BPO-CTX-000037 (Clarificación de Valores) | 1-5 |
| MEC-020: Acercarse | BPO-CON-000004 (Exposición), BPO-CON-000001 (Activación Conductual) | 1-5 |
| MEC-021: Permanecer | BPO-EMO-000007 (Tolerancia Malestar), BPO-CON-000004 (Exposición) | 1-5 |
| MEC-024: Persistir | BPO-MOT-000003 (Persistencia), BPO-CTX-000038 (Acción Comprometida) | 1-5 |
| MEC-029: Autocompasión | BPO-CTX-000039 (Autocompasión), BPO-EMO-000004 (Regulación Emocional) | 1-5 |
| MEC-030: Validación | BPO-CTX-000031 (Aceptación), BPO-EMO-000004 (Regulación Emocional) | 1-5 |
| MEC-032: Escuchar | BPO-INT-000001 (Conexión Social), BPO-INT-000003 (Validación) | 1-5 |
| MEC-037: Conversación Difícil | BPO-INT-000010 (Comunicación Asertiva), BPO-INT-000009 (Reparación) | 1-5 |
| MEC-3D-001: Balloon Burst | BPO-CTX-000032 (Defusión Cognitiva) | 1-5 |
| MEC-3D-002: Resistance Shield | BPO-CTX-000031 (Aceptación), BPO-EMO-000007 (Tolerancia Malestar) | 1-5 |
| MEC-3D-003: Pikmin Missions | BPO-CTX-000038 (Acción Comprometida), BPO-CTX-000037 (Clarificación de Valores) | 1-5 |
| MEC-D-001: Jardín Compartido | BPO-REL-000003 (Sincronía), BPO-INT-000009 (Reparación) | 1-5 |
| MEC-F-001: Reino Familiar | BPO-FAM-000001 (Cohesión), BPO-FAM-000002 (Adaptabilidad) | 1-5 |
| MEC-G-001: Círculo de Confianza | BPO-INT-000001 (Conexión Social), BPO-INT-000006 (Confianza) | 1-5 |

### 5.2. Efectividad de Mecánicas por Proceso BPO

| Proceso BPO | UUID | Mecánicas más efectivas (orden) | Mecánicas secundarias |
|-------------|------|--------------------------------|----------------------|
| Defusión Cognitiva | BPO-CTX-000032 | MEC-001, MEC-013, MEC-016, MEC-015, MEC-3D-001 | MEC-008, MEC-009 |
| Aceptación | BPO-CTX-000031 | MEC-007, MEC-031, MEC-030, MEC-3D-002 | MEC-021, MEC-010 |
| Valores | BPO-CTX-000037 | MEC-019, MEC-041, MEC-039 | MEC-006, MEC-043 |
| Acción Comprometida | BPO-CTX-000038 | MEC-019, MEC-024, MEC-022, MEC-3D-003 | MEC-020, MEC-023 |
| Regulación Emocional | BPO-EMO-000004 | MEC-010, MEC-030, MEC-027 | MEC-011, MEC-031 |
| Autocompasión | BPO-CTX-000039 | MEC-029, MEC-030, MEC-013 | MEC-014, MEC-039 |
| Conexión Social | BPO-INT-000001 | MEC-032, MEC-033, MEC-036 | MEC-037, MEC-035 |
| Comunicación Asertiva | BPO-INT-000010 | MEC-034, MEC-035, MEC-037 | MEC-032, MEC-038 |
| Sincronía de Pareja | BPO-REL-000003 | MEC-D-001, MEC-D-002, MEC-D-003 | MEC-032, MEC-033 |
| Cohesión Familiar | BPO-FAM-000001 | MEC-F-001, MEC-F-002, MEC-F-003 | MEC-036, MEC-041 |

---

## 6. Algoritmos de Recomendación basados en BPG

### 6.1. Propósito
El Exercise Recommender Engine v2.0.0 selecciona el siguiente ejercicio óptimo consultando:

1. **BPG del paciente** (procesos débiles primero, con verificación de aristas del grafo).
2. **Learning Graph** (prerrequisitos, rutas de aprendizaje).
3. **AHEE** (edad, preferencias, metáforas, nivel).
4. **Historial** (qué ejercicios completó y con qué resultados).
5. **Nivel de interacción** (individual, diádico, familiar, grupal).

### 6.2. Estrategias de Recomendación

| Estrategia | Descripción | Cuándo usarla |
|-----------|-------------|---------------|
| **BPG: proceso débil** | Selecciona ejercicios para procesos con menor confianza en el BPG. | Por defecto (reduce incertidumbre clínica). |
| **BPG: arista débil** | Identifica aristas del BPG con bajo peso y busca ejercicios que las fortalezcan. | Cuando la confianza del proceso es aceptable pero las relaciones están débiles. |
| **Prerrequisitos del LG** | Sigue el Learning Graph: si un proceso requiere otro, recomienda primero el prerrequisito. | Cuando el usuario tiene lagunas en habilidades base. |
| **Refuerzo de fortalezas** | Recomienda ejercicios para procesos donde el usuario ya es fuerte. | Cuando necesita motivación o está estancado. |
| **Exploración** | Recomienda ejercicios de procesos no explorados. | En las primeras sesiones. |
| **Multi-nivel** | Recomienda ejercicios del nivel de interacción adecuado (diádico si hay pareja activa, familiar si hay familia activa). | Según el plan de tratamiento. |

### 6.3. Algoritmo de Selección (Pseudocódigo v2.0.0)

```python
class ExerciseRecommenderV2:
    def __init__(self, bpg, learning_graph, ahee_profile, interaction_level="individual"):
        self.bpg = bpg  # MultiDiGraph del paciente
        self.learning_graph = learning_graph
        self.ahee = ahee_profile
        self.interaction_level = interaction_level  # individual/diadico/familiar/grupal

    def recommend(self, user_history):
        # 1. Obtener procesos débiles del BPG (confianza < 0.6)
        weak_processes = self.bpg.get_weak_processes(threshold=0.6)
        
        # 2. Ordenar por confianza ascendente
        weak_processes.sort(key=lambda p: p.confidence)
        
        # 3. Para cada proceso débil, verificar prerrequisitos en el LG
        for process in weak_processes:
            prerequisites = self.learning_graph.get_prerequisites(process.uuid)
            all_prereqs_met = all(
                self.bpg.get_confianza(p) >= 0.7 
                for p in prerequisites
            )
            
            if all_prereqs_met:
                # 4. Verificar que hay ejercicios para el nivel de interacción
                exercises = self.get_exercises_for_process(
                    process, 
                    level=self.interaction_level
                )
                if exercises:
                    return self.select_best_exercise(exercises, user_history)
        
        # 5. Si no hay proceso débil con prerrequisitos listos, explorar
        return self.explore_new_process(user_history)

    def select_best_exercise(self, exercises, history):
        # Filtrar por AHEE
        exercises = [
            e for e in exercises 
            if e.difficulty <= self.ahee.max_difficulty
            and e.duration <= self.ahee.max_duration
        ]
        # Ordenar por efectividad (BSC)
        exercises.sort(key=lambda e: e.effectiveness, reverse=True)
        # Evitar ejercicios completados recientemente
        return self.select_unseen(exercises, history)
```

### 6.4. Integración con AHEE y Nivel de Interacción

El Exercise Recommender v2.0.0 ajusta la recomendación según:

| Variable | Fuente | Ajuste |
|----------|--------|--------|
| **Dificultad máxima** | AHEE | No recomendar ejercicios con dificultad > max_difficulty. |
| **Duración máxima** | AHEE | No recomendar ejercicios con duración > max_duration. |
| **Narrativa preferida** | AHEE | Seleccionar ejercicios con la narrativa preferida. |
| **Nivel de interacción** | BCMS/Plan de Tratamiento | Si el plan indica "diádico", solo recomendar ejercicios con `level: "diadico"`. |
| **Edad del paciente** | BPG/AHEE | Niños: mecánicas simples (nivel 1-2). Adultos: complejas (nivel 3-5). |

---

## 7. Progresión y Dominio de Habilidades (v2.0.0)

### 7.1. Cálculo del Nivel de Dominio

El nivel de dominio de un proceso BPO se calcula a partir de:

```
dominio = (confianza_bpg * 0.4) + (completados / max_completados * 0.2) + 
          (tendencia * 0.2) + (generalizacion * 0.1) + (transferencia * 0.1)
```

| Factor | Fuente | Descripción |
|--------|--------|-------------|
| **confianza_bpg** | BPG | Confianza actual del proceso en el BPG del paciente. |
| **completados** | BERL | Número de ejercicios completados para este proceso. |
| **tendencia** | BPG | Dirección de la confianza (subiendo, bajando, estable). |
| **generalizacion** | BPG | Si la habilidad se aplica en nuevos contextos. |
| **transferencia** | Reportes | Si la habilidad se aplica en la vida real. |

### 7.2. Niveles de Dominio

| Nivel | Rango | Descripción | Acción del sistema |
|-------|-------|-------------|-------------------|
| Base | 0-0.3 | Habilidad no desarrollada o muy incipiente. | Ejercicios básicos de la mecánica principal. |
| En desarrollo | 0.3-0.6 | Habilidad en proceso de consolidación. | Ejercicios de dificultad media, variedad de mecánicas. |
| Consolidado | 0.6-0.8 | Habilidad bien desarrollada. | Ejercicios avanzados, enfoque en generalización. |
| Maestría | 0.8-1.0 | Habilidad plenamente desarrollada. | Reducir frecuencia, ejercicios de mantenimiento. |

### 7.3. Detección de Mesetas

Si un proceso BPO no mejora durante un período (ej. 10 ejercicios en 2 semanas):

1. **Detecta meseta**: La confianza se ha estancado en el BPG.
2. **Propone variación**: Recomienda ejercicios con diferentes mecánicas o niveles.
3. **Cambia nivel de interacción**: Si era individual, sugiere un ejercicio diádico o familiar.
4. **Sugiere reflexión**: El TCCN pregunta al usuario sobre su experiencia.
5. **Escala al terapeuta**: Si la meseta persiste, notifica desde el BCMS.

---

## 8. Soporte Multi-Nivel (v2.0.0)

### 8.1. Niveles de Interacción

| Nivel | Descripción | Ejemplo de ejercicio |
|-------|-------------|---------------------|
| **Individual** | Un paciente, un ejercicio. | "El Bosque de la Incertidumbre" (EXE-001) |
| **Diádico** | Dos personas (pareja). | "Puente de la Conexión" (EXE-020) |
| **Familiar** | Familia (3-6 miembros). | "Reino Familiar" (EXE-030) |
| **Grupal** | Grupo terapéutico (4-8 personas). | "Misiones de Equipo" (EXE-031) |

### 8.2. Cómo Afecta la Recomendación

El motor de procesos ajusta su recomendación según el nivel activo:

- **Individual**: Recomienda ejercicios con `level: "individual"`.
- **Diádico**: Recomienda ejercicios con `level: "diadico"` que entrenan procesos BPO de la pareja (BPO-REL, BPO-INT).
- **Familiar**: Recomienda ejercicios con `level: "familiar"` que entrenan procesos de cohesión (BPO-FAM).
- **Grupal**: Recomienda ejercicios con `level: "grupal"` que entrenan procesos de conexión social (BPO-INT).

### 8.3. Tracking por Nivel

Cada nivel de interacción tiene su propio tracking de progresión:

```json
{
  "patient_id": "uuid-paciente",
  "process_progression": {
    "BPO-CTX-000032": {
      "individual": {"dominio": 0.72, "exercises_completed": 12},
      "diadico": {"dominio": 0.45, "exercises_completed": 4},
      "familiar": null,
      "grupal": null
    }
  }
}
```

---

## 9. Personalización Idiográfica (v2.0.0)

### 9.1. Integración con BPG

El Motor de Procesos consulta el BPG en tiempo real para:

- Obtener el **estado actual** de cada proceso (confianza, tendencia, evidencia).
- Identificar **procesos débiles** (confianza < umbral) que priorizar.
- Verificar **aristas débiles** (relaciones entre procesos con bajo peso).
- Conocer **procesos dominados** que no necesitan más ejercicios.

### 9.2. Integración con Behavioral Twin

Además del BPG, el motor consulta el Behavioral Twin para:

- Obtener la historia de aprendizaje (ejercicios completados, resultados).
- Conocer los valores y objetivos del usuario.
- Identificar hipótesis activas que puedan influir en la recomendación.

### 9.3. Adaptación de la Ruta de Aprendizaje

La ruta se adapta dinámicamente:

- Si el BPG muestra **baja confianza en Defusión**, se priorizan ejercicios de Defusión y sus prerrequisitos.
- Si el BPG muestra **alta confianza en Defusión**, se reduce la frecuencia y se buscan procesos relacionados débiles.
- Si el BPG muestra una **arista débil entre Defusión y Aceptación**, se recomienda un ejercicio que fortalezca esa relación.
- Si el usuario tiene un **valor fuerte en "Conexión familiar"**, se recomiendan ejercicios familiares con mayor frecuencia.

---

## 10. Integración con el Ecosistema v2.0.0

| Motor | Relación con el Motor de Procesos v2.0.0 |
|-------|------------------------------------------|
| **BPO** | El motor **consume** el BPO para definir procesos y sus relaciones en el Learning Graph. |
| **BPG** | El motor **lee** el BPG del paciente para identificar procesos débiles y **actualiza** el BPG con telemetría. |
| **BML v2.0.0** | El motor **utiliza** la BML como paleta de mecánicas, con mapeo a UUID de procesos BPO. |
| **BERL v2.0.0** | BERL **consulta** al motor para seleccionar el siguiente ejercicio óptimo. |
| **AHEE** | El motor **recibe** adaptación de AHEE y ajusta la recomendación por edad, preferencias y nivel. |
| **AAO** | AAO **actualiza** las confianzas en el BPG; el motor las consume para recomendar. |
| **BCMS** | El motor **recibe** prescripciones del terapeuta (nivel de interacción, prioridades). |
| **BSC** | BSC **analiza** datos agregados del motor para investigar qué rutas de aprendizaje son más efectivas. |
| **Ideographic Game Engine** | El motor **proporciona** el proceso objetivo y el perfil BPG para que el IDE genere minijuegos dinámicos. |
| **TCCN** | TCCN **recibe** del motor la información de progresión para guiar conversaciones clínicas. |

---

## 11. Escalabilidad y Rendimiento

### 11.1. Optimización

| Estrategia | Implementación |
|------------|---------------|
| **NetworkX en memoria** | El Learning Graph se carga en memoria para consultas rápidas. |
| **Cache de recomendaciones** | Redis (TTL: 1 hora) para evitar cálculos repetidos. |
| **Actualización asíncrona** | La actualización del BPG (desde telemetría) se procesa de forma asíncrona. |
| **BPG por paciente** | Cada paciente tiene su propio BPG, evitando sobrecarga de un grafo global. |

### 11.2. Métricas de Rendimiento

| Métrica | Objetivo | Herramienta |
|---------|----------|-------------|
| Tiempo de recomendación | < 100 ms | Monitoreo de rendimiento |
| Tamaño del Learning Graph | < 1000 nodos (inicial) | NetworkX |
| Consulta al BPG | < 50 ms | Monitoreo de rendimiento |
| Actualización de confianzas | < 200 ms | Monitoreo de rendimiento |
| Uso de memoria | < 500 MB | Monitoreo de memoria |

---

## 12. Criterios de Validación y Cumplimiento

| Criterio | Métrica | Herramienta |
|----------|---------|-------------|
| **Precisión de recomendaciones** | ≥ 80% de los usuarios completan el ejercicio recomendado. | Analítica de uso |
| **Efectividad clínica** | Mejora en la confianza de los procesos (BPG) después de 10 ejercicios ≥ 0.1. | Análisis de BPG |
| **Secuencia de aprendizaje** | Los usuarios siguen las rutas previstas (prerrequisitos) ≥ 70%. | Analítica de uso |
| **Personalización** | La satisfacción con la personalización ≥ 4/5. | Encuestas in-app |
| **Multi-nivel** | ≥ 60% de los usuarios en plan diádico/familiar completan ejercicios de ese nivel. | Analítica de uso |
| **Escalabilidad** | Soporte para > 10,000 usuarios activos. | Pruebas de carga (k6) |
| **Precisión del Learning Graph** | Las relaciones son validadas por psicólogos (≥ 90%). | Revisión clínica |

---

## 13. El Manifiesto del Motor de Procesos v2.0.0

> *"El aprendizaje no es lineal. Cada persona tiene su propia ruta de desarrollo de habilidades psicológicas.*
>
> *El motor de procesos no impone un camino único; descubre la ruta óptima para cada individuo basándose en su BPG: el grafo vivo de sus procesos, sus fortalezas y sus áreas de crecimiento.*
>
> *Desde v2.0.0, el centro de decisión es el BPG. No recomendamos ejercicios al azar; consultamos el grafo del paciente, verificamos prerrequisitos y seleccionamos el ejercicio con mayor impacto potencial.*
>
> *El aprendizaje no ocurre solo. Ocurre en pareja, en familia, en grupo. El motor soporta todos los niveles de interacción porque el cambio conductual es relacional.*
>
> *El Learning Graph es el mapa del territorio. El BPG es la ubicación del explorador. El motor de procesos es el guía que sugiere el siguiente paso.*
>
> *Nuestra responsabilidad es garantizar que el motor sea preciso, ético, personalizado y efectivo. Que cada recomendación sea un paso hacia una vida más plena."*

---

## 14. Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2026-07-01 | Arquitectura de Gamificación | Creación del documento. Definición del Learning Graph, mapeo de mecánicas a procesos, algoritmos de recomendación, personalización idiográfica, integración con el ecosistema. |
| 2.0.0 | 2026-07-14 | Arquitectura de Gamificación | Migración a BPO como fuente de verdad (UUID). Consulta al BPG del paciente como centro de decisión. Learning Graph dinámico (cruzado con BPG). Mapeo de 47+ mecánicas BML a procesos BPO con UUID. Recomendación basada en BPG (procesos débiles + verificación de prerrequisitos + aristas débiles). Soporte multi-nivel (individual, diádico, familiar, grupal). Tracking de progresión por nivel de interacción. Integración con BCMS e Ideographic Game Engine. |

---

**Fin del documento `process-engine.md` v2.0.0**
