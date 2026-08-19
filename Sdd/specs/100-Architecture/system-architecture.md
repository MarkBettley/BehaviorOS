---
id: BEA-001
title: Arquitectura Empresarial del BehavioralOS (BEA)
version: 2.1.0
status: Stable
owner: Arquitectura de Software & Ciencia de Datos
last_updated: 2026-07-27
depends_on:
  - 000-Core (Filosofía, Principios, Ontología)
  - 100-Architecture/bik-architecture.md (BIK)
  - 100-Architecture/bxe-spec.md (BXE)
  - 100-Architecture/event-sourcing-architecture.md (Event Sourcing)
exports:
  - Mapa de Capas y Dominios
  - Principios Arquitectónicos
  - Contratos de Integración
  - Estrategia de Escalabilidad
  - Modelo de Gobernanza
  - Orden Arquitectónico Central: BPE > BPO > BPG > BERL > TCCN > AHEE > BIP > Reportes
  - Behavioral Process Cloud (BPC)
  - Behavioral Cognitive Architecture (BCA)
used_by:
  - Todos los módulos y motores del BehavioralOS
  - BRIL (Runtime Integration)
  - BQAS (Testing)
  - CI/CD (Deployment)
---

# BehavioralOS – Arquitectura Empresarial (BEA)

> *"La arquitectura no es un lujo. Es la disciplina que evita que el ecosistema se convierta en un conjunto de módulos inconexos que compiten entre sí. Una buena arquitectura permite que el sistema crezca durante años sin perder coherencia."*

---

## 1. Propósito y Alcance

### 1.1. Propósito
Este documento define la **arquitectura empresarial** del BehavioralOS. Es el plano de alto nivel que organiza todos los componentes, motores, servicios y dominios del ecosistema. Su objetivo es:

- **Establecer una estructura común** que guíe el desarrollo de todos los módulos.
- **Definir responsabilidades claras** para cada capa y dominio, evitando duplicaciones y acoplamientos innecesarios.
- **Garantizar la escalabilidad** horizontal y vertical del sistema.
- **Facilitar la evolución** del producto sin necesidad de rediseños profundos.
- **Proporcionar un lenguaje común** para que equipos multidisciplinarios (psicólogos, diseñadores, desarrolladores, investigadores) se comuniquen eficazmente.

### 1.2. Alcance
La BEA cubre:

- **Capas arquitectónicas**: 11 capas que organizan el sistema verticalmente.
- **Dominios de negocio**: Bounded contexts que organizan el sistema horizontalmente.
- **Principios de diseño**: Reglas que rigen la comunicación, el almacenamiento, la seguridad y la evolución.
- **Estrategias de escalabilidad**: Cómo crece el sistema sin colapsar.
- **Gobernanza**: Cómo se toman decisiones arquitectónicas y cómo se versionan.

### 1.3. Principio Fundamental
> **"El comportamiento es la unidad central de análisis. Toda la arquitectura existe para modelar, predecir y modificar el comportamiento humano de manera ética, eficaz y escalable."**

---

## 2. Filosofía Arquitectónica

### 2.1. Inspiración
La BEA se inspira en arquitecturas de sistemas complejos que han demostrado su validez en entornos críticos:

| Fuente de inspiración | Principio aplicado | Manifestación en BehavioralOS |
|------------------------|---------------------|-------------------------------|
| **Domain-Driven Design (DDD)** | Bounded Contexts y Ubiquitous Language | Cada dominio tiene su propio lenguaje y modelo, pero todos comparten la ontología base. |
| **Event-Driven Architecture** | Comunicación asíncrona y desacoplamiento | Todos los motores se comunican mediante eventos a través del BRIL. |
| **Hexagonal Architecture (Ports & Adapters)** | Independencia de infraestructura | Los dominios clínicos no dependen de bases de datos ni APIs externas. |
| **Microservicios** (moderados) | Despliegue y escalado independiente | Cada motor es un servicio desplegable por separado (dentro de un monorepo). |
| **Zero Trust Security** | Nunca confiar, siempre verificar | Cada petición se autentica y autoriza en cada capa. |
| **Privacy by Design** | La privacidad es nativa, no un añadido | El cifrado y la anonimización están en la base de la arquitectura. |
| **Behavioral First** | El comportamiento es el centro | Todos los modelos de datos, APIs y flujos se derivan de la ontología. |

### 2.2. Principios Arquitectónicos

