---
id: AI-004
title: Guardrails Clínicos, de Seguridad y Crisis Interceptor
version: 2.1.0
status: Stable
owner: Arquitectura de IA & Ética Clínica
last_updated: 2026-08-12
depends_on:
  - 000-Core/philosophy.md (Filosofía - dignidad, respeto, autonomía)
  - 000-Core/principles.md (Principios - ética, seguridad, honestidad)
  - 000-Core/ontology.md (Ontología - validación de conceptos)
  - 400-AI/ai-core.md (Motor de IA on-device - Gemma + MediaPipe)
  - 400-AI/companion.md (TCCN - respuestas conversacionales)
  - 400-AI/adaptive-orchestrator.md (AAO - evaluaciones)
  - 400-AI/rag-knowledge-graph.md (BKGE - conocimiento científico)
  - 900-Security/security.md (BSOS - protocolo de crisis, compliance)
  - 000-Infrastructure/selection.md (Infraestructura)
exports:
  - Pipeline de guardrails (entrada y salida)
  - Crisis Interceptor (filtro regex + clasificación semántica)
  - Protocolo de contención con números de emergencia
  - Bloqueo de juegos en modo crisis
  - Notificación al psicólogo en tiempo real
  - Human-in-the-loop obligatorio
  - Cumplimiento FDA (enforcement discretion) y EU MDR/AI Act
  - Validación ontológica, ética, seguridad, formato
  - Escalado a terapeuta
  - Registro y auditoría de incidentes
used_by:
  - TCCN (Compañero terapéutico)
  - AAO (Evaluación adaptativa)
  - RAG (Recuperación de conocimiento)
  - BCGS (Gobernanza y cumplimiento)
  - BQAS (Pruebas de seguridad y ética)
  - Patient App (protocolo de crisis)
---

# BehavioralOS – Guardrails Clínicos, de Seguridad y Crisis Interceptor (v2.0.0)

> *"Un guardrail no es una censura. Es un mecanismo de protección. Protege al usuario de respuestas dañinas, al terapeuta de responsabilidades no deseadas, y a la plataforma de perder la confianza de quienes la usan."*

> **⚠️ AMENDMENT v2.1.0 (2026-08-12) — Runtime On-Device (Norma Vinculante)**
>
> La referencia al motor de IA de `AI-001` se actualiza al runtime **on-device
> (Gemma + MediaPipe)**, en línea con la estandarización de runtime del módulo 400-AI.
> No hay inferencia en servidor privado (vLLM/Ollama) ni en navegador (WebGPU/ONNX).

---

## 1. Propósito y Alcance

### 1.1. Propósito
Este documento define el **sistema de guardrails clínicos y de seguridad** del BehavioralOS, incluyendo el **Crisis Interceptor**. Su objetivo es:

- **Proteger al usuario** de respuestas dañinas, inapropiadas o clínicamente inexactas.
- **Detectar y contener crisis** (ideación suicida, autolesión) en tiempo real.
- **Garantizar la alineación ética** con la Clinical AI Constitution.
- **Asegurar la validez clínica** evitando alucinaciones.
- **Escalar correctamente** los casos de alto riesgo al terapeuta o recursos de emergencia.
- **Cumplir con regulaciones** FDA (enforcement discretion) y EU MDR/AI Act (Clase I/IIa).
- **Registrar y auditar** todos los incidentes.

### 1.2. Alcance
El documento cubre:

- **Crisis Interceptor**: Filtro de seguridad por regex + clasificación semántica ligera.
- **Protocolo de contención**: Números de emergencia, bloqueo de gamificación, notificación al terapeuta.
- **Pipeline de guardrails**: Validación de entrada y salida.
- **Validación ontológica, ética, de seguridad y formato**.
- **Escalado a terapeuta** con human-in-the-loop obligatorio.
- **Cumplimiento normativo**: FDA, EU MDR/AI Act.
- **Registro y auditoría** de incidentes.

### 1.3. Principio Fundamental
> **"Los guardrails son la conciencia ética del BehavioralOS. No limitan la creatividad; la encauzan para que sea segura y útil. El sistema debe ser la plataforma más segura y ética para la psicoterapia digital."**

---

## 2. Crisis Interceptor (NUEVO v2.0.0)

### 2.1. Concepto

