---
id: DEVOPS-001
title: "DevOps: Despliegue, Monitoreo y Operaciones"
version: 1.0.0
status: Stable
owner: DevOps & Arquitectura de Infraestructura
last_updated: 2026-07-01
depends_on:
  - 000-Core/philosophy.md (Filosofía - disponibilidad, resiliencia)
  - 100-Architecture/system-architecture.md (BEA - componentes)
  - 200-Backend/api-graph.md (API Graph - endpoints)
  - 400-AI/ai-core.md (AI Core - modelos locales)
  - 1100-Testing/bqas-spec.md (BQAS - pruebas en CI/CD)
  - 000-Infrastructure/selection.md (Infraestructura - opciones gratuitas)
exports:
  - Arquitectura de DevOps (componentes, flujos)
  - Estrategia de CI/CD (GitHub Actions, ArgoCD)
  - Arquitectura de contenedores (Docker, Kubernetes)
  - Monitoreo y alertas (Prometheus, Grafana, Alertmanager)
  - Observabilidad (OpenTelemetry, Jaeger, Loki)
  - Respaldo y recuperación (backups, failover, disaster recovery)
  - Gestión de secretos (Supabase Vault, AWS KMS)
  - Políticas de escalado y health checks
  - Estrategias de despliegue (canary, blue-green, rollback)
  - Integración con el ecosistema
  - Criterios de validación y métricas de éxito
used_by:
  - Todos los módulos (despliegue y operación)
  - CI/CD (ejecución de pipelines)
  - Admin Dashboard (monitoreo)
  - DevOps (operaciones diarias)
---

# BehavioralOS – DevOps: Despliegue, Monitoreo y Operaciones

> *"Una plataforma clínica como el BehavioralOS debe estar disponible 24/7, ser escalable para soportar el crecimiento, y ser recuperable ante fallos. La infraestructura no es un mal necesario; es la base que permite que la ciencia del comportamiento llegue a más personas. Un sistema bien operado es invisible; un sistema mal operado es una crisis constante."*

---

## 1. Propósito y Alcance

### 1.1. Propósito
Este documento define la **estrategia de despliegue, monitoreo, observabilidad, respaldo y recuperación** del BehavioralOS. Su objetivo es:

- **Automatizar el despliegue** del sistema en entornos de desarrollo, pruebas y producción mediante CI/CD.
- **Orquestar contenedores** con Docker y Kubernetes para garantizar escalabilidad y portabilidad.
- **Monitorear la salud del sistema** con Prometheus, Grafana y Alertmanager, detectando fallos antes de que afecten a los usuarios.
- **Proveer observabilidad** con OpenTelemetry, Jaeger y Loki para rastrear y depurar problemas.
- **Garantizar la recuperación** ante desastres con backups automáticos, failover y planes de disaster recovery.
- **Gestionar secretos** de forma segura con Supabase Vault y AWS KMS.
- **Implementar políticas de escalado** automático para manejar picos de carga.
- **Aplicar estrategias de despliegue** seguras (canary, blue-green, rollback automático).

### 1.2. Alcance
El documento cubre:

- **CI/CD**: GitHub Actions, ArgoCD, pipelines de integración y despliegue continuo.
- **Contenedores**: Docker para empaquetado, Kubernetes para orquestación.
- **Monitoreo**: Prometheus (métricas), Grafana (dashboards), Alertmanager (alertas).
- **Observabilidad**: OpenTelemetry (trazas distribuidas), Jaeger (visualización), Loki (logs centralizados).
- **Respaldo y recuperación**: Backups automáticos, failover entre zonas, disaster recovery plan.
- **Gestión de secretos**: Supabase Vault, AWS KMS, inyección de secretos en pods.
- **Políticas de escalado**: HPA (Horizontal Pod Autoscaler), VPA (Vertical Pod Autoscaler).
- **Health checks**: Endpoints `/health` y `/ready` para cada servicio.
- **Estrategias de despliegue**: Canary, blue-green, rollback automático.
- **Integración con el ecosistema**: Cómo DevOps se integra con todos los módulos.
- **Criterios de validación**: Métricas de disponibilidad, rendimiento, recuperación y escalabilidad.

