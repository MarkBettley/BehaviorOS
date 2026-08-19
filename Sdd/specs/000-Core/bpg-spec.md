---
id: BPG-001
title: Behavioral Process Graph (BPG)
version: 1.0.0
status: Stable
owner: Arquitectura & Psicología Clínica
last_updated: 2026-07-14
depends_on:
  - BPE-001 (Behavioral Process Engine)
  - BPO-001 (Behavioral Process Ontology)
  - 000-Core (Ontología base, Principios)
exports:
  - Grafo Dirigido y Dinámico de Procesos Psicológicos
  - Modelo de nodos con estados e intensidades
  - Modelo de aristas con pesos, confianza y evidencia
  - Motor Bayesiano de actualización
  - Persistencia PostgreSQL (4 tablas)
  - Integración NetworkX MultiDiGraph
  - Visualización dual (profesional / paciente)
  - Extensión BPG-M (Multinivel)
used_by:
  - BPE-001 (Behavioral Process Engine)
  - BPO-001 (Behavioral Process Ontology)
  - BERL (Behavioral Exercise Research Lab)
  - AHEE (Adaptive Human Experience Engine)
  - TCCN (Behavioral Companion)
  - BIP (Behavioral Intelligence Platform)
  - BSC (Behavioral Science Cloud)
  - BROS (Behavioral Research Outcomes System)
  - BCMS (Behavioral Clinical Management System)
  - BXP (Behavioral Experience Platform)
  - BPOS (Behavioral Practice OS)
---

# BehavioralOS – Behavioral Process Graph (BPG)

> *"El BPG no es un grafo estático. Es el gemelo digital funcional de la mente de una persona: un sistema dinámico que respira, cambia y evoluciona con cada interacción. Todo el ecosistema lee este grafo."*

---

## 1. Propósito y Alcance

### 1.1. Propósito

El Behavioral Process Graph (BPG) es la **representación computacional dinámica** del funcionamiento psicológico de un individuo, pareja, familia o sistema. No es un módulo aislado: es el **núcleo compartido** del ecosistema completo.

El BPG parte de una idea fundamental:

```
Las personas no son etiquetas.
Son sistemas dinámicos de procesos que interactúan continuamente.
```

Por ello el motor jamás preguntará:

```
"¿Tiene depresión?"
```

Sino:

```
"¿Qué procesos mantienen este patrón?"
```

### 1.2. Alcance

El BPG define y administra:

- **Nodos**: procesos psicológicos con estados, intensidades y evidencia.
- **Aristas**: relaciones funcionales con pesos, confianza y temporalidad.
- **Motor Bayesiano**: actualización continua basada en evidencia multimodal.
- **Persistencia**: snapshots temporales nunca sobrescritos.
- **Visualización dual**: red interactiva para el profesional, ecosistema Nintendo para el paciente.
- **Extensión BPG-M**: arquitectura multinivel para parejas, familias y organizaciones.

### 1.3. Filosofía

```
El BPG no representa trastornos.
No representa diagnósticos.
Representa procesos.
Todo el ecosistema funciona leyendo este grafo.
```

La unidad mínima no es la persona. Es un **proceso psicológico**. Las personas contienen procesos. Las parejas contienen relaciones entre procesos. Las familias contienen relaciones entre relaciones.

---

## 2. Modelo de Nodos

### 2.1. Tipos de Nodos

Cada nodo representa un proceso psicológico del BPO. Los nodos se organizan por dominio teórico:

#### Procesos ACT (Contextuales)

| Nodo | Descripción |
|------|-------------|
| Aceptación | Disposición a experimentar eventos privados sin evitación |
| Defusión | Distanciamiento de contenido cognitivo literal |
| Presencia | Atención al momento presente sin juicio |
| Yo Contexto | Perspectiva del observador del contenido mental |
| Valores | Direcciones elegidas de vida |
| Acción Comprometida | Comportamiento alineado con valores |

#### Procesos FAP (Interpersonales)

| Nodo | Descripción |
|------|-------------|
| CRB1 | Contingencias reforzadoras naturales |
| CRB2 | Forma, duración, intensidad del comportamiento |
| CRB3 | Timing y elegancia del comportamiento |
| Reforzamiento Natural | Consecuencias naturales del comportamiento social |
| Intimidad | Proximidad emocional y vulnerabilidad |
| Vulnerabilidad | Apertura a ser afectado por el otro |
| Validación | Reconocimiento de la experiencia del otro |
| Conciencia Interpersonal | Atención a señales del otro |

#### Procesos PBT (Terapia Basada en Procesos)