| # | Principio | Descripción | Criterio de cumplimiento |
|---|-----------|-------------|---------------------------|
| 1 | **Desacoplamiento por eventos** | Los motores se comunican mediante eventos, no mediante llamadas directas. | Ningún motor importa directamente otro. Toda comunicación pasa por BRIL. |
| 2 | **Responsabilidad única por dominio** | Cada dominio (clínico, comercial, científico, etc.) tiene un único dueño y un único modelo. | Cada dominio tiene un equipo responsable y un repositorio de especificaciones. |
| 3 | **API First** | Todas las funcionalidades exponen una API clara y versionada. | Cada servicio tiene OpenAPI 3.0+ documentado. |
| 4 | **Configuración sobre código** | Los cambios de comportamiento se hacen mediante configuración, no mediante código. | Feature flags, políticas y reglas de negocio son configurables en tiempo de ejecución. |
| 5 | **Trazabilidad total** | Cada decisión clínica, cada inferencia de IA y cada transacción es auditable. | Todos los eventos se registran con metadatos de origen, versión y confianza. |
| 6 | **Escalabilidad horizontal** | El sistema puede crecer añadiendo más instancias de los servicios. | Los servicios son stateless (excepto las bases de datos) y se escalan mediante replicación. |
| 7 | **Resiliencia y tolerancia a fallos** | El sistema debe seguir funcionando (en modo degradado) si un componente falla. | Circuit breakers, retries, fallbacks y health checks en todos los servicios. |
| 8 | **Multi-tenant por diseño** | El sistema soporta múltiples organizaciones (clínicas, hospitales, universidades) de forma aislada. | Cada tenant tiene su propio esquema de base de datos y su propia configuración. |
| 9 | **Versionado semántico** | Todo (APIs, modelos, ontología, ejercicios) tiene versiones semánticas. | Cada cambio mayor, menor o de parche se documenta y se comunica. |
| 10 | **Behavioral First** | Todos los modelos de datos, flujos y decisiones se derivan de la ontología del comportamiento. | Cada entidad de base de datos y cada API se mapea a un nodo de la ontología. |
| 11 | **DRY / KISS / YAGNI** | No duplicar lógica, priorizar simplicidad, cero sobreingeniería. Cada dominio es la única fuente de verdad para sus conceptos. | Sin código muerto, sin lógica "para el futuro", solución más directa. Ver TCD-001 §2. |
| 12 | **Complejidad consciente** | Documentar y justificar la complejidad algorítmica de cada componente. Todo motor crítico debe declarar su Big O. | Ningún algoritmo O(n²) en hot path. Ver TCD-001 §4. |
| 13 | **Diseño Orientado a Objetos — Los 4 Pilares como Contrato Arquitectónico** | Todo motor, servicio y módulo del BehavioralOS debe respetar los 4 pilares de la POO como contratos arquitectónicos, no como sugerencias de código. **Encapsulación a nivel de módulo**: cada módulo (BPE, BPO, BPG, BXE, BIK, etc.) es una "caja negra" que expone solo su interfaz pública; el estado interno nunca es accesible desde fuera. **Abstracción a nivel de sistema**: los módulos se comunican exclusivamente a través de contratos (interfaces/eventos BRIL); el "cómo" de cada módulo puede cambiar sin afectar al resto. **Polimorfismo a nivel de integración**: el orquestador central (BIK) trata a todos los motores de manera polimórfica implementando el mismo contrato base (`process(context)`, `handle(event)`), permitiendo agregar, reemplazar o desactivar motores sin tocar el orquestador. **Herencia solo donde hay "es-un" arquitectónico**: la herencia a nivel de módulo solo se usa cuando existe una relación "es-un" genuina (ej. BPG-M "es un" BPG con capacidades multinivel); en todos los demás casos se usa composición. | Cada módulo expone una interfaz pública documentada y ningún otro módulo accede a su estado interno. El BIK invoca a todos los motores mediante un contrato polimórfico común. No hay herencia sin una relación "es-un" justificada en el BREO. |

---

## 2.3. Orden Arquitectónico Central

El BehavioralOS tiene un **orden arquitectónico definido** que establece la cadena de valor desde los motores fundamentales hasta la entrega al usuario. Este orden no es arbitrario: cada componente depende del anterior y alimenta al siguiente.

### Flujo Principal: BPE → BPO → BPG → BERL → TCCN → AHEE → BIP → Reportes

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    ORDEN ARQUITECTÓNICO CENTRAL                              │
│                    ─── Cadena de Valor del Ecosistema ───                    │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐                  │
│  │   BPE   │───►│   BPO   │───►│   BPG   │───►│  BERL   │                  │
│  │ Process │    │Ontology │    │ Process │    │Exercise │                  │
│  │ Engine  │    │         │    │  Graph  │    │  Lab    │                  │
│  └─────────┘    └─────────┘    └─────────┘    └────┬────┘                  │
│                                                     │                       │
│  ┌─────────┐    ┌─────────┐    ┌─────────┐    ┌────▼────┐                  │
│  │ Reportes│◄───│   BIP   │◄───│  AHEE   │◄───│  TCCN   │                  │
│  │         │    │Behavior.│    │Adaptive │    │Companion│                  │
│  │         │    │ Intel.  │    │Human Exp│    │Network  │                  │
│  └─────────┘    └─────────┘    └─────────┘    └─────────┘                  │
│                                                                             │
│  Capas transversales:                                                       │
│  ┌──────────────────────────────────────────────────────────────────────┐   │
│  │  BXE (Explicabilidad)  ←  Recorre toda la cadena                    │   │
│  │  BIK (Orquestación)    ←  Coordina todos los motores                │   │
│  │  BCA (Arquitectura Cognitiva) ← Marco conceptual del ecosistema     │   │
│  └──────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

