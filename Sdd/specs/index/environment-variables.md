---
id: ENV-001
title: Variables de Entorno del BehavioralOS
version: 1.0.0
status: Stable
owner: DevOps & Arquitectura de Infraestructura
last_updated: 2026-07-02
---

# BehavioralOS – Variables de Entorno

> *"Las variables de entorno son el puente entre el código y la configuración del entorno. Nunca deben hardcodearse en el código fuente. Este documento lista todas las variables necesarias para desplegar y ejecutar el BehavioralOS en cualquier entorno."*

---

## 1. Propósito

Este documento lista todas las variables de entorno necesarias para el funcionamiento del BehavioralOS. Cada variable está categorizada por su uso y acompañada de una descripción, ejemplo y nivel de seguridad (pública, sensible o secreta).

---

## 2. Categorías de Variables

| Categoría | Descripción |
|-----------|-------------|
| **Backend** | Variables para el servidor FastAPI y la aplicación backend. |
| **Base de Datos** | Variables para la conexión a Supabase / PostgreSQL. |
| **Autenticación y Seguridad** | Variables para JWT, cifrado y seguridad. |
| **IA y Modelos** | Variables para la configuración de Gemma, MediaPipe y otros modelos. |
| **Integraciones (Pagos)** | Claves para Stripe, Mercado Pago, Facturapi. |
| **Integraciones (Comunicación)** | Claves para correo, SMS, WhatsApp, videollamadas. |
| **Integraciones (Calendario)** | Claves para Google Calendar, Outlook. |
| **Frontend** | Variables para la aplicación React. |
| **DevOps** | Variables para despliegue, monitoreo y secretos. |

---

## 3. Variables de Entorno

### 3.1. Backend (FastAPI)

| Variable | Descripción | Ejemplo | Seguridad |
|----------|-------------|---------|-----------|
| `APP_ENV` | Entorno de ejecución (`development`, `staging`, `production`). | `production` | Pública |
| `APP_NAME` | Nombre de la aplicación. | `BehavioralOS` | Pública |
| `APP_VERSION` | Versión de la aplicación. | `1.0.0` | Pública |
| `APP_HOST` | Host donde corre el servidor. | `0.0.0.0` | Pública |
| `APP_PORT` | Puerto del servidor. | `8000` | Pública |
| `APP_DEBUG` | Modo debug (`true`/`false`). | `false` | Pública |
| `SECRET_KEY` | Clave secreta para sesiones y seguridad general. | `cambiar_esta_clave_en_produccion` | **Secreta** |
| `API_PREFIX` | Prefijo de las rutas de la API. | `/api/v1` | Pública |
| `CORS_ORIGINS` | Orígenes permitidos para CORS (separados por coma). | `https://patient.behavioralos.com,https://therapist.behavioralos.com` | Pública |

---

### 3.2. Base de Datos (Supabase / PostgreSQL)

| Variable | Descripción | Ejemplo | Seguridad |
|----------|-------------|---------|-----------|
| `SUPABASE_URL` | URL de la API de Supabase. | `https://your-project.supabase.co` | **Sensible** |
| `SUPABASE_ANON_KEY` | Clave anónima de Supabase (para cliente). | `eyJhbGciOiJIUzI1NiIs...` | **Sensible** |
| `SUPABASE_SERVICE_ROLE_KEY` | Clave de rol de servicio (para backend). | `eyJhbGciOiJIUzI1NiIs...` | **Secreta** |
| `SUPABASE_JWT_SECRET` | Clave JWT de Supabase (para verificar tokens). | `cambiar_esta_clave_en_produccion` | **Secreta** |
| `DATABASE_URL` | URL de conexión a la base de datos (PostgreSQL). | `postgresql://user:pass@host:5432/db` | **Secreta** |
| `DATABASE_POOL_SIZE` | Tamaño del pool de conexiones. | `10` | Pública |
| `DATABASE_MAX_OVERFLOW` | Máximo de conexiones adicionales en el pool. | `20` | Pública |

