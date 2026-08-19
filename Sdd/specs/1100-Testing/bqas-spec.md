---
id: BQAS-001
title: Behavioral Quality Assurance System (BQAS)
version: 1.0.0
status: Stable
owner: Calidad de Software & DevOps
last_updated: 2026-07-01
depends_on:
  - 000-Core/philosophy.md (Filosofía - calidad como valor)
  - 000-Core/principles.md (Principios - rigor científico, seguridad)
  - 100-Architecture/system-architecture.md (BEA - componentes a probar)
  - 200-Backend/api-graph.md (API Graph - pruebas de API)
  - 200-Backend/database-graph.md (Database Graph - integridad de datos)
  - 300-Frontend/design-system.md (BDS - pruebas de UI)
  - 400-AI/guardrails.md (Guardrails - pruebas de IA)
  - 500-Experiencies/experience-engine.md (BERL - pruebas de ejercicios)
  - 600-Commerce/business-model.md (BCE - pruebas de pagos)
  - 700-PracticeOS/practice-os.md (BPOS - pruebas de práctica clínica)
  - 800-Analytics/outcomes-analytics.md (BIP - pruebas de modelos predictivos)
  - 900-Security/security.md (BSOS - pruebas de seguridad)
  - 1000-Integration/bril-spec.md (BRIL - pruebas de integración)
  - 000-Infrastructure/selection.md (Infraestructura - herramientas gratuitas)
exports:
  - Arquitectura del BQAS (componentes, flujos)
  - Pruebas unitarias (Pytest, Jest, Vitest)
  - Pruebas de integración (TestContainers, Docker Compose)
  - Pruebas clínicas (validación de lógica clínica)
  - Pruebas científicas (validación de modelos estadísticos)
  - Pruebas de IA (evaluación de alucinaciones, seguridad, coherencia)
  - Pruebas de seguridad (OWASP ZAP, Bandit, Semgrep, Trivy)
  - Pruebas de rendimiento (k6, Locust)
  - Pruebas de accesibilidad (axe-core, Lighthouse)
  - Pruebas de regresión (Playwright, Chromatic)
  - Quality Gates (cobertura, vulnerabilidades, rendimiento)
  - Estrategia de CI/CD (GitHub Actions, despliegues canary)
  - Integración con el ecosistema
  - Criterios de validación y métricas de éxito
used_by:
  - Todos los módulos (validación de calidad)
  - CI/CD (ejecución automática de pruebas)
  - DevOps (monitoreo de calidad)
  - BQAS (sistema de calidad)
---

# BehavioralOS – Behavioral Quality Assurance System (BQAS)

> *"La calidad no es un añadido; es un requisito fundamental en un sistema clínico. Un error en el código puede tener consecuencias graves en la salud de los pacientes. El BQAS es la red de seguridad que protege a los usuarios, a los terapeutas y a la plataforma. Cada prueba es una promesa de que el sistema funcionará como se espera, sin sorpresas, sin fallos inesperados."*

---

## 1. Propósito y Alcance

### 1.1. Propósito
Este documento define el **Behavioral Quality Assurance System (BQAS)** , el sistema de aseguramiento de calidad del BehavioralOS. Su objetivo es:

- **Garantizar la integridad científica** de los modelos y algoritmos clínicos.
- **Asegurar la corrección técnica** de todo el código (backend, frontend, IA, etc.).
- **Proteger la seguridad** de los datos y del sistema.
- **Verificar la accesibilidad** y la experiencia de usuario.
- **Automatizar el proceso de calidad** mediante pruebas unitarias, de integración, clínicas, científicas, de IA, de seguridad, de rendimiento, de accesibilidad y de regresión.
- **Establecer Quality Gates** que bloqueen despliegues si no se cumplen los estándares.
- **Integrar el testing en el pipeline de CI/CD** para garantizar que cada cambio sea validado automáticamente.

### 1.2. Alcance
El documento cubre:

- **Arquitectura del BQAS**: Componentes, flujos, herramientas.
- **Pruebas unitarias**: Pytest (Python), Jest/Vitest (JavaScript/TypeScript).
- **Pruebas de integración**: TestContainers, Docker Compose para servicios completos.
- **Pruebas clínicas**: Validación de lógica clínica (procesos, hipótesis, relaciones).
- **Pruebas científicas**: Validación de modelos estadísticos y de Machine Learning.
- **Pruebas de IA**: Evaluación de alucinaciones, seguridad, coherencia y guardrails.
- **Pruebas de seguridad**: OWASP ZAP, Bandit, Semgrep, Trivy, Gitleaks.
- **Pruebas de rendimiento**: k6, Locust para pruebas de carga y estrés.
- **Pruebas de accesibilidad**: axe-core, Lighthouse para WCAG AA/AAA.
- **Pruebas de regresión**: Playwright (E2E), Chromatic (visual).
- **Quality Gates**: Cobertura de código, vulnerabilidades, rendimiento, accesibilidad.
- **Estrategia de CI/CD**: GitHub Actions, despliegues canary, rollback automático.
- **Integración con el ecosistema**: Cómo BQAS se integra con todos los módulos.
- **Criterios de validación**: Métricas de calidad, cobertura, seguridad y rendimiento.

### 1.3. Principio Fundamental
> **"La calidad no se prueba al final; se construye desde el principio. Cada línea de código, cada modelo, cada componente debe ser validado continuamente. El BQAS es la red de seguridad que protege a los usuarios, a los terapeutas y a la plataforma. Un error en el código puede tener consecuencias graves en la salud de los pacientes."**

---

## 2. Filosofía del BQAS

### 2.1. Principios de Calidad

| # | Principio | Descripción | Manifestación |
|---|-----------|-------------|---------------|
| 1 | **Calidad como requisito** | La calidad no es un lujo; es un requisito no negociable. | Quality Gates bloquean despliegues si no se cumplen los estándares. |
| 2 | **Automatización** | Las pruebas deben ser automáticas y ejecutarse en cada cambio. | CI/CD ejecuta todas las pruebas en cada pull request. |
| 3 | **Cobertura exhaustiva** | Las pruebas deben cubrir todas las funcionalidades críticas. | Cobertura ≥ 90% en módulos críticos. |
| 4 | **Validación continua** | La calidad se valida en cada etapa del desarrollo. | Pruebas unitarias, de integración, E2E, etc. |
| 5 | **Rigor científico** | Las pruebas clínicas y científicas deben validar la lógica subyacente. | Validación de procesos, hipótesis, modelos predictivos. |
| 6 | **Seguridad por diseño** | La seguridad se prueba en cada capa. | Escaneo de vulnerabilidades, pruebas de penetración. |
| 7 | **Accesibilidad universal** | La plataforma debe ser accesible para todos. | Pruebas de accesibilidad WCAG AA. |
| 8 | **Código limpio** | DRY/KISS/YAGNI son vinculantes para todo el código del ecosistema | Quality Gates bloquean violaciones: código muerto, O(n²), setters genéricos, complejidad excesiva |

### 2.2. Pirámide de Testing

┌─────────────────────────────────────────────────────────────────────────┐
│ Pirámide de Testing │
├─────────────────────────────────────────────────────────────────────────┤
│ │
│ ┌─────────────────────────────────┐ │
│ │ Pruebas E2E (Playwright) │ │
│ │ (pocas, lentas) │ │
│ └─────────────────────────────────┘ │
│ ┌───────────────────────────────────┐ │
│ │ Pruebas de Integración (TestContainers) │ │
│ │ (algunas, medias) │ │
│ └───────────────────────────────────┘ │
│ ┌─────────────────────────────────────────────────────┐ │
│ │ Pruebas Unitarias (Pytest, Jest) │ │
│ │ (muchas, rápidas) │ │
│ └─────────────────────────────────────────────────────┘ │
│ │
│ Además de la pirámide tradicional, se añaden capas específicas: │
│ • Pruebas Clínicas (validación de lógica clínica) │
│ • Pruebas Científicas (validación de modelos) │
│ • Pruebas de IA (evaluación de alucinaciones) │
│ • Pruebas de Seguridad (OWASP ZAP, Bandit, etc.) │
│ • Pruebas de Rendimiento (k6, Locust) │
│ • Pruebas de Accesibilidad (axe-core, Lighthouse) │
└─────────────────────────────────────────────────────────────────────────┘


---

## 3. Arquitectura del BQAS

### 3.1. Visión General

