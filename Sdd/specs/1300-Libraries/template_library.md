# ============================================================
# TEMPLATE_LIBRARY.yaml
# Plantilla para generar el resto de bibliotecas de BehavioralOS
# con la misma calidad y estructura que BCL.
# ============================================================

version: "1.0.0"
description: "Instrucciones paso a paso para que la IA genere cada biblioteca siguiendo el estándar de BCL."

# ---------- REFERENCIAS OBLIGATORIAS ----------
references:
  - "strict_spec_schema.yaml"  # Reglas globales de calidad
  - "BCL_COMPLETE_IMPLEMENTATION.md"  # Ejemplo canónico de implementación

# ---------- PLANTILLA PASO A PASO ----------
template_steps:
  - step: 1
    name: "Preparar estructura de carpetas"
    action: |
      Crear la siguiente estructura para la biblioteca {library_name}:
      
behavioral-{library_name}/
├── pyproject.toml
├── requirements.txt
├── README.md
├── src/
│ └── behavioral/
│ └── {library_name}/
│ ├── init.py
│ ├── models.py # Modelos Pydantic
│ ├── functions.py # Funciones principales
│ ├── utils.py # Utilidades
│ └── exceptions.py # Excepciones personalizadas
├── tests/
│ ├── init.py
│ ├── conftest.py
│ ├── test_models.py
│ ├── test_functions.py
│ └── test_utils.py
└── docs/
├── conf.py
├── index.rst
└── api.rst


- step: 2
name: "Configurar pyproject.toml"
action: |
Copiar el pyproject.toml de BCL y adaptar:
- name: "behavioral-{library_name}"
- description: "BehavioralOS - {library_description}"
- dependencies: {dependencies_list}
- Mantener las mismas herramientas de desarrollo (pytest, mypy, black, isort).

- step: 3
name: "Definir requirements.txt"
action: |
Listar todas las dependencias con versiones exactas.
Incluir las dependencias de desarrollo en un grupo opcional.

- step: 4
name: "Implementar models.py"
action: |
Basado en las especificaciones de behavioral_sdd_complete.md:
1. Definir todas las clases de datos con Pydantic.
2. Usar Field con ge, le, min_length, max_length.
3. Añadir validadores personalizados con @validator o @root_validator.
4. Usar ConfigDict(frozen=True) para inmutabilidad y extra='forbid'.
5. Incluir métodos to_dict() y from_dict() para serialización.
6. Referencia: BCL_COMPLETE_IMPLEMENTATION.md -> models.py

- step: 5
name: "Implementar functions.py"
action: |
Basado en las especificaciones de behavioral_sdd_complete.md:
1. Definir todas las funciones públicas con type hints.
2. Incluir docstrings en formato Google.
3. Usar structlog para logging.
4. Validar entradas con if/raise o usando Pydantic.
5. Referencia: BCL_COMPLETE_IMPLEMENTATION.md -> functions.py

- step: 6
name: "Implementar utils.py"
action: |
Incluir utilidades específicas de la biblioteca:
1. Funciones de serialización (to_dict, from_dict, to_json, from_json).
2. Funciones de hashing y comparación.
3. Decoradores de logging (log_entrada_salida).
4. Referencia: BCL_COMPLETE_IMPLEMENTATION.md -> utils.py

- step: 7
name: "Implementar exceptions.py"
action: |
Definir jerarquía de excepciones:
- {LibraryName}Error (base)
- ValidationError
- NotFoundError
- ConflictError
Referencia: BCL_COMPLETE_IMPLEMENTATION.md -> exceptions.py

- step: 8
name: "Implementar __init__.py"
action: |
Exportar todas las clases, funciones y excepciones públicas.
Incluir docstring con la descripción de la biblioteca.

- step: 9
name: "Escribir tests"
action: |
Para cada función pública y clase, escribir:
1. Happy path: caso normal con entrada válida.
2. Edge case: valores límite (máximos, mínimos, None, listas vacías).
3. Error case: excepciones esperadas (ValueError, TypeError, ValidationError).
Usar pytest.mark.parametrize para múltiples casos.
Asegurar 100% de cobertura.
Referencia: BCL_COMPLETE_IMPLEMENTATION.md -> tests/

