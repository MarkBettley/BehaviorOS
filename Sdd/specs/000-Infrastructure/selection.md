---
id: INF-001
title: Selección de Infraestructura y Motores (Opciones Gratuitas)
version: 1.0.0
status: Stable
owner: Arquitectura de Software & DevOps
last_updated: 2026-07-01
depends_on: []
exports:
  - Estrategia de selección de tecnologías gratuitas/open source
  - Tabla de equivalencias: motor de paga → alternativa gratuita
  - Límites y condiciones de las versiones gratuitas
  - Plan de migración a versiones de paga cuando sea necesario
  - Enlaces a documentación y guías de configuración
used_by:
  - Todos los módulos (backend, frontend, IA, comercio, etc.)
  - Equipo de desarrollo (para elegir herramientas)
  - DevOps (para configurar infraestructura)
---

# BehavioralOS – Selección de Infraestructura y Motores (Opciones Gratuitas)

> *"Construir un proyecto de esta magnitud no debería requerir una inversión inicial en infraestructura. Existen herramientas gratuitas y de código abierto que, bien configuradas, pueden sostener el desarrollo y las primeras fases de producción sin costos. Este documento guía la elección de cada componente tecnológico priorizando lo gratuito, y señala cuándo y cómo migrar a soluciones de pago cuando el proyecto crezca."*

---

## 1. Propósito y Alcance

### 1.1. Propósito
Este documento establece las **decisiones de infraestructura y selección de motores** del BehavioralOS, con un enfoque en opciones gratuitas, de código abierto o con planes gratuitos generosos que permitan desarrollar y lanzar el producto sin costos iniciales significativos.

**Objetivos**:
- **Minimizar costos iniciales**: Utilizar versiones gratuitas siempre que sea posible.
- **Garantizar escalabilidad**: Elegir herramientas que permitan migrar a versiones de pago sin reescribir la arquitectura.
- **Mantener calidad y rendimiento**: No sacrificar la funcionalidad por el precio; las alternativas gratuitas deben ser equivalentes o suficientemente cercanas.
- **Facilitar el desarrollo**: Proveer instrucciones claras sobre cómo configurar cada opción gratuita.

### 1.2. Alcance
Cubre todos los motores y frameworks mencionados en los archivos de especificación (YAML y MD), organizados por categorías:

- Backend y Bases de Datos
- Frontend y UI
- IA y Machine Learning
- Juegos y Gamificación
- Comercio y Pagos
- Videoterapia y Comunicación
- Workflows e Integración
- Testing y Calidad
- Despliegue y Monitoreo
- Seguridad y Cumplimiento

### 1.3. Principio Fundamental
> **"No pagues por lo que puedes obtener gratis, pero no escatimes en lo que es esencial. Las herramientas de pago solo se utilizan cuando la alternativa gratuita no existe, es insuficiente en funcionalidad o no cumple con requisitos regulatorios (como facturación CFDI o pagos con tarjeta)."**

---

## 2. Estrategia General

### 2.1. Criterios de Selección

| Criterio | Ponderación | Descripción |
|----------|-------------|-------------|
| **Costo** | Alta | Priorizar herramientas con planes gratuitos suficientes para MVP y primeros 1000 usuarios. |
| **Open Source** | Media | Preferir herramientas de código abierto que se puedan autohospedar para mayor control. |
| **Escalabilidad** | Alta | La herramienta debe permitir migrar a una versión de pago o a una infraestructura más potente sin reescribir. |
| **Comunidad y Documentación** | Media | Tener buena documentación y soporte comunitario para resolver problemas. |
| **Integración** | Media | Que se integre bien con el resto del stack (ej. FastAPI, React, PostgreSQL). |

### 2.2. Clasificación de Herramientas

