#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

if python3 -c "import yaml" >/dev/null 2>&1; then
python3 - "$REPO_ROOT" <<'PY'
from pathlib import Path
import json
import sys
import yaml

repo_root = Path(sys.argv[1])

tasks_schema = json.loads((repo_root / "schemas/tasks.schema.json").read_text())
manifest_schema = json.loads((repo_root / "schemas/manifest.schema.json").read_text())

task_required = set(tasks_schema["properties"]["tasks"]["items"]["required"])
task_allowed = set(tasks_schema["properties"]["tasks"]["items"]["properties"].keys())
task_statuses = set(tasks_schema["properties"]["tasks"]["items"]["properties"]["status"]["enum"])
task_priorities = set(tasks_schema["properties"]["tasks"]["items"]["properties"]["priority"]["enum"])

manifest_required = set(manifest_schema["required"])
manifest_allowed = set(manifest_schema["properties"].keys())

errors = []


def fail(message: str) -> None:
    errors.append(message)


def load_yaml(path: Path):
    try:
        return yaml.safe_load(path.read_text())
    except Exception as exc:
        fail(f"FAIL: YAML parse error in {path.relative_to(repo_root)}: {exc}")
        return None


def validate_task_file(rel_path: str) -> None:
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

    for index, task in enumerate(data["tasks"], start=1):
        task_keys = set(task.keys())
        missing_task_keys = task_required - task_keys
        extra_task_keys = task_keys - task_allowed
        label = f"{rel_path} task #{index}"

        if missing_task_keys:
            fail(f"FAIL: {label} missing keys: {sorted(missing_task_keys)}")
        if extra_task_keys:
            fail(f"FAIL: {label} has unexpected keys: {sorted(extra_task_keys)}")

        if task.get("status") not in task_statuses:
            fail(f"FAIL: {label} has invalid status: {task.get('status')}")
        if task.get("priority") not in task_priorities:
            fail(f"FAIL: {label} has invalid priority: {task.get('priority')}")

        for field in ("files", "acceptance", "verify"):
            value = task.get(field)
            if not isinstance(value, list) or not value or not all(isinstance(item, str) and item for item in value):
                fail(f"FAIL: {label} must define non-empty string entries for {field}")

        for field in ("plan", "report"):
            value = task.get(field)
            if not isinstance(value, str) or not value:
                fail(f"FAIL: {label} must define {field} as a non-empty string")
                continue
            target = path.parent / value
            if not target.exists():
                fail(f"FAIL: {label} points {field} at missing file: {value}")


def validate_manifest_file(rel_path: str) -> None:
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

    entrypoints = data.get("entrypoints")
    if not isinstance(entrypoints, list) or not entrypoints:
        fail(f"FAIL: {rel_path} must define a non-empty entrypoints list")
    else:
        for entrypoint in entrypoints:
            target = path.parent.parent / entrypoint
            if not target.exists():
                fail(f"FAIL: {rel_path} points entrypoint at missing file: {entrypoint}")

    for field in ("task_registry", "plans_dir", "reports_dir"):
        value = data.get(field)
        if not isinstance(value, str) or not value:
            fail(f"FAIL: {rel_path} must define {field} as a non-empty string")
            continue
        target = path.parent.parent / value
        if not target.exists():
            fail(f"FAIL: {rel_path} points {field} at missing path: {value}")

    skills_dir = data.get("skills_dir")
    if skills_dir:
        target = path.parent.parent / skills_dir
        if not target.exists():
            fail(f"FAIL: {rel_path} points skills_dir at missing path: {skills_dir}")


task_files = [
    "templates/core/TASKS.yaml",
    "examples/minimal-repo/TASKS.yaml",
]

manifest_files = [
    "templates/core/.agents/manifest.yaml",
]

for rel_path in task_files:
    validate_task_file(rel_path)

for rel_path in manifest_files:
    validate_manifest_file(rel_path)

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
elif command -v ruby >/dev/null 2>&1; then
ruby - "$REPO_ROOT" <<'RUBY'
require "json"
require "set"
require "yaml"
require "pathname"

repo_root = Pathname.new(ARGV[0])

tasks_schema = JSON.parse((repo_root + "schemas/tasks.schema.json").read)
manifest_schema = JSON.parse((repo_root + "schemas/manifest.schema.json").read)

task_required = tasks_schema.dig("properties", "tasks", "items", "required").to_set
task_allowed = tasks_schema.dig("properties", "tasks", "items", "properties").keys.to_set
task_statuses = tasks_schema.dig("properties", "tasks", "items", "properties", "status", "enum").to_set
task_priorities = tasks_schema.dig("properties", "tasks", "items", "properties", "priority", "enum").to_set

manifest_required = manifest_schema["required"].to_set
manifest_allowed = manifest_schema["properties"].keys.to_set

errors = []

def fail(errors, message)
  errors << message
end

