---
id: BCMS-002
title: Behavioral Clinical Management System (BCMS) — Sistema Operativo del Psicólogo Conductual
version: 2.0.0
status: Draft
owner: Arquitectura de Software & Psicología Clínica
last_updated: 2026-07-14
depends_on:
  - 100-Architecture (Event Sourcing, Data Model, System Architecture)
  - 200-Backend (API Graph, Database Graph, Events & Workflows)
  - BCI (Behavioral Clinical Intake)
  - BAD (Behavioral Assessment Designer)
  - BCDSL (Behavioral Clinical DSL)
  - BKC (Behavioral Knowledge Compiler)
  - BKS (Behavioral Knowledge Simulator)
  - BPO (Behavioral Process Ontology)
  - BPG (Behavioral Process Graph)
  - BERL (Behavioral Exercise Research Lab)
  - BESS (Behavioral Evidence Scenario Set)
  - BTVE (Behavioral Theoretical Validation Engine)
  - BCCE (Behavioral Clinical Consistency Engine)
  - BXE (Behavioral Explainability Engine)
  - BCGS (Behavioral Clinical Governance System)
exports:
  - 20 submódulos clínicos
  - Patient Registry (registro unificado de pacientes)
  - Therapist Workspace (escritorio principal del terapeuta)
  - Appointment Manager (gestión de citas multi-modal)
  - Clinical Intake Manager (preentrevista inteligente)
  - Assessment Manager (evaluación continua y puntual)
  - Clinical Record Manager (expediente basado en objetos clínicos)
  - Case Formulation Manager (formulación dinámica)
  - Treatment Plan Manager (plan vivo y adaptativo)
  - Session Manager (ciclo completo de sesión)
  - Homework Manager (tareas conectadas con BERL)
  - Progress Monitoring Manager (monitoreo multi-indicador)
  - Clinical Timeline (línea temporal clínica)
  - Clinical Documentation Engine (notas SOAP/DAP/BIRP generadas por IA)
  - Supervisor Workspace (supervisión con control RBAC)
  - Clinical Collaboration Layer (trabajo colaborativo inter-profesional)
  - Notification Center (recordatorios inteligentes contextuales)
  - Automation Engine (automatización de procesos clínicos)
  - Clinical Search Engine (búsqueda semántica clínica)
  - Archive Manager (archivado, retención, exportación)
  - Audit Manager (trazabilidad completa de modificaciones)
  - Behavioral Caseload Intelligence Engine (BCIE) — submódulo
  - Behavioral Clinic Operations Engine (BCOE) — submódulo de operaciones
  - Behavioral Scheduling Intelligence (BSI) — submotor del BCIE
used_by:
  - Therapist App (interfaz principal del terapeuta)
  - Patient App (portal del paciente)
  - BCIE (Behavioral Caseload Intelligence Engine)
  - BCOE (Behavioral Clinic Operations Engine)
  - BSI (Behavioral Scheduling Intelligence)
  - BIMS (Behavioral Intervention Management System)
  - BARS (Behavioral Analytics & Reporting System)
  - BRIL (Behavioral Runtime Integration Layer)
---

# BehavioralOS — Behavioral Clinical Management System (BCMS) v2.0.0

> *"El BCMS no es un expediente electrónico. Es un Behavioral Clinical Operating System. Toda la práctica clínica gira alrededor de él. El psicólogo nunca debería perder tiempo administrando información; debería dedicar ese tiempo a analizar e intervenir clínicamente."*

---

## 1. Propósito y Alcance

### 1.1. Propósito

El Behavioral Clinical Management System (BCMS) es el **sistema integral de gestión clínica** que coordina pacientes, terapeutas, expedientes, sesiones, planes de tratamiento, seguimiento, documentación clínica, supervisión y operación diaria del consultorio o clínica dentro del ecosistema Behavioral.

No es únicamente un EMR (Electronic Medical Record). Es un **Behavioral Clinical Operating System (BCOS)**. Toda la plataforma trabaja alrededor de este núcleo.

### 1.2. Filosofía

El BCMS tiene un principio fundamental:

> **El psicólogo nunca debería perder tiempo administrando información; debería dedicar ese tiempo a analizar e intervenir clínicamente.**

- Todo aquello que sea administrativo debe **automatizarse**.
- Todo aquello que sea repetitivo debe **sugerirse**.
- Todo aquello que sea manual debe **reducirse**.

### 1.3. Objetivos

El BCMS administra todo el ciclo clínico completo:

```
Paciente nuevo → Preentrevista → Evaluación → Formulación → Plan →
Sesiones → Seguimiento → Alta → Seguimiento post alta
```