| Categoría | Herramientas de Paga (si no hay alternativa) | Alternativas Gratuitas/Open Source |
|-----------|----------------------------------------------|------------------------------------|
| **Pagos** | Stripe (internacional), Mercado Pago (México) | No hay alternativa gratuita para procesar pagos con tarjeta de forma segura. |
| **Facturación CFDI** | Facturapi, FiscalAPI | No hay alternativa gratuita para timbrar CFDI (requiere PAC). |
| **Correo Transaccional** | SendGrid (pago), Brevo (pago), Resend (pago) | Planes gratuitos con límites suficientes para MVP. |
| **Mensajería (WhatsApp)** | Twilio, WhatsApp Business API | Plan gratuito con límites, pero requiere aprobación de Meta. |
| **Videoterapia** | Zoom Pro, Google Meet Enterprise | Jitsi (open source, autohospedado), Google Meet (gratis con límites). |
| **Backend** | Supabase (plan Pro), AWS | Supabase (plan gratuito), PostgreSQL autohospedado. |
| **Base de Datos** | AWS RDS, Azure SQL | PostgreSQL autohospedado, Supabase (gratis), TimescaleDB (gratis). |
| **Cache/Colas** | Redis Enterprise | Redis (open source), autohospedado. |
| **Workflows** | Temporal Cloud | Temporal (open source), autohospedado. |
| **Monitoreo** | Datadog, New Relic | Prometheus + Grafana (open source), Sentry (plan gratuito). |
| **IA (LLM)** | OpenAI API, Claude API | Gemma (on-device, gratis), Llama (open source). |
| **IA (Visión)** | AWS Rekognition | MediaPipe (on-device, gratis). |
| **IA (Voz)** | Google Cloud Speech-to-Text | Whisper (on-device, gratis). |

---

## 3. Análisis por Categoría y Recomendaciones

### 3.1. Backend y Bases de Datos

#### 3.1.1. Framework Web

| Motor | Opción de Paga | Alternativa Gratuita | Configuración | Límites |
|-------|----------------|----------------------|---------------|---------|
| **FastAPI** | No aplica (open source) | FastAPI (gratis) | Usar Uvicorn como servidor. | Sin límites. |

**Instrucciones**:
- FastAPI es open source y se puede usar sin costos.
- Para producción, usar Uvicorn con workers y Gunicorn como gestor de procesos.

#### 3.1.2. Base de Datos Relacional

| Motor | Opción de Paga | Alternativa Gratuita | Configuración | Límites |
|-------|----------------|----------------------|---------------|---------|
| **PostgreSQL** | AWS RDS, Azure DB | **Supabase** (plan gratuito) | Crear proyecto en Supabase (500 MB base de datos). | 500 MB, 2 GB de ancho de banda, 2 proyectos. |
| | | **PostgreSQL autohospedado** (Docker) | Instalar con Docker Compose. | Sin límites (depende del hardware). |

**Recomendación**:
- **Para desarrollo y primeras fases**: Supabase (gratis) por su facilidad y servicios adicionales (Auth, Storage, Realtime).
- **Para escalar**: Migrar a PostgreSQL autohospedado o a un plan de pago de Supabase cuando se superen los 500 MB.

#### 3.1.3. Cache y Colas

| Motor | Opción de Paga | Alternativa Gratuita | Configuración | Límites |
|-------|----------------|----------------------|---------------|---------|
| **Redis** | Redis Enterprise (pago) | **Redis** (open source) | Instalar con Docker o usar el servicio de Redis en Supabase (limitado). | Sin límites (autohospedado). |

**Recomendación**:
- **Autohospedar Redis** con Docker Compose (gratis).
- **Para colas**: Usar Redis Streams (gratis) o BullMQ con Redis.

#### 3.1.4. Series Temporales (Telemetría)

| Motor | Opción de Paga | Alternativa Gratuita | Configuración | Límites |
|-------|----------------|----------------------|---------------|---------|
| **TimescaleDB** | Timescale Cloud (pago) | **TimescaleDB** (open source) | Instalar como extensión de PostgreSQL. | Sin límites (autohospedado). |

**Recomendación**:
- **Autohospedar TimescaleDB** con Docker (gratis) o usar la extensión en Supabase (si está disponible).

#### 3.1.5. Almacenamiento de Archivos (S3)

| Motor | Opción de Paga | Alternativa Gratuita | Configuración | Límites |
|-------|----------------|----------------------|---------------|---------|
| **Supabase Storage** | Plan Pro (pago) | **Supabase Storage** (gratis) | Usar Supabase Storage (1 GB gratis). | 1 GB, 2 GB de ancho de banda. |
| | | **MinIO** (open source) | Autohospedar MinIO con Docker. | Sin límites (depende del hardware). |

