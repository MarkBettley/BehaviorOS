---
id: THP-001
title: Experiencia Apple – App del Terapeuta
version: 1.0.0
status: Stable
owner: Diseño UX/UI & Frontend Engineering
last_updated: 2026-07-01
depends_on:
  - 000-Core/philosophy.md (Filosofía - guía)
  - 000-Core/principles.md (Principios - Apple, productividad)
  - 000-Core/vocabulary.md (Lenguaje - guía, acompañamiento, evidencia)
  - 300-Frontend/design-system.md (BDS - tokens Apple)
  - 300-Frontend/ui-graph.md (UI Graph - navegación terapeuta)
  - 300-Frontend/accessibility.md (Accesibilidad - adaptaciones)
  - 300-Frontend/patient-app.md (Experiencia paciente - vista compartida)
  - 400-AI/companion.md (TCCN - copiloto)
  - 400-AI/adaptive-orchestrator.md (AAO - evaluación)
  - 500-Experiencies/experience-engine.md (BERL - ejercicios)
  - 600-Commerce/business-model.md (BCE - facturación)
  - 700-PracticeOS/practice-os.md (BPOS - práctica clínica)
  - 800-Analytics/outcomes-analytics.md (BIP - analítica)
exports:
  - Filosofía de la experiencia Apple
  - Arquitectura de navegación (sidebar, atajos, búsqueda)
  - Especificación de pantallas clave (Dashboard, Pacientes, Agenda, Videoterapia, Notas, Informes, Analítica, Facturación, Configuración)
  - Flujos de usuario clave (gestión de paciente, videoterapia, generación de informe, facturación)
  - Integración con Behavioral Twin, IA (copiloto), BPOS, BCE, BIP
  - Criterios de validación y métricas de éxito
used_by:
  - Frontend Engineers (implementación de la app)
  - UX/UI Designers (diseño de pantallas y flujos)
  - QA (pruebas de experiencia de usuario)
  - Psicólogos clínicos (validación de flujos de trabajo)
---

# BehavioralOS – Experiencia Apple: App del Terapeuta

> *"El terapeuta no debe pensar en la herramienta. Debe pensar en el paciente. La app del terapeuta es invisible cuando funciona bien: la información está donde debe estar, las herramientas aparecen cuando se necesitan, y la IA sugiere sin interrumpir. Es el equivalente digital de un consultorio bien organizado."*

---

## 1. Filosofía de la Experiencia Apple

### 1.1. La Fantasía Central: El Guía de la Exploración

La experiencia del terapeuta se basa en una **fantasía central** clara y funcional:

> **El terapeuta no es un "proveedor de servicios". Es un guía que acompaña al explorador (paciente) en su viaje de autodescubrimiento, utilizando herramientas de inteligencia clínica para personalizar el camino.**

Esta fantasía se traduce en:

| Concepto clínico | Metáfora Apple | Manifestación en la app |
|------------------|----------------|-------------------------|
| **Práctica clínica** | Un consultorio digital organizado. | Dashboard central con KPIs, pacientes, agenda y alertas. |
| **Paciente** | El centro de atención. | Perfil completo del paciente con Behavioral Twin integrado. |
| **Sesión terapéutica** | Un espacio de trabajo enfocado. | Videoterapia con HUD clínico, transcripción y copiloto IA. |
| **Notas clínicas** | Documentación precisa y trazable. | Editor de notas SOAP/DAP con autocompletado y firma electrónica. |
| **IA (TCCN)** | Un copiloto clínico silencioso. | Sugerencias de preguntas, hipótesis y oportunidades durante la sesión. |
| **Informes** | Reportes profesionales y personalizables. | Functional Behavioral Reports (FBR) con datos del Behavioral Twin. |
| **Facturación** | Gestión financiera integrada. | Suscripciones, pagos, facturas CFDI y reembolsos en un solo lugar. |

### 1.2. Principios de Diseño Apple

| # | Principio | Descripción | Manifestación en la app |
|---|-----------|-------------|-------------------------|
| 1 | **Minimalismo radical** | La interfaz muestra solo la información necesaria para la decisión clínica. | Sin elementos decorativos; jerarquía visual clara; espacios en blanco generosos. |
| 2 | **Claridad** | La información es fácil de entender y navegar. | Tipografía legible, etiquetas claras, breadcrumbs, búsqueda rápida. |
| 3 | **Eficiencia** | Las tareas comunes se realizan con pocos clics y atajos de teclado. | Atajos de teclado (`Cmd+K` para búsqueda), botones de acción rápida, flujos optimizados. |
| 4 | **Consistencia** | Los patrones de interacción son predecibles. | Mismos gestos, mismas posiciones de elementos, misma terminología. |
| 5 | **Integración profunda** | La app se conecta con el ecosistema de productividad del terapeuta. | Google Calendar/Outlook, Zoom/Google Meet, sistema de archivos local. |
| 6 | **Automatización silenciosa** | La IA trabaja en segundo plano, sugiriendo sin interrumpir. | Sugerencias de hipótesis, preguntas, notas automáticas. |
| 7 | **Privacidad y seguridad** | Los datos del paciente están protegidos con los más altos estándares. | Cifrado de extremo a extremo, autenticación biométrica, auditoría de acceso. |

### 1.3. El Lenguaje del Terapeuta (Vocabulario Controlado)

