---
id: CP-001
title: Mapeo de Intervenciones Clínicas
version: 2.0.0
status: Stable
owner: Psicología Clínica & Arquitectura de Gamificación
last_updated: 2026-07-14
depends_on:
  - 000-Core/ontology.md (Ontología - procesos)
  - 000-Core/bpo.md (BPO - ontología de procesos computacional)
  - 000-Core/bpg.md (BPG - grafo de procesos del paciente)
  - 500-Experiencies/mechanics-library.md (BML v2.0.0 - mecánicas por proceso)
  - 500-Experiencies/process-engine.md (Motor de procesos v2.0.0 - Learning Graph)
  - 500-Experiencies/experience-engine.md (BERL v2.0.0 - ejercicios)
  - 100-Architecture/behavioral-twin.md (Behavioral Twin - perfil del paciente)
  - 400-AI/adaptive-orchestrator.md (AAO - evaluación)
  - 700-PracticeOS/practice-os.md (BCMS - plan de tratamiento)
  - 000-Infrastructure/selection.md (Infraestructura - opciones gratuitas)
exports:
  - Formulación clínica por PROCESOS (no por diagnóstico)
  - Mapeo de intervenciones a ejercicios gamificados por proceso BPO (UUID)
  - Protocolos de tratamiento por proceso y nivel de interacción
  - Flujo de prescripción (terapeuta → BCMS → BERL → paciente)
  - Adaptación de protocolos por perfil (AHEE + BPG)
  - Soporte multi-nivel: individual, diádico, familiar, grupal
  - Criterios de validación y métricas de éxito
used_by:
  - Terapeutas (BCMS - prescripción de ejercicios)
  - BERL v2.0.0 (selección de ejercicios)
  - BCMS (planificación de intervenciones)
  - AHEE (adaptación de protocolos)
  - BSC (investigación de efectividad de protocolos)
  - Ideographic Game Engine (generación dinámica de minijuegos)
---

# BehavioralOS – Mapeo de Intervenciones Clínicas v2.0.0

> *"Las intervenciones clínicas no son un menú de opciones aisladas. Son secuencias cuidadosamente diseñadas que, combinadas, producen cambio conductual. Desde v2.0.0, la formulación clínica se centra en PROCESOS del BPO, no en diagnósticos del DSM/CIE. Un mismo proceso (ej. 'Defusión') puede ser intervenido desde ACT, FAP, DBT y PBT simultáneamente. Los protocolos se organizan por proceso, por nivel de interacción, y se adaptan al BPG del paciente."*

---

## Cambios v2.0.0 (Resumen)

| Aspecto | v1.0.0 | v2.0.0 |
|---------|--------|--------|
| **Organización** | Por terapia (ACT, FAP, DBT, PBT, Gottman) | **Por proceso BPO** (Defusión, Aceptación, Valores, etc.) |
| **Formulación clínica** | Por diagnóstico funcional | **Por proceso BPO con UUID** (diagnóstico como referencia secundaria) |
| **Fuente de verdad** | Procesos genéricos | **BPO** (ontología computacional con UUID) |
| **Protocolos** | Secuencias fijas por terapia | **Secuencias flexibles por proceso, con múltiples intervenciones** |
| **Multi-nivel** | Individual únicamente | **Individual, diádico, familiar, grupal** |
| **Integración** | BPOS genérico | **BCMS** (plan de tratamiento), **BPG** del paciente |
| **Personalización** | AHEE básico | **AHEE + BPG**: adaptación por perfil y por grafo de procesos |
| **Minijuegos** | Sin soporte | **Generación dinámica según BPG** (Ideographic Game Engine) |

---

## 1. Propósito y Alcance

### 1.1. Propósito
Este documento define el **mapeo de intervenciones clínicas v2.0.0** del BehavioralOS. Su objetivo es:

- **Traducir las intervenciones clínicas** en ejercicios gamificados, **organizadas por proceso BPO** (no por terapia).
- **Formular clínicamente por procesos**: la pregunta nunca es "¿qué diagnóstico tiene?" sino "¿qué procesos debo modificar?".
- **Diseñar protocolos y secuencias de tratamiento** que sean flexibles y se adapten al BPG del paciente.
- **Integrar el plan de tratamiento** del paciente (BCMS) con el sistema de recomendación de ejercicios.
- **Soportar niveles de interacción** individual, diádico, familiar y grupal.
- **Adaptar los protocolos** al perfil del usuario (AHEE) y a su BPG.

### 1.2. Alcance
El documento cubre:

- **Formulación clínica por procesos**: Cómo se evalúa un paciente en términos de procesos BPO, no de diagnósticos.
- **Mapeo de intervenciones a ejercicios por proceso**: Cada proceso BPO (UUID) tiene intervenciones de múltiples terapias disponibles.
- **Protocolos por proceso y nivel**: Secuencias de ejercicios para cada proceso BPO, con variantes por nivel de interacción.
- **Integración con BCMS**: Flujo de prescripción del terapeuta al paciente.
- **Adaptación por BPG y AHEE**: Ajuste de protocolos según el grafo de procesos y el perfil del usuario.
- **Criterios de validación**: Métricas de efectividad de los protocolos.

### 1.3. Principio Fundamental
> **"La pregunta clínica nunca es '¿qué trato?' sino '¿qué proceso debo modificar?'. Un mismo proceso puede ser intervenido desde múltiples terapias. La terapia no es un menú de ejercicios aislados; es una secuencia de experiencias diseñadas para producir cambio en PROCESOS ESPECÍFICOS del BPO."**

---

## 2. Filosofía: Formulación por Procesos, No por Diagnósticos

### 2.1. El Cambio Paradigmático

```
ANTES (v1.0.0):
Diagnóstico: "Ansiedad Generalizada" → Protocolo de ACT → Ejercicios

AHORA (v2.0.0):
Formulación por procesos BPO:
  ├── Fusión Cognitiva (BPO-CTX-000032): 0.82 (alta)
  ├── Aceptación (BPO-CTX-000031): 0.24 (baja)
  ├── Valores (BPO-CTX-000037): 0.61 (media)
  └── Regulación Emocional (BPO-EMO-000004): 0.38 (baja)

Protocolo seleccionado: Fusión Cognitiva
  ├── Intervenciones disponibles:
  │   ├── ACT: Ejercicios de defusión (EXE-001, EXE-006)
  │   ├── DBT: Ejercicios de mindfulness (EXE-003)
  │   ├── PBT: Ejercicios de contacto presente (EXE-010)
  │   └── FAP: Ejercicios de detección en sesión (EXE-009)
  ├── Selección según BPG del paciente
  └── Adaptación según AHEE
```

### 2.2. Por Qué Procesos > Diagnósticos

| Razón | Explicación |
|-------|-------------|
| **Un proceso, múltiples diagnósticos** | La Defusión Cognitiva baja aparece en ansiedad, depresión, TOC, TLP, TEPT, etc. |
| **Un diagnóstico, múltiples procesos** | La "Ansiedad Generalizada" involucra fusión, evitación, baja tolerancia al malestar, valores difusos. |
| **Combinabilidad** | Si organizamos por proceso, podemos combinar intervenciones de diferentes terapias para un mismo proceso. |
| **Evidencia acumulativa** | Podemos medir qué intervención funciona MEJOR para cada proceso, no para cada diagnóstico. |
| **Evitar etiquetas** | Los diagnósticos son etiquetas; los procesos son dimensiones medibles y modificables. |

### 2.3. Principios de Diseño de Protocolos

