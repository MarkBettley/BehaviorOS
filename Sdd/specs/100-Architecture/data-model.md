---
id: DM-001
title: Modelo de Datos del BehavioralOS
version: 2.2.0
status: Stable
owner: Arquitectura de Datos & Backend
last_updated: 2026-08-12
depends_on:
  - 000-Core/ontology.md (Ontología)
  - 100-Architecture/system-architecture.md (BEA)
  - 100-Architecture/behavioral-twin.md (Behavioral Twin)
  - 100-Architecture/engines-overview.md (BREO)
  - 100-Architecture/bik-architecture.md (BIK)
  - 100-Architecture/event-sourcing-architecture.md (Event Sourcing)
exports:
  - Modelo relacional (PostgreSQL): tablas, relaciones, índices, RLS
  - Modelo de grafos (BKGE): nodos, aristas, atributos, versionado
  - Modelo vectorial (pgvector): embeddings, RAG, búsqueda semántica
  - Modelo de series temporales (TimescaleDB/InfluxDB): procesos, telemetría, predicciones
  - Modelo de Event Sourcing: event_stream, derived_views
  - Modelo de Procesos: process_nodes, process_edges, process_snapshots, process_events, process_domains, process_instruments
  - Políticas de versionado, consistencia y escalabilidad
  - Estrategias de cifrado, anonimización y retención de datos
used_by:
  - Todos los motores y servicios (AAO, BERL, TCCN, BSC, BWM, BPOS, BCE, etc.)
  - BPE, BPO, BPG, BIK, BXE (motores del núcleo)
  - BQAS (pruebas de integridad de datos)
  - CI/CD (migraciones y versionado de esquemas)
---

# BehavioralOS – Modelo de Datos

> *"Los datos no son un subproducto del sistema. Son el sistema. Cada interacción, cada evaluación, cada hipótesis, cada descubrimiento queda grabado en la memoria del BehavioralOS. Un buen modelo de datos no solo almacena información; la organiza para que pueda ser consultada, analizada y comprendida. Es el mapa de la memoria del ecosistema."*

---

## 1. Propósito y Alcance

### 1.1. Propósito
Este documento define el **modelo de datos** del BehavioralOS: cómo se almacenan, organizan, versionan, consultan y protegen todos los datos del ecosistema. Su objetivo es:

- **Proveer una estructura coherente** para todos los tipos de datos (relacionales, grafos, vectores, series temporales, documentos).
- **Garantizar la integridad** y consistencia de los datos clínicos, financieros y operacionales.
- **Facilitar el acceso** a los datos para todos los motores (AAO, BERL, TCCN, BSC, etc.) mediante APIs eficientes.
- **Asegurar la privacidad** y el cumplimiento normativo (LFPDPPP, GDPR, HIPAA) mediante cifrado, anonimización y políticas de retención.
- **Soportar la escalabilidad** horizontal y el multi-tenant desde el diseño.

### 1.2. Alcance
El modelo de datos cubre cinco subsistemas de almacenamiento:

1. **Modelo Relacional (PostgreSQL)**: Datos estructurados (usuarios, pacientes, sesiones, pagos, etc.).
2. **Modelo de Grafos (BKGE)**: Conocimiento semántico (ontología, procesos, relaciones, hipótesis, redes RFT).
3. **Modelo Vectorial (pgvector)**: Embeddings para RAG y búsqueda semántica.
4. **Modelo de Series Temporales (TimescaleDB / InfluxDB)**: Trayectorias de procesos, telemetría, predicciones.
5. **Modelo de Documentos y Archivos (Supabase Storage)**: Informes, notas, audios, videos, sprites, PDFs.

### 1.3. Principio Fundamental
> **"Los datos son la memoria del BehavioralOS. Cada bit debe ser trazable, versionado, seguro y accesible. La integridad de los datos clínicos es tan importante como la integridad de los datos financieros. Un modelo de datos mal diseñado es una sentencia de muerte para un sistema clínico."**

---

## 2. Principios de Diseño de Datos

| # | Principio | Descripción | Criterio de cumplimiento |
|---|-----------|-------------|---------------------------|
| 1 | **Idempotencia** | Todas las operaciones de escritura son idempotentes (se pueden repetir sin efectos secundarios). | Cada operación incluye un `idempotency_key` (UUID v7). |
| 2 | **Versionado semántico** | Todos los esquemas y datos tienen versiones (MAJOR.MINOR.PATCH). | Cada tabla tiene un campo `version` o se versiona mediante eventos. |
| 3 | **Trazabilidad total** | Cada cambio en los datos clínicos o financieros es auditado (quién, cuándo, qué, por qué). | Tablas de auditoría o Event Sourcing. |
| 4 | **Cifrado en reposo y en tránsito** | Todos los datos sensibles (clínicos, financieros, identificables) están cifrados. | AES-256 en reposo, TLS 1.3 en tránsito. |
| 5 | **RLS (Row Level Security)** | El acceso a los datos está restringido por tenant y por rol. | Políticas RLS en PostgreSQL. |
| 6 | **Separación lógica** | Los datos clínicos, financieros y de investigación están en esquemas separados. | Esquemas `clinical`, `commerce`, `research`. |
| 7 | **Anonimización para investigación** | Los datos de investigación no contienen información identificable. | Anonimización automática antes de exportar a BSC. |
| 8 | **Retención configurable** | Los datos se retienen según políticas (ej. logs 2 años, expedientes 10 años). | Políticas de retención en cada tabla. |
| 9 | **Escalabilidad horizontal** | Las bases de datos pueden escalarse mediante replicación y sharding. | PostgreSQL con replicación, TimescaleDB para series. |
| 10 | **Backup y recuperación** | Los backups son automáticos, cifrados y probados regularmente. | Backups diarios, RPO < 1 hora, RTO < 4 horas. |
| 11 | **Transformación correcta** | Distinguir encoding, hashing y encriptación según el objetivo. Ningún dato sensible usa encoding como seguridad. | Ver TCD-001 §3. |

---

## 3. Modelo Relacional (PostgreSQL)