| Nodo | Descripción |
|------|-------------|
| Selección | Procesos que incrementan supervivencia |
| Variación | Rango de comportamientos disponibles |
| Retención | Mantenimiento de comportamientos efectivos |
| Contexto | Ambiente que selecciona comportamientos |
| Historia | Experiencias pasadas que moldean repertorio |
| Función | Relación comportamiento-ambiente |
| Nivel Individual | Procesos dentro de la persona |
| Nivel Social | Procesos entre personas |
| Nivel Cultural | Procesos en contexto cultural |

#### Procesos EEMM (Meta Modelo Evolutivo Extendido)

| Nodo | Descripción |
|------|-------------|
| Afectivo | Respuestas emocionales y afecto |
| Cognitivo | Procesamiento de información |
| Atencional | Selección y mantenimiento de atención |
| Motivacional | Dirección y energía del comportamiento |
| Conductual | Acciones observables |
| Biológico | Procesos fisiológicos |
| Social | Interacciones interpersonales |
| Cultural | Normas y valores culturales |

#### Procesos Neuropsicológicos

| Nodo | Descripción |
|------|-------------|
| Inhibición | Control inhibitorio (Go/No-Go) |
| Working Memory | Memoria operativa |
| Shifting | Flexibilidad de cambio entre tareas |
| Velocidad | Velocidad de procesamiento |
| Planeación | Organización de conducta dirigida a meta |
| Monitoreo | Supervisión del propio desempeño |
| Flexibilidad Cognitiva | Adaptación a reglas cambiantes |
| Control Motor | Coordinación motora fina y gruesa |
| Atención Sostenida | Mantenimiento de atención prolongada |
| Atención Selectiva | Focalización en estímulos relevantes |

#### Procesos Motivacionales (RFT)

| Nodo | Descripción |
|------|-------------|
| Reforzamiento Positivo | Incremento por consecuencia positiva |
| Reforzamiento Negativo | Incremento por escape/evitación |
| Castigo | Reducción por consecuencia aversiva |
| Extinción | Reducción por ausencia de reforzamiento |
| Habituación | Reducción por exposición repetida |
| Sensibilización | Incremento por exposición repetida |

#### Procesos Sociales

| Nodo | Descripción |
|------|-------------|
| Apego | Vínculo afectivo primario |
| Validación | Reconocimiento de la experiencia del otro |
| Comunicación | Intercambio efectivo de información |
| Cooperación | Trabajo conjunto hacia meta compartida |
| Empatía | Comprensión de la experiencia del otro |
| Perspectiva | Capacidad de adoptar punto de vista ajeno |
| Mentalización | Comprensión de estados mentales propios y ajenos |

#### Procesos Familiares

| Nodo | Descripción |
|------|-------------|
| Triangulación | Inclusión de tercero en conflicto diádico |
| Coalición | Alianza contra un miembro |
| Jerarquía | Estructura de poder familiar |
| Roles | Funciones asignadas dentro del sistema |
| Límites | Reglas de permeabilidad del sistema |
| Escalada | Incremento progresivo de intensidad conflictiva |
| Reparación | Restablecimiento tras ruptura |
| Co-regulación | Regulación mutua de estados emocionales |

#### Procesos de Pareja (Gottman)

| Nodo | Descripción |
|------|-------------|
| Crítica | Ataque al carácter del otro |
| Desprecio | Superioridad moral e insulto |
| Defensividad | Rechazo de responsabilidad |
| Stonewalling | Retirada y bloqueo emocional |
| Repair Attempts | Esfuerzos de resolución durante conflicto |
| Fondness | Admiración y afecto positivo |
| Turning Toward | Respuesta positiva a bids de conexión |
| Conflict Repair | Resolución post-conflicto |

### 2.2. Estados del Nodo

Cada proceso posee un estado dinámico que refleja su comportamiento actual en el sistema:

| Estado | Significado | Representación Visual |
|--------|-------------|----------------------|
| **Dormido** | Proceso inactivo, sin evidencia reciente | Árbol pequeño, gris |
| **Activo** | Proceso en funcionamiento normal | Árbol verde, tamaño medio |
| **Dominante** | Proceso con alta intensidad, influencia máxima | Árbol grande, dorado |
| **En Descenso** | Proceso disminuyendo (evolución positiva) | Árbol con hojas cayendo |
| **En Mejora** | Proceso incrementando (evolución positiva) | Árbol con brotes nuevos |
| **Inestable** | Proceso con variabilidad alta | Árbol oscilante |
| **Cronificado** | Proceso estable en nivel alto (patrón rígido) | Árbol petrificado |

### 2.3. Intensidad del Nodo

