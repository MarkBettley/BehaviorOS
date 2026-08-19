---
id: BREO-001
title: Catálogo de Motores y Frameworks (BREO)
version: 2.1.0
status: Stable
owner: Arquitectura de Software & Ciencia de Datos
last_updated: 2026-07-27
depends_on:
  - 000-Core (Ontología, Principios)
  - 100-Architecture/system-architecture.md (BEA)
  - 100-Architecture/bik-architecture.md (BIK)
  - 100-Architecture/bxe-spec.md (BXE)
  - 100-Architecture/event-sourcing-architecture.md (Event Sourcing)
exports:
  - Catálogo completo de motores con fichas técnicas
  - Matriz de compatibilidad (plataformas y versiones)
  - Políticas de uso y gobernanza de motores
  - Estrategia de versionado y actualización
  - ~35+ motores catalogados
used_by:
  - BRIL (Runtime Integration)
  - BQAS (Testing de motores)
  - CI/CD (Deployment y actualización)
  - Equipos de desarrollo (selección de tecnologías)
---

# BehavioralOS – Catálogo de Motores y Frameworks (BREO)

> *"Un motor no es una herramienta aislada. Es un engranaje en un ecosistema. Cada elección técnica debe justificarse no solo por su rendimiento, sino por su capacidad de integrarse armónicamente con el resto."*

---

## 1. Propósito y Alcance

### 1.1. Propósito
Este documento establece el **catálogo oficial de motores, frameworks, SDKs y librerías** que componen el BehavioralOS. Su objetivo es:

- **Centralizar el conocimiento técnico** sobre cada componente del ecosistema.
- **Facilitar la toma de decisiones** sobre qué tecnologías utilizar en cada contexto.
- **Garantizar la compatibilidad** entre versiones y plataformas.
- **Establecer políticas de uso** (licencias, rendimiento, seguridad, soporte).
- **Proveer una hoja de ruta** para actualizaciones y sustituciones.

### 1.2. Alcance
El catálogo cubre todos los motores y frameworks utilizados en el BehavioralOS, organizados en 10 categorías:

1. **Motores de IA** (Gemma, MediaPipe, Whisper, etc.)
2. **Motores Psicológicos** (ACT, FAP, DBT, PBT, RFT, EEMM, etc.)
3. **Motores de Juego y Simulación** (Godot, jsPsych, etc.)
4. **Motores de Backend y Datos** (FastAPI, Supabase, PostgreSQL, Redis, etc.)
5. **Motores de Frontend** (React, React Native, Tailwind, Framer Motion, etc.)
6. **Motores de Negocio y Comercio** (Stripe, Mercado Pago, Facturapi, etc.)
7. **Motores Científicos y Analíticos** (NetworkX, statsmodels, pyEDM, fuzzylogic, etc.)
8. **Motores de Integración** (BRIL adapters, Webhooks, etc.)
9. **Motores de Seguridad** (WebCrypto, JWT, OAuth, etc.)
10. **Motores de Testing y Calidad** (Pytest, Jest, Playwright, k6, etc.)

### 1.3. Principio Fundamental
> **"Cada motor debe ser reemplazable sin afectar al resto del ecosistema."**  
> Esto significa que todos los motores están encapsulados detrás de adaptadores (BRIL) y solo se comunican mediante contratos bien definidos. Si un motor queda obsoleto o surge una alternativa mejor, se puede sustituir sin rediseñar el sistema.

> **Torticode:** Cada motor debe cumplir los principios TCD-001. La ficha técnica incluye un campo de Big O para declarar complejidad algorítmica. DRY/KISS/YAGNI aplican a la implementación de los adaptadores y motores.

### 1.4. Principios POO en el Diseño de Motores

Este documento sigue los principios de la programación orientada a objetos definidos en Torticode (TCD-001 §5) como base arquitectónica para el diseño de motores en BehavioralOS. Cada pilar se aplica de la siguiente manera:

**1. Abstracción en Motores**: Cada motor expone solo su interfaz pública a través de BRIL. El resto del ecosistema no conoce la implementación interna del motor. Ejemplo: el BPE (Behavioral Process Engine) expone `process(event)` y `classify(context)`, pero nadie sabe si usa reglas, ML o un archivo YAML por dentro.

**2. Encapsulación en Motores**: Cada motor es dueño absoluto de su estado interno. No hay variables globales compartidas entre motores. La comunicación es exclusivamente por mensajes (eventos BRIL). Esto garantiza que un motor no pueda corromper el estado de otro.

**3. Herencia en Motores**: Donde exista una relación "es-un" genuina (ej. BPG es un tipo de Grafo de Procesos → BPG-M es una extensión multinivel del mismo). Usar composición cuando la relación sea "tiene-un" (ej. un BXE tiene un submotor de explicación, no es un submotor).

**4. Polimorfismo entre Motores**: Todos los motores del núcleo (BPE, BPO, BPG, BXE, BIK) implementan contratos comunes. El orquestador (BIK) itera motores llamando `process()` sin saber qué motor específico está ejecutando. Esto permite agregar, reemplazar o desactivar motores sin modificar el orquestador.

| Pilar POO | Cómo se aplica en BREO | Ejemplo concreto |
|-----------|------------------------|-------------------|
| Abstracción | Motores expuestos solo por interfaz BRIL | `BPE.process(event)` sin exponer implementación |
| Encapsulación | Estado interno aislado, comunicación por eventos | BIK no accede directamente al grafo del BPG |
| Herencia | Solo cuando hay "es-un" real, de lo contrario composición | BPG-M extiende BPG solo si "es-un" BPG especializado |
| Polimorfismo | Contrato común `process()` para todos los motores | BIK itera `[BPE, BPO, BPG, BXE].process(ctx)` |

---

## 2. Categoría 1: Motores de IA

### 2.1. Gemma (LLM on-device)

| Atributo | Valor |
|----------|-------|
| **ID** | `AI-001` |
| **Nombre** | Gemma |
| **Versión** | 4 (Gemma 4) |
| **Proveedor** | Google DeepMind |
| **Tipo** | Modelo de lenguaje ligero (2B/7B parámetros) |
| **Ejecución** | Local (on-device) mediante MediaPipe LLM Inference |
| **Propósito** | Generación de lenguaje natural, análisis de texto, conversación terapéutica, resumen, generación de preguntas. |
| **Dependencias** | MediaPipe LLM Inference Runtime, ONNX Runtime (opcional). |
| **Consumido por** | TCCN (Companion), AAO (análisis de texto), AHEE (adaptación), BSC (extracción de conocimiento). |
| **Alternativas** | Qwen 2.5 (local), Phi-3 (local), Llama 3.2 (local). |
| **Políticas de uso** | - Solo se usa para inferencia, nunca para entrenamiento.<br>- No se almacenan prompts ni respuestas completas (solo patrones anonimizados).<br>- Guardrails clínicos aplicados en cada salida. |
| **Rendimiento** | - Latencia: < 200 ms en dispositivos con NPU, < 500 ms en CPU.<br>- Consumo de RAM: 2-4 GB (modelo 2B), 6-8 GB (modelo 7B). |
| **Licencia** | Google Gemma Terms (uso comercial permitido con restricciones éticas). |
| **Última actualización** | 2026-06-15 |
| **Estado** | Estable |

### 2.2. MediaPipe (Visión, Audio y LLM Runtime)

