---
id: BAS-001
title: Behavioral Automation Studio (BAS)
version: 1.0.0
status: Stable
owner: Práctica Clínica & Automatización
last_updated: 2026-07-02
depends_on:
  - 000-Core/philosophy.md (Filosofía - eficiencia, autonomía)
  - 200-Backend/events-and-workflows.md (Eventos y workflows)
  - 200-Backend/api-graph.md (API Graph - triggers y acciones)
  - 300-Frontend/therapist-app.md (Experiencia Apple - interfaz del terapeuta)
  - 400-AI/companion.md (TCCN - notificaciones inteligentes)
  - 700-PracticeOS/practice-os.md (BPOS - agenda, CRM, pacientes)
  - 600-Commerce/business-model.md (BCE - facturación, suscripciones)
  - 800-Analytics/outcomes-analytics.md (BIP - métricas y predicciones)
  - 1000-Integration/bril-spec.md (BRIL - eventos y adaptadores)
  - 000-Infrastructure/selection.md (Infraestructura - opciones gratuitas)
exports:
  - Arquitectura del Automation Studio
  - Editor visual de workflows (drag & drop)
  - Catálogo de disparadores (triggers)
  - Catálogo de acciones (actions)
  - Catálogo de condiciones y filtros
  - Integración con el ecosistema (BPOS, BCE, BIP, TCCN)
  - Gestión de workflows (activación, desactivación, historial)
  - Plantillas predefinidas
  - Criterios de validación
used_by:
  - Terapeutas (automatización de tareas clínicas y operativas)
  - Administradores (workflows de negocio y marketing)
  - BPOS (ejecución de workflows)
  - BCE (workflows de facturación y cobranza)
  - BIP (workflows de análisis y reportes)
---

# BehavioralOS – Behavioral Automation Studio (BAS)

> *"La automatización no reemplaza el juicio clínico; lo potencia. El Behavioral Automation Studio permite a los terapeutas y administradores crear flujos de trabajo automatizados que reducen la carga administrativa, mejoran la adherencia de los pacientes y optimizan la práctica clínica. Sin código, sin complicaciones, solo resultados."*

---

## 1. Propósito y Alcance

### 1.1. Propósito
Este documento define el **Behavioral Automation Studio (BAS)** , una herramienta visual de automatización de workflows que permite a los terapeutas y administradores crear flujos de trabajo automatizados sin necesidad de programación. Su objetivo es:

- **Automatizar tareas repetitivas** (recordatorios, seguimiento, reactivación, notificaciones) para liberar tiempo del terapeuta.
- **Mejorar la adherencia** de los pacientes mediante recordatorios y seguimientos personalizados.
- **Optimizar la práctica clínica** con workflows que integran agenda, CRM, facturación y analítica.
- **Facilitar la creación de workflows** a través de un editor visual drag & drop.
- **Integrar todos los módulos del ecosistema** (BPOS, BCE, BIP, TCCN) en flujos automatizados.
- **Proveer plantillas predefinidas** para casos de uso comunes (onboarding, seguimiento, reactivación, etc.).

### 1.2. Alcance
El documento cubre:

- **Arquitectura del Automation Studio**: Componentes, flujos de creación y ejecución.
- **Editor visual de workflows**: Interfaz drag & drop para construir flujos.
- **Catálogo de disparadores (triggers)**: Eventos que inician un workflow.
- **Catálogo de acciones (actions)**: Tareas que se ejecutan en un workflow.
- **Catálogo de condiciones y filtros**: Reglas lógicas que controlan el flujo.
- **Integración con el ecosistema**: Conexión con BPOS, BCE, BIP, TCCN y BRIL.
- **Gestión de workflows**: Activación, desactivación, historial de ejecuciones.
- **Plantillas predefinidas**: Casos de uso comunes listos para usar.
- **Criterios de validación**: Métricas de usabilidad, rendimiento y efectividad.

### 1.3. Principio Fundamental
> *"La automatización no reemplaza el juicio clínico; lo potencia. El BAS permite a los terapeutas centrarse en lo que realmente importa: el paciente y la terapia. Las tareas repetitivas se automatizan, las decisiones importantes quedan en manos del profesional."*

---

## 2. Filosofía del Automation Studio

### 2.1. Principios de Diseño

| # | Principio | Descripción | Manifestación |
|---|-----------|-------------|---------------|
| 1 | **Sin código** | No se requiere programación para crear workflows. | Editor visual drag & drop. |
| 2 | **Visual e intuitivo** | Los workflows se construyen con bloques visuales. | Interfaz tipo "flowchart" con conexiones entre bloques. |
| 3 | **Integración nativa** | Los workflows se conectan automáticamente con todos los módulos. | Acciones y triggers predefinidos para cada módulo. |
| 4 | **Seguro y ético** | Los workflows respetan la privacidad y autonomía del paciente. | No se automatizan decisiones clínicas críticas; solo tareas administrativas y de apoyo. |
| 5 | **Escalable** | Los workflows pueden ser simples (1 paso) o complejos (múltiples condiciones y acciones). | Flujos condicionales, bucles, esperas. |
| 6 | **Auditable** | Cada ejecución de workflow se registra para trazabilidad. | Historial de ejecuciones con resultados. |