Cada proceso posee una intensidad numérica:

```
Escala: 0 → 100
```

Ejemplo:

| Proceso | Intensidad |
|---------|------------|
| Evitación | 78 |
| Fusión | 61 |
| Aceptación | 24 |
| Valores | 80 |
| Flexibilidad Psicológica | 35 |
| CRB1 | 52 |
| Memoria de Trabajo | 67 |
| Regulación Emocional | 43 |

**Reglas de interpretación:**

| Rango | Interpretación |
|-------|----------------|
| 0–20 | Muy bajo / Ausente |
| 21–40 | Bajo |
| 41–60 | Moderado |
| 61–80 | Alto |
| 81–100 | Muy alto / Dominante |

---

## 3. Modelo de Aristas

### 3.1. Tipos de Relaciones

No todas las conexiones son iguales. El BPG define 7 tipos de relaciones:

| Tipo | Notación | Descripción |
|------|----------|-------------|
| **Facilitación** | A → B | A incrementa B |
| **Inhibición** | A ─\| B | A reduce B |
| **Bidireccional** | A ↔ B | A y B se influyen mutuamente |
| **Moderación** | A mod(B→C) | A modifica la fuerza de la relación B→C |
| **Mediación** | A → B → C | A afecta C a través de B |
| **Temporal** | A ⟶ B | A ocurre antes que B (secuencial) |
| **Dependencia** | A ⊂ B | A requiere de B para existir |

### 3.2. Pesos de las Relaciones

Cada arista tiene un peso que representa la fuerza de la relación:

```
Escala: 0.0 → 1.0
```

Ejemplo:

| Arista | Peso |
|--------|------|
| Fusión → Rumiación | 0.93 |
| Rumiación → Evitación | 0.87 |
| Evitación → Alivio inmediato | 0.91 |
| Alivio → Refuerzo negativo | 0.88 |
| Refuerzo negativo → Mayor evitación | 0.85 |
| Defusión → Aceptación | 0.76 |
| Valores → Acción Comprometida | 0.82 |

### 3.3. Confianza

Cada conexión guarda un nivel de confianza:

```
Escala: 0 → 100 (porcentaje)
```

Ejemplo:

| Conexión | Confianza |
|----------|-----------|
| Fusión → Rumiación | 94% |
| Aceptación → Regulación | 87% |
| CRB1 → Intimidad | 63% |
| Valores → Acción | 91% |

**Fuentes de confianza:**

| Fuente | Peso base |
|--------|-----------|
| Auto reporte | 0.60 |
| Juego | 0.55 |
| Terapeuta | 0.85 |
| IA | 0.70 |
| Wearables | 0.50 |
| Ejercicio | 0.65 |
| Entrevista | 0.80 |
| Google Meet | 0.75 |
| Familia | 0.60 |
| Pareja | 0.60 |

### 3.4. Evidencia

Toda conexión tiene evidencia asociada. Cada actualización posee un origen:

| Fuente de Evidencia | Descripción |
|---------------------|-------------|
| Auto reporte | Cuestionarios y escalas del paciente |
| Juego | Telemetría de minijuegos |
| Terapeuta | Observación clínica directa |
| IA | Análisis automático de patrones |
| Wearables | Datos fisiológicos (HRV, sueño, actividad) |
| Ejercicio | Resultados de ejercicios BERL |
| Entrevista | Sesion estructurada |
| Google Meet | Análisis de sesión en vivo |
| Familia | Reporte de miembros familiares |
| Pareja | Reporte de la pareja |

### 3.5. Temporalidad

Toda relación posee historia temporal:

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `timestamp` | datetime | Momento del registro |
| `inicio` | datetime | Momento de la primera observación |
| `ultimo_cambio` | datetime | Última modificación |
| `duracion` | interval | Tiempo desde inicio |

Esto permite **animar la evolución** del paciente a lo largo del tiempo.

---

## 4. Ejemplo: Ciclo de Evitación

Un ejemplo clásico de cómo el BPG representa un patrón clínico:

```
Fusión (71) ──[0.93]──→ Rumiación (65) ──[0.87]──→ Evitación (78)
     ↑                                                    │
     │                                                    ↓
     │                                              Alivio inmediato (82)
     │                                                    │
     │                                                    ↓
     └────────────────── Refuerzo negativo (0.85) ←───────┘
```

**Lectura clínica:**

1. Fusión cognitiva alimenta rumiación (0.93)
2. Rumiación alimenta evitación (0.87)
3. Evitación genera alivio inmediato (0.91)
4. Alivio actúa como refuerzo negativo (0.88)
5. Refuerzo negativo incrementa evitación (0.85)
6. El ciclo se cierra y se auto-mantiene

