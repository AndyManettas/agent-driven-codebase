#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
EXAMPLE_DIR="$REPO_ROOT/examples/minimal-repo"

required_files=(
  "README.md"
  "SPEC.md"
  "TASKS.yaml"
  "docs/architecture.md"
  "plans/API-001-task-crud.md"
  ".agents/reports/API-001.md"
)

unexpected_files=(
  "AGENTS.md"
  ".agents/manifest.yaml"
  ".agents/reports/TEMPLATE.md"
  "plans/TEMPLATE.md"
  "skills/task-start/SKILL.md"
  "skills/task-progress/SKILL.md"
  "skills/task-closeout/SKILL.md"
  "skills/task-decompose/SKILL.md"
)

for file in "${required_files[@]}"; do
  if [[ ! -f "$EXAMPLE_DIR/$file" ]]; then
    echo "FAIL: minimal overlay is missing $file"
    exit 1
  fi
done

for file in "${unexpected_files[@]}"; do
  if [[ -e "$EXAMPLE_DIR/$file" ]]; then
    echo "FAIL: minimal overlay still duplicates core file $file"
    exit 1
  fi
done

if ! grep -q 'templates/core/' "$EXAMPLE_DIR/README.md"; then
  echo "FAIL: minimal overlay README does not point readers back to templates/core/"
  exit 1
fi

if ! grep -q 'overlay example' "$EXAMPLE_DIR/README.md"; then
  echo "FAIL: minimal overlay README does not describe the example as an overlay"
  exit 1
fi

echo "PASS: minimal example stays an overlay and only owns customized surfaces."