| # | Principio | Descripción | Manifestación |
|---|-----------|-------------|---------------|
| 1 | **Proceso-centrado** | Los protocolos se organizan alrededor de procesos BPO (con UUID). | Un protocolo de "Defusión" usa ejercicios de ACT, FAP, DBT y PBT. |
| 2 | **Multi-intervención** | Cada protocolo puede incluir intervenciones de múltiples terapias. | Defusión: ACT + DBT + PBT + FAP. |
| 3 | **Secuencial** | Las intervenciones se ordenan según el Learning Graph (prerrequisitos primero). | El motor de procesos guía la secuencia. |
| 4 | **Flexible** | Los protocolos se adaptan al perfil (AHEE) y al BPG del paciente. | Duración, dificultad, narrativa y nivel de interacción se ajustan. |
| 5 | **Multi-nivel** | Los protocolos soportan individual, diádico, familiar y grupal. | Cada protocolo declara sus variantes por nivel. |
| 6 | **Basado en evidencia** | Los protocolos se basan en la ciencia del comportamiento. | Cada secuencia está respaldada por evidencia (BSC). |
| 7 | **Iterativo** | Los protocolos se mejoran continuamente con telemetría. | El BSC actualiza protocolos basándose en datos agregados. |

### 2.4. Estructura de un Protocolo v2.0.0

| Componente | Descripción | Ejemplo |
|------------|-------------|---------|
| **Nombre** | Nombre del protocolo. | "Protocolo de Defusión Cognitiva" |
| **Proceso BPO objetivo** | UUID del proceso BPO a modificar. | BPO-CTX-000032 (Defusión Cognitiva) |
| **Nivel de interacción** | Individual, diádico, familiar, grupal. | Individual (con variantes diádicas) |
| **Intervenciones disponibles** | Terapias que pueden intervenir este proceso. | ACT, DBT, PBT, FAP |
| **Prerrequisitos** | Procesos BPO que deben estar desarrollados antes. | BPO-CTX-000034 (Contacto con el Presente) |
| **Secuencia de ejercicios** | Lista ordenada de ejercicios del BERL v2.0.0. | EXE-001 → EXE-006 → EXE-009 → EXE-010 |
| **Duración estimada** | Tiempo total estimado. | 4 semanas (2 ejercicios/semana) |
| **Criterios de progreso** | Cuándo avanzar al siguiente nivel. | Confianza BPG en Defusión > 0.6 |
| **Criterios de éxito** | Cuándo se considera completado. | Confianza BPG > 0.8 y generalización > 0.6 |

---

## 3. Mapeo de Intervenciones a Ejercicios por Proceso BPO

### 3.1. Proceso: Defusión Cognitiva (BPO-CTX-000032)

| Intervención | Ejercicios (BERL v2.0.0) | Mecánicas principales | Niveles de profundidad |
|-------------|-------------------------|----------------------|------------------------|
| **ACT** | EXE-001 "El Bosque de la Incertidumbre", EXE-006 "La Tormenta de la Defusión" | MEC-001, MEC-016, MEC-013 | 1-5 |
| **DBT** | EXE-003 "El Faro del Equilibrio" (mindfulness), EXE-009 "Globos de los Pensamientos" (3D) | MEC-007, MEC-009, MEC-3D-001 | 1-5 |
| **PBT** | EXE-010 "Río de la Defusión" (3D) | MEC-3D-004, MEC-007 | 1-5 |
| **FAP** | EXE-009 "Globos de los Pensamientos" (detección en sesión) | MEC-002, MEC-3D-001 | 2-4 |

### 3.2. Proceso: Aceptación (BPO-CTX-000031)

| Intervención | Ejercicios (BERL v2.0.0) | Mecánicas principales | Niveles de profundidad |
|-------------|-------------------------|----------------------|------------------------|
| **ACT** | EXE-004 "El Laberinto de la Aceptación", EXE-011 "Escudo de Resistencia" (3D) | MEC-021, MEC-031, MEC-3D-002 | 1-5 |
| **DBT** | EXE-003 "El Faro del Equilibrio" (tolerancia al malestar), EXE-012 "Jardín de la Apertura" | MEC-010, MEC-027, MEC-031 | 1-5 |
| **PBT** | EXE-012 "Jardín de la Apertura" | MEC-007, MEC-031 | 1-5 |
| **TIP** | EXE-011 "Escudo de Resistencia" (3D) | MEC-3D-002, MEC-010 | 2-4 |

### 3.3. Proceso: Acción Comprometida (BPO-CTX-000038)

