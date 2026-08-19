---
id: AI-006
title: Event Sourcing para Procesamiento de IA
version: 1.1.0
status: Stable
owner: Arquitectura de IA & Backend Engineering
last_updated: 2026-08-12
depends_on:
  - 400-AI/ai-core.md (AI-001 - Motor de inferencia on-device Gemma + MediaPipe)
  - 100-Architecture/system-architecture.md (BEA - arquitectura de capas)
  - 100-Architecture/engines-overview.md (BREO - catálogo de motores)
  - 200-Backend/api-graph.md (API Graph - endpoints)
exports:
  - Arquitectura Event-Driven para procesamiento de IA
  - Event Stream como System of Record
  - 7 motores derivados (RFT, ACT, FAP, BPG, Twin, BXE, BARS)
  - Redis Streams como bus de eventos
  - FastAPI BackgroundTasks para orquestación
  - Database Views como contrato público
  - Patrón Strangler Fig para migración incremental
  - Criterios de validación y métricas
used_by:
  - 400-AI/ai-core.md (Emisión de eventos desde el pipeline de IA)
  - 200-Backend/database-graph.md (Neo4j para RFT)
  - 400-AI/companion.md (TCCN consume eventos)
  - 400-AI/adaptive-orchestrator.md (AAO consume eventos)
  - 700-PracticeOS/ (Panel del terapeuta consume vistas)
---

# BehavioralOS – Event Sourcing para Procesamiento de IA (v1.0.0)

> *"El chat del paciente no es solo una conversación. Es un flujo vivo de eventos conductuales que alimenta múltiples motores científicos de forma asíncrona y tolerante a fallos."*

> **⚠️ AMENDMENT v1.1.0 (2026-08-12) — Runtime On-Device (Norma Vinculante)**
>
> La referencia al motor de inferencia de `AI-001` se actualiza al runtime **on-device
> (Gemma + MediaPipe)**: los eventos se emiten desde el runtime del dispositivo vía la
> capa de orquestación (FastAPI). No hay inferencia en servidor privado (vLLM/Ollama)
> ni embebida en navegador (WebGPU/ONNX).

---

## 1. Propósito y Alcance

### 1.1. Propósito
Este documento define la **arquitectura de eventos** para el procesamiento de IA del BehavioralOS. Su objetivo es:

- **Establecer el Event Stream como System of Record**: El chat del paciente emite "Eventos Conductuales Brutos" a un log inmutable de auditoría.
- **Habilitar 7 motores derivados** que procesan el stream de forma asíncrona e independiente.
- **Garantizar tolerancia a fallos**: Si un motor falla, los demás continúan operando.
- **Permitir escalabilidad independiente**: Cada motor se escala según su carga.
- **Facilitar la migración incremental** mediante el patrón Strangler Fig.

### 1.2. Alcance
El documento cubre:

- **Event Stream**: Log inmutable de eventos conductuales brutos.
- **7 Motores Derivados**: RFT Engine, ACT Hexaflex, FAP CRB, BPG Updater, Twin Updater, BXE Processor, BARS Aggregator.
- **Redis Streams**: Bus de eventos de alta performance.
- **FastAPI BackgroundTasks**: Orquestación de procesamiento asíncrono.
- **Database Views**: Contrato público para consumo de datos.
- **Strangler Fig**: Migración incremental desde monolito.

### 1.3. Principio Fundamental
> **"En un sistema intensivo en datos, el estado mental no se calcula de forma síncrona. Se deriva de un flujo vivo de eventos que múltiples motores observan de forma independiente, sin afectarse entre sí."**

---

## 2. Arquitectura Event-Driven

### 2.1. Visión General