**Intervención óptima:** Atacar Fusión → Defusión, porque tiene mayor centralidad en el ciclo.

---

## 5. Motor Bayesiano de Actualización

### 5.1. Filosofía

```
Nunca existen verdades absolutas.
Solo probabilidades dinámicas.
```

Cada evidencia modifica probabilidades:

```
Prior → Nueva evidencia → Posterior
```

### 5.2. Pipeline de Actualización

```
Nueva evidencia
       ↓
Normalización
       ↓
Asignación de pesos
       ↓
Actualización Bayesiana
       ↓
Actualización NetworkX
       ↓
Persistencia (PostgreSQL)
       ↓
Visualización
```

### 5.3. Fuentes de Actualización

Cada fuente modifica el grafo:

| Fuente | Tipo de Actualización |
|--------|----------------------|
| BERL | Genera evidencia experimental |
| TCCN | Detecta procesos durante sesión |
| ASC | Elige siguiente intervención |
| AHEE | Adapta experiencia según perfil |
| BSC | Convierte grafo en recomendaciones |
| BROS | Evalúa resultados terapéuticos |
| BIP | Analiza datos anonimizados |
| Dashboard | Visualiza estado y evolución |
| App Paciente | Transforma en experiencias gamificadas |

**Todos alimentan el mismo grafo.**

### 5.4. Algoritmo Bayesiano

```python
def actualizar_proceso(proceso_id, nueva_evidencia):
    """
    Actualiza la intensidad de un proceso usando inferencia bayesiana.
    
    Big O:
        O(k) donde k = aristas salientes del proceso.
        Propagación: O(k * m) donde m = profundidad promedio del grafo.
    
    Args:
        proceso_id: UUID del proceso (BPO-XXX-XXXX)
        nueva_evidencia: dict con {fuente, valor, confianza, timestamp}
    """
    # 1. Obtener estado actual (prior)
    prior = obtener_estado(proceso_id)
    
    # 2. Normalizar evidencia
    evidencia_normalizada = normalizar(nueva_evidencia)
    
    # 3. Calcular peso de la fuente
    peso_fuente = PESOS_FUENTES[nueva_evidencia["fuente"]]
    
    # 4. Aplicar actualización bayesiana
    likelihood = calcular_likelihood(evidencia_normalizada, peso_fuente)
    posterior = (prior * likelihood) / normalizing_factor(prior, likelihood)
    
    # 5. Actualizar intensidad
    nueva_intensidad = posterior * 100  # Escalar a 0-100
    
    # 6. Determinar cambio de estado
    nuevo_estado = determinar_estado(prior, nueva_intensidad)
    
    # 7. Persistir
    guardar_snapshot(proceso_id, nueva_intensidad, nuevo_estado)
    
    # 8. Propagar efectos a procesos conectados
    propagar_efectos(proceso_id, nueva_intensidad)
    
    return {
        "proceso_id": proceso_id,
        "intensidad": nueva_intensidad,
        "estado": nuevo_estado,
        "evidencia": nueva_evidencia,
        "timestamp": datetime.now()
    }
```

### 5.5. Propagación de Efectos

Cuando un proceso cambia, los procesos conectados se actualizan:

```python
def propagar_efectos(proceso_id, nueva_intensidad):
    """
    Propaga el cambio a procesos conectados según tipo de relación.
    
    Big O:
        O(e) donde e = aristas salientes del nodo.
        Recursión controlada por UMBRAL_PROPAGACION.
    """
    aristas = obtener_aristas_salientes(proceso_id)
    
    for arista in aristas:
        factor = calcular_factor(arista.tipo, arista.peso, nueva_intensidad)
        proceso_destino = arista.destino
        
        # Solo propagar si el factor supera umbral
        if abs(factor) > UMBRAL_PROPAGACION:
            nueva_evidencia = {
                "fuente": "propagacion",
                "valor": factor,
                "confianza": arista.confianza * 0.8,  # Decaimiento
                "timestamp": datetime.now()
            }
            actualizar_proceso(proceso_destino.id, nueva_evidencia)
```

---

## 6. Persistencia PostgreSQL

### 6.1. Esquema de Tablas

El BPG se persiste en 4 tablas principales:

#### Tabla: `process_nodes`