| Prohibido | Permitido | Ejemplo |
|-----------|-----------|---------|
| Paciente | Explorador, Persona, Usuario | "El explorador completó la misión de defusión." |
| Ejercicio, Tarea | Misión, Experiencia, Práctica | "La misión de aceptación fue completada." |
| Síntoma | Patrón, Señal, Indicador | "Observamos un patrón de evitación en contextos sociales." |
| Recaída | Nuevo aprendizaje, Información sobre el contexto | "Apareció un patrón conocido en un nuevo contexto." |
| Mejoría | Crecimiento, Flexibilidad | "El explorador ha desarrollado mayor flexibilidad psicológica." |
| Datos (en contexto clínico) | Evidencia, Huellas, Pistas | "La evidencia sugiere que la evitación disminuye con la exposición." |
| Alta | Transición, Nueva etapa | "El explorador entra en la etapa de entrenamiento continuo." |

---

## 2. Arquitectura de Navegación

### 2.1. Sidebar (Colapsable)
┌─────────────────────────────────────────────────────────────────────────┐
│ Sidebar (Terapeuta) │
├─────────────────────────────────────────────────────────────────────────┤
│ 🏠 Dashboard │
│ 👥 Pacientes │
│ 📅 Agenda │
│ 🎥 Videoterapia │
│ 📝 Notas │
│ 📊 Informes │
│ ⚙️ Configuración │
│ 📈 Analítica │
│ 💰 Facturación │
│ ❓ Ayuda │
│ │
│ ───────────────────────────────────────────────────────────────────── │
│ │
│ 👤 Dr. Marco Hernández │
│ 📧 marco@clinica.com │
│ 📊 12 pacientes activos │
└─────────────────────────────────────────────────────────────────────────┘


### 2.2. Atajos de Teclado

| Atajo | Acción | Uso |
|-------|--------|-----|
| `Cmd+K` o `Ctrl+K` | Abrir búsqueda rápida (global). | Navegación entre pacientes, pantallas y acciones. |
| `Cmd+1` | Ir a Dashboard. | Acceso rápido al resumen. |
| `Cmd+2` | Ir a Pacientes. | Acceso rápido a la lista de pacientes. |
| `Cmd+3` | Ir a Agenda. | Acceso rápido al calendario. |
| `Cmd+4` | Ir a Videoterapia. | Acceso rápido a la videollamada activa. |
| `Cmd+5` | Ir a Notas. | Acceso rápido al editor de notas. |
| `Cmd+6` | Ir a Informes. | Acceso rápido a la lista de informes. |
| `Cmd+7` | Ir a Analítica. | Acceso rápido a los dashboards. |
| `Cmd+8` | Ir a Facturación. | Acceso rápido a la gestión financiera. |
| `Cmd+9` | Ir a Configuración. | Acceso rápido a las preferencias. |
| `Cmd+N` | Crear nuevo paciente, cita, nota, etc. | Acción contextual. |
| `Cmd+S` | Guardar (nota, informe, configuración). | Guardar cambios. |
| `Esc` | Cerrar modal o volver a la pantalla anterior. | Navegación rápida. |

### 2.3. Búsqueda Rápida (Cmd+K)

La búsqueda rápida es el centro de navegación del terapeuta. Permite buscar y acceder a:

- **Pacientes**: Por nombre, ID, o estado.
- **Sesiones**: Por fecha, paciente o terapeuta.
- **Notas**: Por paciente, fecha o palabras clave.
- **Informes**: Por paciente, tipo o fecha.
- **Acciones**: "Agendar cita", "Generar informe", "Ver perfil de paciente", etc.

┌─────────────────────────────────────────────────────────────────────────┐
│ 🔍 Buscar... │
├─────────────────────────────────────────────────────────────────────────┤
│ Resultados: │
│ │
│ 👥 Pacientes │
│ • María González (paciente activo, última sesión: 28/06) │
│ • Juan Pérez (paciente activo, última sesión: 27/06) │
│ • Laura Fernández (paciente en alta, 15/06) │
│ │
│ 📅 Sesiones │
│ • Sesión con María González (01/07, 10:00) │
│ • Sesión con Juan Pérez (02/07, 11:00) │
│ │
│ 📝 Notas │
│ • Nota de sesión - María González (28/06) │
│ • Nota de sesión - Juan Pérez (27/06) │
│ │
│ Acciones │
│ • Agendar cita con María González │
│ • Generar informe FBR para Juan Pérez │
└─────────────────────────────────────────────────────────────────────────┘


---

## 3. Pantalla: Dashboard

### 3.1. Descripción General

El Dashboard es la **pantalla de inicio** del terapeuta. Proporciona una visión de alto nivel de su práctica clínica, con KPIs clave, alertas y acceso rápido a las acciones más frecuentes.
┌─────────────────────────────────────────────────────────────────────────┐
│ 🏠 Dashboard 🔔 3 alertas nuevas │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌──────────────┐ ┌──────────────┐ ┌──────────────┐ ┌──────────────┐ │
│ │ Pacientes │ │ Sesiones │ │ Ingresos │ │ Retención │ │
│ │ 12 activos │ │ 5 hoy │ │ $14,200 │ │ 92% │ │
│ │ ↑ 2 esta │ │ 8 esta semana│ │ ↑ 12% │ │ ↓ 3% │ │
│ │ semana │ │ │ │ │ │ │ │
│ └──────────────┘ └──────────────┘ └──────────────┘ └──────────────┘ │
│ │
│ 📅 Sesiones de hoy │
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ 10:00 María González ⚠️ Riesgo de abandono: medio │ │
│ │ 11:00 Juan Pérez ✅ Última sesión: progreso │ │
│ │ 12:00 Laura Fernández ⚠️ Riesgo de abandono: alto │ │
│ │ 15:00 Carlos Ruiz ✅ Sin alertas │ │
│ └─────────────────────────────────────────────────────────────────┘ │
│ │
│ ⚠️ Alertas clínicas │
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ • Laura Fernández: Riesgo de abandono alto (última semana) │ │
│ │ • María González: Disminución de adherencia en ejercicios │ │
│ │ • Juan Pérez: Mejora significativa en Aceptación (↑ 25%) │ │
│ └─────────────────────────────────────────────────────────────────┘ │
│ │
│ 📈 Progreso de pacientes (última semana) │
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ ████████░░░░ Aceptación (promedio) ↑ 12% │ │
│ │ ██████░░░░░░ Defusión (promedio) ↑ 8% │ │
│ │ ████████░░░░ Valores (promedio) ↑ 15% │ │
│ └─────────────────────────────────────────────────────────────────┘ │
│ │
│ 💰 Ingresos del mes │
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ ██████████████████████████████████████░░░░ $14,200/20,000 │ │
│ └─────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────┘


