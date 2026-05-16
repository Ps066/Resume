#!/usr/bin/env bash
# Build one or all resumes (macOS/Linux). PDFs land in ./build/
#
# Usage:
#   bash scripts/build.sh                       # build every *.tex in resumes/
#   bash scripts/build.sh full-stack            # build resumes/full-stack.tex
#   bash scripts/build.sh resumes/backend.tex   # explicit path also works

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC_DIR="$ROOT/resumes"
OUT_DIR="$ROOT/build"
mkdir -p "$OUT_DIR"

compile_one() {
  local tex="$1"
  local base
  base="$(basename "$tex" .tex)"
  echo ""
  echo "==> Building $base"
  ( cd "$(dirname "$tex")" && pdflatex \
      -synctex=1 \
      -interaction=nonstopmode \
      -file-line-error \
      -output-directory="$OUT_DIR" \
      "$(basename "$tex")" >/dev/null )
  echo "    -> $OUT_DIR/$base.pdf"
}

if [ $# -eq 0 ]; then
  shopt -s nullglob
  files=( "$SRC_DIR"/*.tex )
  if [ ${#files[@]} -eq 0 ]; then
    echo "No .tex files found in $SRC_DIR" >&2
    exit 1
  fi
  for f in "${files[@]}"; do compile_one "$f"; done
else
  arg="$1"
  # Allow bare name, name.tex, or path
  if [ -f "$arg" ]; then
    tex="$arg"
  elif [ -f "$SRC_DIR/$arg" ]; then
    tex="$SRC_DIR/$arg"
  elif [ -f "$SRC_DIR/$arg.tex" ]; then
    tex="$SRC_DIR/$arg.tex"
  else
    echo "Could not find: $arg (looked in $SRC_DIR)" >&2
    exit 1
  fi
  compile_one "$tex"
  open "$OUT_DIR/$(basename "$tex" .tex).pdf" 2>/dev/null || true
fi

echo ""
echo "Done. Output: $OUT_DIR/"