Todo permanece conectado.

### 1.4. Dependencias

- **100-Architecture**: Event Sourcing, Data Model, System Architecture
- **200-Backend**: API Graph, Database Graph, Events & Workflows
- **Capa de conocimiento**: BPO, BPG, BCDSL, BKC, BKS, BESS, BTVE, BCCE, BXE, BCGS
- **Motores clínicos**: BCI, BAD, BERL, BKS
- **Motor de ejecución**: BIMS (se integra pero no depende para existir)

### 1.5. Diferenciación vs. v1.0.0

La versión 1.0.0 (PracticeOS/BPOS) implementaba un consultorio digital básico: agenda, expediente, videoterapia, notas y CRM. La versión 2.0.0 transforma el BCMS en un **sistema operativo clínico completo** con inteligencia de carga (BCIE), optimización de agenda (BSI) y operaciones del negocio (BCOE) como submódulos nativos.

---

## 2. Arquitectura General

```
Behavioral Clinical Management System (BCMS)
│
├── Patient Registry
├── Therapist Workspace
├── Appointment Manager
├── Clinical Intake Manager
├── Assessment Manager
├── Clinical Record Manager
├── Case Formulation Manager
├── Treatment Plan Manager
├── Session Manager
├── Homework Manager
├── Progress Monitoring Manager
├── Clinical Timeline
├── Clinical Documentation Engine
├── Supervisor Workspace
├── Clinical Collaboration Layer
├── Notification Center
├── Automation Engine
├── Clinical Search Engine
├── Archive Manager
├── Audit Manager
│
├── Behavioral Caseload Intelligence Engine (BCIE) [submódulo]
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
│   └── Behavioral Scheduling Intelligence (BSI) [submotor]
│       ├── Availability Engine
│       ├── Preference Learning Engine
│       ├── Continuity Optimizer
│       ├── Session Frequency Engine
│       ├── Smart Recommendation Engine
│       ├── Cancellation Predictor
│       ├── Rescheduling Engine
│       ├── Waiting List Optimizer
│       ├── Calendar Synchronization Layer
│       ├── Reminder Intelligence
│       ├── Attendance Prediction Engine
│       ├── Scheduling Conflict Resolver
│       ├── Multiuser Coordination Engine
│       ├── Behavioral Routine Analyzer
│       ├── Treatment Milestone Scheduler
│       └── Scheduling Analytics
│
└── Behavioral Clinic Operations Engine (BCOE) [submódulo]
    ├── Clinic Administration Engine
    ├── Resource Management Engine
    ├── Staff Management Engine
    ├── Room & Equipment Manager
    ├── Financial Operations Engine
    ├── Billing & Subscription Engine
    ├── Payment Intelligence Engine
    ├── Operational Workflow Engine
    ├── Patient Journey Operations
    ├── Document Management Engine
    ├── Communication Center
    ├── Notification Center (operativo)
    ├── Inventory Manager
    ├── Operational Analytics
    ├── Multi-Branch Manager
    ├── Compliance Operations
    ├── Automation Engine (operativo)
    └── Organization Settings
```

---

## 3. Submódulos Detallados

### 3.1. Patient Registry

**Propósito**: Administrar toda la información del paciente en un registro unificado y navegable.

**Funciones**:
- Datos personales, de contacto y demográficos
- Tipo de terapia asignada (individual, pareja, familiar, neuropsicología)
- Terapeuta(s) asignado(s) y nivel de supervisión
- Programas activos y membresías vinculadas
- Estado clínico actual (activo, inactivo, alta, seguimiento)
- Historial completo de interacciones con la plataforma
- Perfiles múltiples (paciente como usuario, paciente como beneficiario)
- Gestión de consentimientos vinculados (BCGS)

**Datos que maneja**:
- Identidad del paciente (nombre, fecha de nacimiento, género, idioma)
- Información de contacto (teléfono, correo, dirección, zona horaria)
- Tipo de servicio contratado y modalidad (presencial, online, híbrida)
- Referencia y canal de origen
- Estado operativo y clínico
- Relaciones familiares y de pareja (para terapia sistémica)
- Historial de programas, sesiones y evaluaciones

**Integraciones**:
- BCI → preentrevista alimenta el registro inicial
- BAD → evaluaciones se vinculan al expediente
- BCOE → información operativa del paciente sin contenido clínico
- BSI → disponibilidad y preferencias del paciente para programación
- BCGS → consentimientos, privacidad y políticas de retención

---

### 3.2. Therapist Workspace

**Propósito**: Ser el escritorio principal del psicólogo, evitando abrir múltiples pantallas.

