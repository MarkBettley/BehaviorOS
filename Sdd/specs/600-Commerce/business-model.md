---
id: BCE-001
title: Behavioral Commerce Engine (BCE)
version: 2.0.0
status: Stable
owner: Comercio & Arquitectura Financiera
last_updated: 2026-07-14
depends_on:
  - 100-Architecture/system-architecture.md (BEA - capa de negocio)
  - 200-Backend/api-graph.md (API Graph - endpoints comerciales)
  - 900-Security/security.md (Seguridad - datos financieros, RBAC)
exports:
  - Modelo de negocio multicapa (3 verticales, 4 formas de venta)
  - Sistema de suscripciones (planes, ciclos, renovaciones)
  - Procesamiento de pagos (Stripe, Mercado Pago)
  - Facturación CFDI 4.0 (Facturapi, PAC, SAT)
  - Marketplace de productos digitales
  - Sistema de cupones y promociones
  - Inteligencia comercial (KPIs, MRR, ARR, LTV, churn)
  - Niveles de acompañamiento (4 niveles)
  - Modelo de comisión
  - Integración con el ecosistema
used_by:
  - Patient App (compras y suscripciones)
  - Therapist App (gestión financiera, planes, facturación)
  - BPOS (asociación de pagos a servicios)
  - BIP (analítica comercial)
  - Admin Dashboard (gestión de la plataforma)
  - LIC (licencias y acceso)
---

# BehavioralOS – Behavioral Commerce Engine (BCE)

> *"No estás construyendo un 'agenda + videollamada'. Estás construyendo un ecosistema completo: IA local especializada en psicoterapia, gamificación terapéutica, telemetría conductual, analítica idiográfica, marketplace, facturación SAT, formación y más. Eso cambia completamente el posicionamiento."*

---

## 1. Propósito y Alcance

### 1.1. Propósito
Este documento define el **Behavioral Commerce Engine (BCE)**, el motor comercial completo del BehavioralOS. Su modelo de negocio se estructura en **3 verticales** con necesidades diferentes, **4 formas de vender el mismo ecosistema**, y **4 niveles de acompañamiento** que eliminan la dicotomía "app vs. terapia".

- **Verticales**: Pacientes (B2C), Psicólogos (SaaS B2B), Clínicas/Instituciones (Enterprise) + Estudiantes/Universidades.
- **Formas de venta**: App (solo tecnología), Tratamiento (sesiones + app), Programa (ruta estructurada 8-16 semanas), Mantenimiento (post-alta).
- **Acompañamiento**: Autoguiado → Acompañado → Programa Intensivo → Mantenimiento.

### 1.2. Alcance
El documento cubre:

- **Modelo de negocio completo**: 3 verticales, 4 formas de venta, 4 niveles de acompañamiento, modelo de comisión.
- **Sistema de suscripciones**: Planes por vertical, ciclos de facturación, renovaciones, cancelaciones, pausas.
- **Procesamiento de pagos**: Integración con Stripe y Mercado Pago, webhooks, idempotencia, manejo de fallos, reembolsos.
- **Facturación CFDI 4.0**: Generación de facturas, timbrado vía Facturapi, validación fiscal.
- **Marketplace**: Catálogo de productos digitales, comisiones (5% productos digitales, 0% terapia).
- **Cupones y promociones**: Creación, reglas de aplicación, seguimiento.
- **Inteligencia comercial**: KPIs (MRR, ARR, LTV, churn), dashboards por vertical.
- **Créditos IA**: Bolsa mensual por plan (10k-600k créditos).
- **Modelo de licenciamiento**: Dos modelos para el paciente (incluido vs. compartido).

### 1.3. Principio Fundamental
> **"La suscripción del paciente no debería ser obligatoria para recibir terapia. El psicólogo decide entre: (1) Modelo incluido — paga su suscripción y asigna licencias de la app a sus pacientes sin costo adicional, o (2) Modelo compartido — el paciente contrata directamente su suscripción. Esto hace que el ecosistema sea atractivo tanto para psicólogos independientes como para clínicas."**

