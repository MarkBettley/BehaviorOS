---
id: BPOS-001
title: Behavioral Clinical Management System (BCMS)
version: 2.0.0
status: Stable
owner: Práctica Clínica & Arquitectura de Software
last_updated: 2026-07-14
depends_on:
  - 000-Core/philosophy.md (Filosofía - guía clínico)
  - 000-Core/principles.md (Principios - ética clínica)
  - 100-Architecture/system-architecture.md (BEA - capa operacional)
  - 100-Architecture/behavioral-twin.md (Behavioral Twin - perfil del paciente)
  - 200-Backend/api-graph.md (API Graph - endpoints clínicos)
  - 200-Backend/database-graph.md (Database Graph - tablas clínicas)
  - 200-Backend/events-and-workflows.md (Eventos - flujos clínicos)
  - 300-Frontend/therapist-app.md (Experiencia Apple - interfaz del terapeuta)
  - 400-AI/adaptive-orchestrator.md (AAO - evaluación continua)
  - 400-AI/companion.md (TCCN - copiloto IA)
  - 500-Experiencies/experience-engine.md (BERL - ejercicios)
  - 600-Commerce/business-model.md (BCE - facturación)
  - 000-Infrastructure/selection.md (Infraestructura - Google Meet, Jitsi)
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
  - Behavioral Caseload Intelligence Engine (BCIE)
  - Behavioral Clinic Operations Engine (BCOE)
  - Behavioral Scheduling Intelligence (BSI)
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

# BehavioralOS – Behavioral Clinical Management System (BCMS) v2.0.0

> *"El BCMS no es un simple EMR. Es un Behavioral Clinical Operating System. Toda la práctica clínica gira alrededor de él. El psicólogo nunca debería perder tiempo administrando información; debería dedicar ese tiempo a analizar e intervenir clínicamente."*

---

## 1. Propósito y Alcance

### 1.1. Propósito

El Behavioral Clinical Management System (BCMS) es el **sistema integral de gestión clínica** que coordina pacientes, terapeutas, expedientes, sesiones, planes de tratamiento, seguimiento, documentación clínica, supervisión y operación diaria del consultorio o clínica dentro del ecosistema Behavioral.

No es únicamente un EMR (Electronic Medical Record). Es un **Behavioral Clinical Operating System (BCOS)**. Toda la plataforma trabaja alrededor de este núcleo.

### 1.2. Filosofía

> **"El psicólogo nunca debería perder tiempo administrando información; debería dedicar ese tiempo a analizar e intervenir clínicamente."**

- Todo aquello que sea administrativo debe **automatizarse**.
- Todo aquello que sea repetitivo debe **sugerirse**.
- Todo aquello que sea manual debe **reducirse**.

### 1.3. Ciclo Clínico Completo

El BCMS administra todo el ciclo de vida del paciente:

```
Paciente nuevo → Preentrevista → Evaluación → Formulación → Plan →
Sesiones → Seguimiento → Alta → Post-alta
```

Cada paso alimenta al siguiente. Nada se pierde. Todo permanece conectado.

### 1.4. Documentos Relacionados

| Documento | Descripción |
|-----------|-------------|
| `bcms-detailed.md` | Especificación completa del BCMS: 20 submódulos, arquitectura detallada, integración con el ecosistema |
| `bcie-spec.md` | Behavioral Caseload Intelligence Engine (BCIE): inteligencia de carga clínica, priorización, predicción de abandono |
| `bcoe-spec.md` | Behavioral Clinic Operations Engine (BCOE): motor de operaciones del negocio (recursos, finanzas, personal) |
| `bsi-spec.md` | Behavioral Scheduling Intelligence (BSI): programación inteligente de citas, continuidad, optimización |

### 1.5. Principio Fundamental

> **"El BCMS es invisible cuando funciona bien. El terapeuta no debe pensar en la herramienta; debe pensar en el paciente. La agenda se sincroniza sola, la información del paciente está siempre disponible, la IA sugiere sin interrumpir. El BCMS es un facilitador, no un obstáculo."**

---

## 2. Filosofía del BCMS

### 2.1. Principios de Diseño

