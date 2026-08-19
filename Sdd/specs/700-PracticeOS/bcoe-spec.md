---
id: BCOE-001
title: Behavioral Clinic Operations Engine (BCOE) — Motor de Operaciones del Negocio
version: 1.0.0
status: Draft
owner: Arquitectura de Software & Psicología Clínica
last_updated: 2026-07-14
depends_on:
  - BCMS (Behavioral Clinical Management System)
  - 600-Commerce (Business Model, Billing, Marketplace)
exports:
  - 18 submotores de operaciones del negocio
  - Clinic Administration Engine
  - Resource Management Engine
  - Staff Management Engine
  - Room & Equipment Manager
  - Financial Operations Engine
  - Billing & Subscription Engine
  - Payment Intelligence Engine
  - Operational Workflow Engine
  - Patient Journey Operations
  - Document Management Engine
  - Communication Center
  - Notification Center (operativo)
  - Inventory Manager
  - Operational Analytics
  - Multi-Branch Manager
  - Compliance Operations
  - Automation Engine (operativo)
  - Organization Settings
used_by:
  - BCMS (Behavioral Clinical Management System)
  - BCIE (Behavioral Caseload Intelligence Engine)
  - Therapist App (interfaz del terapeuta)
  - Admin Dashboard (panel administrativo)
  - BARS (Behavioral Analytics & Reporting System)
  - BRIL (Behavioral Runtime Integration Layer)
  - BCGS (Behavioral Clinical Governance System)
---

# BehavioralOS — Behavioral Clinic Operations Engine (BCOE)

> *"El BCOE administra la operación del consultorio o clínica. No toma decisiones clínicas. No formula casos. No recomienda intervenciones. Su responsabilidad es hacer que la organización funcione eficientemente."*

---

## 1. Propósito y Alcance

### 1.1. Propósito

El Behavioral Clinic Operations Engine (BCOE) es el **motor de operaciones** que administra todos los procesos administrativos, operativos y comerciales de consultorios, clínicas y hospitales que utilizan la plataforma Behavioral, manteniendo completamente separada la gestión operativa del razonamiento clínico.

### 1.2. Filosofía

El terapeuta debe dedicar su tiempo a la atención clínica. La plataforma debe encargarse de la operación. Por eso el BCOE automatiza todo aquello que **no requiere juicio clínico**.

### 1.3. Objetivos

El BCOE busca:
- Reducir carga administrativa
- Automatizar procesos repetitivos
- Optimizar recursos
- Mejorar la productividad operativa
- Facilitar el crecimiento del consultorio
- Permitir escalar a clínicas y hospitales
- Mantener trazabilidad operativa
- Integrarse con la capa clínica **sin invadirla**

### 1.4. Dependencias

- **BCMS**: datos de pacientes y agenda (solo lo operativo, nunca contenido clínico)
- **600-Commerce**: modelo de negocio, facturación, marketplace

### 1.5. Diferenciación Fundamental

| Componente | Administra | NO accede a |
|------------|-----------|-------------|
| **BCMS** | La práctica clínica | Facturación, ocupación de salas |
| **BCIE** | La carga clínica | Decisiones clínicas, cambios de tratamiento |
| **BCOE** | La operación del negocio | Contenido clínico, formulaciones, procesos psicológicos |

> Para un psicólogo independiente aporta información sobre la salud operativa de su consulta. Para una clínica u hospital, ofrece una visión ejecutiva del funcionamiento del servicio **sin mezclar la gestión empresarial con las decisiones clínicas**.

---

## 2. Separación Clinical Core / Operations Core

```
CLINICAL CORE
──────────────────────────────
BCI, BCMS, BCAS, BIMS, BCIE, BSI,
BASP, BTPL, BTC, BCML, BPL
  │
  ↓  Interfaces Controladas
  │
OPERATIONS CORE
──────────────────────────────
BCOE
  ├── Facturación
  ├── Agenda Operativa
  ├── Recursos
  ├── Personal
  ├── Inventario
  ├── Licencias
  └── KPIs
```