| Atributo | Valor |
|----------|-------|
| **ID** | `AI-002` |
| **Nombre** | MediaPipe |
| **Versión** | 2.3 (última estable) |
| **Proveedor** | Google |
| **Tipo** | Framework de inferencia multimodal (visión, audio, texto) |
| **Ejecución** | Local (on-device) |
| **Propósito** | - Ejecutar Gemma (LLM Inference).<br>- Reconocimiento facial (Face Mesh) para indicadores de atención y fatiga.<br>- Detección de landmarks corporales (postura, gestos).<br>- Análisis de audio (prosodia básica). |
| **Dependencias** | WebAssembly (web), C++ (nativo), Python (backend). |
| **Consumido por** | TCCN (conversación multimodal), AAO (evaluación no verbal), AHEE (adaptación sensorial), BERL (integración con Godot). |
| **Alternativas** | ONNX Runtime (para algunos modelos), TensorFlow Lite. |
| **Políticas de uso** | - Face Mesh solo con consentimiento explícito.<br>- Los datos de audio y video no se almacenan; se procesan en tiempo real y se descartan.<br>- Modelos cargados desde el dispositivo (sin envío a la nube). |
| **Rendimiento** | - Face Mesh: 30-60 FPS en dispositivos modernos.<br>- LLM Inference: depende de Gemma.<br>- Consumo de batería: moderado (optimizado para móviles). |
| **Licencia** | Apache 2.0 |
| **Última actualización** | 2026-05-20 |
| **Estado** | Estable |

### 2.3. Whisper (Reconocimiento de Voz)

| Atributo | Valor |
|----------|-------|
| **ID** | `AI-003` |
| **Nombre** | Whisper |
| **Versión** | v3 (large-v3) / tiny (para dispositivos limitados) |
| **Proveedor** | OpenAI |
| **Tipo** | Modelo de reconocimiento automático de voz (ASR) |
| **Ejecución** | Local (on-device) o servidor (según capacidad) |
| **Propósito** | Transcripción de audio en tiempo real para videoterapia y conversaciones con TCCN. |
| **Dependencias** | ONNX Runtime, Transformers (Python). |
| **Consumido por** | TCCN (entrada de voz), BPOS (videoterapia), AAO (análisis prosódico). |
| **Alternativas** | Vosk (local), Google Speech-to-Text (nube). |
| **Políticas de uso** | - Solo se transcribe con consentimiento explícito.<br>- Las transcripciones se anonimizan y no se almacenan (solo se extraen patrones).<br>- Para dispositivos limitados, se usa la versión `tiny` con menor precisión pero mayor velocidad. |
| **Rendimiento** | - Latencia: < 1s en GPU, 2-3s en CPU (large).<br>- Precisión: > 95% en español con buena calidad de audio. |
| **Licencia** | MIT |
| **Última actualización** | 2025-12-10 |
| **Estado** | Estable |

### 2.4. ONNX Runtime (Motor de Inferencia)

| Atributo | Valor |
|----------|-------|
| **ID** | `AI-004` |
| **Nombre** | ONNX Runtime |
| **Versión** | 1.18.0 |
| **Proveedor** | Microsoft |
| **Tipo** | Motor de inferencia multiplataforma para modelos ONNX |
| **Ejecución** | Local (CPU/GPU/NPU) |
| **Propósito** | Ejecutar modelos de IA (Gemma, Whisper, etc.) optimizados en formato ONNX. |
| **Dependencias** | Python, C++, WebAssembly (web). |
| **Consumido por** | Gemma, Whisper, y otros modelos que se conviertan a ONNX. |
| **Alternativas** | TensorFlow Lite, PyTorch Mobile. |
| **Políticas de uso** | - Se prefiere ONNX para modelos pequeños (< 1 GB).<br>- Se usa la versión web (WebAssembly) para navegadores modernos. |
| **Rendimiento** | - Depende del modelo y del hardware.<br>- Optimizado para CPU y GPU (CUDA). |
| **Licencia** | MIT |
| **Última actualización** | 2026-05-01 |
| **Estado** | Estable |

---

## 3. Categoría 2: Motores Psicológicos

### 3.1. ACT Engine (Acceptance and Commitment Therapy)

| Atributo | Valor |
|----------|-------|
| **ID** | `PSY-001` |
| **Nombre** | ACT Engine |
| **Versión** | 2.0 |
| **Proveedor** | BehavioralOS (propio) |
| **Tipo** | Motor de intervención psicológica basado en ACT |
| **Ejecución** | Backend (Python) + Reglas configuradas en DSL |
| **Propósito** | - Implementar ejercicios y protocolos de ACT (defusión, aceptación, valores, acción comprometida).<br>- Mapear ejercicios a procesos de la ontología.<br>- Adaptar las intervenciones según el perfil del paciente. |
| **Dependencias** | Ontología, BKGE, AAO, BERL, BSC. |
| **Consumido por** | BERL (generación de ejercicios), TCCN (diálogos terapéuticos), AAO (evaluación de procesos ACT). |
| **Alternativas** | Ninguna (especificación propia) |
| **Políticas de uso** | - Todas las intervenciones deben estar validadas por el ASC (Adaptive Scientific Council).<br>- Los ejercicios se versionan con el cambio de evidencia científica. |
| **Rendimiento** | - No es un motor de alto rendimiento; es una capa de lógica clínica.<br>- Respuesta < 100 ms en consultas. |
| **Licencia** | Propietario (BehavioralOS) |
| **Última actualización** | 2026-06-20 |
| **Estado** | Estable |

### 3.2. FAP Engine (Functional Analytic Psychotherapy)

| Atributo | Valor |
|----------|-------|
| **ID** | `PSY-002` |
| **Nombre** | FAP Engine |
| **Versión** | 1.0 |
| **Proveedor** | BehavioralOS (propio) |
| **Tipo** | Motor de análisis de conducta clínicamente significativa (CCS) |
| **Ejecución** | Backend (Python) + Reglas en DSL |
| **Propósito** | - Identificar CCS (CRB1, CRB2, CRB3).<br>- Sugerir respuestas terapéuticas (FAP 5 rules).<br>- Evaluar la calidad de la alianza terapéutica. |
| **Dependencias** | Ontología, AAO, TCCN, BKGE. |
| **Consumido por** | TCCN (diálogo), BPOS (notas clínicas), AAO (evaluación de la sesión). |
| **Alternativas** | Ninguna (especificación propia) |
| **Políticas de uso** | - Solo se activa durante sesiones con terapeuta.<br>- Las CCS se registran en el Behavioral Twin. |
| **Rendimiento** | - Respuesta < 50 ms en inferencias. |
| **Licencia** | Propietario |
| **Última actualización** | 2026-06-10 |
| **Estado** | Experimental (en validación clínica) |

### 3.3. PBT Engine (Process-Based Therapy)

| Atributo | Valor |
|----------|-------|
| **ID** | `PSY-003` |
| **Nombre** | PBT Engine |
| **Versión** | 1.0 |
| **Proveedor** | BehavioralOS (propio) |
| **Tipo** | Motor de terapia basada en procesos |
| **Ejecución** | Backend (Python) + Reglas en DSL |
| **Propósito** | - Modelar los 8 dominios y procesos de PBT.<br>- Seleccionar procesos objetivo basados en el perfil del paciente.<br>- Generar secuencias de intervención basadas en la evidencia. |
| **Dependencias** | Ontología, AAO, BKGE, BWM, BCC, MPO. |
| **Consumido por** | MPO (selección de procesos), AAO (evaluación), BERL (ejercicios). |
| **Alternativas** | Ninguna (especificación propia) |
| **Políticas de uso** | - La selección de procesos se basa en evidencia científica actualizada por el BSC.<br>- Las secuencias se validan mediante simulaciones. |
| **Rendimiento** | - Cálculo de prioridades: < 200 ms. |
| **Licencia** | Propietario |
| **Última actualización** | 2026-06-15 |
| **Estado** | Estable |