| # | Principio | Descripción | Manifestación |
|---|-----------|-------------|---------------|
| 1 | **Invisibilidad** | La herramienta no debe ser un obstáculo para la relación terapéutica. | La UI es minimalista, la información está donde se necesita, la automatización es silenciosa. |
| 2 | **Integración profunda** | El BCMS se conecta con todos los motores del ecosistema (AAO, TCCN, BCE, BCIE, BCOE, BSI). | Los datos fluyen sin intervención manual. |
| 3 | **Eficiencia** | Las tareas comunes deben ser rápidas y con pocos clics. | Atajos de teclado, autocompletado, plantillas. |
| 4 | **Seguridad y privacidad** | Los datos del paciente están protegidos con cifrado y RLS. | Todos los datos clínicos están cifrados en reposo y en tránsito. |
| 5 | **Adaptabilidad** | El BCMS debe adaptarse al estilo de trabajo de cada terapeuta. | Plantillas personalizables, dashboards configurables. |
| 6 | **Trazabilidad** | Todas las acciones clínicas quedan registradas para auditoría. | Historial de versiones de notas, logs de acceso al EHR. |
| 7 | **Separación clínico-operativo** | La lógica clínica NUNCA se mezcla con la operativa. | BCMS (clínico) ↔ BCOE (operativo) con interfaces controladas. |

### 2.2. Inspiración en Apple

El BCMS está inspirado en los principios de diseño de Apple:

- **Minimalismo**: Sin elementos decorativos, solo lo esencial.
- **Claridad**: La información es fácil de entender y navegar.
- **Eficiencia**: Las tareas se realizan con pocos clics y atajos de teclado.
- **Consistencia**: Los patrones de interacción son predecibles.
- **Integración**: Se conecta con el ecosistema de productividad del terapeuta.

---

## 3. Arquitectura General del BCMS

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
├── BCIE [submódulo] → ver bcie-spec.md
│   └── BSI [submotor] → ver bsi-spec.md
│
└── BCOE [submódulo] → ver bcoe-spec.md
```

> Para la especificación completa de cada submódulo, consultar `bcms-detailed.md`.

---

## 4. Agenda Inteligente (Appointment Manager)

### 4.1. Funcionalidades

| Funcionalidad | Descripción | Tecnología |
|---------------|-------------|------------|
| **Vistas** | Día, Semana, Mes, Agenda (lista). | React + FullCalendar |
| **Creación de citas** | Seleccionar paciente, fecha, hora, modalidad (presencial/online), duración. | Formulario con autocompletado de pacientes. |
| **Edición de citas** | Cambiar fecha, hora, modalidad, estado. | Drag & drop en la vista de semana. |
| **Integración con Google Calendar/Outlook** | Sincronización bidireccional de citas. | Google Calendar API, Microsoft Graph API |
| **Disponibilidad** | Configurar horarios de trabajo, bloques de descanso, vacaciones. | Configuración en el perfil del terapeuta. |
| **Recordatorios** | Envío automático de recordatorios al paciente y al terapeuta. | Notification Center |
| **Lista de espera** | Gestión de pacientes en espera para citas. | Alimentada por BSI (optimización inteligente). |
| **Indicadores de riesgo** | Mostrar alertas de riesgo junto a la cita. | Integración con BCIE. |
| **Optimización inteligente** | Sugerencias de horarios basadas en patrones, continuidad y disponibilidad. | BSI (Smart Recommendation Engine). |

### 4.2. Flujo de Creación de una Cita

1. **El terapeuta selecciona una fecha/hora** en la agenda (vista de semana).
2. **Se abre un modal** con el formulario de creación de cita.
3. **El terapeuta busca o selecciona un paciente** (autocompletado).
4. **Selecciona la modalidad** (presencial u online).
5. **El sistema verifica** la disponibilidad del paciente y del terapeuta.
6. **BSI sugiere horarios óptimos** basados en patrones de asistencia y continuidad.
7. **La cita se guarda** y se sincroniza con Google Calendar/Outlook (si está configurado).
8. **Se envían recordatorios** contextuales al paciente y al terapeuta.
9. **La cita aparece** en la agenda y en el dashboard del terapeuta.

### 4.3. Integración con Videoterapia

- **Desde la agenda**, el terapeuta puede hacer clic en "Iniciar videollamada" para una cita online.
- **El sistema genera automáticamente** un enlace de videollamada (Google Meet, Zoom, o Jitsi autohospedado).
- **El enlace se envía al paciente** en el recordatorio de la cita.

---

## 5. Expediente Clínico Electrónico (Clinical Record Manager)

### 5.1. Estructura del EHR

El expediente está basado en el **Behavioral Twin** y organiza la información del paciente en secciones navegables:

| Sección | Descripción | Contenido |
|---------|-------------|-----------|
| **Identidad** | Datos personales y demográficos. | Nombre, edad, género, contacto, terapeuta asignado, fecha de ingreso. |
| **Behavioral Twin** | Modelo dinámico del paciente. | Hexaflex, redes RFT, trayectorias de procesos, hipótesis activas. |
| **Historial de sesiones** | Registro de todas las sesiones. | Fecha, hora, modalidad, notas SOAP/DAP/BIRP, estado. |
| **Evaluaciones** | Resultados de evaluaciones clínicas. | MPFI, DASS-21, PHQ-9, GAD-7, etc., con fechas y tendencias. |
| **Formulación** | Formulación dinámica del caso. | Procesos identificados, hipótesis funcionales, factores de mantenimiento. |
| **Plan de tratamiento** | Plan vivo y adaptativo. | Objetivos, procesos, ejercicios, indicadores de éxito. |
| **Tareas y ejercicios** | Tareas asignadas entre sesiones. | Ejercicios BERL, adherencia, resultados. |
| **Documentos** | Informes, consentimientos, otros documentos. | PDFs, imágenes, etc. |

### 5.2. Filosofía del Expediente

El expediente no es un PDF estático. Es una **colección de objetos clínicos navegables**:

```
Caso → Sesiones → Procesos → Hipótesis → Objetivos → Ejercicios → Resultados
```

Cada objeto tiene versionado, enlaces semánticos y control de acceso granular (RBAC).

### 5.3. Gestión de Documentos

- **Subida de documentos**: El terapeuta puede subir documentos al EHR del paciente.
- **Firmas**: Los documentos pueden ser firmados electrónicamente.
- **Almacenamiento**: Los documentos se almacenan en Supabase Storage (cifrados).
- **Exportación**: A formatos estándar (HL7 FHIR, PDF estructurado, JSON).

---

## 6. Ciclo Clínico Completo

### 6.1. Flujo del Paciente

```
Paciente nuevo
  ↓