def load_yaml(errors, repo_root, path)
  YAML.safe_load(path.read, permitted_classes: [], aliases: false)
rescue StandardError => e
  fail(errors, "FAIL: YAML parse error in #{path.relative_path_from(repo_root)}: #{e.message}")
  nil
end

def validate_task_file(errors, repo_root, rel_path, task_required, task_allowed, task_statuses, task_priorities)
  path = repo_root + rel_path
  unless path.exist?
    fail(errors, "FAIL: YAML file not found: #{rel_path}")
    return
  end

  data = load_yaml(errors, repo_root, path)
  return if data.nil?

  puts "PASS: #{rel_path} parses cleanly"

  missing = ["version", "status_values", "tasks"].to_set - data.keys.to_set
  unless missing.empty?
    fail(errors, "FAIL: #{rel_path} missing top-level keys: #{missing.to_a.sort}")
    return
  end

  data["tasks"].each_with_index do |task, index|
    task_keys = task.keys.to_set
    missing_task_keys = task_required - task_keys
    extra_task_keys = task_keys - task_allowed
    label = "#{rel_path} task ##{index + 1}"

    fail(errors, "FAIL: #{label} missing keys: #{missing_task_keys.to_a.sort}") unless missing_task_keys.empty?
    fail(errors, "FAIL: #{label} has unexpected keys: #{extra_task_keys.to_a.sort}") unless extra_task_keys.empty?

    fail(errors, "FAIL: #{label} has invalid status: #{task['status']}") unless task_statuses.include?(task["status"])
    fail(errors, "FAIL: #{label} has invalid priority: #{task['priority']}") unless task_priorities.include?(task["priority"])

    %w[files acceptance verify].each do |field|
      value = task[field]
      valid = value.is_a?(Array) && !value.empty? && value.all? { |item| item.is_a?(String) && !item.empty? }
      fail(errors, "FAIL: #{label} must define non-empty string entries for #{field}") unless valid
    end

    %w[plan report].each do |field|
      value = task[field]
      unless value.is_a?(String) && !value.empty?
        fail(errors, "FAIL: #{label} must define #{field} as a non-empty string")
        next
      end

      target = path.dirname + value
      fail(errors, "FAIL: #{label} points #{field} at missing file: #{value}") unless target.exist?
    end
  end
end

def validate_manifest_file(errors, repo_root, rel_path, manifest_required, manifest_allowed)
  path = repo_root + rel_path
  unless path.exist?
    fail(errors, "FAIL: YAML file not found: #{rel_path}")
    return
  end

  data = load_yaml(errors, repo_root, path)
  return if data.nil?

  puts "PASS: #{rel_path} parses cleanly"

  keys = data.keys.to_set
  missing = manifest_required - keys
  extra = keys - manifest_allowed
  fail(errors, "FAIL: #{rel_path} missing keys: #{missing.to_a.sort}") unless missing.empty?
  fail(errors, "FAIL: #{rel_path} has unexpected keys: #{extra.to_a.sort}") unless extra.empty?

  entrypoints = data["entrypoints"]
  if !entrypoints.is_a?(Array) || entrypoints.empty?
    fail(errors, "FAIL: #{rel_path} must define a non-empty entrypoints list")
  else
    entrypoints.each do |entrypoint|
      target = path.dirname.dirname + entrypoint
      fail(errors, "FAIL: #{rel_path} points entrypoint at missing file: #{entrypoint}") unless target.exist?
    end
  end

  %w[task_registry plans_dir reports_dir].each do |field|
    value = data[field]
    unless value.is_a?(String) && !value.empty?
      fail(errors, "FAIL: #{rel_path} must define #{field} as a non-empty string")
      next
    end

    target = path.dirname.dirname + value
    fail(errors, "FAIL: #{rel_path} points #{field} at missing path: #{value}") unless target.exist?
  end

  if data["skills_dir"]
    target = path.dirname.dirname + data["skills_dir"]
    fail(errors, "FAIL: #{rel_path} points skills_dir at missing path: #{data['skills_dir']}") unless target.exist?
  end
end

task_files = [
  "templates/core/TASKS.yaml",
  "examples/minimal-repo/TASKS.yaml"
]

manifest_files = [
  "templates/core/.agents/manifest.yaml"
]

task_files.each do |rel_path|
  validate_task_file(errors, repo_root, rel_path, task_required, task_allowed, task_statuses, task_priorities)
end

manifest_files.each do |rel_path|
  validate_manifest_file(errors, repo_root, rel_path, manifest_required, manifest_allowed)
end

unless errors.empty?
  puts
  errors.each { |message| puts message }
  puts
  puts "#{errors.length} error(s) found."
  exit 1
end

puts
puts "All schema checks passed."
RUBY
else
  echo "FAIL: tests/schema/test-schema-validation.sh requires either python3 with PyYAML or ruby."
  exit 1
fi
