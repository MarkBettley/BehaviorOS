---
id: BCIE-001
title: Behavioral Caseload Intelligence Engine (BCIE) — Motor de Inteligencia para Gestión de Carga Clínica
version: 1.0.0
status: Draft
owner: Arquitectura de Software & Psicología Clínica
last_updated: 2026-07-14
depends_on:
  - BCMS (Behavioral Clinical Management System)
  - 400-AI (Gemma, RAG, BKGE, Adaptive Orchestrator)
exports:
  - 15 submotores de inteligencia de carga clínica
  - Behavioral Clinical Load Index (BCLI) — índice compuesto de carga
  - Behavioral Continuity Index (BCoI) — indicador de continuidad
  - Caseload Analyzer
  - Priority Engine
  - Risk Stratification Engine
  - Dropout Prediction Engine
  - Engagement Monitor
  - Clinical Workload Optimizer
  - Therapist Capacity Engine
  - Follow-up Intelligence
  - Waiting List Optimizer
  - Session Frequency Optimizer
  - Resource Allocation Engine
  - Clinical Heatmap Engine
  - Productivity Analytics
  - Burnout Prevention Engine
  - Caseload Dashboard
  - Behavioral Scheduling Intelligence (BSI) — submotor de programación
used_by:
  - BCMS (Behavioral Clinical Management System)
  - Therapist Workspace (escritorio del terapeuta)
  - Patient App (dashboard del paciente)
  - BCOE (Behavioral Clinic Operations Engine)
  - BSI (Behavioral Scheduling Intelligence)
  - BARS (Behavioral Analytics & Reporting System)
  - BRIL (Behavioral Runtime Integration Layer)
  - BCGS (Behavioral Clinical Governance System)
---

# BehavioralOS — Behavioral Caseload Intelligence Engine (BCIE)

> *"El BCIE no reemplaza al terapeuta. No toma decisiones clínicas. No cambia tratamientos. Responde constantemente una pregunta: ¿Dónde debería concentrar hoy mi atención clínica?"*

---

## 1. Propósito y Alcance

### 1.1. Propósito

El Behavioral Caseload Intelligence Engine (BCIE) es el **motor de inteligencia para la gestión de carga clínica** que analiza continuamente el estado de todos los pacientes, prioriza el trabajo del terapeuta, identifica riesgos operativos y clínicos, optimiza el seguimiento y ayuda a distribuir eficientemente los recursos del consultorio o clínica.

El BCIE es el equivalente al **"piloto automático" del consultorio**. Ningún software actual (SimplePractice, TherapyNotes, Cliniko) administra la carga clínica — administran agendas, pero no ayudan a priorizar.

### 1.2. Filosofía

No todos los pacientes requieren el mismo nivel de seguimiento. No todas las semanas tienen la misma carga clínica. No todos los terapeutas tienen la misma disponibilidad.

El BCIE intenta equilibrar tres elementos:
- **Bienestar del paciente**
- **Calidad clínica**
- **Sostenibilidad del terapeuta**

### 1.3. Objetivos

El BCIE debe:
- Priorizar pacientes
- Detectar riesgo de abandono
- Detectar estancamiento terapéutico
- Detectar recaídas tempranas
- Organizar seguimientos
- Distribuir carga entre terapeutas
- Reducir olvidos administrativos
- Mejorar continuidad terapéutica

### 1.4. Dependencias

- **BCMS**: agendas, expedientes, sesiones y datos de pacientes
- **400-AI**: modelos de predicción, RAG, orquestación adaptativa

### 1.5. Contexto

Un psicólogo puede tener 30 pacientes, pero:
- 5 requieren atención inmediata
- 10 van muy bien
- 8 necesitan pequeños ajustes
- 7 están a punto de abandonar el tratamiento

**Ningún software actual ayuda a priorizar eso.** Ahí entra el BCIE.

---

## 2. Arquitectura

```
Behavioral Caseload Intelligence Engine (BCIE)
│
├── Caseload Analyzer
├── Priority Engine
├── Risk Stratification Engine
├── Dropout Prediction Engine
├── Engagement Monitor
├── Clinical Workload Optimizer
├── Therapist Capacity Engine
├── Follow-up Intelligence
├── Waiting List Optimizer
├── Session Frequency Optimizer
├── Resource Allocation Engine
├── Clinical Heatmap Engine
├── Productivity Analytics
├── Burnout Prevention Engine
├── Caseload Dashboard
│
└── Behavioral Scheduling Intelligence (BSI) [submotor]
    ├── Availability Engine
    ├── Preference Learning Engine
    ├── Continuity Optimizer
    ├── Session Frequency Engine
    ├── Smart Recommendation Engine
    ├── Cancellation Predictor
    ├── Rescheduling Engine
    ├── Waiting List Optimizer
    ├── Calendar Synchronization Layer
    ├── Reminder Intelligence
    ├── Attendance Prediction Engine
    ├── Scheduling Conflict Resolver
    ├── Multiuser Coordination Engine
    ├── Behavioral Routine Analyzer
    ├── Treatment Milestone Scheduler
    └── Scheduling Analytics
```

