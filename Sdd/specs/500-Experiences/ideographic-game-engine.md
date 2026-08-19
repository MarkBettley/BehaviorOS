---
id: IDE-001
title: Motor de Juegos Ideográficos Dinámicos
version: 1.0.0
status: Stable
owner: "Diseño de Juegos, IA & Psicología Clínica"
last_updated: 2026-07-14
depends_on:
  - 000-Core/bpo.md (BPO - ontología de procesos computacional)
  - 000-Core/bpg.md (BPG - grafo de procesos del paciente)
  - 500-Experiencies/experience-engine.md (BERL v2.0.0 - genoma de ejercicios)
  - 500-Experiencies/mechanics-library.md (BML v2.0.0 - mecánicas)
  - 500-Experiencies/process-engine.md (Motor de procesos v2.0.0 - recomendación)
  - 100-Architecture/behavioral-twin.md (Behavioral Twin - perfil del paciente)
  - 400-AI/adaptive-orchestrator.md (AAO - evaluación de procesos)
  - 000-Infrastructure/selection.md (Infraestructura - Three.js, Gemma 4)
exports:
  - DSL JSON para generación dinámica de minijuegos 3D
  - Pipeline Gemma 4 → DSL JSON → Three.js
  - Mecánicas ideográficas: absorber, soltar, equilibrar, recolectar
  - Configuración adaptativa por BPG del paciente
  - Event Sourcing de interacciones del paciente
  - Validación de configuraciones DSL generadas
  - Criterios de validación y métricas de éxito
used_by:
  - BERL v2.0.0 (generación de minijuegos ideográficos)
  - Patient App (renderizado Three.js)
  - Motor de Procesos (proporciona perfil BPG)
  - BCMS (configuración de nivel de interacción)
  - BSC (investigación de efectividad de juegos generativos)
---

# BehavioralOS – Motor de Juegos Ideográficos Dinámicos v1.0.0

> *"No podemos tener un catálogo fijo de juegos preprogramados; el sistema debe generar dinámicamente las mecánicas, las reglas y los estímulos lúdicos adaptados al perfil clínico de ese sujeto específico. Gemma 4 no escribe código de Three.js; escribe las reglas lógicas y estéticas del juego en un JSON estructurado. El motor de renderizado lee ese JSON y 'construye' el minijuego en tiempo real."*

---

## 1. Propósito y Alcance

### 1.1. Propósito
Este documento define el **Motor de Juegos Ideográficos Dinámicos** del BehavioralOS. Su objetivo es:

- **Generar minijuegos 3D dinámicos** que se adaptan al perfil clínico único de cada paciente (idiográfico).
- **Usar Gemma 4 como diseñador de juegos**: la IA genera configuraciones en DSL JSON que definen mecánicas, estímulos, colores y condiciones de victoria.
- **Renderizar en Three.js**: el frontend PWA recibe el DSL JSON y construye el minijuego 3D en tiempo real.
- **Cada juego es único**: los estímulos, colores y mecánicas reflejan la mente del paciente, no un catálogo genérico.
- **Registrar interacciones**: cada interacción genera un hecho inmutable (Event Sourcing) que el BPG consume para actualizarse.

### 1.2. Alcance
El documento cubre:

- **Pipeline completo**: Gemma 4 → DSL JSON → Three.js → Paciente → Telemetría → BPG.
- **DSL JSON**: Estructura del lenguaje de dominio para describir juegos dinámicos.
- **Mecánicas ideográficas**: absorber, soltar, equilibrar, recolectar (las 4 mecánicas base).
- **Configuración por BPG**: Cómo el BPG del paciente determina los parámetros del juego.
- **Integración con BERL v2.0.0**: Cómo el BERL invoca al motor y recibe configuraciones.
- **Event Sourcing**: Registro inmutable de interacciones para análisis clínico.
- **Criterios de validación**: Métricas de calidad, engagement y seguridad.

### 1.3. Principio Fundamental
> **"Cada paciente tiene una mente única. Sus juegos deben ser únicos también. El motor ideográfico no entrega contenido prehecho; genera experiencias vivas que reflejan la historia clínica de cada persona. No hay dos pacientes que jueguen lo mismo."**

