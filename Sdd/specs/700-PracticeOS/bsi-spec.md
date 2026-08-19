---
id: BSI-001
title: Behavioral Scheduling Intelligence (BSI) — Submotor de Programación Inteligente
version: 1.0.0
status: Draft
owner: Arquitectura de Software & Psicología Clínica
last_updated: 2026-07-14
depends_on:
  - BCIE (Behavioral Caseload Intelligence Engine)
  - BCMS (Behavioral Clinical Management System)
exports:
  - 16 submotores de programación inteligente
  - Availability Engine
  - Preference Learning Engine
  - Continuity Optimizer
  - Session Frequency Engine
  - Smart Recommendation Engine
  - Cancellation Predictor
  - Rescheduling Engine
  - Waiting List Optimizer
  - Calendar Synchronization Layer
  - Reminder Intelligence
  - Attendance Prediction Engine
  - Scheduling Conflict Resolver
  - Multiuser Coordination Engine
  - Behavioral Routine Analyzer
  - Treatment Milestone Scheduler
  - Scheduling Analytics
  - Dashboard del Paciente (tarjeta de progreso)
  - Dashboard del Terapeuta
used_by:
  - BCMS (Appointment Manager, Session Manager)
  - BCIE (Priority Engine, Follow-up Intelligence)
  - BCOE (Resource Management, Operational Analytics)
  - Therapist App (recomendaciones de agenda)
  - Patient App (dashboard de tratamiento y programación)
  - BARS (métricas de programación)
  - BRIL (Runtime Integration Layer)
---

# BehavioralOS — Behavioral Scheduling Intelligence (BSI)

> *"El BSI no agenda por el usuario. No obliga. No modifica automáticamente el calendario. Su función es proponer la mejor decisión posible para ambas partes. Si funciona bien, la gente simplemente sentirá que 'la app siempre encuentra el mejor momento para las sesiones'."*

---

## 1. Propósito y Alcance

### 1.1. Propósito

El Behavioral Scheduling Intelligence (BSI) es el **submotor del BCIE** encargado de optimizar la programación, continuidad y coordinación inteligente de las sesiones clínicas, considerando simultáneamente la evolución terapéutica, disponibilidad del paciente, disponibilidad del terapeuta, adherencia, carga clínica, preferencias personales y continuidad del tratamiento.

### 1.2. Filosofía

Una agenda no debe organizar únicamente horarios. Debe organizar **procesos terapéuticos**. Cada sesión ocurre en un contexto diferente:

- Hay pacientes con turnos rotativos
- Estudiantes con horarios variables
- Padres con responsabilidades familiares
- Terapeutas con distintos niveles de carga
- Programas intensivos que requieren mayor frecuencia

El BSI entiende ese contexto y adapta la programación.

> **El BSI responde: ¿Cuándo debería agendar una sesión?**
> Mientras que el BASP responde: ¿Bajo qué reglas clínicas debe evolucionar la frecuencia?

### 1.3. Objetivos

El BSI busca:
- Maximizar la continuidad terapéutica
- Minimizar cancelaciones
- Reducir tiempos muertos
- Disminuir abandonos
- Facilitar la organización del paciente
- Equilibrar la agenda del terapeuta
- Respetar preferencias personales
- Evitar sobrecarga clínica

### 1.4. Dependencias

- **BCIE**: prioridad, riesgo de abandono, continuidad y carga clínica
- **BCMS**: agenda clínica, expedientes y disponibilidad de terapeutas

### 1.5. Posición Arquitectónica

```
BCMS
└── BCIE
    ├── Caseload Analyzer
    ├── Dropout Prediction
    ├── Follow-up Intelligence
    ├── BSI (Behavioral Scheduling Intelligence) ← ESTE MÓDULO
    ├── Session Frequency Optimizer
    ├── Waiting List Optimizer
    └── Burnout Prevention
```

El BSI es un **submotor del BCIE**, no un módulo independiente. La programación de citas depende directamente de la inteligencia sobre la carga clínica, el riesgo de abandono, la continuidad del tratamiento y la disponibilidad.

---

## 2. Arquitectura

