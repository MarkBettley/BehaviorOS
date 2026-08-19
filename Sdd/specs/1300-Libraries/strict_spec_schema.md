# ============================================================
# strict_spec_schema.yaml
# Esquema de validación estricto para la generación de código
# de BehavioralOS.
# ============================================================

version: "1.0.0"
description: "Reglas obligatorias para que la IA genere código profesional, consistente y sin errores."

# ---------- REGLAS GLOBALES ----------
global_rules:
  python_version: ">=3.11"
  style_guide: "PEP 8"
  typing: "mypy --strict"  # Obligatorio: todos los archivos deben pasar mypy strict.
  logging: "structlog"     # Usar structlog para trazabilidad estructurada.
  async_io: "Async para operaciones I/O; síncrono para lógica pura."
  docstrings: "Google Style"  # Formato: '''Summary.\n\nArgs:\n    param: desc.\nReturns:\n    desc.\nRaises:\n    desc.\n'''
  torticode_reference: "Ver 000-Core/torticode-principles.md (TCD-001) para principios vinculantes."

# ---------- ESTRUCTURA DE CARPETAS ----------
library_structure:
  - folder: "src/behavioral/{library_name}/"
    description: "Código fuente de la biblioteca."
    files:
      - "__init__.py"
      - "models.py"
      - "functions.py"
      - "utils.py"
      - "exceptions.py"
  - folder: "tests/"
    description: "Pruebas unitarias. Debe tener 100% de cobertura."
    files:
      - "__init__.py"
      - "test_models.py"
      - "test_functions.py"
      - "test_utils.py"
      - "conftest.py"
  - folder: "docs/"
    description: "Documentación generada con Sphinx."
    files:
      - "conf.py"
      - "index.rst"
      - "api.rst"
  - folder: "scripts/"
    description: "Scripts de utilidad (ej: generación de datos de prueba)."