---

## 2. Filosofía del Comercio Ético

### 2.1. Principios de Comercio

| # | Principio | Descripción |
|---|-----------|-------------|
| 1 | **Transparencia total** | Todos los costos y condiciones son claros y visibles. Sin dark patterns. |
| 2 | **Cancelación sin fricción** | Cancelar una suscripción debe ser tan fácil como contratarla. |
| 3 | **Sin manipulación** | No se utilizan tácticas de presión o culpa para retener. |
| 4 | **Facturación clara** | Cada cargo está justificado. Facturación SAT incluida sin costo. |
| 5 | **Privacidad financiera** | No se almacenan datos de tarjeta. Uso de Stripe Elements / Mercado Pago Checkout. |
| 6 | **Flexibilidad** | Cambiar de plan, pausar o congelar sin penalización. |
| 7 | **0% comisión en terapia** | La plataforma NO cobra comisión por sesiones de terapia. Diferenciador clave. |

### 2.2. Posicionamiento Competitivo

No se compite contra plataformas de videollamadas para psicólogos. Se compite contra un híbrido de:

| Categoría | Referencia | Elemento que se toma |
|-----------|-----------|---------------------|
| Practice Management | SimplePractice, TherapyNotes, Jane App | CRM, agenda, facturación, historia clínica |
| E-commerce | Shopify | Marketplace, productos, cupones, pagos |
| CRM / Automatización | HubSpot | Automatizaciones, pipeline, métricas |
| Documentación | Notion | Organización de conocimiento |
| Gamificación / Educación | Duolingo, Nintendo | Experiencia de usuario, gamificación, engagement |

**Todo integrado en un solo ecosistema.**

---

## 3. Modelo de Negocio — 3 Verticales

### 3.1. Vertical I: Suscripciones para Pacientes

> *"No vendería 'la terapia'. La terapia la cobra el psicólogo. Tú vendes la plataforma."*

#### 3.1.1. Planes de Suscripción

| ID | Plan | Precio (MXN/mes) | Usuarios | Descripción |
|----|------|------------------|----------|-------------|
| `pat_individual` | Behavioral Individual | $149 | 1 | App Nintendo, ejercicios diarios, gamificación, registro emocional, diario, IA coterapeuta, tareas, recordatorios, seguimiento, reportes para el terapeuta, minijuegos, biblioteca. **No incluye sesiones.** |
| `pat_couple` | Behavioral Couple | $249 | 2 | Todo Individual + dos usuarios, juegos cooperativos, ejercicios Gottman, TIP, dashboard relacional, metas compartidas, estadísticas de pareja. |
| `pat_family` | Behavioral Family | $399 | hasta 6 | Todo Couple + ecosistema familiar, juegos familiares, telemetría grupal, valores familiares, objetivos comunes. |
| `pat_neuro` | Behavioral Neuro | $299 | 1 | Evaluaciones frecuentes, juegos cognitivos, telemetría, seguimiento ejecutivo (memoria, atención, velocidad de procesamiento, flexibilidad), dashboard cognitivo. |

#### 3.1.2. Productos de Cobro Adicional (Marketplace)

| Producto | Precio | Comisión de plataforma |
|----------|--------|----------------------|
| Functional Behavioral Report | $800–$1,500 MXN | 5% |
| Evaluación neuropsicológica | $2,500–$7,000 MXN | 5% |
| Cursos, ebooks, manuales, plantillas | Variable | 5% |
| Sesiones adicionales | Variable | 0% |

#### 3.1.3. Modalidades de Pago

Cada plan está disponible en múltiples duraciones:

| Modalidad | Descuento |
|-----------|-----------|
| Semanal | Precio base |
| Mensual | Precio base |
| Bimestral | ~5% descuento |
| Semestral | ~10% descuento |
| Anual | ~20% descuento |

