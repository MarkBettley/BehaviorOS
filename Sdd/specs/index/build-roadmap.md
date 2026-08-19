---
id: BRD-001
title: BehavioralOS - Roadmap de Construcción por Fases y Niveles
version: 1.0.0
status: Specified
owner: Arquitectura Jefe
last_updated: 2026-08-12
---

# BehavioralOS – Roadmap de Construcción por Fases y Niveles

> *"El plan de construcción no es una lista de deseos: es una secuencia. Cada Fase desbloquea la siguiente, cada Nivel tiene una definición de hecho clara, y cada entregable es verificable. Un desarrollador debe poder leer este documento y empezar a codificar sin preguntar '¿por dónde empiezo?'."*

---

## 1. Propósito

Este documento convierte el `build_order` de `master.yaml` en un **plan de construcción accionable**: Fases (macro-etapas) compuestas por Niveles (sub-etapas construibles). Para cada Nivel se define:

- **Módulos concretos** (ID + nombre) y **specs concretos** (archivos).
- **Criterios de entrada**: qué debe existir antes de empezar.
- **Criterios de salida (Definition of Done)**: qué debe ser verificable al terminar.
- **Entregable esperado**: qué se produce en concreto.

Este roadmap **no modifica especificaciones**: solo organiza su prioridad de implementación. Los módulos congelados en `master.yaml` (`implementation_status: Frozen`) se desbloquean cuando su Nivel inicia.

---

## 2. Cómo usar este documento

1. Las **Fases** son macro-etapas (Fundamentos → MVP → Valor Clínico → Inteligencia → Plataforma). No se salta una Fase.
2. Los **Niveles** se construyen en orden dentro de su Fase. Un Nivel está completo solo cuando se cumplen **todos** sus criterios de salida.
3. El **entregable** de cada Nivel es verificable por QA/Testing (mínimo smoke tests desde el Nivel 1.1).
4. Las funcionalidades que se construyen antes que su módulo completo (por ejemplo SLS-001 en Fase 1 y 600-Commerce en Fase 4) se marcan explícitamente en la §3 y se justifican en la §4.

### Resumen de Fases

| Fase | Nombre | Enfoque | Niveles |
|------|--------|---------|---------|
| 0 | Fundamentos | Referencia y base de infraestructura | 0.1 – 0.2 |
| 1 | MVP Funcional | Una funcionalidad end-to-end + presencia pública | 1.1 – 1.5 |
| 2 | Valor Clínico | Gestión de pacientes, experiencias e IA de soporte | 2.1 – 2.3 |
| 3 | Inteligencia | Event sourcing, Behavioral Twin, BPO/BPG, IA completa | 3.1 – 3.3 |
| 4 | Plataforma Completa | Analítica, comercio, librerías, integración, despliegue, testing | 4.1 – 4.6 |

---

## 3. Fases y Niveles de Construcción

### 3.1. Fase 0 — Fundamentos

#### Nivel 0.1 — Referencia filosófica y ontológica

| Campo | Contenido |
|-------|-----------|
| **Módulos** | `000-Core` — Núcleo Filosófico y Ontológico |
| **Specs** | `000-Core/philosophy.md`, `000-Core/principles.md`, `000-Core/vocabulary.md`, `000-Core/ontology.md` |
| **Criterios de entrada** | Ninguno (prerequisito conceptual de todo el proyecto). |
| **Criterios de salida (DoD)** | Misión, visión, principios, ontología y vocabulario controlado disponibles y legibles por el equipo y los agentes de IA. |
| **Entregable** | Documentación de referencia (no se implementa: se consulta). |

#### Nivel 0.2 — Infraestructura base

| Campo | Contenido |
|-------|-----------|
| **Módulos** | `000-Infrastructure` — Infraestructura y Selección Tecnológica |
| **Specs** | `000-Infrastructure/selection.md`, `index/environment-variables.md` |
| **Criterios de entrada** | Nivel 0.1 disponible como referencia. |
| **Criterios de salida (DoD)** | Repositorio creado; Docker Compose con Supabase (Postgres + Auth + Storage) levantable localmente; variables de entorno definidas; dominio configurado. |
| **Entregable** | Entorno de desarrollo reproducible (`docker compose up`). |

---

### 3.2. Fase 1 — MVP Funcional

**Objetivo:** una sola funcionalidad end-to-end: **auth + 1 ejercicio terapéutico**, más la presencia pública (landing). Cuando Fase 1 tenga usuarios, se entra en Fase 2.

