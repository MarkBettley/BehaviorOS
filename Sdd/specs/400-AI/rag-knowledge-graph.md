---
id: AI-005
title: Conocimiento Científico (BKGE + BSC)
version: 1.0.0
status: Stable
owner: Arquitectura de IA & Ciencia de Datos
last_updated: 2026-07-01
depends_on:
  - 000-Core/ontology.md (Ontología - entidades, relaciones)
  - 400-AI/ai-core.md (Motor de inferencia local - sentence-transformers)
  - 400-AI/adaptive-orchestrator.md (AAO - evidencia, hipótesis)
  - 100-Architecture/behavioral-twin.md (Behavioral Twin - perfil del paciente)
  - 100-Architecture/data-model.md (Modelo de datos - grafos, vectores)
  - 800-Analytics/outcomes-analytics.md (BIP - investigación)
  - 000-Infrastructure/selection.md (Infraestructura - pgvector, Supabase)
exports:
  - Estructura del BKGE (grafos de conocimiento, nodos, aristas, atributos)
  - Integración con RAG (búsqueda semántica, embeddings, pgvector)
  - Behavioral Science Cloud (BSC) (conocimiento agregado, investigación, aprendizaje federado)
  - Flujo de actualización del conocimiento (versionado, trazabilidad)
  - Integración con otros motores (TCCN, AAO, BERL, BIP)
  - Criterios de validación y métricas de éxito
used_by:
  - TCCN (contexto conversacional, psicoeducación)
  - AAO (validación ontológica, generación de hipótesis)
  - BERL (diseño de ejercicios basados en evidencia)
  - BIP (investigación y análisis de resultados)
  - BROS (Behavioral Research OS)
---

# BehavioralOS – Conocimiento Científico (BKGE + BSC)

> *"El conocimiento del BehavioralOS no es un conjunto de documentos. Es un grafo vivo donde cada concepto, cada proceso, cada relación y cada artículo científico está conectado semánticamente. El BKGE es la memoria del sistema; el BSC es su capacidad de aprender de la ciencia y de la práctica clínica."*

---

## 1. Propósito y Alcance

### 1.1. Propósito
Este documento define el **sistema de conocimiento científico** del BehavioralOS, compuesto por:

- **Behavioral Knowledge Graph Engine (BKGE)**: Un grafo semántico que almacena la ontología, los procesos psicológicos, las hipótesis, la evidencia científica y las relaciones entre todos estos conceptos.
- **Behavioral Science Cloud (BSC)**: Una capa de conocimiento agregado que integra datos de múltiples pacientes (anonimizados) para investigación, mejora de modelos y aprendizaje continuo.

El objetivo es:

- **Proveer una base de conocimiento** para el RAG (Retrieval-Augmented Generation) del TCCN.
- **Mantener la trazabilidad científica** de todas las intervenciones y recomendaciones del sistema.
- **Facilitar la investigación** y la mejora continua de los modelos clínicos.
- **Asegurar la consistencia** entre la ciencia del comportamiento y la implementación del sistema.

### 1.2. Alcance
El documento cubre:

- **Estructura del BKGE**: Nodos (procesos, eventos, intervenciones, hipótesis, artículos), aristas (relaciones tipadas), y atributos (confianza, evidencia, versión).
- **Integración con RAG**: Uso de embeddings (sentence-transformers) y pgvector para búsqueda semántica en el grafo.
- **Behavioral Science Cloud (BSC)**: Almacenamiento de datos agregados anonimizados, aprendizaje federado, generación de conocimiento.
- **Flujo de actualización**: Cómo se agrega nuevo conocimiento (desde investigación, desde la práctica clínica) y cómo se versiona.
- **Integración con otros motores**: TCCN (psicoeducación, contexto), AAO (validación ontológica), BERL (ejercicios basados en evidencia), BIP (investigación y análisis).

### 1.3. Principio Fundamental
> **"El conocimiento del BehavioralOS no es estático. Es un organismo vivo que crece y se actualiza con la ciencia, la práctica clínica y los datos de los pacientes (siempre anonimizados y con consentimiento). El BKGE es la memoria del sistema; el BSC es su capacidad de aprender."**

---

## 2. Filosofía del Conocimiento

### 2.1. Principios del Conocimiento

