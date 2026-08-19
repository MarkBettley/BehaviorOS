# BehavioralOS

> **El Nintendo de la Psicoterapia** – Plataforma de psicoterapia gamificada basada en procesos, con IA on-device, evaluación adaptativa, y experiencias inspiradas en Nintendo para pacientes y Apple para terapeutas.

---

## 📖 Tabla de Contenidos

1. [Visión General](#visión-general)
2. [Arquitectura de Alto Nivel](#arquitectura-de-alto-nivel)
3. [Estructura de Carpetas](#estructura-de-carpetas)
4. [Orden de Construcción](#orden-de-construcción)
5. [Tecnologías Principales](#tecnologías-principales)
6. [Restricciones Clave](#restricciones-clave)
7. [Variables de Entorno](#variables-de-entorno)
8. [Primeros Pasos](#primeros-pasos)
9. [Cómo Usar los SDD con IA](#cómo-usar-los-sdd-con-ia)
10. [Guía de Estilo y Calidad](#guía-de-estilo-y-calidad)
11. [Licencia](#licencia)

---

## Visión General

**BehavioralOS** es una plataforma integral de psicoterapia gamificada que combina:

- **Psicología científica** (ACT, FAP, DBT, PBT, RFT, neuropsicología funcional)
- **Inteligencia artificial** on-device (Gemma, MediaPipe, Whisper)
- **Diseño de juegos** (inspirado en Nintendo para pacientes)
- **Productividad clínica** (inspirado en Apple para terapeutas)
- **Evaluación adaptativa** continua (AAO)
- **Análisis funcional** idiográfico (Behavioral Twin)
- **Comercio y facturación** (suscripciones, CFDI, marketplace)

El objetivo del sistema es **ayudar a las personas a desarrollar habilidades psicológicas duraderas** mediante experiencias interactivas personalizadas, basadas en análisis funcional y diseño de juegos.

---

## Arquitectura de Alto Nivel

El BehavioralOS se organiza en **16 carpetas de especificación** bajo `/specs/` (incluyendo `index/`, punto de entrada):

| Módulo | Nombre | Descripción |
|--------|--------|-------------|
| **000-Core** | Núcleo Filosófico y Ontológico | Misión, principios, ontología del comportamiento y vocabulario controlado. |
| **000-Infrastructure** | Infraestructura y Selección Tecnológica | Herramientas gratuitas y plan de migración. |
| **100-Architecture** | Arquitectura del Sistema | BEA, BREO, Behavioral Twin y modelo de datos. |
| **200-Backend** | Backend y Servicios | APIs, bases de datos, eventos, workflows y motor transaccional. |
| **300-Frontend** | Frontend y Experiencia de Usuario | BDS, UI, accesibilidad, Patient App, Therapist App, Brand Studio. |
| **400-AI** | Inteligencia Artificial y Motores Cognitivos | Gemma, TCCN, AAO, guardrails, BKGE y BSC. |
| **500-Experiencies** | Experiencias Terapéuticas y Gamificación | BERL, BML, motor de procesos y mapeo clínico. |
| **600-Commerce** | Motor Comercial y Facturación | BCE, suscripciones, pagos, CFDI, marketplace, Website Builder. |
| **700-PracticeOS** | Sistema Operativo del Consultorio Clínico | BPOS, agenda, EHR, videoterapia, CRM, workflows, automation, relationship engine. |
| **800-Analytics** | Inteligencia Analítica y Científica | BIP, dashboards, KPIs, predicciones, BROS, investigación. |
| **900-Security** | Seguridad y Gobernanza | BSOS, identidad, permisos, cifrado, auditoría. |
| **1000-Integration** | Integración y Orquestación en Tiempo Real | BRIL, Event Bus, adaptadores, colas, sincronización. |
| **1100-Testing** | Aseguramiento de Calidad y Testing | BQAS, pruebas unitarias, integración, clínicas, científicas, IA, seguridad. |
| **1200-Deployment** | Despliegue, Infraestructura y Operaciones | DevOps, CI/CD, contenedores, monitoreo, backups. |
| **1300-Libraries** | Arquitectura de Bibliotecas | 72 bibliotecas (Foundation, Intelligence, Application), schemas de calidad, plantillas y BCL. |

Cada módulo tiene su propio archivo `index.yaml` que lista sus documentos hijos y dependencias.

---

## Estructura de Carpetas
/specs/
├── index/ # Punto de entrada
│ ├── master.yaml # Grafo maestro del proyecto
│ ├── ai-reading-profiles.yaml # Perfiles de lectura para agentes de IA
│ ├── behavioral-graph.yaml # Grafo de dependencias entre documentos
│ ├── environment-variables.md # Lista completa de variables de entorno
│ └── README.md # Este archivo
├── 000-Core/
│ ├── index.yaml
│ ├── philosophy.md
│ ├── principles.md
│ ├── vocabulary.md
│ └── ontology.md
├── 000-Infrastructure/
│ ├── index.yaml
│ └── selection.md
├── 100-Architecture/
│ ├── index.yaml
│ ├── system-architecture.md
│ ├── engines-overview.md
│ ├── behavioral-twin.md
│ └── data-model.md
├── 200-Backend/
│ ├── index.yaml
│ ├── api-graph.md
│ ├── database-graph.md
│ ├── events-and-workflows.md
│ └── transaction-engine.md
├── 300-Frontend/
│ ├── index.yaml
│ ├── design-system.md
│ ├── ui-graph.md
│ ├── accessibility.md
│ ├── patient-app.md
│ ├── therapist-app.md
│ ├── ahee-implementation.md
│ └── brand-studio.md
├── 400-AI/
│ ├── index.yaml
│ ├── ai-core.md
│ ├── companion.md
│ ├── adaptive-orchestrator.md
│ ├── guardrails.md
│ └── rag-knowledge-graph.md
├── 500-Experiencies/
│ ├── index.yaml
│ ├── experience-engine.md
│ ├── mechanics-library.md
│ ├── process-engine.md
│ └── clinical-processes.md
├── 600-Commerce/
│ ├── index.yaml
│ ├── business-model.md
│ └── website-builder.md
├── 700-PracticeOS/
│ ├── index.yaml
│ ├── practice-os.md
│ ├── automation-studio.md
│ └── relationship-engine.md
├── 800-Analytics/
│ ├── index.yaml
│ ├── outcomes-analytics.md
│ └── research-platform.md
├── 900-Security/
│ ├── index.yaml
│ └── security.md
├── 1000-Integration/
│ ├── index.yaml
│ └── bril-spec.md
├── 1100-Testing/
│ ├── index.yaml
│ └── bqas-spec.md
└── 1200-Deployment/
├── index.yaml
└── devops-spec.md


**Total de documentos:** 82 archivos (64 `.md` + 18 `.yaml`), medidos sobre `/specs/` (2026-08-07).

---

## Orden de Construcción

El orden de construcción está definido en el `master.yaml` y debe seguirse estrictamente para evitar dependencias faltantes:

1. `000-Core` – Fundamentos filosóficos y ontológicos.
2. `000-Infrastructure` – Selección de herramientas gratuitas.
3. `100-Architecture` – Arquitectura del sistema.
4. `900-Security` – Seguridad y gobernanza (base para todo).
5. `200-Backend` – Backend y servicios.
6. `400-AI` – Inteligencia artificial y motores cognitivos.
7. `500-Experiencies` – Gamificación y ejercicios terapéuticos.
8. `300-Frontend` – Frontend y experiencia de usuario.
9. `600-Commerce` – Motor comercial y facturación.
10. `700-PracticeOS` – Sistema operativo del consultorio clínico.
11. `800-Analytics` – Analítica e investigación.
12. `1000-Integration` – Integración y orquestación.
13. `1100-Testing` – Aseguramiento de calidad.
14. `1200-Deployment` – Infraestructura y operaciones.

> **Nota:** Cada módulo debe completarse antes de pasar al siguiente. La IA debe leer el `index.yaml` de cada módulo y todos sus archivos `.md` antes de escribir código.

---

## Tecnologías Principales

| Área | Tecnologías |
|------|-------------|
| **Backend** | FastAPI (Python 3.12+), Uvicorn, Pydantic |
| **Frontend** | React 19, TypeScript, Tailwind CSS, Framer Motion |
| **Mobile** | React Native + Expo |
| **Base de Datos** | Supabase (PostgreSQL + pgvector), Redis |
| **IA (on-device)** | Gemma (LLM), MediaPipe, Whisper (voz), ONNX Runtime |
| **Juegos** | Godot 4.3, jsPsych |
| **Eventos** | Redis Streams / NATS, BullMQ |
| **Workflows** | Temporal.io |
| **Orquestación** | Docker, Kubernetes (K8s) |
| **Monitoreo** | Prometheus, Grafana, Alertmanager |
| **Observabilidad** | OpenTelemetry, Jaeger, Loki |
| **CI/CD** | GitHub Actions, ArgoCD |
| **Pagos** | Stripe, Mercado Pago |
| **Facturación** | Facturapi (CFDI 4.0) |

---

## Restricciones Clave

1. **Todos los modelos de IA deben ejecutarse localmente (on-device)** usando MediaPipe y Gemma. No se permite el envío de datos de pacientes a la nube para inferencia de IA.

2. **Usa opciones gratuitas siempre que sea posible**. Consulta el archivo `/specs/000-Infrastructure/selection.md` para ver las alternativas gratuitas.

3. **Las únicas herramientas de pago son Stripe, Mercado Pago y Facturapi**, porque no existen alternativas gratuitas viables para procesamiento de pagos con tarjeta y facturación CFDI.

4. **El sistema debe ser multi-tenant desde el diseño**. Cada organización (clínica, terapeuta) debe tener su propio espacio aislado (tenant) con RLS en PostgreSQL.

5. **La seguridad y privacidad son prioritarias**. Consulta `/specs/900-Security/security.md` para las políticas de cifrado, consentimiento y auditoría.

6. **El código debe ser idiomático y seguir las mejores prácticas** de cada lenguaje y framework.

7. **Todos los componentes deben tener pruebas** (unitarias, de integración, clínicas, científicas, de seguridad, etc.) según lo definido en `/specs/1100-Testing/bqas-spec.md`.

---

## Variables de Entorno

La lista completa de variables de entorno necesarias se encuentra en:  
📄 [`/specs/index/environment-variables.md`](./environment-variables.md)

Crea un archivo `.env` (para desarrollo) basado en el `.env.example` incluido en ese documento.

### Variables críticas (obligatorias)

| Variable | Propósito |
|----------|-----------|
| `SUPABASE_URL` | URL de tu proyecto Supabase |
| `SUPABASE_SERVICE_ROLE_KEY` | Clave de rol de servicio de Supabase |
| `SECRET_KEY` | Clave secreta de la aplicación |
| `ENCRYPTION_KEY` | Clave para cifrar datos sensibles |
| `STRIPE_SECRET_KEY` | Clave secreta de Stripe (si usas Stripe) |
| `MERCADO_PAGO_ACCESS_TOKEN` | Token de Mercado Pago (si usas Mercado Pago) |
| `FACTURAPI_API_KEY` | Clave API de Facturapi (si usas CFDI) |

---

## Primeros Pasos

### 1. Clonar el repositorio (o crear la estructura)

```bash
git clone https://github.com/behavioralos/behavioralos.git
cd behavioralos

2. Crear las carpetas y archivos de especificación
Asegúrate de tener toda la estructura de /specs/ con todos los archivos generados.

3. Configurar variables de entorno

bash
cp .env.example .env
# Edita .env con tus valores

4. Instalar dependencias base (backend)

cd backend
python -m venv venv
source venv/bin/activate  # o `venv\Scripts\activate` en Windows
pip install -r requirements.txt

5. Instalar dependencias base (frontend)
cd frontend
npm install

6. Ejecutar el primer módulo (000-Core)
Sigue el orden de construcción y comienza con el módulo 000-Core.

Cómo Usar los SDD con IA
1. Lectura inicial
Pídele a la IA que lea primero el archivo index/master.yaml para entender la estructura completa del proyecto.

Prompt sugerido:

"Empieza leyendo el archivo /specs/index/master.yaml para entender la estructura completa del proyecto y el orden de construcción."

2. Perfiles de lectura
Si usas múltiples agentes de IA (uno para backend, otro para frontend, otro para IA, etc.), consulta el archivo ai-reading-profiles.yaml para asignar a cada agente los documentos relevantes.

3. Construcción paso a paso
Sigue el orden de construcción definido en el master.yaml:

Para cada módulo, pídele a la IA que lea su index.yaml y todos los archivos .md del módulo.

Luego, pídele que genere el código correspondiente (backend, frontend, pruebas, migraciones, etc.).

Avísale cuando termine cada módulo y pídele que pase al siguiente.

4. Preguntar si hay ambigüedades
Si la IA encuentra ambigüedades en las especificaciones, debe preguntar antes de continuar.

Prompt sugerido:

"Si encuentras ambigüedades en las especificaciones, pregúntame antes de continuar."

5. Generación de pruebas
Cada módulo debe incluir pruebas unitarias y de integración. La IA debe generarlas junto con el código.

Guía de Estilo y Calidad
Código
Lenguaje	Estilo
Python	PEP 8, black, isort, flake8
TypeScript/JavaScript	Prettier, ESLint (Airbnb), Husky
React	Componentes funcionales, hooks, prop-types (o TypeScript)
Commits
Conventional Commits (feat:, fix:, docs:, style:, refactor:, test:, chore:)

Mensajes en inglés o español (consistente)

Referencia al módulo (ej. feat(core): add ontology definitions)

Testing
Cobertura mínima: 90% (backend), 80% (frontend)

Pruebas clínicas: 100% de cobertura en lógica clínica

Pruebas de seguridad: 0 vulnerabilidades críticas o altas

Licencia
Este proyecto está bajo la licencia Propietaria (BehavioralOS). Todos los derechos reservados.

Contacto
Arquitectura: arquitectura@behavioralos.com

Soporte: support@behavioralos.com

Documentación: https://docs.behavioralos.com

Historial de Cambios
Versión	Fecha	Autor	Cambios
1.0.0	2026-07-02	Arquitectura Jefe	Creación del README inicial con la guía completa del proyecto.
Fin del documento README.md