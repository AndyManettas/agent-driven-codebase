#!/usr/bin/env bash
set -euo pipefail

# Golden test: assert templates/core/ contains exactly the expected files.
# Catches accidental bloat or missing files.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
CORE_DIR="$REPO_ROOT/templates/core"

EXPECTED_FILES=(
  "AGENTS.md"
  "SPEC.md"
  "TASKS.yaml"
  "plans/TEMPLATE.md"
  "docs/architecture.md"
  ".agents/manifest.yaml"
  ".agents/reports/TEMPLATE.md"
)

errors=0

# Check all expected files exist
for file in "${EXPECTED_FILES[@]}"; do
  if [[ ! -f "$CORE_DIR/$file" ]]; then
    echo "FAIL: missing expected file: $file"
    errors=$((errors + 1))
  fi
done

# Check no unexpected files exist
while IFS= read -r actual_file; do
  relative="${actual_file#"$CORE_DIR/"}"
  found=false
  for expected in "${EXPECTED_FILES[@]}"; do
    if [[ "$relative" == "$expected" ]]; then
      found=true
      break
    fi
  done
  if [[ "$found" == "false" ]]; then
    echo "FAIL: unexpected file in core: $relative"
    errors=$((errors + 1))
  fi
done < <(find "$CORE_DIR" -type f | sort)

if [[ $errors -gt 0 ]]; then
  echo ""
  echo "$errors error(s) found."
  exit 1
fi

echo "PASS: core template contains exactly ${#EXPECTED_FILES[@]} expected files."