Esta separación evita uno de los errores más comunes de los ERP médicos: **mezclar la lógica clínica con la lógica administrativa**.

---

## 3. Arquitectura

```
Behavioral Clinic Operations Engine (BCOE)
│
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

## 4. Submotores Detallados

### 4.1. Clinic Administration Engine

**Propósito**: Ser el núcleo administrativo que gestiona la estructura organizacional.

**Gestiona**:
- Consultorios individuales
- Clínicas con múltiples sedes
- Hospitales y departamentos
- Sucursales y unidades

**Ejemplo**:
```
Clínica Behavioral
├── Sucursal Norte
├── Sucursal Centro
└── Teleconsulta
```

**Datos que maneja**:
- Estructura organizacional (jerarquía de unidades)
- Configuración por unidad (horarios, políticas, moneda)
- Metadatos de cada ubicación
- Estado operativo de cada unidad

**Integraciones**:
- Multi-Branch Manager → consolidación multi-sede
- Organization Settings → configuración global
- BCGS → políticas institucionales

---

### 4.2. Resource Management Engine

**Propósito**: Administrar todos los recursos del consultorio o clínica, no únicamente salas.

**Recursos administrados**:
- Consultorios y salas de terapia
- Computadoras y tablets
- Cascos VR
- Cámaras y sensores
- Material neuropsicológico
- Licencias de software
- Dispositivos de biofeedback

**Ejemplo**:
```
Sala 3 → Disponible 14:00 → Reservada 16:00
Equipo VR → En uso → Devolución estimada: 17:30
```

**Integraciones**:
- Room & Equipment Manager → reservas y disponibilidad
- BCOE → Staff Management para asignación de personal
- BCIE → Resource Allocation Engine para distribución óptima

---

### 4.3. Staff Management Engine

**Propósito**: Administrar todo el personal, no únicamente psicólogos.

**Roles soportados**:
- Psicólogos clínicos
- Neuropsicólogos
- Supervisores
- Practicantes
- Recepción
- Administración
- Coordinadores clínicos
- Evaluadores

> Cada rol tiene permisos independientes (RBAC).

**Datos que maneja**:
- Perfil profesional (especialización, licencia, certificaciones)
- Disponibilidad horaria
- Asignación de casos y pacientes
- Historial de desempeño
- Carga de trabajo actual
- Documentación laboral

**Integraciones**:
- RBAC → permisos por rol
- BCIE → Therapist Capacity Engine y Burnout Prevention Engine
- BCOE → Billing & Subscription Engine (para licencias de staff)
- BCGS → políticas de acceso y confidencialidad

---

### 4.4. Room & Equipment Manager

**Propósito**: Reservar y gestionar consultorios, salas grupales, equipos neuropsicológicos y dispositivos.

**Especialmente útil para clínicas grandes.**

**Funciones**:
- Reserva de consultorios por horario y terapeuta
- Reserva de salas grupales para terapia familiar/pareja
- Asignación de equipos neuropsicológicos
- Control de disponibilidad en tiempo real
- Prevención de conflictos de reserva
- Historial de utilización por sala/equipo
- Mantenimiento programado de equipos

**Integraciones**:
- Resource Management Engine → inventario de recursos
- BCMS → Appointment Manager para reservas vinculadas a citas
- BSI → coordinación de programación con disponibilidad de sala
- Operational Analytics → métricas de utilización

---

### 4.5. Financial Operations Engine

**Propósito**: Organizar la salud financiera sin sustituir al contador.

**Funciones**:
- Registro de ingresos por servicio, programa o membresía
- Registro de egresos operativos
- Flujo de efectivo proyectado
- Costos por servicio o terapeuta
- Rentabilidad por programa
- Compatible con las reglas fiscales mexicanas (BCGS)

**Datos que maneja**:
- Ingresos (sesiones, programas, membresías, licencias)
- Egresos (personal, alquiler, equipos, servicios)
- Flujo de caja mensual/anual
- Costo por paciente atendido
- Margen por programa

**Integraciones**:
- Billing & Subscription Engine → datos de facturación
- BCGS → reglas fiscales y normativas
- Operational Analytics → dashboards financieros
- BCOE → Compliance Operations para auditorías financieras

---

### 4.6. Billing & Subscription Engine

**Propósito**: Gestionar toda la monetización de la plataforma.

**Modelos soportados**:

| Segmento | Modelos |
|----------|---------|
| **Pacientes** | Suscripción semanal, mensual, bimestral, semestral; programas de tratamiento; membresías |
| **Psicólogos** | Licencias; suscripciones; comisión por paciente (solo nivel individual, no aplica a clínicas ni hospitales) |
| **Clínicas** | Licencias empresariales |
| **Hospitales** | Licencias Enterprise |

**Integraciones**:
- Payment Intelligence Engine → procesamiento de pagos
- 600-Commerce → modelo de negocio y planes
- BCOE → Clinic Administration Engine para configuración por unidad
- BCGS → políticas de facturación y cumplimiento fiscal

---

### 4.7. Payment Intelligence Engine

**Propósito**: Gestionar pagos, reintentos, cobros, facturación, promociones y cupones.

**Funciones**:
- Procesamiento de pagos recurrentes
- Reintentos inteligentes en caso de fallo
- Emisión de facturas
- Promociones y cupones de descuento
- Meses sin intereses (si se ofrecen)
- Conciliación de pagos
- Alertas de pagos fallidos

**Integraciones**:
- Billing & Subscription Engine → planes y suscripciones
- Financial Operations Engine → registro contable
- Communication Center → notificaciones de pago
- BCGS → cumplimiento fiscal

---

### 4.8. Operational Workflow Engine

**Propósito**: Automatizar procesos administrativos repetitivos.

**Ejemplo**:
```
Nuevo paciente
  → Crear expediente
  → Enviar consentimiento
  → Enviar BCI
  → Esperar respuesta
  → Agendar sesión
  → Enviar recordatorio