#### Nivel 1.1 — Seguridad y autenticación

| Campo | Contenido |
|-------|-----------|
| **Módulos** | `900-Security` — Seguridad y Gobernanza (BSOS) |
| **Specs** | `900-Security/security.md` |
| **Criterios de entrada** | Nivel 0.2 (infraestructura base). |
| **Criterios de salida (DoD)** | Registro, login y JWT funcionales; RLS activo en Postgres; roles básicos (paciente); consentimiento mínimo; auditoría de accesos; pruebas de seguridad básicas. |
| **Entregable** | Auth de paciente de punta a punta (backend + RLS) con tests. |

#### Nivel 1.2 — Backend mínimo

| Campo | Contenido |
|-------|-----------|
| **Módulos** | `200-Backend` — Backend y Servicios |
| **Specs** | `200-Backend/api-graph.md`, `200-Backend/database-graph.md`, `200-Backend/transaction-engine.md`; `200-Backend/events-and-workflows.md` (mínimo) |
| **Criterios de entrada** | Nivel 1.1 (auth disponible). |
| **Criterios de salida (DoD)** | API REST FastAPI con endpoints de auth y de 1 ejercicio terapéutico; esquema en Supabase; telemetría mínima del ejercicio persistida; contrato OpenAPI versionado. |
| **Entregable** | Backend desplegable localmente, consumible por el frontend. |

#### Nivel 1.3 — Frontend básico

| Campo | Contenido |
|-------|-----------|
| **Módulos** | `300-Frontend` — Frontend y Experiencia de Usuario |
| **Specs** | `300-Frontend/design-system.md`, `300-Frontend/ui-graph.md`, `300-Frontend/pwa-architecture.md` (base + §7 instalación), `300-Frontend/patient-app.md` (pantalla inicial) |
| **Criterios de entrada** | Nivel 1.2 (API disponible). |
| **Criterios de salida (DoD)** | Login + dashboard con 1 ejercicio; PWA instalable (`beforeinstallprompt`, manifest, Service Worker básico, guía de instalación PWA-001 §7); accesibilidad WCAG AA básica; vocabulario controlado respetado. |
| **Entregable** | SPA React (Tailwind + Framer Motion) instalable como PWA. |

#### Nivel 1.4 — Ejercicio end-to-end

| Campo | Contenido |
|-------|-----------|
| **Módulos** | `200-Backend` + `300-Frontend` + `900-Security` (integración) |
| **Specs** | Las de los Niveles 1.1–1.3 (integración, sin specs nuevos). |
| **Criterios de entrada** | Niveles 1.1, 1.2 y 1.3 completos. |
| **Criterios de salida (DoD)** | Un ejercicio terapéutico se ejecuta de principio a fin: autenticado, iniciado, completado y con telemetría persistida y consultable. |
| **Entregable** | **MVP funcional** usable por un primer grupo de usuarios. |

#### Nivel 1.5 — Presencia pública (landing)

| Campo | Contenido |
|-------|-----------|
| **Módulos** | `600-Commerce` — Motor Comercial (únicamente SLS-001; el resto del módulo sigue congelado) |
| **Specs** | `600-Commerce/service-landing.md`; soporte en `200-Backend/api-graph.md` (`POST /leads`); diseño desde `300-Frontend/design-system.md` |
| **Criterios de entrada** | Nivel 1.2 (endpoint de leads disponible). |
| **Criterios de salida (DoD)** | Landing de un dominio con dos audiencias; formulario de leads con validación, deduplicación y consentimiento; SEO básico (sitemap, metadata); Lighthouse ≥90; WCAG AA; **sin chatbot comercial** (el único componente conversacional será el widget AI-007 en Fase 2). |
| **Entregable** | Landing pública en producción como superficie de adquisición. |

---

### 3.3. Fase 2 — Valor Clínico

**Objetivo:** gestión de pacientes, más ejercicios y companion/soporte IA básico. Cuando Fase 2 tenga datos, se entra en Fase 3.

#### Nivel 2.1 — BCMS (PracticeOS)

| Campo | Contenido |
|-------|-----------|
| **Módulos** | `700-PracticeOS` — Behavioral Clinical Management System (BCMS); submotores `BSI` |
| **Specs** | `700-PracticeOS/practice-os.md`, `700-PracticeOS/bcms-detailed.md`, `700-PracticeOS/automation-studio.md`, `700-PracticeOS/relationship-engine.md`, `700-PracticeOS/bsi-spec.md` |
| **Criterios de entrada** | Fase 1 completa (usuarios reales). |
| **Criterios de salida (DoD)** | CRUD de pacientes, asignación a terapeuta, historial y expediente mínimo; agenda; separación Clinical Core / Operations Core respetada; automatizaciones básicas. |
| **Entregable** | Consultorio clínico operativo para terapeutas. |