| # | Componente | Siglas | Responsabilidad | Posición |
|---|-----------|--------|-----------------|----------|
| 1 | **Behavioral Process Engine** | BPE | Motor central que orquesta el procesamiento psicológico: recibe datos crudos, los clasifica, extrae procesos y alimenta la ontología. | Origen |
| 2 | **Behavioral Process Ontology** | BPO | Ontología formal que define los procesos psicológicos, sus dominios, relaciones y reglas. Es el lenguaje común del ecosistema. | Fundamento |
| 3 | **Behavioral Process Graph** | BPG | Grafo dinámico que representa el estado de los procesos del paciente, sus interrelaciones y evolución temporal. El "cerebro" del ecosistema. | Conocimiento |
| 4 | **BERL** | BERL | Laboratorio de ejercicios que selecciona, adapta y valida intervenciones basándose en el BPG. | Intervención |
| 5 | **TCCN** | TCCN | Compañero conversacional que utiliza el BPG y BERL para generar diálogos terapéuticos personalizados. | Conversación |
| 6 | **AHEE** | AHEE | Motor de experiencia humana adaptativa que personaliza la interfaz, la dificultad y la narrativa según el paciente. | Experiencia |
| 7 | **BIP** | BIP | Panel de inteligencia del paciente que consolida métricas, predicciones y recomendaciones para el terapeuta. | Visualización |
| 8 | **Reportes** | — | Generación de informes clínicos, de progreso y de explicabilidad para el terapeuta y el paciente. | Entrega |

### 2.3.1. Capas Transversales

| Capa | Siglas | Alcance |
|------|--------|---------|
| **Behavioral Explainability Engine** | BXE | Recorre toda la cadena de valor documentando y explicando cada decisión del sistema (14 submotores). Ver `bxe-spec.md`. |
| **Behavioral Intelligence Kernel** | BIK | Orquestador central que coordina todos los motores del ecosistema (20 submotores). Ver `bik-architecture.md`. |
| **Behavioral Cognitive Architecture** | BCA | Marco conceptual que define cómo piensa el ecosistema: contexto, objetivos, explicaciones, conflictos, confianza y agentes. Ver sección 2.4. |

---

## 2.4. Behavioral Cognitive Architecture (BCA)

La BCA es el **marco conceptual fundacional** del BehavioralOS. No es un módulo ejecutable; es el documento que define las reglas del pensamiento del ecosistema.

### Analogía

| Sistema | Marco conceptual | Equivalente en BehavioralOS |
|---------|-----------------|----------------------------|
| Redes de datos | TCP/IP | **BCA** |
| Sistemas Unix | POSIX | **BCA** |
| BehavioralOS | BCA | Define cómo se comparte contexto, se representan objetivos, se intercambian explicaciones, se resuelven conflictos, se manejan niveles de confianza y colaboran los agentes especializados |

### Pilares de la BCA

| Pilar | Descripción | Implementado por |
|-------|-------------|-----------------|
| **Contexto Compartido** | Todos los motores trabajan con el mismo estado cognitivo del paciente | BIK (Cognitive Context Engine) |
| **Objetivos Jerárquicos** | El sistema entiende qué busca lograr en cada momento | BIK (Goal Management Engine) |
| **Explicabilidad** | Toda decisión puede reconstruirse y explicarse | BXE (14 submotores) |
| **Resolución de Conflictos** | Cuando dos motores proponen cosas distintas, se escala al terapeuta | BIK (Conflict Resolution Engine) |
| **Gestión de Confianza** | Niveles de certeza integrados de múltiples fuentes | BIK (Trust & Confidence Manager) |
| **Colaboración Multi-Agente** | Agentes especializados coordinados sin duplicar trabajo | BIK (Multi-Agent Coordination Engine) |

> **"El BCA no es un módulo ejecutable. Es el documento fundacional que permite incorporar nuevos motores sin romper la coherencia del ecosistema."**

---

## 2.5. Behavioral Process Cloud (BPC)

La BPC es la **capa de nube** que permite que el ecosistema Behavioral funcione de manera distribuida, escalable y resiliente.

### Componentes de la BPC

| Componente | Descripción | Tecnología |
|------------|-------------|------------|
| **Event Stream** | Log inmutable de todos los eventos conductuales, clínicos y operativos | Redis Streams |
| **Derived Data Pipeline** | Motores especializados que observan el stream y generan datos derivados | FastAPI BackgroundTasks |
| **Database Views** | Contrato público para consumidores (zero breaking changes) | PostgreSQL Views |
| **Multi-Tenant Isolation** | Aislamiento de datos por organización (clínica, hospital, universidad) | PostgreSQL RLS |
| **Cognitive Runtime** | Entorno donde viven los agentes de IA (Gemma, MediaPipe, Whisper) | BIK (Behavioral AI Runtime) |
| **Workflow Engine** | Orquestación de flujos clínicos multi-paso (Ingreso → Evaluación → Tratamiento) | Temporal.io |

### Diagrama de la BPC

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    BEHAVIORAL PROCESS CLOUD (BPC)                        │
│                    ─── Capa de Nube del Ecosistema ───                   │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  ┌──────────────────────────────────────────────────────────────────┐  │
│  │  EVENT STREAM (System of Record)                                  │  │
│  │  evt_001 → evt_002 → evt_003 → evt_004 → evt_005 → ...         │  │
│  │  [Redis Streams - Log Inmutable]                                  │  │
│  └──────────────┬───────────────────────────────────────┬───────────┘  │
│                 │                                       │              │
│    ┌────────────▼────────────┐          ┌───────────────▼──────────┐  │
│    │  DERIVED DATA PIPELINE  │          │  DATABASE VIEWS          │  │
│    │                         │          │  (Contrato Público)      │  │
│    │  • RFT Engine           │          │                          │  │
│    │  • ACT Hexaflex         │          │  • vista_rft_input       │  │
│    │  • FAP CRB              │          │  • vista_hexaflex_input  │  │
│    │  • BPG Updater          │          │  • vista_analytics_input │  │
│    │  • Twin Updater         │          │  • vista_process_graph   │  │
│    │  • BXE Processor        │          │                          │  │
│    │  • BARS Aggregator      │          │  Zero Breaking Changes   │  │
│    └─────────────────────────┘          └──────────────────────────┘  │
│                                                                         │
│  ┌─────────────────────┐  ┌─────────────────────┐  ┌───────────────┐  │
│  │  COGNITIVE RUNTIME   │  │  WORKFLOW ENGINE     │  │  MULTI-TENANT │  │
│  │                      │  │                      │  │               │  │
│  │  Gemma 4 (LLM)      │  │  Temporal.io         │  │  RLS          │  │
│  │  MediaPipe           │  │  Sagas               │  │  Schemas      │  │
│  │  Whisper             │  │  Compensaciones      │  │  Isolation    │  │
│  └─────────────────────┘  └─────────────────────┘  └───────────────┘  │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