# ---------- REQUISITOS DE ARCHIVOS OBLIGATORIOS ----------
file_requirements:
  - path: "pyproject.toml"
    content_template: |
      [build-system]
      requires = ["setuptools>=61.0", "wheel"]
      build-backend = "setuptools.build_meta"

      [project]
      name = "behavioral-{library_name}"
      version = "0.1.0"
      description = "BehavioralOS - {library_description}"
      readme = "README.md"
      requires-python = ">=3.11"
      dependencies = {dependencies_list}
      
      [project.optional-dependencies]
      dev = ["pytest>=7.0", "pytest-cov>=4.0", "mypy>=1.0", "black>=23.0", "isort>=5.0"]

      [tool.mypy]
      strict = true
      disallow_untyped_defs = true
      ignore_missing_imports = false
      warn_return_any = true
      warn_unused_configs = true

      [tool.pytest.ini_options]
      minversion = "7.0"
      addopts = "-ra -q --strict-markers --cov=src/behavioral/{library_name} --cov-report=term-missing"
      testpaths = ["tests"]
      python_files = "test_*.py"
      python_functions = "test_*"
      markers = [
        "unit: Pruebas unitarias (default)",
        "integration: Pruebas de integración",
        "slow: Pruebas que toman más de 1 segundo"
      ]

      [tool.black]
      line-length = 100
      target-version = ['py311']

      [tool.isort]
      profile = "black"
      line_length = 100

  - path: "requirements.txt"
    content_template: |
      # Dependencias exactas con versiones
      {dependencies_list_with_versions}

  - path: "README.md"
    content_template: |
      # Behavioral - {library_display_name}
      
      {library_description}
      
      ## Instalación
      ```bash
      pip install behavioral-{library_name}

Uso básico

from behavioral.{library_name} import {main_export}

# Ejemplo de uso...

Documentación completa
Ver docs/ para más detalles.

---------- REGLAS DE CÓDIGO ----------
code_rules:

--- Modelos Pydantic ---
models:

"Todas las clases de datos deben heredar de pydantic.BaseModel o usar @dataclass(frozen=True)."

"Todas las propiedades deben tener Field con ge, le, min_length, max_length según corresponda."

"Todas las validaciones complejas deben usar @validator o @root_validator."

"Los modelos deben tener model_config = ConfigDict(frozen=True) si son inmutables, o extra='forbid' si no se permiten campos extra."

--- Funciones ---
functions:

"Todas las funciones públicas deben tener type hints completos (parámetros y retorno)."

"Todas las funciones deben tener docstring en formato Google."

"Todas las funciones deben usar structlog.get_logger() para logging estructurado."

"Todas las funciones deben validar entradas con if not isinstance(...) o usando Pydantic directamente."

"Todas las excepciones de negocio deben ser ValueError o TypeError con mensajes específicos y claros."

"Si la función es asíncrona, debe declararse con async def y usar await en operaciones I/O."

--- Reglas Torticode (DRY/KISS/YAGNI) ---
dry_kiss_yagni:
  "Antes de abstraer código duplicado, esperar a la 3ra repetición (Regla de 3)."
  "La solución más simple y legible es la correcta por defecto."
  "Eliminar cualquier parámetro, clase o función que no se use HOY."
  "No agregar lógica 'para el futuro' o 'por si acaso'."

--- Reglas Big O ---
big_o:
  "No permitir O(n²) dentro de bucles anidados sin HashMap/Set para bajar a O(n)."
  "Operaciones de búsqueda deben usar dict/set (O(1)), no listas (O(n))."
  "Recursión ingenua prohibida; usar memoización (functools.lru_cache) o iteración."
  "Toda función debe tener complejidad documentada en el docstring si es > O(n)."

--- Reglas POO/DDD ---
oop_ddd:
  "Prohibido setters genéricos. Usar métodos semánticos: activarCuenta(), no setEstado()."
  "No usar if/else o switch para variantes de comportamiento. Usar polimorfismo (interfaces/ABC)."
  "Toda clase debe modelar UNA entidad del dominio. No clases 'Manager' o 'Utils' genéricas."
  "Inyección de dependencias explícita en __init__, nunca instanciación directa de dependencias."

--- Utilidades y Decoradores ---
utils:

"Crear un decorador @log_entrada_salida para registrar entradas y salidas de funciones críticas."

"Crear un deep_hash para calcular hashes de objetos serializables (usar json.dumps con sort_keys=True)."

--- Excepciones Personalizadas ---
exceptions:

"Definir una jerarquía de excepciones: BehavioralError (base), ValidationError, NotFoundError, ConflictError."

"Todas deben heredar de Exception y tener un mensaje claro."

---------- REGLAS DE PRUEBAS ----------
test_rules:
coverage: "100% de cobertura de líneas y ramas."
structure:

"Un archivo test_*.py por cada módulo en src/."

"Usar pytest.fixture para datos reutilizables."

"Usar pytest.mark.parametrize para probar múltiples casos."

"Usar pytest.mark.slow para pruebas pesadas."
cases:

"Cada función debe tener al menos 3 casos: happy path, edge case, error case."

"Los casos de error deben verificar que se lanza la excepción correcta con el mensaje esperado."

"Los tests deben ser deterministas (no usar random sin semilla)."

---------- GATES DE CALIDAD ----------
quality_gates:

gate: "mypy --strict"
required: true
command: "mypy src/ tests/"

gate: "pytest --cov --cov-fail-under=100"
required: true
command: "pytest -v --cov=src/behavioral/{library_name} --cov-fail-under=100"

gate: "black --check"
required: true
command: "black --check src/ tests/"

gate: "isort --check-only"
required: true
command: "isort --check-only src/ tests/"

gate: "flake8" # opcional, pero recomendado
required: false
command: "flake8 src/ tests/ --max-line-length=100"

gate: "torticode-validation"
required: true
command: "validate-torticode src/ --max-nested-loops=1 --max-complexity=10 --ban-setters"

---------- PLANTILLA DE FUNCIÓN DE EJEMPLO ----------
example_function_template: |
import structlog
from typing import List, Optional

logger = structlog.get_logger()

def example_function(param1: str, param2: Optional[int] = None) -> List[str]:
"""
Esta es una función de ejemplo que cumple con todas las reglas.

Args:
param1: Descripción del primer parámetro.
param2: Descripción del segundo parámetro (opcional).

Returns:
Lista de strings procesados.

Raises:
ValueError: Si param1 está vacío.
TypeError: Si param2 no es int o None.

Examples:

example_function("test", 5)
['test', 'test', 'test', 'test', 'test']
"""
logger.info("Ejecutando example_function", param1=param1, param2=param2)

if not param1 or not param1.strip():
logger.error("param1 vacío", param1=param1)
raise ValueError("param1 no puede estar vacío")

if param2 is not None and not isinstance(param2, int):
logger.error("param2 no es int", param2=param2)
raise TypeError("param2 debe ser int o None")

count = param2 if param2 is not None else 1
result = [param1] * count

logger.info("example_function completada", result_length=len(result))
return result

---------- PLANTILLA DE TEST DE EJEMPLO ----------
example_test_template: |
import pytest
from behavioral.{library_name}.functions import example_function

def test_example_function_happy_path():
"""Caso feliz: param1 válido, param2 entero."""
result = example_function("abc", 3)
assert result == ["abc", "abc", "abc"]

def test_example_function_edge_case():
"""Caso borde: param2 = None, debe devolver 1 elemento."""
result = example_function("abc")
assert result == ["abc"]

def test_example_function_error_empty_param():
"""Caso error: param1 vacío lanza ValueError."""
with pytest.raises(ValueError, match="param1 no puede estar vacío"):
example_function("")

@pytest.mark.parametrize("bad_param", [1.5, [1,2], {"a":1}])
def test_example_function_error_bad_type(bad_param):
"""Caso error: param2 no es int ni None."""
with pytest.raises(TypeError, match="param2 debe ser int o None"):
example_function("abc", bad_param)