---

## 3. Submotores Detallados

### 3.1. Caseload Analyzer

**Propósito**: Analizar continuamente todos los casos activos, yendo más allá del simple conteo de pacientes.

**Análisis por caso**:
- Complejidad de la formulación
- Frecuencia de sesiones requerida
- Evolución clínica (mejoría, estancamiento, deterioro)
- Adherencia al tratamiento
- Tipo de tratamiento (individual, pareja, familiar, neuropsicología)
- Intensidad del seguimiento entre sesiones

**Ejemplo**:
```
Terapeuta: 42 pacientes
  ├── Complejidad Alta: 18
  ├── Complejidad Media: 14
  └── Complejidad Baja: 10
```

**Integraciones**:
- BCMS → datos de pacientes y sesiones
- Assessment Manager → resultados de evaluaciones
- BPO/BPG → procesos psicológicos activos por caso

---

### 3.2. Priority Engine

**Propósito**: Asignar una prioridad dinámica a cada paciente que cambia diariamente.

**Factores de prioridad**:
- Tiempo sin sesión
- Cambios bruscos en indicadores de evaluación
- Adherencia a tareas
- Evolución clínica
- Respuestas a escalas
- Cumplimiento de objetivos del plan
- Asistencia (ausencias, cancelaciones)
- Solicitudes del paciente

**Ejemplo**:
```
Paciente A → Prioridad: 98 (Muy alta)
Paciente B → Prioridad: 23 (Baja)
```

La prioridad cambia **diariamente**. No es un valor estático.

**Integraciones**:
- BCMS → datos de agenda y expedientes
- Assessment Manager → resultados de evaluaciones recientes
- Homework Manager → adherencia a tareas
- Progress Monitoring Manager → tendencias de indicadores

---

### 3.3. Risk Stratification Engine

**Propósito**: Clasificar automáticamente los casos en niveles de riesgo operativo (no diagnóstico).

**Niveles**:

| Nivel | Significado | Acción sugerida |
|-------|-------------|-----------------|
| **Verde** | Seguimiento rutinario | Mantener plan actual |
| **Amarillo** | Vigilancia | Monitorear indicadores de cerca |
| **Naranja** | Revisión próxima | Revisar formulación y plan |
| **Rojo** | Prioridad clínica | Acción inmediata requerida |

> Esta clasificación **no es un sistema diagnóstico**. Es una clasificación operativa para ayudar a organizar el trabajo.

**Integraciones**:
- BCMS → datos clínicos del paciente
- BCIE → Dropout Prediction y Engagement Monitor
- BXE → explicación de por qué un caso tiene determinado nivel

---

### 3.4. Dropout Prediction Engine

**Propósito**: Predecir la probabilidad de que un paciente abandone el tratamiento.

**Variables analizadas**:
- Cancelaciones frecuentes
- Poca interacción con la app
- Tareas no realizadas
- Largos períodos sin actividad
- Disminución de participación en ejercicios

**Ejemplo**:
```
Probabilidad estimada de abandono: 74%
Factores asociados:
  • 3 cancelaciones consecutivas
  • Sin ejercicios completados en 12 días
  • Sin respuesta a recordatorios
```

> La predicción debe mostrarse como una **estimación**, nunca como un hecho.

**Integraciones**:
- BCMS → datos de asistencia y cancelaciones
- Homework Manager → cumplimiento de tareas
- BSI → patrones de programación y asistencia
- Notification Center → alertas de seguimiento sugerido

---

### 3.5. Engagement Monitor

**Propósito**: Calcular el nivel de participación del paciente durante todo el tratamiento.

**Métricas de engagement**:
- Ejercicios completados
- Diarios y autorregistros
- Participación en videojuegos terapéuticos
- Tareas conductuales
- Seguimiento entre sesiones
- Mensajes y comunicación con el terapeuta
- Interacción general con la app

**Integraciones**:
- BERL → telemetría de ejercicios y videojuegos
- Homework Manager → tareas completadas
- BCMS → interacciones registradas
- Progress Monitoring Manager → indicadores consolidados

---

### 3.6. Clinical Workload Optimizer

**Propósito**: Distribuir la carga clínica por complejidad, no por número de pacientes.

