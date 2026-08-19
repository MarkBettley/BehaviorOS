---
id: AI-001
title: Motor de Inferencia IA On-Device (Gemma + MediaPipe)
version: 2.1.0
status: Stable
owner: Arquitectura de IA & Ciencia de Datos
last_updated: 2026-08-12
depends_on:
  - 000-Core/philosophy.md (Filosofía - privacidad, autonomía)
  - 000-Core/principles.md (Principios - honestidad, seguridad)
  - 100-Architecture/engines-overview.md (BREO - catálogo de motores)
  - 100-Architecture/system-architecture.md (BEA - arquitectura de capas)
  - 200-Backend/api-graph.md (API Graph - integración con backend)
exports:
  - Arquitectura de inferencia on-device: Gemma + MediaPipe
  - Decodificación restringida JSON (Constrained Decoding)
  - Function Calling para eventos clínicos
  - Prompt versioning y shadow deployments
  - Pipeline de streaming: PWA → WebSocket/SSE → Gemma on-device → JSON → motores derivados
  - Modelos soportados y formatos
  - Estrategias de privacidad y optimización
  - Criterios de validación y métricas de éxito
used_by:
  - TCCN (Compañero terapéutico)
  - AAO (Evaluación adaptativa)
  - AHEE (Adaptación de experiencia)
  - BERL (Ejercicios y gamificación)
  - BSC (Investigación y conocimiento)
  - event-sourcing-ai.md (Motores derivados)
---

# BehavioralOS – Motor de Inferencia IA On-Device (Gemma + MediaPipe) (v2.1.0)

> *"La inteligencia artificial del BehavioralOS no depende de la nube externa. No envía tus conversaciones a servidores remotos. La IA vive en tu dispositivo. Es rápida, privada y siempre disponible. Es la inteligencia que te acompaña, no la que te vigila."*

> **⚠️ AMENDMENT v2.1.0 (2026-08-12) — Runtime On-Device (Norma Vinculante)**
>
> Estandarización de runtime: **todas las AIs del BehavioralOS corren ON-DEVICE con
> Gemma + MediaPipe** (modelo + runtime de inferencia en el dispositivo del usuario).
> Este amendment **SUPERSEDE** cualquier mención previa a un servidor privado
> (vLLM/Ollama) o a inferencia embebida en navegador (WebGPU/ONNX). El streaming
> (WebSocket/SSE) se conserva, pero se origina desde el runtime on-device vía la capa
> de orquestación (FastAPI). Los fragmentos de este documento que citen vLLM/Ollama/
> servidor privado quedan corregidos por esta norma.

---

## 1. Propósito y Alcance

### 1.1. Propósito
Este documento define el **núcleo técnico de la inteligencia artificial** del BehavioralOS. Su objetivo es:

- **Establecer la arquitectura de inferencia on-device** con Gemma como modelo principal, ejecutado localmente en el dispositivo vía MediaPipe.
- **Garantizar salidas estructuradas** mediante decodificación restringida JSON (Constrained Decoding).
- **Habilitar Function Calling** para disparar eventos clínicos automatizados.
- **Gestionar prompts** con versioning y shadow deployments para evaluación segura.
- **Definir el pipeline de streaming**: PWA → WebSocket/SSE → Gemma on-device → JSON → motores derivados (streams originados desde el runtime on-device).
- **Aplicar principios de AI Engineering** (Chip Huyen) para producción resiliente.

### 1.2. Alcance
El documento cubre:

- **Gemma (LLM)**: Modelo principal de lenguaje para conversación y análisis.
- **MediaPipe (LLM Inference)**: Runtime on-device que ejecuta Gemma en el dispositivo del usuario.
- **Constrained Decoding**: Decodificación restringida para JSON garantizado.
- **Function Calling**: Llamadas a funciones para eventos clínicos.
- **Prompt Engineering**: Versioning, evaluación y shadow deployments.
- **Streaming SSE**: Transmisión en tiempo real hacia la PWA.
- **Integración con Backend**: Pipeline completo de procesamiento.
- **Optimización**: Cuantización, caching, latencia <200ms.

### 1.3. Principio Fundamental
> **"La IA del BehavioralOS es privada por diseño. Ningún dato personal abandona el servidor sin consentimiento explícito. La inteligencia artificial está al servicio del usuario, no al servicio de la vigilancia."**

---