---

## 2. Filosofía y Principios

### 2.1. ¿Por qué Ideográfico?

| Enfoque | Problema | Solución Ideográfica |
|---------|----------|---------------------|
| **Catálogo fijo** | Mismos juegos para todos → los pacientes se aburren, pierden relevancia clínica. | Cada juego se genera según el BPG del paciente. |
| **Juegos genéricos** | Estímulos neutros → no conectan con la historia del paciente. | Gemma 4 escribe estímulos específicos del paciente (pensamientos, situaciones, valores). |
| **Adaptación superficial** | Solo cambia dificultad → la experiencia se siente siempre igual. | Cambia mecánica, estímulos, colores, narrativa y condición de victoria. |
| **Sin relación con BPG** | Los juegos no modifican procesos específicos. | Cada juego mapea a procesos BPO del BPG y actualiza el grafo con telemetría. |

### 2.2. Principios de Diseño

| # | Principio | Descripción | Manifestación |
|---|-----------|-------------|---------------|
| 1 | **Absolutamente idiosincrásico** | Cada juego refleja la mente del paciente. | Los estímulos textuales son pensamientos reales del paciente. |
| 2 | **Gemma diseña, Three.js renderiza** | Separación clara entre diseño (IA) y ejecución (frontend). | Gemma genera JSON; Three.js interpreta el JSON. |
| 3 | **Mecánicas terapéuticas** | Las mecánicas de juego entrenan procesos BPO específicos. | "Equilibrar" entrena Aceptación; "Soltar" entrena Defusión. |
| 4 | **Feedback inmediato** | Cada interacción produce respuesta visual, auditiva y háptica. | Partículas, sonidos satisfactorios (juicy feedback). |
| 5 | **Fricción cero** | El paciente nunca lee instrucciones; aprende haciendo. | Mecánicas intuitivas estilo Nintendo. |
| 6 | **Diseño obvio** | Si debe equilibrar pensamientos, hay una balanza 3D. | Metáfora visual directa, no abstracta. |
| 7 | **Seguridad clínica** | Gemma 4 no genera contenido peligroso; hay validación. | Filtro de contenido + validación de configuración DSL. |

### 2.3. Las 4 Mecánicas Ideográficas Base

| Mecánica | Descripción | Proceso BPO que entrena | Ejemplo visual |
|----------|-------------|------------------------|----------------|
| **Absorber** | El paciente absorbe estímulos positivos o recursos internos. | Aceptación (BPO-CTX-000031), Autocompasión (BPO-CTX-000039) | Esferas de luz que el avatar absorbe al acercarse. |
| **Soltar** | El paciente suelta pensamientos, emociones o conductas. | Defusión (BPO-CTX-000032), Regulación (BPO-EMO-000004) | Globos con texto que explotan al soltar el dedo. |
| **Equilibrar** | El paciente equilibra fuerzas opuestas (pensamientos, emociones). | Aceptación (BPO-CTX-000031), Tolerancia al Malestar (BPO-EMO-000007) | Balanza 3D con cubos de pensamientos que deben mantenerse en equilibrio. |
| **Recolectar** | El paciente recolecta acciones alineadas con valores. | Acción Comprometida (BPO-CTX-000038), Valores (BPO-CTX-000037) | Semillas que representan microacciones; se plantan en un jardín virtual. |

---

## 3. Arquitectura del Pipeline

### 3.1. Visión General

