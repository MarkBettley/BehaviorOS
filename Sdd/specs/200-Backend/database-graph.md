---
id: DB-001
title: Database Graph – Esquemas, Tablas y Migraciones
version: 1.1.0
status: Stable
owner: Backend & Arquitectura de Datos
last_updated: 2026-08-12
depends_on:
  - 000-Core/ontology.md (Ontología)
  - 100-Architecture/data-model.md (Modelo de Datos)
  - 200-Backend/api-graph.md (API Graph)
exports:
  - Esquemas completos de la base de datos (tablas, campos, tipos)
  - Relaciones y claves foráneas
  - Índices recomendados para rendimiento
  - Políticas RLS (Row Level Security) por tabla y rol
  - Estrategia de migraciones (Alembic)
  - Ejemplos de consultas optimizadas
used_by:
  - Backend (FastAPI, SQLAlchemy)
  - BQAS (Pruebas de integridad y rendimiento)
  - CI/CD (Migraciones automáticas)
---

# BehavioralOS – Database Graph

> *"Una base de datos no es un simple almacén de datos. Es la memoria organizada del sistema. Cada tabla, cada índice, cada política RLS es una decisión arquitectónica que afecta el rendimiento, la seguridad y la evolución del BehavioralOS."*

---

## 1. Propósito y Alcance

### 1.1. Propósito
Este documento define la **implementación física** del modelo de datos del BehavioralOS en PostgreSQL (con Supabase). Su objetivo es:

- **Especificar tablas, campos, tipos y restricciones** para cada dominio (auth, clinical, commerce, practice, analytics, audit, etc.).
- **Definir relaciones** (claves primarias, foráneas) y garantizar la integridad referencial.
- **Establecer índices** para optimizar consultas frecuentes (por tenant, paciente, fechas, etc.).
- **Implementar políticas RLS** (Row Level Security) para aislar tenants y roles.
- **Proveer una estrategia de migraciones** (Alembic) para versionar el esquema.
- **Incluir ejemplos de consultas** optimizadas para casos de uso comunes.

### 1.2. Alcance
El Database Graph cubre:

- **Esquemas** (namespaces) para separar dominios lógicos.
- **Tablas** con campos, tipos (PostgreSQL), restricciones (NOT NULL, UNIQUE, CHECK).
- **Relaciones** (claves primarias y foráneas) con acciones ON DELETE/ON UPDATE.
- **Índices** (B-tree, GIN, BRIN, etc.) para acelerar consultas.
- **Políticas RLS** que aplican automáticamente el multi-tenant y los roles.
- **Estrategia de migraciones** (Alembic) con versionado semántico.
- **Particionado** (para tablas grandes como logs y telemetría).

### 1.3. Principio Fundamental
> **"La base de datos es el corazón del BehavioralOS. Un diseño descuidado provoca lentitud, inconsistencias y problemas de seguridad. Cada tabla debe tener un propósito claro, cada índice una justificación de rendimiento, y cada política RLS una razón de seguridad."**

---

## 2. Tecnologías y Herramientas

| Componente | Tecnología | Propósito |
|------------|------------|-----------|
| **Base de datos** | PostgreSQL 16+ | Motor relacional principal. |
| **Extensión vectorial** | pgvector | Almacenar y consultar embeddings para RAG. |
| **Series temporales** | TimescaleDB 2.12+ | Hipertablas para telemetría y trayectorias. |
| **Autenticación** | Supabase Auth (JWT, RLS) | Gestión de usuarios y políticas de seguridad. |
| **Migraciones** | Alembic (SQLAlchemy) | Versionado y aplicación de cambios al esquema. |
| **ORM** | SQLAlchemy 2.0+ | Mapeo objeto-relacional para Python. |
| **Monitoreo** | Supabase Dashboard + Prometheus | Monitoreo de rendimiento y consultas lentas. |

---

## 3. Organización de Esquemas

La base de datos se organiza en **esquemas lógicos** (namespaces) para separar dominios y facilitar la administración de permisos.

┌─────────────────────────────────────────────────────────────────────────┐
│ PostgreSQL (Supabase) │
├─────────────────────────────────────────────────────────────────────────┤
│ Esquema: auth (autenticación y usuarios) │
│ Esquema: clinical (pacientes, sesiones, evaluaciones, hipótesis) │
│ Esquema: commerce (suscripciones, pagos, facturas, productos, leads, soporte) │
│ Esquema: practice (agenda, videoterapia, mensajes, informes) │
│ Esquema: exercises (ejercicios, telemetría, gamificación) │
│ Esquema: analytics (KPI, trayectorias, predicciones) │
│ Esquema: research (datos anonimizados para investigación) │
│ Esquema: audit (logs de auditoría y acceso) │
│ Esquema: storage (metadatos de archivos) │
└─────────────────────────────────────────────────────────────────────────┘