#### 3.1.4. Niveles de Acompañamiento

El paciente no elige entre "app" o "terapia"; elige el **grado de acompañamiento** que necesita:

| Nivel | Nombre | Incluye | Precio sugerido |
|-------|--------|---------|----------------|
| **1** | Autoguiado | Solo app (ejercicios, IA, gamificación, seguimiento, diario, biblioteca, reportes personales) | Plan de suscripción base |
| **2** | Acompañado | App + terapeuta (sesiones, retroalimentación personalizada, revisión de tareas, ajuste de ejercicios, dashboard compartido) | Suscripción + sesiones del terapeuta |
| **3** | Programa Intensivo | Ruta terapéutica estructurada (objetivos clínicos, ejercicios personalizados, IA, sesiones, evaluación inicial/final, reportes) | Programa de tratamiento ($10,000–$15,000) |
| **4** | Mantenimiento | Post-alta: ejercicios, IA, seguimiento, check-in semanal, prevención de recaídas, biblioteca, estadísticas. Sin sesiones. | $299–$499/mes |

### 3.2. Vertical II: Psicólogos (SaaS)

> *"Aquí está el verdadero negocio. No cobraría comisión por terapia. Cobraría SaaS."*

#### 3.2.1. Planes para Profesionales

| ID | Plan | Precio (MXN/mes) | Créditos IA/mes | Descripción |
|----|------|------------------|-----------------|-------------|
| `pro_professional` | Behavioral Professional | $999 | 100,000 | Pacientes ilimitados, agenda, historia clínica, expedientes, videoterapia, CRM, automatizaciones, dashboard, IA, ejercicios, app pacientes, marketplace, pagos, facturación SAT, reportes, análisis funcional. **Todo.** |
| `pro_plus` | Behavioral Professional Plus | $1,699 | 250,000 | Todo Professional + neuropsicología, terapia de pareja, terapia familiar, dashboards avanzados, investigación, analítica, API, marca personalizada, dominio propio. |
| `pro_expert` | Behavioral Expert | $2,999 | 600,000 | Todo Plus + white label parcial, múltiples terapeutas, supervisor, entrenamiento, Meet Copilot, IA avanzada, investigaciones, exportaciones. |

#### 3.2.2. Créditos IA por Plan

| Plan | Créditos IA/mes | Nota |
|------|-----------------|------|
| Paciente (cualquier plan) | 10,000 | Para servicios cloud opcionales (sincronización, procesamiento avanzado, notificaciones) |
| Professional | 100,000 | |
| Professional Plus | 250,000 | |
| Expert | 600,000 | |

> La IA principal es local (Gemma on-device). Los créditos cubren servicios en la nube opcionales, manteniendo bajos los costos operativos.

#### 3.2.3. Funcionalidades del Marketplace para Psicólogos

Cada psicólogo decide:
- **Precio** de sus productos y servicios
- **Promociones** y paquetes
- **Cupones** y membresías
- **Meses sin intereses**
- **Descuentos**: estudiante, adulto mayor, por referidos
- **Modelo incluido vs. compartido** (asigna licencias de app a pacientes o让他们 compren directamente)

> Como Shopify. Cada profesional define sus productos, servicios y precios.

### 3.3. Vertical III: Clínicas e Instituciones

> *"No cobraría por clínica. Cobraría por usuarios."*

#### 3.3.1. Planes para Clínicas

| ID | Plan | Terapeutas | Precio (MXN/mes) | Descripción |
|----|------|-----------|------------------|-------------|
| `clinic_starter` | Clinic Starter | hasta 5 | $5,999 | Gestión básica multi-terapeuta |
| `clinic_growth` | Clinic Growth | hasta 20 | $17,999 | Dashboards consolidados, supervisión |
| `clinic_enterprise` | Clinic Enterprise | 50+ | desde $39,999 | Cotización personalizada |
| `clinic_hospital` | Enterprise Hospital | Ilimitado | Contrato | Enterprise con SLA, integración hospitalaria |