## 2. Arquitectura de Inferencia

### 2.1. Visión General

El sistema utiliza un enfoque **on-device**: Gemma se ejecuta localmente en el dispositivo del usuario vía MediaPipe (streaming WebSocket/SSE originado desde el runtime del dispositivo):

```
┌─────────────────────────────────────────────────────────────────────────┐
│                     CAPA DE APLICACIÓN (PWA)                           │
│              (Chat casual del paciente + Micro-juegos)                  │
└───────────────────────────┬─────────────────────────────────────────────┘
                            │ WebSocket / SSE
                            ▼
┌─────────────────────────────────────────────────────────────────────────┐
│              CAPA DE ORQUESTACIÓN (FastAPI)                            │
│    (Endpoints SSE, BackgroundTasks, Event Emission)                    │
└───────────────────────────┬─────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────────────┐
│              CAPA DE INFERENCIA ON-DEVICE (MediaPipe)                  │
│         (Gemma, Constrained Decoding, Function Calling)                │
└───────────────────────────┬─────────────────────────────────────────────┘
                            │ JSON estructurado
                            ▼
┌─────────────────────────────────────────────────────────────────────────┐
│              CAPA DE PROCESAMIENTO (Motores Derivados)                  │
│    (RFT Engine, ACT Hexaflex, FAP CRB, BPG Updater, Twin Updater)     │
└─────────────────────────────────────────────────────────────────────────┘
```

### 2.2. Componentes Principales

| Componente | Tecnología | Propósito | Configuración |
|------------|------------|-----------|---------------|
| **LLM Principal** | Gemma (2B/7B/12B) | Modelo de lenguaje para conversación y análisis | On-device vía MediaPipe |
| **Motor de Inferencia** | MediaPipe LLM Inference | Runtime on-device que ejecuta Gemma en el dispositivo | `model_path` local (GGUF) |
| **API Server** | FastAPI + Uvicorn | Endpoints SSE y procesamiento asíncrono | Puerto 8000 |
| **Streaming** | Server-Sent Events | Transmisión en tiempo real a la PWA | Media type: text/event-stream |
| **Constrained Decoding** | response_format JSON | Decodificación restringida para salidas estructuradas | `response_format={"type": "json_object"}` |
| **Function Calling** | Gemma nativo | Llamadas a funciones para eventos clínicos | Definición de tools/functions |

### 2.3. Modelo Gemma

| Atributo | Descripción |
|----------|-------------|
| **Nombre** | Gemma |
| **Proveedor** | Google DeepMind |
| **Variantes** | 2B (ligero), 7B (estándar), 12B (recomendado para calidad) |
| **Formato** | GGUF (cuantización 4-bit/8-bit) |
| **Contexto** | 8192 tokens (configurable) |
| **Temperature** | 0.4 (baja para prevenir alucinaciones clínicas) |
| **Constrained Decoding** | Soportado por el runtime on-device (post-procesamiento JSON) |

---

## 3. Constrained Decoding (Decodificación Restringida)

### 3.1. Concepto

Siguiendo el framework de AI Engineering (Chip Huyen), el sistema **fuerza matemáticamente** que la IA responda exclusivamente con JSON válido:

```python
response = client.chat.completions.create(
    model="gemma4:12b",
    messages=mensajes,
    stream=True,
    response_format={"type": "json_object"},  # Fuerza JSON válido
    temperature=0.4  # Baja para prevenir alucinaciones
)
```

### 3.2. Estructura JSON de Respuesta

```json
{
  "texto_paciente": "Interesante observación. Parece que la respiración te ayuda a regular la ansiedad.",
  "analisis_psicologo": {
    "proceso_emmi_detectado": "Regulación Emocional",
    "nivel_confianza": 0.85,
    "citas_textuales": ["la respiración me ayuda a calmarme"],
    "mision_gamificada_propuesta": {
      "tipo": "defusion_cognitiva",
      "narrativa": "El Bosque de la Incertidumbre",
      "duracion_min": 5,
      "procesos_entrenados": ["Defusión", "Atención"]
    },
    "riesgo_detectado": "bajo",
    "funciones_a_invocar": ["actualizar_twin", "proponer_mision"]
  }
}
```

### 3.3. Validación de Salida

El sistema valida que el JSON cumpla el esquema antes de procesar:

| Campo | Tipo | Requerido | Validación |
|-------|------|-----------|------------|
| `texto_paciente` | string | Sí | Longitud 1-500 chars |
| `analisis_psicologo` | object | Sí | No puede ser null |
| `proceso_emmi_detectado` | string | Sí | Debe estar en ontología |
| `citas_textuales` | array | Sí | Mínimo 1 cita |
| `mision_gamificada_propuesta` | object | No | Opcional |
| `riesgo_detectado` | string | Sí | Valores: bajo, medio, alto, crisis |

---

## 4. Function Calling para Eventos Clínicos

### 4.1. Definición de Functions

```python
functions = [
    {
        "name": "actualizar_twin",
        "description": "Actualiza el Behavioral Twin del paciente con nuevo análisis",
        "parameters": {
            "tipo": "object",
            "propiedades": {
                "paciente_id": {"type": "string"},
                "proceso_detectado": {"type": "string"},
                "nivel_confianza": {"type": "number"},
                "evidencia": {"type": "array"}
            }
        }
    },
    {
        "name": "proponer_mision",
        "description": "Propone una nueva misión gamificada al paciente",
        "parameters": {
            "tipo": "object",
            "propiedades": {
                "tipo_mision": {"type": "string"},
                "narrativa": {"type": "string"},
                "duracion_min": {"type": "integer"},
                "procesos": {"type": "array"}
            }
        }
    },
    {
        "name": "escalar_terapeuta",
        "description": "Escala la conversación al terapeuta humano",
        "parameters": {
            "tipo": "object",
            "propiedades": {
                "razon": {"type": "string"},
                "nivel_urgencia": {"type": "string"},
                "contexto": {"type": "string"}
            }
        }
    }
]
```

### 4.2. Ejecución de Functions

Cuando Gemma identifica un evento clínico, ejecuta function calling que dispara:

1. **actualizar_twin**: Actualiza el Behavioral Twin con nuevos procesos detectados.
2. **proponer_mision**: Propone una misión gamificada relevante.
3. **escalar_terapeuta**: Notifica al terapeuta si hay riesgo o necesidad de intervención.

---

## 5. Prompt Engineering y Versioning

### 5.1. Estructura del Prompt del Sistema

```python
prompt_sistema = (
    "Actúas como un tutor virtual lúdico de salud emocional. "
    "Tu marco es la Psicología Contextual (PBP). "
    "REGLA DE ESTILO: Habla con encanto ('charm'), empatía y lenguaje sencillo estilo Nintendo. "
    "REGLA DE FORMATO: Debes responder EXCLUSIVAMENTE con un objeto JSON válido. "
    "REGLA CLÍNICA: Nunca uses etiquetas DSM-5. Usa la ontología PBP. "
    "REGLA DE SEGURIDAD: Si detectas ideación suicida, activa el protocolo de crisis inmediatamente."
)
```

### 5.2. Prompt Versioning

Cada versión del prompt se almacena con:

| Campo | Descripción |
|-------|-------------|
| `version_id` | Identificador único (ej. `prompt_v2.3.1`) |
| `contenido` | Texto completo del prompt |
| `autor` | Quién realizó el cambio |
| `fecha` | Timestamp del cambio |
| `motivo` | Razón del cambio |
| `metricas_evaluacion` | Precisión, recall, F1 en conjunto de evaluación |

### 5.3. Shadow Deployments

Antes de liberar un nuevo prompt:

1. **Dirigir 10% del tráfico** a una instancia en sombra de Gemma.
2. **Evaluar métricas**: Precisión de clasificación Hexaflex, sesgos biomédicos, calidad de respuestas.
3. **Comparar con versión actual** en el conjunto de evaluación.
4. **Aprobar o rechazar** basado en métricas objetivas.
5. **Liberar gradualmente**: 10% → 50% → 100% del tráfico.

---

## 6. Pipeline de Streaming

### 6.1. Flujo Completo

```
[Paciente envía mensaje desde la PWA]
         │
         ▼
┌───────────────────────────────────────────────────┐
│     CAPA DE CONTROL LOCAL (Service Worker)        │ ── (Almacena en IndexedDB)
└────────────────┬──────────────────────────────────┘
                 │ WebSocket / HTTPS
                 ▼
┌───────────────────────────────────────────────────┐
│        ORQUESTADOR CENTRAL (FastAPI)              │
│        (Gemma on-device)                         │
└────────────────┬─────────────────┬────────────────┘
                 │                 │
                 │ (Streaming)     │ (Constrained Decoding)
                 ▼                 ▼
  [Respuesta casual al Chat]     [Eventos Clínicos]
                                       │
                                       ▼
                              [Motores Derivados]
                              (RFT, ACT, FAP, BPG, Twin)
```