```sql
CREATE TABLE process_nodes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    proceso_id VARCHAR(20) NOT NULL,  -- BPO-XXX-XXXX
    paciente_id UUID NOT NULL REFERENCES pacientes(id),
    dominio VARCHAR(10) NOT NULL,     -- COG, EMO, MOT, etc.
    nombre VARCHAR(100) NOT NULL,
    intensidad INTEGER DEFAULT 0 CHECK (intensidad >= 0 AND intensidad <= 100),
    estado VARCHAR(20) DEFAULT 'dormido' CHECK (estado IN (
        'dormido', 'activo', 'dominante', 'en_descenso', 
        'en_mejora', 'inestable', 'cronificado'
    )),
    confianza INTEGER DEFAULT 0 CHECK (confianza >= 0 AND confianza <= 100),
    posicion_x FLOAT DEFAULT 0.0,
    posicion_y FLOAT DEFAULT 0.0,
    posicion_z FLOAT DEFAULT 0.0,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(proceso_id, paciente_id)
);

CREATE INDEX idx_process_nodes_paciente ON process_nodes(paciente_id);
CREATE INDEX idx_process_nodes_dominio ON process_nodes(dominio);
CREATE INDEX idx_process_nodes_estado ON process_nodes(estado);
```

#### Tabla: `process_edges`

```sql
CREATE TABLE process_edges (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    origen_id UUID NOT NULL REFERENCES process_nodes(id),
    destino_id UUID NOT NULL REFERENCES process_nodes(id),
    tipo VARCHAR(20) NOT NULL CHECK (tipo IN (
        'facilitacion', 'inhibicion', 'bidireccional', 
        'moderacion', 'mediacion', 'temporal', 'dependencia'
    )),
    peso FLOAT DEFAULT 0.5 CHECK (peso >= 0.0 AND peso <= 1.0),
    confianza INTEGER DEFAULT 50 CHECK (confianza >= 0 AND confianza <= 100),
    evidencia JSONB DEFAULT '[]',
    timestamp_inicio TIMESTAMP DEFAULT NOW(),
    timestamp_ultimo_cambio TIMESTAMP DEFAULT NOW(),
    duracion INTERVAL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(origen_id, destino_id, tipo)
);

CREATE INDEX idx_process_edges_origen ON process_edges(origen_id);
CREATE INDEX idx_process_edges_destino ON process_edges(destino_id);
CREATE INDEX idx_process_edges_tipo ON process_edges(tipo);
```

#### Tabla: `process_snapshots`

```sql
CREATE TABLE process_snapshots (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    paciente_id UUID NOT NULL REFERENCES pacientes(id),
    proceso_id VARCHAR(20) NOT NULL,
    intensidad INTEGER NOT NULL,
    estado VARCHAR(20) NOT NULL,
    confianza INTEGER NOT NULL,
    evidencia JSONB DEFAULT '[]',
    fuente VARCHAR(50) NOT NULL,
    capturado_en TIMESTAMP DEFAULT NOW(),
    
    -- Nunca se sobrescribe; siempre se guarda
    -- Esto permite reconstruir toda la evolución
    UNIQUE(paciente_id, proceso_id, capturado_en)
);

CREATE INDEX idx_snapshots_paciente ON process_snapshots(paciente_id);
CREATE INDEX idx_snapshots_proceso ON process_snapshots(proceso_id);
CREATE INDEX idx_snapshots_fecha ON process_snapshots(capturado_en);
```

#### Tabla: `process_events`

```sql
CREATE TABLE process_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    paciente_id UUID NOT NULL REFERENCES pacientes(id),
    tipo_evento VARCHAR(50) NOT NULL,
    datos JSONB NOT NULL,
    fuente VARCHAR(50) NOT NULL,
    procesado BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_events_paciente ON process_events(paciente_id);
CREATE INDEX idx_events_tipo ON process_events(tipo_evento);
CREATE INDEX idx_events_procesado ON process_events(procesado);
```

### 6.2. Política de Snapshots

```
Nunca se sobrescribe el estado.
Siempre se guarda.
```

Ejemplo de evolución:

| Día | Evitación | Fusión | Aceptación | Valores |
|-----|-----------|--------|------------|---------|
| 1 | 82 | 75 | 18 | 30 |
| 8 | 78 | 71 | 24 | 35 |
| 21 | 65 | 58 | 42 | 52 |
| 90 | 34 | 31 | 71 | 85 |

**Esto permite reconstruir toda la evolución del paciente.**

---

## 7. Integración NetworkX

### 7.1. Modelo Interno

Internamente el BPG se almacena como un `MultiDiGraph` de NetworkX:

```python
import networkx as nx

# Crear grafo del paciente
G = nx.MultiDiGraph()

# Agregar nodo
G.add_node("fusion", {
    "id": "BPO-CTX-000012",
    "nombre": "Fusión Cognitiva",
    "dominio": "CTX",
    "value": 71,
    "confidence": 94,
    "estado": "activo",
    "updated": "2026-07-14",
    "evidence": [...]
})

# Agregar arista
G.add_edge("fusion", "rumiacion", {
    "tipo": "facilitacion",
    "peso": 0.93,
    "confianza": 94,
    "evidencia": [...]
})
```

### 7.2. Métricas de Red

El BPG calcula métricas de red para identificar procesos clave:

| Métrica | Descripción | Uso Clínico |
|---------|-------------|-------------|
| **Centralidad de grado** | Número de conexiones | Identificar procesos centrales |
| **Betweenness** | Frecuencia en caminos cortos | Procesos puente |
| **Closeness** | Proximidad a todos los nodos | Procesos de alto impacto |
| **Eigenvector** | Conexión con nodos importantes | Procesos influyentes |
| **Comunidades** | Grupos densamente conectados | Clusters de procesos |
| **Puentes** | Conexiones entre comunidades | Procesos de integración |
| **Cuellos de botella** | Procesos que bloquean flujo | Obstáculos críticos |
| **Resiliencia** | Robustez ante eliminación de nodos | Estabilidad del sistema |
| **Densidad** | Proporción de aristas posibles | Complejidad del sistema |
| **Modularidad** | Fuerza de estructura comunitaria | Organización del grafo |

### 7.3. Análisis de Centralidad

```python
def analizar_centralidad(G):
    """
    Identifica los procesos más centrales del grafo.
    """
    centralidad_grado = nx.degree_centrality(G)
    betweenness = nx.betweenness_centrality(G)
    closeness = nx.closeness_centrality(G)
    eigenvector = nx.eigenvector_centrality(G, max_iter=1000)
    
    # Procesos más centrales (mayor impacto en intervención)
    procesos_centrales = sorted(
        centralidad_grado.keys(),
        key=lambda x: centralidad_grado[x] + betweenness[x],
        reverse=True
    )[:5]
    
    return {
        "procesos_centrales": procesos_centrales,
        "centralidad_grado": centralidad_grado,
        "betweenness": betweenness,
        "closeness": closeness,
        "eigenvector": eigenvector
    }
```

---

## 8. Visualización Dual

### 8.1. Psicólogo: Red Interactiva

El psicólogo ve una **red interactiva** tipo Hexaflex con:

- **Nodos**: procesos con estado e intensidad
- **Aristas**: relaciones con peso y tipo
- **Colores**: por dominio (cognitivo, emocional, conductual, etc.)
- **Tamaño**: proporcional a intensidad
- **Animación**: cambios en tiempo real
- **Filtros**: por dominio, estado, intensidad
- **Temporal**: slider para ver evolución

### 8.2. Paciente: Ecosistema Nintendo

El paciente **nunca ve el grafo clínico**. Visualiza una representación gamificada:

| Modalidad | Representación |
|-----------|----------------|
| **Individual** | "Bosque" donde cada árbol representa un proceso |
| **Pareja** | Dos ecosistemas conectados por puentes |
| **Familiar** | "Reino" con personajes y conexiones |

**Ejemplo de Bosque Individual:**

| Proceso | Representación |
|---------|----------------|
| Fusión | Nube oscura |
| Rumiación | Viento turbulento |
| Evitación | Barrera rocosa |
| Aceptación | Río claro |
| Valores | Camino dorado |
| Defusión | Lago tranquilo |
| Acción Comprometida | Árbol floreciente |

La telemetría y los cambios en los procesos modifican el estado visual del mundo **sin mostrar terminología clínica**.

---

## 9. Extensión BPG-M (Multinivel)

### 9.1. Filosofía

```
La unidad mínima ya no es la persona.
La unidad mínima es un proceso psicológico.
Las personas contienen procesos.
Las parejas contienen relaciones entre procesos.
Las familias contienen relaciones entre relaciones.
Las organizaciones contienen relaciones entre familias y equipos.
```

### 9.2. Los Siete Niveles del Sistema

| Nivel | Contenido | Ejemplo |
|-------|-----------|---------|
| **Nivel 0** | Eventos | Paciente evitó, lloró, respiró, terminó ejercicio |
| **Nivel 1** | Procesos | Aceptación, Defusión, Fusión, CRB1 |
| **Nivel 2** | Individuo | Juan → BPG_Juan, María → BPG_María |
| **Nivel 3** | Relaciones | Juan ↔ María → BPG_Relación |
| **Nivel 4** | Sistema Familiar | Padre, Madre, Hijo, Hija → BPG_Familiar |
| **Nivel 5** | Organización | Clínica, Hospital, Universidad |
| **Nivel 6** | Sociedad/Cultura | Normas, Estigma, Valores culturales |