```
┌─────────────────────────────────────────────────────────────────────────┐
│ Pipeline de Generación Ideográfica                                       │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  1. BPG del Paciente                                                    │
│     └─→ Procesos débiles, historial, eventos recientes                  │
│                                                                         │
│  2. Motor de Procesos                                                   │
│     └─→ Selecciona proceso objetivo (ej. Defusión BPO-CTX-000032)       │
│                                                                         │
│  3. Gemma 4 (Diseñador de Juegos Ideográfico)                           │
│     └─→ Lee BPG + perfil + contexto                                     │
│     └─→ Genera DSL JSON (mecánica, estímulos, colores, victoria)        │
│                                                                         │
│  4. Validador DSL                                                       │
│     └─→ Valida estructura JSON, seguridad de contenido, mapeo BPO       │
│                                                                         │
│  5. Three.js (Render Engine)                                            │
│     └─→ Recibe DSL JSON                                                 │
│     └─→ Construye escena 3D en tiempo real                              │
│     └─→ Activa físicas, partículas, sonidos                             │
│                                                                         │
│  6. Paciente juega                                                      │
│     └─→ Interacciones generan telemetría                                │
│                                                                         │
│  7. Event Sourcing                                                      │
│     └─→ Cada interacción es un evento inmutable                         │
│     └─→ Eventos alimentan el BPG del paciente                           │
│                                                                         │
│  8. BPG se actualiza                                                    │
│     └─→ Confianzas de procesos se ajustan                               │
│     └─→ Siguiente juego se genera con BPG actualizado                   │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### 3.2. Componentes

| Componente | Descripción | Tecnología |
|------------|-------------|------------|
| **BPG Provider** | Provee el perfil de procesos del paciente. | NetworkX + PostgreSQL |
| **Gemma 4 Game Designer** | Genera configuraciones DSL JSON. | Gemma 4 (12B, Ollama local) |
| **DSL Validator** | Valida la estructura y contenido del JSON. | Python (FastAPI) |
| **Three.js Renderer** | Renderiza el minijuego 3D en la PWA. | Three.js + WebGL |
| **Event Store** | Registra interacciones como eventos inmutables. | PostgreSQL (TimescaleDB) |
| **BPG Updater** | Actualiza el BPG con resultados de la sesión. | NetworkX + PostgreSQL |

---

## 4. DSL JSON: Lenguaje de Dominio para Juegos Ideográficos

### 4.1. Estructura del DSL

```json
{
  "dsl_version": "1.0.0",
  "game_id": "IDE-EXE-009-20260714",
  "timestamp": "2026-07-14T10:00:00Z",
  "patient_profile": {
    "bpg_snapshot": "hash-del-bpg-actual",
    "processo_objetivo": {
      "uuid": "BPO-CTX-000032",
      "name": "Defusión Cognitiva",
      "confidence_before": 0.82
    },
    "interaction_level": "individual"
  },
  "mecanica_principal": "soltar",
  "mecanicas_secundarias": ["observar", "distanciamiento"],
  "estimulos_textuales": [
    "No sirvo para nada",
    "Siempre fracaso",
    "No puedo con esto"
  ],
  "paleta_colores": ["#1a2a6c", "#b21f1f", "#fdbb2d"],
  "condicion_victoria": "Estallar cada globo con el pensamiento y verlo desaparecer, permitiendo que la música recupere su ritmo natural.",
  "dificultad_base": 3,
  "duracion_estimada_segundos": 180,
  "escena_3d": {
    "tipo": "balloon_burst",
    "fondo": "bosque_nocturno",
    "elementos": [
      {"tipo": "globo", "texto": "dinámico", "fisica": "flotante"},
      {"tipo": "resortera", "interaccion": "tirar"},
      {"tipo": "particulas", "evento": "explosion"},
      {"tipo": "cielo", "transicion": "oscuro_a_claro"}
    ],
    "sonido": {
      "ambiental": "bosque_calmado.ogg",
      "explosion": "globo_pop_satisfactorio.ogg",
      "victoria": "musica_ritmo_natural.ogg"
    }
  },
  "adaptacion_bpg": true,
  "adaptacion_ahee": true,
  "validado": false,
  "generado_por": "gemma4:12b",
  "validado_por": null
}
```

### 4.2. Campos del DSL

| Campo | Tipo | Obligatorio | Descripción |
|-------|------|-------------|-------------|
| `dsl_version` | string | Sí | Versión del DSL. |
| `game_id` | string | Sí | ID único del juego generado. |
| `timestamp` | ISO 8601 | Sí | Fecha/hora de generación. |
| `patient_profile` | object | Sí | Snapshot del BPG y perfil del paciente. |
| `mecanica_principal` | enum | Sí | Una de las 4 mecánicas base: `absorber`, `soltar`, `equilibrar`, `recolectar`. |
| `mecanicas_secundarias` | array | No | Mecánicas complementarias de la BML. |
| `estimulos_textuales` | array[string] | Sí | Palabras/pensamientos del paciente (mín. 3, máx. 10). |
| `paleta_colores` | array[hex] | Sí | Colores adaptados al estado de ánimo (3-5 hex). |
| `condicion_victoria` | string | Sí | Objetivo clínico encubierto en lenguaje narrativo. |
| `dificultad_base` | int (1-5) | Sí | Nivel de dificultad inicial. |
| `duracion_estimada_segundos` | int | Sí | Duración estimada de la sesión. |
| `escena_3d` | object | Sí | Configuración de la escena Three.js. |
| `adaptacion_bpg` | boolean | Sí | Si `true`, la dificultad se adapta según BPG. |
| `adaptacion_ahee` | boolean | Sí | Si `true`, la narrativa se adapta según AHEE. |

### 4.3. Mecánicas y sus Configuraciones DSL

#### Soltar (Balloon Burst)

```json
{
  "mecanica_principal": "soltar",
  "escena_3d": {
    "tipo": "balloon_burst",
    "elementos": [
      {"tipo": "globo", "texto": "estímulo_del_paciente", "fisica": "flotante", "colores": "paleta_del_paciente"},
      {"tipo": "resortera", "interaccion": "tirar_golpear"},
      {"tipo": "particulas", "evento": "explosion", "efecto": "satisfactorio"},
      {"tipo": "cielo", "transicion": "oscuro_a_claro"}
    ]
  },
  "condicion_victoria": "Estallar cada globo y ver el cielo aclararse."
}
```

**Procesos BPO**: Defusión (BPO-CTX-000032)
**Mecánicas BML**: MEC-016 (Distanciamiento) + MEC-015 (Repetición Semántica)
**Implementación Three.js**: Globos 3D flotantes con texto, resortera digital, partículas al explotar, sonido satisfactorio.

#### Equilibrar (Balance Scale)

```json
{
  "mecanica_principal": "equilibrar",
  "escena_3d": {
    "tipo": "balance_scale",
    "elementos": [
      {"tipo": "balanza", "fisica": "rigid_body"},
      {"tipo": "cubo_pensamiento", "texto": "estímulo_del_paciente", "lado": "izquierdo"},
      {"tipo": "cubo_pensamiento", "texto": "recurso_positivo", "lado": "derecho"},
      {"tipo": "timer", "duracion": "45_segundos"}
    ]
  },
  "condicion_victoria": "Sostener los bloques en equilibrio durante 45 segundos sin intentar destruirlos."
}
```

**Procesos BPO**: Aceptación (BPO-CTX-000031), Tolerancia al Malestar (BPO-EMO-000007)
**Mecánicas BML**: MEC-021 (Permanecer) + MEC-031 (Aceptación)
**Implementación Three.js**: Balanza 3D con cubos de pensamientos, físicas de balanceo, feedback visual de equilibrio.

#### Absorber (Energy Absorption)

```json
{
  "mecanica_principal": "absorber",
  "escena_3d": {
    "tipo": "energy_absorption",
    "elementos": [
      {"tipo": "avatar", "posicion": "centro"},
      {"tipo": "esfera_luz", "texto": "recurso_positivo", "movimiento": "flotante"},
      {"tipo": "aura", "efecto": "expansion_al_absorber"},
      {"tipo": "musica", "crescendo": "al_absorber"}
    ]
  },
  "condicion_victoria": "Absorber todas las esferas de luz y sentir cómo el aura se expande."
}
```

**Procesos BPO**: Aceptación (BPO-CTX-000031), Autocompasión (BPO-CTX-000039)
**Mecánicas BML**: MEC-029 (Autocompasión) + MEC-007 (Observar sin Intervenir)
**Implementación Three.js**: Esferas de luz flotantes que el avatar absorbe al acercarse, aura que se expande, música crescendo.

#### Recolectar (Harvest Values)

```json
{
  "mecanica_principal": "recolectar",
  "escena_3d": {
    "tipo": "harvest_garden",
    "elementos": [
      {"tipo": "jardin", "estado": "semillas_ocultas"},
      {"tipo": "semilla", "texto": "microaccion_del_paciente", "ubicacion": "mundo"},
      {"tipo": "planta", "crecimiento": "al_recolectar", "tipo": "representa_proceso"},
      {"tipo": "jardin_virtual", "estado": "crece_con_cada_mision"}
    ]
  },
  "condicion_victoria": "Recolectar todas las semillas y ver el jardín crecer con cada misión completada."
}
```

**Procesos BPO**: Acción Comprometida (BPO-CTX-000038), Valores (BPO-CTX-000037)
**Mecánicas BML**: MEC-019 (Elegir) + MEC-026 (Microacción) + MEC-041 (Conectar con Valores)
**Implementación Three.js**: Jardín 3D que crece con cada misión, plantas que representan procesos, semillas como microacciones.

---

## 5. Pipeline de Generación con Gemma 4

### 5.1. Flujo Técnico

```python
from fastapi import FastAPI
import openai
import json

