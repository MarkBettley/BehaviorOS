---
# METADATOS DEL PROYECTO
name: BehavioralOS
version: 3.0.0
description: "Sistema operativo científico para psicología basada en análisis funcional del comportamiento, conductismo contextual y modelos basados en procesos"

# INSTRUCCIONES DE GENERACIÓN PARA LA IA
generation_instructions:
  quality_requirements:
    - "100% type hints (mypy --strict compatible)"
    - "100% test coverage (pytest)"
    - "PEP 8 compliant"
    - "Complete docstrings (Google style)"
    - "Error handling with specific exceptions"
    - "Logging with structlog"
    - "Async/await for I/O operations"
    - "Pydantic v2 for all data models"
  output_format: "Python package with setup.py, requirements.txt, and tests/ folder"
  test_framework: "pytest + hypothesis"

# 72 BIBLIOTECAS ORIGINALES
libraries:
  # ============================================================
  # 🟢 NIVEL I: FOUNDATION LIBRARIES
  # ============================================================

  # ---------- A. Core Libraries ----------
  bcl:
    display_name: "Behavioral Core Library (BCL)"
    description: "Clases base: BehaviourUnit, ContextVector, TemporalPoint, ConsequenceVector, ReinforcementValue, StimulusPattern, BehaviouralHistory, FunctionalRelation, ProcessState, AdaptiveCapacity, ResilienceProfile, BehaviouralGraph, ContextualFrame, ContingencyMatrix, ReinforcementSchedule, BehaviouralID, EntityRef, VersionVector, BehaviouralAnnotation, EvidenceScore, ConfidenceInterval, Timeline"
    dependencies: ["pydantic==2.5.0", "attrs==23.1.0"]
    exports: ["BehaviourUnit", "ContextVector", "TemporalPoint", "ConsequenceVector", "ReinforcementValue", "StimulusPattern", "BehaviouralHistory", "FunctionalRelation", "ProcessState", "AdaptiveCapacity", "ResilienceProfile", "BehaviouralGraph", "ContextualFrame", "ContingencyMatrix", "ReinforcementSchedule", "BehaviouralID", "EntityRef", "VersionVector", "BehaviouralAnnotation", "EvidenceScore", "ConfidenceInterval", "Timeline"]
    test_cases:
      - name: "Creación de BehaviourUnit válida"
        input: |
          {
            "behavior": "evitación de contacto visual",
            "context": {"space": "consultorio", "social": "terapeuta"},
            "intensity": 0.8
          }
        expected_output: "BehaviourUnit con id generado, timestamp actual, intensity=0.8"
      - name: "BehaviourUnit con intensity inválida (>1.0)"
        input: |
          {
            "behavior": "evitación de contacto visual",
            "context": {"space": "consultorio", "social": "terapeuta"},
            "intensity": 1.5
          }
        expected_exception: "ValueError: intensity must be between 0.0 and 1.0"
      - name: "BehaviourUnit con behavior vacío"
        input: |
          {
            "behavior": "",
            "context": {"space": "consultorio", "social": "terapeuta"}
          }
        expected_exception: "ValueError: behavior cannot be empty"

  bdml:
    display_name: "Behavioral Data Model Library (BDML)"
    description: "Modelos de datos para pacientes, terapeutas, sesiones, ejercicios, evaluaciones, hipótesis, valores, objetivos, organismos"
    dependencies: ["pydantic==2.5.0", "attrs==23.1.0"]
    depends_on: ["bcl"]
    exports: ["Patient", "Therapist", "Session", "Exercise", "Assessment", "Hypothesis", "Value", "Goal", "Organism"]
    test_cases:
      - name: "Creación de Patient válido"
        input: |
          {
            "name": "Juan Pérez",
            "age": 35,
            "id": "P123"
          }
        expected_output: "Patient con id='P123', name='Juan Pérez', age=35"
      - name: "Patient con edad negativa"
        input: |
          {
            "name": "Juan Pérez",
            "age": -5,
            "id": "P123"
          }
        expected_exception: "ValueError: age must be >= 0"

  bel:
    display_name: "Behavioral Entity Library (BEL)"
    description: "Entidades base del sistema: BehaviourUnit, ContextVector, Event, State, Process"
    dependencies: ["pydantic==2.5.0"]
    depends_on: ["bcl"]
    exports: ["BehaviourUnit", "ContextVector", "Event", "State", "Process"]
    test_cases:
      - name: "Creación de Event válido"
        input: |
          {
            "name": "Sesión iniciada",
            "timestamp": "2024-01-01T10:00:00"
          }
        expected_output: "Event con name='Sesión iniciada'"

  bol:
    display_name: "Behavioral Ontology Library (BOL)"
    description: "Gestión de ontología del comportamiento: nodos, aristas, relaciones RFT, procesos PBT, herencia múltiple"
    dependencies: ["networkx==3.2", "rdflib==7.0.0", "json-ld==1.0.0"]
    depends_on: ["bcl"]
    exports: ["OntologyNode", "OntologyEdge", "OntologyGraph", "RFTRelation", "PBTProcessNode", "NodeCategory", "RelationType", "FrameType"]
    test_cases:
      - name: "Creación de OntologyNode válido"
        input: |
          {
            "label": "acceptance",
            "display_name": "Aceptación",
            "description": "Abrirse al malestar sin intentar cambiarlo",
            "category": "PROCESS"
          }
        expected_output: "OntologyNode con id generado, label='acceptance', category='PROCESS'"
      - name: "OntologyNode con label inválido (contiene espacio)"
        input: |
          {
            "label": "acceptance process",
            "display_name": "Aceptación",
            "description": "Abrirse al malestar",
            "category": "PROCESS"
          }
        expected_exception: "ValueError: label must be a valid identifier (snake_case)"
      - name: "Agregar arista a OntologyGraph con nodos existentes"
        input: |
          graph.add_node(node1)
          graph.add_node(node2)
          edge = OntologyEdge(source=node1.id, target=node2.id, relation_type="ENHANCES")
        expected_output: "Edge agregado correctamente, len(graph.edges) == 1"

  bcontextl:
    display_name: "Behavioral Context Library (BContextL)"
    description: "Gestión de contextos conductuales: ContextVector, ContextualFrame, análisis de contexto, similitud de contextos"
    dependencies: ["numpy==1.24.0", "scipy==1.11.0"]
    depends_on: ["bcl"]
    exports: ["ContextVector", "ContextualFrame", "context_similarity", "normalize_context"]
    test_cases:
      - name: "context_similarity - dos contextos idénticos"
        input: |
          c1 = ContextVector(space="casa", social="familia")
          c2 = ContextVector(space="casa", social="familia")
        expected_output: "similarity == 1.0"
      - name: "context_similarity - contextos diferentes"
        input: |
          c1 = ContextVector(space="casa", social="familia")
          c2 = ContextVector(space="trabajo", social="jefe")
        expected_output: "similarity < 0.5"

  belib:
    display_name: "Behavioral Event Library (BELib)"
    description: "Gestión de eventos conductuales: Event, secuencia de eventos, análisis de patrones temporales"
    dependencies: ["pandas==2.1.0"]
    depends_on: ["bcl"]
    exports: ["Event", "EventSequence", "analyze_event_patterns"]
    test_cases:
      - name: "EventSequence - orden cronológico"
        input: |
          events = [Event(timestamp=t1), Event(timestamp=t2)]  # t1 < t2
        expected_output: "sequence.events[0].timestamp < sequence.events[1].timestamp"
      - name: "analyze_event_patterns - detección de ciclos"
        input: "events = ['A','B','A','B']"
        expected_output: "patrones detectados: ['A->B']"

  bsl:
    display_name: "Behavioral State Library (BSL)"
    description: "Gestión de estados conductuales: State, transiciones de estado, máquinas de estados"
    dependencies: ["networkx==3.2"]
    depends_on: ["bcl"]
    exports: ["State", "StateMachine", "StateTransition"]
    test_cases:
      - name: "StateMachine - transición válida"
        input: |
          sm = StateMachine()
          sm.add_state("inicial")
          sm.add_state("final")
          sm.add_transition("inicial", "final")
          sm.transition("final")
        expected_output: "sm.current_state == 'final'"
      - name: "StateMachine - transición inválida"
        input: |
          sm = StateMachine()
          sm.add_state("inicial")
          sm.transition("final")
        expected_exception: "ValueError: Transition from inicial to final not allowed"

  bpl:
    display_name: "Behavioral Process Library (BPL)"
    description: "Modelado de procesos psicológicos: PsychologicalProcess, ProcessGraph, Learning Graph, trayectorias de procesos"
    dependencies: ["networkx==3.2", "statsmodels==0.14.0", "pgmpy==0.1.23"]
    depends_on: ["bcl", "bol"]
    exports: ["PsychologicalProcess", "ProcessGraph", "ProcessTrajectory", "build_process_graph", "simulate_dynamics", "forecast_process"]
    test_cases:
      - name: "Creación de PsychologicalProcess válido"
        input: 'PsychologicalProcess(name="acceptance", current_value=0.6)'
        expected_output: "process.id is not None, process.current_value == 0.6"
      - name: "PsychologicalProcess con valor inválido"
        input: 'PsychologicalProcess(name="acceptance", current_value=1.5)'
        expected_exception: "ValueError: current_value must be between 0.0 and 1.0"

  btl:
    display_name: "Behavioral Time Library (BTL)"
    description: "Gestión del tiempo conductual: TemporalPoint, Timeline, agregación temporal, ventanas de tiempo"
    dependencies: ["datetime", "pandas==2.1.0"]
    depends_on: ["bcl"]
    exports: ["TemporalPoint", "Timeline", "time_window", "temporal_distance"]
    test_cases:
      - name: "temporal_distance - misma fase"
        input: |
          t1 = TemporalPoint(timestamp=dt1, phase="baseline")
          t2 = TemporalPoint(timestamp=dt2, phase="baseline")
        expected_output: "distance == 0.0"
      - name: "temporal_distance - fases diferentes"
        input: |
          t1 = TemporalPoint(timestamp=dt1, phase="baseline")
          t2 = TemporalPoint(timestamp=dt2, phase="intervention")
        expected_output: "distance > 0.0"

  # ---------- B. Mathematical Libraries ----------
  bslib:
    display_name: "Behavioral Statistics Library (BSLib)"
    description: "Estadística descriptiva e inferencial para datos conductuales"
    dependencies: ["scipy==1.11.0", "numpy==1.24.0", "statsmodels==0.14.0"]
    depends_on: ["bcl"]
    exports: ["describe", "correlation", "t_test", "anova", "regression"]
    test_cases:
      - name: "describe - media correcta"
        input: "[1, 2, 3, 4, 5]"
        expected_output: "mean == 3.0"
      - name: "correlation - perfecta"
        input: "[1, 2, 3], [2, 4, 6]"
        expected_output: "correlation == 1.0"

  bbl:
    display_name: "Behavioral Bayesian Library (BBL)"
    description: "Inferencia bayesiana para modelos conductuales"
    dependencies: ["pymc==5.10.0", "arviz==0.17.0"]
    depends_on: ["bcl"]
    exports: ["BayesianModel", "update_beliefs", "posterior_predictive"]
    test_cases:
      - name: "update_beliefs - actualización correcta"
        input: |
          prior = {"p": 0.5}
          likelihood = 0.7
          posterior = update_beliefs(prior, likelihood)
        expected_output: "posterior['p'] > 0.5"

  bprobl:
    display_name: "Behavioral Probability Library (BProbL)"
    description: "Distribuciones de probabilidad para conducta"
    dependencies: ["scipy==1.11.0"]
    depends_on: ["bcl"]
    exports: ["Distribution", "prob", "log_prob", "sample"]
    test_cases:
      - name: "prob - distribución normal"
        input: "Normal(0,1).prob(0)"
        expected_output: "≈ 0.3989"

  boptl:
    display_name: "Behavioral Optimization Library (BOptL)"
    description: "Optimización de intervenciones y parámetros"
    dependencies: ["scipy==1.11.0", "numpy==1.24.0"]
    depends_on: ["bcl"]
    exports: ["optimize", "gradient_descent", "genetic_algorithm"]
    test_cases:
      - name: "optimize - función cuadrática"
        input: "f(x) = x**2"
        expected_output: "x_opt ≈ 0"

  bnml:
    display_name: "Behavioral Numerical Methods Library (BNML)"
    description: "Métodos numéricos para ecuaciones conductuales"
    dependencies: ["scipy==1.11.0", "numpy==1.24.0"]
    depends_on: ["bcl"]
    exports: ["integrate", "differentiate", "solve_ode"]
    test_cases:
      - name: "integrate - integral de x^2"
        input: "f(x)=x**2, a=0, b=1"
        expected_output: "≈ 0.3333"

  btslib:
    display_name: "Behavioral Time Series Library (BTSLib)"
    description: "Análisis de series temporales conductuales"
    dependencies: ["statsmodels==0.14.0", "pandas==2.1.0"]
    depends_on: ["bcl"]
    exports: ["ARIMA", "VAR", "smooth", "decompose"]
    test_cases:
      - name: "smooth - media móvil"
        input: "[1, 2, 3, 4, 5], window=3"
        expected_output: "[2.0, 3.0, 4.0]"

  bsigl:
    display_name: "Behavioral Signal Processing Library (BSigL)"
    description: "Procesamiento de señales conductuales (frecuencia cardíaca, movimiento, etc.)"
    dependencies: ["scipy==1.11.0", "numpy==1.24.0"]
    depends_on: ["bcl"]
    exports: ["filter", "fft", "wavelet_transform"]
    test_cases:
      - name: "filter - pasa bajos"
        input: "señal con ruido"
        expected_output: "señal filtrada con ruido reducido"

  bdsl:
    display_name: "Behavioral Dynamical Systems Library (BDSL)"
    description: "Sistemas dinámicos aplicados a conducta"
    dependencies: ["scipy==1.11.0", "numpy==1.24.0"]
    depends_on: ["bcl"]
    exports: ["DynamicalSystem", "stability_analysis", "phase_portrait"]
    test_cases:
      - name: "stability_analysis - punto fijo estable"
        input: "dx/dt = -x"
        expected_output: "stable == True"

  # ---------- C. Graph Libraries ----------
  bgraphl:
    display_name: "Behavioral Graph Library (BGraphL)"
    description: "Grafos conductuales base"
    dependencies: ["networkx==3.2"]
    depends_on: ["bcl"]
    exports: ["BehaviouralGraph", "add_node", "add_edge", "remove_node"]
    test_cases:
      - name: "add_node - nodo agregado"
        input: "graph.add_node('A')"
        expected_output: "'A' in graph.nodes"

  bkgl:
    display_name: "Behavioral Knowledge Graph Library (BKGL)"
    description: "Grafo de conocimiento conductual"
    dependencies: ["networkx==3.2", "neo4j==5.15.0"]
    depends_on: ["bcl", "bol"]
    exports: ["KnowledgeGraph", "add_triple", "query", "reason"]
    test_cases:
      - name: "add_triple - triple agregado"
        input: "kg.add_triple('A', 'causa', 'B')"
        expected_output: "kg.has_triple('A', 'causa', 'B') == True"

  bcgl:
    display_name: "Behavioral Context Graph Library (BCGL)"
    description: "Grafo de contexto conductual"
    dependencies: ["networkx==3.2"]
    depends_on: ["bcl", "bcontextl"]
    exports: ["ContextGraph", "context_similarity", "context_clustering"]
    test_cases:
      - name: "context_similarity - similitud > 0.8"
        input: "dos contextos similares"
        expected_output: "similarity > 0.8"

  bgal:
    display_name: "Behavioral Graph Algorithms Library (BGAL)"
    description: "Algoritmos de grafos para conducta: búsqueda, caminos, centralidad, clustering"
    dependencies: ["networkx==3.2"]
    depends_on: ["bgraphl"]
    exports: ["bfs", "dfs", "shortest_path", "centrality", "community_detection"]
    test_cases:
      - name: "shortest_path - camino más corto"
        input: "grafo A->B, B->C"
        expected_output: "shortest_path(A,C) == ['A','B','C']"

  bnal:
    display_name: "Behavioral Network Analysis Library (BNAL)"
    description: "Análisis de redes conductuales"
    dependencies: ["networkx==3.2", "numpy==1.24.0"]
    depends_on: ["bgraphl"]
    exports: ["network_density", "degree_distribution", "small_world_index"]
    test_cases:
      - name: "network_density - grafo completo"
        input: "grafo con 3 nodos, todas las aristas"
        expected_output: "density == 1.0"

  bcausall:
    display_name: "Behavioral Causal Graph Library (BCausalGL)"
    description: "Grafos causales conductuales"
    dependencies: ["networkx==3.2", "pgmpy==0.1.23"]
    depends_on: ["bgraphl"]
    exports: ["CausalGraph", "do_calculus", "counterfactual"]
    test_cases:
      - name: "do_calculus - efecto causal"
        input: "A->B, A->C, B->C"
        expected_output: "efecto de A sobre C == 0.6"

  # ---------- D. Modeling Libraries ----------
  bfml:
    display_name: "Behavioral Functional Modeling Library (BFML)"
    description: "Modelado funcional de conducta: funciones, composición, transformación"
    dependencies: ["numpy==1.24.0"]
    depends_on: ["bcl"]
    exports: ["Function", "compose", "transform", "evaluate"]
    test_cases:
      - name: "compose - composición correcta"
        input: "f(x)=2x, g(x)=x+1"
        expected_output: "compose(f,g)(3) == 8"

  beml:
    display_name: "Behavioral Ecological Modeling Library (BEML)"
    description: "Modelado ecológico de conducta: nicho, adaptación, selección natural"
    dependencies: ["numpy==1.24.0", "scipy==1.11.0"]
    depends_on: ["bcl"]
    exports: ["EcologicalNiche", "adaptation", "selection", "fitness"]
    test_cases:
      - name: "fitness - cálculo correcto"
        input: "organismo en su nicho"
        expected_output: "fitness > 0.5"

  bsysml:
    display_name: "Behavioral Systems Modeling Library (BSysML)"
    description: "Modelado de sistemas conductuales complejos"
    dependencies: ["networkx==3.2", "numpy==1.24.0"]
    depends_on: ["bcl", "bdsl"]
    exports: ["System", "SystemComponent", "SystemInteraction"]
    test_cases:
      - name: "System - simulación estable"
        input: "sistema con retroalimentación negativa"
        expected_output: "simulación converge"

  bhml:
    display_name: "Behavioral Hierarchical Modeling Library (BHML)"
    description: "Modelado jerárquico de conducta"
    dependencies: ["numpy==1.24.0", "pymc==5.10.0"]
    depends_on: ["bcl"]
    exports: ["HierarchicalModel", "multilevel_analysis"]
    test_cases:
      - name: "multilevel_analysis - niveles anidados"
        input: "datos de pacientes y sesiones"
        expected_output: "modelo converge"

  bcml:
    display_name: "Behavioral Contextual Modeling Library (BCML)"
    description: "Modelado contextual de conducta"
    dependencies: ["numpy==1.24.0"]
    depends_on: ["bcl", "bcontextl"]
    exports: ["ContextualModel", "contextual_behavior", "context_switching"]
    test_cases:
      - name: "contextual_behavior - cambio de contexto"
        input: "contexto A -> contexto B"
        expected_output: "conducta cambia"

  blsl:
    display_name: "Behavioral Latent Structure Library (BLSL)"
    description: "Estructuras latentes en conducta: factores, clusters, dimensiones ocultas"
    dependencies: ["scikit-learn==1.3.0", "numpy==1.24.0"]
    depends_on: ["bcl"]
    exports: ["LatentStructure", "factor_analysis", "cluster_analysis"]
    test_cases:
      - name: "factor_analysis - número de factores"
        input: "datos de 10 variables"
        expected_output: "n_factors == 3"

  # ---------- E. Infrastructure Libraries ----------
  bapil:
    display_name: "Behavioral API Library (BAPIL)"
    description: "Gestión de APIs para Behavioral"
    dependencies: ["fastapi==0.104.0", "pydantic==2.5.0"]
    depends_on: ["bcl"]
    exports: ["APIManager", "Endpoint", "Router", "Middleware"]
    test_cases:
      - name: "APIManager - registro de endpoint"
        input: "endpoint('/health')"
        expected_output: "endpoint registrado"

  bsrl:
    display_name: "Behavioral Serialization Library (BSRL)"
    description: "Serialización de datos conductuales: JSON, Protobuf, XML, YAML"
    dependencies: ["json", "protobuf==4.25.0", "pyyaml==6.0.1"]
    depends_on: ["bcl"]
    exports: ["serialize", "deserialize", "to_dict", "from_dict"]
    test_cases:
      - name: "serialize/deserialize - roundtrip"
        input: "objeto serializable"
        expected_output: "deserialize(serialize(obj)) == obj"

  bconfl:
    display_name: "Behavioral Configuration Library (BConfL)"
    description: "Gestión de configuración para Behavioral"
    dependencies: ["pydantic==2.5.0", "pyyaml==6.0.1"]
    depends_on: ["bcl"]
    exports: ["Config", "load_config", "save_config", "validate_config"]
    test_cases:
      - name: "load_config - carga correcta"
        input: "archivo config.yaml"
        expected_output: "Config con valores cargados"

  # ============================================================
  # 🔵 NIVEL II: INTELLIGENCE LIBRARIES
  # ============================================================

  # ---------- A. Learning Libraries ----------
  brll:
    display_name: "Behavioral Reinforcement Learning Library"
    description: "Aprendizaje por refuerzo aplicado a conducta"
    dependencies: ["gymnasium==0.29.0", "torch==2.1.0"]
    depends_on: ["bcl", "bpl"]
    exports: ["RLAgent", "QTable", "PolicyGradient", "reward", "episode"]
    test_cases:
      - name: "RLAgent - entrenamiento"
        input: "agente en entorno simple"
        expected_output: "recompensa promedio > 0"

  blhl:
    display_name: "Behavioral Learning History Library"
    description: "Gestión del historial de aprendizaje"
    dependencies: ["pandas==2.1.0"]
    depends_on: ["bcl"]
    exports: ["LearningHistory", "add_event", "query_history", "analyze_learning"]
    test_cases:
      - name: "LearningHistory - agregar evento"
        input: "history.add_event('aprendizaje', {'outcome': 'éxito'})"
        expected_output: "len(history.events) == 1"

  bcl:
    display_name: "Behavioral Contingency Library"
    description: "Análisis de contingencias conductuales: tres términos (A-B-C), programa de reforzamiento"
    dependencies: ["pandas==2.1.0"]
    depends_on: ["bcl", "bpl"]
    exports: ["Contingency", "ContingencyAnalysis", "schedule"]
    test_cases:
      - name: "ContingencyAnalysis - detección"
        input: "secuencia A->B->C"
        expected_output: "contingencia detectada"

  brsl:
    display_name: "Behavioral Reinforcement Schedule Library"
    description: "Programas de reforzamiento: CRF, FR, VR, FI, VI, análisis de respuesta"
    dependencies: ["numpy==1.24.0"]
    depends_on: ["bcl"]
    exports: ["ReinforcementSchedule", "CRF", "FR", "VR", "FI", "VI", "simulate_response"]
    test_cases:
      - name: "FR - respuesta acumulada"
        input: "FR=5, 10 ensayos"
        expected_output: "respuestas acumuladas == 50"

  bgl:
    display_name: "Behavioral Generalization Library"
    description: "Generalización de conductas: estímulos, contextos, respuestas"
    dependencies: ["numpy==1.24.0"]
    depends_on: ["bcl"]
    exports: ["Generalization", "generalization_gradient", "stimulus_control"]
    test_cases:
      - name: "generalization_gradient - gradiente"
        input: "estímulo original y 5 variantes"
        expected_output: "respuesta disminuye con distancia"

  bshl:
    display_name: "Behavioral Shaping Library"
    description: "Moldeamiento de conductas: aproximaciones sucesivas"
    dependencies: ["numpy==1.24.0"]
    depends_on: ["bcl"]
    exports: ["Shaping", "successive_approximations", "reinforce_step"]
    test_cases:
      - name: "Shaping - progreso"
        input: "objetivo final, pasos intermedios"
        expected_output: "conducta se aproxima al objetivo"

  bel:
    display_name: "Behavioral Extinction Library"
    description: "Extinción de conductas: decremento de respuesta, recuperación espontánea"
    dependencies: ["numpy==1.24.0"]
    depends_on: ["bcl"]
    exports: ["Extinction", "extinction_curve", "spontaneous_recovery"]
    test_cases:
      - name: "extinction_curve - decremento"
        input: "conducta previamente reforzada"
        expected_output: "tasa de respuesta disminuye"

  # ---------- B. Simulation Libraries ----------
  bsiml:
    display_name: "Behavioral Simulation Library"
    description: "Simulación de conducta: agentes, entornos, interacciones"
    dependencies: ["simpy==4.1.1", "numpy==1.24.0"]
    depends_on: ["bcl", "bpl"]
    exports: ["Simulation", "Agent", "Environment", "Event", "run"]
    test_cases:
      - name: "Simulation - ejecución"
        input: "agentes en entorno"
        expected_output: "simulación completa"

  bscenl:
    display_name: "Behavioral Scenario Library"
    description: "Gestión de escenarios conductuales"
    dependencies: ["json"]
    depends_on: ["bcl"]
    exports: ["Scenario", "ScenarioManager", "load", "save"]
    test_cases:
      - name: "ScenarioManager - carga de escenario"
        input: "archivo scenario.json"
        expected_output: "Scenario cargado"

  bisl:
    display_name: "Behavioral Intervention Simulation Library"
    description: "Simulación de intervenciones conductuales"
    dependencies: ["simpy==4.1.1"]
    depends_on: ["bcl", "bsiml"]
    exports: ["InterventionSimulation", "intervention_effect", "simulate_outcome"]
    test_cases:
      - name: "InterventionSimulation - efectividad"
        input: "intervención en simulación"
        expected_output: "outcome mejora"

  bfsl:
    display_name: "Behavioral Forecast Simulation Library"
    description: "Simulación de pronósticos conductuales"
    dependencies: ["numpy==1.24.0"]
    depends_on: ["bcl", "btslib"]
    exports: ["ForecastSimulation", "predict", "confidence_interval"]
    test_cases:
      - name: "ForecastSimulation - precisión"
        input: "datos históricos"
        expected_output: "predicción con IC"

  bcfl:
    display_name: "Behavioral Counterfactual Library"
    description: "Análisis contrafactual de conducta"
    dependencies: ["numpy==1.24.0"]
    depends_on: ["bcl", "bcausall"]
    exports: ["Counterfactual", "what_if", "alternative_outcome"]
    test_cases:
      - name: "Counterfactual - hipótesis"
        input: "escenario real vs alternativo"
        expected_output: "diferencia calculada"

  # ---------- C. Prediction Libraries ----------
  bfl:
    display_name: "Behavioral Forecast Library"
    description: "Pronóstico de conducta"
    dependencies: ["statsmodels==0.14.0"]
    depends_on: ["bcl", "btslib"]
    exports: ["Forecast", "predict", "accuracy"]
    test_cases:
      - name: "Forecast - precisión"
        input: "datos de entrenamiento y test"
        expected_output: "accuracy > 0.8"

  brpl:
    display_name: "Behavioral Risk Prediction Library"
    description: "Predicción de riesgos conductuales"
    dependencies: ["scikit-learn==1.3.0"]
    depends_on: ["bcl"]
    exports: ["RiskPrediction", "risk_score", "threshold"]
    test_cases:
      - name: "RiskPrediction - clasificación"
        input: "datos de riesgo"
        expected_output: "ROC_AUC > 0.8"

  btl:
    display_name: "Behavioral Trajectory Library"
    description: "Análisis de trayectorias conductuales"
    dependencies: ["pandas==2.1.0"]
    depends_on: ["bcl", "btslib"]
    exports: ["Trajectory", "trajectory_analysis", "change_point_detection"]
    test_cases:
      - name: "Trajectory - detección de cambio"
        input: "trayectoria con cambio"
        expected_output: "change_point detectado"

  btrnl:
    display_name: "Behavioral Transition Library"
    description: "Análisis de transiciones conductuales: Markov, matrices de transición"
    dependencies: ["numpy==1.24.0"]
    depends_on: ["bcl"]
    exports: ["Transition", "MarkovMatrix", "transition_probability"]
    test_cases:
      - name: "MarkovMatrix - probabilidades"
        input: "secuencia de estados"
        expected_output: "matriz de transición"

  bopl:
    display_name: "Behavioral Outcome Prediction Library"
    description: "Predicción de resultados conductuales"
    dependencies: ["scikit-learn==1.3.0"]
    depends_on: ["bcl"]
    exports: ["OutcomePrediction", "predict_outcome", "confidence"]
    test_cases:
      - name: "OutcomePrediction - precisión"
        input: "datos de entrenamiento y test"
        expected_output: "accuracy > 0.8"

  # ---------- D. Explainability Libraries ----------
  bexl:
    display_name: "Behavioral Explainability Library"
    description: "Explicabilidad de decisiones conductuales"
    dependencies: ["shap==0.44.0", "lime==0.2.0.1"]
    depends_on: ["bcl"]
    exports: ["Explainability", "explain", "feature_importance", "counterfactual_explanation"]
    test_cases:
      - name: "Explainability - feature importance"
        input: "modelo y datos"
        expected_output: "feature importance calculado"

  brnl:
    display_name: "Behavioral Reasoning Library"
    description: "Razonamiento conductual: lógica, inferencia, deducción"
    dependencies: ["sympy==1.12"]
    depends_on: ["bcl"]
    exports: ["Reasoning", "infer", "deduce", "prove"]
    test_cases:
      - name: "Reasoning - inferencia"
        input: "premisas: A->B, A"
        expected_output: "conclusión: B"

  bmrl:
    display_name: "Behavioral Meta-Reasoning Library"
    description: "Meta-razonamiento sobre procesos conductuales"
    dependencies: ["networkx==3.2"]
    depends_on: ["bcl", "brnl"]
    exports: ["MetaReasoning", "meta_infer", "reason_about_reasoning"]
    test_cases:
      - name: "MetaReasoning - razonamiento sobre razonamiento"
        input: "proceso de inferencia"
        expected_output: "meta-análisis del proceso"

  bel:
    display_name: "Behavioral Evidence Library"
    description: "Gestión de evidencia conductual: recolección, evaluación, integración"
    dependencies: ["pydantic==2.5.0"]
    depends_on: ["bcl"]
    exports: ["Evidence", "EvidenceManager", "evaluate_evidence", "integrate"]
    test_cases:
      - name: "EvidenceManager - agregar evidencia"
        input: "evidencia con peso 0.8"
        expected_output: "evidencia integrada"

  # ---------- E. Knowledge Libraries ----------
  bckl:
    display_name: "Behavioral Clinical Knowledge Library"
    description: "Conocimiento clínico conductual: guías, protocolos, intervenciones"
    dependencies: ["json"]
    depends_on: ["bcl", "bol"]
    exports: ["ClinicalKnowledge", "Guideline", "Protocol", "Intervention"]
    test_cases:
      - name: "ClinicalKnowledge - buscar guía"
        input: "búsqueda: 'depresión'"
        expected_output: "guía encontrada"

  bskl:
    display_name: "Behavioral Scientific Knowledge Library"
    description: "Conocimiento científico conductual: artículos, teorías, modelos"
    dependencies: ["json", "pandas==2.1.0"]
    depends_on: ["bcl", "bol"]
    exports: ["ScientificKnowledge", "Article", "Theory", "Model"]
    test_cases:
      - name: "ScientificKnowledge - buscar teoría"
        input: "búsqueda: 'ACT'"
        expected_output: "teoría encontrada"

  beil:
    display_name: "Behavioral Evidence Integration Library"
    description: "Integración de evidencia conductual: meta-análisis, síntesis"
    dependencies: ["pandas==2.1.0", "scipy==1.11.0"]
    depends_on: ["bcl", "bel"]
    exports: ["EvidenceIntegration", "meta_analysis", "synthesize"]
    test_cases:
      - name: "EvidenceIntegration - meta-análisis"
        input: "estudios con tamaños de efecto"
        expected_output: "efecto combinado"

  bgl:
    display_name: "Behavioral Guideline Library"
    description: "Guías clínicas conductuales: recomendaciones, algoritmos"
    dependencies: ["json"]
    depends_on: ["bcl", "bckl"]
    exports: ["Guideline", "Recommendation", "Algorithm"]
    test_cases:
      - name: "Guideline - seguir algoritmo"
        input: "paso 1 de algoritmo"
        expected_output: "siguiente paso determinado"

  # ============================================================
  # 🟣 NIVEL III: APPLICATION LIBRARIES
  # ============================================================

  # ---------- A. Intervention Libraries ----------
  bipl:
    display_name: "Behavioral Intervention Planning Library"
    description: "Planificación de intervenciones conductuales"
    dependencies: ["pandas==2.1.0"]
    depends_on: ["bcl", "bpl"]
    exports: ["InterventionPlan", "plan_intervention", "evaluate_plan"]
    test_cases:
      - name: "InterventionPlan - planificación"
        input: "perfil del paciente"
        expected_output: "plan generado"

  bsl:
    display_name: "Behavioral Sequencing Library"
    description: "Secuenciación de intervenciones: orden, dependencias, flujo"
    dependencies: ["networkx==3.2"]
    depends_on: ["bcl", "bipl"]
    exports: ["Sequencing", "order_interventions", "dependency_graph"]
    test_cases:
      - name: "Sequencing - orden correcto"
        input: "intervenciones con dependencias"
        expected_output: "orden respeta dependencias"

  bral:
    display_name: "Behavioral Resource Allocation Library"
    description: "Asignación de recursos para intervenciones: tiempo, personal, materiales"
    dependencies: ["numpy==1.24.0"]
    depends_on: ["bcl", "bipl"]
    exports: ["ResourceAllocation", "allocate", "optimize_resources"]
    test_cases:
      - name: "ResourceAllocation - optimización"
        input: "recursos limitados, múltiples intervenciones"
        expected_output: "asignación óptima"

  bapl:
    display_name: "Behavioral Adaptive Planning Library"
    description: "Planificación adaptativa de intervenciones"
    dependencies: ["numpy==1.24.0"]
    depends_on: ["bcl", "bipl"]
    exports: ["AdaptivePlan", "adapt_plan", "monitor_and_adjust"]
    test_cases:
      - name: "AdaptivePlan - ajuste"
        input: "plan inicial, datos de progreso"
        expected_output: "plan ajustado"

  bml:
    display_name: "Behavioral Monitoring Library"
    description: "Monitoreo de intervenciones: progreso, adherencia, efectividad"
    dependencies: ["pandas==2.1.0"]
    depends_on: ["bcl", "bipl"]
    exports: ["Monitor", "track_progress", "adherence", "effectiveness"]
    test_cases:
      - name: "Monitor - tracking"
        input: "datos de sesiones"
        expected_output: "progreso calculado"

  # ---------- B. Cognitive Libraries ----------
  befl:
    display_name: "Behavioral Executive Functions Library"
    description: "Funciones ejecutivas conductuales"
    dependencies: ["numpy==1.24.0"]
    depends_on: ["bcl", "bneuro"]
    exports: ["ExecutiveFunction", "inhibition", "planning", "cognitive_flexibility"]
    test_cases:
      - name: "ExecutiveFunction - inhibición"
        input: "tarea de inhibición"
        expected_output: "puntuación de inhibición"

  bal:
    display_name: "Behavioral Attention Library"
    description: "Atención conductual: selectiva, sostenida, dividida"
    dependencies: ["numpy==1.24.0"]
    depends_on: ["bcl"]
    exports: ["Attention", "selective_attention", "sustained_attention", "divided_attention"]
    test_cases:
      - name: "Attention - selectiva"
        input: "tarea de atención selectiva"
        expected_output: "puntuación de atención"

  bml:
    display_name: "Behavioral Memory Library"
    description: "Memoria conductual: trabajo, episódica, semántica"
    dependencies: ["numpy==1.24.0"]
    depends_on: ["bcl"]
    exports: ["Memory", "working_memory", "episodic_memory", "semantic_memory"]
    test_cases:
      - name: "Memory - working memory"
        input: "tarea de memoria de trabajo"
        expected_output: "span de memoria"

  bccl:
    display_name: "Behavioral Cognitive Compensation Library"
    description: "Compensación cognitiva: estrategias, ayudas, adaptación"
    dependencies: ["numpy==1.24.0"]
    depends_on: ["bcl"]
    exports: ["CognitiveCompensation", "compensate", "strategy", "adapt"]
    test_cases:
      - name: "CognitiveCompensation - estrategia"
        input: "déficit cognitivo"
        expected_output: "estrategia de compensación"

  bdl:
    display_name: "Behavioral Decision Library"
    description: "Toma de decisiones conductuales"
    dependencies: ["numpy==1.24.0"]
    depends_on: ["bcl"]
    exports: ["Decision", "decision_making", "risk_assessment", "choice"]
    test_cases:
      - name: "Decision - risk assessment"
        input: "opciones con riesgo"
        expected_output: "decisión calculada"

  # ---------- C. Measurement Libraries ----------
  bml:
    display_name: "Behavioral Measurement Library"
    description: "Medición de variables conductuales"
    dependencies: ["pandas==2.1.0"]
    depends_on: ["bcl"]
    exports: ["Measurement", "measure", "scale", "instrument"]
    test_cases:
      - name: "Measurement - escala"
        input: "respuestas a ítems"
        expected_output: "puntuación de escala"

  bpsl:
    display_name: "Behavioral Psychometrics Library"
    description: "Psicometría conductual: fiabilidad, validez, análisis de ítems"
    dependencies: ["pingouin==0.5.3", "scipy==1.11.0"]
    depends_on: ["bcl"]
    exports: ["Psychometrics", "reliability", "validity", "item_analysis"]
    test_cases:
      - name: "Psychometrics - reliability"
        input: "datos de test-retest"
        expected_output: "coeficiente de fiabilidad"

  brl:
    display_name: "Behavioral Reliability Library"
    description: "Fiabilidad de medidas conductuales: alfa, test-retest, inter-evaluador"
    dependencies: ["pingouin==0.5.3"]
    depends_on: ["bcl"]
    exports: ["Reliability", "alpha", "test_retest", "inter_rater"]
    test_cases:
      - name: "Reliability - alpha"
        input: "datos de ítems"
        expected_output: "alpha > 0.7"

  bvl:
    display_name: "Behavioral Validity Library"
    description: "Validez de medidas conductuales: constructo, criterio, contenido"
    dependencies: ["pingouin==0.5.3", "scipy==1.11.0"]
    depends_on: ["bcl"]
    exports: ["Validity", "construct_validity", "criterion_validity", "content_validity"]
    test_cases:
      - name: "Validity - construct_validity"
        input: "datos de constructos relacionados"
        expected_output: "correlación > 0.4"

  # ============================================================
  # NIVEL II: KNOWLEDGE LIBRARIES (continuación)
  # ============================================================

  bckl:
    display_name: "Behavioral Clinical Knowledge Library"
    description: "Conocimiento clínico conductual"
    dependencies: ["json", "pydantic==2.5.0"]
    depends_on: ["bcl", "bol"]
    exports: ["ClinicalKnowledge", "ClinicalGuideline", "ClinicalProtocol"]
    test_cases:
      - name: "ClinicalKnowledge - obtener guía"
        input: "código de guía"
        expected_output: "guía encontrada"

  bskl:
    display_name: "Behavioral Scientific Knowledge Library"
    description: "Conocimiento científico conductual"
    dependencies: ["json", "pydantic==2.5.0"]
    depends_on: ["bcl", "bol"]
    exports: ["ScientificKnowledge", "ScientificArticle", "ScientificTheory"]
    test_cases:
      - name: "ScientificKnowledge - obtener artículo"
        input: "DOI"
        expected_output: "artículo encontrado"

  beil:
    display_name: "Behavioral Evidence Integration Library"
    description: "Integración de evidencia conductual"
    dependencies: ["pandas==2.1.0", "scipy==1.11.0"]
    depends_on: ["bcl", "bel"]
    exports: ["EvidenceIntegration", "meta_analysis", "systematic_review"]
    test_cases:
      - name: "EvidenceIntegration - meta_analysis"
        input: "lista de estudios"
        expected_output: "efecto combinado"

  bgl:
    display_name: "Behavioral Guideline Library"
    description: "Guías clínicas conductuales"
    dependencies: ["json", "pydantic==2.5.0"]
    depends_on: ["bcl", "bckl"]
    exports: ["Guideline", "Recommendation", "DecisionTree"]
    test_cases:
      - name: "Guideline - seguir árbol de decisión"
        input: "síntomas"
        expected_output: "recomendación"
