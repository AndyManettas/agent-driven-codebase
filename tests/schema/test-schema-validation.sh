#!/usr/bin/env bash
set -euo pipefail

# Schema tests: validate YAML files parse cleanly and match expected structure.
# Uses basic checks — for full JSON Schema validation, use a tool like ajv-cli.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

errors=0

# Check that all YAML files parse
yaml_files=(
  "templates/core/TASKS.yaml"
  "templates/core/.agents/manifest.yaml"
  "examples/minimal-repo/TASKS.yaml"
  "examples/minimal-repo/.agents/manifest.yaml"
  "examples/before-after/after/TASKS.yaml"
  "examples/before-after/after/.agents/manifest.yaml"
)

for file in "${yaml_files[@]}"; do
  filepath="$REPO_ROOT/$file"
  if [[ ! -f "$filepath" ]]; then
    echo "FAIL: YAML file not found: $file"
    errors=$((errors + 1))
    continue
  fi

  # YAML syntax check: try python3+PyYAML, then ruby, then skip
  if python3 -c "import yaml" 2>/dev/null; then
    if ! python3 -c "import yaml; yaml.safe_load(open('$filepath'))" 2>/dev/null; then
      echo "FAIL: YAML parse error: $file"
      errors=$((errors + 1))
    else
      echo "PASS: $file parses cleanly"
    fi
  elif command -v ruby &>/dev/null; then
    if ! ruby -ryaml -e "YAML.safe_load(File.read('$filepath'))" 2>/dev/null; then
      echo "FAIL: YAML parse error: $file"
      errors=$((errors + 1))
    else
      echo "PASS: $file parses cleanly"
    fi
  else
    echo "SKIP: $file (no YAML parser available — install PyYAML or use Ruby)"
  fi
done

# Check TASKS.yaml has required top-level keys
for tasks_file in "templates/core/TASKS.yaml" "examples/minimal-repo/TASKS.yaml"; do
  filepath="$REPO_ROOT/$tasks_file"
  if [[ -f "$filepath" ]]; then
    for key in "version" "status_values" "tasks"; do
      if ! grep -q "^${key}:" "$filepath"; then
        echo "FAIL: $tasks_file missing required key: $key"
        errors=$((errors + 1))
      fi
    done
  fi
done

# Check manifest.yaml has required top-level keys
for manifest_file in "templates/core/.agents/manifest.yaml" "examples/minimal-repo/.agents/manifest.yaml"; do
  filepath="$REPO_ROOT/$manifest_file"
  if [[ -f "$filepath" ]]; then
    for key in "version" "entrypoints" "task_registry"; do
      if ! grep -q "^${key}:" "$filepath"; then
        echo "FAIL: $manifest_file missing required key: $key"
        errors=$((errors + 1))
      fi
    done
  fi
done

if [[ $errors -gt 0 ]]; then
  echo ""
  echo "$errors error(s) found."
  exit 1
fi

echo ""
echo "All schema checks passed."