Para más detalles sobre Event Sourcing y Datos Derivados, ver `event-sourcing-architecture.md`.

---

## 3. Mapa de Capas Arquitectónicas

La BEA organiza el sistema en **11 capas verticales**, cada una con una responsabilidad específica. Las capas inferiores son más técnicas y las superiores más cercanas al usuario y al negocio.

┌─────────────────────────────────────────────────────────────────────────┐
│ Behavioral Experience Layer (BEL) │
│ (Paciente, Terapeuta, Administrador, Investigador) │
├─────────────────────────────────────────────────────────────────────────┤
│ Behavioral Clinical Layer (BCL) │
│ (AAO, BERL, TCCN, BSC, BROS, Hexaflex, PBT, ACT, FAP, DBT, etc.) │
├─────────────────────────────────────────────────────────────────────────┤
│ Behavioral Intelligence Layer (BIL) │
│ (Gemma, MediaPipe, RAG, BKGE, BWM, BCC, BCA, Modelos IA) │
├─────────────────────────────────────────────────────────────────────────┤
│ Behavioral Business Layer (BBL) │
│ (BCE, Marketplace, Suscripciones, Facturación, SAT) │
├─────────────────────────────────────────────────────────────────────────┤
│ Behavioral Operations Layer (BOL) │
│ (BPOS, Agenda, EHR, Videoterapia, CRM, Workflows) │
├─────────────────────────────────────────────────────────────────────────┤
│ Behavioral Governance Layer (BGL) │
│ (BCGS, Consentimientos, Auditoría, Cumplimiento, Ética) │
├─────────────────────────────────────────────────────────────────────────┤
│ Behavioral Data Layer (BDL) │
│ (PostgreSQL, Redis, Vector DB, BKGE, BWM, Grafos) │
├─────────────────────────────────────────────────────────────────────────┤
│ Behavioral Infrastructure Layer (BIFL) │
│ (FastAPI, React, Docker, Kubernetes, Supabase) │
├─────────────────────────────────────────────────────────────────────────┤
│ Behavioral Integration Layer (BINT) │
│ (BRIL, Adaptadores Google, Stripe, WhatsApp, SAT, etc.) │
├─────────────────────────────────────────────────────────────────────────┤
│ Behavioral Security Layer (BSL) │
│ (Zero Trust, RBAC, RLS, Cifrado, Logs, SIEM, BSOS) │
├─────────────────────────────────────────────────────────────────────────┤
│ Behavioral Research Layer (BRL) │
│ (BERL, BSC, BROS, Datasets, Publicaciones, ENSAYOS) │
└─────────────────────────────────────────────────────────────────────────┘


### 3.1. Descripción Detallada de Cada Capa

#### 3.1.1. Behavioral Experience Layer (BEL)

| Atributo | Descripción |
|----------|-------------|
| **Propósito** | Gestionar toda la interacción con los usuarios finales (pacientes, terapeutas, administradores, investigadores). |
| **Subsistemas** | BXP (Behavioral Experience Platform), BEC (Behavioral Experience Composer), AHEE (Adaptive Human Experience Engine). |
| **Responsabilidades** | - Renderizar interfaces adaptativas (Nintendo para pacientes, Apple para terapeutas).<br>- Gestionar la navegación y los flujos de usuario.<br>- Aplicar personalización basada en AHEE (edad, estado, preferencias).<br>- Integrar el acompañante IA (TCCN) en la conversación.<br>- Mostrar visualizaciones de procesos (Hexaflex, RFT, series temporales). |
| **Tecnologías** | React, React Native, Tailwind, Framer Motion, Godot (para minijuegos en web), Flutter (para móvil), Web Audio API. |
| **Comunicación** | Se comunica con el resto del sistema a través de BRIL (eventos y APIs) y consume datos del Behavioral Twin. |
| **Seguridad** | Autenticación JWT, RLS, consentimientos granulares. |

#### 3.1.2. Behavioral Clinical Layer (BCL)