app = FastAPI(title="Motor de Videojuegos Ideográficos")
client = openai.OpenAI(
    base_url="http://localhost:11434/v1",
    api_key="gemma4-ideographic"
)

@app.post("/api/juegos/generar-configuracion")
async def generar_juego_ideografico(body: dict):
    """
    Lee el BPG del paciente y ordena a Gemma 4 diseñar
    las reglas mecánicas de un juego a medida.
    """
    perfil_ideografico = body.get("perfil_ideografico", {})
    contexto_estimulo = body.get("ultimo_bloqueo_detectado", "")
    
    prompt_sistema = (
        "Eres el Diseñador de Videojuegos Ideográfico del sistema. "
        "Tu trabajo es crear las reglas de un minijuego 3D en formato JSON "
        "a medida para el estado clínico actual del paciente.\n\n"
        "REGLA DE DISEÑO (NINTENDO): El juego debe ser intuitivo, estético "
        "y con feedback responsivo.\n"
        "REGLA DE FORMATO: Devuelve exclusivamente un objeto JSON con las "
        "siguientes llaves exactas:\n"
        "1) 'mecanica_principal': string ('absorber', 'soltar', 'equilibrar', 'recolectar').\n"
        "2) 'estimulos_textuales': lista de strings (pensamientos específicos del paciente).\n"
        "3) 'paleta_colores': lista de hex (colores que se adaptan al estado de ánimo).\n"
        "4) 'condicion_victoria': string que describe el objetivo clínico encubierto."
    )
    
    prompt_usuario = f"""
    Genera un juego para este perfil individual:
    - Proceso BPO débil: {perfil_ideografico.get('proceso_debil', 'Fusión Cognitiva')}
    - UUID del proceso: {perfil_ideografico.get('bpo_uuid', 'BPO-CTX-000032')}
    - Confianza actual: {perfil_ideografico.get('confianza', 0.5)}
    - Historial del paciente: {perfil_ideografico.get('evitaciones_frecuentes', 'Huye de la tristeza')}
    - Estímulo gatillo actual: "{contexto_estimulo}"
    - Nivel de interacción: {perfil_ideografico.get('nivel', 'individual')}
    """
    
    response = client.chat.completions.create(
        model="gemma4:12b",
        messages=[
            {"role": "system", "content": prompt_sistema},
            {"role": "user", "content": prompt_usuario}
        ],
        response_format={"type": "json_object"},
        temperature=0.5
    )
    
    config = json.loads(response.choices[0].message.content)
    
    # Validar la configuración generada
    validacion = validar_dsl(config)
    if not validacion.valido:
        # Reintentar con más restricciones
        return await reintentar_generacion(perfil_ideografico, contexto_estimulo, validacion.errores)
    
    config["validado"] = True
    config["validado_por"] = "dsl_validator"
    
    return config