---

### 3.3. Autenticación y Seguridad

| Variable | Descripción | Ejemplo | Seguridad |
|----------|-------------|---------|-----------|
| `JWT_ACCESS_TOKEN_EXPIRE_MINUTES` | Tiempo de expiración del access token (minutos). | `60` | Pública |
| `JWT_REFRESH_TOKEN_EXPIRE_DAYS` | Tiempo de expiración del refresh token (días). | `30` | Pública |
| `JWT_ALGORITHM` | Algoritmo de firma de JWT. | `HS256` | Pública |
| `ENCRYPTION_KEY` | Clave para cifrar datos sensibles (AES-256). | `cambiar_esta_clave_en_produccion` | **Secreta** |
| `PASSWORD_HASH_ALGORITHM` | Algoritmo de hash de contraseñas. | `bcrypt` | Pública |
| `PASSWORD_SALT_ROUNDS` | Número de rondas de sal para bcrypt. | `12` | Pública |
| `TWO_FACTOR_AUTH_REQUIRED` | Si 2FA es obligatorio para terapeutas (`true`/`false`). | `true` | Pública |

---

### 3.4. IA y Modelos (Gemma, MediaPipe)

| Variable | Descripción | Ejemplo | Seguridad |
|----------|-------------|---------|-----------|
| `GEMMA_MODEL_PATH` | Ruta local del modelo Gemma (GGUF). | `/models/gemma-2b-q4.gguf` | Pública |
| `GEMMA_CONTEXT_SIZE` | Tamaño del contexto de Gemma (tokens). | `4096` | Pública |
| `GEMMA_TEMPERATURE` | Temperatura para generación de Gemma. | `0.7` | Pública |
| `GEMMA_TOP_K` | Top-K para muestreo de Gemma. | `40` | Pública |
| `GEMMA_TOP_P` | Top-P para muestreo de Gemma. | `0.9` | Pública |
| `GEMMA_MAX_TOKENS` | Máximo de tokens a generar. | `512` | Pública |
| `WHISPER_MODEL_PATH` | Ruta local del modelo Whisper (ONNX). | `/models/whisper-tiny.onnx` | Pública |
| `WHISPER_LANGUAGE` | Idioma por defecto para Whisper. | `es` | Pública |
| `MEDIAPIPE_FACE_MESH_ENABLED` | Habilitar Face Mesh (requiere consentimiento). | `true` | Pública |
| `EMBEDDING_MODEL_PATH` | Ruta del modelo de embeddings (sentence-transformers). | `/models/multilingual-e5-small.onnx` | Pública |

---

### 3.5. Integraciones (Pagos)

#### 3.5.1. Stripe

| Variable | Descripción | Ejemplo | Seguridad |
|----------|-------------|---------|-----------|
| `STRIPE_SECRET_KEY` | Clave secreta de Stripe (backend). | `sk_live_...` | **Secreta** |
| `STRIPE_PUBLISHABLE_KEY` | Clave pública de Stripe (frontend). | `pk_live_...` | **Sensible** |
| `STRIPE_WEBHOOK_SECRET` | Secreto para verificar webhooks de Stripe. | `whsec_...` | **Secreta** |
| `STRIPE_CURRENCY` | Moneda por defecto. | `mxn` | Pública |

#### 3.5.2. Mercado Pago

| Variable | Descripción | Ejemplo | Seguridad |
|----------|-------------|---------|-----------|
| `MERCADO_PAGO_ACCESS_TOKEN` | Token de acceso de Mercado Pago. | `APP_USR-...` | **Secreta** |
| `MERCADO_PAGO_PUBLIC_KEY` | Clave pública de Mercado Pago (frontend). | `APP_USR-...` | **Sensible** |
| `MERCADO_PAGO_WEBHOOK_SECRET` | Secreto para verificar webhooks de Mercado Pago. | `...` | **Secreta** |

#### 3.5.3. Facturapi (CFDI)