**Recomendación**:
- **Para archivos pequeños (sprites, PDFs)**: Supabase Storage (gratis) hasta 1 GB.
- **Para escalar**: Migrar a MinIO (autohospedado) o a un proveedor S3 compatible.

---

### 3.2. Frontend y UI

| Motor | Opción de Paga | Alternativa Gratuita | Configuración | Límites |
|-------|----------------|----------------------|---------------|---------|
| **React** | No aplica (open source) | React (gratis) | Usar Vite o Create React App. | Sin límites. |
| **React Native** | No aplica (open source) | React Native (gratis) | Usar Expo para facilitar el desarrollo. | Sin límites. |
| **Tailwind CSS** | No aplica (open source) | Tailwind (gratis) | Usar con PostCSS. | Sin límites. |
| **Framer Motion** | No aplica (open source) | Framer Motion (gratis) | Instalar con npm. | Sin límites. |
| **Storybook** | No aplica (open source) | Storybook (gratis) | Usar para documentar componentes. | Sin límites. |

**Recomendación**:
- Todas las herramientas frontend son gratuitas y open source. No hay necesidad de versiones de paga.

---

### 3.3. IA y Machine Learning

| Motor | Opción de Paga | Alternativa Gratuita | Configuración | Límites |
|-------|----------------|----------------------|---------------|---------|
| **Gemma (LLM)** | No aplica (open source) | Gemma (gratis) | Descargar modelo GGUF y usar MediaPipe. | Sin límites (local). |
| **MediaPipe** | No aplica (open source) | MediaPipe (gratis) | Usar en web, Android, iOS. | Sin límites. |
| **Whisper (Voz)** | No aplica (open source) | Whisper (gratis) | Usar versión tiny o base. | Sin límites (local). |
| **ONNX Runtime** | No aplica (open source) | ONNX Runtime (gratis) | Usar para ejecutar modelos. | Sin límites. |
| **Sentence-Transformers** | No aplica (open source) | sentence-transformers (gratis) | Usar multilingual-e5-small. | Sin límites (local). |

**Recomendación**:
- Todas las herramientas de IA son gratuitas y se ejecutan localmente (on-device). No requieren costos adicionales.

---

### 3.4. Juegos y Gamificación

| Motor | Opción de Paga | Alternativa Gratuita | Configuración | Límites |
|-------|----------------|----------------------|---------------|---------|
| **Godot Engine** | No aplica (open source) | Godot (gratis) | Usar Godot 4.3. | Sin límites. |
| **jsPsych** | No aplica (open source) | jsPsych (gratis) | Usar en web. | Sin límites. |

**Recomendación**:
- Ambas herramientas son gratuitas y open source.

---

### 3.5. Comercio y Pagos

| Motor | Opción de Paga | Alternativa Gratuita | Configuración | Límites |
|-------|----------------|----------------------|---------------|---------|
| **Stripe** | Pago por transacción (2.9% + $0.30 USD) | No hay alternativa gratuita | Configurar Stripe Connect. | Sin límites (pago por uso). |
| **Mercado Pago** | Pago por transacción | No hay alternativa gratuita | Configurar Mercado Pago Checkout. | Sin límites (pago por uso). |
| **Facturapi (CFDI)** | Pago por timbre (aprox. $5-10 MXN) | No hay alternativa gratuita (requiere PAC) | Usar Facturapi o FiscalAPI. | Pago por timbre. |

**Recomendación**:
- Estas son herramientas de pago **necesarias** porque no existen alternativas gratuitas que cumplan con los requisitos regulatorios (procesamiento de pagos con tarjeta, facturación CFDI). Se asume que los costos serán absorbidos por el negocio (comisiones por transacción).

---

### 3.6. Videoterapia y Comunicación

| Motor | Opción de Paga | Alternativa Gratuita | Configuración | Límites |
|-------|----------------|----------------------|---------------|---------|
| **Google Meet** | Google Workspace (pago) | **Google Meet** (gratis) | Usar la API de Google Meet (limitada). | 60 minutos por sesión (gratis). |
| **Zoom** | Zoom Pro (pago) | **Zoom** (gratis) | Usar plan gratuito (40 minutos por sesión). | 40 minutos por sesión. |
| **Jitsi** | No aplica (open source) | **Jitsi Meet** (gratis) | Autohospedar Jitsi con Docker. | Sin límites (autohospedado). |