### 9.3. MetaGrafos

El BPG-M utiliza grafos dentro de grafos:

```
MetaGraph
    ↓
Graph
    ↓
SubGraph
    ↓
SubGraph
    ↓
Nodes
```

Ejemplo:

```
Familia López
    ↓
Subgrafo Padre → [Fusión, Evitación, Rigidez]
Subgrafo Madre → [Aceptación, Flexibilidad, Validación]
Subgrafo Hijo → [Ansiedad, Evitación Escolar, Miedo]
    ↓
Procesos emergentes del sistema: Triangulación, Coalición, Jerarquía
```

### 9.4. Relaciones entre Niveles

No solamente existen relaciones horizontales. También verticales:

```
Fusión Padre → Hostilidad Pareja → Ansiedad Hijo → Evitación Escolar
```

Un único camino puede cruzar cuatro niveles.

### 9.5. PostgreSQL para BPG-M

```sql
-- Tabla de niveles
CREATE TABLE process_levels (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nivel INTEGER NOT NULL CHECK (nivel >= 0 AND nivel <= 6),
    tipo VARCHAR(50) NOT NULL,  -- individual, diádico, familiar, organizacional
    descripcion TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Tabla de relaciones entre niveles
CREATE TABLE process_level_relations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nodo_origen_id UUID NOT NULL REFERENCES process_nodes(id),
    nodo_destino_id UUID NOT NULL REFERENCES process_nodes(id),
    nivel_origen INTEGER NOT NULL,
    nivel_destino INTEGER NOT NULL,
    tipo_influencia VARCHAR(50) NOT NULL,
    peso FLOAT DEFAULT 0.5,
    created_at TIMESTAMP DEFAULT NOW()
);
```

---

## 10. Integración con el Ecosistema

### 10.1. Mapa de Integración

| Motor | Acción sobre BPG |
|-------|------------------|
| **BERL** | Genera evidencia experimental → actualiza nodos |
| **TCCN** | Detecta procesos durante sesión → actualiza aristas |
| **ASC** | Consulta estado BPG → selecciona próxima intervención |
| **AHEE** | Adapta experiencia según perfil → no cambia modelo clínico |
| **BSC** | Convierte grafo en recomendaciones clínicas |
| **BROS** | Evalúa resultados terapéuticos → valida predicciones |
| **BIP** | Analiza datos anonimizados → mejora modelos |
| **Dashboard** | Visualiza estado y evolución |
| **App Paciente** | Transforma grafo en experiencias gamificadas |

### 10.2. Contrato de Integración

```python
class BPGContract:
    """Contrato de integración del BPG con el ecosistema."""
    
    def leer_estado(self, paciente_id: str) -> dict:
        """Lee el estado completo del grafo del paciente."""
        pass
    
    def actualizar_nodo(self, proceso_id: str, evidencia: dict) -> dict:
        """Actualiza un nodo con nueva evidencia."""
        pass
    
    def agregar_arista(self, origen: str, destino: str, tipo: str, peso: float) -> dict:
        """Agrega o actualiza una arista."""
        pass
    
    def calcular_centralidad(self, paciente_id: str) -> dict:
        """Calcula métricas de centralidad del grafo."""
        pass
    
    def predecir_evolucion(self, paciente_id: str, horizon_days: int) -> dict:
        """Predice evolución del grafo en N días."""
        pass
    
    def exportar_snapshot(self, paciente_id: str) -> dict:
        """Exporta snapshot completo del grafo."""
        pass
    
    def reconstruir_historial(self, paciente_id: str, fecha_inicio: str, fecha_fin: str) -> list:
        """Reconstruye la evolución del grafo entre fechas."""
        pass
```

---

## 11. Motor Predictivo

### 11.1. Predicciones

Cada nodo puede proyectarse:

```
Estado actual → Modelo → Predicción → Intervalo de confianza
```

Ejemplo:

| Predicción | Probabilidad |
|------------|--------------|
| Abandono de tratamiento | 72% |
| Recaída | 34% |
| Adherencia | 89% |
| Mejora en Flexibilidad | 78% |
| Reducción de Evitación | 65% |

**Estas predicciones siempre se presentan como apoyo a la decisión clínica, nunca como certezas ni sustituyen el juicio profesional.**

### 11.2. Modelos de Series Temporales

| Modelo | Uso |
|--------|-----|
| VAR | Vectores de procesos correlacionados |
| VARMAX | Con variables exógenas |
| ARIMA | Tendencias individuales |
| Kalman | Filtrado de ruido |
| Hidden Markov | Estados latentes |