**Funciones**:
- Vista consolidada de agenda del día
- Lista priorizada de pacientes (alimentada por BCIE)
- Acceso directo a notas, sesiones y tareas pendientes
- Indicadores de carga clínica y seguimientos urgentes
- Panel de IA clínica (briefings, debriefings, sugerencias)
- Acceso a reportes y analytics del terapeuta
- Notificaciones y alertas contextuales
- Selector rápido de modalidad (presencial/online/híbrida)

**Datos que maneja**:
- Agenda del terapeuta con estado de cada sesión
- Pacientes priorizados por BCIE con nivel de riesgo
- Tareas pendientes y documentos por firmar
- Indicadores de productividad clínica (no monetaria)
- Accesos directos a herramientas frecuentes

**Integraciones**:
- BCIE → priorización de pacientes y carga clínica
- BSI → optimización de agenda y recomendaciones
- Session Manager → ciclo de cada sesión
- Notification Center → alertas y recordatorios
- Automation Engine → procesos automatizados del terapeuta

---

### 3.3. Appointment Manager

**Propósito**: Gestionar la agenda clínica mucho más allá de una simple agenda de citas.

**Funciones**:
- Disponibilidad del terapeuta (horarios fijos, variables, guardias)
- Soporte multi-zona horaria
- Modalidad presencial con asignación de sala/consultorio
- Modalidad online con generación de enlaces (Google Meet, Jitsi)
- Cancelaciones con registro de motivo y reprogramación automática
- Lista de espera inteligente (alimentada por BSI)
- Recordatorios configurables por tipo y frecuencia
- Integración con el Clinical Intake Manager (pre-sesión)
- Resolución de conflictos de agenda multi-paciente

**Datos que maneja**:
- Bloques de disponibilidad del terapeuta
- Citas programadas, confirmadas, completadas, canceladas, ausentes
- Enlaces de videollamada y datos de sala
- Motivos de cancelación y ausencia
- Historial de patrones de asistencia por paciente

**Integraciones**:
- BSI → optimización inteligente de programación
- BCOE → ocupación de consultorios y salas virtuales
- Clinical Intake Manager → preparación pre-sesión
- Notification Center → recordatorios automáticos
- Calendar Synchronization Layer → Google Calendar, Outlook, Apple Calendar (opcional)

---

### 3.4. Clinical Intake Manager

**Propósito**: Gestionar la preentrevista y preparación automática de cada caso nuevo.

**Funciones**:
- Recepción de pacientes nuevos con preentrevista adaptativa
- Conexión directa con BCI para generar preguntas dinámicas
- Uso de BAD para administrar evaluaciones iniciales
- Integración con BKC para acceder al conocimiento compilado
- Adaptación temporal: si el paciente agenda para mañana, la IA reorganiza las preguntas para obtener la máxima información en pocas horas
- Generación de resumen de ingreso para el terapeuta
- Clasificación inicial de complejidad y riesgo
- Asignación automática de ruta terapéutica sugerida (BTPL)

**Datos que maneja**:
- Formulario de preentrevista (adaptativo por BCI)
- Respuestas del paciente y metadatos de interacción
- Resultados de evaluaciones iniciales (BAD)
- Resumen clínico generado por IA
- Clasificación de riesgo y complejidad inicial
- Ruta terapéutica sugerida

**Integraciones**:
- BCI → generación de preguntas y análisis de respuestas
- BAD → evaluaciones iniciales y cuestionarios
- BKC → conocimiento compilado para asistir la formulación
- BCDSL → ejecución de flujos de preentrevista definidos
- BTPL → ruta terapéutica inicial sugerida
- BCCE → verificación de consistencia de la información recabada

---

### 3.5. Assessment Manager

**Propósito**: Coordinar todas las evaluaciones iniciales, continuas y finales de forma automática y trazable.

**Funciones**:
- Programación automática de evaluaciones según la ruta terapéutica
- Soporte para múltiples instrumentos: MPFI, DASS-21, PHQ-9, GAD-7, inventarios neuropsicológicos, etc.
- Evaluación continua (periódica, event-driven)
- Evaluación de cierre y alta
- Comparación de resultados a lo largo del tiempo
- Alertas por cambios significativos en indicadores
- Generación de informes de evaluación
- Integración con ejercicios BERL para evaluación ecológica

**Datos que maneja**:
- Instrumentos de evaluación configurados
- Resultados por paciente, fecha e instrumento
- Puntuaciones, percentiles y clasificaciones
- Tendencias y cambios estadísticamente significativos
- Metadatos de administración (quién, cuándo, modalidad)