```
┌─────────────────────────────────────────────────────────────────────────┐
│                  CAPA DE EMISIÓN (Chat del Paciente)                    │
│        (PWA → Gemma on-device → FastAPI → JSON)                        │
└───────────────────────────┬─────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                  EVENT STREAM (System of Record)                       │
│              (Log inmutable de auditoría - Redis Streams)              │
└──────┬──────┬──────┬──────┬──────┬──────┬──────┬───────────────────────┘
       │      │      │      │      │      │      │
       ▼      ▼      ▼      ▼      ▼      ▼      ▼
    ┌─────┐┌─────┐┌─────┐┌─────┐┌─────┐┌─────┐┌─────┐
    │ RFT ││ ACT ││ FAP ││ BPG ││Twin ││ BXE ││BARS │
    │Engine││Hexaflex││ CRB ││Updater││Updater││Proc.││Aggr.│
    └──┬──┘└──┬──┘└──┬──┘└──┬──┘└──┬──┘└──┬──┘└──┬──┘
       │      │      │      │      │      │      │
       ▼      ▼      ▼      ▼      ▼      ▼      ▼
    ┌─────────────────────────────────────────────────┐
    │           DATABASE VIEWS (Contrato Público)      │
    │     (Vistas virtuales para consumo de datos)     │
    └─────────────────────────────────────────────────┘
                            │
                            ▼
    ┌─────────────────────────────────────────────────┐
    │           CONSUMIDORES (Panel Terapeuta)         │
    └─────────────────────────────────────────────────┘
```

### 2.2. Concepto de Event Sourcing

Siguiendo las lecciones de Martin Kleppmann (Designing Data-Intensive Applications):

| Concepto | Implementación |
|----------|----------------|
| **System of Record** | El chat del paciente solo emite "Eventos Conductuales Brutos" a un log inmutable |
| **Datos Derivados** | Múltiples microservicios observan de forma asíncrona el flujo |
| **Aislamiento** | Cada motor extrae lo que necesita sin afectar a otros |
| **Tolerancia a fallos** | Si un motor falla, el chat continúa funcionando |
| **Mantenibilidad** | Agregar un nuevo motor no requiere modificar el chat |

---

## 3. Event Stream

### 3.1. Estructura del Evento

```json
{
  "event_id": "evt_1721001600",
  "timestamp": "2026-07-14T10:30:00Z",
  "paciente_id": "pac_anon_123",
  "tipo_evento": "mensaje_chat",
  "mensaje_bruto": "Siento que no sirvo para nada y evito salir",
  "analisis_clinico": {
    "proceso_emmi_detectado": "Fusión Cognitiva",
    "nivel_confianza": 0.85,
    "citas_textuales": ["no sirvo para nada", "evito salir"],
    "mision_propuesta": "defusion_cognitiva_globo",
    "riesgo_detectado": "bajo"
  },
  "metadata": {
    "session_id": "sess_abc123",
    "duracion_respuesta_ms": 150,
    "tokens_generados": 45
  }
}
```

### 3.2. Tipos de Eventos

| Tipo | Descripción | Motores que consumen |
|------|-------------|----------------------|
| `mensaje_chat` | Mensaje del paciente en el chat | Todos |
| `completacion_mision` | El paciente completó una misión | RFT, ACT, Twin, BPG |
| `evaluacion_automatica` | AAO generó una evaluación | ACT, Twin, BARS |
| ` sesion_terapeuta` | Sesión con terapeuta completada | Twin, BARS |
| `crisis_detectada` | Crisis interceptor activado | Twin, BARS (notificación) |

### 3.3. Propiedades del Stream

| Propiedad | Implementación | Propósito |
|-----------|----------------|-----------|
| **Inmutabilidad** | Los eventos nunca se modifican ni eliminan | Auditoría y trazabilidad |
| **Orden temporal** | Redis Streams mantiene orden por timestamp | Consistencia temporal |
| **Persistencia** | Almacenamiento en Redis + backup en PostgreSQL | Durabilidad |
| **Replay** | Los eventos pueden re-procesarse desde cualquier punto | Corrección de errores |
| **Escalabilidad** | Consumer groups para procesamiento paralelo | Alto throughput |

---

## 4. Los 7 Motores Derivados

### 4.1. RFT Engine (Relational Frame Theory)