| Intervención | Ejercicios (BERL v2.0.0) | Mecánicas principales | Niveles de profundidad |
|-------------|-------------------------|----------------------|------------------------|
| **ACT** | EXE-002 "La Montaña de los Valores", EXE-008 "La Expedición de la Flexibilidad" | MEC-019, MEC-024, MEC-041 | 1-5 |
| **PBT** | EXE-008 "La Expedición de la Flexibilidad", EXE-013 "Misiones Pikmin" (3D) | MEC-006, MEC-022, MEC-3D-003 | 1-5 |
| **DBT** | EXE-002 "La Montaña de los Valores" (compromiso con valores) | MEC-019, MEC-041 | 2-4 |

### 3.4. Proceso: Regulación Emocional (BPO-EMO-000004)

| Intervención | Ejercicios (BERL v2.0.0) | Mecánicas principales | Niveles de profundidad |
|-------------|-------------------------|----------------------|------------------------|
| **DBT** | EXE-003 "El Faro del Equilibrio" (respiración, escaneo), EXE-007 "El Espejo de la Autocompasión" | MEC-010, MEC-011, MEC-029 | 1-5 |
| **ACT** | EXE-007 "El Espejo de la Autocompasión" | MEC-029, MEC-030 | 1-5 |
| **Gottman** | EXE-003 "El Faro del Equilibrio" (coregulación en pareja) | MEC-010, MEC-027 | 3-5 |

### 3.5. Proceso: Validación / Conexión Social (BPO-INT-000001 / BPO-INT-000003)

| Intervención | Ejercicios (BERL v2.0.0) | Mecánicas principales | Niveles de profundidad |
|-------------|-------------------------|----------------------|------------------------|
| **FAP** | EXE-020 "Puente de la Conexión" (diádico), EXE-005 "El Puente de las Relaciones" | MEC-032, MEC-033, MEC-036 | 2-5 |
| **DBT** | EXE-020 "Puente de la Conexión" (efectividad interpersonal) | MEC-032, MEC-034, MEC-035 | 2-5 |
| **Gottman** | EXE-020 "Puente de la Conexión", EXE-021 "Jardín Compartido" (diádico) | MEC-032, MEC-033, MEC-D-001 | 3-5 |
| **TIP** | EXE-020 "Puente de la Conexión" (reparación) | MEC-038, MEC-033 | 3-5 |

### 3.6. Proceso: Cohesión Familiar (BPO-FAM-000001)

| Intervención | Ejercicios (BERL v2.0.0) | Mecánicas principales | Niveles de profundidad |
|-------------|-------------------------|----------------------|------------------------|
| **Sistémico** | EXE-030 "Reino Familiar" (familiar), EXE-031 "Misiones de Equipo" (grupal) | MEC-F-001, MEC-F-002 | 1-5 |
| **PBT** | EXE-030 "Reino Familiar" (valores familiares) | MEC-F-003, MEC-041 | 1-5 |
| **Gottman** | EXE-021 "Jardín Compartido" (diádico, significado compartido) | MEC-D-001, MEC-041 | 3-5 |

### 3.7. Proceso: Flexibilidad Cognitiva (BPO-NEU-000003)

| Intervención | Ejercicios (BERL v2.0.0) | Mecánicas principales | Niveles de profundidad |
|-------------|-------------------------|----------------------|------------------------|
| **Neuropsicología** | EXE-008 "La Expedición de la Flexibilidad" | MEC-003, MEC-004, MEC-014 | 2-4 |
| **ACT** | EXE-008 "La Expedición de la Flexibilidad" (cambio de marco) | MEC-014, MEC-018 | 2-5 |
| **PBT** | EXE-008 "La Expedición de la Flexibilidad" | MEC-003, MEC-014 | 1-5 |

---

## 4. Protocolos de Tratamiento por Proceso (v2.0.0)

### 4.1. Protocolo: Defusión Cognitiva

**Proceso BPO**: BPO-CTX-000032 (Defusión Cognitiva)
**Nivel**: Individual (con variante diádica)
**Prerrequisitos**: BPO-CTX-000034 (Contacto con el Presente) ≥ 0.5