#### 3.3.2. Estudiantes y Universidades

| ID | Plan | Precio (MXN/mes) | Descripción |
|----|------|------------------|-------------|
| `edu_student` | Student | $199 | Casos clínicos, simuladores, IA, gamificación, OSATS, microcertificados |
| `edu_professor` | Profesores | $699 | Herramientas de enseñanza, gestión de cursos |
| `edu_university` | Universidad | Licenciamiento | Contrato institucional, acceso masivo |

### 3.4. Ingresos Estimados (Referencia)

Si en unos años se alcanza:

| Segmento | Usuarios | Ingreso mensual aprox. |
|----------|----------|----------------------|
| Pacientes individuales | 2,000 | ~$298,000 MXN |
| Parejas | 600 | ~$149,000 MXN |
| Familias | 300 | ~$120,000 MXN |
| Psicólogos Professional | 700 | ~$699,000 MXN |
| Professional Plus | 200 | ~$339,800 MXN |
| Expert | 40 | ~$119,960 MXN |
| Clínicas | 30 | ~$179,970 MXN |
| **Total aproximado** | | **~$1.9 millones MXN/mes** |

> Sin considerar ingresos por reportes, evaluaciones neuropsicológicas, marketplace, formación, certificaciones o licencias universitarias.

---

## 4. 4 Formas de Vender el Mismo Ecosistema

| # | Forma | Qué es | Incluye |
|---|-------|--------|---------|
| 1 | **App** | Solo tecnología | App + IA + ejercicios + gamificación + seguimiento + biblioteca |
| 2 | **Tratamiento** | Sesiones + app | App + sesiones con terapeuta + retroalimentación + revisión de tareas |
| 3 | **Programa** | Ruta estructurada 8-16 semanas | App + sesiones + ejercicios personalizados + evaluación + reportes |
| 4 | **Mantenimiento** | Post-alta | App + IA + seguimiento + prevención de recaídas (sin sesiones) |

### 4.1. Flujo Comercial del Paciente

```
1. Descarga la app → $149/mes (autoguiado)
         ↓
2. Decide iniciar terapia → contrata un programa de tratamiento
         ↓
3. Finaliza el programa → pasa a la membresía de mantenimiento ($299-499/mes)
         ↓
4. Si necesita una nueva intervención → vuelve a contratar un programa
```

> Es un ciclo continuo, no una relación que termina cuando concluyen las sesiones.

---

## 5. Modelo de Comisión

| Escenario | Comisión de la plataforma | Nota |
|-----------|--------------------------|------|
| **Productos digitales** (cursos, ebooks, manuales, plantillas) | **5%** | Sobre precio de venta |
| **Terapia** (sesiones) | **0%** | Diferenciador clave — la plataforma NO interviene en el precio de sesiones |
| **Facturación SAT** | **Incluida sin costo** | CFDI 4.0 incluido en la suscripción del psicólogo |
| **Créditos IA** | Incluidos por plan | Exceso: pago por consumo |

---

## 6. Sistema de Suscripciones

### 6.1. Ciclo de Vida de una Suscripción

```
[Prospecto] → [Prueba gratuita] → [Activa] → [Renovación] → [Activa]
     ↓              ↓                ↓              ↓
 [Carrito]   [Pago pendiente]  [Cancelación]  [Pago fallido]
     ↓              ↓                ↓              ↓
  [Pago]     [Pago exitoso]   [Período de    [Período de gracia]
(activación)         ↓         gracia]           ↓
     ↓         [Cancelada]         ↓        [Cancelada]
[Cancelada]                     [Expirada]
```

### 6.2. Estados de Suscripción