```

Todo configurable por organización.

**Funciones**:
- Diseñador de workflows visuales
- Triggers configurables (evento → acción)
- Workflows de onboarding de pacientes
- Workflows de alta y seguimiento post-alta
- Workflows de facturación y cobro
- Workflows de supervisión
- Historial de ejecuciones y errores

**Integraciones**:
- BCMS → eventos clínicos que desencadenan workflows operativos
- Automation Engine del BCMS → coordinación de automatizaciones
- Communication Center → envío de notificaciones
- Document Management Engine → generación de documentos

---

### 4.9. Patient Journey Operations

**Propósito**: Analizar el recorrido del usuario **sin contenido clínico**.

**Ejemplo**:
```
Registro → Evaluación → Primera sesión → Programa → Seguimiento → Alta
```

> Permite detectar abandonos operativos (pacientes que se registraron pero nunca agendaron, o que agendaron una vez y no volvieron).

**Funciones**:
- Mapa del recorrido del paciente
- Detección de puntos de abandono
- Tiempo promedio entre etapas
- Conversión por etapa del funnel
- Alertas de pacientes estancados en una etapa

**Integraciones**:
- BCMS → datos de pacientes y sesiones (solo operativos)
- BCOE → Billing & Subscription Engine para estado de pagos
- Operational Analytics → métricas del journey
- BCIE → Dropout Prediction (perspectiva clínica complementaria)

---

### 4.10. Document Management Engine

**Propósito**: Administrar todos los documentos administrativos de la organización.

**Tipos de documento**:
- Consentimientos informados
- Contratos
- Cartas y constancias
- Recetas (si en algún país aplica)
- Certificados
- Facturas
- Políticas internas
- Manuales de procedimientos

**Funciones**:
- Versionado de documentos
- Firma electrónica
- Plantillas configurables
- Historial de generación y modificación
- Buscador de documentos
- Control de acceso por rol

**Integraciones**:
- Clinical Documentation Engine del BCMS → documentos clínicos (separados)
- BCGS → plantillas requeridas por regulación
- Compliance Operations → verificación de documentos vigentes
- Audit Manager → trazabilidad de documentos

---

### 4.11. Communication Center

**Propósito**: Centralizar toda la comunicación de la organización.

**Canales soportados**:
- Correo electrónico
- WhatsApp Business
- SMS
- Push notifications
- Mensajería dentro de la app

> Siempre respetando el consentimiento y las preferencias del usuario (BCGS).

**Funciones**:
- Plantillas de mensaje por tipo de comunicación
- Programación de envíos
- Historial de comunicaciones por paciente
- Gestión de consentimientos de comunicación
- Respuestas automáticas configurables

**Integraciones**:
- BCGS → preferencias de comunicación y consentimientos
- Notification Center (BCOE) → notificaciones operativas
- BCMS → Notification Center clínico (separado)
- Operational Workflow Engine → workflows que generan comunicaciones

---

### 4.12. Notification Center (Operativo)

**Propósito**: Gestionar todas las notificaciones de naturaleza operativa (no clínica).

**Tipos de notificación**:
- Sesión programada mañana
- Pago pendiente
- Nueva tarea disponible
- Documento por firmar
- Recordatorio de renovación de membresía
- Cambio en horario de atención

Todo configurable por tipo y frecuencia.

**Integraciones**:
- Communication Center → canales de envío
- BCMS → Notification Center clínico (separado por dominio)
- Billing & Subscription Engine → alertas de pago
- BCGS → preferencias del usuario

---

### 4.13. Inventory Manager

**Propósito**: Para clínicas, controlar pruebas físicas, manuales, materiales, consumibles y dispositivos.

**Funciones**:
- Registro de inventario con stock mínimo
- Alertas de reabastecimiento
- Historial de movimientos (entradas, salidas, Transferencias)
- Asignación de material a terapeutas o salas
- Depreciación de activos
- Inventario por sucursal (Multi-Branch)

**Integraciones**:
- Resource Management Engine → inventario consolidado
- Financial Operations Engine → costos de inventario
- Multi-Branch Manager → inventario por sede
- BCOE → Compliance Operations para auditorías de inventario

---

### 4.14. Operational Analytics

**Propósito**: Dashboard de operación con KPIs del negocio.

**Ejemplo**:
```
Hoy
  ├── Ocupación: 92%
  ├── Consultorios disponibles: 3
  ├── Ingresos mensuales: $420,000
  └── Pacientes activos: 381