**Ejemplo**:
```
Terapeuta A: 20 pacientes → Carga estimada: 82%
Terapeuta B: 30 pacientes → Carga estimada: 61%
```

Porque los casos son diferentes. Un paciente con terapia de pareja + rehabilitación neuropsicológica pesa mucho más que uno en fase de seguimiento mensual.

**Integraciones**:
- Caseload Analyzer → complejidad por caso
- Therapist Capacity Engine → capacidad disponible
- BCOE → distribución de recursos operativos
- BCGS → políticas de asignación de casos

---

### 3.7. Therapist Capacity Engine

**Propósito**: Calcular la capacidad real disponible del terapeuta, no solo sus horas libres.

**Factores considerados**:
- Horas disponibles en la agenda
- Tipo de casos que puede atender (especialización, experiencia)
- Carga actual estimada (Clinical Workload Optimizer)
- Supervisiones pendientes
- Tiempo administrativo requerido
- Disponibilidad real vs. teórica

**Integraciones**:
- BCMS → agenda del terapeuta
- Clinical Workload Optimizer → carga actual
- BCOE → datos operativos de disponibilidad
- BCIE → Burnout Prevention Engine

---

### 3.8. Follow-up Intelligence

**Propósito**: Sugerir seguimientos inteligentes basados en el contexto del paciente.

**Ejemplos**:
```
Paciente: no responde hace 8 días
  → Sugerencia: enviar seguimiento personalizado

Paciente: alta con mejoría
  → Seguimiento: mensual

Paciente: alta con recaída previa
  → Seguimiento: quincenal durante 3 meses
```

**Integraciones**:
- BCMS → estado del paciente y último contacto
- BCIE → Dropout Prediction y Risk Stratification
- BSI → programación de seguimientos
- Notification Center → envío de recordatorios de seguimiento

---

### 3.9. Waiting List Optimizer

**Propósito**: Cuando un terapeuta no tiene espacio, sugerir redistribución o priorizar la lista de espera.

**Funciones**:
- Priorización de la lista de espera por urgencia y compatibilidad
- Sugerencia de redistribución entre terapeutas
- Matching por especialización y disponibilidad
- Notificación automática al paciente cuando se libera un espacio
- Coordinación con BSI para encontrar el mejor horario

**Integraciones**:
- BCMS → lista de espera activa
- Therapist Capacity Engine → disponibilidad de terapeutas
- BSI → optimización de programación
- BCOE → datos operativos de capacidad

---

### 3.10. Session Frequency Optimizer

**Propósito**: Sugerir la frecuencia ideal de sesiones para cada paciente, que no tiene por qué ser fija.

**Ejemplo**:
```
Paciente mejorando → cada 15 días
Paciente empeorando → semanal
Paciente en programa intensivo → dos veces por semana
```

**Siempre como sugerencia. Nunca automática.**

**Integraciones**:
- BCIE → evolución del caso y priorización
- BSI → programación de la frecuencia sugerida
- Treatment Plan Manager → intensidad del plan activo
- BXE → explicación de por qué se sugiere esa frecuencia

---

### 3.11. Resource Allocation Engine

**Propósito**: Distribuir eficientemente consultorios, horarios, terapeutas, supervisores y evaluadores.

**Especialmente útil para clínicas con múltiples profesionales.**

**Recursos distribuidos**:
- Consultorios físicos
- Salas virtuales
- Horarios de terapeutas
- Supervisores disponibles
- Evaluadores especializados
- Equipos neuropsicológicos

**Integraciones**:
- BCOE → Resource Management Engine y Room & Equipment Manager
- Therapist Capacity Engine → disponibilidad de profesionales
- BCIE → Caseload Analyzer y Clinical Workload Optimizer

---

### 3.12. Clinical Heatmap Engine

**Propósito**: Generar mapas visuales de la carga clínica.

**Ejemplo**:
```
Pacientes:
  ██████  Alta prioridad
  ███     Media
  █       Baja

También puede mostrar:
  - Semanas más cargadas
  - Horarios saturados
  - Tipos de consulta predominantes
```

**Integraciones**:
- BCIE → todos los submotores como fuente de datos
- Caseload Dashboard → visualización consolidada
- BCOE → Operational Analytics

---

### 3.13. Productivity Analytics

**Propósito**: Medir productividad **por calidad**, no por cantidad de pacientes.

**Indicadores**:
```
Seguimientos realizados: 98%
Adherencia promedio: 87%
Planes actualizados: 95%
Reportes pendientes: 2
```

> Estos indicadores describen la operación clínica y no deben interpretarse como medidas de eficacia clínica por sí mismos.

**Integraciones**:
- BCMS → datos de seguimiento y documentación
- Homework Manager → adherencia
- Treatment Plan Manager → estado de planes
- Clinical Documentation Engine → reportes generados