### 3.4. RFT Engine (Relational Frame Theory)

| Atributo | Valor |
|----------|-------|
| **ID** | `PSY-004` |
| **Nombre** | RFT Engine |
| **Versión** | 1.0 |
| **Proveedor** | BehavioralOS (propio) |
| **Tipo** | Motor de modelado y análisis de marcos relacionales |
| **Ejecución** | Backend (Python) + Grafos (NetworkX) |
| **Propósito** | - Extraer marcos relacionales del lenguaje natural (coordinación, distinción, oposición, etc.).<br>- Modelar redes RFT del paciente.<br>- Simular transformaciones de funciones.<br>- Evaluar la flexibilidad relacional. |
| **Dependencias** | Ontología, Gemma (NLP), NetworkX, BKGE. |
| **Consumido por** | AAO (análisis de lenguaje), TCCN (diálogo), BERL (ejercicios RFT), Behavioral Twin. |
| **Alternativas** | Ninguna (especificación propia) |
| **Políticas de uso** | - Los marcos extraídos se validan con un nivel de confianza.<br>- Las redes RFT se actualizan con cada conversación. |
| **Rendimiento** | - Extracción de marcos: < 500 ms por utterance.<br>- Simulación de transformaciones: < 100 ms. |
| **Licencia** | Propietario |
| **Última actualización** | 2026-06-20 |
| **Estado** | Estable |

### 3.5. EEMM Engine (Extended Evolutionary Meta-Model)

| Atributo | Valor |
|----------|-------|
| **ID** | `PSY-005` |
| **Nombre** | EEMM Engine |
| **Versión** | 1.0 |
| **Proveedor** | BehavioralOS (propio) |
| **Tipo** | Motor de meta-modelado evolutivo |
| **Ejecución** | Backend (Python) + Grafos (NetworkX) |
| **Propósito** | - Modelar las 6 dimensiones del EEMM (Cognición, Afecto, Atención, Self, Motivación, Conducta).<br>- Evaluar la interacción entre dimensiones.<br>- Simular la evolución del paciente a través del tiempo. |
| **Dependencias** | Ontología, AAO, BKGE, BWM, BCC, MPO. |
| **Consumido por** | MPO (planificación de intervenciones), AAO (evaluación), BWM (simulación), Behavioral Twin. |
| **Alternativas** | Ninguna (especificación propia) |
| **Políticas de uso** | - El modelo se actualiza con cada evaluación del AAO.<br>- Las simulaciones se usan para predecir trayectorias de cambio. |
| **Rendimiento** | - Actualización del modelo: < 300 ms.<br>- Simulación: < 1 s. |
| **Licencia** | Propietario |
| **Última actualización** | 2026-06-18 |
| **Estado** | Estable |

---

## 4. Categoría 3: Motores de Juego y Simulación

### 4.1. Godot Engine (Motor de Juegos)

| Atributo | Valor |
|----------|-------|
| **ID** | `GAME-001` |
| **Nombre** | Godot Engine |
| **Versión** | 4.3 (última estable) |
| **Proveedor** | Fundación Godot (Open Source) |
| **Tipo** | Motor de juegos 2D/3D |
| **Ejecución** | Web (WebAssembly), Móvil (Android/iOS), Desktop (Windows/Mac/Linux) |
| **Propósito** | - Implementar minijuegos terapéuticos (gamificación de ejercicios).<br>- Simulaciones de exposición, entornos virtuales.<br>- Visualización interactiva del Behavioral Twin (mapas, atlas). |
| **Dependencias** | BRIL (para eventos), jsPsych (telemetría), MediaPipe (integración con cámara), Web Audio API. |
| **Consumido por** | BERL (ejercicios), Patient App (experiencia), AHEE (adaptación visual). |
| **Alternativas** | Unity (con WebGL), Phaser (2D). |
| **Políticas de uso** | - Todos los minijuegos deben estar vinculados a un proceso psicológico (ontología).<br>- La telemetría se envía a BRIL y luego a AAO/BSC.<br>- Los assets deben ser ligeros (< 10 MB por juego). |
| **Rendimiento** | - 60 FPS en dispositivos modernos, 30 FPS en dispositivos limitados.<br>- Tamaño de build: 2-5 MB por juego. |
| **Licencia** | MIT |
| **Última actualización** | 2026-05-25 |
| **Estado** | Estable |

### 4.2. jsPsych (Motor de Experimentos Cognitivos)

| Atributo | Valor |
|----------|-------|
| **ID** | `GAME-002` |
| **Nombre** | jsPsych |
| **Versión** | 8.0.0 |
| **Proveedor** | Joshua de Leeuw (Open Source) |
| **Tipo** | Biblioteca para experimentos psicológicos en navegador |
| **Ejecución** | Web (JavaScript) |
| **Propósito** | - Implementar tareas cognitivas (Stroop, Go/NoGo, N-Back, Trail Making, etc.).<br>- Medir tiempos de reacción, precisión, latencia.<br>- Recopilar telemetría para evaluaciones neuropsicológicas funcionales. |
| **Dependencias** | BRIL (envío de telemetría), AAO (orquestación de evaluaciones). |
| **Consumido por** | AAO (evaluaciones), Neuropsychological Service, BERL (ejercicios). |
| **Alternativas** | PsychoPy (Web), Lab.js. |
| **Políticas de uso** | - Las tareas se adaptan al perfil del paciente (AHEE).<br>- Los datos se envían a BRIL y se integran con el Behavioral Twin. |
| **Rendimiento** | - Tiempo de reacción con precisión de milisegundos (requestAnimationFrame). |
| **Licencia** | MIT |
| **Última actualización** | 2026-04-10 |
| **Estado** | Estable |

---

## 5. Categoría 4: Motores de Backend y Datos

### 5.1. FastAPI (Framework Web)

| Atributo | Valor |
|----------|-------|
| **ID** | `BACK-001` |
| **Nombre** | FastAPI |
| **Versión** | 0.115.0 |
| **Proveedor** | Sebastián Ramírez (Open Source) |
| **Tipo** | Framework web asíncrono para Python |
| **Ejecución** | Servidor (Uvicorn) |
| **Propósito** | - Exponer APIs REST y WebSockets.<br>- Gestionar autenticación y autorización.<br>- Servir como capa de aplicación para todos los servicios. |
| **Dependencias** | Python 3.12+, Pydantic, SQLAlchemy, Supabase (PostgreSQL). |
| **Consumido por** | Todos los servicios backend (BCL, BBL, BOL, BDL, etc.). |
| **Alternativas** | Django (con DRF), Flask (con RESTX). |
| **Políticas de uso** | - Todas las APIs deben estar documentadas con OpenAPI 3.0.<br>- Se usa `async/await` para operaciones IO-bound.<br>- Versionado semántico en las rutas (ej. `/api/v1/...`). |
| **Rendimiento** | - < 50 ms de latencia base.<br>- Soporte para miles de conexiones simultáneas (asíncrono). |
| **Licencia** | MIT |
| **Última actualización** | 2026-06-01 |
| **Estado** | Estable |

### 5.2. Supabase (Backend-as-a-Service)

