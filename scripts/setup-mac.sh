#!/usr/bin/env bash
# One-shot setup for LaTeX live-preview on macOS.
# Installs: Homebrew (if missing), MacTeX (no GUI), VS Code, LaTeX Workshop ext.
# Run:  bash scripts/setup-mac.sh

set -euo pipefail

cyan()  { printf "\033[1;36m%s\033[0m\n" "$*"; }
green() { printf "\033[1;32m%s\033[0m\n" "$*"; }
yellow(){ printf "\033[1;33m%s\033[0m\n" "$*"; }
red()   { printf "\033[1;31m%s\033[0m\n" "$*"; }

cyan "==> macOS LaTeX environment setup"

# 1. Homebrew
if ! command -v brew >/dev/null 2>&1; then
  yellow "Homebrew not found. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Add brew to PATH for current shell (Apple Silicon vs Intel)
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
else
  green "Homebrew: OK ($(brew --version | head -1))"
fi

# 2. MacTeX (no GUI variant ~2GB; full MacTeX is ~5GB and not needed here)
if ! command -v pdflatex >/dev/null 2>&1; then
  yellow "Installing MacTeX (no GUI). This is ~2GB, will take a while..."
  brew install --cask mactex-no-gui
  # Make TeX tools visible in this shell session
  eval "$(/usr/libexec/path_helper)"
  export PATH="/Library/TeX/texbin:$PATH"
else
  green "pdflatex: OK ($(pdflatex --version | head -1))"
fi

# 3. VS Code
if ! command -v code >/dev/null 2>&1; then
  if [ -d "/Applications/Visual Studio Code.app" ]; then
    yellow "VS Code app installed but 'code' CLI is not on PATH."
    yellow "Open VS Code → Cmd+Shift+P → 'Shell Command: Install code command in PATH'."
  else
    yellow "Installing Visual Studio Code..."
    brew install --cask visual-studio-code
  fi
else
  green "VS Code: OK"
fi

# 4. LaTeX Workshop extension
if command -v code >/dev/null 2>&1; then
  yellow "Installing LaTeX Workshop extension..."
  code --install-extension james-yu.latex-workshop --force
  green "LaTeX Workshop: installed"
else
  red "Skipping extension install: 'code' CLI not available. Install it then re-run."
fi

green "==> Done."
echo
echo "Next steps:"
echo "  1. Open the project:  code \"$(cd "$(dirname "$0")/.." && pwd)\""
echo "  2. Open main.tex. PDF preview opens in a new tab and updates on save."
echo "  3. Build: Cmd+Option+B (⌘⌥B)    |    Toggle preview: Cmd+Option+V (⌘⌥V)"
echo "  4. Manual one-off build:  bash scripts/build.sh"