| Atributo | Descripción |
|----------|-------------|
| **Función** | Propaga funciones relacionales para la Teoría del Marco Relacional |
| **Entrada** | Mensajes del chat con citas textuales |
| **Procesamiento** | Identifica marcos relacionales (comparación, oposición, equivalencia) |
| **Salida** | Actualización del grafo de relaciones en Neo4j |
| **Latencia** | < 100ms |
| **Dependencia** | Neo4j |

```python
async def procesar_derivado_rft(evento: dict):
    """Deriva los datos hacia la base de datos de grafos para RFT."""
    # Identificar marcos relacionales en el texto
    marcos = identificar_marcos(evento['mensaje_bruto'])
    # Actualizar grafo en Neo4j
    await neo4j_client.actualizar_marcos(evento['paciente_id'], marcos)
```

### 4.2. ACT Hexaflex Engine

| Atributo | Descripción |
|----------|-------------|
| **Función** | Calcula y actualiza la matriz numérica del Hexaflex |
| **Entrada** | Análisis clínico con procesos detectados |
| **Procesamiento** | Fórmulas de normalización psicométrica |
| **Salida** | Puntuaciones actualizadas de los 6 procesos del Hexaflex |
| **Latencia** | < 50ms |
| **Dependencia** | PostgreSQL |

```python
async def procesar_derivado_act_hexaflex(evento: dict, analisis: dict):
    """Calcula y actualiza el Hexaflex de forma aislada."""
    proceso = analisis['proceso_emmi_detectado']
    confianza = analisis['nivel_confianza']
    # Actualizar puntuación del proceso
    await db.actualizar_hexaflex(evento['paciente_id'], proceso, confianza)
```

### 4.3. FAP CRB Engine (Functional Analytic Psychotherapy)

| Atributo | Descripción |
|----------|-------------|
| **Función** | Clasifica secuencias de texto en busca de CRB1, CRB2, CRB3 |
| **Entrada** | Análisis clínico con citas textuales |
| **Procesamiento** | Clasificación de Comportamientos Clínicamente Relevantes |
| **Salida** | Clasificación CRB con nivel de severidad |
| **Latencia** | < 75ms |
| **Dependencia** | PostgreSQL |

```python
async def procesar_derivado_fap_crb(analisis: dict):
    """Clasifica secuencia de texto en busca de CRBs."""
    crb = clasificar_crb(analisis['citas_textuales'])
    await db.registrar_crb(analisis['paciente_id'], crb)
```

### 4.4. BPG Updater (Behavioral Progress Graph)

| Atributo | Descripción |
|----------|-------------|
| **Función** | Actualiza el gráfico de progreso conductual del paciente |
| **Entrada** | Eventos de completación de misiones y evaluaciones |
| **Procesamiento** | Agregación temporal de progreso por proceso |
| **Salida** | Datos para visualización del Atlas en el frontend |
| **Latencia** | < 30ms |
| **Dependencia** | PostgreSQL |

```python
async def procesar_derivado_bpg(evento: dict):
    """Actualiza el gráfico de progreso conductual."""
    await db.actualizar_progreso(
        evento['paciente_id'],
        evento['tipo_evento'],
        evento.get('analisis_clinico', {})
    )
```

### 4.5. Twin Updater (Behavioral Twin)

| Atributo | Descripción |
|----------|-------------|
| **Función** | Actualiza el modelo digital del paciente (Behavioral Twin) |
| **Entrada** | Todos los tipos de eventos |
| **Procesamiento** | Fusión de datos de múltiples fuentes |
| **Salida** | Twin actualizado con nuevos procesos, valores, objetivos |
| **Latencia** | < 100ms |
| **Dependencia** | PostgreSQL |

```python
async def procesar_derivado_twin(evento: dict, analisis: dict):
    """Actualiza el Behavioral Twin del paciente."""
    await twin_client.actualizar(
        evento['paciente_id'],
        proceso=analisis.get('proceso_emmi_detectado'),
        evidencia=analisis.get('citas_textuales'),
        confianza=analisis.get('nivel_confianza')
    )
```

### 4.6. BXE Processor (Behavioral Exchange)