**Creación de esquemas**:
```sql
CREATE SCHEMA IF NOT EXISTS auth;
CREATE SCHEMA IF NOT EXISTS clinical;
CREATE SCHEMA IF NOT EXISTS commerce;
CREATE SCHEMA IF NOT EXISTS practice;
CREATE SCHEMA IF NOT EXISTS exercises;
CREATE SCHEMA IF NOT EXISTS analytics;
CREATE SCHEMA IF NOT EXISTS research;
CREATE SCHEMA IF NOT EXISTS audit;
CREATE SCHEMA IF NOT EXISTS storage;

4. Tablas por Dominio
4.1. Esquema auth (Autenticación y Usuarios)
Este esquema gestiona todos los usuarios del sistema, sus roles, sesiones y consentimientos.

4.1.1. Tabla users
Campo	Tipo	Restricciones	Descripción
id	UUID	PRIMARY KEY, DEFAULT gen_random_uuid()	Identificador único del usuario.
email	VARCHAR(255)	UNIQUE, NOT NULL	Correo electrónico (login).
password_hash	VARCHAR(255)	NOT NULL	Hash de la contraseña (bcrypt/Argon2).
role	VARCHAR(50)	NOT NULL, CHECK (role IN ('patient', 'therapist', 'admin', 'super_admin', 'researcher', 'billing', 'secretary'))	Rol del usuario.
tenant_id	UUID	NOT NULL, REFERENCES tenants(id)	ID del tenant (organización).
status	VARCHAR(50)	DEFAULT 'active', CHECK (status IN ('active', 'inactive', 'suspended'))	Estado de la cuenta.
last_login	TIMESTAMP	NULL	Última fecha de inicio de sesión.
created_at	TIMESTAMP	DEFAULT NOW()	Fecha de creación.
updated_at	TIMESTAMP	DEFAULT NOW()	Fecha de última actualización.

Índices:

CREATE INDEX idx_users_email ON auth.users (email);
CREATE INDEX idx_users_tenant_id ON auth.users (tenant_id);
CREATE INDEX idx_users_role ON auth.users (role);
CREATE INDEX idx_users_status ON auth.users (status);

4.1.2. Tabla profiles
Campo	Tipo	Restricciones	Descripción
user_id	UUID	PRIMARY KEY, REFERENCES users(id) ON DELETE CASCADE	ID del usuario.
first_name	VARCHAR(100)	NOT NULL	Nombre.
last_name	VARCHAR(100)	NOT NULL	Apellido.
age	INTEGER	NULL	Edad en años.
gender	VARCHAR(50)	NULL	Identidad de género.
timezone	VARCHAR(50)	DEFAULT 'America/Mexico_City'	Zona horaria.
language	VARCHAR(10)	DEFAULT 'es'	Idioma preferido.
phone	VARCHAR(20)	NULL	Número de teléfono.
avatar_url	TEXT	NULL	URL del avatar.
created_at	TIMESTAMP	DEFAULT NOW()	Fecha de creación.
updated_at	TIMESTAMP	DEFAULT NOW()	Fecha de última actualización.
4.1.3. Tabla sessions
Campo	Tipo	Restricciones	Descripción
id	UUID	PRIMARY KEY, DEFAULT gen_random_uuid()	ID de la sesión.
user_id	UUID	NOT NULL, REFERENCES users(id) ON DELETE CASCADE	ID del usuario.
jwt_token	TEXT	NOT NULL	Token JWT (hash).
refresh_token	TEXT	NOT NULL	Refresh token (hash).
expires_at	TIMESTAMP	NOT NULL	Fecha de expiración del JWT.
refresh_expires_at	TIMESTAMP	NOT NULL	Fecha de expiración del refresh token.
ip	INET	NULL	Dirección IP del cliente.
user_agent	TEXT	NULL	User agent del navegador.
device_id	VARCHAR(255)	NULL	Identificador del dispositivo.
is_active	BOOLEAN	DEFAULT TRUE	Si la sesión está activa.
created_at	TIMESTAMP	DEFAULT NOW()	Fecha de creación.
updated_at	TIMESTAMP	DEFAULT NOW()	Fecha de última actualización.

Índices:

CREATE INDEX idx_sessions_user_id ON auth.sessions (user_id);
CREATE INDEX idx_sessions_expires_at ON auth.sessions (expires_at);
CREATE INDEX idx_sessions_refresh_token ON auth.sessions (refresh_token);
CREATE INDEX idx_sessions_is_active ON auth.sessions (is_active);

4.1.4. Tabla consents
Campo	Tipo	Restricciones	Descripción
id	UUID	PRIMARY KEY, DEFAULT gen_random_uuid()	ID del consentimiento.
user_id	UUID	NOT NULL, REFERENCES users(id) ON DELETE CASCADE	ID del usuario.
type	VARCHAR(50)	NOT NULL, CHECK (type IN ('clinical', 'ai', 'research', 'telemetry', 'video', 'camera', 'marketing', 'billing'))	Tipo de consentimiento.
version	VARCHAR(20)	NOT NULL	Versión del documento de consentimiento.
accepted_at	TIMESTAMP	NOT NULL	Fecha de aceptación.
revoked_at	TIMESTAMP	NULL	Fecha de revocación (si aplica).
ip	INET	NULL	Dirección IP desde la que se aceptó.
signature	TEXT	NULL	Firma digital (opcional).
metadata	JSONB	NULL	Metadatos adicionales.

Índices:

CREATE INDEX idx_consents_user_id ON auth.consents (user_id);
CREATE INDEX idx_consents_type ON auth.consents (type);
CREATE INDEX idx_consents_accepted_at ON auth.consents (accepted_at);

4.2. Esquema clinical (Datos Clínicos)
4.2.1. Tabla patients
Campo	Tipo	Restricciones	Descripción
id	UUID	PRIMARY KEY, DEFAULT gen_random_uuid()	ID del paciente.
user_id	UUID	UNIQUE, NOT NULL, REFERENCES auth.users(id) ON DELETE CASCADE	ID del usuario (paciente).
therapist_id	UUID	REFERENCES auth.users(id) ON DELETE SET NULL	ID del terapeuta principal.
tenant_id	UUID	NOT NULL, REFERENCES tenants(id)	ID del tenant.
status	VARCHAR(50)	DEFAULT 'active', CHECK (status IN ('active', 'inactive', 'transferred', 'discharged'))	Estado del paciente.
intake_date	TIMESTAMP	DEFAULT NOW()	Fecha de ingreso.
discharge_date	TIMESTAMP	NULL	Fecha de alta.
medical_history	TEXT	NULL	Resumen de historia médica (texto libre).
referral_source	VARCHAR(255)	NULL	Fuente de derivación.
created_at	TIMESTAMP	DEFAULT NOW()	Fecha de creación.
updated_at	TIMESTAMP	DEFAULT NOW()	Fecha de última actualización.

Índices:

CREATE INDEX idx_patients_user_id ON clinical.patients (user_id);
CREATE INDEX idx_patients_therapist_id ON clinical.patients (therapist_id);
CREATE INDEX idx_patients_tenant_id ON clinical.patients (tenant_id);
CREATE INDEX idx_patients_status ON clinical.patients (status);
CREATE INDEX idx_patients_intake_date ON clinical.patients (intake_date);

4.2.2. Tabla therapists
Campo	Tipo	Restricciones	Descripción
id	UUID	PRIMARY KEY, DEFAULT gen_random_uuid()	ID del terapeuta.
user_id	UUID	UNIQUE, NOT NULL, REFERENCES auth.users(id) ON DELETE CASCADE	ID del usuario (terapeuta).
tenant_id	UUID	NOT NULL, REFERENCES tenants(id)	ID del tenant.
license_number	VARCHAR(50)	NOT NULL	Número de cédula profesional.
specialties	JSONB	NULL	Especialidades (ej. ["ACT", "FAP", "DBT"]).
bio	TEXT	NULL	Biografía.
years_experience	INTEGER	NULL	Años de experiencia.
hourly_rate	DECIMAL(10,2)	NULL	Tarifa por hora (opcional).
created_at	TIMESTAMP	DEFAULT NOW()	Fecha de creación.
updated_at	TIMESTAMP	DEFAULT NOW()	Fecha de última actualización.

Índices:

CREATE INDEX idx_therapists_user_id ON clinical.therapists (user_id);
CREATE INDEX idx_therapists_tenant_id ON clinical.therapists (tenant_id);
CREATE INDEX idx_therapists_license_number ON clinical.therapists (license_number);

4.2.3. Tabla sessions
Campo	Tipo	Restricciones	Descripción
id	UUID	PRIMARY KEY, DEFAULT gen_random_uuid()	ID de la sesión.
patient_id	UUID	NOT NULL, REFERENCES patients(id) ON DELETE CASCADE	ID del paciente.
therapist_id	UUID	NOT NULL, REFERENCES therapists(id) ON DELETE CASCADE	ID del terapeuta.
tenant_id	UUID	NOT NULL, REFERENCES tenants(id)	ID del tenant.
start_time	TIMESTAMP	NOT NULL	Hora de inicio.
end_time	TIMESTAMP	NULL	Hora de fin.
duration	INTEGER	NULL	Duración en minutos.
modality	VARCHAR(50)	NOT NULL, CHECK (modality IN ('presencial', 'online', 'telefono'))	Modalidad de la sesión.
status	VARCHAR(50)	DEFAULT 'scheduled', CHECK (status IN ('scheduled', 'confirmed', 'in_progress', 'completed', 'cancelled', 'no_show'))	Estado de la sesión.
notes_soap	TEXT	NULL	Notas SOAP (texto).
notes_dap	TEXT	NULL	Notas DAP (texto).
signed_at	TIMESTAMP	NULL	Fecha de firma de las notas.
video_url	TEXT	NULL	URL de la videollamada (Google Meet/Zoom).
recording_url	TEXT	NULL	URL de la grabación (si existe).
created_at	TIMESTAMP	DEFAULT NOW()	Fecha de creación.
updated_at	TIMESTAMP	DEFAULT NOW()	Fecha de última actualización.

Índices:

CREATE INDEX idx_sessions_patient_id ON clinical.sessions (patient_id);
CREATE INDEX idx_sessions_therapist_id ON clinical.sessions (therapist_id);
CREATE INDEX idx_sessions_tenant_id ON clinical.sessions (tenant_id);
CREATE INDEX idx_sessions_status ON clinical.sessions (status);
CREATE INDEX idx_sessions_start_time ON clinical.sessions (start_time);
CREATE INDEX idx_sessions_modality ON clinical.sessions (modality);

.2.4. Tabla assessments
Campo	Tipo	Restricciones	Descripción
id	UUID	PRIMARY KEY, DEFAULT gen_random_uuid()	ID de la evaluación.
patient_id	UUID	NOT NULL, REFERENCES patients(id) ON DELETE CASCADE	ID del paciente.
tenant_id	UUID	NOT NULL, REFERENCES tenants(id)	ID del tenant.
type	VARCHAR(50)	NOT NULL, CHECK (type IN ('AAQ-II', 'CompACT', 'VLAQ', 'CFQ', 'MPFI', 'MAAS', 'DERS', 'FIAT', 'FAP-IS', 'EOS', 'TPQ'))	Tipo de evaluación.
score	DECIMAL(10,2)	NULL	Puntuación global (si aplica).
interpretation	JSONB	NULL	Interpretación (ej. niveles de procesos).
confidence	DECIMAL(5,4)	DEFAULT 0.8	Nivel de confianza.
administered_at	TIMESTAMP	NOT NULL	Fecha de administración.
expires_at	TIMESTAMP	NULL	Fecha de expiración (para evaluaciones periódicas).
created_at	TIMESTAMP	DEFAULT NOW()	Fecha de creación.
updated_at	TIMESTAMP	DEFAULT NOW()	Fecha de última actualización.

Índices:

CREATE INDEX idx_assessments_patient_id ON clinical.assessments (patient_id);
CREATE INDEX idx_assessments_tenant_id ON clinical.assessments (tenant_id);
CREATE INDEX idx_assessments_type ON clinical.assessments (type);
CREATE INDEX idx_assessments_administered_at ON clinical.assessments (administered_at);

4.2.5. Tabla assessment_items
Campo	Tipo	Restricciones	Descripción
id	UUID	PRIMARY KEY, DEFAULT gen_random_uuid()	ID del ítem.
assessment_id	UUID	NOT NULL, REFERENCES assessments(id) ON DELETE CASCADE	ID de la evaluación.
item_id	VARCHAR(50)	NOT NULL	Identificador del ítem (ej. "AAQII_01").
response	JSONB	NOT NULL	Respuesta del paciente (puede ser múltiple).
score	DECIMAL(5,2)	NULL	Puntuación del ítem (si aplica).
timestamp	TIMESTAMP	NOT NULL	Momento de la respuesta.
latency	INTEGER	NULL	Tiempo de latencia en milisegundos.
confidence	DECIMAL(5,4)	DEFAULT 0.9	Nivel de confianza.

Índices:

CREATE INDEX idx_assessment_items_assessment_id ON clinical.assessment_items (assessment_id);
CREATE INDEX idx_assessment_items_item_id ON clinical.assessment_items (item_id);

4.2.6. Tabla hypotheses
Campo	Tipo	Restricciones	Descripción
id	UUID	PRIMARY KEY, DEFAULT gen_random_uuid()	ID de la hipótesis.
patient_id	UUID	NOT NULL, REFERENCES patients(id) ON DELETE CASCADE	ID del paciente.
tenant_id	UUID	NOT NULL, REFERENCES tenants(id)	ID del tenant.
description	TEXT	NOT NULL	Descripción de la hipótesis.
antecedents	JSONB	NULL	Antecedentes implicados.
behavior	JSONB	NULL	Conducta objetivo.
consequences	JSONB	NULL	Consecuencias que mantienen la conducta.
processes	JSONB	NULL	Procesos psicológicos implicados.
relational_frames	JSONB	NULL	Marcos relacionales RFT.
confidence	DECIMAL(5,4)	DEFAULT 0.5	Nivel de confianza (0-1).
status	VARCHAR(50)	DEFAULT 'activa', CHECK (status IN ('activa', 'confirmada', 'rechazada', 'en_revision'))	Estado de la hipótesis.
evidence_for	JSONB	NULL	Evidencia a favor.
evidence_against	JSONB	NULL	Evidencia en contra.
predictions	JSONB	NULL	Predicciones verificables.
created_at	TIMESTAMP	DEFAULT NOW()	Fecha de creación.
updated_at	TIMESTAMP	DEFAULT NOW()	Fecha de última actualización.

Índices:

CREATE INDEX idx_hypotheses_patient_id ON clinical.hypotheses (patient_id);
CREATE INDEX idx_hypotheses_tenant_id ON clinical.hypotheses (tenant_id);
CREATE INDEX idx_hypotheses_status ON clinical.hypotheses (status);
CREATE INDEX idx_hypotheses_confidence ON clinical.hypotheses (confidence);

4.2.7. Tabla hypothesis_updates
Campo	Tipo	Restricciones	Descripción
id	UUID	PRIMARY KEY, DEFAULT gen_random_uuid()	ID del registro.
hypothesis_id	UUID	NOT NULL, REFERENCES hypotheses(id) ON DELETE CASCADE	ID de la hipótesis.
new_confidence	DECIMAL(5,4)	NOT NULL	Nueva confianza.
reason	TEXT	NOT NULL	Razón de la actualización.
source	VARCHAR(50)	NOT NULL, CHECK (source IN ('AAO', 'BERL', 'TCCN', 'terapeuta', 'sistema'))	Fuente de la actualización.
timestamp	TIMESTAMP	DEFAULT NOW()	Fecha de la actualización.

Índices:

CREATE INDEX idx_hypothesis_updates_hypothesis_id ON clinical.hypothesis_updates (hypothesis_id);
CREATE INDEX idx_hypothesis_updates_timestamp ON clinical.hypothesis_updates (timestamp);

4.2.8. Tabla values (ACT)
Campo	Tipo	Restricciones	Descripción
id	UUID	PRIMARY KEY, DEFAULT gen_random_uuid()	ID del valor.
patient_id	UUID	NOT NULL, REFERENCES patients(id) ON DELETE CASCADE	ID del paciente.
tenant_id	UUID	NOT NULL, REFERENCES tenants(id)	ID del tenant.
name	VARCHAR(100)	NOT NULL	Nombre del valor.
domain	VARCHAR(50)	NOT NULL, CHECK (domain IN ('trabajo', 'familia', 'pareja', 'amigos', 'salud', 'crecimiento', 'ocio', 'espiritualidad', 'educacion', 'comunidad'))	Dominio del valor.
behaviors	JSONB	NULL	Conductas asociadas al valor.
barriers	JSONB	NULL	Barreras que impiden la conducta valorada.
natural_reinforcers	JSONB	NULL	Reforzadores naturales asociados.
costs	JSONB	NULL	Costos asociados.
coherence	DECIMAL(5,4)	DEFAULT 0.5	Índice de coherencia (0-1).
confidence	DECIMAL(5,4)	DEFAULT 0.7	Nivel de confianza.
created_at	TIMESTAMP	DEFAULT NOW()	Fecha de creación.
updated_at	TIMESTAMP	DEFAULT NOW()	Fecha de última actualización.

Índices:

CREATE INDEX idx_values_patient_id ON clinical.values (patient_id);
CREATE INDEX idx_values_tenant_id ON clinical.values (tenant_id);
CREATE INDEX idx_values_domain ON clinical.values (domain);

4.2.9. Tabla goals
Campo	Tipo	Restricciones	Descripción
id	UUID	PRIMARY KEY, DEFAULT gen_random_uuid()	ID del objetivo.
patient_id	UUID	NOT NULL, REFERENCES patients(id) ON DELETE CASCADE	ID del paciente.
tenant_id	UUID	NOT NULL, REFERENCES tenants(id)	ID del tenant.
description	TEXT	NOT NULL	Descripción del objetivo.
target_behavior	VARCHAR(255)	NOT NULL	Conducta objetivo.
frequency	INTEGER	NULL	Frecuencia objetivo.
unit	VARCHAR(50)	NULL	Unidad de frecuencia (ej. "veces/semana").
progress	DECIMAL(5,4)	DEFAULT 0.0	Progreso actual (0-1).
deadline	DATE	NULL	Fecha límite.
status	VARCHAR(50)	DEFAULT 'activo', CHECK (status IN ('activo', 'completado', 'cancelado'))	Estado del objetivo.
created_at	TIMESTAMP	DEFAULT NOW()	Fecha de creación.
updated_at	TIMESTAMP	DEFAULT NOW()	Fecha de última actualización.

Índices:

CREATE INDEX idx_goals_patient_id ON clinical.goals (patient_id);
CREATE INDEX idx_goals_tenant_id ON clinical.goals (tenant_id);
CREATE INDEX idx_goals_status ON clinical.goals (status);
CREATE INDEX idx_goals_deadline ON clinical.goals (deadline);

4.3. Esquema commerce (Comercio y Pagos)
4.3.1. Tabla tenants
Campo	Tipo	Restricciones	Descripción
id	UUID	PRIMARY KEY, DEFAULT gen_random_uuid()	ID del tenant.
name	VARCHAR(255)	NOT NULL	Nombre de la organización.
slug	VARCHAR(100)	UNIQUE, NOT NULL	Slug para URL (ej. "clinica-abc").
domain	VARCHAR(255)	UNIQUE, NULL	Dominio personalizado (ej. "clinicaabc.com").
logo_url	TEXT	NULL	URL del logo.
branding	JSONB	NULL	Colores, tipografía, etc.
config	JSONB	NULL	Configuración general (feature flags, etc.).
status	VARCHAR(50)	DEFAULT 'active', CHECK (status IN ('active', 'suspended', 'deleted'))	Estado del tenant.
created_at	TIMESTAMP	DEFAULT NOW()	Fecha de creación.
updated_at	TIMESTAMP	DEFAULT NOW()	Fecha de última actualización.
4.3.2. Tabla plans
Campo	Tipo	Restricciones	Descripción
id	UUID	PRIMARY KEY, DEFAULT gen_random_uuid()	ID del plan.
tenant_id	UUID	NOT NULL, REFERENCES tenants(id)	ID del tenant.
name	VARCHAR(100)	NOT NULL	Nombre del plan.
description	TEXT	NULL	Descripción del plan.
price	DECIMAL(10,2)	NOT NULL	Precio en moneda local.
currency	VARCHAR(3)	DEFAULT 'MXN'	Moneda.
interval	VARCHAR(50)	NOT NULL, CHECK (interval IN ('semanal', 'mensual', 'trimestral', 'semestral', 'anual'))	Período de facturación.
features	JSONB	NOT NULL	Características incluidas.
is_active	BOOLEAN	DEFAULT TRUE	Si el plan está activo.
created_at	TIMESTAMP	DEFAULT NOW()	Fecha de creación.
updated_at	TIMESTAMP	DEFAULT NOW()	Fecha de última actualización.

Índices:

CREATE INDEX idx_plans_tenant_id ON commerce.plans (tenant_id);
CREATE INDEX idx_plans_is_active ON commerce.plans (is_active);
CREATE INDEX idx_plans_interval ON commerce.plans (interval);

4.3.3. Tabla subscriptions
Campo	Tipo	Restricciones	Descripción
id	UUID	PRIMARY KEY, DEFAULT gen_random_uuid()	ID de la suscripción.
patient_id	UUID	NOT NULL, REFERENCES clinical.patients(id) ON DELETE CASCADE	ID del paciente.
tenant_id	UUID	NOT NULL, REFERENCES tenants(id)	ID del tenant.
plan_id	UUID	NOT NULL, REFERENCES commerce.plans(id)	ID del plan.
stripe_id	VARCHAR(255)	NULL	ID de Stripe (si aplica).
mercadopago_id	VARCHAR(255)	NULL	ID de Mercado Pago (si aplica).
status	VARCHAR(50)	NOT NULL, CHECK (status IN ('active', 'canceled', 'expired', 'pending', 'past_due', 'trialing'))	Estado de la suscripción.
start_date	DATE	NOT NULL	Fecha de inicio.
end_date	DATE	NULL	Fecha de fin (si cancelada).
auto_renew	BOOLEAN	DEFAULT TRUE	Si se renueva automáticamente.
created_at	TIMESTAMP	DEFAULT NOW()	Fecha de creación.
updated_at	TIMESTAMP	DEFAULT NOW()	Fecha de última actualización.

Índices:
CREATE INDEX idx_subscriptions_patient_id ON commerce.subscriptions (patient_id);
CREATE INDEX idx_subscriptions_tenant_id ON commerce.subscriptions (tenant_id);
CREATE INDEX idx_subscriptions_status ON commerce.subscriptions (status);
CREATE INDEX idx_subscriptions_stripe_id ON commerce.subscriptions (stripe_id);
CREATE INDEX idx_subscriptions_mercadopago_id ON commerce.subscriptions (mercadopago_id);

4.3.4. Tabla invoices
Campo	Tipo	Restricciones	Descripción
id	UUID	PRIMARY KEY, DEFAULT gen_random_uuid()	ID de la factura.
patient_id	UUID	NOT NULL, REFERENCES clinical.patients(id) ON DELETE CASCADE	ID del paciente.
tenant_id	UUID	NOT NULL, REFERENCES tenants(id)	ID del tenant.
subscription_id	UUID	REFERENCES commerce.subscriptions(id) ON DELETE SET NULL	ID de la suscripción asociada.
amount	DECIMAL(10,2)	NOT NULL	Subtotal.
tax	DECIMAL(10,2)	DEFAULT 0	Impuesto (IVA).
total	DECIMAL(10,2)	NOT NULL	Total.
currency	VARCHAR(3)	DEFAULT 'MXN'	Moneda.
status	VARCHAR(50)	NOT NULL, CHECK (status IN ('pending', 'paid', 'failed', 'canceled', 'refunded'))	Estado de la factura.
cfdi_xml	TEXT	NULL	XML del CFDI.
cfdi_pdf_url	TEXT	NULL	URL del PDF de la factura.
payment_method	VARCHAR(50)	NULL	Método de pago (ej. "stripe", "mercadopago").
payment_id	VARCHAR(255)	NULL	ID de transacción del gateway.
issued_at	TIMESTAMP	DEFAULT NOW()	Fecha de emisión.
paid_at	TIMESTAMP	NULL	Fecha de pago.
due_date	DATE	NULL	Fecha de vencimiento.
created_at	TIMESTAMP	DEFAULT NOW()	Fecha de creación.
updated_at	TIMESTAMP	DEFAULT NOW()	Fecha de última actualización.

Índices:

CREATE INDEX idx_invoices_patient_id ON commerce.invoices (patient_id);
CREATE INDEX idx_invoices_tenant_id ON commerce.invoices (tenant_id);
CREATE INDEX idx_invoices_status ON commerce.invoices (status);
CREATE INDEX idx_invoices_issued_at ON commerce.invoices (issued_at);
CREATE INDEX idx_invoices_subscription_id ON commerce.invoices (subscription_id);

4.3.5. Tabla coupons
Campo	Tipo	Restricciones	Descripción
id	UUID	PRIMARY KEY, DEFAULT gen_random_uuid()	ID del cupón.
tenant_id	UUID	NOT NULL, REFERENCES tenants(id)	ID del tenant.
code	VARCHAR(50)	UNIQUE, NOT NULL	Código del cupón.
discount_type	VARCHAR(50)	NOT NULL, CHECK (discount_type IN ('percentage', 'fixed_amount'))	Tipo de descuento.
value	DECIMAL(10,2)	NOT NULL	Valor del descuento.
expires_at	TIMESTAMP	NOT NULL	Fecha de expiración.
usage_limit	INTEGER	NULL	Límite de usos.
used_count	INTEGER	DEFAULT 0	Número de usos.
is_active	BOOLEAN	DEFAULT TRUE	Si está activo.
created_at	TIMESTAMP	DEFAULT NOW()	Fecha de creación.
updated_at	TIMESTAMP	DEFAULT NOW()	Fecha de última actualización.

Índices:

CREATE INDEX idx_coupons_code ON commerce.coupons (code);
CREATE INDEX idx_coupons_tenant_id ON commerce.coupons (tenant_id);
CREATE INDEX idx_coupons_is_active ON commerce.coupons (is_active);
CREATE INDEX idx_coupons_expires_at ON commerce.coupons (expires_at);

4.3.6. Tabla leads
Campo	Tipo	Restricciones	Descripción
id	UUID	PRIMARY KEY, DEFAULT gen_random_uuid()	ID del lead.
org_name	VARCHAR(255)	NOT NULL	Nombre de la clínica u organización.
contact_name	VARCHAR(255)	NOT NULL	Nombre de contacto.
email	VARCHAR(255)	NOT NULL	Correo de contacto.
phone	VARCHAR(20)	NULL	Teléfono de contacto.
audience	VARCHAR(50)	NOT NULL, CHECK (audience IN ('clinica', 'psicologo'))	Tipo de audiencia comercial.
source	VARCHAR(50)	NOT NULL, DEFAULT 'landing'	Origen del lead.
status	VARCHAR(50)	DEFAULT 'received', CHECK (status IN ('received', 'contacted', 'qualified', 'converted', 'discarded'))	Estado del lead.
consent	BOOLEAN	NOT NULL, DEFAULT FALSE	Consentimiento RGPD/LFPDPPP (obligatorio).
consent_granted_at	TIMESTAMP	NULL	Fecha de aceptación del consentimiento.
metadata	JSONB	NULL	Metadatos adicionales (UAs, referrer).
created_at	TIMESTAMP	DEFAULT NOW()	Fecha de creación.
updated_at	TIMESTAMP	DEFAULT NOW()	Fecha de última actualización.

Índices:

CREATE INDEX idx_leads_email ON commerce.leads (email);
CREATE INDEX idx_leads_source ON commerce.leads (source);
CREATE INDEX idx_leads_status ON commerce.leads (status);
CREATE INDEX idx_leads_created_at ON commerce.leads (created_at);

Deduplicación: UNIQUE(email, COALESCE(org_name, ''), source).

4.3.7. Tabla support_tickets
Campo	Tipo	Restricciones	Descripción
id	UUID	PRIMARY KEY, DEFAULT gen_random_uuid()	ID del ticket de soporte.
user_id	UUID	NULL, REFERENCES auth.users(id) ON DELETE SET NULL	Usuario autenticado (NULL para visitantes de la landing).
category	VARCHAR(50)	NOT NULL, CHECK (category IN ('error', 'improvement'))	Categoría del ticket.
severity	VARCHAR(50)	NOT NULL, CHECK (severity IN ('low', 'medium', 'high', 'critical'))	Severidad.
status	VARCHAR(50)	DEFAULT 'new', CHECK (status IN ('new', 'awaiting_reproduction', 'in_progress', 'escalated', 'resolved', 'closed'))	Estado del ticket.
description	TEXT	NOT NULL	Descripción del reporte.
reproduction_steps	TEXT	NULL	Pasos de reproducción (errores).
app_context	JSONB	NULL	Contexto de la app (versión, plataforma, pantalla).
source	VARCHAR(50)	NOT NULL, CHECK (source IN ('landing', 'patient_app', 'therapist_app'))	Superficie de origen.
consent_id	UUID	NULL, REFERENCES consent_log(id) ON DELETE SET NULL	Consentimiento de diagnóstico asociado.
created_at	TIMESTAMP	DEFAULT NOW()	Fecha de creación.
updated_at	TIMESTAMP	DEFAULT NOW()	Fecha de última actualización.

Índices:

CREATE INDEX idx_support_tickets_user_id ON support_tickets (user_id);
CREATE INDEX idx_support_tickets_status ON support_tickets (status);
CREATE INDEX idx_support_tickets_category ON support_tickets (category);
CREATE INDEX idx_support_tickets_severity ON support_tickets (severity);
CREATE INDEX idx_support_tickets_created_at ON support_tickets (created_at);

4.3.8. Tabla consent_log
Campo	Tipo	Restricciones	Descripción
id	UUID	PRIMARY KEY, DEFAULT gen_random_uuid()	ID del registro de consentimiento.
user_key	TEXT	NOT NULL	Identificador del usuario o visitante (anónimo si no hay cuenta).
scope	VARCHAR(50)	NOT NULL, CHECK (scope IN ('diagnostics', 'marketing', 'ai', 'clinical', 'telemetry'))	Alcance del consentimiento.
granted_at	TIMESTAMP	NOT NULL	Momento de aceptación.
revoked_at	TIMESTAMP	NULL	Momento de revocación.
metadata	JSONB	NULL	Metadatos (versión del documento, IP).

Índices:

CREATE INDEX idx_consent_log_user_key ON consent_log (user_key);
CREATE INDEX idx_consent_log_scope ON consent_log (scope);
CREATE INDEX idx_consent_log_granted_at ON consent_log (granted_at);

> **Nota de implementación:** `support_tickets` y `consent_log` ya existen en el
> codebase implementado (slice T2.6 del change `landing-ia-atencion`); este spec
> formaliza su contrato. La tabla `leads` corresponde al formulario SLS-001-REC-003.

4.4. Esquema exercises (Ejercicios y Telemetría)
4.4.1. Tabla exercises_catalog
Campo	Tipo	Restricciones	Descripción
id	UUID	PRIMARY KEY, DEFAULT gen_random_uuid()	ID del ejercicio.
tenant_id	UUID	NOT NULL, REFERENCES tenants(id)	ID del tenant.
name	VARCHAR(255)	NOT NULL	Nombre del ejercicio.
description	TEXT	NULL	Descripción del ejercicio.
type	VARCHAR(50)	NOT NULL, CHECK (type IN ('defusion', 'acceptance', 'values', 'exposure', 'mindfulness', 'regulation', 'social', 'neuropsychology'))	Tipo de ejercicio.
processes	JSONB	NOT NULL	Procesos psicológicos que entrena.
mechanics	JSONB	NOT NULL	Mecánicas de juego utilizadas.
difficulty_level	INTEGER	DEFAULT 1	Nivel de dificultad (1-10).
estimated_duration	INTEGER	NULL	Duración estimada en minutos.
min_age	INTEGER	NULL	Edad mínima recomendada.
max_age	INTEGER	NULL	Edad máxima recomendada.
version	VARCHAR(20)	DEFAULT '1.0.0'	Versión del ejercicio.
status	VARCHAR(50)	DEFAULT 'active', CHECK (status IN ('active', 'experimental', 'deprecated'))	Estado del ejercicio.
godot_scene	TEXT	NULL	URL de la escena de Godot.
metadata	JSONB	NULL	Metadatos adicionales.
created_at	TIMESTAMP	DEFAULT NOW()	Fecha de creación.
updated_at	TIMESTAMP	DEFAULT NOW()	Fecha de última actualización.

Índices:
CREATE INDEX idx_exercises_catalog_tenant_id ON exercises.exercises_catalog (tenant_id);
CREATE INDEX idx_exercises_catalog_type ON exercises.exercises_catalog (type);
CREATE INDEX idx_exercises_catalog_processes ON exercises.exercises_catalog USING GIN (processes);
CREATE INDEX idx_exercises_catalog_status ON exercises.exercises_catalog (status);

4.4.2. Tabla exercise_sessions
Campo	Tipo	Restricciones	Descripción
id	UUID	PRIMARY KEY, DEFAULT gen_random_uuid()	ID de la sesión de ejercicio.
patient_id	UUID	NOT NULL, REFERENCES clinical.patients(id) ON DELETE CASCADE	ID del paciente.
tenant_id	UUID	NOT NULL, REFERENCES tenants(id)	ID del tenant.
exercise_id	UUID	NOT NULL, REFERENCES exercises_catalog(id)	ID del ejercicio.
start_time	TIMESTAMP	NOT NULL	Hora de inicio.
end_time	TIMESTAMP	NULL	Hora de fin.
duration	INTEGER	NULL	Duración en segundos.
completion_status	VARCHAR(50)	NOT NULL, CHECK (completion_status IN ('completed', 'abandoned', 'interrupted', 'failed'))	Estado de finalización.
score	DECIMAL(10,2)	NULL	Puntuación obtenida.
difficulty_level_used	INTEGER	NULL	Nivel de dificultad aplicado.
feedback	JSONB	NULL	Feedback generado por el sistema.
created_at	TIMESTAMP	DEFAULT NOW()	Fecha de creación.
updated_at	TIMESTAMP	DEFAULT NOW()	Fecha de última actualización.

Índices:
CREATE INDEX idx_exercise_sessions_patient_id ON exercises.exercise_sessions (patient_id);
CREATE INDEX idx_exercise_sessions_tenant_id ON exercises.exercise_sessions (tenant_id);
CREATE INDEX idx_exercise_sessions_exercise_id ON exercises.exercise_sessions (exercise_id);
CREATE INDEX idx_exercise_sessions_start_time ON exercises.exercise_sessions (start_time);

4.4.3. Tabla exercise_telemetry
Campo	Tipo	Restricciones	Descripción
id	UUID	PRIMARY KEY, DEFAULT gen_random_uuid()	ID del registro de telemetría.
session_id	UUID	NOT NULL, REFERENCES exercise_sessions(id) ON DELETE CASCADE	ID de la sesión de ejercicio.
variable_name	VARCHAR(100)	NOT NULL	Nombre de la variable (ej. "latencia", "errores", "tiempo_reaccion").
value	JSONB	NOT NULL	Valor de la variable (puede ser numérico, booleano, array).
timestamp	TIMESTAMP	NOT NULL	Momento de la medición.
confidence	DECIMAL(5,4)	DEFAULT 0.9	Nivel de confianza.
Índices:

-- Esta tabla se particiona por tiempo (TimescaleDB)
CREATE INDEX idx_exercise_telemetry_session_id ON exercises.exercise_telemetry (session_id);
CREATE INDEX idx_exercise_telemetry_variable_name ON exercises.exercise_telemetry (variable_name);
CREATE INDEX idx_exercise_telemetry_timestamp ON exercises.exercise_telemetry (timestamp);

4.5. Esquema analytics (Análisis y KPIs)
4.5.1. Tabla process_trajectories
Campo	Tipo	Restricciones	Descripción
id	UUID	PRIMARY KEY, DEFAULT gen_random_uuid()	ID del registro.
patient_id	UUID	NOT NULL, REFERENCES clinical.patients(id) ON DELETE CASCADE	ID del paciente.
tenant_id	UUID	NOT NULL, REFERENCES tenants(id)	ID del tenant.
process_name	VARCHAR(100)	NOT NULL	Nombre del proceso (ej. "Aceptación").
value	DECIMAL(5,4)	NOT NULL	Valor del proceso (0-1).
confidence	DECIMAL(5,4)	DEFAULT 0.8	Nivel de confianza.
timestamp	TIMESTAMP	NOT NULL	Momento de la medición.
Índices:

-- Hipertabla de TimescaleDB
CREATE INDEX idx_process_trajectories_patient_id ON analytics.process_trajectories (patient_id);
CREATE INDEX idx_process_trajectories_tenant_id ON analytics.process_trajectories (tenant_id);
CREATE INDEX idx_process_trajectories_process_name ON analytics.process_trajectories (process_name);
CREATE INDEX idx_process_trajectories_timestamp ON analytics.process_trajectories (timestamp);

4.5.2. Tabla adherence_metrics
Campo	Tipo	Restricciones	Descripción
id	UUID	PRIMARY KEY, DEFAULT gen_random_uuid()	ID del registro.
patient_id	UUID	NOT NULL, REFERENCES clinical.patients(id) ON DELETE CASCADE	ID del paciente.
tenant_id	UUID	NOT NULL, REFERENCES tenants(id)	ID del tenant.
date	DATE	NOT NULL	Fecha.
exercises_completed	INTEGER	DEFAULT 0	Número de ejercicios completados.
minutes_used	INTEGER	DEFAULT 0	Minutos de uso de la app.
engagement_score	DECIMAL(5,4)	DEFAULT 0.5	Puntuación de engagement (0-1).
sessions_attended	INTEGER	DEFAULT 0	Sesiones asistidas.
created_at	TIMESTAMP	DEFAULT NOW()	Fecha de creación.
updated_at	TIMESTAMP	DEFAULT NOW()	Fecha de última actualización.

Índices:
CREATE INDEX idx_adherence_metrics_patient_id ON analytics.adherence_metrics (patient_id);
CREATE INDEX idx_adherence_metrics_tenant_id ON analytics.adherence_metrics (tenant_id);
CREATE INDEX idx_adherence_metrics_date ON analytics.adherence_metrics (date);

4.5.3. Tabla predictions
Campo	Tipo	Restricciones	Descripción
id	UUID	PRIMARY KEY, DEFAULT gen_random_uuid()	ID del registro.
patient_id	UUID	NOT NULL, REFERENCES clinical.patients(id) ON DELETE CASCADE	ID del paciente.
tenant_id	UUID	NOT NULL, REFERENCES tenants(id)	ID del tenant.
prediction_type	VARCHAR(50)	NOT NULL, CHECK (prediction_type IN ('dropout_risk', 'relapse_risk', 'adherence', 'process_improvement'))	Tipo de predicción.
value	DECIMAL(5,4)	NOT NULL	Valor de la predicción (0-1).
confidence	DECIMAL(5,4)	NOT NULL	Nivel de confianza (0-1).
horizon	INTEGER	NOT NULL	Horizonte de predicción en días.
timestamp	TIMESTAMP	NOT NULL	Momento de la predicción.
metadata	JSONB	NULL	Metadatos adicionales (ej. variables utilizadas).

índice:

CREATE INDEX idx_predictions_patient_id ON analytics.predictions (patient_id);
CREATE INDEX idx_predictions_tenant_id ON analytics.predictions (tenant_id);
CREATE INDEX idx_predictions_type ON analytics.predictions (prediction_type);
CREATE INDEX idx_predictions_timestamp ON analytics.predictions (timestamp);

4.6. Esquema audit (Auditoría y Logs)
4.6.1. Tabla audit_logs
Campo	Tipo	Restricciones	Descripción
id	UUID	PRIMARY KEY, DEFAULT gen_random_uuid()	ID del log.
user_id	UUID	REFERENCES auth.users(id) ON DELETE SET NULL	ID del usuario que realizó la acción.
tenant_id	UUID	NOT NULL, REFERENCES tenants(id)	ID del tenant.
action	VARCHAR(100)	NOT NULL	Acción realizada (ej. "patient_created", "session_updated").
resource_type	VARCHAR(100)	NOT NULL	Tipo de recurso (ej. "patient", "session", "invoice").
resource_id	UUID	NOT NULL	ID del recurso afectado.
changes	JSONB	NULL	Cambios realizados (antes/después).
ip	INET	NULL	Dirección IP.
user_agent	TEXT	NULL	User agent.
timestamp	TIMESTAMP	DEFAULT NOW()	Fecha y hora.

Índices:

-- Particionado por mes
CREATE INDEX idx_audit_logs_user_id ON audit.audit_logs (user_id);
CREATE INDEX idx_audit_logs_tenant_id ON audit.audit_logs (tenant_id);
CREATE INDEX idx_audit_logs_action ON audit.audit_logs (action);
CREATE INDEX idx_audit_logs_resource_type ON audit.audit_logs (resource_type);
CREATE INDEX idx_audit_logs_resource_id ON audit.audit_logs (resource_id);
CREATE INDEX idx_audit_logs_timestamp ON audit.audit_logs (timestamp);

4.6.2. Tabla access_logs
Campo	Tipo	Restricciones	Descripción
id	UUID	PRIMARY KEY, DEFAULT gen_random_uuid()	ID del log.
user_id	UUID	NOT NULL, REFERENCES auth.users(id) ON DELETE CASCADE	ID del usuario que accedió.
patient_id	UUID	NOT NULL, REFERENCES clinical.patients(id) ON DELETE CASCADE	ID del paciente consultado.
tenant_id	UUID	NOT NULL, REFERENCES tenants(id)	ID del tenant.
reason	VARCHAR(255)	NULL	Razón del acceso.
timestamp	TIMESTAMP	DEFAULT NOW()	Fecha y hora.

Índices:

CREATE INDEX idx_access_logs_user_id ON audit.access_logs (user_id);
CREATE INDEX idx_access_logs_patient_id ON audit.access_logs (patient_id);
CREATE INDEX idx_access_logs_tenant_id ON audit.access_logs (tenant_id);
CREATE INDEX idx_access_logs_timestamp ON audit.access_logs (timestamp);

5. Políticas RLS (Row Level Security)
5.1. Principios de RLS
Aislamiento de tenants: Cada fila tiene un tenant_id. Las políticas RLS garantizan que un usuario solo pueda ver y modificar datos de su propio tenant (o de los tenants que tenga permiso).

Basado en roles: Los permisos dependen del rol del usuario (patient, therapist, admin, super_admin, etc.).

Consentimiento: El acceso a datos clínicos sensibles requiere consentimiento explícito del paciente.

5.2. Implementación de RLS
Se habilita RLS en todas las tablas que lo requieren:

ALTER TABLE clinical.patients ENABLE ROW LEVEL SECURITY;
ALTER TABLE clinical.sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE clinical.assessments ENABLE ROW LEVEL SECURITY;
ALTER TABLE clinical.hypotheses ENABLE ROW LEVEL SECURITY;
ALTER TABLE commerce.subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE commerce.invoices ENABLE ROW LEVEL SECURITY;
-- ... todas las demás tablas

Ejemplo de políticas:

5.2.1. Política para patients (pacientes)

-- Política para pacientes (solo ven sus propios datos)
CREATE POLICY patient_select_patients ON clinical.patients
  FOR SELECT USING (
    auth.uid() = user_id
  );

-- Política para terapeutas (ven sus pacientes asignados)
CREATE POLICY therapist_select_patients ON clinical.patients
  FOR SELECT USING (
    therapist_id = (
      SELECT id FROM clinical.therapists WHERE user_id = auth.uid()
    )
  );

-- Política para administradores del tenant (ven todos los pacientes del tenant)
CREATE POLICY admin_select_patients ON clinical.patients
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM auth.users
      WHERE auth.users.id = auth.uid()
      AND auth.users.role IN ('admin', 'super_admin')
      AND auth.users.tenant_id = clinical.patients.tenant_id
    )
  );

-- Política de inserción (solo terapeutas y administradores pueden crear pacientes)
CREATE POLICY therapist_insert_patients ON clinical.patients
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM auth.users
      WHERE auth.users.id = auth.uid()
      AND auth.users.role IN ('therapist', 'admin', 'super_admin')
      AND auth.users.tenant_id = NEW.tenant_id
    )
  );

5.2.2. Política para sessions (sesiones)

-- Pacientes ven sus propias sesiones
CREATE POLICY patient_select_sessions ON clinical.sessions
  FOR SELECT USING (
    patient_id IN (
      SELECT id FROM clinical.patients WHERE user_id = auth.uid()
    )
  );

-- Terapeutas ven sesiones de sus pacientes asignados
CREATE POLICY therapist_select_sessions ON clinical.sessions
  FOR SELECT USING (
    therapist_id IN (
      SELECT id FROM clinical.therapists WHERE user_id = auth.uid()
    )
  );

5.2.3. Política para invoices (facturas)

-- Pacientes ven sus propias facturas
CREATE POLICY patient_select_invoices ON commerce.invoices
  FOR SELECT USING (
    patient_id IN (
      SELECT id FROM clinical.patients WHERE user_id = auth.uid()
    )
  );

-- Administradores ven todas las facturas del tenant
CREATE POLICY admin_select_invoices ON commerce.invoices
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM auth.users
      WHERE auth.users.id = auth.uid()
      AND auth.users.role IN ('admin', 'super_admin')
      AND auth.users.tenant_id = commerce.invoices.tenant_id
    )
  );

5.2.4. Política para audit_logs (logs de auditoría)

-- Solo administradores y super_admin pueden ver logs
CREATE POLICY admin_select_audit_logs ON audit.audit_logs
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM auth.users
      WHERE auth.users.id = auth.uid()
      AND auth.users.role IN ('admin', 'super_admin')
      AND auth.users.tenant_id = audit.audit_logs.tenant_id
    )
  );

5.3. Políticas de Inserción/Actualización/Eliminación
Se deben definir políticas para todas las operaciones (INSERT, UPDATE, DELETE) siguiendo los mismos principios de tenant y rol.

Ejemplo para patients:

-- Actualización: solo terapeutas y administradores pueden modificar pacientes
CREATE POLICY therapist_update_patients ON clinical.patients
  FOR UPDATE USING (
    therapist_id = (
      SELECT id FROM clinical.therapists WHERE user_id = auth.uid()
    )
  ) WITH CHECK (
    therapist_id = (
      SELECT id FROM clinical.therapists WHERE user_id = auth.uid()
    )
  );

-- Eliminación: solo administradores pueden eliminar pacientes (soft delete)
CREATE POLICY admin_delete_patients ON clinical.patients
  FOR DELETE USING (
    EXISTS (
      SELECT 1 FROM auth.users
      WHERE auth.users.id = auth.uid()
      AND auth.users.role IN ('admin', 'super_admin')
      AND auth.users.tenant_id = clinical.patients.tenant_id
    )
  );

6. Estrategia de Índices y Optimización
6.1. Índices Recomendados por Tabla
Tabla	Índice	Tipo	Justificación
users	(tenant_id, role)	B-tree	Filtrado por tenant y rol.
users	(email)	B-tree (UNIQUE)	Búsqueda por email para login.
sessions	(patient_id, start_time DESC)	B-tree	Obtener sesiones recientes de un paciente.
sessions	(therapist_id, start_time DESC)	B-tree	Obtener sesiones recientes de un terapeuta.
assessments	(patient_id, administered_at DESC)	B-tree	Obtener evaluaciones recientes.
process_trajectories	(patient_id, process_name, timestamp)	B-tree (TimescaleDB)	Consultas de trayectorias.
exercise_telemetry	(session_id, variable_name, timestamp)	B-tree (TimescaleDB)	Consultas de telemetría por sesión.
invoices	(patient_id, issued_at DESC)	B-tree	Facturas recientes.
invoices	(status)	B-tree	Facturas pendientes.
hypotheses	(patient_id, confidence DESC)	B-tree	Hipótesis más confiables.
audit_logs	(timestamp DESC)	BRIN (particionado)	Consultas de auditoría por fecha.
access_logs	(patient_id, timestamp DESC)	B-tree	Registros de acceso a un paciente.
consents	(user_id, type)	B-tree	Consentimientos por tipo.
subscriptions	(patient_id, status)	B-tree	Suscripciones activas.
plans	(is_active, interval)	B-tree	Planes activos por intervalo.

6.2. Índices GIN para JSONB
sql
-- Para búsquedas en campos JSONB (ej. interpretation en assessments)
CREATE INDEX idx_assessments_interpretation ON clinical.assessments USING GIN (interpretation);

-- Para processes en exercises_catalog
CREATE INDEX idx_exercises_catalog_processes ON exercises.exercises_catalog USING GIN (processes);

-- Para metadata general
CREATE INDEX idx_hypotheses_evidence_for ON clinical.hypotheses USING GIN (evidence_for);
CREATE INDEX idx_hypotheses_evidence_against ON clinical.hypotheses USING GIN (evidence_against);

6.3. Índices de Texto Completo
sql
-- Para búsqueda en notas de sesión (si se requiere búsqueda textual)
CREATE INDEX idx_sessions_notes_search ON clinical.sessions
  USING GIN (to_tsvector('spanish', COALESCE(notes_soap, '') || ' ' || COALESCE(notes_dap, '')));

-- Para búsqueda en descripciones de ejercicios
CREATE INDEX idx_exercises_catalog_search ON exercises.exercises_catalog
  USING GIN (to_tsvector('spanish', name || ' ' || COALESCE(description, '')));

6.4. Estrategias de Particionado
audit_logs: Particionado por mes (PARTITION BY RANGE (timestamp)).

exercise_telemetry: TimescaleDB (hipertabla con chunk por semana).

process_trajectories: TimescaleDB (hipertabla con chunk por mes).

access_logs: Particionado por trimestre.

Ejemplo de particionado (TimescaleDB):

sql
-- Convertir tabla en hipertabla (TimescaleDB)
SELECT create_hypertable('exercises.exercise_telemetry', 'timestamp', chunk_time_interval => INTERVAL '1 week');

-- Crear políticas de retención (eliminar datos > 2 años)
SELECT add_retention_policy('exercises.exercise_telemetry', INTERVAL '2 years');

7. Estrategia de Migraciones (Alembic)
7.1. Estructura de Migraciones
Las migraciones se gestionan con Alembic (SQLAlchemy). Cada cambio al esquema se versiona y se aplica en orden.

Estructura de carpetas:

backend/
├── migrations/
│   ├── versions/
│   │   ├── 001_initial_schema.py
│   │   ├── 002_add_consents_table.py
│   │   ├── 003_add_process_trajectories.py
│   │   └── ...
│   ├── env.py
│   └── alembic.ini
└── …

Ejemplo de migración (creación de tabla values):

# migrations/versions/005_add_values_table.py
"""add values table

Revision ID: 005
Revises: 004
Create Date: 2026-07-01 10:00:00.000000
"""

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects.postgresql import UUID, JSONB

# revision identifiers, used by Alembic.
revision = '005'
down_revision = '004'
branch_labels = None
depends_on = None

def upgrade():
    op.create_table(
        'values',
        sa.Column('id', UUID, primary_key=True, server_default=sa.text('gen_random_uuid()')),
        sa.Column('patient_id', UUID, nullable=False),
        sa.Column('tenant_id', UUID, nullable=False),
        sa.Column('name', sa.String(100), nullable=False),
        sa.Column('domain', sa.String(50), nullable=False),
        sa.Column('behaviors', JSONB, nullable=True),
        sa.Column('barriers', JSONB, nullable=True),
        sa.Column('natural_reinforcers', JSONB, nullable=True),
        sa.Column('costs', JSONB, nullable=True),
        sa.Column('coherence', sa.Numeric(5, 4), nullable=True),
        sa.Column('confidence', sa.Numeric(5, 4), nullable=True),
        sa.Column('created_at', sa.TIMESTAMP, server_default=sa.text('NOW()')),
        sa.Column('updated_at', sa.TIMESTAMP, server_default=sa.text('NOW()')),
        schema='clinical',
    )
    # Añadir índices
    op.create_index('idx_values_patient_id', 'values', ['patient_id'], schema='clinical')
    op.create_index('idx_values_tenant_id', 'values', ['tenant_id'], schema='clinical')
    op.create_index('idx_values_domain', 'values', ['domain'], schema='clinical')
    # Añadir foreign keys
    op.create_foreign_key('fk_values_patient_id', 'values', 'patients', ['patient_id'], ['id'], source_schema='clinical', referent_schema='clinical')
    op.create_foreign_key('fk_values_tenant_id', 'values', 'tenants', ['tenant_id'], ['id'], source_schema='clinical', referent_schema='commerce')

def downgrade():
    op.drop_table('values', schema='clinical')

7.2. Políticas de Migración
Versionado semántico: Las migraciones se nombran con números secuenciales (001, 002, ...).

Rollback: Cada migración tiene una función downgrade() que permite revertir el cambio.

Idempotencia: Las migraciones son idempotentes (se pueden ejecutar múltiples veces sin efectos secundarios).

Validación pre-deploy: Las migraciones se prueban en entorno de staging antes de producción.

7.3. Gestión de Datos de Referencia
Los datos de referencia (ej. planes de suscripción, roles, tipos de evaluación) se insertan mediante migraciones de datos (usando op.bulk_insert()).

Ejemplo:

from sqlalchemy import table, column
from sqlalchemy.sql import table

def upgrade():
    # Crear tabla de planes si no existe (ya creada en migración anterior)
    # Insertar planes por defecto
    plans_table = table('plans',
        column('id', UUID),
        column('tenant_id', UUID),
        column('name', sa.String),
        column('description', sa.String),
        column('price', sa.Numeric),
        column('currency', sa.String),
        column('interval', sa.String),
        column('features', JSONB),
        column('is_active', sa.Boolean),
    )
    op.bulk_insert(plans_table, [
        {
            'id': '11111111-1111-1111-1111-111111111111',
            'tenant_id': '00000000-0000-0000-0000-000000000000',  # tenant por defecto
            'name': 'Plan Mensual',
            'description': '4 sesiones al mes + ejercicios ilimitados',
            'price': 700.00,
            'currency': 'MXN',
            'interval': 'mensual',
            'features': {'sessions': 4, 'ai_chat': True, 'exercises': 'all'},
            'is_active': True,
        },
        # ... más planes
    ])

8. Ejemplos de Consultas Optimizadas
8.1. Obtener el perfil completo de un paciente (para el terapeuta)

sql
WITH patient_data AS (
  SELECT
    p.id,
    p.user_id,
    p.therapist_id,
    p.status,
    p.intake_date,
    p.discharge_date,
    u.email,
    pr.first_name,
    pr.last_name,
    pr.age,
    pr.gender,
    t.license_number
  FROM clinical.patients p
  JOIN auth.users u ON p.user_id = u.id
  JOIN auth.profiles pr ON u.id = pr.user_id
  LEFT JOIN clinical.therapists t ON p.therapist_id = t.id
  WHERE p.id = 'abc-123'
),
assessments_data AS (
  SELECT
    json_agg(
      json_build_object(
        'type', a.type,
        'score', a.score,
        'administered_at', a.administered_at
      ) ORDER BY a.administered_at DESC
    ) AS recent_assessments
  FROM clinical.assessments a
  WHERE a.patient_id = 'abc-123'
  LIMIT 5
),
hypotheses_data AS (
  SELECT
    json_agg(
      json_build_object(
        'id', h.id,
        'description', h.description,
        'confidence', h.confidence,
        'status', h.status
      ) ORDER BY h.confidence DESC
    ) AS active_hypotheses
  FROM clinical.hypotheses h
  WHERE h.patient_id = 'abc-123'
  AND h.status = 'activa'
),
values_data AS (
  SELECT
    json_agg(
      json_build_object(
        'name', v.name,
        'domain', v.domain,
        'coherence', v.coherence
      )
    ) AS values_list
  FROM clinical.values v
  WHERE v.patient_id = 'abc-123'
)
SELECT
  p.*,
  a.recent_assessments,
  h.active_hypotheses,
  v.values_list
FROM patient_data p
CROSS JOIN assessments_data a
CROSS JOIN hypotheses_data h
CROSS JOIN values_data v;

8.2. Obtener trayectorias de procesos (para el terapeuta y el dashboard)

sql
SELECT
  time_bucket('1 day', timestamp) AS day,
  process_name,
  AVG(value) AS avg_value,
  STDDEV(value) AS std_value,
  COUNT(*) AS sample_size
FROM analytics.process_trajectories
WHERE patient_id = 'abc-123'
  AND process_name IN ('Aceptación', 'Defusión', 'Evitación')
  AND timestamp > NOW() - INTERVAL '90 days'
GROUP BY day, process_name
ORDER BY day, process_name;

8.3. Calcular el riesgo de abandono (para el sistema predictivo)
sql
WITH inactivity AS (
  SELECT
    patient_id,
    1 - (COUNT(DISTINCT date_trunc('day', timestamp)) / 30.0) AS inactivity_rate
  FROM analytics.adherence_metrics
  WHERE date > NOW() - INTERVAL '30 days'
  GROUP BY patient_id
),
low_engagement AS (
  SELECT
    patient_id,
    1 - AVG(engagement_score) AS low_engagement_rate
  FROM analytics.adherence_metrics
  WHERE date > NOW() - INTERVAL '30 days'
  GROUP BY patient_id
),
dropout_risk AS (
  SELECT
    i.patient_id,
    (i.inactivity_rate * 0.6 + le.low_engagement_rate * 0.4) AS dropout_risk
  FROM inactivity i
  JOIN low_engagement le ON i.patient_id = le.patient_id
  HAVING (i.inactivity_rate * 0.6 + le.low_engagement_rate * 0.4) > 0.5
  ORDER BY dropout_risk DESC
)
SELECT
  p.id,
  p.first_name || ' ' || p.last_name AS patient_name,
  dr.dropout_risk,
  CASE
    WHEN dr.dropout_risk > 0.8 THEN 'crítico'
    WHEN dr.dropout_risk > 0.6 THEN 'alto'
    WHEN dr.dropout_risk > 0.4 THEN 'medio'
    ELSE 'bajo'
  END AS risk_level
FROM dropout_risk dr
JOIN clinical.patients p ON dr.patient_id = p.id
JOIN auth.profiles pr ON p.user_id = pr.user_id;

8.4. Análisis de adherencia por tenant y terapeuta

sql
SELECT
  p.tenant_id,
  t.id AS therapist_id,
  t.user_id,
  COUNT(DISTINCT p.id) AS total_patients,
  AVG(am.engagement_score) AS avg_engagement,
  AVG(am.exercises_completed) AS avg_exercises,
  SUM(CASE WHEN am.date = CURRENT_DATE THEN 1 ELSE 0 END) AS active_today
FROM clinical.patients p
JOIN clinical.therapists t ON p.therapist_id = t.id
JOIN analytics.adherence_metrics am ON p.id = am.patient_id
WHERE am.date > NOW() - INTERVAL '30 days'
GROUP BY p.tenant_id, t.id, t.user_id
ORDER BY avg_engagement DESC;

8.5. Búsqueda semántica en la base de conocimiento (RAG)

sql
SELECT
  a.id AS article_id,
  a.title,
  a.abstract,
  1 - (e.embedding <=> '[0.123, 0.456, ...]'::vector) AS similarity
FROM research.article_embeddings e
JOIN research.articles a ON e.article_id = a.id
WHERE 1 - (e.embedding <=> '[0.123, 0.456, ...]'::vector) > 0.7
ORDER BY similarity DESC
LIMIT 5;

9. Monitorización y Mantenimiento
9.1. Consultas Lentas
Monitoreo: Supabase Dashboard, pg_stat_statements.

Alertas: Prometheus + Grafana para consultas que exceden 100 ms.

9.2. Mantenimiento Periódico
Tarea	Frecuencia	Herramienta
Vacuum (limpieza de filas muertas)	Diario (automático)	Autovacuum de PostgreSQL.
Reindexación	Mensual	REINDEX (en ventana de mantenimiento).
Análisis de estadísticas	Diario	ANALYZE automático de PostgreSQL.
Archivado de logs	Semanal	Purga de logs > 2 años.
Backup	Diario (completo)	Supabase Backup / pg_dump.
Prueba de restauración	Trimestral	Restaurar backup en entorno de staging.
9.3. Métricas de Rendimiento
Métrica	Objetivo	Herramienta
Tiempo de respuesta de consultas	< 50 ms (promedio)	pg_stat_statements
Tasa de uso de índices	> 90%	pg_stat_all_indexes
Cache hit ratio (lecturas)	> 99%	pg_stat_bgwriter
Conexiones activas	< 80% del límite	Supabase Dashboard
Tamaño de la base de datos	Monitorear crecimiento	pg_database_size
10. Criterios de Validación y Cumplimiento
Criterio	Métrica	Herramienta
Integridad referencial	100% de FK válidas.	Pruebas de integridad (BQAS).
RLS activa	100% de tablas clínicas y de comercio tienen RLS.	Pruebas de seguridad.
Cobertura de índices	90% de consultas frecuentes cubiertas por índices.	Análisis de consultas.
Versionado de esquemas	100% de cambios tienen migración Alembic.	CI/CD.
Backup y recuperación	RPO < 1 hora, RTO < 4 horas.	Pruebas de recuperación.
Tiempo de consulta	< 100 ms para consultas simples, < 500 ms para complejas.	Monitoreo.
11. El Manifiesto de la Base de Datos
"La base de datos es la memoria del BehavioralOS. Cada tabla guarda una historia: la historia de un paciente, la evolución de un proceso, la consolidación de una habilidad.

Proteger esa memoria es nuestra responsabilidad. Cada índice debe estar justificado. Cada política RLS debe tener una razón. Cada migración debe ser segura.

Una base de datos bien diseñada es invisible; simplemente funciona. Una base de datos mal diseñada se convierte en un cuello de botella, una fuente de errores y una pesadilla de mantenimiento.

Nuestra misión es mantener la memoria viva, rápida y segura."

12. Historial de Cambios
Versión	Fecha	Autor	Cambios
1.0.0	2026-07-01	Arquitectura de Datos	Creación del documento. Definición de esquemas, tablas, campos, relaciones, índices, políticas RLS, estrategia de migraciones y ejemplos de consultas.
1.1.0	2026-08-12	Arquitectura de Datos & Backend	Añadidas tablas del change `landing-ia-atencion` (slice 2): `leads` (4.3.6), `support_tickets` (4.3.7) y `consent_log` (4.3.8) en el esquema commerce. `support_tickets` y `consent_log` ya existían en el codebase implementado (T2.6); `leads` formaliza el formulario SLS-001-REC-003.
Fin del documento database-graph.md