### 3.1. Esquemas y Tenants

El modelo relacional se organiza en **esquemas** para separar dominios lógicos, y cada tabla incluye un campo `tenant_id` para el multi-tenant.

┌─────────────────────────────────────────────────────────────────────────┐
│ PostgreSQL (Supabase) │
├─────────────────────────────────────────────────────────────────────────┤
│ Esquema: auth (autenticación y usuarios) │
│ Esquema: clinical (pacientes, sesiones, evaluaciones, notas) │
│ Esquema: commerce (suscripciones, pagos, facturas, productos, leads, soporte) │
│ Esquema: practice (agenda, videoterapia, CRM) │
│ Esquema: analytics (datos agregados, predicciones) │
│ Esquema: research (datos anonimizados para investigación) │
│ Esquema: audit (logs y auditoría) │
│ Esquema: storage (metadatos de archivos) │
└─────────────────────────────────────────────────────────────────────────┘


### 3.2. Tablas Principales (por Dominio)

#### 3.2.1. Dominio `auth` (Autenticación y Usuarios)

| Tabla | Descripción | Campos clave |
|-------|-------------|--------------|
| `users` | Usuarios del sistema (todos los roles) | `id` (UUID), `email`, `password_hash`, `role`, `tenant_id`, `created_at` |
| `profiles` | Perfiles de usuario (datos demográficos) | `user_id`, `first_name`, `last_name`, `age`, `gender`, `timezone`, `language` |
| `roles` | Roles del sistema (RBAC) | `id`, `name`, `permissions` (JSON) |
| `user_roles` | Asignación de roles a usuarios | `user_id`, `role_id`, `tenant_id` |
| `sessions` | Sesiones activas | `id`, `user_id`, `jwt_token`, `expires_at`, `ip`, `device_info` |
| `consents` | Consentimientos firmados | `id`, `user_id`, `consent_type`, `version`, `accepted_at`, `ip`, `signature` |
| `consent_versions` | Versionado de consentimientos | `id`, `type`, `version`, `content`, `effective_date`, `deprecated_date` |

#### 3.2.2. Dominio `clinical` (Datos Clínicos)

| Tabla | Descripción | Campos clave |
|-------|-------------|--------------|
| `patients` | Pacientes (personas en terapia) | `id` (UUID), `user_id`, `therapist_id`, `tenant_id`, `status` (activo/alta/transferido), `created_at` |
| `therapists` | Terapeutas (psicólogos) | `id` (UUID), `user_id`, `license_number`, `specialties` (JSON), `tenant_id` |
| `sessions` | Sesiones terapéuticas | `id`, `patient_id`, `therapist_id`, `start_time`, `end_time`, `modality` (presencial/online), `status` (programada/completada/cancelada) |
| `session_notes` | Notas de sesión (SOAP/DAP) | `id`, `session_id`, `content`, `version`, `created_by`, `signed_at` (firma del terapeuta) |
| `assessments` | Evaluaciones clínicas | `id`, `patient_id`, `type` (MPFI/AAQ-II/CompACT/etc.), `score`, `interpretation` (JSON), `administered_at`, `confidence` |
| `assessment_items` | Reactivos de evaluaciones (para adaptativas) | `id`, `assessment_id`, `item_id`, `response`, `timestamp` |
| `exercise_sessions` | Registro de ejercicios realizados | `id`, `patient_id`, `exercise_id`, `start_time`, `end_time`, `duration`, `completion_status`, `score`, `difficulty_level` |
| `exercise_telemetry` | Telemetría detallada de ejercicios | `id`, `exercise_session_id`, `variable_name`, `value`, `timestamp` (serie temporal) |
| `hypotheses` | Hipótesis funcionales | `id`, `patient_id`, `description`, `confidence`, `evidence_for` (JSON), `evidence_against` (JSON), `status` (activa/confirmada/rechazada), `created_at` |
| `hypothesis_updates` | Historial de actualizaciones de hipótesis | `id`, `hypothesis_id`, `new_confidence`, `reason`, `source` (AAO/BERL/TCCN/terapeuta), `timestamp` |
| `values` | Valores (ACT) | `id`, `patient_id`, `name`, `domain`, `coherence_score`, `behaviors` (JSON), `barriers` (JSON) |
| `goals` | Objetivos terapéuticos | `id`, `patient_id`, `description`, `target_behavior`, `frequency`, `unit`, `progress`, `deadline` |
| `behavioral_twin` | Snapshot del Behavioral Twin (versión actual) | `id`, `patient_id`, `twin_json` (JSONB), `version`, `updated_at` |

#### 3.2.3. Dominio `commerce` (Datos Comerciales)

| Tabla | Descripción | Campos clave |
|-------|-------------|--------------|
| `subscriptions` | Suscripciones activas | `id`, `patient_id`, `plan_id`, `status` (activa/cancelada/expirada), `start_date`, `end_date`, `auto_renew` |
| `plans` | Planes de suscripción | `id`, `name`, `price`, `currency`, `interval` (semanal/mensual/anual), `features` (JSON) |
| `invoices` | Facturas emitidas | `id`, `patient_id`, `subscription_id`, `amount`, `tax`, `total`, `status` (pagada/pendiente/cancelada), `cfdi_xml` (texto), `cfdi_pdf` (URL), `issued_at` |
| `payments` | Transacciones de pago | `id`, `invoice_id`, `amount`, `currency`, `payment_method`, `status`, `transaction_id` (externo), `processed_at` |
| `coupons` | Cupones y descuentos | `id`, `code`, `discount_type` (porcentaje/monto), `value`, `expires_at`, `usage_limit`, `used_count` |
| `products` | Productos digitales (marketplace) | `id`, `name`, `description`, `price`, `category`, `file_url`, `created_by` (terapeuta/equipo) |
| `purchases` | Compras de productos | `id`, `patient_id`, `product_id`, `amount`, `purchased_at` |
| `leads` | Leads de la landing (SLS-001) | `id`, `org_name`, `contact_name`, `email`, `audience` (clínica/psicólogo), `source`, `status`, `consent`, `consent_granted_at`, `created_at` |
| `support_tickets` | Tickets de soporte por IA (AI-007) | `id`, `user_id` (NULL en landing), `category` (error/improvement), `severity`, `status`, `description`, `reproduction_steps`, `app_context` (JSONB), `source`, `consent_id`, `created_at` |
| `consent_log` | Registro de consentimientos de diagnóstico (AI-007) | `id`, `user_key`, `scope` (diagnostics/…), `granted_at`, `revoked_at` |