```

### 5.2. Ejemplo de Generación para un Paciente Específico

**Perfil del paciente** (BPG):
- Fusión Cognitiva: 0.82 (alta)
- Aceptación: 0.24 (baja)
- Valores: 0.61 (media)
- Último bloqueo: "Me siento fracasado en el trabajo"

**Configuración generada por Gemma 4**:

```json
{
  "mecanica_principal": "equilibrar",
  "estimulos_textuales": [
    "Tengo que ser perfecto",
    "Si fallo, me van a juzgar",
    "No sirvo para esto"
  ],
  "paleta_colores": ["#1a2a6c", "#b21f1f", "#fdbb2d"],
  "condicion_victoria": "Sostener los bloques de pensamiento en una balanza 3D durante 45 segundos sin intentar destruirlos, permitiendo que la música recupere su ritmo natural."
}
```

**Three.js renderiza**: Balanza 3D con cubos que tienen los pensamientos del paciente. Físicas de balanceo. Si el paciente intenta destruir los cubos, la balanza se desestabiliza. Si los sostiene (respiración consciente), la balanza se estabiliza y la música se armoniza.

---

## 6. Validación de Configuraciones DSL

### 6.1. Reglas de Validación

| Regla | Descripción | Acción si falla |
|-------|-------------|-----------------|
| **Estructura JSON** | El JSON debe tener todos los campos obligatorios. | Rechazar + reintentar con Gemma. |
| **Mecánica válida** | `mecanica_principal` debe ser una de las 4 base. | Reemplazar con mecánica por defecto según proceso. |
| **Estímulos mínimos** | Al menos 3 estímulos textuales. | Rechazar + reintentar. |
| **Seguridad de contenido** | Los estímulos no deben contener lenguaje autolesivo, violento o inapropiado. | Filtrar estímulos + reintentar. |
| **Mapeo BPO** | La mecánica debe ser coherente con el proceso BPO objetivo. | Ajustar mecánica o rechazar. |
| **Dificultad razonable** | Dificultad entre 1 y 5. | Ajustar a rango válido. |
| **Duración razonable** | Entre 60 y 600 segundos. | Ajustar a rango válido. |

### 6.2. Filtro de Seguridad de Contenido

```python
PALABRAS_PROHIBIDAS = [
    "suicidio", "matarme", "lastimarme", "morir",
    # ... lista completa de seguridad
]