| Atributo | Valor |
|----------|-------|
| **ID** | `BACK-002` |
| **Nombre** | Supabase |
| **Versión** | Última estable (15.0) |
| **Proveedor** | Supabase Inc. |
| **Tipo** | Plataforma BaaS (PostgreSQL, Auth, Storage, Realtime) |
| **Ejecución** | Nube (con opción self-hosted) |
| **Propósito** | - Almacenar datos relacionales (PostgreSQL).<br>- Gestionar autenticación (JWT, OAuth, WebAuthn).<br>- Almacenar archivos (Storage).<br>- Proporcionar WebSockets (Realtime). |
| **Dependencias** | PostgreSQL (con pgvector), Redis (opcional). |
| **Consumido por** | Todos los servicios backend. |
| **Alternativas** | Firebase, AWS Amplify, Hasura. |
| **Políticas de uso** | - Se usa RLS (Row Level Security) para aislar tenants.<br>- Los datos clínicos se cifran en reposo.<br>- Las migraciones se versionan con Alembic. |
| **Rendimiento** | - PostgreSQL: depende de la configuración (replicación, índices).<br>- Se espera soporte para > 10,000 usuarios concurrentes. |
| **Licencia** | Apache 2.0 (self-hosted) / Propietario (nube) |
| **Última actualización** | 2026-06-10 |
| **Estado** | Estable |

### 5.3. Redis (Caché y Colas)

| Atributo | Valor |
|----------|-------|
| **ID** | `BACK-003` |
| **Nombre** | Redis |
| **Versión** | 7.4 |
| **Proveedor** | Redis Ltd. |
| **Tipo** | Base de datos en memoria (caché, colas, pub/sub) |
| **Ejecución** | Servidor (autónomo o en clúster) |
| **Propósito** | - Cache de sesiones y datos de usuario.<br>- Cola de eventos (Streams) para BRIL.<br>- Pub/Sub para notificaciones en tiempo real.<br>- Almacenamiento de locks distribuidos. |
| **Dependencias** | Ninguna (independiente). |
| **Consumido por** | BRIL (eventos), BIFL (caché), BOL (colas de trabajo), BSOS (locks). |
| **Alternativas** | Memcached (caché), RabbitMQ (colas), Kafka (eventos). |
| **Políticas de uso** | - Los datos en caché tienen TTL (Time-To-Live) configurable.<br>- Los eventos se persisten en disco (AOF) para recuperación. |
| **Rendimiento** | - < 1 ms de latencia.<br>- Soporte para > 100,000 operaciones/segundo. |
| **Licencia** | RSAL (Redis Source Available License) / SSPL |
| **Última actualización** | 2026-05-15 |
| **Estado** | Estable |

---

## 6. Categoría 5: Motores de Frontend

### 6.1. React (Framework de UI)

| Atributo | Valor |
|----------|-------|
| **ID** | `FRONT-001` |
| **Nombre** | React |
| **Versión** | 19.0 |
| **Proveedor** | Meta (Open Source) |
| **Tipo** | Biblioteca para interfaces de usuario |
| **Ejecución** | Web (navegador), Mobile (React Native) |
| **Propósito** | - Construir la interfaz del paciente (Nintendo) y del terapeuta (Apple).<br>- Gestionar el estado de la aplicación (Zustand/Redux).<br>- Renderizar gráficos y visualizaciones (Recharts, D3). |
| **Dependencias** | Node.js, Vite (bundler), Tailwind (estilos), Framer Motion (animaciones). |
| **Consumido por** | Patient App, Therapist App, Admin Dashboard. |
| **Alternativas** | Vue.js, Svelte, Angular. |
| **Políticas de uso** | - Se usa TypeScript para tipado estático.<br>- Los componentes son reutilizables (Storybook).<br>- Accesibilidad WCAG AA garantizada. |
| **Rendimiento** | - Optimizado con `memo`, `useCallback`, `useMemo`.<br>- Lazy loading para rutas y componentes. |
| **Licencia** | MIT |
| **Última actualización** | 2026-05-30 |
| **Estado** | Estable |

### 6.2. React Native (Aplicaciones Móviles)

| Atributo | Valor |
|----------|-------|
| **ID** | `FRONT-002` |
| **Nombre** | React Native |
| **Versión** | 0.75 |
| **Proveedor** | Meta (Open Source) |
| **Tipo** | Framework para aplicaciones móviles nativas |
| **Ejecución** | Android (Java/Kotlin), iOS (Swift/Objective-C) |
| **Propósito** | - Versión móvil de la Patient App (Nintendo).<br>- Acceso a sensores del dispositivo (acelerómetro, GPS, cámara, etc.). |
| **Dependencias** | React, Expo (opcional), librerías nativas. |
| **Consumido por** | Patient App (móvil). |
| **Alternativas** | Flutter, Kotlin Multiplatform. |
| **Políticas de uso** | - Se usa Expo para simplificar el desarrollo.<br>- Se integra con Godot (minijuegos) mediante WebView o plugins nativos. |
| **Rendimiento** | - 60 FPS en dispositivos modernos.<br>- Tamaño de APK/IPA optimizado. |
| **Licencia** | MIT |
| **Última actualización** | 2026-06-01 |
| **Estado** | Estable |

### 6.3. Tailwind CSS (Framework de Estilos)

| Atributo | Valor |
|----------|-------|
| **ID** | `FRONT-003` |
| **Nombre** | Tailwind CSS |
| **Versión** | 4.0 |
| **Proveedor** | Tailwind Labs (Open Source) |
| **Tipo** | Framework de utilidades CSS |
| **Ejecución** | Web |
| **Propósito** | - Estilizar todas las interfaces con rapidez y consistencia.<br>- Aplicar el Behavioral Design System (BDS) mediante tokens de diseño. |
| **Dependencias** | PostCSS, Autoprefixer. |
| **Consumido por** | Patient App, Therapist App, Admin Dashboard. |
| **Alternativas** | Bootstrap, Material-UI (con estilos personalizados). |
| **Políticas de uso** | - Se usa el sistema de diseño (BDS) para colores, tipografía, espaciado.<br>- Los estilos son personalizables por tenant (branding). |
| **Rendimiento** | - Tamaño final de CSS optimizado (PurgeCSS en producción). |
| **Licencia** | MIT |
| **Última actualización** | 2026-05-20 |
| **Estado** | Estable |

### 6.4. Framer Motion (Animaciones)

| Atributo | Valor |
|----------|-------|
| **ID** | `FRONT-004` |
| **Nombre** | Framer Motion |
| **Versión** | 11.0 |
| **Proveedor** | Framer (Open Source) |
| **Tipo** | Biblioteca de animaciones para React |
| **Ejecución** | Web |
| **Propósito** | - Implementar animaciones fluidas y microinteracciones.<br>- Crear transiciones suaves entre pantallas.<br>- Feedback visual para acciones del usuario. |
| **Dependencias** | React, Motion (core). |
| **Consumido por** | Patient App (Nintendo), Therapist App (Apple). |
| **Alternativas** | React Spring, GSAP. |
| **Políticas de uso** | - Las animaciones deben ser funcionales (comunicar progreso, feedback), no meramente decorativas.<br>- Se debe respetar la preferencia de movimiento reducido (`prefers-reduced-motion`). |
| **Rendimiento** | - Optimizado con GPU acceleration (transform, opacity). |
| **Licencia** | MIT |
| **Última actualización** | 2026-05-10 |
| **Estado** | Estable |

---

## 7. Categoría 6: Motores de Negocio y Comercio

### 7.1. Stripe (Pasarela de Pagos Internacional)