### 6.2. Implementación del Endpoint SSE

```python
@app.post("/api/chat/stream")
async def stream_coterapeuta(request: Request):
    body = await request.json()
    mensaje_paciente = body.get("mensaje", "")
    historial = body.get("historial", [])

    async def generador_eventos_sse():
        try:
            response = client.chat.completions.create(
                model="gemma4:12b",
                messages=[{"role": "system", "content": prompt_sistema}] + historial + [{"role": "user", "content": mensaje_paciente}],
                stream=True,
                response_format={"type": "json_object"},
                temperature=0.4
            )

            buffer = []
            for chunk in response:
                if chunk.choices and chunk.choices[0].delta.content:
                    token = chunk.choices[0].delta.content
                    buffer.append(token)
                    yield f"data: {token}\n\n"
                    await asyncio.sleep(0.005)

            # Procesar eventos derivados después del streaming
            json_completo = json.loads("".join(buffer))
            emitir_eventos_derivados(json_completo)

        except Exception as e:
            yield f"data: {json.dumps({'error': str(e)})}\n\n"

    return StreamingResponse(generador_eventos_sse(), media_type="text/event-stream")
```

### 6.3. Métricas de Rendimiento

| Métrica | Objetivo | Medición |
|---------|----------|----------|
| Latencia primera respuesta | < 200ms | Tiempo desde envío hasta primer token |
| Throughput tokens | > 50 tokens/segundo | Tokens generados por segundo |
| Tasa de error JSON | < 1% | Respuestas que no pasan validación |
| Disponibilidad | > 99.5% | Uptime del servidor de inferencia |
| Memoria del dispositivo | < 8GB | Uso de RAM con Gemma en el dispositivo |

---

## 7. Optimización y Rendimiento

### 7.1. Cuantización

| Formato | Precisión | Memoria | Velocidad | Uso |
|---------|-----------|---------|-----------|-----|
| FP16 | Máxima | ~24GB | Lenta | Desarrollo/evaluación |
| INT8 | Alta | ~12GB | Media | Producción estándar |
| INT4 (GPTQ) | Buena | ~6GB | Rápida | Producción optimizada |

### 7.2. Estrategias de Caching

- **KV Cache**: Reutilizar claves-valor de prompts del sistema.
- **Semantic Cache**: Almacenar respuestas similares para preguntas repetidas.
- **Prompt Cache**: Mantener el prompt del sistema en memoria.

---

## 8. Criterios de Validación

| Criterio | Métrica | Herramienta |
|----------|---------|-------------|
| Precisión JSON | >99% respuestas JSON válidas | Validador esquema |
| Clasificación Hexaflex | >85% F1-score | Conjunto de evaluación |
| Latencia chat | <200ms primera respuesta | Métricas backend |
| Alucinaciones clínicas | <2% en evaluación | Auditoría manual |
| Shadow deployment | 0 regresiones en métricas | Comparación A/B |
| Disponibilidad | >99.5% uptime | Monitoreo |

---

## 9. Referencias

- **AI Engineering** (Chip Huyen): Framework de producción para LLMs.
- **MediaPipe**: Runtime on-device para ejecución local de modelos.
- **GGUF**: Formato de cuantización para modelos en dispositivo.
- **Gemma**: Modelo de lenguaje de Google DeepMind.

---

## 10. Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2026-07-01 | Arquitectura IA | Creación inicial: inferencia local Gemma + MediaPipe. |
| 2.0.0 | 2026-07-14 | Arquitectura IA | Migración a Gemma 4 + vLLM on-premise, Constrained Decoding JSON, Function Calling clínico, prompt versioning, shadow deployments, pipeline streaming SSE completo. |
| 2.1.0 | 2026-08-12 | Arquitectura IA | AMENDMENT: estandarización de runtime a **on-device (Gemma + MediaPipe)** en todo el módulo 400-AI. SUPERSEDE las referencias a vLLM/Ollama y servidor privado; el streaming (WebSocket/SSE) se conserva originado desde el runtime del dispositivo. |

---

**Fin del documento `ai-core.md`**