---

## 12. Métricas del Sistema

### 12.1. Métricas de Grafo

| Métrica | Descripción | Target |
|---------|-------------|--------|
| Nodos activos | Procesos con estado ≠ dormido | Variable |
| Densidad | Aristas posibles / aristas reales | 0.3–0.7 |
| Modularidad | Fuerza de comunidades | > 0.3 |
| Resiliencia | Robustez ante eliminación | > 0.6 |
| Actualizaciones/día | Frecuencia de actualización bayesiana | > 10 |
| Latencia actualización | Tiempo desde evidencia a persistencia | < 200ms |

### 12.2. Métricas Clínicas

| Métrica | Descripción | Target |
|---------|-------------|--------|
| Procesos mejorando | Procesos con estado "en mejora" | > 0 |
| Procesos en descenso | Procesos negativos disminuyendo | > 0 |
| Estabilidad | Variancia de intensidades | < 15 |
| Cobertura | % de procesos BPO representados | > 60% |

---

## 13. Casos de Uso

### 13.1. Individual

```
Paciente con TAG:
- Fusión: 71 (activo)
- Rumiación: 65 (activo)
- Evitación: 78 (dominante)
- Aceptación: 24 (dormido)
- Valores: 30 (dormido)
- Acción Comprometida: 18 (dormido)

Intervención: Defusión + Aceptación
Resultado tras 8 semanas:
- Fusión: 45 (en descenso)
- Rumiación: 38 (en descenso)
- Evitación: 52 (en descenso)
- Aceptación: 67 (en mejora)
- Valores: 72 (en mejora)
- Acción Comprometida: 61 (en mejora)
```

### 13.2. Pareja

```
BPG_Juan: Fusión 45, Evitación 38
BPG_María: Aceptación 72, Validación 68
BPG_Relación: Sincronía 55, Repair Attempts 42, Crítica 61

Dinámica: La Crítica de María (61) facilita Stonewalling de Juan (58)
         Repair Attempts (42) actúa como moderador
```

### 13.3. Familia

```
BPG_Padre: Rigidez 74, Fusión 68
BPG_Madre: Flexibilidad 71, Validación 65
BPG_Hijo: Ansiedad 62, Evitación Escolar 58
BPG_Familiar: Triangulación 67, Coalición 54, Jerarquía 72

Dinámica: Fusión Padre → Triangulación → Ansiedad Hijo → Evitación Escolar
```

---

## 14. Preparación para Futuras Expansiones

El BPG queda diseñado como una ontología abierta para incorporar:

- Rehabilitación neuropsicológica avanzada
- Psicología organizacional
- Salud ocupacional
- Medicina conductual
- Psicología deportiva
- Coaching basado en procesos
- Intervenciones escolares
- Sistemas de apoyo mediante wearables e IoT
- Agentes de IA especializados que operen sobre el mismo grafo

---

## 15. Resumen de Especificación

| Aspecto | Especificación |
|---------|---------------|
| **Tipo** | Grafo dirigido y dinámico (MultiDiGraph) |
| **Nodos** | Procesos psicológicos (BPO-XXX-XXXX) |
| **Aristas** | Relaciones funcionales (7 tipos) |
| **Pesos** | 0.0–1.0 (fuerza de relación) |
| **Confianza** | 0–100 (nivel de certeza) |
| **Estados** | 7 estados dinámicos |
| **Intensidad** | 0–100 (nivel del proceso) |
| **Actualización** | Bayesiana continua |
| **Persistencia** | PostgreSQL (4 tablas + BPG-M) |
| **Motor de grafos** | NetworkX MultiDiGraph |
| **Visualización** | Dual (profesional / paciente) |
| **Niveles** | 7 niveles (eventos → sociedad) |
| **Modelos temporales** | VAR, VARMAX, ARIMA, Kalman, HMM |
| **Métricas** | 10 métricas de red |
| **Integración** | 9 motores del ecosistema |

---

## 16. Changelog

### v1.0.0 (2026-07-14)

- Versión inicial del BPG
- Definición de 9 tipos de nodos (ACT, FAP, PBT, EEMM, Neuro, Motivacional, Social, Familiar, Pareja)
- 7 tipos de relaciones
- 7 estados de nodo
- Motor bayesiano de actualización
- Persistencia PostgreSQL (4 tablas)
- Integración NetworkX MultiDiGraph
- Visualización dual
- Extensión BPG-M (7 niveles)
- Métricas de red
- Motor predictivo
- Casos de uso individual, pareja y familiar