El **Crisis Interceptor** es un filtro de seguridad de ultra-baja latencia que se ejecuta **antes** de que la IA procese el mensaje del paciente. Su objetivo es detectar ideación suicida o riesgo autolítico y activar inmediatamente el protocolo de contención.

### 2.2. Arquitectura del Filtro

```
[Mensaje del paciente]
         │
         ▼
┌───────────────────────────────────────────────────┐
│     CRISIS INTERCEPTOR (Filtro de entrada)        │
│                                                   │
│  1. Filtro Regex (ultra-rápido, <1ms)            │
│     → Patrones de ideación suicida/autolesión     │
│                                                   │
│  2. Clasificación Semántica Ligera (si regex      │
│     detecta coincidencia)                         │
│     → Gemma con prompt especializado            │
│     → Clasificación: riesgo_bajo/medio/alto/crisis│
└────────────────┬──────────────────────────────────┘
                 │
         ┌───────┴───────┐
         │               │
    [Sin crisis]    [Crisis detectada]
         │               │
         ▼               ▼
  [Pipeline normal]  [Protocolo de Contención]
```

### 2.3. Filtro Regex

El filtro regex busca patrones de alto riesgo con expresiones regulares predefinidas:

| Categoría | Patrones (ejemplos) | Prioridad |
|-----------|---------------------|-----------|
| **Ideación suicida explícita** | "quiero morir", "me voy a matar", "acabar con todo", "no quiero vivir" | Crítica |
| **Ideación suicida implícita** | "ya no importa", "para qué seguir", "no tiene sentido", "mejor no estar" | Alta |
| **Autolesión** | "me hago daño", "me corto", "me golpeo", "me lastimo" | Alta |
| **Planificación** | "tengo un plan", "ya decidí", "es mi última vez" | Crítica |
| **Despedida** | "adiós para siempre", "cuídense", "ya no estaré" | Crítica |

**Características del filtro regex:**
- **Latencia**: < 1ms (ejecución síncrona).
- **Sensibilidad**: Alto (mejor falsos positivos que falsos negativos).
- **Case-insensitive**: Ignora mayúsculas/minúsculas.
- **Normalización**: Elimina acentos, espacios múltiples, caracteres especiales.

### 2.4. Clasificación Semántica Ligera

Cuando el regex detecta una coincidencia potencial, se ejecuta una **clasificación semántica ligera** usando Gemma con un prompt especializado:

```python
prompt_clasificacion_crisis = (
    "Clasifica el siguiente mensaje de un paciente en una categoría de riesgo. "
    "Responde SOLO con el JSON: {\"riesgo\": \"bajo\"|\"medio\"|\"alto\"|\"crisis\"} "
    "y {\"confianza\": 0.0-1.0}. "
    "No respondas nada más. Categorías: "
    "- bajo: malestar general, sin ideación "
    "- medio: pensamientos negativos, sin plan específico "
    "- alto: ideación suicida sin plan o autolesión pasiva "
    "- crisis: ideación con plan, intento reciente, autolesión activa"
)
```

### 2.5. Protocolo de Contención

Cuando se detecta una crisis (clasificación "alto" o "crisis"):

| Paso | Acción | Responsable | Tiempo |
|------|--------|-------------|--------|
| 1 | **Congelar gamificación** | Sistema | Inmediato |
| 2 | **Inyectar mensaje de crisis** | Sistema | < 500ms |
| 3 | **Mostrar números de emergencia** | Sistema | Inmediato |
| 4 | **Notificar al psicólogo** | Sistema | < 2 segundos |
| 5 | **Bloquear juegos** | Sistema | Inmediato |
| 6 | **Registrar incidente** | Sistema | < 1 segundo |
| 7 | **Escalado humano** | Psicólogo | Según protocolo clínico |

### 2.6. Mensaje de Crisis