| Atributo | Descripción |
|----------|-------------|
| **Función** | Procesa intercambios conductuales entre paciente y sistema |
| **Entrada** | Mensajes del chat y respuestas de la IA |
| **Procesamiento** | Análisis de patrones de intercambio |
| **Salida** | Métricas de calidad de la interacción |
| **Latencia** | < 50ms |
| **Dependencia** | PostgreSQL |

```python
async def procesar_derivado_bxe(evento: dict):
    """Procesa intercambios conductuales."""
    metrica = analizar_intercambio(evento)
    await db.registrar_bxe(evento['paciente_id'], metrica)
```

### 4.7. BARS Aggregator (Behavioral Analytics & Reporting Service)

| Atributo | Descripción |
|----------|-------------|
| **Función** | Agrega datos para reportes y analítica |
| **Entrada** | Eventos procesados por otros motores |
| **Procesamiento** | Agregación, agregación temporal, análisis estadístico |
| **Salida** | Reportes para el panel del terapeuta y analítica de plataforma |
| **Latencia** | < 200ms (puede ser diferida) |
| **Dependencia** | PostgreSQL, Redis |

```python
async def procesar_derivado_bars(evento: dict):
    """Agrega datos para reportes y analítica."""
    await aggregator.actualizar_metricas(evento)
    # Notificar al panel del terapeuta si hay cambios significativos
    if evento.get('analisis_clinico', {}).get('riesgo_detectado') == 'alto':
        await notificar_terapeuta(evento['paciente_id'])
```

---

## 5. Infraestructura de Eventos

### 5.1. Redis Streams

| Configuración | Valor | Propósito |
|---------------|-------|-----------|
| **Max length** | 1,000,000 eventos | Retención de datos |
| **Consumer groups** | 7 (uno por motor) | Procesamiento paralelo |
| **Ack mode** | Manual | Confirmación de procesamiento |
| **Persistence** | AOF (Append-Only File) | Durabilidad |
| **Replication** | Master-Slave | Alta disponibilidad |

### 5.2. FastAPI BackgroundTasks

```python
def emitir_evento_dominio(background_tasks: BackgroundTasks, mensaje: str, analisis: dict):
    """Publica un evento inmutable y encola tareas derivadas."""
    evento = {
        "id": f"evt_{int(time.time())}",
        "timestamp": datetime.utcnow().isoformat(),
        "mensaje_bruto": mensaje,
        "analisis_clinico": analisis
    }
    
    # Almacenar en el log inmutable
    redis_client.xadd("event_stream", evento)
    
    # Encolar procesamiento asíncrono
    background_tasks.add_task(procesar_derivado_rft, evento)
    background_tasks.add_task(procesar_derivado_act_hexaflex, evento, analisis)
    background_tasks.add_task(procesar_derivado_fap_crb, analisis)
    background_tasks.add_task(procesar_derivado_bpg, evento)
    background_tasks.add_task(procesar_derivado_twin, evento, analisis)
    background_tasks.add_task(procesar_derivado_bxe, evento)
    background_tasks.add_task(procesar_derivado_bars, evento)
```

### 5.3. Database Views (Contrato Público)

Para aislar el estado de datos y evitar acoplamiento:

```sql
-- Vista para consumo de la IA (datos anonimizados)
CREATE VIEW vista_analisis_contextual AS
SELECT 
    id AS evento_id,
    paciente_id AS anonimato_id,
    texto_sesion AS corpus_linguistico
FROM registro_conductual_bruto;

-- Vista para el panel del terapeuta
CREATE VIEW vista_progreso_paciente AS
SELECT 
    paciente_id,
    proceso,
    AVG(confianza) AS confianza_promedio,
    COUNT(*) AS total_interacciones,
    MAX(timestamp) AS ultima_actividad
FROM eventos_procesados
GROUP BY paciente_id, proceso;
```

**Ventaja**: Si el formato de almacenamiento cambia, solo se actualiza la vista; los consumidores siguen usando el mismo contrato (Zero Breaking Changes).

---

## 6. Patrón Strangler Fig (Migración Incremental)

### 6.1. Concepto

Siguiendo las lecciones de Sam Newman (Monolith to Microservices), la migración se realiza de forma incremental:

```
[Fase 1: Monolito] → [Fase 2: Intermediación] → [Fase 3: Microservicios]
         │                      │                          │
    Todo en un solo        Strangler Fig redirige       Motores independientes
    proceso síncrono       tráfico gradualmente         con contratos de datos
```

### 6.2. Implementación Frontend (Router)

```javascript
class StranglerRouter {
  constructor() {
    this.featureFlags = {
      usarNuevoStreamingPBP: true,
      usarCalculoHexaflexAntiguo: false
    };
  }

  async enrutarPeticion(endpoint, datosPayload) {
    if (endpoint === '/api/chat' && this.featureFlags.usarNuevoStreamingPBP) {
      return fetch('http://localhost:8000/api/chat/stream', {
        method: 'POST',
        body: JSON.stringify(datosPayload)
      });
    }
    return fetch(`http://localhost:8000${endpoint}`, {
      method: 'POST',
      body: JSON.stringify(datosPayload)
    });
  }
}
```

### 6.3. Ventajas de la Migración

| Ventaja | Descripción |
|---------|-------------|
| **Cero interrupciones** | No hay downtime durante la migración |
| **Rollback fácil** | Si algo falla, se desvía el tráfico al sistema anterior |
| **Testing incremental** | Cada motor se puede probar de forma aislada |
| **Escalabilidad independiente** | Cada motor se escala según su demanda |
| **Mantenibilidad** | Agregar un nuevo motor no rompe nada |

---

## 7. Tolerancia a Fallos

### 7.1. Escenarios de Fallo

| Escenario | Comportamiento del sistema |
|-----------|---------------------------|
| **Redis caído** | El chat continúa funcionando; eventos se encolan en memoria y se persisten al recuperar |
| **Motor RFT falla** | Los demás motores continúan; RFT se reconecta y procesa eventos pendientes |
| **Neo4j caído** | RFT engine entra en modo retry; otros motores no se ven afectados |
| **Backend completo caído** | La PWA almacena mensajes en IndexedDB y sincroniza al recuperar conexión |

### 7.2. Métricas de Resiliencia

| Métrica | Objetivo |
|---------|----------|
| **Disponibilidad del chat** | > 99.9% (no depende de motores derivados) |
| **Recuperación de motor** | < 30 segundos después de reconexión |
| **Pérdida de eventos** | 0% (persistencia en Redis + backup PostgreSQL) |
| **Latencia de procesamiento** | < 500ms para todos los motores |

---

## 8. Criterios de Validación

| Criterio | Métrica | Herramienta |
|----------|---------|-------------|
| Emisión de eventos | 100% mensajes generan eventos | Tests de integración |
| Procesamiento motor | >99% eventos procesados exitosamente | Monitoreo |
| Tolerancia a fallos | Chat funciona con motores caídos | Tests de resiliencia |
| Latencia total | <500ms desde mensaje hasta actualización | Métricas backend |
| Consistencia datos | 0% discrepancias entre motores | Auditoría cruzada |
| Strangler Fig | Migración incremental sin downtime | Tests de regresión |
| Database Views | 0% breaking changes en contratos | Tests de compatibilidad |

---

## 9. Referencias

- **Designing Data-Intensive Applications** (Martin Kleppmann): Event sourcing, datos derivados.
- **Monolith to Microservices** (Sam Newman): Patrón Strangler Fig, migración incremental.
- **Redis Streams**: Documentación oficial para event streaming.
- **FastAPI BackgroundTasks**: Orquestación asíncrona.

---

## 10. Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2026-07-14 | Arquitectura IA | Creación inicial: Event Stream, 7 motores derivados, Redis Streams, BackgroundTasks, Database Views, Strangler Fig. |
| 1.1.0 | 2026-08-12 | Arquitectura IA | AMENDMENT: referencia de runtime de `AI-001` estandarizada a **on-device (Gemma + MediaPipe)**; el diagrama de emisión refleja el streaming originado desde el runtime del dispositivo. |

---

**Fin del documento `event-sourcing-ai.md`**