| Fase | Ejercicio | Intervención | Frecuencia | Criterio de progreso |
|------|-----------|-------------|------------|---------------------|
| **Fase 1 (Sem 1-2)** | EXE-001 "El Bosque de la Incertidumbre" (nivel 1-2) | ACT | 3x/semana | Confianza BPG > 0.5 |
| **Fase 2 (Sem 3-4)** | EXE-006 "La Tormenta de la Defusión" (nivel 2-3) | ACT/DBT | 3x/semana | Confianza BPG > 0.6 |
| **Fase 3 (Sem 5-6)** | EXE-009 "Globos de los Pensamientos" (3D, nivel 3-4) | DBT/FAP | 2x/semana | Confianza BPG > 0.7 |
| **Fase 4 (Sem 7-8)** | EXE-010 "Río de la Defusión" (3D, generalización) | PBT | 2x/semana | Confianza > 0.8, generalización > 0.6 |

**Criterios de éxito**: Confianza BPG en Defusión > 0.8 y generalización > 0.6.

**Variante diádica** (si aplica):
| Fase | Ejercicio | Intervención | Frecuencia |
|------|-----------|-------------|------------|
| Fase 2-3 | MEC-D-002 "Conversación del Puente" | FAP/Gottman | 1x/semana |

### 4.2. Protocolo: Aceptación y Tolerancia al Malestar

**Procesos BPO**: BPO-CTX-000031 (Aceptación) + BPO-EMO-000007 (Tolerancia al Malestar)
**Nivel**: Individual
**Prerrequisitos**: BPO-CTX-000034 (Contacto con el Presente) ≥ 0.4

| Fase | Ejercicio | Intervención | Frecuencia | Criterio de progreso |
|------|-----------|-------------|------------|---------------------|
| **Fase 1 (Sem 1-2)** | EXE-003 "El Faro del Equilibrio" (respiración) | DBT | Diario | Práctica diaria completada |
| **Fase 2 (Sem 3-4)** | EXE-004 "El Laberinto de la Aceptación" (nivel 1-2) | ACT | 3x/semana | Confianza BPG Aceptación > 0.5 |
| **Fase 3 (Sem 5-6)** | EXE-011 "Escudo de Resistencia" (3D, nivel 2-3) | ACT/TIP | 3x/semana | Confianza BPG > 0.6 |
| **Fase 4 (Sem 7-8)** | EXE-012 "Jardín de la Apertura" (generalización) | PBT | 2x/semana | Confianza > 0.7, evitación < 0.4 |

**Criterios de éxito**: Confianza BPG en Aceptación > 0.7 y evitación < 0.4.

### 4.3. Protocolo: Acción Comprometida y Valores

**Procesos BPO**: BPO-CTX-000038 (Acción Comprometida) + BPO-CTX-000037 (Clarificación de Valores)
**Nivel**: Individual
**Prerrequisitos**: BPO-CTX-000032 (Defusión) ≥ 0.4, BPO-CTX-000031 (Aceptación) ≥ 0.4

| Fase | Ejercicio | Intervención | Frecuencia | Criterio de progreso |
|------|-----------|-------------|------------|---------------------|
| **Fase 1 (Sem 1-2)** | EXE-002 "La Montaña de los Valores" (nivel 1-2) | ACT | 3x/semana | Confianza BPG Valores > 0.5 |
| **Fase 2 (Sem 3-4)** | EXE-008 "La Expedición de la Flexibilidad" (nivel 2-3) | ACT/PBT | 3x/semana | Confianza BPG Acción > 0.6 |
| **Fase 3 (Sem 5-6)** | EXE-013 "Misiones Pikmin" (3D, microacciones reales) | PBT/ACT | 3x/semana | Confianza BPG > 0.7 |
| **Fase 4 (Sem 7-8)** | MEC-F-003 "Árbol de Valores" (familiar, si aplica) | Sistémico | 1x/semana | Generalización > 0.6 |

**Criterios de éxito**: Confianza BPG en Acción Comprometida > 0.7.

### 4.4. Protocolo: Regulación Emocional (DBT)

