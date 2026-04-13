#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

cp -R "$REPO_ROOT/templates/core/." "$TMP_DIR/"

required_files=(
  "AGENTS.md"
  "SPEC.md"
  "TASKS.yaml"
  "plans/TEMPLATE.md"
  "docs/architecture.md"
  ".agents/manifest.yaml"
  ".agents/reports/TEMPLATE.md"
  "skills/task-start/SKILL.md"
  "skills/task-progress/SKILL.md"
  "skills/task-closeout/SKILL.md"
  "skills/task-decompose/SKILL.md"
)

for file in "${required_files[@]}"; do
  if [[ ! -e "$TMP_DIR/$file" ]]; then
    echo "FAIL: copied core is missing $file"
    exit 1
  fi
done

if ! grep -q 'TASKS.yaml' "$TMP_DIR/AGENTS.md"; then
  echo "FAIL: copied AGENTS.md does not reference TASKS.yaml"
  exit 1
fi

if ! grep -q 'docs/architecture.md' "$TMP_DIR/AGENTS.md"; then
  echo "FAIL: copied AGENTS.md does not reference docs/architecture.md"
  exit 1
fi

if ! grep -q '.agents/reports/TEMPLATE.md' "$TMP_DIR/AGENTS.md"; then
  echo "FAIL: copied AGENTS.md does not reference the report template"
  exit 1
fi

if ! grep -q 'skills/task-start/SKILL.md' "$TMP_DIR/AGENTS.md"; then
  echo "FAIL: copied AGENTS.md does not reference the task-start core skill"
  exit 1
fi

if ! grep -q '^skills_dir: skills$' "$TMP_DIR/.agents/manifest.yaml"; then
  echo "FAIL: copied manifest does not wire the core skills directory"
  exit 1
fi

echo "PASS: copying templates/core/ into an empty directory produces a self-consistent core."