| # | Principio | Descripción | Manifestación |
|---|-----------|-------------|---------------|
| 1 | **Semántico y conectado** | Todo conocimiento está representado como un grafo de nodos y relaciones. | Nodos de procesos, intervenciones, artículos; aristas de "facilita", "inhibe", "apoya", etc. |
| 2 | **Trazable y versionado** | Cada nodo tiene metadatos de origen, fecha, versión y confianza. | Historial de cambios en cada concepto. |
| 3 | **Basado en evidencia** | El conocimiento está respaldado por evidencia científica (o marcado como hipotético). | Niveles de evidencia para cada relación. |
| 4 | **Anonimizado y agregado** | Los datos de pacientes se agregan y anonimizan para investigación. | Datos agregados en el BSC, sin información identificable. |
| 5 | **Accesible para RAG** | El conocimiento está indexado semánticamente para búsqueda por embeddings. | pgvector para embeddings de nodos y textos. |

### 2.2. Estructura del Conocimiento

El conocimiento del BehavioralOS se organiza en **tres capas**:

| Capa | Descripción | Ejemplos |
|------|-------------|----------|
| **Ontología** | Entidades y relaciones fundamentales del comportamiento. | Procesos, eventos, conductas, marcos RFT. |
| **Conocimiento clínico** | Intervenciones, protocolos, estrategias terapéuticas y su evidencia. | ACT, FAP, DBT, ejercicios de defusión. |
| **Conocimiento idiográfico** | Hipótesis, patrones y relaciones específicas del paciente. | Hipótesis funcionales, redes RFT del paciente. |

---

## 3. Behavioral Knowledge Graph Engine (BKGE)

### 3.1. Estructura del Grafo

El BKGE es un grafo dirigido y etiquetado donde:

- **Nodos**: Representan entidades (procesos, eventos, intervenciones, hipótesis, artículos, etc.).
- **Aristas**: Representan relaciones entre nodos (causa, facilita, inhibe, apoya, contradice, etc.).
- **Atributos**: Cada nodo y arista tiene metadatos (confianza, versión, evidencia, fecha de creación, etc.).

### 3.2. Tipos de Nodos (no exhaustivo)

| Tipo | Descripción | Atributos clave |
|------|-------------|-----------------|
| **Process** | Proceso psicológico (ej. Aceptación, Defusión). | `name`, `domain`, `definition`, `indicators`, `confidence` |
| **Event** | Evento psicológico (ej. pensamiento, emoción, conducta). | `type`, `content`, `function`, `intensity` |
| **Intervention** | Intervención terapéutica (ej. ejercicio de defusión, misión). | `name`, `description`, `target_processes`, `evidence_level` |
| **Hypothesis** | Hipótesis funcional. | `description`, `antecedents`, `behavior`, `consequences`, `confidence` |
| **Article** | Artículo científico. | `title`, `authors`, `abstract`, `doi`, `evidence_level`, `publication_date` |
| **RelationalFrame** | Marco relacional (RFT). | `type`, `nodes`, `strength`, `flexibility` |
| **Value** | Valor (ACT). | `name`, `domain`, `behaviors`, `barriers` |
| **Context** | Contexto conductual. | `name`, `features`, `typical_patterns` |

### 3.3. Tipos de Aristas (no exhaustivo)

| Tipo | Descripción | Dirección |
|------|-------------|-----------|
| `causes` | A causa B. | A → B |
| `facilitates` | A facilita B. | A → B |
| `inhibits` | A inhibe B. | A → B |
| `strengthens` | A fortalece B. | A → B |
| `weakens` | A debilita B. | A → B |
| `supported_by` | A está respaldado por B (evidencia). | A → B |
| `contradicted_by` | A es contradicho por B (evidencia). | A → B |
| `generalizes_to` | A se generaliza a B. | A → B |
| `derived_from` | A se deriva de B (RFT). | A → B |
| `part_of` | A es parte de B. | A → B |
| `instance_of` | A es una instancia de B. | A → B |
| `related_to` | A está relacionado con B (genérico). | A ↔ B |

### 3.4. Representación Computacional

El BKGE se almacena en **PostgreSQL con soporte para JSONB** (para almacenar grafos serializados) y **pgvector** (para embeddings de nodos y textos). También se puede usar **NetworkX** para operaciones en memoria y **Neo4j** si el volumen crece significativamente.

#### 3.4.1. Tablas del BKGE (PostgreSQL)