```
Behavioral Scheduling Intelligence (BSI)
│
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

### 3.1. Availability Engine

**Propósito**: Construir un perfil dinámico de disponibilidad del paciente y el terapeuta.

**No almacena únicamente horarios fijos. Aprende del comportamiento.**

**Ejemplo**:
```
Paciente declara:
  Disponible: Lunes 18:00-20:00, Miércoles 19:00-21:00, Sábado 10:00-13:00

El motor también observa:
  Últimos 20 agendamientos → Siempre rechazó Martes → Reducir prioridad de martes
```

**Funciones**:
- Registro de disponibilidad declarada por el paciente
- Aprendizaje de patrones de disponibilidad real
- Descuento de días horarios consistentemente rechazados
- Soporte para disponibilidad rotativa (turnos de trabajo)
- Zona horaria del paciente y del terapeuta
- Disponibilidad del terapeuta (horarios fijos, variables, guardias)

**Integraciones**:
- BCMS → Appointment Manager para disponibilidad del terapeuta
- BSI → Preference Learning Engine para detectar patrones
- BSI → Behavioral Routine Analyzer para rutinas del paciente
- BSI → Calendar Synchronization Layer para calendarios externos

---

### 3.2. Preference Learning Engine

**Propósito**: Aprender patrones de preferencia sin necesidad de configurarlos todos manualmente.

**Ejemplos**:
```
Paciente siempre agenda después del trabajo
  → Preferencia detectada: horarios vespertinos

Nunca acepta sesiones antes de las 9 AM
  → Registrar preferencia: evitar mañanas
```

**Funciones**:
- Detección automática de preferencias por patrones de comportamiento
- Aprendizaje de preferencias declaradas por el paciente
- Actualización continua de preferencias
- Preferencias de modalidad (online vs. presencial)
- Preferencias de duración de sesión
- Preferencias de día de la semana
- Manejo de restricciones (trabajo, escuela, guardias, hijos, viajes)

**Integraciones**:
- BSI → Availability Engine para actualizar disponibilidad
- BCMS → Patient Registry para preferencias declaradas
- BSI → Cancellation Predictor para evitar horarios problemáticos
- BSI → Smart Recommendation Engine como entrada de recomendaciones

---

### 3.3. Continuity Optimizer

**Propósito**: Mantener el ritmo terapéutico, no llenar huecos de agenda.

> **Este es uno de los motores principales.** Su objetivo no es llenar agenda; es mantener la continuidad del tratamiento.

**Ejemplo**:
```
Programa: 12 semanas
Sesión ideal: cada 7 días
Retraso actual: 3 días → Sin impacto relevante

Otro caso:
Retraso: 21 días → Puede afectar la continuidad → Priorizar reagendamiento
```

**Funciones**:
- Cálculo de ritmo terapéutico ideal por programa
- Detección de brechas entre sesiones
- Estimación de impacto de retrasos
- Sugerencias de reagendamiento preventivo
- Priorización de continuidad sobre llenado de agenda
- Coordinación con Treatment Plan Manager para hitos

**Integraciones**:
- BCIE → Risk Stratification y Dropout Prediction
- Treatment Plan Manager → fase del tratamiento y frecuencia planificada
- BSI → Session Frequency Engine para ajuste dinámico
- BSI → Rescheduling Engine para reagendamiento inteligente
- BXE → explicación del impacto estimado del retraso

---

### 3.4. Session Frequency Engine

**Propósito**: Determinar la frecuencia ideal de sesiones que nunca es fija.

**Factores considerados**:
- Fase del tratamiento (inicio, intervención, consolidación, seguimiento)
- Intensidad del programa terapéutico
- Evolución clínica del paciente
- Adherencia observada
- Disponibilidad del paciente

**Ejemplo**:
```
Inicio → Semanal
Después de mejoría → Quincenal
Seguimiento → Mensual
```

> **Siempre como sugerencia para el terapeuta. Nunca automática.**

**Integraciones**:
- BCIE → Caseload Analyzer y Priority Engine
- Treatment Plan Manager → fase y tipo de programa
- Progress Monitoring Manager → tendencias de indicadores
- BSI → Continuity Optimizer para mantener ritmo
- BASP → políticas adaptativas de programación (si está implementado)

---

### 3.5. Smart Recommendation Engine

**Propósito**: Ser el cerebro del BSI. En lugar de mostrar un calendario vacío, mostrar **recomendaciones inteligentes**.

**Ejemplo**:
```
Se recomienda agendar entre Martes y Jueves,
después de las 18:00
Probabilidad estimada de asistencia: 95%
```

**Funciones**:
- Generación de ventanas de tiempo óptimas
- Scoring de cada posible horario
- Consideración simultánea de todos los factores del BSI
- Presentación de 2-3 opciones óptimas
- Explicación del razonamiento detrás de cada recomendación
- Actualización en tiempo real de recomendaciones

**Integraciones**:
- Todos los submotores del BSI como entradas
- BXE → explicación de por qué se recomienda ese horario
- BCIE → prioridad del paciente como factor de ranking
- Attendance Prediction Engine → probabilidad de asistencia por opción

---

### 3.6. Cancellation Predictor

**Propósito**: Analizar patrones históricos para predecir la probabilidad de cancelación.

**Ejemplo**:
```
Últimos 8 viernes → 4 cancelaciones → Reducir prioridad de viernes