**Recomendación**:
- **Para MVP**: Usar Google Meet (gratis) con límite de 60 minutos, o Zoom (gratis) con 40 minutos.
- **Para escalar**: Autohospedar Jitsi (open source) o migrar a Google Workspace/Zoom Pro cuando se necesiten más funciones.

---

### 3.7. Workflows e Integración

| Motor | Opción de Paga | Alternativa Gratuita | Configuración | Límites |
|-------|----------------|----------------------|---------------|---------|
| **Temporal.io** | Temporal Cloud (pago) | **Temporal** (open source) | Autohospedar con Docker. | Sin límites (autohospedado). |
| **Redis Streams** | Redis Enterprise (pago) | **Redis** (open source) | Usar Redis con Streams. | Sin límites (autohospedado). |

**Recomendación**:
- **Autohospedar Temporal** con Docker (gratis) para workflows largos.
- **Usar Redis** para colas y eventos (gratis).

---

### 3.8. Testing y Calidad

| Motor | Opción de Paga | Alternativa Gratuita | Configuración | Límites |
|-------|----------------|----------------------|---------------|---------|
| **Pytest** | No aplica (open source) | Pytest (gratis) | Usar con pytest-cov. | Sin límites. |
| **Jest** | No aplica (open source) | Jest (gratis) | Usar para testing de React. | Sin límites. |
| **Playwright** | No aplica (open source) | Playwright (gratis) | Usar para E2E. | Sin límites. |
| **axe-core** | No aplica (open source) | axe-core (gratis) | Usar para accesibilidad. | Sin límites. |
| **Lighthouse** | No aplica (open source) | Lighthouse (gratis) | Usar en CI/CD. | Sin límites. |
| **k6** | k6 Cloud (pago) | **k6** (open source) | Usar k6 localmente. | Sin límites. |

**Recomendación**:
- Todas las herramientas de testing son gratuitas y open source.

---

### 3.9. Despliegue y Monitoreo

| Motor | Opción de Paga | Alternativa Gratuita | Configuración | Límites |
|-------|----------------|----------------------|---------------|---------|
| **Docker** | No aplica (open source) | Docker (gratis) | Usar Docker Compose. | Sin límites. |
| **Kubernetes** | No aplica (open source) | Kubernetes (gratis) | Usar minikube o k3s para desarrollo. | Sin límites (autohospedado). |
| **GitHub Actions** | GitHub Actions (pago por minutos extra) | **GitHub Actions** (gratis) | Usar plan gratuito (2000 minutos/mes). | 2000 minutos/mes. |
| **Prometheus + Grafana** | No aplica (open source) | Prometheus + Grafana (gratis) | Autohospedar con Docker. | Sin límites. |
| **Sentry** | Sentry (pago) | **Sentry** (plan gratuito) | Usar plan gratuito (5k errores/mes). | 5k errores/mes. |

**Recomendación**:
- **Docker Compose** para desarrollo y primeras fases de producción.
- **GitHub Actions** (gratis) para CI/CD.
- **Prometheus + Grafana** para monitoreo (open source).
- **Sentry** (gratis) para errores en producción.

---

### 3.10. Seguridad y Cumplimiento

| Motor | Opción de Paga | Alternativa Gratuita | Configuración | Límites |
|-------|----------------|----------------------|---------------|---------|
| **OWASP ZAP** | No aplica (open source) | OWASP ZAP (gratis) | Usar en CI/CD. | Sin límites. |
| **Bandit** | No aplica (open source) | Bandit (gratis) | Usar para Python. | Sin límites. |
| **Semgrep** | Semgrep (pago) | **Semgrep** (open source) | Usar versión community. | Sin límites (open source). |
| **Trivy** | No aplica (open source) | Trivy (gratis) | Usar para escaneo de vulnerabilidades en contenedores. | Sin límites. |

**Recomendación**:
- Todas las herramientas de seguridad son gratuitas y open source.

---

## 4. Plan de Migración a Versiones de Paga

### 4.1. Cuándo Migrar