- step: 10
name: "Escribir conftest.py"
action: |
Definir fixtures reutilizables para:
- Datos de prueba (pacientes, sesiones, contextos).
- Objetos base (BehaviourUnit, ContextVector, etc.) si son necesarios.

- step: 11
name: "Documentar con README.md"
action: |
Incluir:
- Descripción de la biblioteca.
- Instalación: pip install behavioral-{library_name}
- Ejemplo de uso básico.
- Enlace a documentación completa.

- step: 12
name: "Verificar calidad"
action: |
Ejecutar los siguientes comandos y asegurar que pasan sin errores:
- mypy --strict src/ tests/
- pytest --cov --cov-fail-under=100
- black --check src/ tests/
- isort --check-only src/ tests/
- flake8 src/ tests/ --max-line-length=100

# ---------- CHECKLIST DE VALIDACIÓN ----------
validation_checklist:
- "¿Todas las clases heredan de BaseModel o usan @dataclass(frozen=True)?"
- "¿Todas las propiedades tienen Field con ge/le/min_length/max_length?"
- "¿Todas las funciones tienen type hints completos?"
- "¿Todas las funciones tienen docstring en formato Google?"
- "¿Todas las funciones usan structlog para logging?"
- "¿Todas las validaciones lanzan excepciones específicas (ValueError, TypeError, ValidationError)?"
- "¿El archivo __init__.py exporta todos los símbolos públicos?"
- "¿Hay al menos 3 tests por función (happy path, edge case, error case)?"
- "¿La cobertura de pruebas es 100%?"
- "¿El código pasa mypy --strict sin errores?"
- "¿El código pasa black, isort y flake8 sin errores?"
- "¿README.md incluye instalación y ejemplo de uso?"

# ---------- EJEMPLO DE ADAPTACIÓN PARA CLINICAL_LIB.ACT ----------
example_adaptation:
library_name: "clinical_lib.act"
description: "Terapia de Aceptación y Compromiso (ACT)"
dependencies:
- "pandas==2.1.0"
- "numpy==1.24.0"
- "scipy==1.11.0"
models:
- HexaflexProfile: campos acceptance, defusion, present_moment, self_as_context, values, committed_action, overall_flexibility (0.0-1.0)
- InstrumentScore: instrument, total_score, subscales, interpretation, normative_percentile
- ACTExercise: id, type, name, description, steps, target_process, difficulty, duration, metaphor
functions:
- score_aaqii(responses: List[int]) -> InstrumentScore
- score_compact(responses: List[int]) -> InstrumentScore
- score_vlaq(responses: List[Dict]) -> InstrumentScore
- score_cfq(responses: List[int]) -> InstrumentScore
- compute_hexaflex_from_instruments(scores: Dict[str, InstrumentScore]) -> HexaflexProfile
- generate_defusion_exercise(difficulty: float, duration: int, patient_name: str) -> ACTExercise
- generate_acceptance_exercise(difficulty: float, duration: int, patient_name: str) -> ACTExercise
- generate_values_exercise(difficulty: float, patient_name: str) -> ACTExercise
- generate_committed_action_exercise(difficulty: float, patient_name: str) -> ACTExercise
- recommend_interventions(profile: HexaflexProfile, constraints: Dict) -> ACTInterventionRecommendation
utils:
- normalize_score(score: float, min_val: float, max_val: float, invert: bool) -> float
- get_aaqii_percentile(total: int) -> float
- get_compact_percentile(total: float) -> float
tests:
- test_score_aaqii_max()
- test_score_aaqii_min()
- test_score_aaqii_invalid_length()
- test_score_aaqii_invalid_value()
- test_generate_defusion_exercise_low_difficulty()
- test_generate_defusion_exercise_high_difficulty()
- test_recommend_interventions_deficit_defusion()

