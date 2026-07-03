#!/usr/bin/env bash
set -uo pipefail

# Run every test script under tests/ and report a summary.
# Does not use `set -e` so one failing test does not abort the rest.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

failed=0
for test in "$SCRIPT_DIR"/*/*.sh; do
  name="${test#"$SCRIPT_DIR/"}"
  echo "=== $name ==="
  if ! bash "$test"; then
    failed=$((failed + 1))
  fi
  echo
done

if [[ $failed -gt 0 ]]; then
  echo "$failed test file(s) failed."
  exit 1
fi

echo "All test files passed."