**Integraciones**:
- BAD → diseño y administración de instrumentos
- BCI → preentrevista como primer punto de evaluación
- BERL → ejercicios como datos de evaluación ecológica
- Progress Monitoring Manager → integración de resultados en monitoreo
- BSI → programación de reevaluaciones según hitos del tratamiento
- BXE → explicación de por qué se sugiere cada evaluación

---

### 3.6. Clinical Record Manager

**Propósito**: Almacenar el expediente clínico como una colección de objetos clínicos navegables, no como documentos PDF estáticos.

**Funciones**:
- Almacenamiento de objetos clínicos interconectados
- Navegación: caso → sesiones → procesos → hipótesis → objetivos → ejercicios → resultados
- Versionado de cada objeto clínico
- Enlaces semánticos entre objetos
- Vista gráfica del expediente (grafo clínico)
- Exportación a formatos estándar (cuando sea requerido)
- Control de acceso granular por objeto (RBAC)

**Datos que maneja**:
- Casos clínicos (cada paciente puede tener múltiples casos)
- Sesiones (con todas sus sub-partes)
- Procesos psicológicos trabajados
- Hipótesis funcionales
- Objetivos terapéuticos
- Ejercicios y tareas asignadas
- Resultados e indicadores de progreso
- Notas y documentación asociada

**Integraciones**:
- BPO/BPG → procesos psicológicos como objetos del expediente
- BCDSL → ejecución de flujos clínicos representados en el expediente
- Clinical Documentation Engine → generación de notas y reportes desde objetos
- Clinical Timeline → visualización cronológica del expediente
- Archive Manager → políticas de retención y archivado
- Audit Manager → trazabilidad de modificaciones

---

### 3.7. Case Formulation Manager

**Propósito**: Construir y mantener la formulación del caso de forma dinámica, integrando conocimiento y datos clínicos.

**Funciones**:
- Formulación basada en procesos psicológicos (no diagnósticos)
- Integración de múltiples marcos: ACT, FAP, PBT, Gottman, EEMM, TIP, neuropsicología
- Construcción dinámica a partir de datos de evaluación
- Actualización continua conforme evoluciona el caso
- Visualización en grafo de formulación
- Comparación entre formulaciones iniciales y actuales
- Sugerencias de reformulación basadas en IA

**Datos que maneja**:
- Formulación funcional del caso
- Procesos psicológicos identificados (desde BPO)
- Hipótesis funcionales y relaciones funcionales
- Factores de mantenimiento y vulnerabilidad
- Fortalezas y recursos del paciente
- Marco teórico utilizado
- Evidencia que soporta la formulación

**Integraciones**:
- BKC → conocimiento compilado para asistir la formulación
- BCDSL → flujos de formulación definidos en lenguaje clínico
- BPO/BPG → ontología y grafo de procesos psicológicos
- BAD → resultados de evaluación que alimentan la formulación
- BCCE → verificación de consistencia de la formulación
- BXE → explicación del razonamiento detrás de la formulación
- BTPL → ruta terapéutica derivada de la formulación

---

### 3.8. Treatment Plan Manager

**Propósito**: Administrar el plan de tratamiento como un sistema vivo que cambia conforme evoluciona el paciente, no como un documento estático.

**Funciones**:
- Plan terapéutico compuesto por objetivos, procesos, ejercicios e indicadores
- Cada objetivo tiene estado (activo, en progreso, alcanzado, modificado)
- Adaptación dinámica según la evolución del paciente
- Versionado del plan con trazabilidad de cambios
- Conexión directa con la formulación del caso
- Generación automática de plan inicial desde BTPL
- Indicadores de seguimiento por objetivo
- Plan multi-modal (individual + pareja + familiar + neuropsicología)

**Datos que maneja**:
- Objetivos terapéuticos con prioridad y plazo estimado
- Procesos psicológicos asociados a cada objetivo
- Intervenciones y ejercicios prescritos
- Indicadores de éxito por objetivo
- Estado y progreso de cada objetivo
- Historial de adaptaciones del plan
- Hitos y fechas clave del tratamiento

**Integraciones**:
- BTPL → ruta terapéutica como plantilla del plan
- BPO/BPG → procesos psicológicos vinculados a objetivos
- BERL → ejercicios prescritos para cada objetivo
- BIMS → ejecución de las intervenciones del plan
- BCCE → verificación de consistencia del plan
- BSI/BASP → programación de sesiones según intensidad del plan
- Progress Monitoring Manager → seguimiento de objetivos

---

### 3.9. Session Manager

**Propósito**: Administrar el ciclo completo de cada sesión clínica, desde la preparación hasta el seguimiento post-sesión.

