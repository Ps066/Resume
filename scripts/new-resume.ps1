# Create a new resume by copying an existing one as a template.
# Usage:  powershell -File scripts\new-resume.ps1 backend-engineer

param(
  [Parameter(Mandatory=$true)][string]$Name
)

$ErrorActionPreference = "Stop"

$Root     = (Resolve-Path "$PSScriptRoot\..").Path
$SrcDir   = Join-Path $Root "resumes"
$Template = Join-Path $SrcDir "main.tex"
$Target   = Join-Path $SrcDir "$Name.tex"

if (-not (Test-Path $Template)) { Write-Error "Template not found: $Template"; exit 1 }
if (Test-Path $Target)           { Write-Error "Already exists: $Target";       exit 1 }

Copy-Item $Template $Target
Write-Host "Created: $Target"
Write-Host "Open it in VS Code and edit the role/title at the top."