| Atributo | Valor |
|----------|-------|
| **ID** | `COMM-001` |
| **Nombre** | Stripe |
| **Versión** | API 2026-06-15 |
| **Proveedor** | Stripe Inc. |
| **Tipo** | Pasarela de pagos y gestión de suscripciones |
| **Ejecución** | Nube (API REST) |
| **Propósito** | - Procesar pagos con tarjeta de crédito/débito (internacional).<br>- Gestionar suscripciones y planes.<br>- Manejar webhooks de eventos (pago exitoso, fallido, renovación, cancelación). |
| **Dependencias** | Stripe SDK (Python), webhooks. |
| **Consumido por** | BCE (Behavioral Commerce Engine). |
| **Alternativas** | PayPal, Adyen, Braintree. |
| **Políticas de uso** | - Solo se usa para pagos internacionales.<br>- Los datos de tarjeta se manejan mediante Stripe Elements (PCI-DSS compliance).<br>- Los webhooks son idempotentes. |
| **Rendimiento** | - < 500 ms de latencia en transacciones. |
| **Licencia** | Propietario (SaaS) |
| **Última actualización** | 2026-06-15 |
| **Estado** | Estable |

### 7.2. Mercado Pago (Pasarela de Pagos México/Latam)

| Atributo | Valor |
|----------|-------|
| **ID** | `COMM-002` |
| **Nombre** | Mercado Pago |
| **Versión** | API 2026-06-01 |
| **Proveedor** | Mercado Libre |
| **Tipo** | Pasarela de pagos (tarjetas, efectivo, SPEI) |
| **Ejecución** | Nube (API REST) |
| **Propósito** | - Procesar pagos locales (México, Argentina, Chile, etc.).<br>- Aceptar pagos en efectivo (OXXO, etc.).<br>- Gestionar suscripciones locales. |
| **Dependencias** | Mercado Pago SDK (Python), webhooks. |
| **Consumido por** | BCE (Behavioral Commerce Engine). |
| **Alternativas** | Conekta, OpenPay, PayPal. |
| **Políticas de uso** | - Se usa para pagos en moneda local (MXN, ARS, etc.).<br>- Los webhooks son idempotentes.<br>- Los datos de tarjeta se manejan mediante Mercado Pago Checkout. |
| **Rendimiento** | - < 1 s de latencia en transacciones. |
| **Licencia** | Propietario (SaaS) |
| **Última actualización** | 2026-06-01 |
| **Estado** | Estable |

### 7.3. Facturapi (Facturación Electrónica CFDI 4.0)

| Atributo | Valor |
|----------|-------|
| **ID** | `COMM-003` |
| **Nombre** | Facturapi |
| **Versión** | API 2026-06-01 |
| **Proveedor** | Facturapi |
| **Tipo** | Servicio de facturación electrónica (CFDI) |
| **Ejecución** | Nube (API REST) |
| **Propósito** | - Generar facturas CFDI 4.0 (XML y PDF).<br>- Timbrar facturas mediante PAC (Proveedor Autorizado de Certificación).<br>- Enviar facturas por correo electrónico. |
| **Dependencias** | Facturapi SDK (Python), SAT (registro). |
| **Consumido por** | BCE (Behavioral Commerce Engine). |
| **Alternativas** | FiscalAPI, Aspel, Efi (PAC directo). |
| **Políticas de uso** | - Solo se usa para facturación en México.<br>- Los timbres se generan con el PAC asociado.<br>- Se deben validar los datos fiscales del cliente (RFC, régimen). |
| **Rendimiento** | - < 5 s por factura (incluyendo timbrado). |
| **Licencia** | Propietario (SaaS) |
| **Última actualización** | 2026-06-01 |
| **Estado** | Estable |

---

## 8. Categoría 7: Motores Científicos y Analíticos

### 8.1. NetworkX (Grafos)

| Atributo | Valor |
|----------|-------|
| **ID** | `SCI-001` |
| **Nombre** | NetworkX |
| **Versión** | 3.4 |
| **Proveedor** | NetworkX Developers (Open Source) |
| **Tipo** | Biblioteca para análisis de redes y grafos |
| **Ejecución** | Python (backend) |
| **Propósito** | - Modelar redes RFT (marcos relacionales).<br>- Representar el Behavioral Twin como grafo.<br>- Analizar centralidad, comunidades, caminos.<br>- Modelar interacciones entre procesos (EEMM, PBT). |
| **Dependencias** | NumPy, SciPy, Matplotlib (opcional). |
| **Consumido por** | BKGE, BWM, RFT Engine, EEMM Engine, Behavioral Twin. |
| **Alternativas** | Graph-tool, igraph, Neo4j (para persistencia). |
| **Políticas de uso** | - Los grafos se serializan en JSON para persistencia (PostgreSQL).<br>- Se usa NetworkX para análisis en memoria, no para almacenamiento. |
| **Rendimiento** | - Admite grafos de hasta 100,000 nodos en memoria.<br>- Análisis de centralidad: < 1 s para < 1,000 nodos. |
| **Licencia** | BSD 3-Clause |
| **Última actualización** | 2026-05-15 |
| **Estado** | Estable |

### 8.2. statsmodels (Estadística y Series Temporales)

| Atributo | Valor |
|----------|-------|
| **ID** | `SCI-002` |
| **Nombre** | statsmodels |
| **Versión** | 0.14.0 |
| **Proveedor** | Statsmodels Developers (Open Source) |
| **Tipo** | Biblioteca de modelado estadístico |
| **Ejecución** | Python (backend) |
| **Propósito** | - Modelar series temporales de procesos (ej. evolución de la aceptación).<br>- Calcular tendencias y estacionalidad.<br>- Realizar pruebas estadísticas (ej. comparación pre-post).<br>- Modelar relaciones entre variables (regresión, VAR). |
| **Dependencias** | Pandas, NumPy, SciPy, Matplotlib. |
| **Consumido por** | BIP (analytics), BSC (investigación), AAO (evaluación longitudinal), Behavioral Twin. |
| **Alternativas** | R (lme4), PyMC (Bayesiano), scikit-learn (machine learning). |
| **Políticas de uso** | - Se usa para análisis N=1 (series temporales individuales).<br>- Los modelos se actualizan con nuevos datos (ventana móvil). |
| **Rendimiento** | - Modelado VAR para < 10 variables: < 1 s. |
| **Licencia** | BSD 3-Clause |
| **Última actualización** | 2026-04-20 |
| **Estado** | Estable |

### 8.3. pyEDM (Empirical Dynamic Modeling)

| Atributo | Valor |
|----------|-------|
| **ID** | `SCI-003` |
| **Nombre** | pyEDM |
| **Versión** | 1.4.0 |
| **Proveedor** | EDM Developers (Open Source) |
| **Tipo** | Biblioteca para modelado dinámico empírico (EDM) |
| **Ejecución** | Python (backend) |
| **Propósito** | - Detectar relaciones causales no lineales en series temporales.<br>- Modelar sistemas dinámicos (atractores, estados).<br>- Simular escenarios "what-if" (contrafactuales). |
| **Dependencias** | NumPy, SciPy, rEDM (C++ backend). |
| **Consumido por** | BWM (simulación), BIP (predicción), BSC (investigación). |
| **Alternativas** | CCM (convergent cross-mapping) con métodos propios. |
| **Políticas de uso** | - Se usa cuando los datos longitudinales son suficientes (> 20 puntos).<br>- Los resultados se interpretan con cautela y se validan con otras fuentes. |
| **Rendimiento** | - Depende del tamaño de la serie (n > 50).<br>- Simulación: < 2 s para series cortas. |
| **Licencia** | Apache 2.0 |
| **Última actualización** | 2026-05-10 |
| **Estado** | Experimental (en validación) |

### 8.4. fuzzylogic (Lógica Difusa para Adaptación)

