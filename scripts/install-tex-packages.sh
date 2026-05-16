#!/usr/bin/env bash
# Install LaTeX packages required by main.tex via tlmgr.
# Needs sudo because TeX Live lives under /usr/local/texlive.
# Run:  bash scripts/install-tex-packages.sh

set -euo pipefail

if ! command -v tlmgr >/dev/null 2>&1; then
  echo "tlmgr not found. Install MacTeX or BasicTeX first (scripts/setup-mac.sh)." >&2
  exit 1
fi

echo "==> Updating tlmgr itself..."
sudo tlmgr update --self

echo "==> Installing packages required by main.tex..."
sudo tlmgr install \
  titlesec \
  marvosym \
  fontawesome5 \
  enumitem \
  multicol \
  ragged2e \
  tabularx \
  fancyhdr \
  preprint \
  latexsym \
  setspace \
  xcolor \
  hyperref \
  babel-english

echo "==> Done. You can now compile main.tex."
