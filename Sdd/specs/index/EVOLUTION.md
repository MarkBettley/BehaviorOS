---
id: EVO-001
title: BehavioralOS - Evolution, Changelog & RFC Registry
version: 2.3.0
status: Stable
owner: Arquitectura Jefe
last_updated: 2026-08-12
---

# BehavioralOS – Evolution, Changelog & RFC Registry

> *"El progreso se mide en cambios. Cada modificación, cada ajuste, cada mejora queda registrada en este documento. No importa si es grande o pequeño; todo cambio es un paso hacia adelante. Las decisiones importantes se documentan como RFCs, y el historial completo del proyecto se mantiene vivo para que cualquier agente de IA o desarrollador pueda entender cómo hemos llegado hasta aquí."*

---

## 📋 Tabla de Contenidos

1. [Versión Actual](#versión-actual)
2. [Resumen del Proyecto](#resumen-del-proyecto)
3. [Changelog por Versión](#changelog-por-versión)
4. [Registro de RFCs (Request for Comments)](#registro-de-rfcs-request-for-comments)
5. [Métricas de Evolución](#métricas-de-evolución)
6. [Historial del Documento](#historial-del-documento)

---

## Versión Actual

| Campo | Valor |
|-------|-------|
| **Versión** | `2.3.0` |
| **Fecha** | `2026-08-12` |
| **Estado** | `Estable - Behavioral Clinical Operating System` |
| **Próxima versión planificada** | `2.4.0` (siguiente iteración de construcción) |
| **Total de documentos** | `~83` |
| **Total de módulos** | `~22-25` |

---

## Resumen del Proyecto

**BehavioralOS** es una plataforma de psicoterapia gamificada basada en procesos, con IA on-device, evaluación adaptativa, y experiencias inspiradas en Nintendo para pacientes y Apple para terapeutas.

### Hitos alcanzados

| Hito | Fecha | Descripción |
|------|-------|-------------|
| **Inicio del proyecto** | 2026-06-01 | Conceptualización inicial y definición de la visión. |
| **Arquitectura definida** | 2026-06-15 | BEA, capas, dominios y principios arquitectónicos. |
| **Ontología completada** | 2026-06-20 | Ontología formal del comportamiento (RFT, PBT, AEC). |
| **Especificación completa** | 2026-07-02 | 51 documentos, 15 módulos, estructura completa. |
| **Núcleo de procesos** | 2026-07-14 | Nuevo núcleo clínico: BPE, BPO, BPG, BXE, BIK, BCMS ampliado, BCIE, BCOE, BSI. |

---

## Changelog por Versión

### v3.0.0 (2026-07-23) — Reorganización por niveles de implementación

**Cambio mayor:** Reordenamiento completo de la prioridad de implementación en 4 niveles.

**Nivel 1 (MVP Funcional):** 000-Core, 000-Infrastructure, 900-Security, 200-Backend, 300-Frontend
**Nivel 2 (Valor Clínico):** 700-PracticeOS, 500-Experiences, 400-AI (básico)
**Nivel 3 (Inteligencia):** 100-Architecture, BPO/BPG, 400-AI (completo)
**Nivel 4 (Plataforma Completa):** 800-Analytics, 600-Commerce, 1300-Libraries, 1000-Integration, 1200-Deployment, 1100-Testing

**Impacto:**
- `master.yaml` actualizado: nuevo `build_order` con niveles
- `index.yaml` de cada módulo sin cambios (los specs no se tocan, solo su prioridad de implementación)
- Todos los módulos congelados en los niveles 2-4 mantienen sus specs intactos

---

### [2.3.0] - 2026-08-12 — Estandarización de runtime on-device + roadmap de construcción

#### 🎉 **Añadido (index)**

- **BRD-001** (`build-roadmap.md`): spec del roadmap de construcción por fases y niveles — dependencias del grafo de comportamiento, arranque en frío y sucesión de implementación.

#### ⚠️ **AMENDMENT de runtime (Norma Vinculante)**

- **Runtime estandarizado a on-device (Gemma + MediaPipe) en todo el módulo 400-AI.** Esta entrada **corrige explícitamente** la descripción del AI-007 en la entrada `[2.2.0]` ("Gemma 4 + vLLM, streaming SSE... Sin inferencia en navegador (no WebGPU/ONNX)"), que queda sustituida por la nueva norma: **no hay vLLM/Ollama, ni servidor privado, ni inferencia embebida en navegador (WebGPU/ONNX)**. El streaming SSE/WebSocket se conserva, originado desde el runtime del dispositivo.

#### 🔧 **Modificado**

- `400-AI/ai-core.md` — AI-001 v2.1.0: runtime on-device (Gemma + MediaPipe), pipeline, métricas y referencias actualizados; SUPERSEDE vLLM/Ollama y servidor privado.
- `400-AI/ai-007-support.md` — AI-007 v1.1.0: runtime estandarizado a on-device; SUPERSEDE la decisión previa de servidor privado (Gemma 4 + vLLM) de la v1.0.0.
- `400-AI/guardrails.md` — AI-004 v2.1.0: referencia de runtime de AI-001 estandarizada a on-device.
- `400-AI/event-sourcing-ai.md` — AI-006 v1.1.0: referencia de runtime de AI-001 estandarizada a on-device; diagrama de emisión corregido.
- `400-AI/index.yaml` — v2.2.0: descripciones, exportaciones y tags de runtime alineados a on-device.
- `index/master.yaml` — reconciliado a `project.version: 2.2.0`.
- `index/behavioral-graph.yaml` — añadidos nodos BRD-001/IDX-007, AI-006, AI-007 y SLS-001 con sus aristas `depends_on` (AI-007 → AI-001/AI-004/AI-006/API-001/DB-001/SLS-001; SLS-001 → AI-007; IDX-007 → IDX-001).

#### 📝 **Nota**

- Corrección de consistencia: la entrada `[2.2.0]` documentaba el AI-007 con runtime vLLM; la norma on-device del 2026-08-12 la sustituye. Las entradas previas del changelog permanecen intactas como registro histórico.

---

### [2.2.0] - 2026-08-12 — Change `landing-ia-atencion` (aplicación del slice 2)

#### 🎉 **Añadido (400-AI)**

- **AI-007** (`ai-007-support.md`): spec de Soporte y Atención por IA (support chat) — canal conversacional para reportar errores y proponer mejoras en la landing y las apps. Runtime sobre AI-001 (Gemma 4 + vLLM, streaming SSE), clasificación de intents (error/improvement), tickets en `support_tickets`, consentimiento en `consent_log`, escalamiento vía `POST /api/v1/ai/escalation` y guardrails (AI-004). Sin inferencia en navegador (no WebGPU/ONNX).
- Registro del nodo AI-007 en `400-AI/index.yaml` y `master.yaml` (status: `Specified`).

#### 🔧 **Modificado**

- `600-Commerce/service-landing.md` — AMENDMENT v1.1.0: la landing aloja el widget de soporte IA (AI-007); el formulario sigue siendo el único canal comercial. Nuevo SLS-001-REC-006; REC-004, exports, alcance y trazabilidad actualizados. Estado promovido a `Stable`.
- `300-Frontend/pwa-architecture.md` — PWA-001 v1.1.0: añadida §7 Instalación y Aterrizaje de la PWA (beforeinstallprompt, instalación por plataforma, UX de instalación). Secciones 8-13 renumeradas.
- `300-Frontend/patient-app.md` — puntero a la guía de instalación (PWA-001 §7) en "Ayuda y soporte".
- `200-Backend/database-graph.md` — DB-001 v1.1.0: tablas `leads` (§4.3.6), `support_tickets` (§4.3.7) y `consent_log` (§4.3.8) en el esquema commerce.
- `100-Architecture/data-model.md` — DM-001 v2.2.0: registradas `leads`, `support_tickets` y `consent_log` en el dominio commerce.
- `200-Backend/api-graph.md` — API-001 v1.1.0: `POST /leads` y endpoints de escalación de soporte (`POST /ai/escalation`, `GET /ai/escalation/{ticket_id}`, `GET /ai/escalation`).
- `400-AI/index.yaml` — añadido el hijo `ai-007-support.md`, exportación de soporte por IA, tags y validaciones. La implementación del módulo permanece congelada hasta Nivel 2.

#### 📝 **Nota**

- Continuación del delta `landing-ia-atencion` (obs #262). En este slice se materializan AI-007, la sección de instalación de la PWA y la enmienda de SLS-001 (widget de soporte).
- `support_tickets` y `consent_log` ya existían en el codebase implementado (T2.6 del mismo change); este slice formaliza su contrato en la especificación.

---

### [2.1.0] - 2026-08-07 — Change `landing-ia-atencion` (aplicación del slice 1)

#### 🎉 **Añadido (600-Commerce)**

- **SLS-001** (`service-landing.md`): spec de la landing del servicio — un dominio, dos audiencias (pacientes / clínicas y psicólogos), contenido informativo veraz no clínico, formulario de leads con validación/consentimiento, SEO básico + WCAG AA + Lighthouse ≥90, sin chatbot.
- Registro del nodo SLS-001 en `600-Commerce/index.yaml` y `master.yaml`.

#### 🔧 **Modificado**

- `600-Commerce/index.yaml` — Añadido el hijo `service-landing.md` y exportaciones del SLS/formulario de leads.
- `master.yaml` — `600-Commerce` depende ahora de `300-Frontend` (BDS-001) y lista `service-landing.md`.

#### 📝 **Nota**

- Cambio de specs: este change es la materialización del delta `landing-ia-atencion` (specs del 400-AI/300-Frontend quedaron definidos en el delta #262). Solo se materializa en 600-Commerce dentro de este slice.
- El módulo 400-AI y su modificación (AI-001-REC-RUNTIME/PATHS, AI-002-REC-RUNTIME, PAT-001/UI-001-REC-ASISTENTE) se normaliza en el slice 2, no aquí.

---

### [2.0.0] - 2026-07-14

#### 🎉 **Añadido**

**Núcleo de Procesos Clínicos (Nivel 2 del Roadmap)**

- **BPE** (Behavioral Process Engine): Motor central de procesos psicológicos.
- **BPO** (Behavioral Process Ontology): Ontología formal de procesos (ACT, FAP, DBT, Gottman, etc.).
- **BPG** (Behavioral Process Graph): Grafo de relaciones entre procesos psicológicos.
- **BXE** (Behavioral Explainability Engine): Motor de explicabilidad de decisiones de IA.
- **BIK** (Behavioral Intervention Kit): Kit de intervenciones estandarizadas.
- **BCIE** (Behavioral Caseload Intelligence Engine): 15 submotores de inteligencia de carga clínica, BCLI y BCoI.
- **BCOE** (Behavioral Clinic Operations Engine): 18 submotores de operaciones del negocio.
- **BSI** (Behavioral Scheduling Intelligence): 16 submotores de programación inteligente de citas.

**Ampliación del BCMS**

- Transformación de BPOS (v1.0.0) a BCMS (v2.0.0): Behavioral Clinical Operating System.
- 20 submódulos clínicos detallados.
- Ciclo clínico completo: Paciente nuevo → Preentrevista → Evaluación → Formulación → Plan → Sesiones → Seguimiento → Alta → Post-alta.
- Separación clínico-operativo (Clinical Core vs Operations Core).
- Filosofía: "El psicólogo nunca debería perder tiempo administrando información".

**Documentos nuevos en `specs/700-PracticeOS/`**

- `bcms-detailed.md` — Especificación completa de los 20 submódulos del BCMS.
- `bcie-spec.md` — BCIE: inteligencia de carga clínica (15 submotores).
- `bcoe-spec.md` — BCOE: motor de operaciones del negocio (18 submotores).
- `bsi-spec.md` — BSI: programación inteligente de citas (16 submotores).

#### 🔧 **Modificado**

- `master.yaml` — Actualizado con nuevos módulos y dependencias del núcleo de procesos.
- `behavioral-graph.yaml` — Expandido con nodos BPE, BPO, BPG, BXE, BIK, BCIE, BCOE, BSI.
- `ai-reading-profiles.yaml` — Nuevo perfil de lectura para el núcleo de procesos clínicos.
- `system-architecture.md` — Ampliado con la separación Clinical Core / Operations Core.
- `engines-overview.md` — Actualizado con BCIE, BCOE, BSI, BXE, BIK como motores de primer nivel.
- `data-model.md` — Nuevas entidades: Caseload, Scheduling, Operations, Process Graph.
- `ontology.md` — Ampliado con la BPO (ontología formal de procesos) y BPG (grafo de procesos).

#### 📝 **RFCs asociados**

- **RFC-002**: Aprobación del nuevo núcleo de procesos clínicos (BPE, BPO, BPG, BXE, BIK) y submódulos del BCMS (BCIE, BCOE, BSI). (Estado: Aceptado)

---

### [1.0.0] - 2026-07-02

#### 🎉 **Añadido**

**Arquitectura Central**
- Creación de la carpeta `index/` con los archivos maestros:
  - `master.yaml` – Grafo maestro del proyecto.
  - `ai-reading-profiles.yaml` – Perfiles de lectura para agentes de IA.
  - `behavioral-graph.yaml` – Grafo de dependencias entre documentos.
  - `environment-variables.md` – Lista completa de variables de entorno.
  - `README.md` – Guía de inicio rápido y documentación general.
  - `EVOLUTION.md` – Este archivo (Changelog, historial y RFCs).

**Módulo 000-Core (Núcleo Filosófico)**
- `philosophy.md` – Misión, visión, valores y fantasía central (Nintendo de la psicoterapia).
- `principles.md` – 12 principios de diseño, 10 reglas éticas, reglas Nintendo y Hayes.
- `vocabulary.md` – Diccionario controlado (palabras prohibidas y permitidas).
- `ontology.md` – Ontología formal del comportamiento (entidades, procesos, RFT, relaciones).

**Módulo 000-Infrastructure**
- `selection.md` – Selección de herramientas gratuitas y plan de migración.

**Módulo 100-Architecture**
- `system-architecture.md` – BEA: capas, dominios, principios y contratos.
- `engines-overview.md` – BREO: catálogo de motores y frameworks (25+ motores).
- `behavioral-twin.md` – Behavioral Twin: modelo dinámico del paciente.
- `data-model.md` – Modelo de datos relacional, de grafos, vectorial y de series temporales.

**Módulo 200-Backend**
- `api-graph.md` – APIs REST, WebSockets, contratos y versionado.
- `database-graph.md` – Esquemas, tablas, índices, RLS y migraciones.
- `events-and-workflows.md` – Eventos, workflows, Sagas y Temporal.io.
- `transaction-engine.md` – Motor de consistencia transaccional (idempotencia, Sagas).

**Módulo 300-Frontend**
- `design-system.md` – BDS: tokens, componentes, patrones Nintendo/Apple.
- `ui-graph.md` – Mapa de pantallas y navegación (paciente y terapeuta).
- `accessibility.md` – WCAG, adaptaciones cognitivas (TEA, TDAH, dislexia).
- `patient-app.md` – Experiencia Nintendo para pacientes.
- `therapist-app.md` – Experiencia Apple para terapeutas.
- `ahee-implementation.md` – Integración del motor adaptativo AHEE.
- `brand-studio.md` – Personalización de identidad visual de terapeutas y clínicas.

**Módulo 400-AI**
- `ai-core.md` – Gemma, MediaPipe, Whisper, inferencia local on-device.
- `companion.md` – TCCN: compañero terapéutico con personalidad clínica.
- `adaptive-orchestrator.md` – AAO: evaluación adaptativa continua y multimodal.
- `guardrails.md` – Guardrails clínicos y de seguridad (pipeline de validación).
- `rag-knowledge-graph.md` – BKGE + BSC: conocimiento científico y RAG.

**Módulo 500-Experiencies**
- `experience-engine.md` – BERL: laboratorio de ejercicios gamificados.
- `mechanics-library.md` – BML: 40+ mecánicas universales (7 familias).
- `process-engine.md` – Motor de procesos psicológicos y Learning Graph.
- `clinical-processes.md` – Mapeo de intervenciones clínicas (ACT, FAP, DBT, etc.).

**Módulo 600-Commerce**
- `business-model.md` – BCE: suscripciones, pagos, CFDI, marketplace.
- `website-builder.md` – Constructor de sitios web para terapeutas (drag & drop).

**Módulo 700-PracticeOS**
- `practice-os.md` – BPOS: agenda, EHR, videoterapia, CRM, workflows.
- `automation-studio.md` – Editor visual de workflows (automatización sin código).
- `relationship-engine.md` – CRM avanzado y motor de relaciones con pacientes.

**Módulo 800-Analytics**
- `outcomes-analytics.md` – BIP: dashboards, KPIs, modelos predictivos.
- `research-platform.md` – BROS: investigación, experimentos, simulación.

**Módulo 900-Security**
- `security.md` – BSOS: identidad, permisos, consentimientos, cifrado, auditoría.

**Módulo 1000-Integration**
- `bril-spec.md` – BRIL: Event Bus, adaptadores, colas, sincronización.

**Módulo 1100-Testing**
- `bqas-spec.md` – BQAS: pruebas unitarias, integración, clínicas, científicas, IA, seguridad.

**Módulo 1200-Deployment**
- `devops-spec.md` – DevOps: CI/CD, contenedores, monitoreo, backups.

#### 🔧 **Modificado**
- Ninguno (versión inicial).

#### 🗑️ **Eliminado**
- Ninguno (versión inicial).

#### 📝 **RFCs asociados**
- **RFC-001**: Aprobación de la arquitectura completa del BehavioralOS. (Estado: Aceptado)

---

## Registro de RFCs (Request for Comments)

Los RFCs documentan decisiones importantes de diseño y cambios significativos en el proyecto. Cada RFC incluye:
- **ID único**
- **Fecha de creación**
- **Autor**
- **Descripción del cambio propuesto**
- **Estado**: `Propuesto`, `En revisión`, `Aceptado`, `Rechazado`, `Implementado`
- **Impacto**: Módulos afectados
- **Decisión final** (si está aceptado o rechazado)
- **Fecha de implementación** (si aplica)

---

### RFC-001: Aprobación de la arquitectura completa del BehavioralOS

| Campo | Valor |
|-------|-------|
| **ID** | `RFC-001` |
| **Fecha de creación** | `2026-06-15` |
| **Autor** | `Arquitectura Jefe` |
| **Descripción** | Aprobación de la arquitectura completa del BehavioralOS, incluyendo la BEA, los 14 módulos, la ontología y las tecnologías principales. |
| **Estado** | ✅ `Aceptado` |
| **Impacto** | Todos los módulos |
| **Decisión final** | La arquitectura fue aprobada en su totalidad. Se procede con la especificación detallada de cada módulo. |
| **Fecha de implementación** | `2026-06-15` |

---

### RFC-002: Aprobación del nuevo núcleo de procesos clínicos y submódulos del BCMS

| Campo | Valor |
|-------|-------|
| **ID** | `RFC-002` |
| **Fecha de creación** | `2026-07-14` |
| **Autor** | `Arquitectura de Práctica Clínica` |
| **Descripción** | Aprobación del nuevo núcleo de procesos clínicos (BPE, BPO, BPG, BXE, BIK) y los submódulos del BCMS (BCIE con 15 submotores, BCOE con 18 submotores, BSI con 16 submotores). Transformación de BPOS a BCMS como Behavioral Clinical Operating System. Separación clínico-operativo. |
| **Estado** | ✅ `Aceptado` |
| **Impacto** | 700-PracticeOS (BCMS, BCIE, BCOE, BSI), 000-Core (BPO, BPG), 100-Architecture (system-architecture, engines-overview, data-model), index/ (master.yaml, behavioral-graph.yaml, ai-reading-profiles.yaml) |
| **Decisión final** | Se aprueba la creación del núcleo de procesos y la transformación del BCMS. Se establece la separación clínico-operativo como principio arquitectónico. |
| **Fecha de implementación** | `2026-07-14` |

---

## Métricas de Evolución

| Métrica | Valor | Fecha |
|---------|-------|-------|
| **Total de documentos** | `~65` | 2026-07-14 |
| **Total de módulos** | `~22-25` | 2026-07-14 |
| **Total de RFCs** | `2` (activos) | 2026-07-14 |
| **Líneas de especificación** | `~45,000` (estimado) | 2026-07-14 |
| **Cobertura de conceptos del PDF** | `100%` | 2026-07-14 |

### Proyección de crecimiento

| Fase | Documentos estimados | Módulos estimados | Fecha estimada |
|------|---------------------|-------------------|----------------|
| **Especificación completa** | `51` | `15` | 2026-07-02 |
| **Núcleo de procesos (Nivel 2)** | `~65` | `~22-25` | 2026-07-14 |
| **Implementación del backend** | `~80` | `~25` | 2026-08-15 |
| **Implementación del frontend** | `~95` | `~25` | 2026-09-30 |
| **Implementación de IA y juegos** | `~110` | `~25` | 2026-11-15 |
| **Despliegue en producción** | `~120` | `~25` | 2026-12-31 |

---

## Historial del Documento

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2026-07-02 | Arquitectura Jefe | Creación del documento. Registro inicial del proyecto y RFC-001. |
| 2.0.0 | 2026-07-14 | Arquitectura Jefe | Agregada entrada v2.0.0: Núcleo de procesos clínicos (BPE, BPO, BPG, BXE, BIK), BCMS ampliado, BCIE, BCOE, BSI. RFC-002. Actualizadas métricas y proyecciones. |
| 2.1.0 | 2026-08-07 | Arquitectura Jefe | Entrada v2.1.0: change `landing-ia-atencion` slice 1 — nuevo SLS-001 (service-landing.md) en 600-Commerce, índices actualizados. |
| 2.2.0 | 2026-08-12 | Arquitectura Jefe | Entrada v2.2.0: change `landing-ia-atencion` slice 2 — nuevo AI-007 (ai-007-support.md) en 400-AI, AMENDMENT SLS-001 v1.1.0 (widget de soporte), PWA-001 §7 instalación, tablas leads/support_tickets/consent_log y endpoints de escalación. |
| 2.3.0 | 2026-08-12 | Arquitectura Jefe | Entrada v2.3.0: estandarización de runtime on-device (Gemma + MediaPipe) en todo el módulo 400-AI, corrigiendo la descripción de runtime del AI-007 de la v2.2.0; nuevo BRD-001 (build-roadmap.md); nodos y aristas en behavioral-graph.yaml; master.yaml reconciliado a 2.2.0. |

---

**Fin del documento `EVOLUTION.md`**