**Funciones**:
- **Pre-sesión**: Briefing generado por IA (resumen del caso, tareas pendientes, indicadores)
- **Durante la sesión**: Estructura flexible, registro en tiempo real, acceso a material
- **Post-sesión**: Debriefing automático, generación de notas, tareas asignadas
- Registro de objetivos trabajados y procesos abordados
- Duración real vs. planificada
- Modalidad registrada (presencial, online, híbrida)
- Materiales utilizados en la sesión
- Notas del terapeuta con autocompletado por IA

**Ciclo de la sesión**:
```
Antes → Preparación IA → Sesión → Notas → Resumen → Tareas → Seguimiento
```

**Datos que maneja**:
- Datos de cada sesión (fecha, hora, duración, modalidad)
- Objetivos abordados y procesos trabajados
- Notas clínicas (SOAP, DAP, BIRP, orientadas a procesos)
- Tareas asignadas durante la sesión
- Resumen generado por IA
- Decisiones clínicas tomadas
- Tiempo de contacto real

**Integraciones**:
- Appointment Manager → ciclo de la cita
- Treatment Plan Manager → objetivos activos de la sesión
- BIMS → ejecución de intervenciones
- Clinical Documentation Engine → generación de notas
- Clinical Timeline → eventos de la sesión en la línea temporal
- Homework Manager → tareas generadas post-sesión
- Notification Center → recordatorios post-sesión

---

### 3.10. Homework Manager

**Propósito**: Gestionar todas las tareas asignadas entre sesiones, conectándolas con los ejercicios del BERL.

**Funciones**:
- Asignación de tareas vinculadas a objetivos del plan
- Conexión directa con ejercicios BERL (videojuegos, prácticas, registros)
- Seguimiento de frecuencia y adherencia
- Recordatorios automáticos al paciente
- Retroalimentación del terapeuta sobre tareas completadas
- Registro de adherencia por tarea y período
- Análisis de patrones de cumplimiento
- Adaptación de tareas según adherencia observada

**Flujo**:
```
Ejercicio → Proceso entrenado → Frecuencia → Adherencia → Resultados
```

**Datos que maneja**:
- Tareas asignadas (descripción, proceso, frecuencia, plazo)
- Estado de cada tarea (pendiente, en progreso, completada, omitida)
- Tiempo invertido en cada tarea
- Resultados de ejercicios BERL vinculados
- Adherencia calculada (por tarea, por período, global)
- Retroalimentación del terapeuta
- Historial de tareas por paciente

**Integraciones**:
- BERL → ejercicios, videojuegos y prácticas conductuales
- Treatment Plan Manager → objetivos que justifican cada tarea
- Progress Monitoring Manager → adherencia como indicador de progreso
- Notification Center → recordatorios de tareas pendientes
- Session Manager → tareas generadas durante la sesión
- BIMS → Homework Engine de ejecución y registro

---

### 3.11. Progress Monitoring Manager

**Propósito**: Integrar todos los indicadores de progreso del paciente en un solo lugar.

**Funciones**:
- Dashboard unificado de indicadores de progreso
- Integración de: MPFI, telemetría de juegos, autorregistros, adherencia, valores, flexibilidad psicológica, indicadores neuropsicológicos
- Gráficas de tendencia por indicador
- Alertas por cambios significativos (mejoría o deterioro)
- Comparación entre períodos
- Correlación entre indicadores
- Resumen de progreso para supervisión
- Exportación de reportes de progreso

**Datos que maneja**:
- MPFI y resultados de instrumentos de evaluación continua
- Telemetría de videojuegos (tiempo, desempeño, errores)
- Autorregistros del paciente
- Adherencia a tareas y ejercicios
- Indicadores de procesos (flexibilidad, regulación, etc.)
- Resultados neuropsicológicos
- Valores y dirección de vida (desde ACT)

**Integraciones**:
- Assessment Manager → resultados de evaluaciones
- BERL → telemetría de ejercicios y videojuegos
- BIMS → adherencia a tareas (Adherence Monitoring Engine)
- BPO/BPG → procesos psicológicos como ejes de análisis
- BCIE → indicadores de progreso como factor de priorización
- BXE → explicación de tendencias y correlaciones
- Clinical Timeline → eventos de progreso en la línea temporal

---

### 3.12. Clinical Timeline

**Propósito**: Visualizar toda la historia del paciente como una línea temporal navegable.

**Funciones**:
- Línea temporal cronológica de todos los eventos clínicos
- Filtros por tipo de evento, período, proceso, intensidad
- Eventos marcados: ingreso, evaluación, sesiones, cambios, recaídas, mejorías, alta
- Zoom por sesión, por semana, por mes, por fase del tratamiento
- Anotaciones del terapeuta en puntos clave
- Eventos de la IA (alertas, sugerencias, adaptaciones)
- Comparación visual de períodos

