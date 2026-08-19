---
id: SLS-001
title: BehavioralOS Service Landing (SLS)
version: 1.1.0
status: Stable
owner: Comercio & Arquitectura Financiera
last_updated: 2026-08-12
depends_on:
  - 300-Frontend/design-system.md (BDS-001 - design system, tokens, WCAG AA)
  - 100-Architecture/system-architecture.md (BEA - capa de negocio)
  - 200-Backend/api-graph.md (API Graph - endpoint de leads y escalación AI)
  - 600-Commerce/business-model.md (BCE - verticales de negocio)
  - 400-AI/ai-007-support.md (AI-007 - widget de soporte)
exports:
  - Landing pública de un dominio con dos audiencias (pacientes / clínicas y psicólogos)
  - Contenido informativo veraz no clínico por audiencia
  - Formulario de contacto (leads) con validación, deduplicación y consentimiento
  - Widget de soporte IA (AI-007) para reporte de errores y propuestas de mejora
  - Sitemap, metadata SEO y evaluación facilitada de Lighthouse (≥90)
  - Sin chatbot comercial: todo contacto de adquisición nace del formulario (decisión de producto)
used_by:
  - Pacientes (descubrimiento del servicio)
  - Clínicas y psicólogos (adquisición de cuentas comerciales vía leads)
  - BCE (verticales de negocio)
---

# BehavioralOS – Service Landing (SLS)

> *"La landing es la superficie de adquisición: un solo dominio, dos audiencias, sin chatbots comerciales. Todo contacto comercial nace del formulario; el único componente conversacional es el widget de soporte (AI-007) para errores y mejoras."*

---

## 1. Propósito y Alcance

### 1.1. Propósito

La landing pública del BehavioralOS presenta el servicio de forma informativa y
veraz, sirviendo a dos audiencias en un único dominio: pacientes y clínicas/
psicólogos. Su objetivo de conversión es el formulario de contacto (leads) para
la audiencia comercial. **No forma parte de BWB** (que es por-terapeuta y
multi-dominio) y **no aloja chatbot comercial** (decisión de producto: todo
contacto de adquisición nace del formulario). Como única excepción conversacional,
incorpora el **widget de soporte IA (AI-007)** para reportar errores y proponer
mejoras, sin funciones de adquisición ni contenido clínico.

> **AMENDMENT v1.1.0 (2026-08-12):** la versión original (v1.0.0) declaraba "sin
> chatbot en la superficie comercial" de forma absoluta. Por decisión de producto
> se amplía: la landing **sí aloja un widget de soporte IA** (reporte de errores y
> mejoras, ver `400-AI/ai-007-support.md`), manteniéndose el formulario como único
> camino de contacto comercial. Ver §2.4, §2.6 y §6.

### 1.2. Alcance

- Una URL base `/` que sirve ambas audiencias mediante secciones.
- Contenido estático prerendered (SSG) con hidratación SPA.
- Formulario de contacto con POST a `/api/v1/leads`.
- Widget de soporte IA (AI-007) para reporte de errores y propuestas de mejora.
- SEO básico (metadatos, títulos, sitemap) y accesibilidad WCAG AA.

### 1.3. Fuera de alcance

- BCE — pagos, CFDI 4.0, suscripciones, marketplace, cupones.
- LIC (licensing), BWB (website builder).
- IA terapéutica (TCCN) y evaluación adaptativa (AAO) — viven en patient-app, no en la superficie comercial.
- Chatbot comercial: la landing no convierte vía conversación; solo captura leads por formulario.
- Transacciones propias; la landing solo captura leads y tickets de soporte (AI-007).

---

## 2. Requisitos Funcionales

### 2.1. SLS-001-REC-001: Un dominio, dos audiencias

| Atributo | Valor |
|----------|-------|
| Descripción | La landing se sirve en un único dominio con secciones por audiencia; cada audiencia usa contenido y CTA diferenciados. |
| Criterio de aceptación | Una URL base sirve ambas audiencias; navegación por sección sin redirección de dominio. |