### 2.2. Inspiración

El BAS se inspira en plataformas de automatización como **Zapier**, **Make (Integromat)**, **n8n** y **HubSpot Workflows**, pero adaptado específicamente a las necesidades de psicólogos y terapeutas, con integraciones nativas con los módulos del BehavioralOS.

---

## 3. Arquitectura del Automation Studio

### 3.1. Visión General

┌─────────────────────────────────────────────────────────────────────────┐
│ Behavioral Automation Studio (BAS) │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ Visual Workflow Editor (Drag & Drop) │ │
│ │ • Bloques: Triggers, Conditions, Actions, Delays, Loops │ │
│ │ • Conexiones entre bloques │ │
│ │ • Previsualización y simulación │ │
│ └─────────────────────────────────────────────────────────────────┘ │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ Workflow Engine │ │
│ │ • Ejecución de workflows (basado en eventos) │ │
│ │ • Cola de ejecución (BullMQ) │ │
│ │ • Monitoreo y logs │ │
│ └─────────────────────────────────────────────────────────────────┘ │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ Integration Layer │ │
│ │ • BPOS (agenda, CRM, pacientes, notas) │ │
│ │ • BCE (facturación, suscripciones, pagos) │ │
│ │ • BIP (métricas, predicciones, reportes) │ │
│ │ • TCCN (notificaciones, mensajes, conversaciones) │ │
│ │ • BRIL (eventos, webhooks, adaptadores) │ │
│ └─────────────────────────────────────────────────────────────────┘ │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ Workflow Library & Templates │ │
│ │ • Plantillas predefinidas │ │
│ │ • Workflows guardados por el terapeuta │ │
│ │ • Marketplace de workflows (compartir con otros) │ │
│ └─────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────┘


### 3.2. Componentes del BAS

| Componente | Descripción | Tecnología | Notas (Gratuito) |
|------------|-------------|------------|------------------|
| **Visual Workflow Editor** | Editor drag & drop para construir workflows. | React + React Flow | Open source |
| **Workflow Engine** | Motor de ejecución de workflows. | Python (FastAPI) + BullMQ | Open source |
| **Integration Layer** | Conexión con módulos del ecosistema. | Python (FastAPI) + BRIL | Open source |
| **Workflow Library & Templates** | Almacén de workflows y plantillas. | Supabase | Plan gratuito |

---

## 4. Editor Visual de Workflows

### 4.1. Bloques Disponibles

#### 4.1.1. Disparadores (Triggers)

| Disparador | Descripción | Configuración |
|------------|-------------|---------------|
| **Nuevo paciente** | Se activa cuando un paciente se registra en la plataforma. | Filtros (edad, diagnóstico, etc.). |
| **Cita programada** | Se activa cuando se programa una cita. | Filtros (modalidad, duración, etc.). |
| **Cita completada** | Se activa cuando una cita se completa. | Filtros (paciente, terapeuta, etc.). |
| **Cita cancelada** | Se activa cuando una cita se cancela. | Filtros (motivo de cancelación, etc.). |
| **Ejercicio completado** | Se activa cuando un paciente completa un ejercicio (BERL). | Filtros (ejercicio, puntuación, etc.). |
| **Pago recibido** | Se activa cuando se recibe un pago (BCE). | Filtros (monto, método, etc.). |
| **Suscripción activada** | Se activa cuando se activa una suscripción (BCE). | Filtros (plan, etc.). |
| **Suscripción cancelada** | Se activa cuando se cancela una suscripción (BCE). | Filtros (motivo, etc.). |
| **Inactividad** | Se activa cuando un paciente no ha interactuado con la plataforma en X días. | Configuración de días de inactividad. |
| **Riesgo detectado** | Se activa cuando el BIP detecta un riesgo (abandono, recaída). | Filtros (tipo de riesgo, nivel). |
| **Mensaje recibido** | Se activa cuando el paciente envía un mensaje (TCCN, chat). | Filtros (contenido, palabras clave). |
| **Fecha programada** | Se activa en una fecha/hora específica (recurrente o única). | Configuración de fecha y hora. |
| **Webhook** | Se activa cuando se recibe un webhook externo. | Configuración de URL y autenticación. |

#### 4.1.2. Condiciones (Filtros)