### 3.2. Elementos del Dashboard

| Elemento | Descripción | Comportamiento |
|----------|-------------|----------------|
| **KPIs** | Tarjetas con números y tendencias: Pacientes activos, Sesiones de hoy, Ingresos (MRR), Retención. | Click → abre la vista detallada correspondiente. |
| **Sesiones de hoy** | Lista de sesiones programadas para hoy con indicadores de riesgo. | Click → abre la agenda o el perfil del paciente. |
| **Alertas clínicas** | Pacientes con riesgo de abandono, recaída o progreso significativo. | Click → abre el perfil del paciente con la alerta resaltada. |
| **Progreso de pacientes** | Gráficos de barras con la evolución promedio de procesos (última semana). | Click → abre la analítica detallada. |
| **Ingresos del mes** | Barra de progreso con el ingreso mensual y su meta. | Click → abre la facturación. |
| **Notificaciones** | Campana en la esquina superior derecha con el número de notificaciones no leídas. | Click → abre el centro de notificaciones. |

---

## 4. Pantalla: Pacientes

### 4.1. Descripción General

La pantalla de Pacientes muestra la **lista completa de pacientes** del terapeuta, con filtros, búsqueda y acceso rápido a las acciones más comunes.
┌─────────────────────────────────────────────────────────────────────────┐
│ 👥 Pacientes 🔍 Buscar... [+ Nuevo] │
├─────────────────────────────────────────────────────────────────────────┤
│ Filtros: [Todos] [Activos] [Alta] [Riesgo] [Sin actividad] │
│ Ordenar: [Nombre] [Última sesión] [Riesgo] │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ 🖼️ [Avatar] María González 📅 45 años ⚠️ Riesgo: medio │ │
│ │ Última sesión: 28/06 Próxima: 01/07 📊 5 ejercicios│ │
│ │ [Agendar] [Mensaje] [Ver perfil] │ │
│ └─────────────────────────────────────────────────────────────────┘ │
│ │
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ 🖼️ [Avatar] Juan Pérez 📅 32 años ✅ Riesgo: bajo │ │
│ │ Última sesión: 27/06 Próxima: 02/07 📊 8 ejercicios│ │
│ │ [Agendar] [Mensaje] [Ver perfil] │ │
│ └─────────────────────────────────────────────────────────────────┘ │
│ │
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ 🖼️ [Avatar] Laura Fernández 📅 28 años ⚠️ Riesgo: alto │ │
│ │ Última sesión: 20/06 Próxima: 03/07 📊 2 ejercicios│ │
│ │ [Agendar] [Mensaje] [Ver perfil] │ │
│ └─────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────┘


### 4.2. Elementos de la Pantalla de Pacientes

| Elemento | Descripción | Comportamiento |
|----------|-------------|----------------|
| **Filtros** | Por estado (activo, alta, transferido), por riesgo (bajo, medio, alto), por actividad (última semana, mes). | Click → filtra la lista. |
| **Búsqueda** | Campo de búsqueda por nombre, ID, email, etc. | Escribir → resultados en tiempo real. |
| **Tarjeta de paciente** | Avatar, nombre, edad, estado, última sesión, próxima sesión, número de ejercicios, indicador de riesgo. | Click → abre el perfil completo del paciente. |
| **Acciones rápidas** | Botones para agendar cita, enviar mensaje, ver perfil. | Click → abre la acción correspondiente. |
| **Botón "Nuevo paciente"** | Botón para crear un nuevo paciente (registro). | Click → abre el modal de creación. |

---

## 5. Pantalla: Perfil del Paciente

### 5.1. Descripción General

El Perfil del Paciente es el **centro de atención clínica**. Proporciona una vista completa del paciente, incluyendo información personal, Behavioral Twin, historial de sesiones, evaluaciones, hipótesis, valores, objetivos y ejercicios.