#### 3.2.4. Dominio `practice` (Operación Clínica)

| Tabla | Descripción | Campos clave |
|-------|-------------|--------------|
| `appointments` | Citas en agenda | `id`, `patient_id`, `therapist_id`, `start_time`, `end_time`, `status` (programada/confirmada/completada/cancelada), `modality` |
| `waiting_list` | Lista de espera | `id`, `patient_id`, `requested_service`, `priority`, `created_at` |
| `messages` | Mensajes entre paciente y terapeuta | `id`, `sender_id`, `receiver_id`, `content`, `is_read`, `sent_at`, `attachments` (JSON) |
| `todos` | Tareas pendientes para el terapeuta | `id`, `therapist_id`, `description`, `due_date`, `completed_at` |
| `templates` | Plantillas de documentos (notas, informes) | `id`, `name`, `content` (con variables), `category`, `created_by` |
| `reports` | Informes generados (ej. Functional Behavioral Report) | `id`, `patient_id`, `therapist_id`, `type`, `content` (JSON/PDF), `generated_at`, `signed_at` |

#### 3.2.5. Dominio `analytics` (Datos Agregados)

| Tabla | Descripción | Campos clave |
|-------|-------------|--------------|
| `kpi_daily` | KPIs diarios agregados por tenant | `id`, `tenant_id`, `date`, `active_patients`, `new_patients`, `sessions_completed`, `revenue`, `adherence_rate` |
| `process_trajectories` | Trayectorias de procesos por paciente (agregadas) | `id`, `patient_id`, `process_name`, `date`, `value`, `confidence` |
| `predictions` | Predicciones del sistema | `id`, `patient_id`, `prediction_type` (abandono/recaída/mejora), `value`, `confidence`, `horizon` (días), `generated_at` |

#### 3.2.6. Dominio `audit` (Auditoría)

| Tabla | Descripción | Campos clave |
|-------|-------------|--------------|
| `audit_logs` | Registro de todas las acciones críticas | `id`, `user_id`, `action`, `resource_type`, `resource_id`, `changes` (JSON), `ip`, `user_agent`, `timestamp` |
| `access_logs` | Registro de accesos a datos clínicos | `id`, `user_id`, `patient_id`, `reason`, `timestamp` |
| `security_events` | Eventos de seguridad (intentos de acceso no autorizados, etc.) | `id`, `event_type`, `user_id`, `ip`, `details` (JSON), `timestamp` |

#### 3.2.7. Dominio `processes` (Grafo de Procesos del BPG)

Este dominio almacena el estado del Behavioral Process Graph (BPG): nodos, aristas, snapshots, eventos y catálogos de dominios e instrumentos.

| Tabla | Descripción | Campos clave |
|-------|-------------|--------------|
| `process_nodes` | Nodos del grafo de procesos del paciente | `id` (UUID), `patient_id` (UUID FK), `name` (text), `domain` (text), `value` (float), `confidence` (float), `state` (text: activo/inactivo/en_evolución), `intensity` (float 0-1), `metadata` (JSONB), `created_at`, `updated_at` |
| `process_edges` | Aristas del grafo (relaciones entre procesos) | `id` (UUID), `source_node_id` (UUID FK → process_nodes), `target_node_id` (UUID FK → process_nodes), `relation_type` (text: facilita/inhibe/causa/facilita/compite), `weight` (float), `confidence` (float), `evidence` (JSONB: lista de fuentes), `created_at`, `updated_at` |
| `process_snapshots` | Instantáneas del grafo al final de cada sesión | `id` (UUID), `patient_id` (UUID FK), `snapshot_data` (JSONB: grafo completo serializado), `timestamp` (timestamptz), `therapy_session_id` (UUID FK → clinical.sessions), `version` (integer), `created_at` |
| `process_events` | Eventos que modifican el grafo de procesos | `id` (UUID), `patient_id` (UUID FK), `event_type` (text: node_created/node_updated/edge_created/edge_weight_changed/state_changed), `source_module` (text: BPE/BPG/BCAS/BDSS/BERL), `payload` (JSONB), `timestamp` (timestamptz), `created_at` |
| `process_domains` | Catálogo de dominios de procesos (de la ontología BPO) | `id` (UUID), `name` (text: Cognitivo/Afectivo/Conductual/Relacional/Social/Somático/Motivacional/Meta), `description` (text), `process_count` (integer), `version` (text), `created_at` |
| `process_instruments` | Instrumentos asociados a procesos (evaluaciones que los miden) | `id` (UUID), `process_node_id` (UUID FK → process_nodes), `instrument_name` (text: MPFI/AAQ-II/CompACT/DASS-21/etc.), `score_type` (text: sum/mean/item), `weight` (float: contribución al proceso), `metadata` (JSONB), `created_at` |

**Relaciones con tablas existentes:**

```
patients (1) ──── (0..*) process_nodes
patients (1) ──── (0..*) process_snapshots
patients (1) ──── (0..*) process_events
clinical.sessions (1) ──── (0..*) process_snapshots
process_nodes (1) ──── (0..*) process_edges (source)
process_nodes (1) ──── (0..*) process_edges (target)
process_nodes (1) ──── (0..*) process_instruments
process_domains (1) ──── (0..*) process_nodes
```

**Índices clave:**

| Tabla | Índices | Tipo |
|-------|---------|------|
| `process_nodes` | `patient_id`, `domain`, `name` | B-tree |
| `process_edges` | `source_node_id`, `target_node_id`, `relation_type` | B-tree |
| `process_snapshots` | `patient_id`, `timestamp` | B-tree, BRIN |
| `process_events` | `patient_id`, `event_type`, `timestamp` | B-tree, BRIN |
| `process_domains` | `name` (único) | B-tree |
| `process_instruments` | `process_node_id`, `instrument_name` | B-tree |