---

# BehavioralOS - Sistema Operativo Científico

## Filosofía del Proyecto
Behavioral trabaja desde una perspectiva de Conductismo Radical y Contextual.
La unidad básica siempre es: conducta + contexto + historia + consecuencias + adaptación.

**Torticode:** todas las bibliotecas deben cumplir los principios Torticode (TCD-001):
DRY/KISS/YAGNI, transformación criptográfica correcta (Encoding/Hashing/Encryption),
Big O documentado y POO+DDD.

## Arquitectura General

Behavioral Platform
│
┌────────────────────────────────────────┐
│ Nivel III – Application Libraries │
│ (14 bibliotecas) │
└────────────────────────────────────────┘
▲
┌────────────────────────────────────────┐
│ Nivel II – Intelligence Libraries │
│ (25 bibliotecas) │
└────────────────────────────────────────┘
▲
┌────────────────────────────────────────┐
│ Nivel I – Foundation Libraries │
│ (33 bibliotecas) │
└────────────────────────────────────────┘
▲
Behavioral Core Runtime


## Stack Tecnológico para Gemma 4
[Entrada de Texto/Audio del Paciente]
│
▼
┌──────────────────┐
│ Gemma 4 │ ── (Extrae entidades lingüísticas y puntuaciones)
└────────┬─────────┘
│
▼
┌─────────────────────────────────────────────────────────────┐
│ MOTOR MÁTEMATICO Y DE GRAFOS │
├───────────────────────────────┬─────────────────────────────┤
│ • RFT / PBP: Neo4j + NetworkX │ • Neuro / ACT: scipy & pandas│
│ • Cadenas DBT: NetworkX │ • CRBs: spaCy Pipeline │
└───────────────────────┬───────┴─────────────────────────────┘
│
▼
[Dashboard Unificado del Psicólogo]