**Proceso BPO**: BPO-EMO-000004 (Regulación Emocional)
**Nivel**: Individual (con variante familiar)
**Prerrequisitos**: Ninguno (proceso base)

| Fase | Ejercicio | Intervención | Frecuencia | Criterio de progreso |
|------|-----------|-------------|------------|---------------------|
| **Fase 1 (Sem 1-2)** | EXE-003 "El Faro del Equilibrio" (respiración, escaneo) | DBT | Diario | Práctica diaria completada |
| **Fase 2 (Sem 3-4)** | EXE-003 "El Faro del Equilibrio" (mindfulness) | DBT | 3x/semana | Confianza BPG > 0.5 |
| **Fase 3 (Sem 5-6)** | EXE-007 "El Espejo de la Autocompasión" (validación) | DBT/ACT | 3x/semana | Confianza BPG > 0.6 |
| **Fase 4 (Sem 7-8)** | EXE-004 "El Laberinto de la Aceptación" (tolerancia) | ACT | 2x/semana | Confianza > 0.7 |

**Criterios de éxito**: Confianza BPG en Regulación Emocional > 0.7.

### 4.5. Protocolo: Validación de Pareja (Gottman/TIP)

**Procesos BPO**: BPO-INT-000003 (Validación) + BPO-REL-000003 (Sincronía)
**Nivel**: **Diádico**
**Prerrequisitos**: Ambos miembros con BPO-INT-000001 (Conexión Social) ≥ 0.4

| Fase | Ejercicio | Intervención | Frecuencia | Criterio de progreso |
|------|-----------|-------------|------------|---------------------|
| **Fase 1 (Sem 1-2)** | EXE-020 "Puente de la Conexión" (escuchar, validar) | Gottman/FAP | 2x/semana | Confianza BPG Validación > 0.5 |
| **Fase 2 (Sem 3-4)** | MEC-D-001 "Jardín Compartido" (cooperación) | Gottman | 2x/semana | Confianza BPG Sincronía > 0.5 |
| **Fase 3 (Sem 5-6)** | MEC-D-002 "Conversación del Puente" (conversación difícil) | Gottman/TIP | 1x/semana | Confianza BPG > 0.6 |
| **Fase 4 (Sem 7-8)** | EXE-021 "Jardín Compartido" (significado compartido) | Gottman | 1x/semana | Confianza > 0.7 |

**Criterios de éxito**: Confianza BPG en Sincronía > 0.7 y satisfacción relacional ≥ 4/5.

### 4.6. Protocolo: Cohesión Familiar

**Procesos BPO**: BPO-FAM-000001 (Cohesión) + BPO-FAM-000002 (Adaptabilidad)
**Nivel**: **Familiar**
**Prerrequisitos**: Todos los miembros con BPO-INT-000001 ≥ 0.3

| Fase | Ejercicio | Intervención | Frecuencia | Criterio de progreso |
|------|-----------|-------------|------------|---------------------|
| **Fase 1 (Sem 1-2)** | MEC-F-003 "Árbol de Valores" (valores compartidos) | Sistémico | 1x/semana | Valores familiares identificados |
| **Fase 2 (Sem 3-4)** | EXE-030 "Reino Familiar" (roles, cooperación) | Sistémico/PBT | 1x/semana | Confianza BPG Cohesión > 0.5 |
| **Fase 3 (Sem 5-6)** | MEC-F-002 "Misiones de Equipo" (comunicación) | Sistémico | 1x/semana | Confianza BPG > 0.6 |
| **Fase 4 (Sem 7-8)** | EXE-031 "Misiones de Equipo" (grupal) | Sistémico | 1x/semana | Confianza > 0.7 |

**Criterios de éxito**: Confianza BPG en Cohesión > 0.7 y satisfacción familiar ≥ 4/5.

---

## 5. Integración con BCMS (Plan de Tratamiento)

### 5.1. Flujo de Prescripción v2.0.0