┌─────────────────────────────────────────────────────────────────────────┐
│ 👤 Perfil: María González 🔙 Volver a Pacientes │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ 🖼️ [Avatar] María González 📅 45 años 📞 555-123-4567 │ │
│ │ Terapeuta: Dr. Marco Hernández 📅 Ingreso: 01/01/2026 │ │
│ │ Estado: Activo 🎯 Riesgo: Medio │ │
│ │ │ │
│ │ [Agendar cita] [Enviar mensaje] [Generar informe] [Ver EHR] │ │
│ └─────────────────────────────────────────────────────────────────┘ │
│ │
│ 📊 Behavioral Twin │
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ [Hexaflex] [Red RFT] [Trayectorias de procesos] │ │
│ │ │ │
│ │ ████████░░░░ Aceptación: 65% ↑ 12% │ │
│ │ ██████░░░░░░ Defusión: 55% ↑ 8% │ │
│ │ ██████████░░ Valores: 82% ↑ 15% │ │
│ │ ████░░░░░░░░ Evitación: 35% ↓ 5% │ │
│ └─────────────────────────────────────────────────────────────────┘ │
│ │
│ 📝 Historial de sesiones │
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ 01/07/2026 10:00 Sesión completada [Ver notas] │ │
│ │ 28/06/2026 10:00 Sesión completada [Ver notas] │ │
│ │ 25/06/2026 10:00 Sesión completada [Ver notas] │ │
│ └─────────────────────────────────────────────────────────────────┘ │
│ │
│ 📋 Evaluaciones │
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ AAQ-II: 42 (15/06/2026) [Ver detalle] │ │
│ │ CompACT: 68 (15/06/2026) [Ver detalle] │ │
│ └─────────────────────────────────────────────────────────────────┘ │
│ │
│ 🧠 Hipótesis activas │
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ H1: Evitación social por reforzamiento negativo (confianza: │ │
│ │ 68%) │ │
│ │ H2: Autocrítica mediada por marcos de coordinación 'yo = │ │
│ │ fracaso' (confianza: 62%) │ │
│ │ [Ver todas] [Nueva hipótesis] │ │
│ └─────────────────────────────────────────────────────────────────┘ │
│ │
│ 💎 Valores y objetivos │
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ Valor: Conexión familiar (coherencia: 82%) │ │
│ │ Objetivo: Iniciar conversaciones con familiares (progreso: │ │
│ │ 60%) │ │
│ │ [Ver todos] [Nuevo objetivo] │ │
│ └─────────────────────────────────────────────────────────────────┘ │
│ │
│ 🎮 Ejercicios realizados │
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ El Bosque de la Incertidumbre (01/07) ⭐⭐⭐⭐ │ │
│ │ La Montaña de los Valores (29/06) ⭐⭐⭐ │ │
│ │ [Ver todos] │ │
│ └─────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────┘


### 5.2. Elementos del Perfil del Paciente

| Elemento | Descripción | Comportamiento |
|----------|-------------|----------------|
| **Información personal** | Avatar, nombre, edad, contacto, terapeuta, fecha de ingreso, estado, riesgo. | Editable (con permisos). |
| **Acciones rápidas** | Agendar cita, enviar mensaje, generar informe, ver EHR (expediente). | Click → abre la acción correspondiente. |
| **Behavioral Twin** | Visualización interactiva del Twin: Hexaflex (procesos), red RFT (marcos relacionales), trayectorias de procesos (gráficos de líneas). | Click en cada elemento → abre detalle. |
| **Historial de sesiones** | Lista cronológica de sesiones con fecha, hora, estado y acceso a notas. | Click → abre la nota de sesión. |
| **Evaluaciones** | Lista de evaluaciones (MPFI, AAQ-II, etc.) con puntuaciones, fechas y acceso a detalle. | Click → abre el detalle de la evaluación. |
| **Hipótesis activas** | Lista de hipótesis funcionales con descripción y nivel de confianza. | Click → abre el detalle de la hipótesis (con evidencia). |
| **Valores y objetivos** | Lista de valores ACT y objetivos terapéuticos con progreso. | Click → abre el detalle. |
| **Ejercicios realizados** | Lista de ejercicios completados con fecha y puntuación. | Click → abre el detalle del ejercicio (telemetría). |

---

## 6. Pantalla: Agenda

### 6.1. Descripción General

La Agenda es el **calendario del terapeuta**. Permite gestionar citas con vistas diaria, semanal y mensual, con integración con Google Calendar y Outlook.
┌─────────────────────────────────────────────────────────────────────────┐
│ 📅 Agenda [Día] [Semana] [Mes] [+] Nueva │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ Lunes 01/07 │ Martes 02/07 │ Miércoles 03/07 │ │ │
│ │ 09:00 - 10:00 │ 09:00 - 10:00 │ 09:00 - 10:00 │ │ │
│ │ María G. │ Juan P. │ Laura F. │ │ │
│ │ [⏰] │ [⏰] │ [⚠️] │ │ │
│ │ │ │ │ │ │
│ │ 10:00 - 11:00 │ 10:00 - 11:00 │ 10:00 - 11:00 │ │ │
│ │ Carlos R. │ Ana M. │ Jorge L. │ │ │
│ │ [✅] │ [📹] │ [📹] │ │ │
│ │ │ │ │ │ │
│ │ 11:00 - 12:00 │ 11:00 - 12:00 │ 11:00 - 12:00 │ │ │
│ │ (disponible) │ (disponible) │ (disponible) │ │ │
│ └─────────────────────────────────────────────────────────────────┘ │
│ │
│ ⏰ Próximas citas (hoy) │
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ 10:00 María González ⚠️ Riesgo de abandono: medio │ │
│ │ [Iniciar videollamada] [Ver perfil] [Editar] │ │
│ └─────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────┘


### 6.2. Elementos de la Agenda

| Elemento | Descripción | Comportamiento |
|----------|-------------|----------------|
| **Vistas** | Día, Semana, Mes. | Click → cambia la vista. |
| **Bloques de citas** | Bloques de tiempo con información del paciente (nombre, modalidad, indicadores de riesgo). | Click → abre el detalle de la cita. |
| **Indicadores** | [⏰] Presencial, [📹] Online, [⚠️] Riesgo, [✅] Progreso. | Visualización rápida. |
| **Crear cita** | Botón para crear una nueva cita (paciente, fecha, hora, modalidad). | Click → abre un modal de creación. |
| **Integración** | Sincronización con Google Calendar/Outlook. | Automática (con autorización). |
| **Disponibilidad** | Bloqueos de tiempo (vacaciones, descansos). | Configurable en "Configuración". |
| **Próximas citas** | Lista de citas del día con acceso a acciones (iniciar videollamada, ver perfil, editar). | Click → abre la acción correspondiente. |