**Flujo visual**:
```
Ingreso → Evaluación → Sesión 1 → Cambio → Recaída → Mejoría → Alta
```

**Datos que maneja**:
- Todos los eventos del expediente clínico ordenados cronológicamente
- Tipo de evento, fecha, descripción y peso clínico
- Cambios en indicadores de progreso
- Decisiones clínicas y adaptaciones del plan
- Hitos del tratamiento

**Integraciones**:
- Clinical Record Manager → todos los objetos del expediente
- Assessment Manager → eventos de evaluación
- Session Manager → eventos de sesión
- Progress Monitoring Manager → cambios en indicadores
- BCIE → eventos de priorización y alerta
- Clinical Documentation Engine → documentos generados

---

### 3.13. Clinical Documentation Engine

**Propósito**: Generar automáticamente documentación clínica de alta calidad, siempre requiriendo validación del terapeuta.

**Funciones**:
- Generación automática de notas SOAP, DAP, BIRP y orientadas a procesos
- Reportes neuropsicológicos
- Cartas clínicas y constancias
- Informes de progreso para pacientes, seguros o referentes
- Resúmenes para supervisión
- Consentimientos informados (plantilla + personalización)
- Autocompletado basado en objetos del expediente
- Versionado y firma electrónica de documentos
- Plantillas configurables por organización

**Datos que maneja**:
- Plantillas de documentación (SOAP, DAP, BIRP, personalizadas)
- Objetos del expediente como fuente de datos
- Documentos generados con metadatos de generación
- Firmas electrónicas y timestamps
- Historial de versiones de cada documento

**Integraciones**:
- Clinical Record Manager → fuente de datos para generación
- Session Manager → contexto de la sesión para notas
- Assessment Manager → resultados para informes
- BCGS → formatos requeridos por regulación
- BXE → justificación de decisiones documentadas
- Audit Manager → trazabilidad de generación y modificación

---

### 3.14. Supervisor Workspace

**Propósito**: Permitir al supervisor visualizar y asistir en la gestión de casos asignados, sin acceso a casos privados que no supervisa.

**Funciones**:
- Vista consolidada de todos los casos supervisados
- Acceso a expedientes, notas y formulaciones de casos asignados
- Comentarios y anotaciones en casos de práctica
- Aprobación de documentación clínica generada por practicantes
- Dashboard de supervisión (carga de practicantes, casos críticos)
- Reuniones de supervisión con contexto clínico
- Evaluación del desempeño del practicante
- Control de acceso estricto por RBAC

**Datos que maneja**:
- Lista de casos asignados al supervisor
- Expedientes de casos supervisados (lectura)
- Comentarios y anotaciones del supervisor
- Estado de aprobación de documentación
- Indicadores de desempeño del practicante
- Agenda de reuniones de supervisión

**Integraciones**:
- Clinical Record Manager → acceso a expedientes supervisados
- Clinical Documentation Engine → aprobación de documentos
- BCIE → información de carga para supervisión
- Notification Center → alertas de casos que requieren revisión
- BCGS → políticas de supervisión y permisos

---

### 3.15. Clinical Collaboration Layer

**Propósito**: Permitir el trabajo colaborativo entre profesionales con permisos granulares RBAC.

**Funciones**:
- Asignación de roles por caso (terapeuta principal, co-terapeuta, evaluador, supervisor)
- Permisos granulares por objeto clínico
- Comentarios y discusiones en el contexto de un caso
- Referencias entre profesionales
- Coordinación de sesiones conjuntas
- Vista compartida del plan de tratamiento
- Historial de colaboración por caso
- Control de visibilidad por privacidad

**Datos que maneja**:
- Asignaciones de profesionales por caso
- Roles y permisos RBAC por objeto
- Comentarios y discusiones en contexto
- Referencias y notas de transferencia
- Agenda de sesiones conjuntas

**Integraciones**:
- RBAC → sistema de control de acceso
- BCGS → políticas de privacidad y consentimiento
- Clinical Record Manager → objetos clínicos compartidos
- Session Manager → sesiones multi-profesional
- Notification Center → notificaciones de colaboración

---

### 3.16. Notification Center

**Propósito**: Enviar recordatorios inteligentes y contextuales, no genéricos.

**Funciones**:
- Recordatorios de sesiones próximas
- Alertas de pacientes sin respuesta (ej: "no respondió 3 días → sugerir seguimiento")
- Alertas de objetivos sin progreso (ej: "sin avance en 4 sesiones → revisar formulación")
- Recordatorios de tareas pendientes
- Notificaciones de evaluaciones programadas
- Alertas de riesgo de abandono (desde BCIE)
- Notificaciones de documentos por firmar
- Configuración por tipo de notificación y frecuencia

