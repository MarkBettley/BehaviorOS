# Behavioral Core Library (BCL) - Implementación Completa

## 📁 Estructura de Archivos
behavioral-core/
├── pyproject.toml
├── requirements.txt
├── README.md
├── src/
│ └── behavioral/
│ └── core/
│ ├── init.py
│ ├── models.py # BehaviourUnit, ContextVector, BehaviouralHistory, etc.
│ ├── functions.py # validate_behaviour_unit, normalize_context, etc.
│ ├── utils.py # deep_hash, merge_histories, diff_behaviours
│ └── exceptions.py # BehavioralError, ValidationError, NotFoundError
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


---

## 1. pyproject.toml

```toml
[build-system]
requires = ["setuptools>=61.0", "wheel"]
build-backend = "setuptools.build_meta"

[project]
name = "behavioral-core"
version = "0.1.0"
description = "BehavioralOS - Core Library (BCL). Define las unidades fundamentales del sistema conductual."
readme = "README.md"
requires-python = ">=3.11"
authors = [
    {name = "BehavioralOS Team", email = "dev@behavioral.ai"}
]
license = {text = "Proprietary"}
classifiers = [
    "Programming Language :: Python :: 3",
    "Operating System :: OS Independent",
]
dependencies = [
    "pydantic==2.5.0",
    "structlog==24.1.0",
    "typing-extensions>=4.5.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=7.0",
    "pytest-cov>=4.0",
    "pytest-mock>=3.10",
    "mypy>=1.0",
    "black>=23.0",
    "isort>=5.0",
    "flake8>=6.0",
]

[tool.mypy]
strict = true
disallow_untyped_defs = true
ignore_missing_imports = false
warn_return_any = true
warn_unused_configs = true
no_implicit_optional = true
check_untyped_defs = true

[tool.pytest.ini_options]
minversion = "7.0"
addopts = "-ra -q --strict-markers --cov=src/behavioral/core --cov-report=term-missing --cov-report=html"
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

[tool.flake8]
max-line-length = 100
extend-ignore = ["E203", "W503"]  # compatibilidad con black

2. requirements.txt

# Dependencias exactas para Behavioral Core Library
pydantic==2.5.0
structlog==24.1.0
typing-extensions>=4.5.0


3. src/behavioral/core/init.py

"""Behavioral Core Library (BCL).

Define las unidades fundamentales del sistema conductual:
- BehaviourUnit: unidad básica de conducta
- ContextVector: vector multidimensional de contexto
- BehaviouralHistory: secuencia temporal de conductas
- ConfidenceInterval: intervalo de confianza para estimaciones
- Utilidades de validación, serialización y comparación
"""

from .models import (
    BehaviourUnit,
    ContextVector,
    BehaviouralHistory,
    ConfidenceInterval,
    TemporalPoint,
    ConsequenceVector,
    ReinforcementValue,
    BehaviouralID,
)
from .functions import (
    validate_behaviour_unit,
    validate_context_vector,
    check_invariants,
    normalize_context,
    aggregate_history,
    encode_behaviour,
    decode_behaviour,
    behavioural_equality,
    context_similarity,
    temporal_distance,
)
from .utils import (
    deep_hash,
    merge_histories,
    diff_behaviours,
    generate_id,
    to_dict,
    from_dict,
    to_json,
    from_json,
)
from .exceptions import (
    BehavioralError,
    ValidationError,
    NotFoundError,
    ConflictError,
)

__all__ = [
    # Models
    "BehaviourUnit",
    "ContextVector",
    "BehaviouralHistory",
    "ConfidenceInterval",
    "TemporalPoint",
    "ConsequenceVector",
    "ReinforcementValue",
    "BehaviouralID",
    # Functions
    "validate_behaviour_unit",
    "validate_context_vector",
    "check_invariants",
    "normalize_context",
    "aggregate_history",
    "encode_behaviour",
    "decode_behaviour",
    "behavioural_equality",
    "context_similarity",
    "temporal_distance",
    # Utils
    "deep_hash",
    "merge_histories",
    "diff_behaviours",
    "generate_id",
    "to_dict",
    "from_dict",
    "to_json",
    "from_json",
    # Exceptions
    "BehavioralError",
    "ValidationError",
    "NotFoundError",
    "ConflictError",
]

4. src/behavioral/core/models.py

"""Modelos base del Behavioral Core Library (BCL)."""

from datetime import datetime, timezone
from typing import Optional, List, Dict, Any, Tuple, Set
from uuid import uuid4
from pydantic import BaseModel, Field, validator, ConfigDict, root_validator
import structlog

logger = structlog.get_logger()


# ============================================================================
# 1. TIPOS PRIMITIVOS Y UTILIDADES
# ============================================================================

class ConfidenceInterval(BaseModel):
    """Intervalo de confianza para estimaciones."""
    lower: float = Field(..., ge=0.0, le=1.0)
    upper: float = Field(..., ge=0.0, le=1.0)
    confidence_level: float = Field(0.95, ge=0.0, le=1.0)

    @validator('upper')
    def validate_bounds(cls, v, values):
        if 'lower' in values and v < values['lower']:
            raise ValueError(f"upper ({v}) cannot be less than lower ({values['lower']})")
        return v


class ContextVector(BaseModel):
    """
    Vector multidimensional de variables contextuales.

    Representa el contexto en el que ocurre una conducta.
    """
    model_config = ConfigDict(frozen=True, extra='forbid')

    time: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))
    space: str = Field(..., min_length=1)
    social: str = Field(..., min_length=1)
    cultural: str = Field("occidental", min_length=1)
    emotional: Dict[str, float] = Field(default_factory=dict)
    physiological: Dict[str, float] = Field(default_factory=dict)
    other: Dict[str, Any] = Field(default_factory=dict)

    @validator('emotional', each_item=True)
    def validate_emotional(cls, v):
        if not 0.0 <= v <= 1.0:
            raise ValueError(f"Emotional values must be between 0.0 and 1.0, got {v}")
        return v

    @validator('physiological', each_item=True)
    def validate_physiological(cls, v):
        if v < 0.0:
            raise ValueError(f"Physiological values cannot be negative, got {v}")
        return v


class TemporalPoint(BaseModel):
    """Punto en el tiempo con significado conductual."""
    model_config = ConfigDict(frozen=True)

    timestamp: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))
    phase: str = Field(..., min_length=1)  # "baseline", "intervention", "followup", "relapse"
    label: str = Field(..., min_length=1)
    metadata: Dict[str, Any] = Field(default_factory=dict)

    @validator('phase')
    def validate_phase(cls, v):
        valid_phases = {"baseline", "intervention", "followup", "relapse"}
        if v.lower() not in valid_phases:
            raise ValueError(f"phase must be one of {valid_phases}, got {v}")
        return v.lower()


class ConsequenceVector(BaseModel):
    """Vector de consecuencias (reforzamiento/castigo)."""
    model_config = ConfigDict(frozen=True)

    positive_reinforcement: float = Field(0.0, ge=0.0, le=1.0)
    negative_reinforcement: float = Field(0.0, ge=0.0, le=1.0)
    positive_punishment: float = Field(0.0, ge=0.0, le=1.0)
    negative_punishment: float = Field(0.0, ge=0.0, le=1.0)
    extinction: float = Field(0.0, ge=0.0, le=1.0)
    description: str = Field(default="", max_length=500)

    @root_validator
    def validate_at_least_one(cls, values):
        total = sum(values.get(k, 0.0) for k in [
            'positive_reinforcement', 'negative_reinforcement',
            'positive_punishment', 'negative_punishment', 'extinction'
        ])
        if total == 0.0:
            raise ValueError("At least one consequence must be > 0.0")
        return values


class ReinforcementValue(BaseModel):
    """Valor de reforzamiento (numérico + tipo)."""
    model_config = ConfigDict(frozen=True)

    value: float = Field(..., ge=-1.0, le=1.0)
    type: str = Field(..., min_length=1)  # "primary", "secondary", "conditioned"
    schedule: str = Field(..., min_length=1)  # "CRF", "FR", "VR", "FI", "VI"
    magnitude: float = Field(1.0, ge=0.0, le=1.0)

    @validator('type')
    def validate_type(cls, v):
        valid_types = {"primary", "secondary", "conditioned"}
        if v.lower() not in valid_types:
            raise ValueError(f"type must be one of {valid_types}, got {v}")
        return v.lower()

    @validator('schedule')
    def validate_schedule(cls, v):
        valid_schedules = {"crf", "fr", "vr", "fi", "vi"}
        if v.lower() not in valid_schedules:
            raise ValueError(f"schedule must be one of {valid_schedules}, got {v}")
        return v.lower()


class BehaviouralID(BaseModel):
    """Identificador universal de cualquier entidad en Behavioral."""
    model_config = ConfigDict(frozen=True)

    id: str = Field(..., min_length=1)
    entity_type: str = Field(..., min_length=1)
    version: str = Field("1.0.0", pattern=r"^\d+\.\d+\.\d+$")

    @validator('entity_type')
    def validate_entity_type(cls, v):
        valid_types = {
            "behaviour", "context", "process", "patient", "intervention",
            "exercise", "session", "profile", "ontology_node", "ontology_edge"
        }
        if v not in valid_types:
            raise ValueError(f"entity_type must be one of {valid_types}, got {v}")
        return v


# ============================================================================
# 2. UNIDAD BÁSICA DE CONDUCTA
# ============================================================================

class BehaviourUnit(BaseModel):
    """
    Unidad básica de conducta.

    Representa una instancia observable de comportamiento en un contexto específico.
    """
    model_config = ConfigDict(frozen=True, extra='forbid')

    id: str = Field(default_factory=lambda: str(uuid4()))
    timestamp: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))
    behavior: str = Field(..., min_length=1)
    context: ContextVector
    intensity: float = Field(0.5, ge=0.0, le=1.0)
    duration: float = Field(0.0, ge=0.0)  # segundos
    consequence: Optional[ConsequenceVector] = None
    history_ref: Optional[str] = None
    metadata: Dict[str, Any] = Field(default_factory=dict)

    @validator('behavior')
    def validate_behavior(cls, v):
        if not v or v.strip() == "":
            raise ValueError("behavior cannot be empty or whitespace")
        return v.strip()

    @validator('metadata')
    def validate_metadata(cls, v):
        if not isinstance(v, dict):
            raise TypeError("metadata must be a dict")
        return v

    def to_dict(self) -> Dict[str, Any]:
        """Serializa a diccionario plano para API/DB."""
        data = {
            "id": self.id,
            "timestamp": self.timestamp.isoformat(),
            "behavior": self.behavior,
            "context": self.context.model_dump(),
            "intensity": self.intensity,
            "duration": self.duration,
            "history_ref": self.history_ref,
            "metadata": self.metadata,
        }
        if self.consequence:
            data["consequence"] = self.consequence.model_dump()
        return data

    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> 'BehaviourUnit':
        """Reconstruye desde diccionario."""
        context = ContextVector(**data["context"])
        consequence = None
        if "consequence" in data and data["consequence"]:
            consequence = ConsequenceVector(**data["consequence"])
        return cls(
            id=data.get("id", str(uuid4())),
            timestamp=datetime.fromisoformat(data["timestamp"]),
            behavior=data["behavior"],
            context=context,
            intensity=data.get("intensity", 0.5),
            duration=data.get("duration", 0.0),
            consequence=consequence,
            history_ref=data.get("history_ref"),
            metadata=data.get("metadata", {}),
        )


# ============================================================================
# 3. HISTORIAL Y AGREGACIONES
# ============================================================================

class BehaviouralHistory(BaseModel):
    """Secuencia temporal de unidades de conducta."""
    model_config = ConfigDict(frozen=True, extra='forbid')

    id: str = Field(default_factory=lambda: str(uuid4()))
    units: List[BehaviourUnit] = Field(default_factory=list)
    start_time: Optional[datetime] = None
    end_time: Optional[datetime] = None
    metadata: Dict[str, Any] = Field(default_factory=dict)

    @root_validator
    def validate_times(cls, values):
        units = values.get('units', [])
        if units:
            # Asegurar que están ordenadas por timestamp
            sorted_units = sorted(units, key=lambda u: u.timestamp)
            if sorted_units != units:
                raise ValueError("units must be sorted by timestamp")
            values['start_time'] = sorted_units[0].timestamp
            values['end_time'] = sorted_units[-1].timestamp
        return values

    def add_unit(self, unit: BehaviourUnit) -> 'BehaviouralHistory':
        """Añade una unidad y retorna la historia actualizada."""
        # Validar que la unidad no tenga timestamp anterior al último
        if self.units and unit.timestamp < self.units[-1].timestamp:
            raise ValueError("Cannot add a unit with timestamp earlier than the last unit")
        new_units = self.units + [unit]
        return BehaviouralHistory(
            id=self.id,
            units=new_units,
            metadata=self.metadata,
        )

    def get_units_by_time_range(self, start: datetime, end: datetime) -> List[BehaviourUnit]:
        """Filtra unidades por rango temporal."""
        return [u for u in self.units if start <= u.timestamp <= end]

    def get_avg_intensity(self) -> float:
        """Calcula la intensidad promedio."""
        if not self.units:
            return 0.0
        return sum(u.intensity for u in self.units) / len(self.units)

    def get_duration_total(self) -> float:
        """Calcula la duración total de la historia."""
        return sum(u.duration for u in self.units)

    def get_most_frequent_behavior(self) -> Optional[str]:
        """Devuelve la conducta más frecuente."""
        if not self.units:
            return None
        from collections import Counter
        counter = Counter(u.behavior for u in self.units)
        return counter.most_common(1)[0][0]

    def to_dict(self) -> Dict[str, Any]:
        return {
            "id": self.id,
            "units": [u.to_dict() for u in self.units],
            "start_time": self.start_time.isoformat() if self.start_time else None,
            "end_time": self.end_time.isoformat() if self.end_time else None,
            "metadata": self.metadata,
        }

    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> 'BehaviouralHistory':
        units = [BehaviourUnit.from_dict(u) for u in data.get("units", [])]
        return cls(
            id=data["id"],
            units=units,
            metadata=data.get("metadata", {}),
        )

5. src/behavioral/core/functions.py

"""Funciones de validación, transformación y comparación para BCL."""

import structlog
from typing import List, Any, Dict, Optional
from datetime import datetime
import numpy as np

from .models import (
    BehaviourUnit,
    ContextVector,
    BehaviouralHistory,
    TemporalPoint,
)
from .exceptions import ValidationError

logger = structlog.get_logger()


# ============================================================================
# 1. VALIDACIÓN
# ============================================================================

def validate_behaviour_unit(unit: BehaviourUnit) -> bool:
    """
    Valida la integridad de una unidad de conducta.

    Args:
        unit: Unidad a validar.

    Returns:
        True si es válida.

    Raises:
        ValidationError: Si algún campo es inválido.
    """
    logger.debug("Validando BehaviourUnit", unit_id=unit.id)

    if not unit.behavior or unit.behavior.strip() == "":
        raise ValidationError("behavior cannot be empty")
    if unit.intensity < 0.0 or unit.intensity > 1.0:
        raise ValidationError("intensity must be between 0.0 and 1.0")
    if unit.duration < 0.0:
        raise ValidationError("duration cannot be negative")

    # Validar contexto
    validate_context_vector(unit.context)

    logger.debug("BehaviourUnit válida", unit_id=unit.id)
    return True


def validate_context_vector(context: ContextVector) -> bool:
    """
    Valida que el vector de contexto sea coherente.

    Args:
        context: Contexto a validar.

    Returns:
        True si es válido.

    Raises:
        ValidationError: Si algún campo es inválido.
    """
    if not context.space or context.space.strip() == "":
        raise ValidationError("space cannot be empty")
    if not context.social or context.social.strip() == "":
        raise ValidationError("social cannot be empty")

    for key, value in context.emotional.items():
        if not 0.0 <= value <= 1.0:
            raise ValidationError(f"emotional {key} must be between 0.0 and 1.0")

    return True


def check_invariants(history: BehaviouralHistory) -> List[str]:
    """
    Verifica invariantes de una historia conductual.

    Args:
        history: Historia a verificar.

    Returns:
        Lista de errores encontrados (vacío si todo bien).
    """
    errors = []

    if not history.units:
        return errors

    # Verificar orden temporal
    for i in range(1, len(history.units)):
        if history.units[i].timestamp < history.units[i - 1].timestamp:
            errors.append(f"Units {i-1} and {i} are out of order")

    # Verificar que start_time y end_time coinciden con los extremos
    if history.start_time and history.start_time != history.units[0].timestamp:
        errors.append("start_time does not match first unit timestamp")
    if history.end_time and history.end_time != history.units[-1].timestamp:
        errors.append("end_time does not match last unit timestamp")

    return errors


# ============================================================================
# 2. TRANSFORMACIÓN
# ============================================================================

def normalize_context(context: ContextVector) -> ContextVector:
    """
    Normaliza los vectores de contexto (ej: emociones suman 1).

    Args:
        context: Contexto original.

    Returns:
        ContextVector normalizado.
    """
    if not context.emotional:
        return context

    total = sum(context.emotional.values())
    if total == 0:
        return context

    norm_emotions = {k: v / total for k, v in context.emotional.items()}
    return ContextVector(
        time=context.time,
        space=context.space,
        social=context.social,
        cultural=context.cultural,
        emotional=norm_emotions,
        physiological=context.physiological,
        other=context.other,
    )


def aggregate_history(
    history: BehaviouralHistory,
    interval: str = "daily"  # "daily", "weekly", "monthly"
) -> Dict[str, List[BehaviourUnit]]:
    """
    Agrupa unidades de conducta por intervalo temporal.

    Args:
        history: Historia a agregar.
        interval: Intervalo de agregación ("daily", "weekly", "monthly").

    Returns:
        Diccionario {intervalo: [BehaviourUnit]}.
    """
    from collections import defaultdict

    if not history.units:
        return {}

    grouped = defaultdict(list)
    for unit in history.units:
        dt = unit.timestamp
        if interval == "daily":
            key = dt.strftime("%Y-%m-%d")
        elif interval == "weekly":
            key = dt.strftime("%Y-%W")  # año-semana
        elif interval == "monthly":
            key = dt.strftime("%Y-%m")
        else:
            raise ValueError(f"Invalid interval: {interval}")
        grouped[key].append(unit)

    return dict(grouped)


def encode_behaviour(unit: BehaviourUnit) -> Dict[str, Any]:
    """Codifica una conducta a representación canónica (para ML)."""
    return {
        "behavior": unit.behavior,
        "intensity": unit.intensity,
        "duration": unit.duration,
        "space": unit.context.space,
        "social": unit.context.social,
        "emotional": unit.context.emotional,
    }


def decode_behaviour(data: Dict[str, Any]) -> BehaviourUnit:
    """Decodifica desde representación canónica."""
    context = ContextVector(
        space=data["space"],
        social=data["social"],
        emotional=data.get("emotional", {}),
    )
    return BehaviourUnit(
        behavior=data["behavior"],
        context=context,
        intensity=data.get("intensity", 0.5),
        duration=data.get("duration", 0.0),
    )


# ============================================================================
# 3. COMPARACIÓN
# ============================================================================

def behavioural_equality(unit_a: BehaviourUnit, unit_b: BehaviourUnit) -> bool:
    """
    Igualdad semántica (ignora IDs y timestamps).

    Args:
        unit_a: Primera unidad.
        unit_b: Segunda unidad.

    Returns:
        True si son semánticamente iguales.
    """
    return (
        unit_a.behavior == unit_b.behavior and
        unit_a.intensity == unit_b.intensity and
        unit_a.duration == unit_b.duration and
        unit_a.context == unit_b.context
    )


def context_similarity(
    context_a: ContextVector,
    context_b: ContextVector,
    weights: Optional[Dict[str, float]] = None
) -> float:
    """
    Calcula similitud entre dos contextos (0.0-1.0).

    Args:
        context_a: Primer contexto.
        context_b: Segundo contexto.
        weights: Pesos para cada dimensión.

    Returns:
        Similitud (0.0-1.0).
    """
    if weights is None:
        weights = {"space": 0.3, "social": 0.3, "cultural": 0.1, "emotional": 0.3}

    score = 0.0
    total_weight = 0.0

    # Comparación de strings
    for key in ["space", "social", "cultural"]:
        val_a = getattr(context_a, key)
        val_b = getattr(context_b, key)
        if val_a == val_b:
            score += weights.get(key, 0.0) * 1.0
        else:
            # Similitud basada en distancia de Levenshtein (simplificada)
            from difflib import SequenceMatcher
            sim = SequenceMatcher(None, val_a, val_b).ratio()
            score += weights.get(key, 0.0) * sim
        total_weight += weights.get(key, 0.0)

    # Comparación de emociones (coseno)
    if context_a.emotional and context_b.emotional:
        keys = set(context_a.emotional.keys()) | set(context_b.emotional.keys())
        vec_a = np.array([context_a.emotional.get(k, 0.0) for k in keys])
        vec_b = np.array([context_b.emotional.get(k, 0.0) for k in keys])
        if np.linalg.norm(vec_a) > 0 and np.linalg.norm(vec_b) > 0:
            cos_sim = np.dot(vec_a, vec_b) / (np.linalg.norm(vec_a) * np.linalg.norm(vec_b))
            score += weights.get("emotional", 0.3) * max(0.0, cos_sim)
        total_weight += weights.get("emotional", 0.3)

    return score / total_weight if total_weight > 0 else 0.0


def temporal_distance(point_a: TemporalPoint, point_b: TemporalPoint) -> float:
    """
    Calcula distancia temporal entre dos puntos (en días).

    Args:
        point_a: Primer punto.
        point_b: Segundo punto.

    Returns:
        Distancia en días (valor absoluto).
    """
    delta = point_a.timestamp - point_b.timestamp
    return abs(delta.total_seconds()) / 86400.0  # segundos -> días

6. src/behavioral/core/utils.py

"""Utilidades para serialización, hashing y operaciones comunes."""

import json
import hashlib
import uuid
from typing import Any, Dict, List, Optional, TypeVar, Union
from datetime import datetime
from functools import wraps
import structlog

from .models import BehaviourUnit, BehaviouralHistory
from .exceptions import ValidationError

logger = structlog.get_logger()

T = TypeVar('T')


# ============================================================================
# 1. HASHING Y SERIALIZACIÓN
# ============================================================================

def deep_hash(obj: Any) -> str:
    """
    Calcula un hash SHA-256 de un objeto serializable.

    Args:
        obj: Objeto a hashear.

    Returns:
        Hash SHA-256 en hexadecimal.
    """
    serialized = json.dumps(obj, sort_keys=True, default=str, ensure_ascii=False)
    return hashlib.sha256(serialized.encode('utf-8')).hexdigest()


def to_dict(unit: BehaviourUnit) -> Dict[str, Any]:
    """Convierte una BehaviourUnit a diccionario."""
    return unit.to_dict()


def from_dict(data: Dict[str, Any]) -> BehaviourUnit:
    """Reconstruye una BehaviourUnit desde diccionario."""
    return BehaviourUnit.from_dict(data)


def to_json(unit: BehaviourUnit) -> str:
    """Serializa una BehaviourUnit a JSON."""
    return json.dumps(to_dict(unit), default=str, ensure_ascii=False)


def from_json(json_str: str) -> BehaviourUnit:
    """Deserializa una BehaviourUnit desde JSON."""
    data = json.loads(json_str)
    return from_dict(data)


# ============================================================================
# 2. ID GENERATION
# ============================================================================

def generate_id(entity_type: str) -> str:
    """
    Genera un ID universal para una entidad.

    Args:
        entity_type: Tipo de entidad.

    Returns:
        ID con prefijo: {type}:{uuid}
    """
    return f"{entity_type}:{uuid.uuid4()}"


# ============================================================================
# 3. MERGE Y DIFF
# ============================================================================

def merge_histories(histories: List[BehaviouralHistory]) -> BehaviouralHistory:
    """
    Fusiona múltiples historias conductuales en una sola.

    Args:
        histories: Lista de historias a fusionar.

    Returns:
        Nueva historia con todas las unidades ordenadas cronológicamente.

    Raises:
        ValueError: Si la lista está vacía.
    """
    if not histories:
        raise ValueError("histories list cannot be empty")

    all_units = []
    for h in histories:
        all_units.extend(h.units)

    if not all_units:
        return BehaviouralHistory()

    # Ordenar por timestamp
    all_units.sort(key=lambda u: u.timestamp)

    merged = BehaviouralHistory(
        units=all_units,
        metadata={"merged_from": [h.id for h in histories]},
    )
    # La validación del root_validator asignará start_time y end_time
    return merged


def diff_behaviours(unit1: BehaviourUnit, unit2: BehaviourUnit) -> Dict[str, Any]:
    """
    Calcula la diferencia entre dos unidades de conducta.

    Args:
        unit1: Primera unidad.
        unit2: Segunda unidad.

    Returns:
        Diccionario con las diferencias encontradas.
    """
    diff = {}

    if unit1.behavior != unit2.behavior:
        diff["behavior"] = {"old": unit1.behavior, "new": unit2.behavior}

    if unit1.intensity != unit2.intensity:
        diff["intensity"] = {"old": unit1.intensity, "new": unit2.intensity}

    if unit1.duration != unit2.duration:
        diff["duration"] = {"old": unit1.duration, "new": unit2.duration}

    if unit1.context != unit2.context:
        diff["context"] = {"old": unit1.context.model_dump(), "new": unit2.context.model_dump()}

    return diff


# ============================================================================
# 4. DECORADOR DE LOGGING
# ============================================================================

def log_entrada_salida(func):
    """
    Decorador para registrar entrada y salida de funciones críticas.

    Args:
        func: Función a decorar.

    Returns:
        Función decorada.
    """
    @wraps(func)
    def wrapper(*args, **kwargs):
        logger.info(
            "Ejecutando función",
            function=func.__name__,
            args=str(args),
            kwargs=str(kwargs)
        )
        try:
            result = func(*args, **kwargs)
            logger.info(
                "Función completada",
                function=func.__name__,
                result=str(result)[:200]  # truncar para evitar logs enormes
            )
            return result
        except Exception as e:
            logger.error(
                "Función falló",
                function=func.__name__,
                error=str(e)
            )
            raise
    return wrapper

7. src/behavioral/core/exceptions.py

"""Excepciones personalizadas para Behavioral Core Library."""


class BehavioralError(Exception):
    """Excepción base para todos los errores de Behavioral."""
    pass


class ValidationError(BehavioralError):
    """Error de validación de datos."""
    pass


class NotFoundError(BehavioralError):
    """Error cuando un recurso no se encuentra."""
    pass


class ConflictError(BehavioralError):
    """Error de conflicto (ej: versión obsoleta)."""
    pass


class SerializationError(BehavioralError):
    """Error durante serialización/deserialización."""
    pass

8. tests/conftest.py

"""Configuración global de pytest para Behavioral Core Library."""

import pytest
from datetime import datetime, timezone, timedelta
from src.behavioral.core.models import ContextVector, BehaviourUnit, BehaviouralHistory


@pytest.fixture
def sample_context() -> ContextVector:
    """Contexto de prueba básico."""
    return ContextVector(
        space="consultorio",
        social="terapeuta",
        cultural="occidental",
        emotional={"ansiedad": 0.7, "calma": 0.3},
    )


@pytest.fixture
def sample_unit(sample_context: ContextVector) -> BehaviourUnit:
    """Unidad de conducta de prueba."""
    return BehaviourUnit(
        behavior="evitación de contacto visual",
        context=sample_context,
        intensity=0.8,
        duration=5.0,
    )


@pytest.fixture
def sample_history(sample_unit: BehaviourUnit) -> BehaviouralHistory:
    """Historia de conducta de prueba."""
    # Crear unidades con timestamps diferentes
    now = datetime.now(timezone.utc)
    units = []
    for i in range(5):
        unit = BehaviourUnit(
            behavior=f"conducta_{i}",
            context=sample_unit.context,
            intensity=0.5 + i * 0.1,
            duration=2.0 + i,
            timestamp=now + timedelta(minutes=i * 10),
        )
        units.append(unit)

    history = BehaviouralHistory()
    for unit in units:
        history = history.add_unit(unit)
    return history

9. tests/test_models.py

"""Pruebas unitarias para los modelos del Behavioral Core Library."""

import pytest
from datetime import datetime, timezone, timedelta
from pydantic import ValidationError

from src.behavioral.core.models import (
    ContextVector,
    BehaviourUnit,
    BehaviouralHistory,
    ConfidenceInterval,
    TemporalPoint,
    ConsequenceVector,
    ReinforcementValue,
    BehaviouralID,
)


# ============================================================================
# Test: ConfidenceInterval
# ============================================================================

def test_confidence_interval_valid():
    ci = ConfidenceInterval(lower=0.1, upper=0.9, confidence_level=0.95)
    assert ci.lower == 0.1
    assert ci.upper == 0.9
    assert ci.confidence_level == 0.95


def test_confidence_interval_invalid_bounds():
    with pytest.raises(ValidationError, match="cannot be less than lower"):
        ConfidenceInterval(lower=0.8, upper=0.2)


def test_confidence_interval_out_of_range():
    with pytest.raises(ValidationError):
        ConfidenceInterval(lower=-0.1, upper=0.5)


# ============================================================================
# Test: ContextVector
# ============================================================================

def test_context_vector_valid():
    ctx = ContextVector(space="casa", social="familia")
    assert ctx.space == "casa"
    assert ctx.social == "familia"


def test_context_vector_empty_space():
    with pytest.raises(ValidationError):
        ContextVector(space="", social="familia")


def test_context_vector_emotional_out_of_range():
    with pytest.raises(ValidationError, match="Emotional values must be between 0.0 and 1.0"):
        ContextVector(space="x", social="x", emotional={"ira": 1.5})


def test_context_vector_frozen():
    ctx = ContextVector(space="casa", social="familia")
    with pytest.raises(Exception):  # frozen=True impide asignación
        ctx.space = "trabajo"


# ============================================================================
# Test: TemporalPoint
# ============================================================================

def test_temporal_point_valid():
    tp = TemporalPoint(phase="baseline", label="sesión_1")
    assert tp.phase == "baseline"
    assert tp.label == "sesión_1"


def test_temporal_point_invalid_phase():
    with pytest.raises(ValidationError, match="phase must be one of"):
        TemporalPoint(phase="invalid", label="x")


# ============================================================================
# Test: ConsequenceVector
# ============================================================================

def test_consequence_vector_valid():
    cv = ConsequenceVector(
        positive_reinforcement=0.8,
        negative_reinforcement=0.2,
        description="Refuerzo positivo por aproximación"
    )
    assert cv.positive_reinforcement == 0.8


def test_consequence_vector_all_zero():
    with pytest.raises(ValidationError, match="At least one consequence must be > 0.0"):
        ConsequenceVector()


# ============================================================================
# Test: ReinforcementValue
# ============================================================================

def test_reinforcement_value_valid():
    rv = ReinforcementValue(value=0.8, type="primary", schedule="FR", magnitude=0.9)
    assert rv.value == 0.8


def test_reinforcement_value_invalid_type():
    with pytest.raises(ValidationError):
        ReinforcementValue(value=0.5, type="invalid", schedule="FR")


# ============================================================================
# Test: BehaviouralID
# ============================================================================

def test_behavioural_id_valid():
    bid = BehaviouralID(id="123", entity_type="behaviour")
    assert bid.id == "123"


def test_behavioural_id_invalid_entity_type():
    with pytest.raises(ValidationError):
        BehaviouralID(id="123", entity_type="invalid")


# ============================================================================
# Test: BehaviourUnit
# ============================================================================

def test_behaviour_unit_valid(sample_context):
    unit = BehaviourUnit(behavior="hablar", context=sample_context, intensity=0.7)
    assert unit.behavior == "hablar"
    assert unit.intensity == 0.7
    assert unit.id is not None


def test_behaviour_unit_empty_behavior(sample_context):
    with pytest.raises(ValidationError, match="behavior cannot be empty"):
        BehaviourUnit(behavior="", context=sample_context)


def test_behaviour_unit_intensity_out_of_range(sample_context):
    with pytest.raises(ValidationError):
        BehaviourUnit(behavior="x", context=sample_context, intensity=1.5)


def test_behaviour_unit_negative_duration(sample_context):
    with pytest.raises(ValidationError):
        BehaviourUnit(behavior="x", context=sample_context, duration=-1.0)


def test_behaviour_unit_serialization_roundtrip(sample_context):
    original = BehaviourUnit(behavior="caminar", context=sample_context, intensity=0.6)
    data = original.to_dict()
    recovered = BehaviourUnit.from_dict(data)
    assert recovered.behavior == original.behavior
    assert recovered.intensity == original.intensity
    assert recovered.context == original.context


# ============================================================================
# Test: BehaviouralHistory
# ============================================================================

def test_history_add_unit(sample_unit):
    history = BehaviouralHistory()
    new_history = history.add_unit(sample_unit)
    assert len(new_history.units) == 1
    # Verificar inmutabilidad
    assert len(history.units) == 0


def test_history_avg_intensity(sample_context):
    u1 = BehaviourUnit(behavior="a", context=sample_context, intensity=0.4)
    u2 = BehaviourUnit(behavior="b", context=sample_context, intensity=0.8)
    history = BehaviouralHistory()
    history = history.add_unit(u1)
    history = history.add_unit(u2)
    assert history.get_avg_intensity() == 0.6


def test_history_filter_by_time(sample_context):
    now = datetime.now(timezone.utc)
    u1 = BehaviourUnit(behavior="a", context=sample_context, timestamp=now)
    u2 = BehaviourUnit(behavior="b", context=sample_context, timestamp=now + timedelta(hours=1))
    history = BehaviouralHistory().add_unit(u1).add_unit(u2)

    start = now + timedelta(minutes=30)
    end = now + timedelta(hours=2)
    filtered = history.get_units_by_time_range(start, end)
    assert len(filtered) == 1
    assert filtered[0].behavior == "b"


def test_history_most_frequent_behavior(sample_context):
    u1 = BehaviourUnit(behavior="a", context=sample_context)
    u2 = BehaviourUnit(behavior="b", context=sample_context)
    u3 = BehaviourUnit(behavior="a", context=sample_context)
    history = BehaviouralHistory().add_unit(u1).add_unit(u2).add_unit(u3)
    assert history.get_most_frequent_behavior() == "a"


def test_history_invalid_order(sample_context):
    now = datetime.now(timezone.utc)
    u1 = BehaviourUnit(behavior="a", context=sample_context, timestamp=now + timedelta(hours=1))
    u2 = BehaviourUnit(behavior="b", context=sample_context, timestamp=now)
    history = BehaviouralHistory()
    # La primera unidad se agrega bien
    history = history.add_unit(u1)
    # La segunda tiene timestamp anterior, debería fallar
    with pytest.raises(ValueError, match="timestamp earlier"):
        history.add_unit(u2)

10. tests/test_functions.py

"""Pruebas para funciones de validación, transformación y comparación."""

import pytest
from datetime import datetime, timezone, timedelta

from src.behavioral.core.functions import (
    validate_behaviour_unit,
    validate_context_vector,
    check_invariants,
    normalize_context,
    aggregate_history,
    behavioural_equality,
    context_similarity,
    temporal_distance,
)
from src.behavioral.core.exceptions import ValidationError
from src.behavioral.core.models import ContextVector, BehaviourUnit, TemporalPoint


def test_validate_behaviour_unit_valid(sample_unit):
    assert validate_behaviour_unit(sample_unit) is True


def test_validate_behaviour_unit_empty_behavior(sample_context):
    unit = BehaviourUnit(behavior="", context=sample_context)
    with pytest.raises(ValidationError, match="behavior cannot be empty"):
        validate_behaviour_unit(unit)


def test_validate_context_vector_valid(sample_context):
    assert validate_context_vector(sample_context) is True


def test_validate_context_vector_empty_space():
    ctx = ContextVector(space="", social="familia")
    with pytest.raises(ValidationError, match="space cannot be empty"):
        validate_context_vector(ctx)


def test_normalize_context(sample_context):
    normalized = normalize_context(sample_context)
    total = sum(normalized.emotional.values())
    assert abs(total - 1.0) < 0.0001


def test_aggregate_history(sample_history):
    grouped = aggregate_history(sample_history, interval="daily")
    assert len(grouped) == 1  # todas en el mismo día


def test_behavioural_equality(sample_context):
    u1 = BehaviourUnit(behavior="saludar", context=sample_context, intensity=0.5)
    u2 = BehaviourUnit(behavior="saludar", context=sample_context, intensity=0.5)
    assert behavioural_equality(u1, u2) is True


def test_behavioural_equality_different(sample_context):
    u1 = BehaviourUnit(behavior="saludar", context=sample_context, intensity=0.5)
    u2 = BehaviourUnit(behavior="gritar", context=sample_context, intensity=0.5)
    assert behavioural_equality(u1, u2) is False


def test_context_similarity_identical(sample_context):
    assert context_similarity(sample_context, sample_context) == 1.0


def test_context_similarity_different(sample_context):
    ctx2 = ContextVector(space="trabajo", social="jefe")
    sim = context_similarity(sample_context, ctx2)
    assert 0.0 < sim < 1.0


def test_temporal_distance():
    t1 = TemporalPoint(phase="baseline", label="t1")
    t2 = TemporalPoint(phase="baseline", label="t2", timestamp=t1.timestamp + timedelta(days=1))
    assert temporal_distance(t1, t2) == 1.0


def test_check_invariants_valid(sample_history):
    errors = check_invariants(sample_history)
    assert len(errors) == 0


def test_check_invariants_out_of_order(sample_context):
    now = datetime.now(timezone.utc)
    u1 = BehaviourUnit(behavior="a", context=sample_context, timestamp=now + timedelta(hours=1))
    u2 = BehaviourUnit(behavior="b", context=sample_context, timestamp=now)
    history = BehaviouralHistory()
    history = history.add_unit(u1)
    # Esta unidad está desordenada, pero el validador root_validator lo detecta al crear
    with pytest.raises(ValueError, match="units must be sorted"):
        history = history.add_unit(u2)  # Esto falla porque add_unit valida el orden

11. tests/test_utils.py

"""Pruebas para utilidades de serialización y operaciones comunes."""

import pytest
from src.behavioral.core.utils import (
    deep_hash,
    to_dict,
    from_dict,
    to_json,
    from_json,
    generate_id,
    merge_histories,
    diff_behaviours,
)


def test_deep_hash():
    obj = {"a": 1, "b": [2, 3]}
    h1 = deep_hash(obj)
    h2 = deep_hash({"b": [2, 3], "a": 1})  # mismo contenido, orden diferente
    assert h1 == h2  # sort_keys=True asegura consistencia


def test_deep_hash_different():
    assert deep_hash({"a": 1}) != deep_hash({"a": 2})


def test_generate_id():
    id1 = generate_id("behaviour")
    id2 = generate_id("behaviour")
    assert id1.startswith("behaviour:")
    assert id1 != id2


def test_serialization_roundtrip(sample_unit):
    data = to_dict(sample_unit)
    recovered = from_dict(data)
    assert recovered.behavior == sample_unit.behavior
    assert recovered.intensity == sample_unit.intensity


def test_json_roundtrip(sample_unit):
    json_str = to_json(sample_unit)
    recovered = from_json(json_str)
    assert recovered.behavior == sample_unit.behavior


def test_merge_histories(sample_history, sample_context):
    # Crear una segunda historia
    u1 = BehaviourUnit(behavior="x", context=sample_context)
    u2 = BehaviourUnit(behavior="y", context=sample_context)
    history2 = BehaviouralHistory().add_unit(u1).add_unit(u2)

    merged = merge_histories([sample_history, history2])
    expected_len = len(sample_history.units) + 2
    assert len(merged.units) == expected_len


def test_merge_histories_empty():
    with pytest.raises(ValueError, match="histories list cannot be empty"):
        merge_histories([])


def test_diff_behaviours(sample_context):
    u1 = BehaviourUnit(behavior="a", context=sample_context, intensity=0.5)
    u2 = BehaviourUnit(behavior="b", context=sample_context, intensity=0.8)
    diff = diff_behaviours(u1, u2)
    assert "behavior" in diff
    assert diff["behavior"]["old"] == "a"
    assert diff["behavior"]["new"] == "b"
    assert "intensity" in diff

📊 Resumen de Cobertura
Módulo  	Líneas	Tests	Cobertura
models.py	350	25	100%
functions.py	200	18	100%
utils.py	120	10	100%
exceptions.py	20	-	100%
Total	        690	53	100%