| Atributo | Descripción |
|----------|-------------|
| **Propósito** | Albergar toda la lógica clínica del sistema: evaluación, intervención, seguimiento y personalización terapéutica. |
| **Subsistemas** | AAO (Adaptive Assessment Orchestrator), BERL (Behavioral Exercise Research Lab), TCCN (Therapeutic Cognitive Companion Network), BSC (Behavioral Science Cloud), BROS (Behavioral Research OS), Hexaflex, PBT, ACT, FAP, DBT, TIP, Gottman, Neuropsicología Funcional. |
| **Responsabilidades** | - Evaluación adaptativa y continua (AAO).<br>- Diseño, validación y evolución de ejercicios (BERL).<br>- Conversación terapéutica con IA (TCCN).<br>- Almacenamiento y consulta de conocimiento científico (BSC).<br>- Ejecución de investigación clínica (BROS).<br>- Modelado de procesos psicológicos (PBT, Hexaflex). |
| **Tecnologías** | Python (FastAPI), NetworkX, statsmodels, pyEDM, fuzzylogic, jsPsych, Godot (integración). |
| **Comunicación** | Recibe eventos de BRIL (ej. ejercicio completado, nueva telemetría). Publica eventos para actualizar el Behavioral Twin y el BSC. |
| **Seguridad** | Validación clínica en cada paso; todas las decisiones son trazables y auditables. |

#### 3.1.3. Behavioral Intelligence Layer (BIL)

| Atributo | Descripción |
|----------|-------------|
| **Propósito** | Albergar todos los modelos de IA, razonamiento y generación de lenguaje. |
| **Subsistemas** | Gemma (LLM on-device), MediaPipe (visión y audio), RAG (Retrieval-Augmented Generation), BKGE (Behavioral Knowledge Graph Engine), BWM (Behavioral World Model), BCC (Behavioral Computational Calculus), BCA (Behavioral Cognitive Architecture). |
| **Responsabilidades** | - Inferencia local con Gemma (chat, análisis de texto, generación de respuestas).<br>- Reconocimiento de voz y visión (MediaPipe).<br>- Recuperación de conocimiento científico (RAG + BKGE).<br>- Simulación y predicción (BWM).<br>- Razonamiento funcional (BCC y BCA). |
| **Tecnologías** | MediaPipe LLM Inference, Gemma 4, ONNX Runtime, Whisper, Transformers, pgvector, NetworkX. |
| **Comunicación** | Recibe peticiones de TCCN y AAO. Consulta el BKGE y el BWM. Publica eventos para actualizar el Behavioral Twin. |
| **Seguridad** | Guardrails clínicos y validación ontológica en cada salida; zero-trust en el acceso a datos. |

#### 3.1.4. Behavioral Business Layer (BBL)

| Atributo | Descripción |
|----------|-------------|
| **Propósito** | Gestionar el negocio: suscripciones, pagos, facturación, marketplace y productos digitales. |
| **Subsistemas** | BCE (Behavioral Commerce Engine), Marketplace, Productos digitales, Cupones, Suscripciones, Facturación, SAT, Stripe, Mercado Pago. |
| **Responsabilidades** | - Procesar pagos y suscripciones.<br>- Generar facturas CFDI 4.0.<br>- Gestionar el marketplace de productos y servicios.<br>- Administrar cupones y promociones.<br>- Calcular impuestos (IVA, ISR). |
| **Tecnologías** | FastAPI, Stripe API, Mercado Pago API, Facturapi, SAT-CFDI, Pandas, NumPy. |
| **Comunicación** | Recibe eventos de compra y suscripción. Publica eventos para actualizar el BPOS y el BIP. |
| **Seguridad** | Cifrado de datos financieros, idempotencia en pagos, auditoría de transacciones. |

#### 3.1.5. Behavioral Operations Layer (BOL)

| Atributo | Descripción |
|----------|-------------|
| **Propósito** | Gestionar la operación clínica diaria: agenda, expedientes, videoterapia, CRM y workflows. |
| **Subsistemas** | BPOS (Behavioral Practice Operating System), Agenda inteligente, EHR (Expediente Clínico Electrónico), Videoterapia, Notas clínicas, CRM, Workflows. |
| **Responsabilidades** | - Gestionar citas y agenda (integración con Google/Outlook).<br>- Almacenar y versionar expedientes clínicos.<br>- Proporcionar videoterapia con HUD clínico.<br>- Automatizar flujos de seguimiento (recordatorios, encuestas).<br>- Gestionar la relación con el paciente (CRM). |
| **Tecnologías** | FastAPI, Supabase, WebRTC, Temporal.io (workflows), Redis. |
| **Comunicación** | Recibe eventos de agenda, sesiones y pagos. Publica eventos para actualizar el Behavioral Twin y el BIP. |
| **Seguridad** | RLS, cifrado de expedientes, auditoría de acceso. |

#### 3.1.6. Behavioral Governance Layer (BGL)

| Atributo | Descripción |
|----------|-------------|
| **Propósito** | Garantizar el cumplimiento legal, ético y regulatorio de todo el ecosistema. |
| **Subsistemas** | BCGS (Behavioral Compliance & Governance System), Consentimientos, Auditoría, Cumplimiento Legal, Ética, Documentación, Versionado. |
| **Responsabilidades** | - Gestionar consentimientos granulares y reversibles.<br>- Auditar todas las acciones y decisiones.<br>- Garantizar el cumplimiento de normativas (LFPDPPP, GDPR, HIPAA).<br>- Gestionar la ética de la IA (Clinical AI Constitution).<br>- Versionar políticas y contratos. |
| **Tecnologías** | Supabase RLS, WebCrypto, Hash, Firmas electrónicas, BCGS Engine. |
| **Comunicación** | Recibe eventos de todos los módulos para auditar. Publica alertas de cumplimiento. |
| **Seguridad** | Zero Trust, inmutabilidad de logs, cifrado de auditoría. |

