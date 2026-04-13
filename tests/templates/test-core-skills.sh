#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILLS_DIR="$REPO_ROOT/templates/core/skills"

required_files=(
  "task-start/SKILL.md"
  "task-progress/SKILL.md"
  "task-closeout/SKILL.md"
  "task-decompose/SKILL.md"
)

required_headings=(
  "## When to use"
  "## Read first"
  "## Actions"
  "## Update surfaces"
  "## Output"
)

for file in "${required_files[@]}"; do
  if [[ ! -f "$SKILLS_DIR/$file" ]]; then
    echo "FAIL: core skills are missing $file"
    exit 1
  fi
done

for skill in \
  "$SKILLS_DIR/task-start/SKILL.md" \
  "$SKILLS_DIR/task-progress/SKILL.md" \
  "$SKILLS_DIR/task-closeout/SKILL.md" \
  "$SKILLS_DIR/task-decompose/SKILL.md"
do
  if ! grep -q '^---$' "$skill"; then
    echo "FAIL: $(basename "$(dirname "$skill")") core skill is missing YAML frontmatter"
    exit 1
  fi

  for heading in "${required_headings[@]}"; do
    if ! grep -q "^${heading}$" "$skill"; then
      echo "FAIL: $(basename "$(dirname "$skill")") core skill is missing heading: $heading"
      exit 1
    fi
  done
done

echo "PASS: core lifecycle skills exist and expose the required workflow sections."
