#!/usr/bin/env bash
set -euo pipefail

# Docs test: verify all markdown links in README.md and docs/ resolve to real files.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

errors=0

check_links_in_file() {
  local file="$1"
  local dir
  dir="$(dirname "$file")"

  # Extract markdown links: [text](path) — skip URLs and anchors
  while IFS= read -r link; do
    # Skip URLs
    if [[ "$link" =~ ^https?:// ]] || [[ "$link" =~ ^mailto: ]]; then
      continue
    fi
    # Strip anchor fragments
    link="${link%%#*}"
    # Skip empty links
    if [[ -z "$link" ]]; then
      continue
    fi

    # Resolve relative to file's directory
    local target
    if [[ "$link" == /* ]]; then
      target="$REPO_ROOT$link"
    else
      target="$dir/$link"
    fi

    # Normalize path
    target="$(cd "$(dirname "$target")" 2>/dev/null && echo "$(pwd)/$(basename "$target")")" 2>/dev/null || true

    if [[ ! -e "$target" ]]; then
      echo "FAIL: broken link in $(basename "$file"): $link"
      errors=$((errors + 1))
    fi
  done < <(grep -oP '\[.*?\]\(\K[^)]+' "$file" 2>/dev/null || true)
}

# Check README.md
check_links_in_file "$REPO_ROOT/README.md"

# Check all docs
for doc in "$REPO_ROOT"/docs/*.md; do
  if [[ -f "$doc" ]]; then
    check_links_in_file "$doc"
  fi
done

if [[ $errors -gt 0 ]]; then
  echo ""
  echo "$errors broken link(s) found."
  exit 1
fi

echo "PASS: all links in README.md and docs/ resolve to real files."