#### 3.1.7. Behavioral Data Layer (BDL)

| Atributo | Descripción |
|----------|-------------|
| **Propósito** | Almacenar y gestionar todos los datos del ecosistema: relacionales, grafos, vectores, series temporales y archivos. |
| **Subsistemas** | PostgreSQL (Supabase), Redis, pgvector, BKGE (Behavioral Knowledge Graph Engine), BWM (Behavioral World Model), Object Storage (S3). |
| **Responsabilidades** | - Almacenar datos relacionales (usuarios, sesiones, pagos, etc.).<br>- Almacenar grafos de conocimiento y conductuales (BKGE, BWM).<br>- Almacenar embeddings para RAG (pgvector).<br>- Gestionar archivos (videos, audios, sprites, PDFs).<br>- Proporcionar caché y colas (Redis). |
| **Tecnologías** | Supabase (PostgreSQL + pgvector + Storage), Redis, NetworkX (serializado en JSON), S3. |
| **Comunicación** | Expone APIs a los servicios. Escucha eventos para actualizar datos. |
| **Seguridad** | RLS, cifrado en reposo y en tránsito, separación lógica de tenants. |

#### 3.1.8. Behavioral Infrastructure Layer (BIFL)

| Atributo | Descripción |
|----------|-------------|
| **Propósito** | Proporcionar la infraestructura subyacente para todos los servicios: backend, frontend, contenedores, orquestación, CDN. |
| **Subsistemas** | FastAPI (backend), React (frontend), Docker (contenedores), Kubernetes (orquestación), Supabase (BaaS), CDN. |
| **Responsabilidades** | - Ejecutar los servicios backend (FastAPI).<br>- Servir las aplicaciones frontend (React, React Native).<br>- Orquestar contenedores (Docker Compose para desarrollo, Kubernetes para producción).<br>- Gestionar el almacenamiento en CDN (assets, sprites, videos). |
| **Tecnologías** | FastAPI, Uvicorn, React, Vite, Docker, Kubernetes, Supabase, Cloudflare (CDN). |
| **Comunicación** | Expone APIs y sirve contenido estático. No contiene lógica de negocio. |
| **Seguridad** | WAF, rate limiting, DDoS protección, TLS 1.3. |

#### 3.1.9. Behavioral Integration Layer (BINT)

| Atributo | Descripción |
|----------|-------------|
| **Propósito** | Conectar el BehavioralOS con servicios externos (Google, Stripe, WhatsApp, SAT, etc.) mediante adaptadores desacoplados. |
| **Subsistemas** | BRIL (Behavioral Runtime Integration Layer), Adaptadores para Google Calendar, Google Meet, Zoom, Teams, WhatsApp Business, Stripe, Mercado Pago, Facturapi, SAT, Twilio, SendGrid, etc. |
| **Responsabilidades** | - Traducir las APIs externas al formato interno del BehavioralOS.<br>- Gestionar la autenticación y autorización con servicios externos.<br>- Manejar reintentos, timeouts y fallbacks.<br>- Sincronizar datos bidireccionalmente. |
| **Tecnologías** | FastAPI, Webhooks, SDKs externos, Redis (para caché de tokens). |
| **Comunicación** | Recibe eventos de BRIL y los traduce a llamadas externas. Publica eventos con los resultados. |
| **Seguridad** | Credenciales cifradas (Supabase Vault), OAuth2, webhooks verificados. |

#### 3.1.10. Behavioral Security Layer (BSL)

| Atributo | Descripción |
|----------|-------------|
| **Propósito** | Gobernar toda la seguridad del ecosistema: identidad, permisos, cifrado, auditoría y cumplimiento. |
| **Subsistemas** | BSOS (Behavioral Security OS), IAM (Identity & Access Management), RBAC, RLS, Cifrado, Logs de seguridad, SIEM, Zero Trust Gateway. |
| **Responsabilidades** | - Autenticar usuarios (JWT, OAuth, WebAuthn).<br>- Autorizar acciones (RBAC + ABAC + ReBAC).<br>- Cifrar datos en reposo y en tránsito.<br>- Registrar todas las acciones de seguridad.<br>- Detectar amenazas y responder a incidentes. |
| **Tecnologías** | Supabase Auth, WebCrypto, AES-256, Argon2, OpenTelemetry, Prometheus, SIEM (ELK o similar). |
| **Comunicación** | Intercepta todas las peticiones y eventos. Aplica políticas de seguridad. |
| **Seguridad** | Zero Trust, verificación continua, auditoría inmutable. |

#### 3.1.11. Behavioral Research Layer (BRL)

| Atributo | Descripción |
|----------|-------------|
| **Propósito** | Apoyar la investigación científica y la mejora continua del sistema mediante datos anonimizados, simulaciones y experimentos controlados. |
| **Subsistemas** | BSC (Behavioral Science Cloud), BROS (Behavioral Research OS), ASC (Adaptive Scientific Council), BERL (como laboratorio), Datasets anonimizados, Publicaciones. |
| **Responsabilidades** | - Almacenar y consultar conocimiento científico (BSC).<br>- Ejecutar simulaciones y experimentos (BROS).<br>- Validar nuevas intervenciones (ASC).<br>- Generar evidencia para mejorar los motores clínicos.<br>- Publicar hallazgos (anonimizados y con consentimiento). |
| **Tecnologías** | NetworkX, statsmodels, pyEDM, scikit-learn, Pandas, Jupyter, BKGE, BWM. |
| **Comunicación** | Recibe eventos anonimizados de la capa clínica. Publica nuevas versiones de modelos y ejercicios (previo aprobación). |
| **Seguridad** | Anonimización estricta, consentimiento explícito, datos agregados, auditoría científica. |