Clinical Intake Manager (BCI + BAD) → Preentrevista adaptativa
  ↓
Assessment Manager → Evaluación inicial
  ↓
Case Formulation Manager (BKC + BCDSL + BPO) → Formulación dinámica
  ↓
Treatment Plan Manager (BTPL + BERL) → Plan vivo y adaptativo
  ↓
Session Manager (ciclo de sesión con briefing/debriefing IA)
  ↓
Homework Manager (tareas con BERL) → Seguimiento entre sesiones
  ↓
Progress Monitoring Manager (multi-indicador) → Monitoreo continuo
  ↓
Clinical Timeline → Visualización cronológica
  ↓
Clinical Documentation Engine (notas, reportes) → Documentación automática
  ↓
Alta → Archive Manager → Seguimiento post-alta
```

### 6.2. Ciclo de la Sesión

```
Antes → Preparación IA → Sesión → Notas → Resumen → Tareas → Seguimiento
```

- **Pre-sesión**: Briefing generado por IA (resumen del caso, tareas pendientes, indicadores).
- **Durante la sesión**: Estructura flexible, registro en tiempo real, acceso a material.
- **Post-sesión**: Debriefing automático, generación de notas, tareas asignadas.

---

## 7. Videoterapia con HUD y Copiloto IA

### 7.1. Pantalla de Videoterapia

```
┌─────────────────────────────────────────────────────────────────────────┐
│ 🎥 Videoterapia: María González                    Duración: 35:12     │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐    │
│ │ [Ventana de video del paciente]    [Ventana del terapeuta]     │    │
│ │                                                                 │    │
│ │ Controles: [🎤] [📹] [📺 Compartir] [💬 Chat] [📝 Notas]      │    │
│ └─────────────────────────────────────────────────────────────────┘    │
│                                                                        │
│ 📊 HUD Clínico                                                        │
│ ┌─────────────────────────────────────────────────────────────────┐    │
│ │ Proceso dominante: Aceptación (↑ 12% esta semana)              │    │
│ │ CRB detectadas:                                                 │    │
│ │ • CRB1: Paciente evita contacto visual al hablar de familia.   │    │
│ │ Oportunidades:                                                  │    │
│ │ • Sugerir ejercicio de defusión para la crítica interna.       │    │
│ │ [Ver más]                                                       │    │
│ └─────────────────────────────────────────────────────────────────┘    │
│                                                                        │
│ 📝 Transcripción en tiempo real                                        │
│ ┌─────────────────────────────────────────────────────────────────┐    │
│ │ Terapeuta: "¿Cómo te sientes hoy?"                             │    │
│ │ Paciente: "Me siento más tranquilo, pero aún me cuesta          │    │
│ │ hablar de mi familia."                                          │    │
│ └─────────────────────────────────────────────────────────────────┘    │
│                                                                        │
│ 🤖 Copiloto IA                                                        │
│ ┌─────────────────────────────────────────────────────────────────┐    │
│ │ Sugerencia:                                                     │    │
│ │ "Podrías explorar el marco relacional 'yo = fracaso' con       │    │
│ │ una metáfora de defusión. ¿Te parece?"                         │    │
│ │ [Aceptar] [Modificar] [Ignorar]                                 │    │
│ └─────────────────────────────────────────────────────────────────┘    │
│                                                                        │
│ [Finalizar sesión]                                                     │
└─────────────────────────────────────────────────────────────────────────┘
```

### 7.2. Componentes de la Videoterapia

| Componente | Descripción | Tecnología |
|------------|-------------|------------|
| **Videollamada** | Ventana de video del paciente y del terapeuta. | Google Meet API, Zoom API, Jitsi (self-hosted) |
| **Controles** | Micrófono, cámara, compartir pantalla, chat, notas. | WebRTC (si se usa Jitsi) |
| **HUD Clínico** | Panel con información clínica en tiempo real. | React + WebSockets (integración con AAO) |
| **Transcripción** | Texto de la conversación con identificación de hablante. | Whisper (on-device) + Google Cloud Speech-to-Text |
| **Copiloto IA** | Sugerencias de preguntas, intervenciones o ejercicios. | TCCN (Gemma) + AAO |
| **Notas rápidas** | Editor de notas durante la sesión. | React + Autocompletado (procesos, CRB) |

### 7.3. Funcionalidades Avanzadas

| Funcionalidad | Descripción | Integración |
|---------------|-------------|-------------|
| **Detección de CRB (FAP)** | Detección de Conductas Clínicamente Significativas en la interacción. | AAO + TCCN |
| **Análisis de procesos en tiempo real** | Estimación del estado de los procesos basado en el lenguaje. | AAO (NLP) |
| **Sugerencias de ejercicios** | Ejercicios que el terapeuta puede asignar durante o después de la sesión. | BERL |
| **Notas automáticas** | Al finalizar la sesión, generación de borrador de notas. | TCCN + NLP |
| **Grabación (con consentimiento)** | Opción de grabar la sesión para supervisión o formación. | Google Meet API, Zoom API |

---

## 8. Notas Clínicas (Clinical Documentation Engine)

### 8.1. Formatos Soportados

| Formato | Secciones | Descripción |
|---------|-----------|-------------|
| **SOAP** | Subjective, Objective, Assessment, Plan | Estándar clínico ampliamente utilizado. |
| **DAP** | Data, Assessment, Plan | Formato más breve y ágil. |
| **BIRP** | Behavior, Intervention, Response, Plan | Orientado a conducta y procesos. |
| **Orientadas a procesos** | Personalizado | Basado en BPO/BPG para documentos de proceso. |

### 8.2. Generación Automática

- **Al finalizar una sesión de videoterapia**, el sistema genera un borrador basado en:
  - **Transcripción**: Extracción de información relevante de la conversación.
  - **HUD Clínico**: Procesos dominantes, CRB detectadas.
  - **Sugerencias del copiloto**: Intervenciones sugeridas y aplicadas.
- **El terapeuta revisa, edita y firma** el borrador antes de guardarlo.
- **Firma electrónica** con OTP o biometría (WebAuthn).
- **Versionado** completo de cada nota.

---

## 9. CRM y Comunicaciones

### 9.1. Gestión de Pacientes

| Funcionalidad | Descripción |
|---------------|-------------|
| **Lista de pacientes** | Lista con filtros (activos, alta, riesgo), búsqueda por nombre, ID. |
| **Perfil del paciente** | Acceso al EHR completo (Behavioral Twin, sesiones, evaluaciones, etc.). |
| **Acciones rápidas** | Agendar cita, enviar mensaje, generar informe, etc. |
| **Indicadores de riesgo** | Alerta visual para pacientes en riesgo de abandono o recaída (alimentado por BCIE). |

### 9.2. Mensajería Segura

| Funcionalidad | Descripción |
|---------------|-------------|
| **Chat paciente ↔ terapeuta** | Mensajería en tiempo real (WebSockets). |
| **Notificaciones** | Push, correo, SMS para nuevos mensajes. |
| **Adjuntos** | Envío de archivos (imágenes, documentos). |
| **Historial** | Almacenamiento seguro de todos los mensajes. |
| **Cifrado** | Cifrado de extremo a extremo para mensajes sensibles. |

### 9.3. Recordatorios Inteligentes (Notification Center)

| Tipo | Descripción | Canal |
|------|-------------|-------|
| **Recordatorio de cita** | Contextual (ej: "Has completado 80% de tus ejercicios esta semana"). | Correo, push, SMS |
| **Recordatorio de ejercicio** | Si el paciente no ha completado ejercicios en varios días. | Push, correo |
| **Alerta clínica** | Riesgo de abandono o recaída (desde BCIE). | Correo, push, dashboard |
| **Seguimiento post-alta** | Según el riesgo del paciente (mensual, quincenal). | Correo, push |
| **Evaluaciones programadas** | Envío automático de escalas según la ruta terapéutica. | Push, correo |

---

## 10. Inteligencia de Carga Clínica (BCIE)

> Para la especificación completa, consultar `bcie-spec.md`.

### 10.1. Resumen

El BCIE es el **"piloto automático" del consultorio**. Analiza continuamente el estado de todos los pacientes, prioriza el trabajo del terapeuta, identifica riesgos y optimiza el seguimiento.

**Submotores principales**:
- **Caseload Analyzer**: Análisis de complejidad por caso
- **Priority Engine**: Priorización dinámica diaria
- **Risk Stratification Engine**: Clasificación de riesgo operativo
- **Dropout Prediction Engine**: Predicción de abandono
- **Engagement Monitor**: Nivel de participación del paciente
- **Clinical Workload Optimizer**: Distribución por complejidad
- **Burnout Prevention Engine**: Prevención de sobrecarga del terapeuta
- **Caseload Dashboard**: Vista consolidada diaria

### 10.2. Índices Compuestos

| Índice | Propósito |
|--------|-----------|
| **BCLI** (Behavioral Clinical Load Index) | Estimar la carga operativa de cada caso |
| **BCoI** (Behavioral Continuity Index) | Medir la continuidad terapéutica |

---

## 11. Programación Inteligente (BSI)

> Para la especificación completa, consultar `bsi-spec.md`.

### 11.1. Resumen

El BSI es el **submotor del BCIE** que optimiza la programación de sesiones, considerando evolución terapéutica, disponibilidad, preferencias y continuidad.

**Principio clave**: El BSI **no agenda automáticamente**. Sugiere y aprende.

### 11.2. Submotores Principales

| Submotor | Propósito |
|----------|-----------|
| **Availability Engine** | Perfil dinámico de disponibilidad |
| **Preference Learning Engine** | Aprendizaje de preferencias por patrones |
| **Continuity Optimizer** | Mantener el ritmo terapéutico |
| **Smart Recommendation Engine** | Recomendaciones de horarios óptimos |
| **Cancellation Predictor** | Predicción de cancelaciones |
| **Attendance Prediction Engine** | Probabilidad de asistencia por cita |

---

## 12. Operaciones del Negocio (BCOE)

> Para la especificación completa, consultar `bcoe-spec.md`.

### 12.1. Resumen

El BCOE administra todos los procesos administrativos, operativos y comerciales, manteniendo **completamente separada** la gestión operativa del razonamiento clínico.

### 12.2. Separación Clínico-Operativo

```
CLINICAL CORE                    OPERATIONS CORE
──────────────────────           ──────────────────────
BCMS, BCIE, BSI,                BCOE
BCI, BAD, BERL          →       ├── Facturación
  │                              ├── Recursos
  ↓                              ├── Personal