Otro caso:
Paciente cancela cuando agenda antes del trabajo → No sugerir mañanas
```

**Funciones**:
- Análisis de patrones de cancelación por día, hora y contexto
- Predicción de probabilidad de cancelación por slot
- Incorporación de factores externos (clima, vacaciones, eventos)
- Actualización continua del modelo
- Integración con Smart Recommendation Engine para ponderar opciones

**Integraciones**:
- BCMS → Appointment Manager para historial de cancelaciones
- BSI → Availability Engine para patrones de disponibilidad real
- BCIE → Dropout Prediction para correlacionar cancelaciones con abandono
- BSI → Rescheduling Engine para preparar alternativas

---

### 3.7. Rescheduling Engine

**Propósito**: Cuando ocurre una cancelación, buscar el espacio con **mayor probabilidad de éxito**, no el siguiente libre.

**Funciones**:
- Detección inmediata de cancelación
- Búsqueda de alternativas compatibles
- Priorización por probabilidad de asistencia del paciente
- Consideración de continuidad terapéutica
- Notificación al paciente con opciones pre-seleccionadas
- Coordinación con Waiting List Optimizer para reasignar espacio liberado

**Integraciones**:
- BSI → Cancellation Predictor para probabilidades
- BSI → Availability Engine para compatibilidad horaria
- BCIE → Priority Engine para priorizar reagendamiento urgente
- BSI → Waiting List Optimizer para espacio liberado
- Notification Center → notificación de alternativas al paciente

---

### 3.8. Waiting List Optimizer

**Propósito**: Cuando se libera un espacio, buscar automáticamente el paciente compatible.

**Criterios de matching**:
- Horario compatible
- Modalidad compatible (presencial/online)
- Duración de sesión requerida
- Prioridad clínica
- Probabilidad de aceptación

**Ejemplo**:
```
Se liberó un espacio: Hoy 18:00
  → Paciente compatible encontrado
  → Se le pregunta: "Se liberó un espacio. ¿Quieres tomarlo?"
```

**Integraciones**:
- BCMS → lista de espera activa
- BCIE → Priority Engine para ranking de pacientes en lista
- BSI → Availability Engine para compatibilidad horaria
- Attendance Prediction Engine → probabilidad de que acepten
- Notification Center → envío de invitación opcional

---

### 3.9. Calendar Synchronization Layer

**Propósito**: Sincronizar opcionalmente con calendarios externos, sin que la agenda oficial dependa de ellos.

**Calendarios soportados**:
- Google Calendar
- Outlook Calendar
- Apple Calendar

> **La agenda oficial sigue siendo la del BCMS.** Nunca depende exclusivamente de servicios externos.

**Funciones**:
- Importación de eventos de calendarios externos
- Exportación de citas del BCMS a calendarios externos
- Resolución de conflictos entre fuentes
- Sincronización bidireccional configurable
- Modo unidireccional (solo lectura de externo)
- Manejo de zonas horarias

**Integraciones**:
- BCMS → Appointment Manager como fuente primaria
- BSI → Availability Engine para eventos externos
- BSI → Scheduling Conflict Resolver para resolver duplicados
- BCOE → configuración por organización (si habilitar sincronización)

---

### 3.10. Reminder Intelligence

**Propósito**: Enviar recordatorios contextuales, no genéricos de "tu sesión es mañana".

**Ejemplos**:
```
Recordatorio 1:
  "Tu sesión es mañana. Has completado 80% de tus ejercicios.
   Excelente trabajo."