**RLS (Row Level Security):**

```sql
-- Políticas RLS para process_nodes
CREATE POLICY patient_process_nodes ON process_nodes
  FOR ALL USING (
    patient_id IN (SELECT id FROM patients WHERE user_id = auth.uid())
    OR (SELECT role FROM users WHERE id = auth.uid()) = 'therapist'
    OR (SELECT role FROM users WHERE id = auth.uid()) = 'admin'
  );
```

#### 3.2.8. Dominio `streaming` (Event Sourcing y Datos Derivados)

Este dominio implementa la arquitectura de Event Sourcing definida en `event-sourcing-architecture.md`.

| Tabla | Descripción | Campos clave |
|-------|-------------|--------------|
| `event_stream` | Log inmutable de todos los eventos del sistema (System of Record) | `event_id` (UUID), `event_type` (text), `aggregate_id` (UUID: patient_id o session_id), `payload` (JSONB), `metadata` (JSONB: schema_version, correlation_id, causation_id), `timestamp` (timestamptz), `sequence` (bigint), `created_at` |
| `derived_views` | Vistas de datos derivados generadas por los motores que observan el Event Stream | `id` (UUID), `view_name` (text: hexaflex_scores/ftb_classifications/rft_graph/bpg_state/twin_snapshot), `aggregate_id` (UUID), `data` (JSONB), `source_event_id` (UUID FK → event_stream), `engine_version` (text), `confidence` (float), `created_at`, `updated_at` |

**Relaciones con tablas existentes:**

```
event_stream (1) ──── (0..*) derived_views
patients (1) ──── (0..*) event_stream (vía aggregate_id)
clinical.sessions (1) ──── (0..*) event_stream (vía aggregate_id)
```

**Índices clave:**

| Tabla | Índices | Tipo |
|-------|---------|------|
| `event_stream` | `aggregate_id`, `event_type`, `timestamp` | B-tree, BRIN |
| `event_stream` | `sequence` (único) | B-tree |
| `derived_views` | `aggregate_id`, `view_name` | B-tree |

**Retención:**

| Tabla | Período | Política |
|-------|---------|----------|
| `event_stream` | Indefinido (inmutable) | Nunca se purga; es la fuente de verdad |
| `derived_views` | Regenerable | Si se pierde, se regenera re-procesando el event_stream |

**RLS (Row Level Security):**

```sql
-- Políticas RLS para event_stream
CREATE POLICY tenant_event_stream ON event_stream
  FOR ALL USING (
    aggregate_id IN (
      SELECT id FROM patients WHERE tenant_id = auth.jwt() ->> 'tenant_id'
    )
  );
```

### 3.3. Relaciones Clave (Diagrama ER Conceptual)
users (1) ──────┬───── (0..) patients
├───── (0..) therapists
└───── (0..*) messages

patients (1) ───┬───── (0..) sessions
├───── (0..) assessments
├───── (0..) exercise_sessions
├───── (0..) hypotheses
├───── (0..) values
├───── (0..) goals
└───── (1..*) appointments

therapists (1) ─┬───── (0..) sessions
├───── (0..) appointments
└───── (0..*) patients

sessions (1) ───┬───── (0..) session_notes
└───── (0..) reports

exercise_sessions (1) ────── (0..*) exercise_telemetry

subscriptions (1) ────── (0..) invoices
invoices (1) ────── (0..) payments
patients (1) ────── (0..) subscriptions
patients (1) ────── (0..) purchases


### 3.4. Políticas RLS (Row Level Security)

Todas las tablas del dominio `clinical`, `commerce`, `practice` y `analytics` tienen políticas RLS que garantizan:

- **Tenant isolation**: Un usuario solo puede ver datos de su propio tenant (clínica/organización).
- **Role-based access**: Un paciente solo puede ver sus propios datos. Un terapeuta solo puede ver los datos de sus pacientes asignados.
- **Consent-based access**: El acceso a datos sensibles (ej. notas de sesión) requiere consentimiento explícito del paciente.