# ---------- EJEMPLO DE ADAPTACIÓN PARA CORE_ONTOLOGY ----------
example_adaptation_core_ontology:
library_name: "core_ontology"
description: "Gestión de ontología del comportamiento"
dependencies:
- "networkx==3.2"
- "rdflib==7.0.0"
- "json-ld==1.0.0"
models:
- OntologyNode: id, label, display_name, description, category, properties, parents, created_at, version
- OntologyEdge: id, source, target, relation_type, weight, evidence, properties, created_at
- OntologyGraph: id, nodes, edges, version, created_at
- RFTRelation: (hereda de OntologyEdge) frame_type, transformation_function, derived_from
- PBTProcessNode: (hereda de OntologyNode) dimensions, measurement, intervention_targets
functions:
- get_ontology() -> OntologyGraph
- create_base_ontology() -> OntologyGraph
- get_node(graph: OntologyGraph, node_id: str) -> Optional[OntologyNode]
- get_node_by_label(graph: OntologyGraph, label: str) -> Optional[OntologyNode]
- get_parents(graph: OntologyGraph, node_id: str) -> List[OntologyNode]
- get_ancestors(graph: OntologyGraph, node_id: str) -> List[OntologyNode]
- get_descendants(graph: OntologyGraph, node_id: str) -> List[OntologyNode]
- is_subclass_of(graph: OntologyGraph, child_id: str, parent_id: str) -> bool
- find_path(graph: OntologyGraph, source_id: str, target_id: str) -> List[List[str]]
- infer_relation(graph: OntologyGraph, source_id: str, target_id: str) -> Optional[RelationType]
- get_synonyms(graph: OntologyGraph, node_id: str) -> List[OntologyNode]
- get_opposites(graph: OntologyGraph, node_id: str) -> List[OntologyNode]
- validate_instance(node: OntologyNode, instance_data: Dict) -> bool
- check_integrity(graph: OntologyGraph) -> List[str]
- add_node(graph: OntologyGraph, node: OntologyNode) -> None
- remove_node(graph: OntologyGraph, node_id: str, cascade: bool) -> None
- add_edge(graph: OntologyGraph, edge: OntologyEdge) -> None
- remove_edge(graph: OntologyGraph, edge_id: str) -> None
- merge_ontology(graph: OntologyGraph, other: OntologyGraph, strategy: str) -> OntologyGraph
- save_snapshot(graph: OntologyGraph, filepath: str) -> None
- load_snapshot(filepath: str) -> OntologyGraph
- diff(graph1: OntologyGraph, graph2: OntologyGraph) -> OntologyDelta
- apply_delta(graph: OntologyGraph, delta: OntologyDelta) -> None
- to_dict(graph: OntologyGraph) -> Dict
- from_dict(data: Dict) -> OntologyGraph
- to_jsonld(graph: OntologyGraph) -> Dict
- to_owl(graph: OntologyGraph) -> str
tests:
- test_create_base_ontology()
- test_add_node()
- test_add_edge()
- test_inheritance()
- test_find_path()
- test_integrity()
- test_serialization()
- test_diff_snapshots()

# ---------- INSTRUCCIONES PARA LA IA ----------
instructions_for_ai: |
Para cada biblioteca {library_name}:
1. Lee la descripción en behavioral_sdd_complete.md.
2. Sigue los pasos 1-12 de TEMPLATE_LIBRARY.yaml.
3. Usa BCL_COMPLETE_IMPLEMENTATION.md como referencia exacta de estilo y estructura.
4. Asegura que todos los casos de prueba definidos en behavioral_sdd_complete.md estén cubiertos.
5. Valida con el checklist de validación.
6. Entrega el código completo con 100% de cobertura y mypy --strict.
7. Si algo no está claro, detente y pregunta.

# ---------- NOTAS ADICIONALES ----------
notes:
- "Las bibliotecas clínicas (ACT, FAP, DBT) deben depender de core_models y core_ontology."
- "Las bibliotecas de inteligencia (PBT, RFT, EEMM) deben depender de core_models, core_ontology y las bibliotecas clínicas correspondientes."
- "Las bibliotecas de aplicación (Intervention, Cognitive, Measurement) deben depender de las bibliotecas de inteligencia."
- "Todas las bibliotecas deben ser instalables con pip y tener sus propias pruebas."
- "El orden de generación debe ser: Foundation Libraries -> Intelligence Libraries -> Application Libraries."