Recordatorio 2:
  "Hace 5 días no practicas. Tu próxima sesión es en 2 días.
   ¿Quieres hacer un ejercicio rápido antes de la sesión?"
```

**Funciones**:
- Recordatorios de sesión con contexto clínico
- Recordatorios de ejercicios pendientes
- Recordatorios de evaluaciones por completar
- Sugerencias de preparación pre-sesión
- Personalización de tono y frecuencia
- Coordinación con Reminder Intelligence del BCMS

**Integraciones**:
- Homework Manager → tareas pendientes
- Assessment Manager → evaluaciones programadas
- BCIE → Dropout Prediction para recordatorios preventivos
- BSI → Treatment Milestone Scheduler para hitos próximos
- BCGS → preferencias de comunicación del paciente

---

### 3.11. Attendance Prediction Engine

**Propósito**: Calcular una probabilidad de asistencia para cada cita utilizando únicamente información autorizada por el usuario.

**Variables posibles**:
- Historial de asistencia
- Frecuencia de cancelaciones
- Puntualidad
- Tiempo de respuesta a confirmaciones
- Preferencias registradas

**Ejemplo**:
```
Probabilidad estimada: 96%
  (basado en: 95% de asistencia histórica, confirma rápido, sin cancelaciones recientes)
```

> Estas estimaciones deben basarse únicamente en información que el paciente haya proporcionado o autorizado y deben presentarse como **probabilidades, no como certezas**.

**Integraciones**:
- BCMS → Appointment Manager para historial de asistencia
- BSI → Cancellation Predictor para correlacionar factores
- BSI → Smart Recommendation Engine como factor de scoring
- BSI → Rescheduling Engine para priorizar alternativas
- BCGS → consentimiento para uso de datos de predicción

---

### 3.12. Scheduling Conflict Resolver

**Propósito**: Detectar y resolver conflictos de agenda automáticamente.

**Ejemplo**:
```
Paciente agendó dos sesiones el mismo día
  → Sugerir reorganización

Terapeuta tiene dos citas superpuestas
  → Alertar y sugerir reasignación
```

**Funciones**:
- Detección de sobreposiciones de citas
- Detección de doble booking del paciente
- Detección de doble booking del terapeuta
- Sugerencias de reorganización
- Resolución automática de conflictos menores
- Escalación al terapeuta para conflictos complejos

**Integraciones**:
- BCMS → Appointment Manager como fuente de citas
- BSI → Multiuser Coordination Engine para conflictos multi-paciente
- BSI → Availability Engine para alternativas disponibles
- Notification Center → alertas de conflicto

---

### 3.13. Multiuser Coordination Engine

**Propósito**: Coordinar horarios entre múltiples participantes, especialmente importante para terapia de pareja y familiar.

**Ejemplo**:
```
Pareja:
  Persona A disponible: Lunes 19:00
  Persona B disponible: Lunes 20:00
  → Mejor opción: Lunes 20:00 (ambos disponibles)

Familia:
  Padre, Madre, Hijo → Intersección de horarios
  → Horario sugerido: el que cubra a todos
```

**Funciones**:
- Cálculo de intersección de disponibilidades
- Priorización por compatibilidad con el terapeuta
- Soporte para sesiones donde no todos participan
- Coordinación de sesiones individuales complementarias
- Manejo de asistencia parcial (miembros que no pueden asistir)

**Integraciones**:
- BSI → Availability Engine para disponibilidad de cada participante
- BCMS → Appointment Manager para tipo de servicio (pareja, familiar)
- BSI → Smart Recommendation Engine para opciones compatibles
- BSI → Scheduling Conflict Resolver para conflictos multi-paciente
- BIMS → tipo de intervención para determinar quiénes participan

---

### 3.14. Behavioral Routine Analyzer

**Propósito**: Analizar rutinas del paciente para favorecer adherencia, no para vigilar.

**Ejemplo**:
```
Paciente siempre realiza los ejercicios el domingo
  → Recomendar sesiones el lunes (aprovechar el momentum)

Paciente trabaja turnos rotativos
  → No asumir mismo horario semanal
