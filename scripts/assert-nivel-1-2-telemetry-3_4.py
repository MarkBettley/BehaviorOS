"""Deterministic assertion for Task 3.4 telemetry persistence.

Parses backend/app/exercises/service.py and verifies that the completion path:
1. checks patient ownership explicitly (session.patient_id != patient_id),
2. returns early on already-completed sessions without inserting telemetry,
3. inserts exactly the four telemetry variables (duration, completion, pauses, retries)
   once each on the active completion path,
4. inserts no telemetry anywhere else.
"""

import ast
import sys
from pathlib import Path

REQUIRED_TELEMETRY = {"duration", "completion", "pauses", "retries"}
SERVICE_PATH = Path(__file__).resolve().parents[1] / "backend" / "app" / "exercises" / "service.py"


def _get_compare_names(node: ast.Compare) -> set[str]:
    """Return the set of attribute/variable names participating in a comparison."""
    names: set[str] = set()
    if isinstance(node.left, ast.Attribute):
        names.add(f"{_id_or_attr(node.left.value)}.{node.left.attr}")
    elif isinstance(node.left, ast.Name):
        names.add(node.left.id)
    for comparator in node.comparators:
        if isinstance(comparator, ast.Attribute):
            names.add(f"{_id_or_attr(comparator.value)}.{comparator.attr}")
        elif isinstance(comparator, ast.Name):
            names.add(comparator.id)
    return names


def _id_or_attr(node: ast.AST) -> str:
    if isinstance(node, ast.Name):
        return node.id
    if isinstance(node, ast.Attribute):
        return f"{_id_or_attr(node.value)}.{node.attr}"
    return ""


def _find_function(tree: ast.Module, name: str) -> ast.AsyncFunctionDef | None:
    for node in ast.walk(tree):
        if isinstance(node, ast.AsyncFunctionDef) and node.name == name:
            return node
    return None


def _collect_create_telemetry_calls(body: list[ast.stmt]) -> list[tuple[str, ast.Call]]:
    """Collect (variable_name_argument, Call) pairs for repository.create_telemetry."""
    calls: list[tuple[str, ast.Call]] = []
    for node in ast.walk(ast.Module(body=body, type_ignores=[])):
        if not isinstance(node, ast.Call):
            continue
        func = node.func
        if not isinstance(func, ast.Attribute) or func.attr != "create_telemetry":
            continue
        if len(node.args) < 3:
            continue
        name_arg = node.args[2]
        if isinstance(name_arg, ast.Constant) and isinstance(name_arg.value, str):
            calls.append((name_arg.value, node))
    return calls


def _branch_contains_node(branch_body: list[ast.stmt], target: ast.AST) -> bool:
    for node in ast.walk(ast.Module(body=branch_body, type_ignores=[])):
        if node is target:
            return True
    return False


def main() -> int:
    if not SERVICE_PATH.exists():
        print(f"FAIL: service file not found at {SERVICE_PATH}", file=sys.stderr)
        return 1

    source = SERVICE_PATH.read_text(encoding="utf-8")
    tree = ast.parse(source)

    func = _find_function(tree, "complete_exercise")
    if func is None:
        print("FAIL: complete_exercise function not found", file=sys.stderr)
        return 1

    # Verify explicit patient ownership check.
    has_ownership_check = False
    for node in ast.walk(func):
        if isinstance(node, ast.Compare):
            names = _get_compare_names(node)
            if "session.patient_id" in names and "patient_id" in names:
                has_ownership_check = True
                break
    if not has_ownership_check:
        print("FAIL: missing explicit session.patient_id != patient_id ownership check", file=sys.stderr)
        return 1

    # Collect telemetry calls and branches.
    all_calls = _collect_create_telemetry_calls(func.body)
    variable_names = [name for name, _ in all_calls]

    # Identify the already-completed branch and active branch.
    completed_branch_body: list[ast.stmt] = []
    active_path_body: list[ast.stmt] = []
    for stmt in func.body:
        if (
            isinstance(stmt, ast.If)
            and isinstance(stmt.test, ast.Compare)
            and "session.status" in _get_compare_names(stmt.test)
            and any(
                isinstance(c, ast.Constant) and c.value == "completed"
                for c in stmt.test.comparators
            )
        ):
            completed_branch_body = stmt.body
        else:
            active_path_body.append(stmt)

    if not completed_branch_body:
        print("FAIL: missing already-completed early-return branch", file=sys.stderr)
        return 1

    # Ensure no create_telemetry calls are inside the already-completed branch.
    completed_calls = _collect_create_telemetry_calls(completed_branch_body)
    if completed_calls:
        print(
            f"FAIL: already-completed branch contains {len(completed_calls)} telemetry call(s); expected 0",
            file=sys.stderr,
        )
        return 1

    # Ensure exactly four telemetry calls on the active path with the required names.
    active_calls = _collect_create_telemetry_calls(active_path_body)
    active_names = {name for name, _ in active_calls}
    if active_names != REQUIRED_TELEMETRY or len(active_calls) != 4:
        print(
            f"FAIL: active completion path telemetry calls = {variable_names}; expected exactly {sorted(REQUIRED_TELEMETRY)}",
            file=sys.stderr,
        )
        return 1

    # Ensure no telemetry calls anywhere else in the function.
    if len(all_calls) != 4:
        print(
            f"FAIL: total create_telemetry calls in complete_exercise = {len(all_calls)}; expected 4",
            file=sys.stderr,
        )
        return 1

    print("OK: exactly four telemetry variables persisted once on active completion; none on idempotent path; patient ownership enforced")
    return 0


if __name__ == "__main__":
    sys.exit(main())