| Componente | Versión Gratuita | Límite | Acción de Migración |
|------------|------------------|--------|---------------------|
| **Supabase (BD)** | 500 MB, 2 GB ancho de banda | Superar 500 MB o 2 GB | Migrar a Supabase Pro ($25/mes) o autohospedar PostgreSQL. |
| **GitHub Actions** | 2000 minutos/mes | Superar 2000 minutos | Migrar a GitHub Actions (pago por minutos extra) o migrar a otro CI/CD (ej. GitLab CI). |
| **Sentry** | 5k errores/mes | Superar 5k errores | Migrar a Sentry (pago) o a alternativa open source (Sentry self-hosted). |
| **Google Meet** | 60 min/sesión | Necesitar sesiones > 60 min | Migrar a Google Workspace ($6/usuario/mes) o a Zoom Pro. |
| **Zoom** | 40 min/sesión | Necesitar sesiones > 40 min | Migrar a Zoom Pro ($14.99/mes) o a Google Meet (con Workspace). |

### 4.2. Estrategia de Migración

- **Base de Datos**: Migrar de Supabase a PostgreSQL autohospedado cuando se superen los límites de almacenamiento o ancho de banda. El esquema es compatible (ambos usan PostgreSQL).
- **CI/CD**: Si se superan los minutos de GitHub Actions, considerar migrar a GitLab CI (gratis con minutos ilimitados para proyectos open source) o a un runner self-hosted.
- **Monitoreo**: Si Sentry se vuelve costoso, autohospedar Sentry (open source) o migrar a alternativa como GlitchTip.
- **Videoterapia**: Si las sesiones gratuitas de Google Meet/Zoom no son suficientes, autohospedar Jitsi (open source) o migrar a un plan de pago.

---

## 5. Resumen de Costos Estimados (Fase Inicial)

| Componente | Costo Mensual (gratis) | Notas |
|------------|------------------------|-------|
| **Backend (FastAPI)** | $0 | Open source. |
| **Base de Datos (Supabase)** | $0 | Plan gratuito: 500 MB, 2 GB ancho de banda. |
| **Cache/Colas (Redis)** | $0 | Autohospedado con Docker. |
| **Frontend** | $0 | Todas las herramientas open source. |
| **IA (Gemma, MediaPipe, Whisper)** | $0 | Ejecución local. |
| **Godot, jsPsych** | $0 | Open source. |
| **Pagos (Stripe, Mercado Pago)** | Pago por transacción | Costo variable (2.9% + $0.30 USD por Stripe). |
| **Facturación (Facturapi)** | Pago por timbre | Aprox. $5-10 MXN por factura. |
| **Videoterapia (Google Meet)** | $0 | Límite: 60 min/sesión. |
| **CI/CD (GitHub Actions)** | $0 | Límite: 2000 min/mes. |
| **Monitoreo (Prometheus + Grafana)** | $0 | Autohospedado. |
| **Errores (Sentry)** | $0 | Límite: 5k errores/mes. |

**Costo total mensual estimado (fase inicial)**:
- **Infraestructura**: $0 (excepto pagos y facturación).
- **Pagos**: Depende del volumen de transacciones (aprox. 3% del ingreso).
- **Facturación**: Depende del número de facturas emitidas.

---

## 6. El Manifiesto de la Infraestructura Gratuita

> *"No pagamos por lo que podemos obtener gratis, pero no escatimamos en lo que es esencial.*
>
> *La infraestructura gratuita no es un compromiso con la calidad, sino una decisión estratégica para invertir nuestros recursos en lo que realmente importa: la ciencia del comportamiento y la experiencia del usuario.*
>
> *Cuando el proyecto crezca, migraremos a versiones de pago sin remordimientos, porque cada dólar invertido en infraestructura se habrá ganado con el éxito del producto.*
>
> *Mientras tanto, construimos sobre los hombros de gigantes open source, agradecidos por su trabajo y comprometidos a contribuir cuando podamos."*

---

## 7. Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2026-07-01 | Arquitectura de Software | Creación del documento. Análisis exhaustivo de todos los motores y frameworks del proyecto, con recomendaciones de alternativas gratuitas y plan de migración. |

---

**Fin del documento `selection.md`**