---

## 7. Pantalla: Videoterapia (Workspace)

### 7.1. Descripción General

La pantalla de Videoterapia es el **espacio de trabajo de la sesión en vivo**. Integra la videollamada (Google Meet/Zoom), el HUD clínico (indicadores en tiempo real), la transcripción, el copiloto IA y las notas rápidas.

┌─────────────────────────────────────────────────────────────────────────┐
│ 🎥 Videoterapia: María González Duración: 35:12 │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ [Ventana de video del paciente] [Ventana de video del │ │
│ │ terapeuta] │ │
│ │ │ │
│ │ Controles: [🎤] [📹] [📺 Compartir] [💬 Chat] [📝 Notas] │ │
│ └─────────────────────────────────────────────────────────────────┘ │
│ │
│ 📊 HUD Clínico │
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ Proceso dominante: Aceptación (↑ 12% esta semana) │ │
│ │ CRB detectadas: │ │
│ │ • CRB1: Paciente evita contacto visual al hablar de su │ │
│ │ familia. │ │
│ │ Oportunidades: │ │
│ │ • Sugerir ejercicio de defusión para la crítica interna. │ │
│ │ [Ver más] │ │
│ └─────────────────────────────────────────────────────────────────┘ │
│ │
│ 📝 Transcripción en tiempo real │
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ Terapeuta: "¿Cómo te sientes hoy?" │ │
│ │ Paciente: "Me siento más tranquilo, pero aún me cuesta │ │
│ │ hablar de mi familia." │ │
│ │ Terapeuta: "Entiendo. ¿Qué es lo que te resulta más difícil?" │ │
│ │ Paciente: "Siento que voy a decepcionarlos." │ │
│ └─────────────────────────────────────────────────────────────────┘ │
│ │
│ 🤖 Copiloto IA │
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ Sugerencia: │ │
│ │ "Podrías explorar el marco relacional 'yo = fracaso' con │ │
│ │ una metáfora de defusión. ¿Te parece?" │ │
│ │ [Aceptar] [Modificar] [Ignorar] │ │
│ └─────────────────────────────────────────────────────────────────┘ │
│ │
│ [Finalizar sesión] │
└─────────────────────────────────────────────────────────────────────────┘


### 7.2. Elementos de la Videoterapia

| Elemento | Descripción | Comportamiento |
|----------|-------------|----------------|
| **Ventanas de video** | Video del paciente y del terapeuta. | Control de cámara, micrófono, compartir pantalla. |
| **Controles** | Botones para controlar la videollamada. | Click → activa/desactiva funciones. |
| **HUD Clínico** | Panel lateral o flotante con: proceso dominante, CRB detectadas, oportunidades de intervención. | Click → abre detalles de la oportunidad. |
| **Transcripción** | Texto de la conversación con identificación de hablante (paciente/terapeuta) y timestamps. | Scroll para ver historial. |
| **Notas rápidas** | Botón para tomar notas durante la sesión (mini editor). | Click → abre un mini editor de notas. |
| **Copiloto IA** | Sugerencias de preguntas, intervenciones o ejercicios (en panel lateral). | Click en "Aceptar" → inserta en el chat o en las notas. |
| **Finalizar sesión** | Botón para terminar la sesión. | Click → confirma y genera automáticamente un borrador de notas. |

### 7.3. Funcionalidades Avanzadas de Videoterapia

| Funcionalidad | Descripción | Comportamiento |
|---------------|-------------|----------------|
| **Detección de CRB (FAP)** | El sistema detecta Conductas Clínicamente Significativas (CRB1, CRB2, CRB3) en la interacción. | Se muestra en el HUD con sugerencias de respuesta (FAP 5 rules). |
| **Análisis de procesos en tiempo real** | El sistema estima el estado de los procesos (Aceptación, Defusión, etc.) basado en el lenguaje y la interacción. | Se actualiza en el HUD cada 5-10 segundos. |
| **Sugerencias de ejercicios** | El sistema sugiere ejercicios (misiones) que el terapeuta puede asignar durante o después de la sesión. | Click → abre el detalle del ejercicio. |
| **Notas automáticas** | Al finalizar la sesión, el sistema genera un borrador de notas SOAP/DAP basado en la transcripción y el HUD. | El terapeuta revisa y edita antes de firmar. |
| **Grabación (con consentimiento)** | Opción de grabar la sesión (audio/video) para supervisión o formación. | Click → inicia/detiene grabación. |

---

## 8. Pantalla: Notas Clínicas

### 8.1. Descripción General

La pantalla de Notas Clínicas es el **editor de notas de sesión**. Permite crear y editar notas SOAP (Subjective, Objective, Assessment, Plan) o DAP (Data, Assessment, Plan) con plantillas, autocompletado de procesos y CRB, y firma electrónica.