```json
{
  "texto_paciente": "He notado que estás pasando por un momento muy difícil. No estás solo/a. Aquí tienes números de ayuda que pueden asistirte ahora mismo:",
  "numeros_emergencia": [
    {"pais": "México", "numero": "800-290-0024", "nombre": "SAPTEL"},
    {"pais": "Argentina", "numero": "135", "nombre": "Línea de la Vida"},
    {"pais": "España", "numero": "024", "nombre": "Línea de la Salud Mental"},
    {"pais": "Colombia", "numero": "106", "nombre": "Línea 106"},
    {"pais": "Chile", "numero": "600-360-7777", "nombre": "Salud Responde"},
    {"pais": "Perú", "numero": "0800-2-9000", "nombre": "Línea de la Vida"}
  ],
  "mensaje_terapeuta": "ALERTA DE CRISIS: Paciente [ID] mostró indicadores de ideación suicida. Requiere intervención inmediata.",
  "acciones_bloqueadas": ["misiones", "juegos", "gamificacion"],
  "modo_crisis_activo": true
}
```

### 2.7. Bloqueo de Gamificación en Modo Crisis

Cuando se activa el modo crisis:

- **Se desactivan todos los juegos y misiones**.
- **Se ocultan elementos de gamificación** (puntos, logros, rachas).
- **La interfaz cambia a modo neutro** (sin colores vibrantes ni animaciones de celebración).
- **El companion cambia de tono** a modo de apoyo emocional directo.
- **Se muestran recursos de ayuda** de forma prominente.
- **El modo crisis permanece activo** hasta que el psicólogo lo desactive manualmente.

### 2.8. Notificación al Psicólogo

En caso de crisis, el sistema notifica al psicólogo en tiempo real:

| Campo | Contenido |
|-------|-----------|
| **Tipo** | Alerta de crisis |
| **Paciente** | ID anonimizado |
| **Nivel de riesgo** | Alto / Crisis |
| **Evidencia** | Cita textual del mensaje |
| **Timestamp** | Fecha/hora del incidente |
| **Acción requerida** | Revisión inmediata |
| **Contacto directo** | Botón para llamar/contactar al paciente |

---

## 3. Pipeline de Guardrails

### 3.1. Pipeline de Entrada

1. **Sanitización**: Eliminar caracteres maliciosos, HTML, emojis excesivos.
2. **Crisis Interceptor**: Filtro regex + clasificación semántica.
3. **Detección de alto riesgo**: Keywords de ideación, autolesión, abuso.
4. **Clasificación de intención**: Ayuda, reflexión, crisis, solicitud de contacto.
5. **Análisis de contexto**: Información sensible, políticas de privacidad.

### 3.2. Pipeline de Salida

1. **Validación ontológica**: Verificar que los conceptos existen en la ontología PBP.
2. **Validación ética**: Clinical AI Constitution (no manipular, no juzgar, no culpar).
3. **Validación de seguridad**: No contenido dañino, no diagnósticos, no consejos peligrosos.
4. **Validación de formato**: Estructura JSON correcta, longitud adecuada.
5. **Validación de estilo**: Tono Nintendo (paciente), tono Apple (terapeuta).

### 3.3. Política de Fallback

1. **Reintento con contexto adicional** si falla validación.
2. **Respuesta genérica segura** si el reintento falla.
3. **Registro del incidente** para revisión humana.
4. **Escalado al equipo de seguridad** si el fallo se repite.

---

## 4. Cumplimiento Normativo

### 4.1. FDA (Estados Unidos)

Bajo la guía de la FDA para **Clinical Decision Support Software**:

| Criterio | Cumplimiento |
|----------|--------------|
| **Enforcement Discretion** | Aplicable: el psicólogo puede revisar y entender la base de las recomendaciones (citas textuales de la charla). |
| **Clasificación** | Software de Soporte a la Decisión Clínica (CDSS). |
| **Requisito principal** | Transparencia: el profesional debe ver las evidencias que justifican el análisis. |
| **Ventaja** | Reducción drástica de barreras burocráticas para salir al mercado. |

### 4.2. EU MDR / AI Act (Europa)

| Criterio | Cumplimiento |
|----------|--------------|
| **Clasificación MDR** | Clase I / IIa (herramienta de triaje secundario y soporte). |
| **AI Act** | No cae en categorías de alto riesgo (IA autónoma de salud mental). |
| **Proceso CE** | Significativamente más rápido y económico. |
| **Requisito** | Human-in-the-loop obligatorio: toda información y propuestas deben ser validadas por el psicólogo. |

### 4.3. Human-in-the-Loop Obligatorio

El sistema está diseñado para que **toda la información y propuestas de juego sean validadas obligatoriamente por el psicólogo** en su panel antes de activarse en la app del paciente:

| Flujo | Descripción |
|-------|-------------|
| 1. IA analiza charla casual | Gemma procesa el mensaje y genera análisis |
| 2. Análisis se envía al panel del terapeuta | El psicólogo revisa el JSON con citas textuales |
| 3. Psicólogo valida o rechaza | Acepta, modifica o rechaza la propuesta |
| 4. Solo entonces se activa en la app | La misión o análisis llega al paciente |
| 5. Psicólogo conserva responsabilidad clínica | La IA actúa solo como asistente de preparación |

---

## 5. Filosofía de los Guardrails

### 5.1. Principios de Seguridad

| # | Principio | Descripción | Manifestación |
|---|-----------|-------------|---------------|
| 1 | **Primero no dañar** | La IA nunca causa daño | Validación estricta; escalado en caso de duda |
| 2 | **Transparencia** | El usuario sabe cuándo interactúa con IA | "Soy un compañero de IA. No soy un terapeuta humano." |
| 3 | **Autonomía** | La IA respeta decisiones del usuario | Nunca usa culpa, vergüenza, presión |
| 4 | **Precisión clínica** | Solo habla de conceptos ontológicos | Validación ontológica de todos los conceptos |
| 5 | **Escalabilidad humana** | Reconoce sus límites | Detección de alto riesgo y escalado automático |
| 6 | **Auditabilidad** | Cada decisión es trazable | Registro de todas las respuestas y validaciones |
| 7 | **Crisis como prioridad** | La detección de crisis supera cualquier otra funcionalidad | Crisis Interceptor se ejecuta antes de todo procesamiento |

---

## 6. Registro y Auditoría

### 6.1. Datos Registrados

| Campo | Descripción |
|-------|-------------|
| `incident_id` | ID único del incidente |
| `timestamp` | Fecha/hora UTC |
| `paciente_id` | ID anonimizado |
| `tipo_incidente` | Crisis, violación ética, error formato, alucinación |
| `nivel_riesgo` | Bajo, medio, alto, crisis |
| `evidencia` | Mensaje del usuario (cifrado) |
| `accion_tomada` | Contención, escalado, respuesta segura |
| `guardrail_disparado` | Qué filtro detectó el incidente |
| `resolucion` | Pendiente, revisado, escalado, resuelto |

### 6.2. Retención de Datos

- **Logs de incidentes**: 5 años (cumplimiento FDA/MDR).
- **Mensajes de crisis**: Hasta resolución del caso + 2 años.
- **Auditorías**: Permanentemente en almacenamiento cifrado.

---

## 7. Criterios de Validación

| Criterio | Métrica | Herramienta |
|----------|---------|-------------|
| Detección de crisis | >99% recall en ideación suicida | Conjunto de evaluación clínica |
| Falsos positivos crisis | <10% | Auditoría manual |
| Latencia Crisis Interceptor | <50ms total (regex + semántica) | Métricas backend |
| Escalado a terapeuta | <2 segundos desde detección | Monitoreo |
| Cumplimiento FDA | 100% trazabilidad de decisiones | Auditoría interna |
| Cumplimiento EU MDR | 100% human-in-the-loop verificado | Logs de validación |
| Auditoría | 100% incidentes registrados | Sistema de logs |

---

## 8. Referencias

- **FDA Guidance**: Clinical Decision Support Software (2022).
- **EU MDR 2017/745**: Medical Device Regulation.
- **EU AI Act 2024/1689**: Artificial Intelligence Act.
- **Clinical AI Constitution**: Ética interna del BehavioralOS.

---

## 9. Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2026-07-01 | Arquitectura IA | Creación inicial: pipeline de guardrails, validación ontológica/ética/seguridad. |
| 2.0.0 | 2026-07-14 | Arquitectura IA | Agregado: Crisis Interceptor (regex + semántica), protocolo de contención, bloqueo de gamificación, notificación al psicólogo, human-in-the-loop obligatorio, cumplimiento FDA/EU MDR/AI Act. |
| 2.1.0 | 2026-08-12 | Arquitectura IA | AMENDMENT: referencia de runtime de `AI-001` estandarizada a **on-device (Gemma + MediaPipe)**, conforme a la norma de runtime del módulo 400-AI. |

---

**Fin del documento `guardrails.md`**