| Condición | Descripción | Configuración |
|-----------|-------------|---------------|
| **Si... entonces...** | Ejecuta acciones si se cumple una condición. | Condición lógica (ej. "si paciente tiene riesgo de abandono"). |
| **Filtro por paciente** | Filtra por atributos del paciente. | Edad, diagnóstico, estado, etc. |
| **Filtro por cita** | Filtra por atributos de la cita. | Modalidad, duración, estado, etc. |
| **Filtro por pago** | Filtra por atributos del pago. | Monto, método, estado, etc. |
| **Filtro por ejercicio** | Filtra por atributos del ejercicio. | Tipo, puntuación, duración, etc. |
| **Filtro por tiempo** | Filtra por tiempo transcurrido desde un evento. | Días, horas, minutos. |

#### 4.1.3. Acciones (Actions)

| Acción | Descripción | Configuración |
|--------|-------------|---------------|
| **Enviar correo** | Envía un correo electrónico. | Plantilla de correo, destinatario, asunto, contenido. |
| **Enviar notificación push** | Envía una notificación push a la app. | Título, mensaje, destinatario. |
| **Enviar SMS** | Envía un SMS (Twilio). | Número, mensaje. |
| **Enviar mensaje TCCN** | El compañero IA envía un mensaje al paciente. | Texto del mensaje (puede incluir variables dinámicas). |
| **Programar cita** | Programa una nueva cita en la agenda del terapeuta. | Fecha, hora, duración, modalidad. |
| **Cancelar cita** | Cancela una cita existente. | ID de la cita, motivo. |
| **Asignar ejercicio** | Asigna un ejercicio (BERL) al paciente. | ID del ejercicio, fecha límite. |
| **Actualizar paciente** | Actualiza información del paciente (ej. estado, etiquetas). | Campo a actualizar, valor. |
| **Crear nota** | Crea una nota en el expediente del paciente. | Contenido, tipo de nota. |
| **Generar informe** | Genera un informe (ej. FBR) para el paciente. | Tipo de informe, plantilla. |
| **Actualizar suscripción** | Actualiza la suscripción del paciente (BCE). | Cambio de plan, estado, etc. |
| **Enviar webhook** | Envía una petición a una URL externa. | URL, método, payload. |
| **Esperar** | Espera un tiempo determinado antes de continuar. | Días, horas, minutos. |
| **Ejecutar workflow** | Ejecuta otro workflow como subproceso. | ID del workflow. |

### 4.2. Interfaz de Usuario

- **Panel de bloques**: Lista de todos los bloques disponibles (disparadores, condiciones, acciones).
- **Área de trabajo**: Lienzo donde se arrastran y conectan los bloques.
- **Configuración de bloque**: Al hacer clic en un bloque, se abre un panel lateral con sus opciones de configuración.
- **Previsualización**: Muestra una vista previa del flujo de trabajo.
- **Simulación**: Permite ejecutar el workflow en modo simulación para verificar su funcionamiento.
- **Guardar y publicar**: Botones para guardar el workflow como borrador o publicarlo (activarlo).

---

## 5. Plantillas Predefinidas

| Plantilla | Descripción | Disparador | Acciones |
|-----------|-------------|------------|----------|
| **Bienvenida al nuevo paciente** | Envía un mensaje de bienvenida al paciente cuando se registra. | Nuevo paciente | Enviar correo + mensaje TCCN. |
| **Recordatorio de cita (24h)** | Envía un recordatorio 24 horas antes de la cita. | Cita programada + fecha programada | Enviar correo + push + SMS. |
| **Recordatorio de cita (1h)** | Envía un recordatorio 1 hora antes de la cita. | Cita programada + fecha programada | Enviar push + SMS. |
| **Seguimiento post-sesión** | Envía una encuesta de satisfacción después de la sesión. | Cita completada | Enviar correo con encuesta. |
| **Asignación de ejercicio post-sesión** | Asigna un ejercicio después de la sesión. | Cita completada | Asignar ejercicio. |
| **Reactivación de paciente inactivo** | Contacta al paciente después de X días de inactividad. | Inactividad (30 días) | Enviar mensaje TCCN + correo. |
| **Alerta de riesgo de abandono** | Notifica al terapeuta si un paciente tiene riesgo de abandono. | Riesgo detectado (abandono) | Enviar correo al terapeuta + alerta en dashboard. |
| **Alerta de riesgo de recaída** | Notifica al terapeuta si un paciente tiene riesgo de recaída. | Riesgo detectado (recaída) | Enviar correo al terapeuta + sugerir ejercicio. |
| **Renovación de suscripción** | Recuerda al paciente que su suscripción está por vencer. | Suscripción próxima a expirar (7 días) | Enviar correo + push. |
| **Pago fallido** | Notifica al paciente si un pago falla y ofrece actualizar el método de pago. | Pago fallido | Enviar correo + push + mensaje TCCN. |
| **Cumpleaños del paciente** | Envía un mensaje de cumpleaños personalizado. | Fecha programada (cumpleaños) | Enviar correo + mensaje TCCN. |
| **Encuesta periódica** | Envía una encuesta de satisfacción cada 3 meses. | Fecha programada (recurrente) | Enviar correo con encuesta. |

