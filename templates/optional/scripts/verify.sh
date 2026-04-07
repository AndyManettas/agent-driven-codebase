#!/usr/bin/env bash
set -euo pipefail

# Single command to prove a task is shippable.
# Runs all quality gates in sequence.

./scripts/lint.sh
./scripts/typecheck.sh
./scripts/test.sh
./scripts/smoke.sh

echo "All checks passed."