| Variable | Descripción | Ejemplo | Seguridad |
|----------|-------------|---------|-----------|
| `FACTURAPI_API_KEY` | Clave API de Facturapi. | `...` | **Secreta** |
| `FACTURAPI_TAX_SYSTEM` | Régimen fiscal por defecto. | `612` | Pública |
| `FACTURAPI_USE_CFDI` | Uso de CFDI por defecto. | `G03` | Pública |

---

### 3.6. Integraciones (Comunicación)

#### 3.6.1. Correo Electrónico

| Variable | Descripción | Ejemplo | Seguridad |
|----------|-------------|---------|-----------|
| `SMTP_HOST` | Servidor SMTP para envío de correos. | `smtp.gmail.com` | Pública |
| `SMTP_PORT` | Puerto SMTP. | `587` | Pública |
| `SMTP_USER` | Usuario SMTP. | `no-reply@behavioralos.com` | **Sensible** |
| `SMTP_PASSWORD` | Contraseña SMTP. | `...` | **Secreta** |
| `SMTP_FROM_EMAIL` | Correo del remitente. | `no-reply@behavioralos.com` | Pública |
| `SMTP_FROM_NAME` | Nombre del remitente. | `BehavioralOS` | Pública |

**Alternativas (SendGrid, Resend)**:

| Variable | Descripción | Ejemplo | Seguridad |
|----------|-------------|---------|-----------|
| `SENDGRID_API_KEY` | Clave API de SendGrid. | `SG.xxx` | **Secreta** |
| `RESEND_API_KEY` | Clave API de Resend. | `re_xxx` | **Secreta** |

#### 3.6.2. SMS (Twilio)

| Variable | Descripción | Ejemplo | Seguridad |
|----------|-------------|---------|-----------|
| `TWILIO_ACCOUNT_SID` | SID de cuenta de Twilio. | `AC...` | **Secreta** |
| `TWILIO_AUTH_TOKEN` | Token de autenticación de Twilio. | `...` | **Secreta** |
| `TWILIO_PHONE_NUMBER` | Número de teléfono de Twilio. | `+1234567890` | Pública |

#### 3.6.3. WhatsApp Business API

| Variable | Descripción | Ejemplo | Seguridad |
|----------|-------------|---------|-----------|
| `WHATSAPP_API_KEY` | Clave API de WhatsApp Business. | `...` | **Secreta** |
| `WHATSAPP_PHONE_NUMBER_ID` | ID del número de teléfono. | `1234567890` | **Sensible** |

---

### 3.7. Integraciones (Calendario)

#### 3.7.1. Google Calendar / Google Meet

| Variable | Descripción | Ejemplo | Seguridad |
|----------|-------------|---------|-----------|
| `GOOGLE_OAUTH_CLIENT_ID` | Client ID de OAuth de Google. | `...apps.googleusercontent.com` | **Sensible** |
| `GOOGLE_OAUTH_CLIENT_SECRET` | Client Secret de OAuth de Google. | `...` | **Secreta** |
| `GOOGLE_CALENDAR_ID` | ID del calendario por defecto. | `primary` | Pública |

#### 3.7.2. Outlook / Microsoft

| Variable | Descripción | Ejemplo | Seguridad |
|----------|-------------|---------|-----------|
| `MICROSOFT_OAUTH_CLIENT_ID` | Client ID de OAuth de Microsoft. | `...` | **Sensible** |
| `MICROSOFT_OAUTH_CLIENT_SECRET` | Client Secret de OAuth de Microsoft. | `...` | **Secreta** |

---

### 3.8. Frontend (React)