┌─────────────────────────────────────────────────────────────────────────┐
│ 📝 Nota de sesión: María González 📅 01/07/2026 [Firmar] [PDF] │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ [SOAP] [DAP] │ │
│ │ │ │
│ │ Subjective: │ │
│ │ "Paciente reporta disminución de ansiedad en contextos │ │
│ │ sociales. Menciona que ha iniciado conversaciones con su │ │
│ │ familia sin sentir la misma angustia." │ │
│ │ │ │
│ │ Objective: │ │
│ │ "Se observa mayor contacto visual, postura más abierta. │ │
│ │ Durante la sesión, el paciente practicó defusión con la │ │
│ │ metáfora del 'pasajero del autobús'." │ │
│ │ │ │
│ │ Assessment: │ │
│ │ "Progreso significativo en Aceptación (↑ 12%) y Defusión │ │
│ │ (↑ 8%). Se confirma la hipótesis H1 (evitación social por │ │
│ │ reforzamiento negativo)." │ │
│ │ │ │
│ │ Plan: │ │
│ │ "Continuar con ejercicios de defusión. Asignar misión 'El │ │
│ │ Bosque de la Incertidumbre' para practicar aceptación." │ │
│ └─────────────────────────────────────────────────────────────────┘ │
│ │
│ 🧠 Autocompletado │
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ Sugerencias: │ │
│ │ • Proceso: Aceptación (confianza: 0.82) │ │
│ │ • CRB1: Evitación de contacto visual │ │
│ │ • Hipótesis: H1 - Evitación social por reforzamiento │ │
│ │ • Ejercicio: El Bosque de la Incertidumbre │ │
│ └─────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────┘


### 8.2. Elementos de las Notas Clínicas

| Elemento | Descripción | Comportamiento |
|----------|-------------|----------------|
| **Tabs** | SOAP y DAP (dos formatos de notas). | Click → cambia el formato de la nota. |
| **Editor de texto** | Área de texto con formato básico (negrita, cursiva, listas). | Escribir y editar. |
| **Plantillas** | Selección de plantillas (SOAP, DAP, FAP, ACT). | Click → carga la estructura de la plantilla. |
| **Autocompletado** | Sugerencias de procesos, CRB, valores, hipótesis mientras se escribe (basado en el Behavioral Twin del paciente). | Aparece automáticamente al escribir. |
| **Firma electrónica** | Botón para firmar electrónicamente las notas (con OTP o biometría). | Click → solicita firma; guarda la nota firmada. |
| **Versiones** | Historial de versiones de la nota (cada modificación guarda una nueva versión). | Click → ver versiones anteriores y restaurar. |
| **Guardar** | Guarda automáticamente (borrador) o manualmente. | Click → guarda la nota. |
| **Exportar** | Exportar a PDF (con o sin firma). | Click → descarga el PDF. |

---

## 9. Pantalla: Informes

### 9.1. Descripción General

La pantalla de Informes permite **gestionar y generar informes clínicos** (Functional Behavioral Report, evaluaciones neuropsicológicas, etc.) con datos precargados del Behavioral Twin.

┌─────────────────────────────────────────────────────────────────────────┐
│ 📊 Informes 🔍 Buscar... [+ Nuevo] │
├─────────────────────────────────────────────────────────────────────────┤
│ Filtros: [Todos] [FBR] [Neuropsicología] [Evaluación] [Pendientes] │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ 📄 FBR - María González 📅 01/07/2026 ✅ Firmado │ │
│ │ Functional Behavioral Report - Progreso en ACT │ │
│ │ [Ver] [Editar] [Descargar PDF] [Firmar] │ │
│ └─────────────────────────────────────────────────────────────────┘ │
│ │
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ 📄 Evaluación Neuropsicológica - Juan Pérez 📅 28/06/2026 │ │
│ │ ⚠️ Pendiente de firma │ │
│ │ [Ver] [Editar] [Descargar PDF] [Firmar] │ │
│ └─────────────────────────────────────────────────────────────────┘ │
│ │
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ 📄 FBR - Laura Fernández 📅 20/06/2026 ⚠️ Borrador │ │
│ │ [Ver] [Editar] [Descargar PDF] [Firmar] │ │
│ └─────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────┘


### 9.2. Elementos de los Informes

| Elemento | Descripción | Comportamiento |
|----------|-------------|----------------|
| **Lista de informes** | Informes generados con fecha, tipo y estado. | Click → abre el informe. |
| **Filtros** | Por tipo (FBR, Neuropsicología, Evaluación) y por estado (borrador, pendiente, firmado). | Click → filtra la lista. |
| **Generar informe** | Botón para crear un nuevo informe (seleccionar tipo y paciente). | Click → abre el wizard de generación. |
| **Plantillas** | Selección de plantillas de informe (personalizables). | Click → carga la plantilla. |
| **Exportar** | Exportar a PDF (con CFDI si aplica). | Click → descarga el PDF. |
| **Firmar** | Firma electrónica del terapeuta. | Click → firma el informe. |

---

## 10. Pantalla: Analítica (BIP)

### 10.1. Descripción General

La pantalla de Analítica (BIP) proporciona **dashboards avanzados** con gráficos de procesos, tendencias de adherencia, predicciones y KPIs clínicos.

┌─────────────────────────────────────────────────────────────────────────┐
│ 📈 Analítica 📅 Últimos 30 días [Exportar] │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ 📊 Progreso de procesos (promedio de todos los pacientes) │ │
│ │ ██████████████████████████████████████████░░░░ Aceptación │ │
│ │ ████████████████████████████████████████░░░░ Defusión │ │
│ │ ████████████████████████████████████████████ Valores │ │
│ │ ██████████████████████████████████░░░░░░░░ Evitación │ │
│ └─────────────────────────────────────────────────────────────────┘ │
│ │
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ 📊 Adherencia (ejercicios por paciente) │ │
│ │ ████████████░░░░░░░░ María G. (8) ↑ 2 │ │
│ │ ██████████████████░░ Juan P. (12) ↑ 5 │ │
│ │ ██████░░░░░░░░░░░░░░ Laura F. (4) ↓ 3 │ │
│ └─────────────────────────────────────────────────────────────────┘ │
│ │
│ ⚠️ Predicciones │
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ • Laura F.: Riesgo de abandono: 82% (crítico) │ │
│ │ • María G.: Riesgo de abandono: 45% (medio) │ │
│ │ • Juan P.: Probabilidad de mejora: 75% (alta) │ │
│ └─────────────────────────────────────────────────────────────────┘ │
│ │
│ 📈 Tendencias de procesos (últimos 90 días) │
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ [Gráfico de líneas con Aceptación, Defusión, Evitación] │ │
│ └─────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────┘


