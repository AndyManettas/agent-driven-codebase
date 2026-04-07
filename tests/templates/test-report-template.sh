#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPORT_TEMPLATE="$REPO_ROOT/templates/core/.agents/reports/TEMPLATE.md"

required_headings=(
  "### Completed"
  "### Remaining"
  "### Files changed"
  "### Commands run"
  "### Results"
  "### Blockers"
  "### Next best step"
)

for heading in "${required_headings[@]}"; do
  if ! grep -q "^${heading}$" "$REPORT_TEMPLATE"; then
    echo "FAIL: report template is missing heading: $heading"
    exit 1
  fi
done

echo "PASS: report template includes all required headings."