#### Nivel 2.2 — Experiencias terapéuticas

| Campo | Contenido |
|-------|-----------|
| **Módulos** | `500-Experiences` — Experiencias Terapéuticas y Gamificación (BERL, BML, motor de procesos) |
| **Specs** | `500-Experiences/experience-engine.md`, `500-Experiences/mechanics-library.md`, `500-Experiences/process-engine.md`, `500-Experiences/clinical-processes.md` |
| **Criterios de entrada** | Nivel 2.1 (pacientes asignados). |
| **Criterios de salida (DoD)** | Biblioteca de ejercicios interactivos con telemetría conectada a pacientes; ejercicios organizados por procesos (no por terapias); mapeo clínico por proceso. |
| **Entregable** | Patient App con ejercicios reales generando datos. |

#### Nivel 2.3 — IA de soporte y companion básico

| Campo | Contenido |
|-------|-----------|
| **Módulos** | `400-AI` — Inteligencia Artificial (Support Chat `AI-007` + companion básico `AI-002`) |
| **Specs** | `400-AI/ai-007-support.md`, `400-AI/companion.md` (mínimo), `400-AI/ai-core.md` (runtime `AI-001`) |
| **Criterios de entrada** | Niveles 2.1–2.2; `SLS-001` (Nivel 1.5) para el widget de la landing. |
| **Criterios de salida (DoD)** | Support chat funcional en landing y apps (intents `error` / `improvement`); tickets en `support_tickets`; consentimiento en `consent_log`; escalamiento a humano; companion básico por reglas (sin IA generativa plena); guardrails aplicados (intents commercial/therapeutic redirigidos). |
| **Entregable** | Canal de soporte por IA operativo. |

---

### 3.4. Fase 3 — Inteligencia

**Objetivo:** IA generativa, Behavioral Twin y grafo de procesos. Cuando Fase 3 esté consolidado, se entra en Fase 4.

#### Nivel 3.1 — Event Sourcing y Behavioral Twin

| Campo | Contenido |
|-------|-----------|
| **Módulos** | `100-Architecture` — Arquitectura del Sistema (BEA, Twin, BIK, BXE) |
| **Specs** | `100-Architecture/system-architecture.md`, `100-Architecture/event-sourcing-architecture.md`, `100-Architecture/behavioral-twin.md`, `100-Architecture/data-model.md`, `100-Architecture/engines-overview.md`, `100-Architecture/bik-architecture.md`, `100-Architecture/bxe-spec.md` |
| **Criterios de entrada** | Fase 2 (datos de pacientes y telemetría). |
| **Criterios de salida (DoD)** | Event Stream como system of record; Behavioral Twin operativo por paciente; explicabilidad BXE trazable; modelo de datos de eventos coherente. |
| **Entregable** | Backend orientado a eventos con Twin consultable. |

#### Nivel 3.2 — Ontología y Grafo de Procesos (BPO/BPG)

| Campo | Contenido |
|-------|-----------|
| **Módulos** | `000-Core` (BPO, BPG, BPE) |
| **Specs** | `000-Core/bpo-ontology.md`, `000-Core/bpg-spec.md`, `000-Core/behavioral-process-engine.md` |
| **Criterios de entrada** | Nivel 3.1. |
| **Criterios de salida (DoD)** | Ontología de procesos poblada con evidencia científica; grafo dirigido dinámico por individuo/pareja/familia/sistema (NetworkX + PostgreSQL); versionado semántico de procesos. |
| **Entregable** | BPG consultable por la IA, los dashboards y los juegos. |

#### Nivel 3.3 — IA completa

| Campo | Contenido |
|-------|-----------|
| **Módulos** | `400-AI` — Inteligencia Artificial y Motores Cognitivos |
| **Specs** | `400-AI/ai-core.md` (Gemma + MediaPipe on-device), `400-AI/guardrails.md`, `400-AI/adaptive-orchestrator.md`, `400-AI/rag-knowledge-graph.md`, `400-AI/event-sourcing-ai.md` |
| **Criterios de entrada** | Niveles 3.1 y 3.2. |
| **Criterios de salida (DoD)** | Inferencia on-device (Gemma + MediaPipe) con constrained decoding; RAG con BSC/BKGE; AAO (evaluación adaptativa) con Confidence Engine; guardrails con Crisis Interceptor (>99% recall); 7 motores derivados procesando eventos. |
| **Entregable** | IA clínica completa, explicable y alineada a la ontología. |