### 10.2. Elementos de la Analítica

| Elemento | Descripción | Comportamiento |
|----------|-------------|----------------|
| **Gráficos de procesos** | Barras con el promedio de procesos por paciente o global. | Click → filtra por proceso o paciente. |
| **Adherencia** | Gráficos de adherencia (ejercicios completados por paciente). | Click → filtra por período. |
| **Predicciones** | Riesgo de abandono, recaída, probabilidad de mejora. | Click → abre el detalle de la predicción. |
| **Tendencias** | Gráficos de líneas con la evolución de procesos (últimos 90 días). | Click → filtra por proceso. |
| **Exportar** | Exportar datos a CSV o PDF. | Click → descarga el archivo. |
| **Filtros** | Por paciente, terapeuta, fecha, proceso. | Click → aplica filtros. |

---

## 11. Pantalla: Facturación

### 11.1. Descripción General

La pantalla de Facturación gestiona **suscripciones, facturas, pagos y reembolsos**. Integra Stripe, Mercado Pago y Facturapi para una gestión financiera completa.

┌─────────────────────────────────────────────────────────────────────────┐
│ 💰 Facturación 📅 Junio 2026 [Exportar] │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌──────────────┐ ┌──────────────┐ ┌──────────────┐ ┌──────────────┐ │
│ │ Ingresos │ │ Facturas │ │ Pagos │ │ Reembolsos │ │
│ │ $14,200 │ │ 12 emitidas │ │ 12 exitosos │ │ 0 │ │
│ │ ↑ 12% │ │ 2 pendientes │ │ 2 fallidos │ │ │ │
│ └──────────────┘ └──────────────┘ └──────────────┘ └──────────────┘ │
│ │
│ 📋 Suscripciones activas │
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ María González Plan Mensual $700/mes Renovación: 01/08 │ │
│ │ Juan Pérez Plan Trimestral $2,100/mes Renovación: 01/09 │ │
│ │ Laura Fernández Plan Mensual $700/mes Renovación: 03/08 │ │
│ └─────────────────────────────────────────────────────────────────┘ │
│ │
│ 📄 Facturas recientes │
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ INV-001 01/07/2026 María G. $812 Pagada [PDF] [XML] │ │
│ │ INV-002 28/06/2026 Juan P. $2,436 Pagada [PDF] [XML] │ │
│ │ INV-003 20/06/2026 Laura F. $812 Pendiente [PDF] [XML] │ │
│ └─────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────┘


### 11.2. Elementos de la Facturación

| Elemento | Descripción | Comportamiento |
|----------|-------------|----------------|
| **KPIs financieros** | Ingresos, facturas emitidas, pagos exitosos, reembolsos. | Click → abre la vista detallada. |
| **Suscripciones activas** | Lista de pacientes con suscripción activa (plan, precio, fecha de renovación). | Click → abre el detalle de la suscripción. |
| **Facturas** | Lista de facturas emitidas con estado (pagada, pendiente, fallida). | Click → abre el detalle de la factura. |
| **Pagos** | Historial de pagos con estado. | Click → abre el detalle del pago. |
| **Generar factura** | Botón para generar una factura manual (si aplica). | Click → abre el wizard de facturación. |
| **Reembolsos** | Gestión de reembolsos. | Click → inicia el proceso de reembolso. |
| **Exportar** | Exportar datos financieros a Excel o PDF. | Click → descarga el archivo. |

---

## 12. Flujos de Usuario Clave

### 12.1. Flujo: Gestión de un Paciente

**Propósito**: Navegar desde la lista de pacientes hasta la acción clínica deseada (agendar, ver perfil, enviar mensaje, etc.).

**Pasos**:

1. **Buscar o filtrar paciente**: En la pantalla de "Pacientes" (barra de búsqueda o filtros).
2. **Click en la tarjeta del paciente**: Abre el perfil completo del paciente.
3. **Explorar Behavioral Twin**: En el perfil, ver el Hexaflex, la red RFT y las trayectorias de procesos.
4. **Agendar cita**: Desde el perfil o desde la agenda, click en "Agendar cita" → selecciona fecha y hora.
5. **Enviar mensaje**: Click en "Enviar mensaje" → abre el chat con el paciente (en la app).
6. **Generar informe**: Click en "Generar informe" → selecciona el tipo de informe y lo genera.
7. **Actualizar hipótesis**: Click en "Hipótesis" → edita o crea una nueva hipótesis.

### 12.2. Flujo: Videoterapia

**Propósito**: Realizar una sesión en vivo con el paciente, utilizando el HUD clínico y el copiloto IA.

**Pasos**:

1. **Notificación**: El terapeuta recibe un recordatorio de la sesión (correo, push, dashboard).
2. **Click en "Iniciar sesión"** (desde el dashboard, agenda o perfil del paciente): Abre la pantalla de videoterapia.
3. **Configuración de la videollamada**: El terapeuta inicia la llamada (Google Meet/Zoom) y el paciente se une.
4. **Durante la sesión**: El terapeuta ve al paciente, el HUD clínico muestra indicadores en tiempo real (proceso dominante, CRB, oportunidades).
5. **Acciones durante la sesión**: El terapeuta toma notas rápidas, usa el copiloto IA para sugerencias de preguntas o ejercicios.
6. **Finalizar sesión**: Click en "Finalizar sesión". El sistema genera automáticamente un borrador de notas basado en la transcripción y el HUD.
7. **Revisión de notas**: El terapeuta revisa y edita el borrador (si es necesario).
8. **Firma**: El terapeuta firma las notas y las guarda en el expediente del paciente.

### 12.3. Flujo: Generación de un Informe (FBR)

**Propósito**: Crear un Functional Behavioral Report (FBR) basado en los datos del Behavioral Twin.

**Pasos**:

1. **Seleccionar paciente**: En el perfil del paciente o en la pantalla de informes.
2. **Click en "Generar informe"**: Selecciona el tipo de informe (FBR, Neuropsicológico, etc.).
3. **Seleccionar plantilla**: El sistema carga la plantilla con datos precargados del Behavioral Twin (procesos, hipótesis, valores, objetivos).
4. **Revisión y edición**: El terapeuta revisa y edita el informe (agrega observaciones, ajusta interpretaciones, añade recomendaciones).
5. **Firma**: El terapeuta firma electrónicamente el informe (con OTP o biometría).
6. **Exportar**: El informe se exporta a PDF y se almacena en el expediente del paciente.
7. **Enviar al paciente**: El informe se envía al paciente (correo, portal del paciente).

---

## 13. Integración con Motores del Ecosistema

### 13.1. Behavioral Twin
- **Lectura**: El perfil del paciente muestra el Twin (Hexaflex, red RFT, trayectorias). Las alertas clínicas se basan en el Twin.
- **Escritura**: El terapeuta puede actualizar el Twin (añadir hipótesis, modificar valores, etc.) a través de la interfaz.

### 13.2. TCCN (Copiloto IA)
- **Lectura**: El copiloto IA lee el Twin para generar sugerencias de preguntas y oportunidades durante la videoterapia.
- **Escritura**: Las notas automáticas y las sugerencias del copiloto se basan en la interacción y el estado del Twin.

### 13.3. AAO (Adaptive Assessment)
- **Lectura**: El AAO proporciona evaluaciones continuas que alimentan el perfil del paciente.
- **Escritura**: Las evaluaciones del AAO actualizan el Twin y se muestran en el perfil del paciente.

### 13.4. BERL (Ejercicios)
- **Lectura**: El perfil del paciente muestra los ejercicios realizados y su telemetría.
- **Escritura**: El terapeuta puede asignar misiones (ejercicios) desde el perfil del paciente.

### 13.5. BPOS (Práctica Clínica)
- **Lectura**: La agenda y las sesiones se gestionan en BPOS.
- **Escritura**: El terapeuta crea y gestiona sesiones, notas y citas a través de la app.

### 13.6. BCE (Comercio)
- **Lectura**: La facturación muestra suscripciones y pagos de los pacientes.
- **Escritura**: El terapeuta puede gestionar suscripciones, generar facturas y procesar reembolsos.

### 13.7. BIP (Analítica)
- **Lectura**: Los dashboards de analítica muestran KPIs, tendencias y predicciones basadas en los datos agregados.
- **Escritura**: Las predicciones y KPIs se generan automáticamente.

---

## 14. Criterios de Validación y Cumplimiento

| Criterio | Métrica | Herramienta |
|----------|---------|-------------|
| **Eficiencia** | ≤ 3 clics para realizar acciones comunes (agendar cita, ver perfil, generar informe). | Pruebas de usabilidad. |
| **Tiempo de carga** | < 2s en 3G. | Lighthouse. |
| **Accesibilidad** | Cumple WCAG 2.1 AA. | axe-core, Lighthouse. |
| **Satisfacción** | ≥ 4.5/5 en encuestas de satisfacción (NPS). | Encuestas in-app. |
| **Tiempo en videoterapia** | Reducción del tiempo de documentación post-sesión en ≥ 30%. | Pruebas comparativas. |
| **Precisión del copiloto** | ≥ 80% de las sugerencias del copiloto son útiles (según el terapeuta). | Feedback del terapeuta. |
| **Facturación** | 0% de errores en facturación (pagos duplicados, facturas incorrectas). | Pruebas de integración. |

---

## 15. El Manifiesto de la Experiencia Apple

> *"La experiencia del terapeuta no es una herramienta. Es un espacio de trabajo.*
>
> *El terapeuta no debe pensar en la interfaz. Debe pensar en el paciente.*
>
> *La información debe estar donde se necesita. Las herramientas deben aparecer cuando se necesitan.*
>
> *La IA debe sugerir sin interrumpir. Automatizar sin sustituir.*
>
> *El objetivo no es hacer al terapeuta más productivo. Es hacerlo más presente.*
>
> *Nuestra responsabilidad es diseñar una experiencia que sea tan eficiente como un consultorio bien organizado, pero tan poderosa como un equipo de apoyo clínico.*
>
> *Que el terapeuta pueda concentrarse en lo que realmente importa: la relación terapéutica y el cambio conductual."*

---

## 16. Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2026-07-01 | Diseño UX/UI | Creación del documento. Definición de filosofía Apple, arquitectura de navegación, especificación de pantallas (Dashboard, Pacientes, Agenda, Videoterapia, Notas, Informes, Analítica, Facturación, Configuración), flujos de usuario, integración con motores y criterios de validación. |

---

**Fin del documento `therapist-app.md`**