### 1.3. Principio Fundamental
> **"La infraestructura no es un mal necesario; es la base que permite que la ciencia del comportamiento llegue a más personas. Un sistema bien operado es invisible; un sistema mal operado es una crisis constante. Nuestra responsabilidad es garantizar que el BehavioralOS esté siempre disponible, siempre seguro y siempre escalable."**

---

## 2. Filosofía de DevOps

### 2.1. Principios de Operaciones

| # | Principio | Descripción | Manifestación |
|---|-----------|-------------|---------------|
| 1 | **Automatización** | Todo proceso repetible debe estar automatizado. | CI/CD, escalado automático, backups automáticos. |
| 2 | **Disponibilidad** | El sistema debe estar disponible 24/7 con un uptime ≥ 99.9%. | Replicación, failover, health checks. |
| 3 | **Escalabilidad** | El sistema debe escalar horizontalmente para soportar el crecimiento. | Kubernetes HPA, servicios stateless. |
| 4 | **Resiliencia** | El sistema debe recuperarse automáticamente de fallos. | Reintentos, circuit breakers, rollback automático. |
| 5 | **Observabilidad** | El sistema debe ser fácil de monitorear y depurar. | Métricas, logs, trazas distribuidas. |
| 6 | **Seguridad** | La infraestructura debe ser segura por diseño. | TLS 1.3, gestión de secretos, escaneo de vulnerabilidades. |
| 7 | **Recuperación** | El sistema debe poder recuperarse ante desastres. | Backups, failover, disaster recovery plan. |

### 2.2. Arquitectura de Referencia

┌─────────────────────────────────────────────────────────────────────────┐
│ Entornos de Despliegue │
├─────────────────────────────────────────────────────────────────────────┤
│ │
│ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ │
│ │ Development │ │ Staging │ │ Production │ │
│ │ (Dev) │ │ (QA) │ │ (Prod) │ │
│ └─────────────┘ └─────────────┘ └─────────────┘ │
│ │ │ │ │
│ └──────────────────┼──────────────────┘ │
│ │ │
│ ┌───────▼───────┐ │
│ │ Kubernetes │ │
│ │ Cluster │ │
│ └───────────────┘ │
│ │ │
│ ┌──────────────────┼──────────────────┐ │
│ │ │ │ │
│ ┌──────▼──────┐ ┌──────▼──────┐ ┌──────▼──────┐ │
│ │ Backend │ │ Frontend │ │ AI Models │ │
│ │ Services │ │ (React) │ │ (Gemma, │ │
│ │ (FastAPI) │ │ │ │ Whisper) │ │
│ └─────────────┘ └─────────────┘ └─────────────┘ │
│ │ │
│ ┌───────▼───────┐ │
│ │ Supabase │ │
│ │ (PostgreSQL, │ │
│ │ Auth, │ │
│ │ Storage) │ │
│ └───────────────┘ │
│ │ │
│ ┌───────▼───────┐ │
│ │ Redis │ │
│ │ (Cache, │ │
│ │ Event Bus) │ │
│ └───────────────┘ │
│ │
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ Observability Stack │ │
│ │ • Prometheus (métricas) • Grafana (dashboards) │ │
│ │ • Alertmanager (alertas) • Jaeger (trazas) │ │
│ │ • Loki (logs) • OpenTelemetry (instrumentación) │ │
│ └─────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────┘


---

## 3. CI/CD

### 3.1. Tecnologías

| Componente | Tecnología | Propósito | Notas (Gratuito) |
|------------|------------|-----------|------------------|
| **CI/CD** | GitHub Actions | Automatización de pruebas y despliegues. | 2000 min/mes (gratis) |
| **GitOps** | ArgoCD | Sincronización de despliegues con el repositorio Git. | Open source |
| **Contenedores** | Docker | Empaquetado de aplicaciones. | Open source |
| **Orquestación** | Kubernetes | Gestión de contenedores en producción. | Open source (minikube, k3s, GKE, EKS) |

### 3.2. Pipeline de CI/CD

