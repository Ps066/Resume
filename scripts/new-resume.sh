#!/usr/bin/env bash
# Create a new resume by copying an existing one as a template.
# Usage:  bash scripts/new-resume.sh backend-engineer

set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: bash scripts/new-resume.sh <name-without-extension>" >&2
  exit 1
fi

NAME="$1"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC_DIR="$ROOT/resumes"
TEMPLATE="$SRC_DIR/main.tex"
TARGET="$SRC_DIR/${NAME}.tex"

[ -f "$TEMPLATE" ] || { echo "Template not found: $TEMPLATE" >&2; exit 1; }
[ -f "$TARGET" ]   && { echo "Already exists: $TARGET" >&2; exit 1; }

cp "$TEMPLATE" "$TARGET"
echo "Created: $TARGET"
echo "Open it in VS Code and edit the role/title at the top."