| Estado | Descripción | Acción del sistema |
|--------|-------------|-------------------|
| `draft` | Carrito de compra iniciado pero no pagado. | Permite modificar el plan. |
| `pending_payment` | Pago iniciado pero no confirmado. | Espera confirmación de Stripe/Mercado Pago. |
| `active` | Suscripción activa y con acceso completo. | Otorga acceso a todos los servicios. |
| `trialing` | Período de prueba gratuito (opcional). | Acceso limitado o completo. |
| `past_due` | Pago fallido, período de gracia (3-7 días). | Acceso limitado; recordatorio diario. |
| `canceled` | Cancelada por el usuario o la plataforma. | Acceso suspendido al final del período. |
| `expired` | Suscripción expirada. | Acceso suspendido. |
| `paused` | Suscripción pausada. | Acceso suspendido temporalmente; historial conservado. |
| `suspended` | **Suspensión administrativa** (violación de términos, etc.). | Acceso inmediato. Requiere revisión manual. |

### 6.3. Renovaciones y Notificaciones

| Evento | Acción del sistema | Canal |
|--------|-------------------|-------|
| 7 días antes de la renovación | Recordatorio de renovación. | Correo, push |
| 24 horas antes de la renovación | Recordatorio final. | Correo, push |
| Pago exitoso (renovación) | Confirmación y factura. | Correo, push |
| Pago fallido (renovación) | Alerta + ofrecer actualizar método de pago. | Correo, push, IA |
| Período de gracia (3 días) | Recordatorio diario. | Correo, push |
| Cancelación por usuario | Confirmar cancelación y ofrecer feedback. | Correo, IA |

### 6.4. Cambios de Plan

| Acción | Regla | Resultado |
|--------|-------|-----------|
| **Upgrade** | Diferencia prorrateada. | Acceso inmediato al nuevo plan. |
| **Downgrade** | Se aplica al final del ciclo actual. | Acceso al plan actual hasta renovación. |
| **Pausa** | Se suspende el acceso; se conserva el historial. | Reactivación en cualquier momento. |
| **Cancelación** | Se cancela al final del ciclo. | Acceso hasta la fecha de finalización. |

---

## 7. Procesamiento de Pagos

### 7.1. Proveedores de Pago

| Proveedor | Alcance | Costo | Integración |
|-----------|---------|-------|-------------|
| **Stripe** | Internacional (tarjetas, Apple Pay, Google Pay) | 2.9% + $0.30 USD por transacción | Stripe Connect |
| **Mercado Pago** | México y Latam (tarjetas, efectivo, SPEI) | 3.5% + IVA por transacción | Checkout + Webhooks |

### 7.2. Flujo de Pago

1. El paciente/terapeuta selecciona un plan.
2. El BCE genera un checkout session (Stripe) o preferencia de pago (Mercado Pago).
3. El usuario es redirigido al entorno de pago del proveedor.
4. El usuario completa el pago.
5. El proveedor envía un webhook al BCE (`payment.succeeded`).
6. El BCE procesa el webhook: verifica firma, valida idempotencia, crea la suscripción.
7. El BCE activa la suscripción y actualiza el estado.
8. El BCE envía confirmación (correo, push, IA).
9. El BCE genera la factura CFDI (si aplica en México).

### 7.3. Idempotencia y Manejo de Duplicados

- Cada transacción tiene un `idempotency_key` (UUID v7).
- Tabla de idempotencia (`idempotency_keys`) registra todas las claves procesadas.
- Webhooks duplicados retornan éxito sin procesar nuevamente.
- Reintentos con backoff exponencial (hasta 5 intentos).

### 7.4. Manejo de Fallos de Pago

| Escenario | Acción |
|-----------|--------|
| Pago rechazado | Suscripción → `past_due`. Notificación + ofrecer actualizar método de pago. |
| Tarjeta expirada | Notificación automática. |
| Cobro fallido tras reintentos | Suscripción → `canceled` después de 3 intentos. |
| Reembolso | Se procesa a través de Stripe/Mercado Pago. Se ajusta el estado. |

### 7.5. Webhooks