┌─────────────────────────────────────────────────────────────────────────┐
│ Behavioral Quality Assurance System (BQAS) │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ Test Execution Engine │ │
│ │ • Ejecuta pruebas unitarias, de integración, E2E, etc. │ │
│ │ • Orquestado por CI/CD (GitHub Actions) │ │
│ └─────────────────────────────────────────────────────────────────┘ │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ Quality Gates Engine │ │
│ │ • Verifica cobertura de código │ │
│ │ • Verifica vulnerabilidades de seguridad │ │
│ │ • Verifica rendimiento y accesibilidad │ │
│ │ • Bloquea despliegues si no se cumplen │ │
│ └─────────────────────────────────────────────────────────────────┘ │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ Reporting & Monitoring Engine │ │
│ │ • Genera reportes de pruebas │ │
│ │ • Monitorea la calidad en producción │ │
│ │ • Alerta de regresiones │ │
│ └─────────────────────────────────────────────────────────────────┘ │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ Tooling Integration Layer │ │
│ │ • Pytest, Jest, Vitest (unit tests) │ │
│ │ • TestContainers, Docker (integration tests) │ │
│ │ • Playwright (E2E tests) │ │
│ │ • OWASP ZAP, Bandit, Semgrep (security tests) │ │
│ │ • k6, Locust (performance tests) │ │
│ │ • axe-core, Lighthouse (accessibility tests) │ │
│ │ • Chromatic (visual regression tests) │ │
│ └─────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────┘


### 3.2. Componentes del BQAS

| Componente | Descripción | Tecnología | Notas (Gratuito) |
|------------|-------------|------------|------------------|
| **Test Execution Engine** | Ejecuta todas las pruebas en CI/CD. | GitHub Actions | Gratuito (2000 min/mes) |
| **Quality Gates Engine** | Verifica métricas de calidad. | Python + scripts | Open source |
| **Reporting & Monitoring Engine** | Genera reportes y monitorea calidad. | Allure, Grafana | Allure (open source), Grafana (gratis) |
| **Tooling Integration Layer** | Integra todas las herramientas de testing. | Pipelines de CI/CD | Open source |

---

## 4. Pruebas Unitarias

### 4.1. Tecnologías

| Lenguaje | Framework | Propósito | Notas (Gratuito) |
|----------|-----------|-----------|------------------|
| Python | Pytest | Pruebas unitarias de backend. | Open source |
| Python | pytest-cov | Cobertura de código. | Open source |
| JavaScript/TypeScript | Jest / Vitest | Pruebas unitarias de frontend. | Open source |

### 4.2. Cobertura Mínima

| Módulo | Cobertura mínima | Prioridad |
|--------|------------------|-----------|
| Backend (FastAPI) | 90% | Alta |
| Frontend (React) | 80% | Alta |
| Motores de IA (TCCN, AAO) | 95% | Crítica |
| Lógica Clínica (BERL, Process Engine) | 95% | Crítica |
| Comercio (BCE) | 90% | Alta |
| Seguridad (BSOS) | 95% | Crítica |

### 4.3. Ejemplo de Prueba Unitaria (Pytest)

