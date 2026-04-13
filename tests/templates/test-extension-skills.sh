#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILLS_DIR="$REPO_ROOT/templates/extensions/skills"

required_files=(
  "README.md"
  "TEMPLATE.md"
  "example-code-review/SKILL.md"
  "example-release-checklist/SKILL.md"
)

required_headings=(
  "## Purpose"
  "## When to use"
  "## Steps"
)

for file in "${required_files[@]}"; do
  if [[ ! -f "$SKILLS_DIR/$file" ]]; then
    echo "FAIL: extension skills module is missing $file"
    exit 1
  fi
done

for skill in \
  "$SKILLS_DIR/example-code-review/SKILL.md" \
  "$SKILLS_DIR/example-release-checklist/SKILL.md"
do
  for heading in "${required_headings[@]}"; do
    if ! grep -q "^${heading}$" "$skill"; then
      echo "FAIL: $(basename "$(dirname "$skill")") skill is missing heading: $heading"
      exit 1
    fi
  done
done

if ! grep -q 'skills_dir: skills' "$SKILLS_DIR/README.md"; then
  echo "FAIL: extension skills README does not mention the existing skills directory"
  exit 1
fi

if ! grep -q 'must not replace it' "$SKILLS_DIR/README.md"; then
  echo "FAIL: extension skills README does not say that skills must not replace the core workflow"
  exit 1
fi

if ! grep -q 'Do not use extra skills to redefine task start, progress updates, closeout, or decomposition.' "$SKILLS_DIR/README.md"; then
  echo "FAIL: extension skills README does not keep lifecycle behavior in core"
  exit 1
fi

echo "PASS: extension skills module is limited to extra workflows beyond the core lifecycle."
