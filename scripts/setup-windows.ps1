# One-shot setup for LaTeX live-preview on Windows.
# Installs: MiKTeX, VS Code, LaTeX Workshop extension.
# Run in PowerShell (Admin recommended for system-wide installs):
#   powershell -ExecutionPolicy Bypass -File scripts\setup-windows.ps1

$ErrorActionPreference = "Stop"

function Info($m) { Write-Host $m -ForegroundColor Cyan }
function Ok($m)   { Write-Host $m -ForegroundColor Green }
function Warn($m) { Write-Host $m -ForegroundColor Yellow }
function Fail($m) { Write-Host $m -ForegroundColor Red }

Info "==> Windows LaTeX environment setup"

# 1. winget
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
  Fail "winget is not available. Install 'App Installer' from the Microsoft Store and re-run."
  exit 1
}
Ok "winget: OK"

# 2. MiKTeX (auto-installs LaTeX packages on demand)
if (-not (Get-Command pdflatex -ErrorAction SilentlyContinue)) {
  Warn "Installing MiKTeX..."
  winget install --id MiKTeX.MiKTeX -e --silent --accept-source-agreements --accept-package-agreements
} else {
  Ok "pdflatex: OK"
}

# 3. VS Code
if (-not (Get-Command code -ErrorAction SilentlyContinue)) {
  Warn "Installing Visual Studio Code..."
  winget install --id Microsoft.VisualStudioCode -e --silent --accept-source-agreements --accept-package-agreements
} else {
  Ok "VS Code: OK"
}

# Refresh PATH so 'code' and 'pdflatex' resolve in this session
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
            [System.Environment]::GetEnvironmentVariable("Path", "User")

# 4. LaTeX Workshop extension
if (Get-Command code -ErrorAction SilentlyContinue) {
  Warn "Installing LaTeX Workshop extension..."
  code --install-extension james-yu.latex-workshop --force
  Ok "LaTeX Workshop: installed"
} else {
  Warn "'code' CLI not found in current shell. Close & reopen PowerShell, then run:"
  Warn "  code --install-extension james-yu.latex-workshop --force"
}

# 5. Tell MiKTeX to install missing packages automatically (no popup)
$miktexInit = Get-Command initexmf -ErrorAction SilentlyContinue
if ($miktexInit) {
  Warn "Configuring MiKTeX to auto-install missing packages..."
  & initexmf --set-config-value "[MPM]AutoInstall=1" | Out-Null
  Ok "MiKTeX auto-install: enabled"
}

Ok "==> Done."
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Open the project:    code ."
Write-Host "  2. Open main.tex. PDF preview opens in a tab and updates on save."
Write-Host "  3. Build: Ctrl+Alt+B   |   Toggle preview: Ctrl+Alt+V"
Write-Host "  4. Manual one-off build:  powershell -File scripts\build.ps1"