Interfaces Controladas           ├── Inventario
                                  └── KPIs
```

> Esta separación evita uno de los errores más comunes de los ERP médicos: **mezclar la lógica clínica con la lógica administrativa**.

---

## 13. Integración con el Ecosistema

### 13.1. Motores que se integran con el BCMS

| Motor | Integra con BCMS para... |
|-------|--------------------------|
| AAO (Evaluación Adaptativa) | Evaluar continuamente los procesos del paciente |
| TCCN (Compañero IA) | Copiloto en videoterapia y generación de notas |
| BCE (Comercio) | Facturación y gestión de suscripciones |
| BERL (Ejercicios) | Prescribir, monitorizar y analizar ejercicios |
| BIP (Analítica) | Dashboards de productividad y outcomes |
| BCI (Preentrevista) | Preparación automática de casos nuevos |
| BAD (Evaluación) | Diseño y administración de instrumentos |
| BPO/BPG (Procesos) | Ontología y grafo de procesos psicológicos |
| BKC (Conocimiento) | Conocimiento compilado para formulación |
| BCCE (Consistencia) | Verificación de consistencia clínica |
| BXE (Explicabilidad) | Explicación del razonamiento de la IA |
| BCGS (Gobernanza) | Seguridad, auditoría y cumplimiento normativo |

---

## 14. Criterios de Validación y Cumplimiento

| Criterio | Métrica | Herramienta |
|----------|---------|-------------|
| **Tiempo de documentación post-sesión** | Reducción del 60% vs. sistema manual | Pruebas de usabilidad |
| **Tiempo de pre-sesión (briefing)** | < 2 minutos | Pruebas de usabilidad |
| **Tasa de completion de notas clínicas** | > 95% | Monitoreo |
| **Tiempo de acceso a expediente** | < 1 segundo | Monitoreo de rendimiento |
| **Búsqueda clínica exitosa** | > 85% | Pruebas de integración |
| **Automatizaciones ejecutadas/sem** | > 200 por terapeuta activo | Monitoreo |
| **Satisfacción del terapeuta (NPS)** | > 50 | Encuestas in-app |
| **Integración con Google Calendar** | 100% de citas sincronizadas | Pruebas de integración |
| **Cifrado de videoterapia** | 100% de audio y video cifrados en tránsito | Pruebas de seguridad |

---

## 15. Notas de Implementación

### 15.1. Event-Sourcing

El BCMS debe implementarse sobre Event Sourcing. Cada acción clínica genera un evento inmutable que alimenta la Clinical Timeline, el Audit Manager y el Clinical Search Engine.

### 15.2. RBAC

Todo acceso al BCMS pasa por RBAC. Los permisos se definen por: rol (terapeuta, supervisor, practicante, administrador), caso asignado, y tipo de objeto clínico.

### 15.3. Zero Trust

El BCMS opera bajo el modelo Zero Trust de la BCGS. Cada solicitud de acceso se valida independientemente de la sesión anterior.

### 15.4. Offline-First

Para terapeutas en zonas con conectividad limitada, el BCMS debe soportar modo offline con sincronización posterior, especialmente para notas de sesión y tareas.

### 15.5. Multi-tenancy

El BCMS soporta consultorios individuales, clínicas con múltiples sedes e instituciones hospitalarias, cada uno con su propia configuración y datos aislados.

---

## 16. El Manifiesto del BCMS

> *"El BCMS no es un software de gestión clínica. Es el Behavioral Clinical Operating System.*
>
> *Donde la tecnología desaparece para dejar solo al paciente y al profesional.*
> *Donde la información está donde se necesita, las herramientas aparecen cuando se necesitan, y la IA sugiere sin interrumpir.*
>
> *El BCMS es un facilitador, no un obstáculo. Su objetivo no es hacer al terapeuta más productivo; es hacerlo más presente.*
>
> *Nuestra responsabilidad es garantizar que el BCMS sea eficiente, seguro, intuitivo y profundamente integrado con el ecosistema del BehavioralOS. Que el terapeuta pueda concentrarse en lo que realmente importa: la relación terapéutica y el cambio conductual."*

---

## 17. Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2026-07-01 | Arquitectura de Práctica Clínica | Creación del documento. Definición del BPOS: agenda inteligente, EHR, videoterapia con HUD y copiloto IA, notas clínicas SOAP/DAP, CRM, workflows automatizados, dashboards de productividad, integración con el ecosistema y criterios de validación. |
| 2.0.0 | 2026-07-14 | Arquitectura de Práctica Clínica | Transformación de BPOS a BCMS (Behavioral Clinical Management System). Reescritura completa: ciclo clínico completo (Preentrevista → Evaluación → Formulación → Plan → Sesiones → Seguimiento → Alta → Post-alta). Agregados 20 submódulos clínicos. Integración nativa con BCIE (inteligencia de carga), BSI (programación inteligente) y BCOE (operaciones del negocio). Separación clínico-operativo. Filosofía: "El psicólogo nunca debería perder tiempo administrando información". Referencia a documentos detallados: bcms-detailed.md, bcie-spec.md, bcoe-spec.md, bsi-spec.md. |

---

**Fin del documento `practice-os.md`**