**Ejemplo de política RLS (PostgreSQL)**:
```sql
-- Política para que un paciente solo vea sus propios datos
CREATE POLICY patient_select ON patients
  FOR SELECT USING (
    auth.uid() = user_id
    OR (SELECT role FROM users WHERE id = auth.uid()) = 'therapist'
    OR (SELECT role FROM users WHERE id = auth.uid()) = 'admin'
  );

-- Política para que un terapeuta solo vea sus pacientes
CREATE POLICY therapist_select ON patients
  FOR SELECT USING (
    therapist_id = (SELECT id FROM therapists WHERE user_id = auth.uid())
    OR (SELECT role FROM users WHERE id = auth.uid()) = 'admin'
  );

3.5. Índices y Optimización
Tabla	Índices clave	Tipo
patients	tenant_id, therapist_id, status	B-tree
sessions	patient_id, therapist_id, start_time, status	B-tree, BRIN (para tiempo)
exercise_telemetry	exercise_session_id, timestamp	B-tree, TimescaleDB (hiper)
assessments	patient_id, administered_at	B-tree
audit_logs	user_id, timestamp, resource_type	B-tree, particionado por fecha
invoices	patient_id, issued_at, status	B-tree
behavioral_twin	patient_id (único)	B-tree
messages	sender_id, receiver_id, sent_at	B-tree
process_trajectories	patient_id, process_name, date	B-tree (TimescaleDB)
3.6. Estrategia de Particionado
Tablas de auditoría y logs: Particionadas por mes (audit_logs_2026_01, etc.) para facilitar la retención y purga.

Tablas de telemetría: Particionadas por semana o mes usando TimescaleDB (hipertables).

Tablas de sesiones: Particionadas por año y mes (si el volumen es alto).

4. Modelo de Grafos (BKGE – Behavioral Knowledge Graph Engine)
4.1. Propósito
El Behavioral Knowledge Graph Engine (BKGE) almacena el conocimiento semántico del BehavioralOS: la ontología, los procesos psicológicos, las hipótesis, las redes RFT, los marcos relacionales y las relaciones entre todos estos conceptos. Es la memoria semántica del sistema, consultada por el RAG, el RFT Engine, el BWM y el Behavioral Twin.

4.2. Estructura del Grafo
El grafo se almacena en PostgreSQL utilizando el tipo JSONB para serializar los grafos de cada paciente o del conocimiento global. Alternativamente, se puede usar Neo4j si el volumen crece significativamente, pero inicialmente se opta por PostgreSQL por simplicidad y seguridad.

4.2.1. Tablas del Grafo
Tabla	Descripción	Campos clave
kg_graphs	Grafos (cada paciente o conocimiento global)	id, type (global/patient), patient_id (opcional), version, created_at, updated_at
kg_nodes	Nodos del grafo	id, graph_id, label (ej. "proceso", "evento", "marco_relacional"), attributes (JSONB), confidence, created_at, updated_at
kg_edges	Aristas del grafo	id, graph_id, source_node_id, target_node_id, relation_type (ej. "causes", "inhibits", "coordinación"), attributes (JSONB), confidence, created_at, updated_at
kg_versions	Versionado de grafos	id, graph_id, version, snapshot (JSONB), created_at
4.2.2. Ejemplo de Nodo (JSONB)

{
  "id": "n_001",
  "label": "proceso",
  "attributes": {
    "name": "Aceptación",
    "domain": "Afectivo",
    "definition": "Disposición a experimentar eventos privados sin intentar cambiarlos.",
    "indicators": ["tiempo de permanencia", "frecuencia de evitación"],
    "confidence": 0.85
  }
}

4.2.3. Ejemplo de Arista (JSONB)

{
  "id": "e_001",
  "source": "n_001",
  "target": "n_002",
  "relation_type": "facilitates",
  "attributes": {
    "strength": 0.75,
    "evidence": ["estudio_ACT_2020", "meta_análisis_2022"],
    "confidence": 0.82
  }
}

4.3. Tipos de Nodos y Aristas
Tipo de nodo	Ejemplos
proceso	Aceptación, Defusión, Valores, Evitación
evento	Pensamiento, Emoción, Conducta
marco_relacional	Coordinación, Distinción, Oposición, Comparación
hipótesis	Hipótesis funcional activa
intervención	Ejercicio de defusión, Exposición
valor	Conexión familiar, Crecimiento personal
evidencia	Artículo, Meta-análisis, Estudio clínico
contexto	Trabajo, Familia, Pareja
Tipo de arista	Ejemplos
causes	A causa B
inhibits	A inhibe B
facilitates	A facilita B
strengthens	A fortalece B
weakens	A debilita B
coordinación	A = B (RFT)
distinción	A ≠ B (RFT)
oposición	A ↔ No A (RFT)
comparación	A > B / A < B (RFT)
generalizes_to	A se generaliza a B
derived_from	A se deriva de B
supported_by	A está respaldado por B
contradicted_by	A es contradicho por B

4.4. Consultas al Grafo (Ejemplos)
Consulta 1: Obtener todos los procesos relacionados con un marco relacional

SELECT n2.*
FROM kg_nodes n1
JOIN kg_edges e ON n1.id = e.source_node_id
JOIN kg_nodes n2 ON e.target_node_id = n2.id
WHERE n1.label = 'marco_relacional'
  AND n1.attributes->>'name' = 'coordinación'
  AND e.relation_type = 'associated_with';

Consulta 2: Obtener la red RFT de un paciente

SELECT n.*, e.*
FROM kg_nodes n
JOIN kg_edges e ON n.id = e.source_node_id OR n.id = e.target_node_id
WHERE n.graph_id = (SELECT id FROM kg_graphs WHERE patient_id = 'abc-123' AND type = 'patient')
  AND n.label IN ('evento', 'marco_relacional');

Consulta 3: Encontrar hipótesis que comparten evidencia

SELECT h1.*, h2.*
FROM kg_nodes h1
JOIN kg_edges e1 ON h1.id = e1.source_node_id
JOIN kg_nodes ev ON e1.target_node_id = ev.id
JOIN kg_edges e2 ON ev.id = e2.source_node_id
JOIN kg_nodes h2 ON e2.target_node_id = h2.id
WHERE h1.label = 'hipótesis' AND h2.label = 'hipótesis' AND h1.id != h2.id
  AND e1.relation_type = 'supported_by'
  AND e2.relation_type = 'supported_by';

4.5. Versionado y Evolución del Grafo
Cada cambio en el grafo (nuevo nodo, arista, actualización de atributos) genera una nueva versión en kg_versions.

Las versiones se almacenan como snapshots completos (JSONB) para facilitar la restauración y la auditoría.

El Behavioral Twin referencia una versión específica del grafo para garantizar consistencia.

5. Modelo Vectorial (pgvector)
5.1. Propósito
El modelo vectorial almacena embeddings de textos (conversaciones, notas, artículos científicos, descripciones de ejercicios) para permitir búsqueda semántica (RAG) y recomendaciones contextuales.

5.2. Tablas Vectoriales
Tabla	Descripción	Campos clave
embeddings	Almacena embeddings de textos	id, text_id (referencia a la fuente), text_type (conversation/note/article/exercise), embedding (vector(1536)), created_at, metadata (JSONB)
conversation_embeddings	Embeddings de conversaciones (por paciente)	id, patient_id, conversation_id, embedding (vector(1536)), timestamp
article_embeddings	Embeddings de artículos científicos (BSC)	id, article_id, embedding (vector(1536)), title, abstract (texto)

5.3. Consultas Semánticas
Búsqueda por similitud de coseno (pgvector):

SELECT text_id, text_type, 1 - (embedding <=> query_embedding) AS similarity
FROM embeddings
WHERE text_type = 'article'
  AND 1 - (embedding <=> query_embedding) > 0.7
ORDER BY similarity DESC
LIMIT 10;

Búsqueda híbrida (semántica + palabras clave):

SELECT text_id, text_type,
  ts_rank(to_tsvector('spanish', text), plainto_tsquery('spanish', 'aceptación')) AS lexical_score,
  1 - (embedding <=> query_embedding) AS semantic_score,
  (lexical_score * 0.3 + semantic_score * 0.7) AS combined_score
FROM embeddings
WHERE text_type = 'article'
  AND (to_tsvector('spanish', text) @@ plainto_tsquery('spanish', 'aceptación')
       OR 1 - (embedding <=> query_embedding) > 0.6)
ORDER BY combined_score DESC
LIMIT 10;

5.4. Generación de Embeddings
Modelo: Se utiliza un modelo de embeddings multilingüe (ej. intfloat/multilingual-e5-large o sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2).

Frecuencia: Los embeddings se generan en el momento de la ingesta de datos (conversaciones, notas, artículos) y se almacenan en embeddings.

Actualización: Si un texto se modifica, su embedding se regenera y se actualiza la tabla.

6. Modelo de Series Temporales (TimescaleDB / InfluxDB)
6.1. Propósito
El modelo de series temporales almacena datos longitudinales de alta frecuencia: trayectorias de procesos, telemetría de ejercicios, EMA, predicciones y métricas de adherencia.

6.2. Tablas de Series Temporales (con TimescaleDB)
Tabla	Descripción	Campos clave	Hipertabla
process_trajectories	Evolución de procesos psicológicos	patient_id, process_name, timestamp, value, confidence	Sí (por paciente)
exercise_telemetry_ts	Telemetría de ejercicios (agregada)	patient_id, exercise_id, timestamp, variable_name, value	Sí (por paciente)
ema_responses	Respuestas a evaluaciones ecológicas	patient_id, question_id, timestamp, response_value	Sí (por paciente)
adherence_metrics	Métricas de adherencia diarias	patient_id, date, exercises_completed, minutes_used, engagement_score	Sí (por paciente)
predictions_ts	Predicciones del sistema (ej. riesgo de abandono)	patient_id, prediction_type, timestamp, value, confidence	Sí (por paciente)
sensor_data	Datos de sensores (wearables, si están disponibles)	patient_id, sensor_type, timestamp, value	Sí (por paciente)

6.3. Consultas de Series Temporales
Consulta 1: Trayectoria de un proceso en los últimos 30 días

SELECT time_bucket('1 day', timestamp) AS day,
       AVG(value) AS avg_value
FROM process_trajectories
WHERE patient_id = 'abc-123'
  AND process_name = 'Aceptación'
  AND timestamp > NOW() - INTERVAL '30 days'
GROUP BY day
ORDER BY day;

Consulta 2: Correlación entre dos procesos

WITH acceptance AS (
  SELECT timestamp, value AS acceptance
  FROM process_trajectories
  WHERE patient_id = 'abc-123' AND process_name = 'Aceptación'
),
avoidance AS (
  SELECT timestamp, value AS avoidance
  FROM process_trajectories
  WHERE patient_id = 'abc-123' AND process_name = 'Evitación'
)
SELECT corr(a.acceptance, b.avoidance) AS correlation
FROM acceptance a
JOIN avoidance b ON a.timestamp = b.timestamp;

6.4. Retención y Compresión
Retención: Los datos de telemetría se retienen 2 años (política de retención de TimescaleDB). Los datos de procesos se retienen 10 años.

Compresión: Los datos antiguos (> 6 meses) se comprimen para ahorrar espacio.

Agregación: Se generan agregaciones diarias y semanales para consultas rápidas (materialized views).

7. Modelo de Documentos y Archivos (Supabase Storage)
7.1. Propósito
Almacenar archivos no estructurados: informes (PDF), notas clínicas (PDF), audios de sesiones (MP3), videos de videoterapia (MP4), sprites y assets de Godot, etc.

7.2. Organización de Buckets
Bucket	Descripción	Política de acceso
patient-documents	Informes, notas, consentimientos firmados (PDF).	Paciente + terapeuta + administradores
session-recordings	Grabaciones de sesiones (audio/video) con consentimiento.	Solo terapeuta y paciente (con cifrado)
exercise-assets	Sprites, sonidos, escenas de Godot.	Público (para la app)
research-data	Datos anonimizados para investigación.	Solo investigadores (con permisos)
temp-uploads	Archivos temporales (subidas, procesamiento).	Limpieza automática (24 horas)
7.3. Metadatos de Archivos
Cada archivo tiene metadatos almacenados en PostgreSQL (tabla storage_metadata):

Campo	Descripción
id	UUID del archivo
bucket	Bucket de almacenamiento
path	Ruta dentro del bucket
size	Tamaño en bytes
mime_type	Tipo MIME
patient_id (opcional)	Paciente asociado
session_id (opcional)	Sesión asociada
uploaded_by	Usuario que subió el archivo
uploaded_at	Fecha de subida
encryption_key	Clave de cifrado (si está cifrado)
hash	SHA-256 del archivo (para integridad)
version	Versión del archivo (para versionado)
7.4. Cifrado de Archivos
Todos los archivos clínicos (informes, grabaciones) se cifran antes de ser subidos a Storage.

Cifrado: AES-256-GCM con una clave derivada de la clave maestra del tenant.

Clave: Se almacena en Supabase Vault (o un servicio de gestión de claves) y no en la aplicación.

8. Estrategias de Versionado y Consistencia
8.1. Versionado de Datos Clínicos
Notas de sesión: Cada modificación genera una nueva versión (ej. v1, v2, v3). La versión anterior se conserva para auditoría.

Hipótesis: Cada actualización de confianza o cambio de estado se registra en hypothesis_updates con timestamp y razón.

Behavioral Twin: Cada actualización genera una nueva versión del Twin (snapshot completo). Se conservan las últimas 100 versiones (por política) y las anteriores se comprimen.

8.2. Consistencia Transaccional
Pagos y suscripciones: Se usan Sagas (con Temporal.io) para garantizar consistencia entre Stripe/Mercado Pago, la base de datos y la facturación.

Behavioral Twin y ejercicios: La actualización del Twin se realiza en una transacción con el registro del ejercicio. Si falla, se revierte.

Eventos de BRIL: Los eventos se almacenan en una tabla de salida (Outbox) antes de ser publicados, para garantizar que no se pierdan si el sistema falla.

8.3. Estrategias de Replicación y Backup
Componente	Estrategia
PostgreSQL	Replicación síncrona (para alta disponibilidad) y asíncrona (para lectura). Backups diarios completos y WAL archiving.
Supabase Storage	Replicación geográfica (opcional). Backups de metadatos en PostgreSQL.
Redis	Replicación con failover automático (Redis Sentinel). Backups RDB diarios.
TimescaleDB	Replicación (como PostgreSQL). Políticas de retención automática.
9. Integración con los Motores del Ecosistema
9.1. AAO (Adaptive Assessment Orchestrator)
Lectura: Consulta process_trajectories y assessments para evaluar el estado actual de los procesos.

Escritura: Inserta en assessments, assessment_items y actualiza process_trajectories con los nuevos valores.

9.2. BERL (Behavioral Exercise Research Lab)
Lectura: Consulta patients, exercise_sessions y hypotheses para seleccionar ejercicios adaptativos.

Escritura: Inserta en exercise_sessions, exercise_telemetry, y actualiza process_trajectories con el impacto del ejercicio.

9.3. TCCN (Therapeutic Cognitive Companion)
Lectura: Consulta hypotheses, values, goals y el Behavioral Twin para generar diálogos.

Escritura: Inserta en messages y actualiza el Behavioral Twin.

9.4. BSC (Behavioral Science Cloud)
Lectura: Consulta datos anonimizados de process_trajectories, assessments, exercise_sessions para investigación.

Escritura: Inserta nuevos conocimientos en kg_nodes y kg_edges (después de validación).

9.5. BPOS (Behavioral Practice OS)
Lectura: Consulta patients, sessions, appointments, invoices, etc. para el dashboard del terapeuta.

Escritura: Inserta en sessions, session_notes, appointments, todos, etc.

9.6. BCE (Behavioral Commerce Engine)
Lectura: Consulta plans, subscriptions, patients para gestionar suscripciones.

Escritura: Inserta en subscriptions, invoices, payments, coupons.

10. Ejemplos de Consultas y Casos de Uso
10.1. Caso 1: Obtener el perfil completo de un paciente (para el terapeuta)

SELECT 
  p.id, p.first_name, p.last_name, p.age, p.gender,
  t.name AS therapist_name,
  (SELECT COUNT(*) FROM sessions WHERE patient_id = p.id) AS total_sessions,
  (SELECT AVG(score) FROM assessments WHERE patient_id = p.id AND type = 'AAQ-II') AS aaqii_avg,
  (SELECT json_agg(DISTINCT h.description) FROM hypotheses h WHERE h.patient_id = p.id AND h.status = 'activa') AS active_hypotheses,
  (SELECT json_agg(v.name) FROM values v WHERE v.patient_id = p.id) AS values_list
FROM patients p
JOIN therapists t ON p.therapist_id = t.id
WHERE p.id = 'abc-123';

10.2. Caso 2: Trayectoria de un paciente en los últimos 3 meses (para el terapeuta)

SELECT 
  time_bucket('1 week', timestamp) AS week,
  process_name,
  AVG(value) AS avg_value
FROM process_trajectories
WHERE patient_id = 'abc-123'
  AND process_name IN ('Aceptación', 'Defusión', 'Evitación')
  AND timestamp > NOW() - INTERVAL '3 months'
GROUP BY week, process_name
ORDER BY week, process_name;

10.3. Caso 3: Riesgo de abandono (para el sistema y el terapeuta)

SELECT 
  patient_id,
  (1 - (COUNT(DISTINCT date_trunc('day', timestamp)) / 30.0)) AS inactivity_rate,
  (1 - AVG(adherence_metrics.engagement_score)) AS low_engagement_rate,
  (inactivity_rate * 0.6 + low_engagement_rate * 0.4) AS dropout_risk
FROM adherence_metrics
WHERE patient_id IN (
  SELECT id FROM patients WHERE status = 'activo'
)
AND date > NOW() - INTERVAL '30 days'
GROUP BY patient_id
HAVING (inactivity_rate * 0.6 + low_engagement_rate * 0.4) > 0.5
ORDER BY dropout_risk DESC;

10.4. Caso 4: Búsqueda semántica en la base de conocimiento (para el TCCN)

SELECT 
  a.title, a.abstract, 
  1 - (e.embedding <=> query_embedding) AS similarity
FROM article_embeddings e
JOIN articles a ON e.article_id = a.id
WHERE 1 - (e.embedding <=> query_embedding) > 0.7
ORDER BY similarity DESC
LIMIT 5;

11. Políticas de Retención y Purga
Tipo de dato	Período de retención	Purga
Logs de auditoría	2 años	Eliminación automática después de 2 años (archivado opcional).
Telemetría de ejercicios	2 años	Agregación después de 1 año (valores medios) y purga de datos crudos.
Series temporales de procesos	10 años	No se purgan (son datos clínicos).
Expedientes clínicos	10 años (o según legislación)	No se purgan sin consentimiento.
Notas de sesión	10 años	No se purgan.
Conversaciones (TCCN)	2 años	Anonimización después de 2 años.
Archivos (videos, audios)	2 años (o según solicitud)	Purga después de 2 años a menos que se solicite conservar.
Facturas y CFDI	5 años (ley fiscal)	No se purgan.
12. Criterios de Validación y Cumplimiento
Criterio	Métrica	Herramienta
Integridad referencial	100% de las relaciones FK deben estar validadas.	Pruebas de integridad (BQAS).
Trazabilidad	100% de las tablas críticas tienen auditoría.	Auditoría automática.
Cifrado	100% de los datos sensibles están cifrados en reposo.	Inspección de seguridad.
RLS	100% de las tablas tienen políticas RLS activas.	Pruebas de seguridad.
Rendimiento	Consultas < 100 ms (índices adecuados).	Monitoreo de rendimiento.
Disponibilidad	99.9% de uptime para bases de datos.	Monitoreo.
Recuperación	RPO < 1 hora, RTO < 4 horas.	Pruebas de recuperación (chaos engineering).
Retención	Políticas de purga aplicadas correctamente.	Revisión periódica.
13. El Manifiesto de los Datos
"Los datos son la memoria del BehavioralOS. Cada byte cuenta una historia de cambio, de crecimiento, de recaída y de recuperación.

Proteger esos datos no es solo una obligación técnica; es una responsabilidad ética. Cada bit de información clínica pertenece al paciente. Solo lo custodiamos.

Un modelo de datos bien diseñado permite que el sistema aprenda, evolucione y ofrezca intervenciones cada vez más precisas.

Un modelo de datos descuidado convierte al sistema en una máquina de ruido.

Nuestra responsabilidad es mantener la memoria viva, segura y accesible para quienes la necesitan."

## 14. Patrones de Acceso a Datos y POO

### 14.1. Abstracción de Persistencia

Los módulos de negocio (engines, servicios) programan contra **interfaces de repositorio**, no contra implementaciones concretas de base de datos. Esto permite cambiar de PostgreSQL a otro motor sin modificar el código de negocio. El repositorio es el **contrato**; la implementación concreta es un detalle intercambiable.

**Ejemplo**: `BPEEngine` depende de `PatientRepository` (interfaz), no de `PostgresPatientRepository`. Si mañana se migra a CockroachDB, solo cambia la implementación concreta.

### 14.2. Encapsulación de Datos

Nadie accede a las tablas directamente desde fuera del módulo de datos. Toda interacción con la base de datos pasa por **Repositorios (Repository Pattern)** que exponen métodos semánticos del dominio:

- ✅ `patientRepository.activarSuscripcion(patientId)`
- ❌ `db.execute("UPDATE patients SET status = 'active' WHERE id = ?")`

Esto garantiza que las reglas de negocio (ej. no activar un paciente sin consentimiento informado) se apliquen en un solo lugar y no se dupliquen en cada motor que necesite modificar el estado.

### 14.3. Herencia en Modelos de Datos

Donde tiene sentido del dominio se usa herencia (ej. `BaseEntity` → `Patient`, `Therapist`, `Clinic`). Para casos donde la relación es «tiene-un» en vez de «es-un» se prefiere **composición**: objetos embebidos (embedded objects) y JSONB.

**Regla práctica**: si la relación se modela mejor como «X tiene Y», usar composición (JSONB, tabla separada con FK). Si es «X es un Y», usar herencia de entidades base.

### 14.4. Polimorfismo en Consultas

Diferentes implementaciones del mismo contrato de repositorio pueden comportarse distinto según el contexto:

| Implementación | Contexto |
|----------------|----------|
| `PostgresPatientRepository` | Producción |
| `SQLitePatientRepository` | Testing de integración |
| `MockPatientRepository` | Tests unitarios |

El código cliente (un engine de BPE) llama al mismo método `.findByProcessIds()` sin saber qué implementación está usando. El polimorfismo permite probar la lógica de negocio sin base de datos y cambiar la implementación sin tocar el cliente.

### 14.5. Ejemplo Práctico: Repository Pattern en BehavioralOS

```python
# Interfaz abstracta (contrato)
class PatientRepository(ABC):
    @abstractmethod
    def find_by_id(self, patient_id: UUID) -> Patient: ...

    @abstractmethod
    def save(self, patient: Patient) -> None: ...

    @abstractmethod
    def activate_subscription(self, patient_id: UUID) -> None: ...