---

### 3.5. Fase 4 — Plataforma Completa

**Objetivo:** comercio, analytics, librerías, integración, despliegue y testing refinado.

#### Nivel 4.1 — Analítica y ciencia

| Campo | Contenido |
|-------|-----------|
| **Módulos** | `800-Analytics` — Inteligencia Analítica y Científica (BIP, BROS) |
| **Specs** | `800-Analytics/outcomes-analytics.md`, `800-Analytics/research-platform.md` |
| **Criterios de entrada** | Fase 3 (datos y eventos maduros). |
| **Criterios de salida (DoD)** | Dashboards de KPIs por proceso; modelos predictivos; plataforma de investigación con experimentos. |
| **Entregable** | Inteligencia de resultados consumible por terapeutas y clínicas. |

#### Nivel 4.2 — Comercio completo

| Campo | Contenido |
|-------|-----------|
| **Módulos** | `600-Commerce` — Motor Comercial (BCE, LIC, BWB). SLS-001 ya desplegado desde Fase 1. |
| **Specs** | `600-Commerce/business-model.md`, `600-Commerce/licensing-system.md`, `600-Commerce/website-builder.md` |
| **Criterios de entrada** | Fase 3 consolidada; Nivel 1.5 (landing) vigente. |
| **Criterios de salida (DoD)** | Suscripciones por vertical; pagos (Stripe/Mercado Pago) idempotentes; CFDI 4.0; marketplace (5% comisión, 0% terapia); licencias con RBAC y revocación <1 minuto; Website Builder accesible. |
| **Entregable** | Motor comercial completo e integrado con BCMS y seguridad. |

#### Nivel 4.3 — Bibliotecas de código

| Campo | Contenido |
|-------|-----------|
| **Módulos** | `1300-Libraries` — Arquitectura de Bibliotecas |
| **Specs** | `1300-Libraries/libraries.md`, `1300-Libraries/strict_spec_schema.md`, `1300-Libraries/template_library.md`, `1300-Libraries/bcl_complete_implementation.md` |
| **Criterios de entrada** | Fases 1–3 (patrones reales de uso). |
| **Criterios de salida (DoD)** | 72 bibliotecas organizadas (Foundation, Intelligence, Application); implementación de referencia BCL; plantillas y estándares de calidad. |
| **Entregable** | SDK reutilizable que acelera nuevos módulos. |

#### Nivel 4.4 — Integración en tiempo real

| Campo | Contenido |
|-------|-----------|
| **Módulos** | `1000-Integration` — Integración y Orquestación (BRIL) |
| **Specs** | `1000-Integration/bril-spec.md` |
| **Criterios de entrada** | Fases 2–3 (módulos que emitir/consumir eventos). |
| **Criterios de salida (DoD)** | Event Bus operativo; adaptadores y colas; sincronización entre módulos en tiempo real. |
| **Entregable** | Bus de eventos que desacopla todos los motores. |

#### Nivel 4.5 — Despliegue y operaciones

| Campo | Contenido |
|-------|-----------|
| **Módulos** | `1200-Deployment` — Despliegue, Infraestructura y Operaciones |
| **Specs** | `1200-Deployment/devops-spec.md` |
| **Criterios de entrada** | Módulos estables que requieren despliegue de producción. |
| **Criterios de salida (DoD)** | CI/CD completo; contenedores y orquestación (K8s); monitoreo, backups y plan de recuperación. |
| **Entregable** | Plataforma en producción con SLAs operativos. |

#### Nivel 4.6 — Testing refinado

| Campo | Contenido |
|-------|-----------|
| **Módulos** | `1100-Testing` — Aseguramiento de Calidad (BQAS) |
| **Specs** | `1100-Testing/bqas-spec.md` |
| **Criterios de entrada** | Módulos de las Fases 1–4 implementados (testing básico ya existe desde el Nivel 1.1). |
| **Criterios de salida (DoD)** | Suite completa: unitarias, integración, clínicas, científicas, IA, seguridad; cobertura por motor y por proceso. |
| **Entregable** | Batería de pruebas que bloquea regresiones clínicas y de seguridad. |

---

## 4. Funcionalidades recientes y su ubicación

Tres funcionalidades especificadas recientemente (change `landing-ia-atencion`) se ubican de forma coherente en este roadmap:

### 4.1. SLS-001 — Landing del servicio (`600-Commerce/service-landing.md`) → **Fase 1, Nivel 1.5**

**Justificación:** la landing es una superficie **estática de baja dependencia**: solo necesita el design system (BDS-001), un endpoint mínimo `POST /leads` y, en Fase 2, el widget AI-007. No depende del BCE/LIC (congelados hasta Nivel 4.2). Se construye en el MVP porque es la **cara pública del proyecto** y el canal de adquisición mientras el producto madura. El formulario se mantiene como único camino comercial; el widget AI-007 se integra después sin cambiar la superficie.

### 4.2. PWA-001 §7 — Guía de instalación (`300-Frontend/pwa-architecture.md`) → **Fase 1, Nivel 1.3**

**Justificación:** la arquitectura PWA es la base de la Patient App y `300-Frontend` es un módulo de la Fase 1 (MVP Funcional). La §7 (instalación y aterrizaje: `beforeinstallprompt`, instalación por plataforma, UX) es parte del **aterrizaje de la app en el dispositivo del usuario**, un requisito del entregable "PWA instalable" del Nivel 1.3. No requiere IA ni backend especial.

### 4.3. AI-007 — Support Chat (`400-AI/ai-007-support.md`) → **Fase 2, Nivel 2.3**

**Justificación:** `master.yaml` congela la implementación de `400-AI` hasta Nivel 2 (Valor Clínico), y la Fase 2 define `400-AI` como "básico — companion/support". AI-007 corre sobre el runtime on-device de AI-001 (Gemma + MediaPipe), así que entra exactamente con ese paquete de IA básico. Su widget se integra en la landing SLS-001 (ya construida en Nivel 1.5) y en las apps del Nivel 2.1.

---

## 5. Mapeo: Módulo → Fase → Nivel

| Módulo | Fase | Nivel |
|--------|------|-------|
| `index` (documentación) | — | — (referencia continua) |
| `000-Core` | 0 Fundamentos | 0.1; BPO/BPG/BPE en 3.2 |
| `000-Infrastructure` | 0 Fundamentos | 0.2 |
| `100-Architecture` | 3 Inteligencia | 3.1 (BIK, BXE) |
| `200-Backend` | 1 MVP Funcional | 1.2 (evoluciona en 3.1 y 4.2) |
| `300-Frontend` | 1 MVP Funcional | 1.3 (evoluciona en 2.2) |
| `400-AI` | 2 Valor Clínico (básico) / 3 Inteligencia (completo) | 2.3 / 3.3 |
| `500-Experiences` | 2 Valor Clínico | 2.2 |
| `600-Commerce` | 1 MVP (solo SLS-001) / 4 Plataforma (BCE, LIC, BWB) | 1.5 / 4.2 |
| `700-PracticeOS` (BCMS) | 2 Valor Clínico | 2.1 |
| `800-Analytics` | 4 Plataforma Completa | 4.1 |
| `900-Security` | 1 MVP Funcional | 1.1 (evoluciona en 4.2) |
| `1000-Integration` | 4 Plataforma Completa | 4.4 |
| `1100-Testing` | 4 Plataforma Completa (testing básico transversal desde 1.1) | 4.6 |
| `1200-Deployment` | 4 Plataforma Completa (CI/CD mínimo desde 1.2) | 4.5 |
| `1300-Libraries` | 4 Plataforma Completa | 4.3 |
| `BPE` | 3 Inteligencia | 3.2 |
| `BPO` | 3 Inteligencia | 3.2 |
| `BPG` | 3 Inteligencia | 3.2 |
| `BXE` | 3 Inteligencia | 3.1 |
| `BIK` | 3 Inteligencia | 3.1 |
| `BCMS` | 2 Valor Clínico | 2.1 |
| `BSI` | 2 Valor Clínico | 2.1 |

---

## 6. Consistencia y versionado

- Este roadmap es la **proyección accionable** del `build_order` de `master.yaml`, que lo referencia en la cabecera de su sección `build_order` (comentario `roadmap: index/build-roadmap.md (BRD-001)`).
- `master.yaml` reconcilia su versión con `EVOLUTION.md` (`project.version: 2.2.0`).
- **Nota de nomenclatura:** `master.yaml` escribe el módulo como `500-Experiencies` (con `e`); la carpeta real y su `index.yaml` usan `500-Experiences`. Este documento usa el ID real `500-Experiences`.

---

**Fin del documento `build-roadmap.md`**