#### Escenarios
- **Audiencia paciente:** el visitante elige "Pacientes" y ve qué hace la plataforma, cómo empezar y cómo agendar; el CTA conduce a la app o registro de paciente.
- **Audiencia clínica:** el visitante elige "Clínicas y psicólogos" y ve beneficios de adquisición e incorporación; el CTA conduce al formulario de contacto (leads).

### 2.2. SLS-001-REC-002: Contenido informativo veraz

| Atributo | Valor |
|----------|-------|
| Descripción | Contenido veráz y no clínico: qué hace la plataforma, cómo funciona, precios/planes, beneficios por audiencia. No promete resultados terapéuticos. |
| Criterio de aceptación | Toda afirmación verificable; revisión editorial sin promesas de resultado. |

### 2.3. SLS-001-REC-003: Formulario de contacto (leads) con validación

| Atributo | Valor |
|----------|-------|
| Descripción | Validación de campos, persistencia del lead en Supabase, notificación por email; envío-exit en < 5 min; sin duplicados; consentimiento (RGPD/LFPDPPP) y confirmación visible. |
| Criterio de aceptación | Envío válido → lead + aviso < 5 min; errores ecolines y accesibles; deduplicación. |

#### Escenarios
- **Envío feliz:** clínica envía datos válidos → validación OK, lead persistido, aviso < 5 min, confirmación visible.
- **Validación fallida:** email inválido → error en línea accesible junto al campo, datos previos preserzados.

### 2.4. SLS-001-REC-004: Sin chatbot comercial en la landing

| Atributo | Valor |
|----------|-------|
| Descripción | La landing NO incluye chatbot comercial; todo contacto de adquisición nace del formulario o datos directos. La única excepción conversacional es el widget de soporte IA (AI-007) para errores y mejoras, que no genera leads ni ofrece contenido de adquisición. |
| Criterio de aceptación | 0 componentes conversacionales de adquisición; todo CTA de contacto conduce al formulario o datos directos; el widget de soporte (AI-007) está aislado del flujo comercial. |

### 2.5. SLS-001-REC-005: SEO básico, WCAG AA y rendimiento

| Atributo | Valor |
|----------|-------|
| Descripción | SEO básico (metadatos, títulos, sitemap, semántica), WCAG AA y rendimiento Lighthouse ≥90 (performance, accessibility, SEO; móvil y desktop). |
| Criterio de aceptación | Lighthouse ≥90 en los 3 ejes y ambos viewports; WCAG AA verificado; metadatos y sitemap presentes. |

### 2.6. SLS-001-REC-006: Widget de soporte IA (AI-007)

| Atributo | Valor |
|----------|-------|
| Descripción | La landing aloja el widget de soporte IA (ver `400-AI/ai-007-support.md`): un canal conversacional para reportar errores y proponer mejoras sobre el producto. No es chatbot comercial, no captura leads y no ofrece contenido terapéutico. El consentimiento de diagnóstico sigue el flujo de `consent_log` (AI-007-REC-005). |
| Criterio de aceptación | El widget está disponible en la landing (audiencia general) con intents solo de soporte/mejora; las respuestas pasan por guardrails (AI-004); el escalamiento usa `POST /api/v1/ai/escalation`; no comparte lógica con el formulario de leads. |

#### Escenarios
- **Reporte de error:** el visitante describe un error desde la landing → se crea un ticket estructurado en `support_tickets` vía `POST /api/v1/ai/escalation` con consentimiento registrado en `consent_log`.
- **Propuesta de mejora:** el visitante sugiere una mejora → se clasifica como intent `improvement` y se persiste como ticket de categoría `improvement`.
- **Consulta comercial:** el visitante pregunta por precios en el widget → el sistema redirige al formulario de contacto (SLS-001-REC-003); no se atiende comercialmente por chat.