```
1. Evaluación inicial
   → Entrevista clínica + AAO actualiza BPG
   → BPG muestra procesos débiles (confianza < umbral)
   
2. Formulación por procesos
   → Terapeuta identifica procesos BPO objetivo (con UUID)
   → BCMS muestra procesos débiles y procesos relacionados
   
3. Selección de protocolo
   → BCMS sugiere protocolo para el proceso más débil
   → Terapeuta selecciona (o el sistema sugiere basado en BPG)
   
4. Personalización
   → Protocolo se adapta: AHEE (edad, preferencias) + BPG (confianzas)
   → Se selecciona nivel de interacción (individual/diadico/familiar/grupal)
   
5. Programación
   → BCMS programa ejercicios en la agenda del paciente
   → Cada ejercicio tiene fecha, hora y recordatorio
   
6. Ejecución
   → Paciente realiza ejercicios → telemetría al BPG
   → BPG se actualiza → dashboard del terapeuta se actualiza
   
7. Revisión
   → Terapeuta revisa progreso (BPG + telemetría)
   → Ajusta protocolo si es necesario
   → Si hay meseta → escalar o cambiar intervención
```

### 5.2. Interfaz para el Terapeuta (BCMS)

```
┌─────────────────────────────────────────────────────────────────────────┐
│ Plan de Tratamiento: María González                                     │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│ Formulación por Procesos BPO:                                           │
│ ├── Defusión (BPO-CTX-000032): 0.35 [Prioridad: ALTA] ▼                │
│ ├── Aceptación (BPO-CTX-000031): 0.40 [Prioridad: MEDIA] ▼             │
│ ├── Regulación Emocional (BPO-EMO-000004): 0.55 [Prioridad: MEDIA]     │
│ └── Valores (BPO-CTX-000037): 0.61 [Prioridad: BAJA]                   │
│                                                                         │
│ Protocolo activo: Defusión Cognitiva                                    │
│ Fase actual: Fase 2 (Semana 3-4)                                        │
│ Progreso: ██████░░░░░░ 60%                                              │
│                                                                         │
│ Intervenciones utilizadas: ACT, DBT                                     │
│ Próximo ejercicio sugerido: EXE-006 "La Tormenta de la Defusión"        │
│                                                                         │
│ Nivel de interacción: Individual                                        │
│ [Cambiar a Diádico] [Cambiar a Familiar]                                │
│                                                                         │
│ [Añadir ejercicio] [Cambiar protocolo] [Ver BPG] [Ver progreso]         │
└─────────────────────────────────────────────────────────────────────────┘
```

### 5.3. Integración con el Sistema de Recomendación

- **El terapeuta puede anular** la recomendación del sistema.
- **El sistema puede sugerir ajustes** basándose en telemetría (ej. "Baja adherencia → reducir frecuencia").
- **La decisión del terapeuta se registra** y se utiliza para mejorar el sistema (BSC).
- **El BPG se actualiza** con cada ejercicio completado, afectando las siguientes recomendaciones.

---

## 6. Adaptación de Protocolos (AHEE + BPG)

### 6.1. Variables de Adaptación

| Variable | Fuente | Ajuste del protocolo |
|----------|--------|----------------------|
| **Edad** | BPG/AHEE | Niños: ejercicios cortos, narrativa de fantasía. Adolescentes: gamificación social. Adultos: ejercicios completos. Adultos mayores: ejercicios cortos, narrativa de naturaleza. |
| **Nivel de habilidad** | BPG | Ajustar la dificultad según confianza del proceso en el BPG. |
| **Preferencias narrativas** | AHEE | Seleccionar ejercicios con la narrativa preferida. |
| **Estado emocional** | AAO/BPG | Si el BPG muestra alta activación, priorizar regulación y reducir duración. |
| **Fatiga** | AAO | Reducir duración y frecuencia. |
| **Adherencia** | Analítica | Si baja adherencia, reducir frecuencia o cambiar a ejercicios más cortos. |
| **BPG: procesos débiles** | BPG | Priorizar procesos con menor confianza en el BPG. |
| **BPG: aristas débiles** | BPG | Incluir ejercicios que fortalezcan relaciones entre procesos. |

### 6.2. Ejemplo de Adaptación