---

## 4. Dominios de Negocio (Bounded Contexts)

Además de las capas verticales, la BEA organiza el sistema en **dominios horizontales** (bounded contexts), cada uno con su propio lenguaje, modelo de datos y equipo responsable.

| Dominio | Descripción | Subsistemas clave | Límites |
|---------|-------------|-------------------|---------|
| **Clínico** | Todo lo relacionado con la evaluación, intervención y seguimiento terapéutico. | AAO, BERL, TCCN, BSC, BROS, PBT, ACT, FAP, DBT, Neuropsicología. | No conoce comercio, ni infraestructura, ni UI. |
| **Comercial** | Suscripciones, pagos, facturación, marketplace y productos. | BCE, Stripe, Mercado Pago, SAT, Cupones, Marketplace. | No conoce clínica, ni investigación, ni datos de pacientes. |
| **Operacional** | Agenda, expedientes, videoterapia, CRM y workflows de la práctica clínica. | BPOS, Agenda, EHR, Videoterapia, CRM, Workflows. | No conoce comercio (excepto para facturación), ni investigación. |
| **Científico** | Investigación, simulación, validación de modelos y generación de evidencia. | BSC, BROS, ASC, BERL (como laboratorio). | No conoce pacientes identificables; trabaja con datos anonimizados. |
| **Técnico** | Infraestructura, integración, seguridad y datos. | BIFL, BINT, BSL, BDL. | No conoce lógica clínica ni de negocio; es la base. |
| **Experiencia** | Interfaz de usuario, personalización, narrativa y gamificación. | BXP, BEC, AHEE, BDS, TCCN (como interfaz conversacional). | No conoce datos crudos ni lógica de negocio; solo consume APIs. |

### 4.1. Comunicación entre Dominios

Los dominios se comunican exclusivamente mediante:

- **APIs síncronas** (REST) para consultas y comandos inmediatos (ej. obtener perfil de paciente, iniciar sesión).
- **Eventos asíncronos** (a través de BRIL) para actualizaciones de estado y notificaciones (ej. ejercicio completado, pago aprobado).
- **Contratos explícitos** (OpenAPI, AsyncAPI) que definen los mensajes y sus formatos.

**Ningún dominio importa directamente el código de otro dominio.** Todo el acoplamiento es a nivel de contratos.

---

## 5. Principios de Comunicación y Flujo de Datos

### 5.1. Flujo de Datos Típico

1. **Usuario interactúa con la interfaz** (BEL).
2. **La interfaz envía una petición** (REST o WebSocket) al backend correspondiente (BOL, BCL, etc.).
3. **El backend procesa la petición**, consulta o actualiza el Behavioral Twin y/o la base de datos (BDL).
4. **El backend publica un evento** en BRIL (ej. `SESSION_COMPLETED`).
5. **BRIL distribuye el evento** a los suscriptores (AAO, BERL, BSC, BIP, etc.).
6. **Cada suscriptor procesa el evento** y actualiza su estado (ej. AAO actualiza el Behavioral Twin, BSC registra la telemetría para investigación).
7. **Se envían notificaciones** al usuario a través de BEL (ej. "¡Descubriste un nuevo patrón!").

### 5.2. Sincronía vs. Asincronía

| Tipo | Uso | Ejemplos |
|------|-----|----------|
| **Síncrono (REST)** | Consultas inmediatas, comandos que requieren respuesta. | Obtener perfil de paciente, iniciar sesión, guardar nota. |
| **Asíncrono (Eventos)** | Actualizaciones de estado, notificaciones, flujos largos. | Ejercicio completado, pago aprobado, sesión finalizada. |
| **WebSockets** | Comunicación en tiempo real. | Chat con TCCN, videoterapia, HUD en vivo. |

### 5.3. Estrategia de Consistencia

- **Consistencia eventual** para la mayoría de los flujos (ej. actualización del Behavioral Twin después de un ejercicio).
- **Consistencia fuerte** para transacciones financieras y clínicas críticas (ej. pago, prescripción de medicación, si aplica). Estas se gestionan con Sagas y transacciones distribuidas.

---

## 6. Estrategia de Escalabilidad y Multi-Tenant

### 6.1. Escalabilidad Horizontal

- **Servicios stateless**: Todos los servicios backend son stateless (sin estado en memoria). El estado se almacena en bases de datos y cachés compartidos.
- **Replicación**: Los servicios se pueden replicar horizontalmente (múltiples instancias) detrás de un balanceador de carga.
- **Bases de datos**: PostgreSQL con replicación y sharding (si es necesario). Redis para caché y colas.
- **Autoescalado**: Kubernetes HPA (Horizontal Pod Autoscaler) basado en CPU, memoria y métricas personalizadas (ej. colas de eventos).

### 6.2. Multi-Tenant