```python
# tests/test_berl.py
import pytest
from berl.exercise_engine import ExerciseEngine

def test_exercise_completion():
    engine = ExerciseEngine()
    result = engine.complete_exercise("EXE-001", "pat_001", 120, 85)
    assert result["status"] == "success"
    assert result["score"] == 85

def test_exercise_abandon():
    engine = ExerciseEngine()
    result = engine.abandon_exercise("EXE-001", "pat_001")
    assert result["status"] == "abandoned"
    assert result["duration"] == 0

5. Pruebas de Integración
5.1. Tecnología
Tecnología	Propósito	Notas (Gratuito)
TestContainers	Entornos de prueba con contenedores Docker.	Open source
Docker Compose	Orquestación de múltiples servicios para pruebas.	Open source
pytest-asyncio	Pruebas asíncronas de APIs FastAPI.	Open source
5.2. Cobertura de Integración
Todos los endpoints de API deben tener pruebas de integración que verifiquen:

Autenticación y autorización.

Validación de entrada/salida.

Integración con la base de datos (Supabase).

Flujos completos (ej. registro → pago → suscripción → acceso a ejercicios).

5.3. Ejemplo de Prueba de Integración (FastAPI + TestContainers)

python

# tests/integration/test_api.py
import pytest
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_create_patient():
    response = client.post(
        "/api/v1/clinical/patients",
        json={
            "first_name": "María",
            "last_name": "González",
            "email": "maria@example.com",
            "age": 34
        },
        headers={"Authorization": "Bearer valid_jwt_token"}
    )
    assert response.status_code == 201
    assert response.json()["first_name"] == "María"

def test_get_patient():
    response = client.get(
        "/api/v1/clinical/patients/pat_001",
        headers={"Authorization": "Bearer valid_jwt_token"}
    )
    assert response.status_code == 200
    assert response.json()["id"] == "pat_001"

6. Pruebas Clínicas
6.1. Propósito
Las pruebas clínicas validan que la lógica clínica (procesos, hipótesis, relaciones) no se rompa con los cambios en el código. Verifican que:

Los procesos de la ontología se actualicen correctamente en el Behavioral Twin.

Las hipótesis se generen y actualicen según las reglas clínicas.

Las relaciones entre procesos (facilitación, inhibición) se mantengan según la ciencia.

Los ejercicios entrenen los procesos correctos.

6.2. Tecnología
Tecnología	Propósito	Notas (Gratuito)
Python (pytest)	Pruebas de lógica clínica.	Open source
Datos de prueba	Casos clínicos simulados.	Open source

6.3. Ejemplo de Prueba Clínica
python

# tests/clinical/test_processes.py
import pytest
from clinical.processes import ProcessEngine

def test_acceptance_facilitates_defusion():
    engine = ProcessEngine()
    # Simular aumento de Aceptación
    engine.update_process("pat_001", "Aceptación", 0.75, 0.85)
    # Verificar que Defusión también mejora
    defusion = engine.get_process("pat_001", "Defusión")
    assert defusion["value"] > 0.5  # Debería haber mejorado

def test_avoidance_inhibits_acceptance():
    engine = ProcessEngine()
    # Simular aumento de Evitación
    engine.update_process("pat_001", "Evitación", 0.80, 0.90)
    # Verificar que Aceptación disminuye
    acceptance = engine.get_process("pat_001", "Aceptación")
    assert acceptance["value"] < 0.4  # Debería haber disminuido

7. Pruebas Científicas
7.1. Propósito
Las pruebas científicas validan que los modelos estadísticos y de Machine Learning (NetworkX, statsmodels, pyEDM, modelos predictivos del BIP) sigan siendo correctos después de los cambios en el código.

7.2. Tecnología
Tecnología	Propósito	Notas (Gratuito)
Python (pytest)	Pruebas de modelos.	Open source
Datos de prueba	Datos sintéticos para validar modelos.	Open source

7.3. Ejemplo de Prueba Científica
python

# tests/scientific/test_predictions.py
import pytest
import numpy as np
from analytics.models import DropoutPredictor

def test_dropout_prediction():
    predictor = DropoutPredictor()
    # Datos de prueba sintéticos
    X = np.random.rand(100, 10)
    y = np.random.randint(0, 2, 100)
    # Entrenar modelo (con datos de prueba)
    predictor.train(X, y)
    # Validar precisión > 0.7
    accuracy = predictor.evaluate(X, y)
    assert accuracy > 0.7

8. Pruebas de IA
8.1. Propósito
Las pruebas de IA evalúan que los modelos de IA (Gemma, TCCN, RAG) no generen alucinaciones, que sean seguros y que mantengan la coherencia clínica.

8.2. Tipos de Pruebas de IA
Tipo	Descripción	Herramienta
Alucinaciones	Verificar que la IA no invente conceptos o información.	Conjunto de prompts de prueba + validación manual/automática.
Seguridad	Verificar que la IA no genere contenido dañino o inapropiado.	Guardrails + pruebas de seguridad.
Coherencia clínica	Verificar que la IA se alinee con la ontología y la ciencia.	Validación ontológica automática.
Personalidad	Verificar que la IA mantenga el tono y estilo definidos.	Análisis de muestras de conversación.


8.3. Ejemplo de Prueba de IA (Alucinaciones)
python

# tests/ai/test_gemma.py
import pytest
from ai.core import GemmaEngine

def test_gemma_no_hallucination():
    engine = GemmaEngine()
    prompt = "¿Qué es la defusión en el contexto de ACT?"
    response = engine.generate(prompt)
    # Verificar que la respuesta no contenga conceptos inventados
    assert "defusión" in response.lower()
    assert "pensamientos" in response.lower()
    assert "observar" in response.lower()
    # Verificar que no contenga información falsa
    assert "inventado" not in response.lower()

9. Pruebas de Seguridad
9.1. Tecnologías
Herramienta	Propósito	Notas (Gratuito)
OWASP ZAP	Análisis de seguridad de aplicaciones web (DAST).	Open source
Bandit	Análisis de seguridad de código Python (SAST).	Open source
Semgrep	Análisis de seguridad de código (SAST).	Open source (community)
Trivy	Escaneo de vulnerabilidades en contenedores.	Open source
Gitleaks	Detección de secretos en código.	Open source
Dependabot	Escaneo de dependencias vulnerables.	Open source (GitHub)

9.2. Ejemplo de Prueba de Seguridad (Bandit)

python

# tests/security/run_bandit.py
import subprocess

def test_bandit():
    result = subprocess.run(
        ["bandit", "-r", "src/", "-f", "json", "-o", "bandit_report.json"],
        capture_output=True,
        text=True
    )
    # Verificar que no haya vulnerabilidades críticas o altas
    assert "CRITICAL" not in result.stdout
    assert "HIGH" not in result.stdout

10. Pruebas de Rendimiento
10.1. Tecnologías
Herramienta	Propósito	Notas (Gratuito)
k6	Pruebas de carga y rendimiento.	Open source
Locust	Pruebas de carga y rendimiento (Python).	Open source
10.2. Pruebas de Carga
API Gateway: Soporte para > 1000 usuarios concurrentes.

Event Bus: Soporte para > 10,000 eventos/segundo.

Tiempo de respuesta: < 300 ms para APIs (sin IA), < 2s para inferencia de IA.

10.3. Ejemplo de Prueba de Carga (k6)

// tests/performance/load_test.js
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
    vus: 100,  // 100 usuarios concurrentes
    duration: '30s',  // 30 segundos
};

export default function () {
    const res = http.get('https://api.behavioralos.com/api/v1/health');
    check(res, {
        'status is 200': (r) => r.status === 200,
        'response time < 200ms': (r) => r.timings.duration < 200,
    });
    sleep(1);
}

11. Pruebas de Accesibilidad
11.1. Tecnologías
Herramienta	Propósito	Notas (Gratuito)
axe-core	Pruebas de accesibilidad WCAG.	Open source
Lighthouse	Auditoría de accesibilidad en navegador.	Open source
11.2. Criterios de Accesibilidad
WCAG 2.1 AA: 100% de cumplimiento (obligatorio).

WCAG 2.1 AAA: ≥ 90% de cumplimiento (cuando sea aplicable).

11.3. Ejemplo de Prueba de Accesibilidad (axe-core)

// tests/accessibility/axe.test.js
import { AxeBuilder } from '@axe-core/playwright';
import { test, expect } from '@playwright/test';

test('homepage should be accessible', async ({ page }) => {
    await page.goto('https://patient.behavioralos.com');
    const accessibilityScanResults = await new AxeBuilder({ page })
        .withTags(['wcag2a', 'wcag2aa'])
        .analyze();
    expect(accessibilityScanResults.violations).toEqual([]);
});

12. Pruebas de Regresión
12.1. Tecnologías
Herramienta	Propósito	Notas (Gratuito)
Playwright	Pruebas E2E (funcionales).	Open source
Chromatic	Pruebas de regresión visual.	Plan gratuito para open source
12.2. Pruebas E2E (Playwright)
Flujos completos: Registro → Onboarding → Misión → Chat → Videoterapia → Pago.

Compatibilidad: Chrome, Firefox, Safari, Edge.

12.3. Pruebas de Regresión Visual (Chromatic)
Comparación de capturas de pantalla: Capturar y comparar visualmente cada componente/página.

Uso: Detectar cambios visuales no deseados en la UI.

13. Quality Gates
13.1. Criterios de Calidad
Criterio	Umbral	Herramienta	Acción
Cobertura de código (backend)	≥ 90%	pytest-cov	Bloquear despliegue si no se cumple.
Cobertura de código (frontend)	≥ 80%	Jest --coverage	Bloquear despliegue si no se cumple.
Vulnerabilidades críticas	0	OWASP ZAP, Bandit, Semgrep	Bloquear despliegue si se detecta alguna.
Vulnerabilidades altas	0	OWASP ZAP, Bandit, Semgrep	Bloquear despliegue si se detecta alguna.
Tiempo de respuesta API	< 300 ms (p95)	k6	Bloquear despliegue si no se cumple.
Accesibilidad WCAG AA	100% de cumplimiento	axe-core, Lighthouse	Bloquear despliegue si no se cumple.
Pruebas clínicas	100% de pruebas pasan	Pytest	Bloquear despliegue si no se cumple.
Pruebas científicas	100% de pruebas pasan	Pytest	Bloquear despliegue si no se cumple.
Regresiones visuales	0% de cambios no deseados	Chromatic	Alerta, pero no bloquea (requiere revisión manual).
Código muerto / YAGNI	0% código sin usar	vulture o `coverage --include-unused`	Bloquear despliegue
Complejidad ciclomática	< 10 por función	mccabe (radon)	Bloquear despliegue
Bucles anidados	Máximo 1 nivel de anidamiento	Linter de complejidad	Bloquear despliegue
Principios Torticode	100% archivos pasan validación	Script `validate_torticode.py`	Bloquear despliegue
13.2. Proceso de Quality Gates en CI/CD
Pull Request: Se ejecutan todas las pruebas.

Quality Gates: Se verifican automáticamente.

Resultado: Si todas las gates pasan, el código se puede fusionar. Si alguna falla, el PR se bloquea.

Revisión manual: En caso de regresiones visuales, se requiere revisión manual antes de fusionar.

14. Estrategia de CI/CD
14.1. Pipeline de CI/CD (GitHub Actions)

┌─────────────────────────────────────────────────────────────────────────┐
│                         Pipeline de CI/CD                              │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  [Push/PR] → [Lint] → [Unit Tests] → [Integration Tests] → [Security] │
│         ↓            ↓                ↓                  ↓            │
│  [Build] → [Deploy to Staging] → [E2E Tests] → [Performance Tests]   │
│         ↓            ↓                ↓                  ↓            │
│  [Quality Gates] → [Approval] → [Deploy to Production] (canary)       │
│                                                                         │
│  Si alguna etapa falla, el despliegue se detiene.                      │
└─────────────────────────────────────────────────────────────────────────┘


14.2. Despliegues Canary
Despliegue gradual: Se despliega la nueva versión a un pequeño porcentaje de usuarios (5-10%) primero.

Monitoreo: Se monitorean errores, rendimiento y métricas de usuario.

Rollback automático: Si se detectan errores o degradación, se revierte automáticamente.

Expansión: Si todo va bien, se expande gradualmente (10% → 25% → 50% → 100%).

14.3. Rollback Automático
Condiciones de rollback:

Tasa de error > 5% en 5 minutos.

Tiempo de respuesta > 500 ms (p95) en 5 minutos.

Aumento de alertas de seguridad.

Acción: Se revierte la versión anterior automáticamente.

15. Integración con el Ecosistema
15.1. Todos los Módulos
Pruebas unitarias: Cada módulo tiene sus propias pruebas unitarias.

Pruebas de integración: Los módulos se prueban juntos en entornos de integración.

Pruebas clínicas: Los módulos clínicos (AAO, BERL, TCCN, etc.) tienen pruebas específicas.

Pruebas científicas: Los módulos de analítica (BIP, BSC, BROS) tienen pruebas de modelos.

15.2. BQAS y CI/CD
El BQAS se ejecuta en cada pull request y en cada despliegue.

Los resultados se reportan en el PR y en el dashboard de calidad.

Las Quality Gates bloquean despliegues si no se cumplen los estándares.

16. Criterios de Validación y Cumplimiento
Criterio	Métrica	Herramienta
Cobertura de código	≥ 90% (backend), ≥ 80% (frontend)	pytest-cov, Jest
Vulnerabilidades	0 críticas, 0 altas	OWASP ZAP, Bandit, Semgrep
Tiempo de respuesta API	< 300 ms (p95)	k6
Accesibilidad	100% WCAG AA	axe-core, Lighthouse
Regresiones visuales	0% cambios no deseados	Chromatic
Pruebas clínicas	100% pasan	Pytest
Pruebas científicas	100% pasan	Pytest
Tiempo de CI/CD	< 15 minutos para pruebas completas.	Monitoreo de CI/CD
17. El Manifiesto del BQAS
"La calidad no es un añadido; es un requisito fundamental en un sistema clínico.

Un error en el código puede tener consecuencias graves en la salud de los pacientes.

El BQAS es la red de seguridad que protege a los usuarios, a los terapeutas y a la plataforma.

Cada prueba es una promesa de que el sistema funcionará como se espera, sin sorpresas, sin fallos inesperados.

Nuestra responsabilidad es garantizar que el BQAS sea riguroso, automatizado y confiable. Que cada cambio sea validado, cada regresión sea detectada, y cada despliegue sea seguro."

18. Historial de Cambios
Versión	Fecha	Autor	Cambios
1.0.0	2026-07-01	Arquitectura de Calidad	Creación del documento. Definición del BQAS: pruebas unitarias, de integración, clínicas, científicas, de IA, de seguridad, de rendimiento, de accesibilidad y de regresión. Quality Gates y estrategia de CI/CD.
Fin del documento bqas-spec.md