| Variable | Descripción | Ejemplo | Seguridad |
|----------|-------------|---------|-----------|
| `REACT_APP_API_URL` | URL de la API backend. | `https://api.behavioralos.com/api/v1` | Pública |
| `REACT_APP_WS_URL` | URL de WebSockets. | `wss://api.behavioralos.com/ws` | Pública |
| `REACT_APP_SUPABASE_URL` | URL de Supabase (para cliente). | `https://your-project.supabase.co` | **Sensible** |
| `REACT_APP_SUPABASE_ANON_KEY` | Clave anónima de Supabase (para cliente). | `eyJhbGciOiJIUzI1NiIs...` | **Sensible** |
| `REACT_APP_STRIPE_PUBLISHABLE_KEY` | Clave pública de Stripe. | `pk_live_...` | **Sensible** |
| `REACT_APP_MERCADO_PAGO_PUBLIC_KEY` | Clave pública de Mercado Pago. | `APP_USR-...` | **Sensible** |
| `REACT_APP_GOOGLE_OAUTH_CLIENT_ID` | Client ID de Google OAuth. | `...apps.googleusercontent.com` | **Sensible** |
| `REACT_APP_ENVIRONMENT` | Entorno de frontend (`development`, `production`). | `production` | Pública |

---

### 3.9. Infraestructura y DevOps

| Variable | Descripción | Ejemplo | Seguridad |
|----------|-------------|---------|-----------|
| `REDIS_URL` | URL de conexión a Redis. | `redis://localhost:6379/0` | **Sensible** |
| `REDIS_PASSWORD` | Contraseña de Redis (si aplica). | `...` | **Secreta** |
| `REDIS_SSL` | Habilitar SSL para Redis (`true`/`false`). | `false` | Pública |
| `SENTRY_DSN` | DSN de Sentry para monitoreo de errores. | `https://...@sentry.io/...` | **Sensible** |
| `PROMETHEUS_ENABLED` | Habilitar endpoint `/metrics` para Prometheus. | `true` | Pública |
| `JAEGER_ENABLED` | Habilitar trazas con Jaeger. | `true` | Pública |
| `JAEGER_AGENT_HOST` | Host del agente de Jaeger. | `localhost` | Pública |
| `JAEGER_AGENT_PORT` | Puerto del agente de Jaeger. | `6831` | Pública |
| `LOG_LEVEL` | Nivel de logs (`debug`, `info`, `warning`, `error`). | `info` | Pública |

---

### 3.10. Secretos para Kubernetes (si aplica)

| Variable | Descripción | Ejemplo | Seguridad |
|----------|-------------|---------|-----------|
| `KUBERNETES_NAMESPACE` | Namespace de Kubernetes. | `production` | Pública |
| `KUBERNETES_SECRET_NAME` | Nombre del secreto en Kubernetes. | `behavioralos-secrets` | Pública |

---

## 4. Archivos de Ejemplo

### 4.1. `.env.example` (Backend)