---

## 3. Diseño Técnico

### 3.1. Stack

- **Frontend**: React 19 + TypeScript + Tailwind 4, tokens de BDS-001; Radix UI, React Hook Form + Zod, Framer Motion.
- **SSG**: prerendering estático por ruta con hidratación SPA (`vite-react-ssg`).
- **Backend**: FastAPI; POST `/api/v1/leads` valida (Pydantic), aplica deduplicación UNIQUE(email, org_name, source), RLS insert-only en Supabase.
- **Email worker**: disparado por insert, aviso < 5 min (Resend/SMTP, proveedor configurable).

### 3.2. Rutas

| Ruta | Audiencia | Contenido |
|------|-----------|-----------|
| `/` | ambas | Presentación general con entry points por audiencia |
| `/pacientes` | pacientes | Qué hace, cómo empezar, cómo agendar |
| `/clinicas-psicologos` | clínica | Beneficios de adquisición e incorporación, formulario de contacto |
| `/pricing` | ambas | Planes y precios |
| `/contacto` | clínica | Formulario SLS-001-REC-003 |

### 3.3. Flujo de leads

1. Usuario completa el formulario (validación cliente con Zod).
2. POST `/api/v1/leads` con `consent=true`, `source='landing'`.
3. Backend valida e inserta con deduplicación `UNIQUE(email, COALESCE(org_name,''), source)`.
4. Duplicado → `409`; sin consentimiento → `422`.
5. Éxito → `201` con `{lead_id, status:'received'}` + aviso por email < 5 min.
6. Confirmación visible al usuario (`role="status"`).

El esquema de la tabla `leads` está especificado en `200-Backend/database-graph.md`
(§4.3.6) y registrado en el modelo de datos (`100-Architecture/data-model.md`, dominio
`commerce`).

---

## 4. No funcionales y Seguridad

- **Privacidad**: consentimiento obligatorio (RGPD/LFPDPPP); minimización de datos.
- **RLS**: anónimos insert-only; sin select/update público sobre `leads` ni `support_tickets`.
- **Anti-bot**: honeypot + rate-limit del lado cliente (aplica a formulario y widget).
- **Accesibilidad**: WCAG AA; contraste ≥ 4.5:1; navegación por teclado; `prefers-reduced-motion`.
- **Guardrails del widget**: toda respuesta del widget de soporte pasa por el pipeline de guardrails (AI-004); nunca ofrece contenido clínico ni terapéutico.

---

## 5. Métricas

| Métrica | Objetivo |
|---------|----------|
| Lighthouse (perf / a11y / SEO) móvil + desktop | ≥ 90 |
| WCAG AA (axe) | 0 violaciones |
| Lead → email | < 5 min |
| Bundle total JS | < 300 KB gzip |

---

## 6. Trazabilidad

- Delta spec: `landing-ia-atencion` (obs #262) → SLS-001; AMENDMENT v1.1.0 (2026-08-12) → AI-007 (widget de soporte).
- Aristas del grafo: `SLS-001 → BCE-001` (verticales), `SLS-001 → BDS-001` (design system), `SLS-001 → BE` (leads), `SLS-001 → AI-007` (widget de soporte).
- Guardrail: 400-AI (solo alineación runtime/paths en ai-core/companion); NO AAO, NO RAG, NO BCE pagos/CFDI/mp, NO LIC, NO BWB.

---

## 7. Historial

| Versión | Fecha | Cambios |
|---------|-------|---------|
| 1.0.0 | 2026-08-07 | Creación del spec (delta `landing-ia-atencion`). |
| 1.1.0 | 2026-08-12 | AMENDMENT: landing aloja widget de soporte IA (AI-007) para errores/mejoras; formulario sigue siendo el único canal comercial. Nuevo REC-006, actualización de REC-004, exports, alcance, no funcionales y trazabilidad. Estado promovido a `Stable`. |