def filtrar_estimulos(estimulos: list[str]) -> list[str]:
    """Filtra estímulos que contengan contenido peligroso."""
    return [
        e for e in estimulos 
        if not any(p in e.lower() for p in PALABRAS_PROHIBIDAS)
    ]

def validar_contenido(config: dict) -> bool:
    """Valida que el contenido generado sea clínicamente seguro."""
    estimulos_filtrados = filtrar_estimulos(config["estimulos_textuales"])
    if len(estimulos_filtrados) < 3:
        return False  # No hay suficientes estímulos seguros
    config["estimulos_textuales"] = estimulos_filtrados
    return True
```

---

## 7. Event Sourcing de Interacciones

### 7.1. Qué se Registra

Cada interacción del paciente con un juego ideográfico genera un **evento inmutable**:

```json
{
  "event_id": "EVT-20260714-001",
  "game_id": "IDE-EXE-009-20260714",
  "patient_id": "uuid-paciente",
  "timestamp": "2026-07-14T10:05:32Z",
  "event_type": "stimulus_interaction",
  "data": {
    "stimulus_text": "No sirvo para nada",
    "action": "balloon_popped",
    "latency_ms": 1200,
    "was_successful": true,
    "emotional_response_detected": "relief"
  },
  "bpg_process_before": {
    "uuid": "BPO-CTX-000032",
    "confidence": 0.82
  }
}
```

### 7.2. Flujo de Eventos al BPG

```
Paciente interactúa
  → Evento registrado en Event Store (PostgreSQL/TimescaleDB)
  → Motor de Procesos lee el evento
  → Calcula impacto en el proceso BPO objetivo
  → Actualiza la confianza en el BPG del paciente
  → BPG se modifica
  → Siguiente juego se genera con BPG actualizado