```

**Funciones**:
- Detección de rutinas de ejercicio y práctica
- Análisis de patrones de actividad en la app
- Identificación de días y horarios más productivos
- Adaptación de recomendaciones según rutina detectada
- Detección de cambios en rutina (posible alerta)

**Integraciones**:
- Homework Manager → patrones de cumplimiento de tareas
- BERL → telemetría de ejercicios realizados
- BSI → Preference Learning Engine para enriquecer preferencias
- BSI → Smart Recommendation Engine como entrada de rutinas
- BCIE → Engagement Monitor para correlacionar rutina con participación

---

### 3.15. Treatment Milestone Scheduler

**Propósito**: Relacionar la agenda con el plan terapéutico y sus hitos clínicos.

**Ejemplo**:
```
Programa Ansiedad → Semana 4 → Aplicar Evaluación Continua
Programa Pareja → Sesión 6 → Ejercicio cooperativo BERL
```

> Todo se programa automáticamente **como sugerencia**.

**Funciones**:
- Mapeo de hitos del plan terapéutico a fechas de agenda
- Sugerencia de evaluaciones en puntos clave
- Programación de hitos de revisión del plan
- Coordinación con BASP para políticas de programación
- Alertas cuando se acerca un hito sin sesión programada

**Integraciones**:
- Treatment Plan Manager → hitos y fechas del plan
- Assessment Manager → evaluaciones programadas por ruta
- BSI → Continuity Optimizer para mantener continuidad en hitos
- BASP → políticas de frecuencia por fase del tratamiento
- BSI → Reminder Intelligence para alertas de hitos próximos
- BXE → explicación de por qué ese hito es relevante

---

### 3.16. Scheduling Analytics

**Propósito**: Generar indicadores de la operación de programación.

**Indicadores**:
- Porcentaje de asistencia
- Tasa de cancelaciones
- Tasa de reprogramaciones
- Puntualidad promedio
- Continuidad del tratamiento (BCoI)
- Tiempo promedio entre sesiones
- Ocupación de agenda
- Tiempos muertos
- Utilización de horarios por tipo de día/hora

**Integraciones**:
- BCMS → Appointment Manager como fuente de datos
- BSI → todos los submotores como fuentes de métricas
- BCOE → Operational Analytics para consolidación
- BARS → reportes ejecutivos

---

## 4. Dashboard del Paciente

El paciente ve en la app una tarjeta de progreso de su tratamiento:

```
───────────────────────────────
Tu tratamiento
  ██████████░░  75%

Sesiones completadas:    9/12
Próxima recomendada:     Esta semana
Adherencia:              92%
Ejercicios:              87%
Continuidad:             Excelente
───────────────────────────────
```

> Esto es mucho más motivante que simplemente ver un calendario.

---

## 5. Dashboard del Terapeuta

```
Hoy
───────────────────────
Sesiones:                6
  Confirmadas:           5
  Pendiente:             1
Pacientes prioritarios:  3
Seguimientos sugeridos:  4
Espacios disponibles:    2
───────────────────────
```

---

## 6. Integración con el Ecosistema

| Motor | Integra con BSI para... |
|-------|--------------------------|
| BCMS | Agenda clínica, expedientes y disponibilidad de terapeutas |
| BCIE | Niveles de prioridad, riesgo de abandono, continuidad y carga clínica |
| BCAS, BAD | Programar evaluaciones iniciales, intermedias y finales según plan |
| BIMS | Sincronizar sesiones con objetivos e intervenciones activas |
| BERL | Sugerir momentos oportunos para ejercicios antes/después de sesiones |
| Terapia Individual, Pareja, Familiar, Neuropsicología | Adaptar lógica de programación según tipo de servicio |
| BCGS | Respetar políticas de privacidad, consentimiento y comunicación |
| BCCE, BXE | Justificar por qué se recomendó determinada frecuencia u horario |

---

## 7. Métricas de Éxito

| Métrica | Objetivo |
|---------|----------|
| Tasa de asistencia a sesiones | > 90% |
| Tasa de cancelaciones | < 10% |
| Tiempo promedio entre cancelación y reagendamiento | < 2 horas |
| Satisfacción del terapeuta con recomendaciones | NPS > 45 |
| Satisfacción del paciente con programación | NPS > 50 |
| Continuidad terapéutica (BCoI) | > 85% |
| Tiempo de respuesta del Smart Recommendation Engine | < 300ms |
| Precisión del Attendance Prediction Engine | > 80% |