**Datos que maneja**:
- Reglas de notificación configurables
- Historial de notificaciones enviadas
- Estado de recepción y lectura
- Contexto clínico de cada notificación

**Integraciones**:
- BCIE → alertas de riesgo y priorización
- Session Manager → eventos de sesión
- Homework Manager → tareas pendientes
- Assessment Manager → evaluaciones programadas
- BCGS → preferencias de comunicación del paciente
- BCOE → notificaciones operativas (pagos, facturación)

---

### 3.17. Automation Engine

**Propósito**: Automatizar procesos clínicos repetitivos para que el terapeuta solo tome decisiones.

**Funciones**:
- Envío automático de formularios y escalas
- Recordatorios de tareas y sesiones
- Generación de consentimientos
- Actualización de programas activos
- Envío de escalas de evaluación continua
- Generación de reportes periódicos
- Preparación automática de sesiones
- Flujos de onboarding de pacientes nuevos
- Workflows de alta y seguimiento post-alta

**Datos que maneja**:
- Reglas de automatización configurables
- Triggers (eventos que inician automatizaciones)
- Acciones (qué se ejecuta cuando se cumple el trigger)
- Historial de ejecuciones
- Errores y reintentos

**Integraciones**:
- Clinical Intake Manager → onboarding automatizado
- Assessment Manager → envío de evaluaciones
- Session Manager → preparación de sesiones
- Homework Manager → recordatorios de tareas
- Clinical Documentation Engine → generación de documentos
- Notification Center → envío de notificaciones
- BCIE → automatizaciones basadas en inteligencia de carga

---

### 3.18. Clinical Search Engine

**Propósito**: Buscar en el expediente clínico no solo por nombre, sino por criterios clínicos complejos.

**Funciones**:
- Búsqueda por nombre, ID o datos demográficos
- Búsqueda clínica semántica: "pacientes con alta evitación + insomnio + 20-30 años"
- Búsqueda por proceso psicológico trabajado
- Búsqueda por tipo de intervención utilizada
- Búsqueda por resultados de evaluación
- Búsqueda por período de tratamiento
- Búsqueda por terapeuta o modalidad
- Resultados navegables con preview del expediente
- Filtros combinables y guardados

**Datos que maneja**:
- Índice de búsqueda sobre todo el expediente
- Metadatos clínicos indexados
- Resultados de evaluaciones indexados
- Procesos psicológicos y objetos del expediente indexados
- Consultas guardadas y favoritas

**Integraciones**:
- Clinical Record Manager → fuente principal de objetos indexados
- BPO/BPG → procesos psicológicos como ejes de búsqueda
- Assessment Manager → resultados de evaluaciones indexados
- BCGS → resultados filtrados por permisos del usuario

---

### 3.19. Archive Manager

**Propósito**: Gestionar el archivado, retención, versionado y exportación de expedientes cumpliendo las políticas del BCGS.

**Funciones**:
- Archivado automático de casos dados de alta
- Políticas de retención documental configurables por organización
- Versionado completo del expediente archivado
- Exportación a formatos estándar (HL7 FHIR, PDF estructurado, JSON)
- Búsqueda en expedientes archivados
- Restauración de expedientes cuando es necesario
- Cumplimiento de normativas de retención (LFPDPPP, GDPR, HIPAA)

**Datos que maneja**:
- Políticas de retención por tipo de documento
- Expedientes archivados con metadatos
- Historial de exportaciones
- Logs de acceso a expedientes archivados

**Integraciones**:
- Clinical Record Manager → fuente de expedientes a archivar
- BCGS → políticas de retención y cumplimiento normativo
- Audit Manager → trazabilidad de acciones de archivado
- BCOE → Compliance Operations para verificación

---

### 3.20. Audit Manager

**Propósito**: Registrar toda modificación en el sistema respondiendo: quién, qué, cuándo, por qué y con qué versión.

**Funciones**:
- Registro inmutable de todas las modificaciones al expediente
- Trazabilidad completa: usuario, acción, timestamp, versión anterior/posterior
- Filtros de auditoría por usuario, paciente, período, tipo de acción
- Reportes de auditoría para supervisión y cumplimiento normativo
- Alertas por accesos no autorizados
- Exportación de logs de auditoría
- Cumplimiento con BCGS para revisión regulatoria