┌─────────────────────────────────────────────────────────────────────────┐
│ Pipeline de CI/CD │
├─────────────────────────────────────────────────────────────────────────┤
│ │
│ [Push/PR] → [Lint] → [Unit Tests] → [Integration Tests] → [Security] │
│ ↓ ↓ ↓ ↓ │
│ [Build] → [Deploy to Dev] → [E2E Tests] → [Deploy to Staging] │
│ ↓ ↓ ↓ ↓ │
│ [Performance Tests] → [Quality Gates] → [Approval] → [Deploy Prod] │
│ │
│ • En Desarrollo: despliegue automático después de cada PR fusionado. │
│ • En Staging: despliegue después de aprobación manual (QA). │
│ • En Producción: despliegue canary con monitoreo. │
└─────────────────────────────────────────────────────────────────────────┘


### 3.3. GitHub Actions (Ejemplo)

```yaml
# .github/workflows/ci-cd.yml
name: BehavioralOS CI/CD

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.12'
      - name: Install dependencies
        run: |
          pip install -r requirements.txt
          pip install pytest pytest-cov bandit semgrep
      - name: Run unit tests
        run: pytest --cov=src/ --cov-report=xml
      - name: Run security scan
        run: bandit -r src/ -f json -o bandit_report.json
      - name: Upload coverage report
        uses: codecov/codecov-action@v4
        with:
          file: ./coverage.xml

  deploy-staging:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - name: Build Docker image
        run: docker build -t behavioralos-api:${{ github.sha }} .
      - name: Push to registry
        run: |
          echo ${{ secrets.DOCKER_PASSWORD }} | docker login -u ${{ secrets.DOCKER_USERNAME }} --password-stdin
          docker tag behavioralos-api:${{ github.sha }} behavioralos/behavioralos-api:latest
          docker push behavioralos/behavioralos-api:latest
      - name: Deploy to Staging (ArgoCD)
        run: |
          kubectl set image deployment/behavioralos-api behavioralos-api=behavioralos/behavioralos-api:${{ github.sha }} -n staging

3.4. GitOps con ArgoCD
ArgoCD sincroniza automáticamente el estado del clúster Kubernetes con el repositorio Git.

Estrategia: Cada cambio en el repositorio (rama main) se sincroniza automáticamente en el entorno de staging y producción (con aprobación).

Rollback: Un simple git revert restaura la versión anterior.

4. Contenedores y Orquestación
4.1. Docker (Contenedores)
Imagen base: Python 3.12-slim para backend, Node 20-alpine para frontend.

Multi-stage builds: Para reducir el tamaño de la imagen final.

Health checks: Definidos en el Dockerfile para que Kubernetes pueda monitorear la salud.

Ejemplo de Dockerfile (Backend):

dockerfile

# Dockerfile
FROM python:3.12-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

FROM python:3.12-slim
WORKDIR /app
COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY . .
EXPOSE 8000
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD python -c "import requests; requests.get('http://localhost:8000/health')" || exit 1
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]

4.2. Kubernetes (Orquestación)
4.2.1. Recursos Principales
Recurso	Descripción
Deployment	Despliegue de cada servicio (backend, frontend, etc.).
Service	Exposición de servicios internos (ClusterIP) y externos (LoadBalancer).
Ingress	Enrutamiento de tráfico externo a los servicios (con TLS).
ConfigMap	Configuración no sensible (variables de entorno).
Secret	Configuración sensible (contraseñas, claves API).
HorizontalPodAutoscaler	Escalado automático basado en CPU/memoria o métricas personalizadas.
PersistentVolumeClaim	Almacenamiento persistente (para bases de datos, archivos).

4.2.2. Ejemplo de Deployment (Backend)

# kubernetes/backend-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: behavioralos-api
  namespace: production
spec:
  replicas: 3
  selector:
    matchLabels:
      app: behavioralos-api
  template:
    metadata:
      labels:
        app: behavioralos-api
    spec:
      containers:
      - name: api
        image: behavioralos/behavioralos-api:latest
        ports:
        - containerPort: 8000
        envFrom:
        - configMapRef:
            name: behavioralos-config
        - secretRef:
            name: behavioralos-secrets
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /health
            port: 8000
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /ready
            port: 8000
          initialDelaySeconds: 10
          periodSeconds: 5

4.2.3. Ejemplo de Ingress (TLS)

# kubernetes/ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: behavioralos-ingress
  namespace: production
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
spec:
  tls:
  - hosts:
    - api.behavioralos.com
    - patient.behavioralos.com
    - therapist.behavioralos.com
    secretName: behavioralos-tls
  rules:
  - host: api.behavioralos.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: behavioralos-api
            port:
              number: 80
  - host: patient.behavioralos.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: behavioralos-frontend-patient
            port:
              number: 80

4.2.4. HorizontalPodAutoscaler (Escalado Automático)

# kubernetes/hpa.yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: behavioralos-api-hpa
  namespace: production
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: behavioralos-api
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80

5. Monitoreo y Alertas
5.1. Tecnologías
Componente	Tecnología	Propósito	Notas (Gratuito)
Métricas	Prometheus	Recopilación de métricas de servicios.	Open source
Dashboards	Grafana	Visualización de métricas en paneles.	Open source
Alertas	Alertmanager	Envío de alertas basadas en reglas de Prometheus.	Open source
5.2. Métricas Clave
Métrica	Descripción	Uso
Latencia de API	Tiempo de respuesta de los endpoints (p50, p95, p99).	Detectar degradación de rendimiento.
Tasa de errores	Porcentaje de peticiones con error (5xx, 4xx).	Detectar fallos en el sistema.
Uso de CPU	Uso de CPU por pod.	Escalado automático.
Uso de memoria	Uso de memoria por pod.	Escalado automático.
Tamaño de colas	Tamaño de colas de trabajo (BullMQ).	Detectar acumulación de tareas.
Latencia de Event Bus	Tiempo de entrega de eventos.	Detectar cuellos de botella en BRIL.
Disponibilidad	Uptime de cada servicio.	Monitoreo de disponibilidad.
Errores de IA	Tasa de fallos de guardrails y alucinaciones.	Monitoreo de calidad de IA.

5.3. Ejemplo de Regla de Alerta (Prometheus)

# prometheus/alerts.yml
groups:
- name: behavioralos_alerts
  rules:
  - alert: HighAPIErrorRate
    expr: rate(http_requests_total{status=~"5.."}[5m]) / rate(http_requests_total[5m]) > 0.05
    for: 5m
    labels:
      severity: critical
    annotations:
      summary: "Alta tasa de errores en API"
      description: "La tasa de errores es del {{ $value }}% en los últimos 5 minutos."

  - alert: HighLatency
    expr: histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) > 0.5
    for: 5m
    labels:
      severity: warning
    annotations:
      summary: "Alta latencia en API"
      description: "El p95 de latencia es de {{ $value }} segundos."

  - alert: LowAvailability
    expr: up{job="behavioralos-api"} == 0
    for: 1m
    labels:
      severity: critical
    annotations:
      summary: "Servicio caído"
      description: "El servicio behavioralos-api no está disponible."

5.4. Dashboards de Grafana
Dashboard de Sistema: Estado general de todos los servicios, recursos y alertas.

Dashboard de API: Latencia, tasa de errores, throughput por endpoint.

Dashboard de Base de Datos: Conexiones activas, queries lentas, uso de almacenamiento.

Dashboard de IA: Tasa de éxito de guardrails, distribución de respuestas, latencia de inferencia.

Dashboard de BRIL: Tamaño de colas, latencia de eventos, tasa de entrega.

6. Observabilidad
6.1. Tecnologías
Componente	Tecnología	Propósito	Notas (Gratuito)
Instrumentación	OpenTelemetry	Generación de trazas y métricas desde el código.	Open source
Trazas	Jaeger	Visualización de trazas distribuidas.	Open source
Logs	Loki	Centralización de logs de todos los servicios.	Open source
6.2. Trazas Distribuidas (OpenTelemetry + Jaeger)
Instrumentación: Se añaden spans en el código para rastrear peticiones a través de los servicios.

Correlación: correlation_id se pasa entre servicios y se incluye en las trazas.

Visualización: Jaeger permite ver el recorrido completo de una petición.

Ejemplo de instrumentación en Python (FastAPI):

from opentelemetry import trace
from opentelemetry.instrumentation.fastapi import FastAPIInstrumentor

tracer = trace.get_tracer(__name__)

@app.get("/api/v1/patients/{id}")
async def get_patient(id: str):
    with tracer.start_as_current_span("get_patient"):
        # Llamada a la base de datos
        patient = await db.get_patient(id)
        # Llamada a otro servicio
        twin = await twin_service.get_twin(id)
        return {"patient": patient, "twin": twin}

6.3. Logs Centralizados (Loki)
Recolección: Promtail recolecta logs de todos los pods y los envía a Loki.

Consulta: Los logs se consultan en Grafana con el lenguaje LogQL.

Retención: 30 días de logs (configurable).

Ejemplo de consulta LogQL:

{app="behavioralos-api", level="error"} |= "timeout" | json

7. Respaldo y Recuperación
7.1. Backups Automáticos
Componente	Frecuencia	Retención	Ubicación
PostgreSQL (Supabase)	Diario (full) + WAL archiving (continuo)	30 días (diarios), 12 meses (mensuales)	Supabase (cifrado)
Archivos (Supabase Storage)	Diario (incremental)	30 días	Supabase Storage (cifrado)
Redis	Diario (RDB)	7 días	Redis (cifrado)
Kubernetes manifests	Continuo (Git)	Indefinido	GitHub
7.2. Failover y Alta Disponibilidad
Multi-zona: Kubernetes se despliega en al menos 2 zonas de disponibilidad.

Replicación de base de datos: PostgreSQL con replicación síncrona (para datos críticos) y asíncrona (para lecturas).

Failover automático: Si un nodo o zona falla, Kubernetes reubica los pods automáticamente.

7.3. Disaster Recovery (DR)
RPO (Recovery Point Objective): < 1 hora (pérdida máxima de datos).

RTO (Recovery Time Objective): < 4 horas (tiempo máximo de recuperación).

Plan de DR:

Restaurar PostgreSQL desde el último backup completo + WAL.
Restaurar archivos desde Supabase Storage.
Recrear los pods de Kubernetes desde los manifests de Git (ArgoCD).
Verificar la integridad de los datos y la funcionalidad del sistema.
8. Gestión de Secretos
8.1. Tecnologías
Componente	Tecnología	Propósito	Notas (Gratuito)
Gestión de secretos	Supabase Vault	Almacenamiento de secretos (claves API, contraseñas).	Supabase (incluido)
Inyección en pods	Kubernetes Secrets	Inyección de secretos en contenedores.	Kubernetes (incluido)
External Secrets Operator	ESO	Sincronización de secretos desde Vault a Kubernetes.	Open source
8.2. Tipos de Secretos
Secreto	Descripción	Almacenamiento
Stripe Secret Key	Clave API de Stripe.	Supabase Vault
Mercado Pago Access Token	Token de acceso de Mercado Pago.	Supabase Vault
Facturapi API Key	Clave API de Facturapi.	Supabase Vault
Google OAuth Credentials	Credenciales de OAuth para Google Calendar/Meet.	Supabase Vault
WhatsApp Business API Key	Clave API de WhatsApp Business.	Supabase Vault
JWT Secret	Clave para firmar JWT.	Supabase Vault
Encryption Key (AES-256)	Clave de cifrado de datos.	Supabase Vault
Supabase JWT Secret	Clave JWT de Supabase.	Supabase (automático)
8.3. Inyección de Secretos en Kubernetes
External Secrets Operator (ESO) - Configuración:

yaml

# eso/secret-store.yaml
apiVersion: external-secrets.io/v1beta1
kind: SecretStore
metadata:
  name: supabase-vault
  namespace: production
spec:
  provider:
    vault:
      server: "https://vault.supabase.co"
      path: "secret/data/behavioralos"
      auth:
        tokenSecretRef:
          name: vault-token
          key: token

# eso/external-secret.yaml
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: behavioralos-secrets
  namespace: production
spec:
  secretStoreRef:
    name: supabase-vault
    kind: SecretStore
  target:
    name: behavioralos-secrets
    creationPolicy: Owner
  data:
  - secretKey: stripe-secret-key
    remoteRef:
      key: stripe
      property: secret-key
  - secretKey: mercado-pago-token
    remoteRef:
      key: mercadopago
      property: access-token

9. Políticas de Escalado y Health Checks
9.1. Health Checks
Endpoint	Propósito	Respuesta esperada
/health	Health check básico.	{"status": "healthy"}
/ready	Readiness check (dependencias listas).	{"status": "ready"}
9.2. Escalado Automático (HPA)
Basado en CPU: Si CPU > 70%, se escalan réplicas.

Basado en memoria: Si memoria > 80%, se escalan réplicas.

Basado en métricas personalizadas: Tamaño de cola de trabajo (BullMQ), latencia de API.

9.3. Escalado Manual (para picos planificados)
Para eventos especiales (ej. lanzamiento de una campaña), se puede escalar manualmente con kubectl scale.

10. Estrategias de Despliegue
10.1. Canary Deployments
Despliegue gradual: Se despliega una nueva versión a un pequeño porcentaje de usuarios (5-10%).

Monitoreo: Se monitorean errores, latencia y métricas de usuario.

Rollback automático: Si se detectan errores o degradación, se revierte automáticamente.

Expansión: Si todo va bien, se expande gradualmente (10% → 25% → 50% → 100%).

10.2. Blue-Green Deployments
Blue: Versión actual (en producción).

Green: Nueva versión (preparada).

Cambio: El tráfico se cambia de Blue a Green en un solo paso (con posibilidad de rollback inmediato).

10.3. Rollback Automático
Condiciones de rollback:

Tasa de error > 5% en 5 minutos.

Tiempo de respuesta > 500 ms (p95) en 5 minutos.

Aumento de alertas de seguridad.

Acción: Se revierte la versión anterior automáticamente (mediante ArgoCD o GitHub Actions).

11. Integración con el Ecosistema
11.1. Todos los Módulos
CI/CD: Todos los módulos se despliegan a través del mismo pipeline.

Monitoreo: Todos los módulos exponen métricas en el endpoint /metrics para Prometheus.

Observabilidad: Todos los módulos instrumentan trazas con OpenTelemetry.

11.2. CI/CD y BQAS
El pipeline de CI/CD ejecuta todas las pruebas del BQAS antes de desplegar.

Las Quality Gates del BQAS bloquean despliegues si no se cumplen los estándares.

11.3. Monitoreo y Alertas
Alertas: Se envían alertas a Slack, correo electrónico y PagerDuty (en producción).

Dashboards: Los dashboards de Grafana están disponibles para todos los equipos.

12. Criterios de Validación y Cumplimiento
Criterio	Métrica	Herramienta
Disponibilidad	Uptime ≥ 99.9% en producción.	Prometheus (blackbox exporter)
Tiempo de despliegue	< 15 minutos (desde el push hasta el despliegue en producción).	Monitoreo de CI/CD
Rollback	< 5 minutos para revertir a una versión anterior.	Monitoreo de CI/CD
Tiempo de recuperación (RTO)	< 4 horas en caso de desastre.	Pruebas de DR
Pérdida de datos (RPO)	< 1 hora en caso de desastre.	Pruebas de DR
Cobertura de monitoreo	100% de servicios monitoreados.	Prometheus
Cobertura de observabilidad	100% de servicios instrumentados con OpenTelemetry.	Jaeger, Loki
13. El Manifiesto de DevOps
"Una plataforma clínica como el BehavioralOS debe estar disponible 24/7, ser escalable para soportar el crecimiento, y ser recuperable ante fallos.

La infraestructura no es un mal necesario; es la base que permite que la ciencia del comportamiento llegue a más personas.

Un sistema bien operado es invisible; un sistema mal operado es una crisis constante.

Nuestra responsabilidad es garantizar que el BehavioralOS esté siempre disponible, siempre seguro y siempre escalable.

Que los despliegues sean automáticos, los fallos sean detectados antes de que afecten a los usuarios, y la recuperación sea rápida y confiable.

La excelencia operativa es la base de la confianza del usuario."

14. Historial de Cambios
Versión	Fecha	Autor	Cambios
1.0.0	2026-07-01	Arquitectura DevOps	Creación del documento. Definición de CI/CD, contenedores, monitoreo, observabilidad, respaldo, recuperación, gestión de secretos, políticas de escalado y estrategias de despliegue.
Fin del documento devops-spec.md