```

---

## 8. Integración con el Ecosistema

| Motor | Relación con el Motor Ideográfico |
|-------|-----------------------------------|
| **BPO** | El motor **consulta** el BPO para validar que las mecánicas sean coherentes con los procesos. |
| **BPG** | El motor **lee** el BPG del paciente para generar juegos adaptados y **actualiza** el BPG con telemetría. |
| **BERL v2.0.0** | El BERL **invoca** al motor cuando necesita un minijuego ideográfico para un paciente. |
| **Motor de Procesos** | El motor de procesos **proporciona** el proceso objetivo y el perfil BPG. |
| **AHEE** | AHEE **ajusta** parámetros narrativos (edad, preferencias) que Gemma 4 incorpora al DSL. |
| **Patient App** | La app **recibe** el DSL JSON y Three.js **renderiza** el minijuego. |
| **BSC** | BSC **analiza** datos agregados de juegos ideográficos para investigar efectividad. |
| **BCMS** | El BCMS **configura** el nivel de interacción (individual/diadico/familiar/grupal). |

---

## 9. Criterios de Validación y Cumplimiento

| Criterio | Métrica | Herramienta |
|----------|---------|-------------|
| **Generación exitosa** | ≥ 95% de las configuraciones DSL son válidas tras 1 intento. | Analítica de generación |
| **Relevancia clínica** | Los estímulos generados son relevantes para el proceso BPO objetivo (validación clínica). | Revisión por psicólogos |
| **Engagement** | Tasa de completado ≥ 80% para juegos ideográficos. | Analítica de uso |
| **Impacto en BPG** | Cambio medible en confianza del proceso objetivo después de 5 sesiones. | Análisis de BPG |
| **Seguridad** | 0% de contenido peligroso en estímulos generados. | Filtro de contenido |
| **Tiempo de generación** | < 5 segundos desde la solicitud hasta el JSON listo. | Monitoreo de rendimiento |
| **Renderizado** | < 3 segundos desde el JSON hasta el juego interactivo en Three.js. | Monitoreo de rendimiento |
| **Satisfacción** | Puntuación ≥ 4/5 en encuestas post-sesión. | Encuestas in-app |

---

## 10. El Manifiesto del Motor Ideográfico

> *"No podemos tener un catálogo fijo de juegos preprogramados. El sistema debe generar dinámicamente las mecánicas, las reglas y los estímulos lúdicos adaptados al perfil clínico de ese sujeto específico.*
>
> *Gemma 4 no escribe código de Three.js; escribe las reglas lógicas y estéticas del juego en un JSON estructurado. El motor de renderizado lee ese JSON y construye el minijuego en tiempo real.*
>
> *Cada juego es único. Los estímulos son pensamientos reales del paciente. Los colores reflejan su estado de ánimo. La mecánica entrena el proceso que necesita modificar.*
>
> *El paciente nunca lee instrucciones. Aprende haciendo. Si debe equilibrar sus pensamientos, hay una balanza 3D. Si debe soltarlos, hay globos que explotar. Si debe absorber recursos, hay esferas de luz que recoger.*
>
> *No hay dos pacientes que jueguen lo mismo. Cada juego es un reflejo de la mente de quien lo juega.*
>
> *Nuestra responsabilidad es garantizar que cada juego generado sea seguro, clínicamente relevante, intuitivo y que produzca cambio medible en el BPG del paciente."*

---

## 11. Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2026-07-14 | Arquitectura de Gamificación & IA | Creación del documento. Pipeline completo: Gemma 4 → DSL JSON → Three.js. 4 mecánicas ideográficas base (absorber, soltar, equilibrar, recolectar). DSL JSON con mapeo a procesos BPO. Validación de configuraciones. Event Sourcing de interacciones. Integración con BERL v2.0.0, BPG, AHEE. Criterios de validación. |

---

**Fin del documento `ideographic-game-engine.md` v1.0.0**