```sql
-- Tabla de grafos (cada paciente tiene su propio grafo, además del grafo global)
CREATE TABLE knowledge_graphs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    type VARCHAR(20) NOT NULL CHECK (type IN ('global', 'patient')),
    patient_id UUID REFERENCES patients(id) ON DELETE CASCADE,
    version VARCHAR(20) DEFAULT '1.0.0',
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Tabla de nodos
CREATE TABLE kg_nodes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    graph_id UUID NOT NULL REFERENCES knowledge_graphs(id) ON DELETE CASCADE,
    label VARCHAR(50) NOT NULL,
    attributes JSONB NOT NULL,
    confidence DECIMAL(5,4) DEFAULT 0.8,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Tabla de aristas
CREATE TABLE kg_edges (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    graph_id UUID NOT NULL REFERENCES knowledge_graphs(id) ON DELETE CASCADE,
    source_node_id UUID NOT NULL REFERENCES kg_nodes(id) ON DELETE CASCADE,
    target_node_id UUID NOT NULL REFERENCES kg_nodes(id) ON DELETE CASCADE,
    relation_type VARCHAR(50) NOT NULL,
    attributes JSONB DEFAULT '{}',
    confidence DECIMAL(5,4) DEFAULT 0.8,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Tabla de versionado de grafos
CREATE TABLE kg_versions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    graph_id UUID NOT NULL REFERENCES knowledge_graphs(id) ON DELETE CASCADE,
    version VARCHAR(20) NOT NULL,
    snapshot JSONB NOT NULL,  -- snapshot completo del grafo (serializado)
    created_at TIMESTAMP DEFAULT NOW()
);

-- Tabla de embeddings para RAG (pgvector)
CREATE TABLE kg_embeddings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    node_id UUID REFERENCES kg_nodes(id) ON DELETE CASCADE,
    text_id UUID,  -- ID de un texto asociado (ej. artículo, intervención)
    text_type VARCHAR(50) NOT NULL, -- article, intervention, hypothesis, etc.
    embedding vector(384),  -- o 1536 para modelos más grandes
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP DEFAULT NOW()
);

3.4.2. Índices para Rendimiento
sql
-- Índice para búsqueda de nodos por etiqueta
CREATE INDEX idx_kg_nodes_label ON kg_nodes (label);

-- Índice para búsqueda de aristas por tipo
CREATE INDEX idx_kg_edges_relation_type ON kg_edges (relation_type);

-- Índice para búsqueda por embedding (pgvector)
CREATE INDEX idx_kg_embeddings_embedding ON kg_embeddings USING ivfflat (embedding vector_cosine_ops);

-- Índices para consultas comunes en grafos
CREATE INDEX idx_kg_edges_source ON kg_edges (source_node_id);
CREATE INDEX idx_kg_edges_target ON kg_edges (target_node_id);

3.5. Ejemplo de Grafo
Nodo 1 (Process): "Aceptación"

{
  "id": "n_001",
  "label": "process",
  "attributes": {
    "name": "Aceptación",
    "domain": "Afectivo",
    "definition": "Disposición a experimentar eventos privados sin intentar cambiarlos.",
    "indicators": ["tiempo de permanencia", "frecuencia de evitación"]
  },
  "confidence": 0.90
}


Nodo 2 (Process): "Defusión"

{
  "id": "n_002",
  "label": "process",
  "attributes": {
    "name": "Defusión",
    "domain": "Cognitivo",
    "definition": "Capacidad de observar pensamientos como eventos mentales, no como hechos.",
    "indicators": ["latencia de fusión", "distancia en la relación pensamiento-conducta"]
  },
  "confidence": 0.92
}

Arista: "facilita" (Aceptación → Defusión)

{
  "source": "n_001",
  "target": "n_002",
  "relation_type": "facilitates",
  "attributes": {
    "strength": 0.78,
    "evidence": ["Estudio ACT 2020", "Meta-análisis 2022"]
  },
  "confidence": 0.85
}

4. Retrieval-Augmented Generation (RAG)
4.1. Propósito
El RAG (Retrieval-Augmented Generation) permite al TCCN y a otros motores de IA recuperar conocimiento relevante del BKGE para enriquecer las respuestas, proporcionar psicoeducación y ofrecer información basada en evidencia.

4.2. Flujo de RAG
Consulta del usuario: El TCCN recibe un mensaje del usuario o una solicitud de contexto.

Generación de consulta semántica: El sistema convierte la consulta en un embedding (usando sentence-transformers).

Búsqueda en el BKGE: Se realiza una búsqueda por similitud de coseno en kg_embeddings (pgvector) para recuperar los nodos más relevantes.

Filtrado contextual: Los nodos recuperados se filtran por relevancia (confianza > 0.7) y por el contexto del usuario (ej. solo intervenciones para su edad).

Construcción del contexto: Los nodos recuperados se convierten en texto legible (ej. "Según la evidencia, la Aceptación facilita la Defusión.") y se incorporan al prompt de Gemma.

Generación de respuesta: Gemma genera una respuesta enriquecida con el conocimiento recuperado.

4.3. Ejemplo de RAG
Consulta del usuario: "¿Qué es la defusión?"

Embedding: Generado con sentence-transformers (multilingual-e5-small).

Búsqueda en BKGE: Recupera nodo process con name = "Defusión".

Contexto: "La defusión es la capacidad de observar pensamientos como eventos mentales, no como hechos. Facilita la flexibilidad psicológica."

Respuesta de Gemma (enriquecida): "La defusión es como observar las nubes: ves los pensamientos pasar sin aferrarte a ellos. Te ayuda a tomar distancia de tus pensamientos, viéndolos como eventos mentales, no como hechos. ¿Te gustaría practicar una misión de defusión?"

4.4. Implementación Técnica de RAG

# Ejemplo de búsqueda semántica en BKGE (Python)
import psycopg2
from sentence_transformers import SentenceTransformer

class RAGEngine:
    def __init__(self, db_connection):
        self.conn = db_connection
        self.model = SentenceTransformer('intfloat/multilingual-e5-small')
        self.embedding_dim = 384

    def query(self, user_message, patient_id, top_k=5):
        # Generar embedding de la consulta
        query_embedding = self.model.encode(user_message)

        # Buscar en pgvector
        cursor = self.conn.cursor()
        cursor.execute("""
            SELECT
                n.id,
                n.label,
                n.attributes,
                n.confidence,
                1 - (e.embedding <=> %s::vector) AS similarity
            FROM kg_nodes n
            JOIN kg_embeddings e ON n.id = e.node_id
            WHERE e.embedding IS NOT NULL
              AND n.confidence > 0.7
              AND e.text_type IN ('process', 'intervention', 'article')
            ORDER BY similarity DESC
            LIMIT %s
        """, (query_embedding.tolist(), top_k))

        results = cursor.fetchall()
        return results

5. Behavioral Science Cloud (BSC)
5.1. Propósito
El Behavioral Science Cloud (BSC) es la capa de conocimiento agregado del BehavioralOS. Su función es:

Agregar datos anonimizados de múltiples pacientes para investigación y mejora de modelos.

Validar y actualizar el conocimiento del BKGE basado en la evidencia acumulada.

Facilitar la investigación (BROS) y el aprendizaje federado.

Proveer un repositorio centralizado de conocimiento científico (artículos, metaanálisis, protocolos) que pueda ser consultado por el RAG y los investigadores.

5.2. Arquitectura del BSC

┌─────────────────────────────────────────────────────────────────────────┐
│                    Behavioral Science Cloud (BSC)                      │
├─────────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │  Data Aggregation Layer                                         │   │
│  │  • Anonimización de datos de pacientes                        │   │
│  │  • Agregación por procesos, intervenciones, resultados         │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                         │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │  Knowledge Validation Layer                                     │   │
│  │  • Comparación de hipótesis con evidencia acumulada           │   │
│  │  • Actualización de confianzas en el BKGE                     │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                         │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │  Research Layer (BROS)                                          │   │
│  │  • Experimentos controlados                                     │   │
│  │  • Simulaciones con Behavioral Twin sintéticos               │   │
│  │  • Publicación de hallazgos                                     │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                         │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │  Knowledge Repository                                            │   │
│  │  • Artículos científicos (PDF, resúmenes)                    │   │
│  │  • Metaanálisis, RCT, estudios observacionales                  │   │
│  │  • Protocolos clínicos y guías                                │   │
│  └─────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────┘

5.3. Flujo de Actualización del Conocimiento
Recolección de datos: Los datos de pacientes (anonimizados) se agregan al BSC desde el Behavioral Twin (con consentimiento).

Validación: El sistema compara las hipótesis del BKGE con la evidencia acumulada de los pacientes. Si una hipótesis es apoyada por múltiples casos, su confianza aumenta. Si es contradicha, su confianza disminuye.

Actualización del BKGE: Las nuevas confianzas y relaciones se actualizan en el BKGE global (después de revisión humana, si es necesario).

Investigación: Los investigadores pueden realizar análisis, experimentos y simulaciones sobre los datos agregados.

Publicación: Los hallazgos se publican (en el BSC) y se integran de nuevo al BKGE.

5.4. Aprendizaje Federado
El BSC utiliza un enfoque de aprendizaje federado para entrenar modelos (ej. predictores de riesgo) sin centralizar los datos sensibles:

Los modelos se entrenan localmente en los dispositivos (o en servidores de los centros clínicos).

Los pesos del modelo (no los datos) se comparten y se agregan en el BSC.

El modelo global se actualiza y se distribuye a los dispositivos.

6. Integración con Motores del Ecosistema
6.1. TCCN (Compañero)
Uso: El TCCN consulta el BKGE (vía RAG) para obtener psicoeducación, definiciones de procesos, y ejemplos de intervenciones.

Actualización: El TCCN no actualiza directamente el BKGE; solo lo consulta.

6.2. AAO (Evaluación Adaptativa)
Uso: El AAO consulta el BKGE para validar que las hipótesis generadas estén alineadas con la ontología y la evidencia científica.

Actualización: El AAO puede actualizar el BKGE idiográfico (el grafo del paciente) con nuevas hipótesis, patrones y relaciones detectadas.

6.3. BERL (Ejercicios)
Uso: El BERL consulta el BKGE para diseñar ejercicios basados en la evidencia (ej. qué procesos se entrenan mejor con qué mecánicas).

Actualización: El BERL no actualiza el BKGE; solo lo consulta.

6.4. BIP (Investigación y Análisis)
Uso: El BIP consulta el BSC para obtener datos agregados y realizar análisis de efectividad de intervenciones.

Actualización: El BIP alimenta el BSC con los resultados de los análisis, que pueden usarse para actualizar el BKGE.

6.5. BROS (Behavioral Research OS)
Uso: El BROS utiliza el BSC como repositorio de datos anonimizados y conocimiento científico para investigación.

Actualización: El BROS puede proponer nuevas relaciones o actualizaciones al BKGE (previa revisión humana).

7. Versionado y Trazabilidad
7.1. Versionado del Conocimiento
Cada nodo y arista tiene un campo version y un historial de cambios.

Los cambios mayores (ej. nueva relación, cambio de definición) requieren una nueva versión y revisión humana.

Los cambios menores (ej. actualización de confianza por nueva evidencia) pueden ser automáticos.

7.2. Trazabilidad
Cada nodo registra su origen (ej. "Ontología", "Artículo científico", "Datos de paciente anonimizados", "Hipótesis del AAO").

Cada arista registra la evidencia que la respalda (ej. "Meta-análisis 2022", "Estudio de caso", "Datos agregados de 500 pacientes").

Trazabilidad completa: Un terapeuta puede preguntar "¿Por qué el sistema recomienda esta intervención?" y el sistema rastrea la evidencia desde el BKGE hasta los artículos científicos o los datos agregados.

8. Criterios de Validación y Cumplimiento
Criterio	Métrica	Herramienta
Integridad del conocimiento	100% de los procesos de la ontología están representados en el BKGE.	Validación automática
Precisión de RAG	≥ 80% de las consultas de RAG recuperan información relevante (según terapeuta).	Revisión humana
Trazabilidad	100% de los nodos tienen metadatos de origen y versión.	Validación automática
Actualización del BSC	Los datos agregados se actualizan diariamente (por lotes).	Monitoreo
Privacidad	0% de datos identificables en el BSC.	Auditoría de anonimización
Tiempo de consulta	< 100 ms para consultas de RAG (con pgvector).	Monitoreo de rendimiento
9. El Manifiesto del Conocimiento
"El conocimiento del BehavioralOS no es un conjunto de documentos estáticos. Es un grafo vivo que crece y se actualiza con la ciencia, la práctica clínica y los datos de los pacientes.

El BKGE es la memoria del sistema. El BSC es su capacidad de aprender.

No almacenamos conocimiento para acumularlo. Lo almacenamos para aplicarlo. Cada concepto, cada relación, cada artículo científico es una herramienta para ayudar a los pacientes.

El conocimiento es poder. Pero el conocimiento sin aplicación es inútil. El BKGE y el BSC existen para que la IA del BehavioralOS sea más precisa, más ética y más útil."

10. Historial de Cambios
Versión	Fecha	Autor	Cambios
1.0.0	2026-07-01	Arquitectura de IA	Creación del documento. Definición de BKGE (estructura, nodos, aristas), integración con RAG (embeddings, pgvector), Behavioral Science Cloud (BSC), flujo de actualización del conocimiento, versionado y trazabilidad.
Fin del documento rag-knowledge-graph.md