| Atributo | Valor |
|----------|-------|
| **ID** | `SCI-004` |
| **Nombre** | fuzzylogic |
| **Versión** | 1.0 (biblioteca propia) |
| **Proveedor** | BehavioralOS (propio) |
| **Tipo** | Motor de lógica difusa para decisión adaptativa |
| **Ejecución** | Python (backend) |
| **Propósito** | - Ajustar la dificultad de los ejercicios (DDA).<br>- Decidir el nivel de apoyo de la IA.<br>- Seleccionar el tipo de feedback.<br>- Calcular el riesgo de abandono. |
| **Dependencias** | Ninguna (implementación propia sobre NumPy). |
| **Consumido por** | AHEE (adaptación), BERL (dificultad), AAO (evaluación), BWM (simulación). |
| **Alternativas** | Scikit-fuzzy (basado en skfuzzy). |
| **Políticas de uso** | - Las reglas difusas se definen en el DSL y se actualizan con la evidencia.<br>- Los conjuntos difusos se calibran con datos de pacientes. |
| **Rendimiento** | - < 10 ms por decisión. |
| **Licencia** | Propietario |
| **Última actualización** | 2026-06-15 |
| **Estado** | Estable |

---

## 9. Categoría 8: Motores de Integración

### 9.1. BRIL (Behavioral Runtime Integration Layer)

| Atributo | Valor |
|----------|-------|
| **ID** | `INT-001` |
| **Nombre** | BRIL |
| **Versión** | 1.0 |
| **Proveedor** | BehavioralOS (propio) |
| **Tipo** | Motor de integración y orquestación en tiempo real |
| **Ejecución** | Backend (Python) + Redis (eventos) |
| **Propósito** | - Orquestar la comunicación entre todos los motores.<br>- Gestionar el bus de eventos.<br>- Proveer adaptadores para servicios externos.<br>- Gestionar colas de trabajo y reintentos. |
| **Dependencias** | Redis (Streams), FastAPI (adaptadores), Temporal.io (workflows largos). |
| **Consumido por** | Todos los motores que necesitan comunicarse (TCCN, AAO, BERL, BCE, BPOS, etc.). |
| **Alternativas** | Apache Kafka (eventos), RabbitMQ (colas), MuleSoft (integración). |
| **Políticas de uso** | - Todos los eventos se registran para auditoría.<br>- Los adaptadores son configurables (feature flags).<br>- Los reintentos siguen una política de backoff exponencial. |
| **Rendimiento** | - < 50 ms de latencia en el bus de eventos.<br>- Soporte para > 10,000 eventos/segundo. |
| **Licencia** | Propietario |
| **Última actualización** | 2026-06-20 |
| **Estado** | Estable |

### 9.2. Temporal.io (Workflows y Sagas)

| Atributo | Valor |
|----------|-------|
| **ID** | `INT-002` |
| **Nombre** | Temporal.io |
| **Versión** | 1.24 |
| **Proveedor** | Temporal Inc. |
| **Tipo** | Motor de orquestación de workflows (distribuidos) |
| **Ejecución** | Servidor (Temporal Cluster) |
| **Propósito** | - Ejecutar workflows largos y transaccionales (ej. compra → pago → factura → activación).<br>- Gestionar Sagas y compensaciones.<br>- Manejar reintentos y timeouts. |
| **Dependencias** | Redis (para estado), PostgreSQL (para eventos). |
| **Consumido por** | BCE (pagos), BPOS (onboarding), BSC (investigación). |
| **Alternativas** | Camunda, Zeebe, AWS Step Functions. |
| **Políticas de uso** | - Los workflows se definen en Python (Temporal SDK).<br>- Las Sagas se diseñan con compensaciones explícitas.<br>- Los workflows son idempotentes. |
| **Rendimiento** | - Latencia: < 100 ms por paso.<br>- Escalabilidad: horizontal mediante workers. |
| **Licencia** | MIT (SDK) / Propietario (Temporal Cloud) |
| **Última actualización** | 2026-05-15 |
| **Estado** | Estable |

---

## 10. Categoría 9: Motores del Núcleo del Ecosistema (Nivel 1)

Los siguientes motores constituyen el **núcleo fundamental** del ecosistema Behavioral. Definen el orden arquitectónico central y son dependencias obligatorias para todos los demás componentes.

### 10.1. BPE (Behavioral Process Engine)

| Atributo | Valor |
|----------|-------|
| **ID** | `CORE-001` |
| **Nombre** | Behavioral Process Engine |
| **Versión** | 1.0 |
| **Proveedor** | BehavioralOS (propio) |
| **Tipo** | Motor central de procesamiento psicológico |
| **Ejecución** | Backend (Python) + Event Stream (Redis) |
| **Propósito** | Motor central que orquesta el procesamiento psicológico: recibe datos crudos de múltiples fuentes (chat, juegos, evaluaciones, EMA, wearables), los clasifica, extrae procesos psicológicos relevantes y alimenta la ontología (BPO). |
| **Dependencias** | BPO, Redis Streams, PostgreSQL |
| **Consumido por** | BPO, BPG, BXE, BIK, todos los motores clínicos |
| **Alternativas** | Ninguna (motor fundamental) |
| **Políticas de uso** | - Es el único punto de entrada para datos conductuales crudos.<br>- Todos los eventos pasan por el BPE antes de ser distribuidos.<br>- Garantiza idempotencia en el procesamiento. |
| **Rendimiento** | - Throughput: > 1,000 eventos/segundo.<br>- Latencia: < 100ms por evento. |
| **Licencia** | Propietario |
| **Última actualización** | 2026-07-14 |
| **Estado** | Estable |

### 10.2. BPO (Behavioral Process Ontology)

| Atributo | Valor |
|----------|-------|
| **ID** | `CORE-002` |
| **Nombre** | Behavioral Process Ontology |
| **Versión** | 1.0 |
| **Proveedor** | BehavioralOS (propio) |
| **Tipo** | Ontología formal de procesos psicológicos |
| **Ejecución** | Backend (Python) + PostgreSQL (JSONB) |
| **Propósito** | Ontología formal que define los procesos psicológicos, sus dominios, relaciones, reglas de inferencia y vocabulario. Es el **lenguaje común** de todo el ecosistema. |
| **Dependencias** | PostgreSQL, NetworkX |
| **Consumido por** | BPE, BPG, BIK, BXE, BCAS, BDSS, BPAS, BERL, TCCN |
| **Alternativas** | Ninguna (fundamento ontológico propio) |
| **Políticas de uso** | - Toda modificación requiere aprobación del ASC (Adaptive Scientific Council).<br>- Las versiones se publican con changelog clínico.<br>- Cada proceso tiene definición, dominio, indicadores y reglas de detección. |
| **Rendimiento** | - Consultas: < 50ms.<br>- Inference: < 200ms. |
| **Licencia** | Propietario |
| **Última actualización** | 2026-07-14 |
| **Estado** | Estable |

### 10.3. BPG (Behavioral Process Graph)