| Evento | Acción |
|--------|--------|
| `payment_intent.succeeded` | Activar suscripción, generar factura, notificar. |
| `payment_intent.payment_failed` | → `past_due`, notificar. |
| `invoice.paid` | Registrar pago recurrente. |
| `invoice.payment_failed` | → `past_due`, notificar. |
| `customer.subscription.deleted` | Cancelar suscripción en el sistema. |
| `charge.refunded` | Registrar reembolso, ajustar factura. |

---

## 8. Facturación CFDI 4.0

### 8.1. Requisitos Fiscales (México)

- **CFDI 4.0**: Comprobante Fiscal Digital por Internet, versión 4.0.
- **PAC**: Proveedor Autorizado de Certificación (Finkok, EdiFactMx).
- **Facturapi**: Servicio de facturación integrado con múltiples PACs.
- **Requisitos del cliente**: RFC, régimen fiscal, uso de CFDI (G03 – Gastos en general).

### 8.2. Flujo de Facturación

1. El paciente completa el pago.
2. El BCE recibe el webhook de pago exitoso.
3. El BCE recopila los datos fiscales del paciente.
4. El BCE envía solicitud de facturación a Facturapi.
5. Facturapi genera el CFDI, lo timbra a través del PAC.
6. El BCE almacena XML y PDF en Supabase Storage.
7. El BCE envía la factura al paciente.
8. El paciente puede descargarla desde su perfil.

### 8.3. Facturación Incluida

> La facturación SAT está **incluida sin costo** en el plan Professional del psicólogo. Esto es un diferenciador clave frente a la competencia.

---

## 9. Marketplace

### 9.1. Tipos de Productos

| Categoría | Ejemplos | Propietario |
|-----------|---------|-------------|
| Cursos | "Introducción a ACT", "Mindfulness" | Terapeutas, creadores |
| Protocolos | "Protocolo de exposición para ansiedad social" | Terapeutas |
| Minijuegos | Ejercicios gamificados adicionales | BehavioralOS, terceros |
| Plantillas | Notas SOAP/DAP, informes FBR | Terapeutas |
| Supervisión | Sesiones de supervisión clínica | Supervisores |
| Meditaciones | Audios de meditación guiada | Terapeutas, creadores |
| Artículos | Publicaciones científicas | Investigadores |
| Dictámenes | Dictamen psicológico | Psicólogos |
| FBR | Functional Behavioral Report | Psicólogos |
| Evaluaciones | Evaluación neuropsicológica, para escuelas/empresas | Neuropsicólogos |
| Sesiones extra | Sesión adicional, sesión de urgencia | Terapeutas |
| Talleres | Talleres presenciales/virtuales | Terapeutas |
| Certificados | Certificaciones de especialización | BehavioralOS |

### 9.2. Comisiones

| Escenario | Comisión de plataforma |
|-----------|----------------------|
| Producto de BehavioralOS | 100% (plataforma) |
| Producto de terapeuta/creador | **5%** |
| Curso con videollamada (supervisión) | 5% |
| **Sesiones de terapia** | **0%** |

### 9.3. Compras Únicas vs. Suscripciones

El marketplace permite compras únicas sin cambiar de plan:
- Dictamen psicológico
- FBR
- Evaluaciones
- Sesión adicional / urgencia
- Talleres, cursos, material descargable
- Programas especializados
- Segundas opiniones, interconsultas

---

## 10. Inteligencia Comercial (KPIs)

### 10.1. KPIs por Vertical

| KPI | Pacientes | Psicólogos | Clínicas |
|-----|-----------|-----------|----------|
| MRR (Monthly Recurring Revenue) | Suscripciones activas | SaaS recurrente | Enterprise recurrente |
| ARR | MRR × 12 | MRR × 12 | MRR × 12 |
| Churn Rate | Cancelaciones / activas | Cancelaciones / activas | Cancelaciones / activas |
| LTV | Ingreso promedio × duración | Ingreso promedio × duración | Ingreso promedio × duración |
| Retención | % que permanece después de 3 meses | % que permanece después de 3 meses | % que permanece después de 3 meses |
| Créditos IA consumidos | Para optimizar costos cloud | Para optimizar costos cloud | Para optimizar costos cloud |