## Resumen de Bibliotecas por Nivel

| Nivel | Categoría | Bibliotecas |
|---|---|---|
| **Nivel I** | Core (9) | BCL, BDML, BEL, BOL, BContextL, BELib, BSL, BPL, BTL |
| **Nivel I** | Mathematical (8) | BSLib, BBL, BProbL, BOptL, BNML, BTSLib, BSigL, BDSL |
| **Nivel I** | Graph (6) | BGraphL, BKGL, BCGL, BGAL, BNAL, BCausalGL |
| **Nivel I** | Modeling (6) | BFML, BEML, BSysML, BHML, BCML, BLSL |
| **Nivel I** | Infrastructure (3) | BAPIL, BSRL, BConfL |
| **Nivel II** | Learning (7) | BRLL, BLHL, BCL, BRSL, BGL, BShL, BEL |
| **Nivel II** | Simulation (5) | BSimL, BScenL, BISL, BFSL, BCFL |
| **Nivel II** | Prediction (5) | BFL, BRPL, BTL, BTrnL, BOPL |
| **Nivel II** | Explainability (4) | BExL, BRnL, BMrL, BEL |
| **Nivel II** | Knowledge (4) | BCKL, BSKL, BEIL, BGL |
| **Nivel III** | Intervention (5) | BIPL, BSL, BRAL, BAPL, BML |
| **Nivel III** | Cognitive (5) | BEFL, BAL, BML, BCCL, BDL |
| **Nivel III** | Measurement (4) | BML, BPsL, BRL, BVL |

---