# Implementación concreta (PostgreSQL)
class PostgresPatientRepository(PatientRepository):
    def __init__(self, db: Database, event_stream: EventStream):
        self.db = db
        self.event_stream = event_stream

    def activate_subscription(self, patient_id: UUID) -> None:
        # Las reglas de negocio se validan ANTES de tocar la DB
        patient = self.find_by_id(patient_id)
        if not patient.consent_signed:
            raise BusinessRuleError(
                "No se puede activar sin consentimiento"
            )
        self.db.execute(
            "UPDATE patients SET subscription_status = 'active' WHERE id = ?",
            patient_id,
        )
        self.event_stream.publish(
            "patient.subscription_activated", {"id": patient_id}
        )
```

El motor de negocio (ej. BCE) nunca importa `PostgresPatientRepository`. Solo conoce `PatientRepository` y recibe la implementación por inyección de dependencias:

```python
class BceEngine:
    def __init__(self, patients: PatientRepository):
        self.patients = patients  # <- no sabe ni le importa si es Postgres, SQLite o mock

    def process_subscription(self, patient_id: UUID) -> None:
        self.patients.activate_subscription(patient_id)
```

15. Historial de Cambios
| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2026-07-01 | Arquitectura de Datos | Creación del documento. Definición del modelo relacional, de grafos, vectorial, de series temporales y de archivos. Establecimiento de políticas de retención, versionado y consistencia. |
| 2.0.0 | 2026-07-14 | Arquitectura de Datos | Agregado de dominio `processes` (process_nodes, process_edges, process_snapshots, process_events, process_domains, process_instruments) para el BPG. Agregado de dominio `streaming` (event_stream, derived_views) para Event Sourcing. Agregadas relaciones, índices, RLS y retención. |
| 2.1.0 | 2026-07-27 | Arquitectura de Datos & Backend | Agregada sección de Patrones de Acceso a Datos y POO (§14): encapsulación con Repository Pattern, abstracción de persistencia, polimorfismo en consultas y herencia en modelos. Incluye ejemplo práctico de `PatientRepository` con implementación PostgreSQL y consumo desde BCE. |
| 2.2.0 | 2026-08-12 | Arquitectura de Datos & Backend | Agregadas al dominio `commerce`: `leads` (SLS-001), `support_tickets` y `consent_log` (AI-007, change `landing-ia-atencion` slice 2). `support_tickets` y `consent_log` ya existen en el codebase implementado (T2.6); `leads` formaliza el formulario SLS-001-REC-003. |

Fin del documento data-model.md