**Perfil**: Usuario de 9 años, con TEA, baja adherencia, BPG muestra Fusión alta (0.82) y Aceptación baja (0.24).

**Protocolo original**: Defusión Cognitiva (4 semanas, 3 ejercicios/semana).

**Protocolo adaptado (AHEE + BPG)**:
- **Ejercicios más cortos**: 3 min en lugar de 5-8.
- **Narrativa de fantasía**: "El Bosque de los Dragones" en lugar de "El Bosque de la Incertidumbre".
- **Frecuencia reducida**: 2 ejercicios/semana.
- **Mecánica 3D prioritaria**: Usar Balloon Burst (3D) para mayor engagement.
- **Validación constante**: El TCCN da más feedback positivo.
- **BPG como guía**: Dado que Fusión es alta y Aceptación es baja, priorizar ejercicios que impacten Aceptación después de las primeras fases de Defusión.

---

## 7. Criterios de Validación y Cumplimiento

| Criterio | Métrica | Herramienta |
|----------|---------|-------------|
| **Efectividad de protocolos** | Tamaño del efecto > 0.3 (Cohen's d) para procesos BPO objetivo. | Análisis estadístico (BSC) |
| **Impacto en BPG** | Cambio medible en confianza del proceso BPO después del protocolo. | Análisis de BPG |
| **Adherencia** | ≥ 70% de ejercicios programados completados. | Analítica de uso |
| **Satisfacción del terapeuta** | ≥ 4/5 en encuestas de usabilidad del BCMS. | Encuestas |
| **Personalización** | ≥ 80% de usuarios reportan que los ejercicios se ajustan a sus necesidades. | Encuestas in-app |
| **Tiempo de configuración** | Terapeuta configura un protocolo en < 5 minutos. | Pruebas de usabilidad |
| **Multi-nivel** | ≥ 60% de usuarios en plan diádico/familiar completan ejercicios de ese nivel. | Analítica de uso |
| **Mejora continua** | Protocolos se actualizan al menos una vez al año con nueva evidencia (BSC). | Revisión anual |

---

## 8. El Manifiesto de los Protocolos Clínicos v2.0.0

> *"La terapia no es un menú de ejercicios aislados. Es una secuencia de experiencias diseñadas para producir cambio en PROCESOS ESPECÍFICOS del BPO.*
>
> *Desde v2.0.0, la pregunta nunca es '¿qué terapia utilizo?' sino '¿qué proceso debo modificar?'. Un mismo proceso puede ser intervenido desde ACT, FAP, DBT y PBT. Elegimos la intervención que mejor funciona para ese proceso y ese paciente.*
>
> *Los protocolos no son camisas de fuerza; son guías flexibles que se adaptan al BPG del paciente, a su perfil (AHEE) y al nivel de interacción (individual, diádico, familiar, grupal).*
>
> *Cada ejercicio modifica el BPG. Cada modificación del BPG afecta las siguientes recomendaciones. El sistema aprende del paciente, y el paciente aprende de sí mismo.*
>
> *Nuestra responsabilidad es garantizar que los protocolos sean efectivos, personalizados, basados en evidencia y fáciles de usar para los terapeutas. Que cada ejercicio sea un paso hacia una vida más plena."*

---

## 9. Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2026-07-01 | Psicología Clínica | Creación del documento. Mapeo de intervenciones por terapia (ACT, FAP, DBT, PBT, Gottman, TIP, Neuropsicología), protocolos de tratamiento, integración con BPOS, adaptación por AHEE. |
| 2.0.0 | 2026-07-14 | Psicología Clínica | Reorganización por procesos BPO (UUID) en lugar de por terapia. Formulación clínica por procesos, no por diagnósticos. Protocolos multi-intervención (ACT+FAP+DBT+PBT para un mismo proceso). Soporte multi-nivel (individual, diádico, familiar, grupal). Integración con BCMS y BPG. Adaptación por BPG + AHEE. Protocolos de pareja (Gottman) y familiar (Sistémico). |

---

**Fin del documento `clinical-processes.md` v2.0.0**