---

### 3.14. Burnout Prevention Engine

**Propósito**: Analizar la carga del terapeuta para prevenir sobrecarga.

**Ejemplo**:
```
Casos complejos: 26
Fatiga estimada: Alta
Recomendación: No aceptar más casos complejos esta semana
```

> No evalúa la salud mental del terapeuta; únicamente analiza indicadores operativos relacionados con la carga de trabajo.

**Integraciones**:
- Clinical Workload Optimizer → carga actual
- Therapist Capacity Engine → capacidad restante
- Caseload Analyzer → distribución de complejidad
- BCOE → datos operativos de productividad

---

### 3.15. Caseload Dashboard

**Propósito**: Pantalla principal que consolida todo lo que el terapeuta necesita ver al inicio del día.

**Ejemplo**:
```
Hoy
  ├── Pacientes prioritarios: 5
  ├── Seguimientos sugeridos: 8
  ├── Evaluaciones pendientes: 3
  ├── Programas por finalizar: 4
  └── Alertas: 2
```

**Todo en un solo lugar.**

**Integraciones**:
- Todos los submotores del BCIE como fuentes de datos
- BCMS → datos de agenda y pacientes
- Notification Center → alertas consolidadas

---

## 4. Índices Compuestos

### 4.1. Behavioral Clinical Load Index (BCLI)

El BCIE calcula un **índice compuesto** para estimar la carga operativa de cada caso:

**Variables del BCLI**:
- Complejidad de la formulación
- Intensidad del plan terapéutico
- Frecuencia de sesiones
- Adherencia del paciente
- Tiempo requerido para documentación
- Seguimiento entre sesiones

> Este índice ayuda a distribuir casos de forma más equilibrada **sin reemplazar el criterio del coordinador clínico**.

### 4.2. Behavioral Continuity Index (BCoI)

Además de la carga, el BCIE calcula un **indicador de continuidad terapéutica**:

**Variables del BCoI**:
- Regularidad de asistencia
- Cumplimiento de tareas
- Estabilidad de los objetivos
- Continuidad del terapeuta (sin cambios frecuentes)
- Participación en el ecosistema digital

> Permite detectar de forma temprana tratamientos que empiezan a fragmentarse.

---

## 5. Integración con el Ecosistema

El BCIE funciona como la **capa de inteligencia operativa** del BCMS:

| Motor | Integra con BCIE para... |
|-------|--------------------------|
| BCMS | Agenda, expedientes y sesiones para analizar carga clínica |
| BCAS, BAD | Resultados de evaluaciones para priorizar casos |
| BIMS | Estado del plan de intervención y adherencia a tareas |
| BPAS | Patrones de personalización para ajustar intensidad de seguimiento |
| BDSS | Información contextual que mejora recomendaciones al terapeuta |
| BCCE | Indicadores de consistencia clínica en la priorización |
| BXE | Explicar por qué un caso fue clasificado con determinada prioridad |
| BARS | Tableros administrativos con métricas de carga, continuidad y eficiencia |
| BCGS | Políticas de privacidad y acceso según roles definidos |

---

## 6. Posición Arquitectónica

```
BCMS
│
├── BCIE
│   │
│   ├── Caseload Analyzer
│   ├── Priority Engine
│   ├── Risk Stratification Engine
│   ├── Dropout Prediction Engine
│   ├── Engagement Monitor
│   ├── Clinical Workload Optimizer
│   ├── Therapist Capacity Engine
│   ├── Follow-up Intelligence
│   ├── Waiting List Optimizer
│   ├── Session Frequency Optimizer
│   ├── Resource Allocation Engine
│   ├── Clinical Heatmap Engine
│   ├── Productivity Analytics
│   ├── Burnout Prevention Engine
│   ├── Caseload Dashboard
│   │
│   └── BSI (Behavioral Scheduling Intelligence)
│       └── [ver bsi-spec.md]
│
└── BCOE
    └── [ver bcoe-spec.md]
```

Esta integración es más limpia arquitectónicamente y mantiene la filosofía: **pocos motores muy sólidos, en lugar de muchos motores pequeños con responsabilidades solapadas**.

---

## 7. Métricas de Éxito

| Métrica | Objetivo |
|---------|----------|
| Detección temprana de abandono | > 80% de precisión en predicciones |
| Tiempo de respuesta del Caseload Dashboard | < 500ms |
| Satisfacción del terapeuta con priorización | NPS > 40 |
| Reducción de olvidos administrativos | > 70% |
| Mejora en continuidad terapéutica (BCoI) | > 15% en 6 meses |
| Alertas de Burnout Prevention aceptadas | > 60% |