| Atributo | Valor |
|----------|-------|
| **ID** | `CORE-003` |
| **Nombre** | Behavioral Process Graph |
| **Versión** | 1.0 |
| **Proveedor** | BehavioralOS (propio) |
| **Tipo** | Grafo dinámico de procesos del paciente |
| **Ejecución** | Backend (Python) + PostgreSQL (JSONB) + NetworkX (en memoria) |
| **Propósito** | Grafo dinámico que representa el estado de los procesos del paciente, sus interrelaciones, fuerzas, confianza y evolución temporal. Es el **"cerebro"** del ecosistema. |
| **Dependencias** | BPO, BPE, NetworkX, PostgreSQL |
| **Consumido por** | BXE, BIK, BCAS, BDSS, BPAS, BERL, TCCN, BIP |
| **Alternativas** | Ninguna (componente fundamental) |
| **Políticas de uso** | - Cada nodo tiene dominio, valor, confianza, estado e intensidad.<br>- Cada arista tiene tipo de relación, peso, confianza y evidencia.<br>- Los snapshots se toman al final de cada sesión terapéutica. |
| **Rendimiento** | - Actualización: < 200ms por evento.<br>- Consulta de subgrafo: < 100ms.<br>- Análisis de caminos: < 500ms para grafos < 1,000 nodos. |
| **Licencia** | Propietario |
| **Última actualización** | 2026-07-14 |
| **Estado** | Estable |

### 10.4. BPG-M (BPG Multilevel)

| Atributo | Valor |
|----------|-------|
| **ID** | `CORE-004` |
| **Nombre** | BPG Multilevel |
| **Versión** | 1.0 |
| **Proveedor** | BehavioralOS (propio) |
| **Tipo** | Extensión multinivel del grafo de procesos |
| **Ejecución** | Backend (Python) + PostgreSQL (JSONB) |
| **Propósito** | Extiende el BPG con soporte para múltiples niveles de abstracción: procesos atómicos, procesos compuestos, dominios completos y meta-procesos. Permite análisis a diferentes escalas. |
| **Dependencias** | BPG, BPO, NetworkX |
| **Consumido por** | BXE, BIK, BDSS, BIP, BERL |
| **Alternativas** | Ninguna |
| **Políticas de uso** | - Cada nivel tiene sus propias reglas de agregación.<br>- La navegación entre niveles es bidireccional. |
| **Rendimiento** | - Navegación entre niveles: < 300ms. |
| **Licencia** | Propietario |
| **Última actualización** | 2026-07-14 |
| **Estado** | Estable |

### 10.5. BXE (Behavioral Explainability Engine)

| Atributo | Valor |
|----------|-------|
| **ID** | `CORE-005` |
| **Nombre** | Behavioral Explainability Engine |
| **Versión** | 1.0 |
| **Proveedor** | BehavioralOS (propio) |
| **Tipo** | Motor de explicabilidad y trazabilidad clínica |
| **Ejecución** | Backend (Python) + PostgreSQL |
| **Propósito** | Motor de explicabilidad y trazabilidad clínica que documenta, reconstruye y comunica el razonamiento utilizado por la IA en cada evaluación, formulación, recomendación, ejercicio, adaptación o alerta. Consta de 14 submotores. |
| **Dependencias** | BPG, BKGE, Gemma, PostgreSQL |
| **Consumido por** | BIK, BCAS, BCMS, BIMS, BPAS, BDSS, BERL, BCI, BAD, BARS, todos los motores que generan decisiones |
| **Alternativas** | Ninguna (componente fundamental de transparencia) |
| **Políticas de uso** | - Toda decisión clínica automatizada debe poder explicarse.<br>- Las trazas de auditoría son inmutables.<br>- Retención: 10 años (datos clínicos). |
| **Rendimiento** | - Generación de explicación: < 200ms.<br>- Cobertura: 100% de decisiones clínicas. |
| **Licencia** | Propietario |
| **Última actualización** | 2026-07-14 |
| **Estado** | Estable |
| **Documentación** | Ver `bxe-spec.md` para arquitectura completa de 14 submotores. |

### 10.6. BIK (Behavioral Intelligence Kernel)

| Atributo | Valor |
|----------|-------|
| **ID** | `CORE-006` |
| **Nombre** | Behavioral Intelligence Kernel |
| **Versión** | 1.0 |
| **Proveedor** | BehavioralOS (propio) |
| **Tipo** | Núcleo central de orquestación e inteligencia |
| **Ejecución** | Backend (Python) + Redis + PostgreSQL |
| **Propósito** | Orquestador central que coordina, sincroniza, contextualiza y gobierna el funcionamiento de todos los motores clínicos, analíticos, adaptativos y operativos. Equivalente al Kernel de un sistema operativo. Consta de 20 submotores. |
| **Dependencias** | Redis Streams, PostgreSQL, Temporal.io |
| **Consumido por** | Todos los motores del ecosistema |
| **Alternativas** | Ninguna (componente fundamental de orquestación) |
| **Políticas de uso** | - Nunca reemplaza módulos; los coordina.<br>- Nunca decide por sí mismo; escala al terapeuta en conflictos.<br>- Gestiona confianza: < 0.5 → intervención humana; 0.5-0.7 → sugiere; > 0.7 → ejecuta. |
| **Rendimiento** | - Coordinación multi-motor: < 500ms end-to-end.<br>- Disponibilidad: 99.9%. |
| **Licencia** | Propietario |
| **Última actualización** | 2026-07-14 |
| **Estado** | Estable |
| **Documentación** | Ver `bik-architecture.md` para arquitectura completa de 20 submotores. |

### 10.7. BCMS (Behavioral Clinical Management System) — Ampliado

| Atributo | Valor |
|----------|-------|
| **ID** | `CORE-007` |
| **Nombre** | Behavioral Clinical Management System |
| **Versión** | 2.0 |
| **Proveedor** | BehavioralOS (propio) |
| **Tipo** | Sistema ampliado de gestión clínica |
| **Ejecución** | Backend (Python) + PostgreSQL |
| **Propósito** | Gestión integral del expediente clínico: intake, evaluaciones, notas, planes de tratamiento, seguimiento, alta. Ampliado para integrar datos del BPG y del Event Stream. |
| **Dependencias** | BPG, BPE, Event Stream, PostgreSQL |
| **Consumido por** | BIK, BPOS, BIP, TCCN, Reportes |
| **Alternativas** | Ninguna |
| **Políticas de uso** | - El expediente es la fuente de verdad clínica.<br>- Cada modificación genera evento en el Event Stream.<br>- Integra datos del BPG para contexto clínico. |
| **Rendimiento** | - CRUD: < 100ms.<br>- Consultas complejas: < 500ms. |
| **Licencia** | Propietario |
| **Última actualización** | 2026-07-14 |
| **Estado** | Estable |

### 10.8. BCIE (Behavioral Caseload Intelligence Engine)

| Atributo | Valor |
|----------|-------|
| **ID** | `CORE-008` |
| **Nombre** | Behavioral Caseload Intelligence Engine |
| **Versión** | 1.0 |
| **Proveedor** | BehavioralOS (propio) |
| **Tipo** | Motor de inteligencia de carga clínica |
| **Ejecución** | Backend (Python) + PostgreSQL |
| **Propósito** | Analiza la carga clínica del terapeuta: distribución de pacientes, riesgo de abandono, priorización de seguimiento, alertas de deterioro y optimización de la agenda. |
| **Dependencias** | BPG, BCMS, BPE, PostgreSQL |
| **Consumido por** | BIK, BPOS, BIP, BSI |
| **Alternativas** | Ninguna |
| **Políticas de uso** | - Prioriza automáticamente según riesgo y urgencia.<br>- Nunca reemplaza la decisión del terapeuta sobre asignación de casos. |
| **Rendimiento** | - Análisis de carga: < 2s para 100 pacientes.<br>- Alertas en tiempo real. |
| **Licencia** | Propietario |
| **Última actualización** | 2026-07-14 |
| **Estado** | Estable |

### 10.9. BCOE (Behavioral Clinic Operations Engine)