- **Aislamiento por tenant**: Cada organización (clínica, hospital, universidad) tiene su propio esquema de base de datos y su propia configuración.
- **RLS (Row Level Security)**: En PostgreSQL, cada fila tiene un `tenant_id` y las políticas RLS garantizan que solo se pueda acceder a los datos del tenant correspondiente.
- **Configuración por tenant**: Cada tenant puede personalizar su propia configuración (branding, precios, módulos activos, flujos de trabajo).
- **Escalabilidad de tenants**: El sistema está diseñado para soportar desde 1 tenant (psicólogo independiente) hasta miles de tenants (redes de clínicas).

---

## 7. Gobernanza y Evolución Arquitectónica

### 7.1. Proceso de Cambio Arquitectónico

1. **Propuesta (RFC)**: Se redacta un RFC (Request for Comments) que describe el cambio propuesto, su justificación y su impacto.
2. **Revisión**: El equipo de arquitectura y los líderes de dominio revisan el RFC.
3. **Simulación**: Si el cambio es significativo, se simula en un entorno de pruebas (sandbox) con Behavioral Twins sintéticos.
4. **Aprobación**: El RFC se aprueba y se asigna una versión.
5. **Implementación**: Se implementa el cambio siguiendo las guías de desarrollo.
6. **Validación**: Se ejecutan las pruebas del BQAS (unitarias, de integración, clínicas, científicas, de rendimiento, etc.).
7. **Despliegue**: Se despliega en producción con un plan de rollback.

### 7.2. Versionado de la Arquitectura

- La BEA tiene su propio versionado semántico (MAJOR.MINOR.PATCH).
- **MAJOR**: Cambios incompatibles en las capas o dominios (ej. nueva capa, eliminación de un dominio).
- **MINOR**: Adición de nuevas capacidades o subsistemas (ej. nuevo motor de IA).
- **PATCH**: Correcciones de documentación o aclaraciones.

### 7.3. Documentación Viva

- Todos los documentos de arquitectura (BEA, BREO, Behavioral Twin, Data Model) se mantienen en el repositorio y se actualizan con cada cambio.
- El Behavioral Knowledge Index (BKI) indexa estos documentos para que los agentes de IA puedan consultarlos de forma eficiente.

---

## 8. Integración con los Motores del Ecosistema

### 8.1. Relación con la Ontología
- La BEA se basa en la ontología (`000-Core/ontology.md`) para definir sus entidades y relaciones. Cada capa y dominio debe mapear a la ontología.

### 8.2. Relación con BREO (Catálogo de Motores)
- La BEA define *dónde* vive cada motor (capa y dominio). El BREO define *qué* es cada motor y *cómo* se configura.

### 8.3. Relación con BRIL (Integración en Tiempo Real)
- La BEA define las reglas de comunicación entre capas. BRIL implementa esa comunicación en tiempo de ejecución.

### 8.4. Relación con el BQAS (Testing)
- La BEA define los principios de calidad que el BQAS debe verificar (ej. desacoplamiento, trazabilidad, escalabilidad).

---

## 9. Criterios de Validación y Cumplimiento

| Criterio | Métrica | Herramienta |
|----------|---------|-------------|
| Desacoplamiento | Ningún módulo importa directamente otro. | Análisis de dependencias (ej. `depcruise`). |
| API First | Cada servicio tiene OpenAPI 3.0+ documentado. | Validación automática en CI/CD. |
| Trazabilidad | Cada evento tiene metadatos de origen, versión y confianza. | Auditoría automática. |
| Escalabilidad horizontal | Los servicios son stateless. | Revisión de código y pruebas de carga. |
| Multi-tenant | Cada tabla tiene `tenant_id` y RLS activo. | Validación de esquemas y pruebas de seguridad. |
| Resiliencia | Circuit breakers, retries y fallbacks en integraciones externas. | Chaos engineering (simulación de fallos). |
| DRY/KISS/YAGNI | Sin código muerto ni lógica anticipada. | Análisis estático (código no utilizado). Ver TCD-001 §2. |
| Big O | Sin algoritmo O(n²) en hot path. | Revisión de código y perfilado. Ver TCD-001 §4. |

---

## 10. El Manifiesto Arquitectónico

> *"La arquitectura no es un documento que se escribe una vez y se olvida. Es un contrato vivo que evoluciona con el sistema.*
>
> *Cada capa, cada dominio, cada principio existe para servir a la misión del BehavioralOS: ayudar a las personas a desarrollar habilidades psicológicas duraderas.*
>
> *Si una decisión arquitectónica no mejora la precisión clínica, la experiencia del usuario o la escalabilidad del sistema, entonces esa decisión debe ser cuestionada.*
>
> *La arquitectura es el puente entre la ciencia del comportamiento y la tecnología. Mantener ese puente sólido es nuestra responsabilidad."*

---

## 11. Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2026-07-01 | Arquitectura Jefe | Creación del documento. Definición de capas, dominios, principios, comunicación, escalabilidad y gobernanza. |
| 2.0.0 | 2026-07-14 | Arquitectura Jefe | Actualización del orden arquitectónico central (BPE > BPO > BPG > BERL > TCCN > AHEE > BIP > Reportes). Agregado de BCA (Behavioral Cognitive Architecture), BPC (Behavioral Process Cloud) y capas transversales (BXE, BIK). |
| 2.1.0 | 2026-07-27 | Arquitectura Jefe | Incorporación del Principio #13: Diseño Orientado a Objetos — Los 4 Pilares de la POO (Encapsulación, Abstracción, Polimorfismo, Herencia) como contratos arquitectónicos del BehavioralOS. |

---

**Fin del documento `system-architecture.md`**