**Datos que maneja**:
- Logs de auditoría inmutables (append-only)
- Metadatos de cada cambio (quién, qué, cuándo, por qué, versión)
- Accesos al sistema (login, logout, intentos fallidos)
- Acciones sobre expedientes (lectura, creación, modificación, eliminación)
- Generación de documentos (qué se generó y con qué datos)

**Integraciones**:
- Clinical Record Manager → eventos de modificación del expediente
- Clinical Documentation Engine → eventos de generación de documentos
- BCGS → políticas de auditoría y cumplimiento
- BCOE → Compliance Operations
- RBAC → verificación de permisos en cada acción

---

## 4. Ciclo Clínico Completo

El BCMS administra el flujo completo del paciente:

```
Paciente nuevo
  ↓
Clinical Intake Manager (BCI + BAD)
  ↓
Assessment Manager (evaluación inicial)
  ↓
Case Formulation Manager (BKC + BCDSL + BPO)
  ↓
Treatment Plan Manager (BTPL + BERL)
  ↓
Session Manager (ciclo de sesión con briefing/debriefing IA)
  ↓
Homework Manager (tareas con BERL)
  ↓
Progress Monitoring Manager (multi-indicador)
  ↓
Clinical Timeline (visualización cronológica)
  ↓
Clinical Documentation Engine (notas, reportes)
  ↓
Alta → Archive Manager → Seguimiento post alta
```

Cada paso alimenta al siguiente. Nada se pierde. Todo permanece conectado.

---

## 5. Integración con el Ecosistema

El BCMS actúa como el **orquestador clínico** de toda la plataforma:

| Motor | Integra con BCMS para... |
|-------|--------------------------|
| BCI | Preentrevista y preparación automática de cada caso |
| BAD | Evaluar evaluaciones iniciales, continuas y de cierre |
| BCDSL | Ejecutar flujos clínicos definidos mediante el DSL |
| BKC | Acceder al conocimiento compilado para asistir formulación |
| BKS | Utilizar simulaciones y entrenamientos cuando sea necesario |
| BPO, BPG, BPG-M | Visualizar y actualizar procesos psicológicos individuales, de pareja y familiares |
| BERL | Prescribir, monitorizar y analizar ejercicios terapéuticos |
| BESS, BTVE | Mantener alineación con la evidencia científica |
| BCCE | Verificar consistencia del caso durante toda su evolución |
| BXE | Explicar el razonamiento detrás de las recomendaciones de la IA |
| BCGS, BEA, RBAC | Garantizar seguridad, auditoría y cumplimiento normativo |

---

## 6. Diferenciación de Submódulos

| Componente | Responsabilidad | NO hace |
|------------|----------------|---------|
| **BCMS** | Práctica clínica (expedientes, sesiones, planes) | No gestiona facturación ni ocupación de salas |
| **BCIE** | Carga clínica (priorización, riesgo, continuidad) | No toma decisiones clínicas ni cambia tratamientos |
| **BCOE** | Operación del negocio (recursos, finanzas, personal) | No accede al contenido clínico ni formula casos |
| **BSI** | Programación inteligente de citas | No agenda automáticamente; sugiere y aprende |

---

## 7. Notas de Implementación

### 7.1. Event-Sourcing

El BCMS debe implementarse sobre Event Sourcing. Cada acción clínica genera un evento inmutable que alimenta la Clinical Timeline, el Audit Manager y el Clinical Search Engine.

### 7.2. RBAC

Todo acceso al BCMS pasa por RBAC. Los permisos se definen por: rol (terapeuta, supervisor, practicante, administrador), caso asignado, y tipo de objeto clínico.

### 7.3. Zero Trust

El BCMS opera bajo el modelo Zero Trust de la BCGS. Cada solicitud de acceso se valida independientemente de la sesión anterior.

### 7.4. Offline-First

Para terapeutas en zonas con conectividad limitada, el BCMS debe soportar modo offline con sincronización posterior, especialmente para notas de sesión y tareas.

### 7.5. Multi-tenancy

El BCMS soporta consultorios individuales, clínicas con múltiples sedes e instituciones hospitalarias, cada uno con su propia configuración y datos aislados.

---

## 8. Métricas de Éxito

| Métrica | Objetivo |
|---------|----------|
| Tiempo de documentación post-sesión | Reducción del 60% vs. sistema manual |
| Tiempo de pre-sesión (briefing) | < 2 minutos |
| Tasa de completion de notas clínicas | > 95% |
| Tiempo de acceso a expediente | < 1 segundo |
| Búsqueda clínica exitosa | > 85% |
| Automatizaciones ejecutadas/sem | > 200 por terapeuta activo |
| Satisfacción del terapeuta (NPS) | > 50 |