| Atributo | Valor |
|----------|-------|
| **ID** | `CORE-009` |
| **Nombre** | Behavioral Clinic Operations Engine |
| **Versión** | 1.0 |
| **Proveedor** | BehavioralOS (propio) |
| **Tipo** | Motor de operaciones clínicas |
| **Ejecución** | Backend (Python) + PostgreSQL + Temporal.io |
| **Propósito** | Gestiona las operaciones diarias de la clínica: agenda, citas, recordatorios, workflows de seguimiento, facturación de servicios clínicos y coordinación de equipo. |
| **Dependencias** | BCMS, BSI, Temporal.io, PostgreSQL |
| **Consumido por** | BIK, BPOS, BCE, BIP |
| **Alternativas** | Ninguna |
| **Políticas de uso** | - Automatiza flujos repetitivos (recordatorios, encuestas post-sesión).<br>- Integra con Google Calendar/Outlook vía BRIL. |
| **Rendimiento** | - Workflows: < 1s por paso.<br>- Recordatorios: envío en < 5s. |
| **Licencia** | Propietario |
| **Última actualización** | 2026-07-14 |
| **Estado** | Estable |

### 10.10. BSI (Behavioral Scheduling Intelligence)

| Atributo | Valor |
|----------|-------|
| **ID** | `CORE-010` |
| **Nombre** | Behavioral Scheduling Intelligence |
| **Versión** | 1.0 |
| **Proveedor** | BehavioralOS (propio) |
| **Tipo** | Motor de agenda inteligente |
| **Ejecución** | Backend (Python) + PostgreSQL |
| **Propósito** | Agenda inteligente que optimiza la asignación de citas considerando: disponibilidad del terapeuta, urgencia clínica, preferencias del paciente, distancia/geolocalización, y análisis predictivo de no-show. |
| **Dependencias** | BCIE, BCMS, PostgreSQL, BRIL (Google/Outlook Calendar) |
| **Consumido por** | BIK, BPOS, BCOE, Patient App |
| **Alternativas** | Ninguna |
| **Políticas de uso** | - Optimiza automáticamente pero permite override manual.<br>- Respeta preferencias del paciente (horarios, modalidad).<br>- Integra predicción de no-show para overbooking ético. |
| **Rendimiento** | - Optimización de agenda: < 1s para 50 slots.<br>- Re-agendamiento: < 500ms. |
| **Licencia** | Propietario |
| **Última actualización** | 2026-07-14 |
| **Estado** | Estable |

---

## 11. Matriz de Compatibilidad

### 11.1. Plataformas y Sistemas Operativos

| Motor | Android | iOS | Web (Chrome) | Web (Firefox) | Web (Safari) | Desktop (Win) | Desktop (Mac) | Desktop (Linux) |
|-------|---------|-----|--------------|---------------|--------------|---------------|---------------|-----------------|
| Gemma (LLM) | ✅ (NPU) | ✅ (NPU) | ✅ (WASM) | ✅ (WASM) | ✅ (WASM) | ✅ (CPU) | ✅ (CPU) | ✅ (CPU) |
| MediaPipe | ✅ | ✅ | ✅ (WASM) | ✅ (WASM) | ✅ (WASM) | ✅ (C++) | ✅ (C++) | ✅ (C++) |
| Godot | ✅ | ✅ | ✅ (WASM) | ✅ (WASM) | ✅ (WASM) | ✅ | ✅ | ✅ |
| jsPsych | ⚠️ (via WebView) | ⚠️ (via WebView) | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| React Native | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| FastAPI | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | ✅ | ✅ |
| Supabase | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Redis | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | ✅ | ✅ |

> **Leyenda**: ✅ = Soporte nativo, ⚠️ = Soporte limitado o mediante adaptador, ❌ = No soportado.

---

## 12. Políticas de Actualización y Sustitución

### 12.1. Ciclo de Vida de un Motor

1. **Evaluación**: Se identifica una nueva versión o alternativa. Se evalúa su compatibilidad, rendimiento y seguridad.
2. **Pruebas en Sandbox**: Se instala en un entorno de pruebas (sandbox) con pacientes sintéticos.
3. **Validación**: Se ejecutan las pruebas del BQAS (unitarias, de integración, clínicas, de rendimiento).
4. **Aprobación**: Si pasa todas las pruebas, se aprueba para producción (o se rechaza).
5. **Despliegue gradual**: Se implementa en producción con un rollout gradual (canary release).
6. **Monitoreo**: Se monitoriza su rendimiento durante 2 semanas. Si falla, se revierte.

### 12.2. Criterios de Sustitución

Un motor puede ser sustituido si:

- **Rendimiento**: La alternativa ofrece al menos un 30% de mejora en latencia o consumo de recursos.
- **Seguridad**: Se detecta una vulnerabilidad crítica no parcheable.
- **Soporte**: El proveedor deja de dar soporte o la licencia cambia a una incompatible.
- **Costo**: La alternativa reduce los costos operativos significativamente.
- **Funcionalidad**: La alternativa ofrece una funcionalidad esencial que el motor actual no tiene.

### 12.3. Versionado de Motores

- Cada motor se versiona semánticamente (MAJOR.MINOR.PATCH).
- **MAJOR**: Cambios incompatibles en la API o en la funcionalidad.
- **MINOR**: Adición de nuevas funcionalidades (compatibles).
- **PATCH**: Correcciones de errores y parches de seguridad.
- El BehavioralOS mantiene una matriz de compatibilidad entre versiones de motores.

---

## 13. Gobernanza de Motores

### 13.1. Comité de Tecnología
- Un comité formado por arquitectos, líderes técnicos y científicos evalúa las propuestas de nuevos motores o actualizaciones.
- El comité revisa la documentación, las pruebas y el impacto en el ecosistema.

### 13.2. Registro de Motores
- Todos los motores se registran en el Behavioral Engine Registry (parte del BREO).
- Cada registro incluye: ID, nombre, versión, proveedor, dependencias, consumidores, políticas de uso, estado y fecha de última actualización.

### 13.3. Documentación Obligatoria
- Cada motor debe tener una ficha técnica (como las de este documento) que se mantenga actualizada.
- La documentación se almacena en el repositorio y se indexa en el BKI (Behavioral Knowledge Index).

---

## 14. El Manifiesto de Motores

> *"Un motor no es una elección técnica aislada. Es una decisión estratégica que afecta a todo el ecosistema.*
>
> *Cada motor que incorporamos debe ser evaluado no solo por su rendimiento hoy, sino por su capacidad de integrarse con el resto y de evolucionar con nosotros.*
>
> *La diversidad tecnológica es riqueza, pero solo si está gobernada por un propósito común: servir a la ciencia del comportamiento y a las personas que buscan cambio."*

---

## 15. Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2026-07-01 | Arquitectura Jefe | Creación del documento. Catálogo inicial de 25+ motores con fichas técnicas, matriz de compatibilidad y políticas de gobernanza. |
| 2.0.0 | 2026-07-14 | Arquitectura Jefe | Agregado de 10 motores del núcleo del ecosistema (Nivel 1): BPE, BPO, BPG, BPG-M, BXE, BIK, BCMS (ampliado), BCIE, BCOE, BSI. Total actualizado a ~35+ motores. Agregadas dependencias de bik-architecture, bxe-spec y event-sourcing-architecture. |
| 2.1.0 | 2026-07-27 | Arquitectura Jefe | Agregada sección 1.4 (Principios POO en el Diseño de Motores) explicando cómo se aplican Abstracción, Encapsulación, Polimorfismo y Herencia según TCD-001 §5 al diseño de motores del BehavioralOS. |

---

**Fin del documento `engines-overview.md`**