---

## 6. Integración con el Ecosistema

### 6.1. BPOS (Práctica Clínica)
- **Disparadores**: Nuevo paciente, cita programada, cita completada, cita cancelada, inactividad.
- **Acciones**: Programar cita, cancelar cita, actualizar paciente, crear nota, generar informe.

### 6.2. BCE (Comercio)
- **Disparadores**: Pago recibido, suscripción activada, suscripción cancelada, suscripción próxima a expirar, pago fallido.
- **Acciones**: Actualizar suscripción, generar factura, enviar recordatorio de pago.

### 6.3. BIP (Analítica)
- **Disparadores**: Riesgo detectado (abandono, recaída), mejora detectada.
- **Acciones**: Enviar alerta al terapeuta, generar reporte.

### 6.4. TCCN (Compañero IA)
- **Disparadores**: Mensaje recibido (con palabras clave), conversación completada.
- **Acciones**: Enviar mensaje TCCN, iniciar conversación guiada.

### 6.5. BRIL (Integración)
- **Disparadores**: Eventos de BRIL (ej. `EXERCISE_COMPLETED`, `CHAT_MESSAGE_SENT`).
- **Acciones**: Publicar evento en BRIL, enviar webhook.

---

## 7. Gestión de Workflows

### 7.1. Ciclo de Vida de un Workflow

1. **Creación**: El terapeuta o administrador crea un nuevo workflow en el editor visual.
2. **Prueba**: El workflow se prueba en modo simulación.
3. **Guardado**: El workflow se guarda como borrador (inactivo).
4. **Publicación**: El workflow se activa y comienza a ejecutarse.
5. **Ejecución**: El workflow se ejecuta automáticamente cuando se activa un disparador.
6. **Monitoreo**: El terapeuta puede ver el historial de ejecuciones y logs.
7. **Actualización**: El workflow se puede modificar y republicar.
8. **Desactivación**: El workflow se puede desactivar (dejar de ejecutarse) o eliminar.

### 7.2. Historial de Ejecuciones

| Campo | Descripción |
|-------|-------------|
| **ID de ejecución** | Identificador único de la ejecución. |
| **Workflow** | Nombre del workflow ejecutado. |
| **Disparador** | Evento que activó el workflow. |
| **Fecha y hora** | Cuándo se ejecutó. |
| **Estado** | Éxito, fallo, en progreso. |
| **Detalles** | Logs de cada paso del workflow. |
| **Errores** | Si hubo errores, mensaje de error. |

---

## 8. Criterios de Validación y Cumplimiento

| Criterio | Métrica | Herramienta |
|----------|---------|-------------|
| **Usabilidad** | El terapeuta puede crear un workflow en < 10 minutos (sin conocimiento técnico). | Pruebas de usabilidad |
| **Tiempo de ejecución** | Los workflows se ejecutan en < 5 segundos (desde el trigger hasta la acción). | Monitoreo de rendimiento |
| **Disponibilidad** | 99.9% de uptime para la ejecución de workflows. | Monitoreo |
| **Precisión** | Los workflows se ejecutan correctamente en > 99% de los casos. | Pruebas de integración |
| **Integración** | 100% de los triggers y acciones están correctamente integrados con los módulos. | Pruebas de integración |
| **Satisfacción** | ≥ 4.5/5 en encuestas de satisfacción con la automatización. | Encuestas in-app |

---

## 9. El Manifiesto del BAS

> *"La automatización no reemplaza el juicio clínico; lo potencia.*
>
> *El Behavioral Automation Studio permite a los terapeutas y administradores crear flujos de trabajo automatizados que reducen la carga administrativa, mejoran la adherencia de los pacientes y optimizan la práctica clínica.*
>
> *Sin código, sin complicaciones, solo resultados.*
>
> *No se trata de reemplazar al terapeuta; se trata de liberar su tiempo para que pueda dedicarse a lo que realmente importa: el paciente y la terapia.*
>
> *Nuestra responsabilidad es garantizar que el BAS sea fácil, seguro, confiable y perfectamente integrado con el ecosistema BehavioralOS."*

---

## 10. Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2026-07-02 | Arquitectura de Automatización | Creación del documento. Definición del Behavioral Automation Studio: arquitectura, editor visual, catálogo de triggers y acciones, plantillas predefinidas, integración con el ecosistema, gestión de workflows y criterios de validación. |

---

**Fin del documento `automation-studio.md`**