```

**Indicadores operativos**:
- Ocupación de consultorios
- Utilización de salas virtuales
- Ingresos por período
- Pacientes nuevos vs. dados de baja
- Cancelaciones y ausencias
- Tiempos de espera
- Proyecciones de capacidad

> Todos estos indicadores son **operativos y financieros**. Nunca contienen información clínica.

**Integraciones**:
- Todos los submotores del BCOE como fuentes de datos
- BCIE → métricas de carga clínica para contexto operativo
- BARS → reportes ejecutivos consolidados
- Multi-Branch Manager → consolidación multi-sede

---

### 4.15. Multi-Branch Manager

**Propósito**: Administrar múltiples sedes desde una sola plataforma.

**Ejemplo**:
```
Ciudad de México
Querétaro
Guadalajara
Monterrey
```

Con indicadores independientes y consolidados.

**Funciones**:
- Vista consolidada de todas las sedes
- Indicadores por sede y consolidados
- Transferencia de pacientes entre sedes
- Distribución de recursos entre sedes
- Configuración independiente por sede
- Reportes comparativos entre sedes

**Integraciones**:
- Clinic Administration Engine → estructura organizacional
- Operational Analytics → métricas por sede
- Staff Management → personal por sede
- Resource Management → recursos por sede
- BCGS → políticas institucionales globales

---

### 4.16. Compliance Operations

**Propósito**: Verificar el cumplimiento de políticas, consentimientos, contratos y procesos administrativos.

**Funciones**:
- Verificación de consentimientos vigentes
- Auditoría de políticas internas
- Control de contratos activos
- Retención documental según normativa
- Preparación de auditorías regulatorias
- Alertas por documentos vencidos o por vencer

> Nunca sustituye la revisión legal.

**Integraciones**:
- BCGS → políticas, consentimientos y normativas
- Document Management Engine → documentos administrativos
- Audit Manager → trazabilidad de acciones
- Compliance de BCGS → LFPDPPP, GDPR, HIPAA, NOM

---

### 4.17. Automation Engine (Operativo)

**Propósito**: Automatizar procesos del negocio.

**Ejemplo**:
```
Pago confirmado
  → Emitir factura
  → Enviar correo
  → Actualizar expediente administrativo
  → Registrar ingreso