```env
# Backend
APP_ENV=development
APP_NAME=BehavioralOS
APP_VERSION=1.0.0
APP_HOST=0.0.0.0
APP_PORT=8000
APP_DEBUG=true
SECRET_KEY=tu_clave_secreta_en_desarrollo
API_PREFIX=/api/v1
CORS_ORIGINS=http://localhost:3000,http://localhost:5173

# Base de Datos
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=tu_anon_key
SUPABASE_SERVICE_ROLE_KEY=tu_service_role_key
SUPABASE_JWT_SECRET=tu_jwt_secret
DATABASE_URL=postgresql://user:pass@localhost:5432/behavioralos
DATABASE_POOL_SIZE=10
DATABASE_MAX_OVERFLOW=20

# Autenticación
JWT_ACCESS_TOKEN_EXPIRE_MINUTES=60
JWT_REFRESH_TOKEN_EXPIRE_DAYS=30
JWT_ALGORITHM=HS256
ENCRYPTION_KEY=tu_clave_de_cifrado
PASSWORD_HASH_ALGORITHM=bcrypt
PASSWORD_SALT_ROUNDS=12
TWO_FACTOR_AUTH_REQUIRED=true

# IA
GEMMA_MODEL_PATH=/models/gemma-2b-q4.gguf
GEMMA_CONTEXT_SIZE=4096
GEMMA_TEMPERATURE=0.7
GEMMA_TOP_K=40
GEMMA_TOP_P=0.9
GEMMA_MAX_TOKENS=512
WHISPER_MODEL_PATH=/models/whisper-tiny.onnx
WHISPER_LANGUAGE=es
MEDIAPIPE_FACE_MESH_ENABLED=true
EMBEDDING_MODEL_PATH=/models/multilingual-e5-small.onnx

# Stripe
STRIPE_SECRET_KEY=sk_test_...
STRIPE_PUBLISHABLE_KEY=pk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...
STRIPE_CURRENCY=mxn

# Mercado Pago
MERCADO_PAGO_ACCESS_TOKEN=APP_USR-...
MERCADO_PAGO_PUBLIC_KEY=APP_USR-...
MERCADO_PAGO_WEBHOOK_SECRET=...

# Facturapi
FACTURAPI_API_KEY=...
FACTURAPI_TAX_SYSTEM=612
FACTURAPI_USE_CFDI=G03

# Correo
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=no-reply@behavioralos.com
SMTP_PASSWORD=tu_contraseña
SMTP_FROM_EMAIL=no-reply@behavioralos.com
SMTP_FROM_NAME=BehavioralOS

# Twilio
TWILIO_ACCOUNT_SID=AC...
TWILIO_AUTH_TOKEN=...
TWILIO_PHONE_NUMBER=+1234567890

# WhatsApp
WHATSAPP_API_KEY=...
WHATSAPP_PHONE_NUMBER_ID=1234567890

# Google
GOOGLE_OAUTH_CLIENT_ID=...apps.googleusercontent.com
GOOGLE_OAUTH_CLIENT_SECRET=...
GOOGLE_CALENDAR_ID=primary

# Microsoft
MICROSOFT_OAUTH_CLIENT_ID=...
MICROSOFT_OAUTH_CLIENT_SECRET=...

# Redis
REDIS_URL=redis://localhost:6379/0
REDIS_PASSWORD=
REDIS_SSL=false

# Observabilidad
SENTRY_DSN=https://...@sentry.io/...
PROMETHEUS_ENABLED=true
JAEGER_ENABLED=true
JAEGER_AGENT_HOST=localhost
JAEGER_AGENT_PORT=6831
LOG_LEVEL=info

4.2. .env.example (Frontend - React)
env

REACT_APP_API_URL=http://localhost:8000/api/v1
REACT_APP_WS_URL=ws://localhost:8000/ws
REACT_APP_SUPABASE_URL=https://your-project.supabase.co
REACT_APP_SUPABASE_ANON_KEY=tu_anon_key
REACT_APP_STRIPE_PUBLISHABLE_KEY=pk_test_...
REACT_APP_MERCADO_PAGO_PUBLIC_KEY=APP_USR-...
REACT_APP_GOOGLE_OAUTH_CLIENT_ID=...apps.googleusercontent.com
REACT_APP_ENVIRONMENT=development

5. Políticas de Seguridad de las Variables
Nivel de Seguridad	Descripción	Almacenamiento
Pública	Puede estar en el código o en configuraciones públicas.	Archivos de configuración, variables de entorno.
Sensible	No debe estar en el código; solo en variables de entorno o secretos.	Variables de entorno, Kubernetes Secrets.
Secreta	Debe estar cifrada y almacenada en un gestor de secretos.	Supabase Vault, AWS KMS, HashiCorp Vault.
6. Gestión de Secretos en Producción
Herramienta	Propósito
Supabase Vault	Almacenamiento de secretos en la nube de Supabase.
AWS KMS / Secrets Manager	Para despliegues en AWS.
Kubernetes Secrets	Para inyección de secretos en pods.
External Secrets Operator (ESO)	Sincronización de secretos desde Vault a Kubernetes.
7. Historial de Cambios
Versión	Fecha	Autor	Cambios
1.0.0	2026-07-02	DevOps	Creación del documento. Lista completa de variables de entorno para el BehavioralOS.
Fin del documento environment-variables.md