### 10.2. Dashboards

- **Patient Dashboard**: Progreso clínico, suscripción, facturas, ejercicios.
- **Therapist Dashboard**: MRR, ARR, churn, retención, ingresos del marketplace, pacientes asignados.
- **Clinic Dashboard**: Terapeutas activos, pacientes totales, ingresos consolidados, supervisión.
- **Admin Dashboard**: MRR total, usuarios por vertical, revenue del marketplace, comisiones.

---

## 11. Integración con el Ecosistema

| Módulo | Integración |
|--------|-------------|
| **BPOS** (Práctica Clínica) | Asociar pagos a sesiones. Verificar suscripción activa al agendar. |
| **BCMS** (Gestión Clínica) | Planes de tratamiento vinculados a programas de pago. |
| **BCOE** (Consentimientos) | Consentimiento informado para datos financieros. |
| **Patient App** | Gestión de suscripción, historial de pagos, facturas, portal. |
| **Therapist App** | Ingresos, suscripciones de pacientes, marketplace, cupones, facturación. |
| **BIP** (Analítica) | Datos de ingresos y transacciones para análisis avanzado. |
| **LIC** (Licencias) | Verificación de acceso, asignación de licencias, suspensión/revocación. |
| **TCCN** (IA) | Notificaciones de renovación, pagos, promociones (con consentimiento). |

---

## 12. Criterios de Validación

| Criterio | Métrica | Verificación |
|----------|---------|-------------|
| Idempotencia | 0% cobros duplicados | Pruebas de integración |
| Tiempo de procesamiento | < 5s desde webhook hasta activación | Monitoreo de rendimiento |
| Facturación CFDI | 100% facturas con timbre válido | Validación XML contra SAT |
| Cancelación | < 2 minutos (sin fricción) | Pruebas de usabilidad |
| Transparencia | 100% términos visibles antes de compra | Auditoría de UX |
| Satisfacción | ≥ 4.5/5 | Encuestas in-app |
| Retención | ≥ 80% después de 3 meses | Analítica de uso |
| 0% comisión en terapia | Verificación de que no se cobra comisión por sesiones | Auditoría de transacciones |
| Facturación SAT sin costo | Verificación de que Professional no factura extra | Auditoría de billing |

---

## 13. El Manifiesto del Comercio Ético

> *"El comercio no es un mal necesario. Es el motor que permite que la ciencia del comportamiento llegue a más personas.*
>
> *Un sistema comercial ético, transparente y eficiente es la base de una plataforma sostenible.*
>
> *No utilizamos tácticas de manipulación. No ocultamos costos. No dificultamos las cancelaciones.*
>
> *La suscripción del paciente no es obligatoria para recibir terapia. El psicólogo decide cómo quiere trabajar.*
>
> *Cero comisión en terapia. Facturación SAT incluida. Marketplace abierto.*
>
> *El BCE no solo gestiona pagos; construye confianza."*

---

## 14. Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2026-07-01 | Arquitectura Comercial | Creación inicial. BCE v1: suscripciones, pagos, facturación, marketplace, cupones, KPIs. |
| **2.0.0** | **2026-07-14** | **Arquitectura Comercial** | **Reestructuración completa del modelo de negocio: 3 verticales (Pacientes, Psicólogos, Clínicas + Estudiantes), 4 formas de venta (App, Tratamiento, Programa, Mantenimiento), 4 niveles de acompañamiento, modelo de comisión (5% marketplace, 0% terapia, facturación SAT incluida), créditos IA por plan, modelo dual de licenciamiento (incluido vs. compartido), ingresos estimados, posicionamiento competitivo (híbrido SimplePractice + Shopify + Duolingo + Nintendo).** |
