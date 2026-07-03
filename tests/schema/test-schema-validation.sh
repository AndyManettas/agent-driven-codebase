#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

if ! python3 -c "import yaml" >/dev/null 2>&1; then
  echo "FAIL: tests/schema/test-schema-validation.sh requires python3 with PyYAML (pip install pyyaml)."
  exit 1
fi

python3 - "$REPO_ROOT" <<'PY'
from pathlib import Path
import json
import re
import sys
import yaml

repo_root = Path(sys.argv[1])

# Constraints are read from the schemas, so this test follows the schema as the
# single source of truth instead of hard-coding allowed values here.
tasks_schema = json.loads((repo_root / "schemas/tasks.schema.json").read_text())
manifest_schema = json.loads((repo_root / "schemas/manifest.schema.json").read_text())

task_item = tasks_schema["properties"]["tasks"]["items"]
task_props = task_item["properties"]
task_required = set(task_item["required"])
task_allowed = set(task_props.keys())
tasks_version = tasks_schema["properties"]["version"]["const"]

manifest_required = set(manifest_schema["required"])
manifest_allowed = set(manifest_schema["properties"].keys())
manifest_version = manifest_schema["properties"]["version"]["const"]

errors = []


def fail(message):
    errors.append(message)


def load_yaml(path):
    try:
        return yaml.safe_load(path.read_text())
    except Exception as exc:
        fail(f"FAIL: YAML parse error in {path.relative_to(repo_root)}: {exc}")
        return None


def check_enum(label, field, value):
    enum = task_props[field].get("enum")
    if enum is not None and value not in enum:
        fail(f"FAIL: {label} has invalid {field}: {value!r} (allowed: {sorted(enum)})")


def check_pattern(label, field, value):
    pattern = task_props[field].get("pattern")
    if pattern is not None and (not isinstance(value, str) or not re.match(pattern, value)):
        fail(f"FAIL: {label} {field} does not match {pattern}: {value!r}")


def validate_task_file(rel_path):
    path = repo_root / rel_path
    if not path.exists():
        fail(f"FAIL: YAML file not found: {rel_path}")
        return

    data = load_yaml(path)
    if data is None:
        return

    print(f"PASS: {rel_path} parses cleanly")

    missing = {"version", "status_values", "tasks"} - set(data.keys())
    if missing:
        fail(f"FAIL: {rel_path} missing top-level keys: {sorted(missing)}")
        return
    if data.get("version") != tasks_version:
        fail(f"FAIL: {rel_path} version must be {tasks_version}, got {data.get('version')!r}")

    for index, task in enumerate(data["tasks"], start=1):
        label = f"{rel_path} task #{index}"
        task_keys = set(task.keys())

        missing_keys = task_required - task_keys
        extra_keys = task_keys - task_allowed
        if missing_keys:
            fail(f"FAIL: {label} missing keys: {sorted(missing_keys)}")
        if extra_keys:
            fail(f"FAIL: {label} has unexpected keys: {sorted(extra_keys)}")

        for field in ("status", "priority", "size"):
            if field in task:
                check_enum(label, field, task[field])

        for field in ("id", "parent"):
            if field in task:
                check_pattern(label, field, task[field])

        deps = task.get("deps")
        if isinstance(deps, list):
            for dep in deps:
                check_pattern(label, "deps", dep)

        for field in ("files", "acceptance", "verify"):
            value = task.get(field)
            if not isinstance(value, list) or not value or not all(isinstance(item, str) and item for item in value):
                fail(f"FAIL: {label} must define non-empty string entries for {field}")

        for field in ("plan", "report"):
            value = task.get(field)
            if not isinstance(value, str) or not value:
                fail(f"FAIL: {label} must define {field} as a non-empty string")
                continue
            if not (path.parent / value).exists():
                fail(f"FAIL: {label} points {field} at missing file: {value}")


def validate_manifest_file(rel_path):
    path = repo_root / rel_path
    if not path.exists():
        fail(f"FAIL: YAML file not found: {rel_path}")
        return

    data = load_yaml(path)
    if data is None:
        return

    print(f"PASS: {rel_path} parses cleanly")

    keys = set(data.keys())
    missing = manifest_required - keys
    extra = keys - manifest_allowed
    if missing:
        fail(f"FAIL: {rel_path} missing keys: {sorted(missing)}")
    if extra:
        fail(f"FAIL: {rel_path} has unexpected keys: {sorted(extra)}")
    if data.get("version") != manifest_version:
        fail(f"FAIL: {rel_path} version must be {manifest_version}, got {data.get('version')!r}")

    entrypoints = data.get("entrypoints")
    if not isinstance(entrypoints, list) or not entrypoints:
        fail(f"FAIL: {rel_path} must define a non-empty entrypoints list")
    else:
        for entrypoint in entrypoints:
            if not (path.parent.parent / entrypoint).exists():
                fail(f"FAIL: {rel_path} points entrypoint at missing file: {entrypoint}")

    for field in ("task_registry", "plans_dir", "reports_dir", "skills_dir"):
        value = data.get(field)
        if not isinstance(value, str) or not value:
            fail(f"FAIL: {rel_path} must define {field} as a non-empty string")
            continue
        if not (path.parent.parent / value).exists():
            fail(f"FAIL: {rel_path} points {field} at missing path: {value}")


for rel_path in ("templates/core/TASKS.yaml", "examples/minimal-repo/TASKS.yaml"):
    validate_task_file(rel_path)

validate_manifest_file("templates/core/.agents/manifest.yaml")

if errors:
    print()
    for message in errors:
        print(message)
    print()
    print(f"{len(errors)} error(s) found.")
    raise SystemExit(1)

print()
print("All schema checks passed.")
PY