```

```
Paciente nuevo
  → BCI
  → Agenda
  → Recordatorios
  → Seguimiento
```

Todo mediante reglas configurables.

**Funciones**:
- Editor de reglas (trigger → condición → acción)
- Workflows predefinidos para escenarios comunes
- Integración con el Automation Engine del BCMS
- Ejecución asíncrona con manejo de errores
- Historial de ejecuciones

**Integraciones**:
- Automation Engine del BCMS → coordinación clínico-operativa
- Communication Center → envío de notificaciones
- Document Management Engine → generación de documentos
- Billing & Subscription Engine → eventos de facturación
- Operational Workflow Engine → flujos operativos

---

### 4.18. Organization Settings

**Propósito**: Configurar toda la organización.

**Parámetros configurables**:
- Horarios de atención
- Días festivos
- Zonas horarias
- Idiomas soportados
- Moneda
- Impuestos
- Políticas internas
- Configuración de notificaciones
- Plantillas de comunicación
- Parámetros de facturación

**Integraciones**:
- Clinic Administration Engine → configuración por unidad
- BCGS → políticas globales
- Financial Operations Engine → parámetros fiscales
- Communication Center → configuración de canales

---

## 5. Dashboard Operativo

```
Hoy
────────────────────────────
Sesiones:              42
Consultorios:          18/20
Pagos pendientes:       7
Recordatorios enviados: 108
Pacientes nuevos:       5
Facturas emitidas:      17
────────────────────────────
```

---

## 6. Integración con el Ecosistema

| Motor | Integra con BCOE para... |
|-------|--------------------------|
| BCMS | Crear expedientes y sincronizar agenda administrativa **sin acceder al razonamiento clínico** |
| BCIE | Utilizar información de continuidad y carga de trabajo para distribuir recursos |
| BSI, BASP | Coordinar programación de sesiones con disponibilidad operativa |
| BCGS | Asegurar cumplimiento de políticas, consentimientos y procesos administrativos |
| Billing & Subscription Engine | Administrar suscripciones, programas y licencias comerciales |
| BMP (Marketplace) | Gestionar compra y licenciamiento de programas y recursos |
| BLES (Licensing Ecosystem) | Controlar licencias para psicólogos, clínicas y hospitales |
| BDIS (Developer Integration) | Integraciones con calendarios, pasarelas de pago y servicios externos |

---

## 7. Métricas de Éxito

| Métrica | Objetivo |
|---------|----------|
| Ocupación de consultorios | > 85% en horario pico |
| Tiempo de onboarding de paciente nuevo | < 10 minutos |
| Tasa de facturación exitosa | > 98% |
| Reducción de tareas administrativas manuales | > 60% |
| Satisfacción administrativa (NPS) | > 40 |
| Tiempo de respuesta del dashboard operativo | < 1 segundo |
| Cumplimiento de consentimientos vigentes | 100% |
