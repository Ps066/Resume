# Build one or all resumes (Windows). PDFs land in .\build\
#
# Usage:
#   powershell -File scripts\build.ps1                       # build every *.tex in resumes\
#   powershell -File scripts\build.ps1 full-stack            # build resumes\full-stack.tex
#   powershell -File scripts\build.ps1 resumes\backend.tex   # explicit path also works

param(
  [string]$Target = ""
)

$ErrorActionPreference = "Stop"

$Root   = (Resolve-Path "$PSScriptRoot\..").Path
$SrcDir = Join-Path $Root "resumes"
$OutDir = Join-Path $Root "build"
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

function Compile-One([string]$Tex) {
  $base = [System.IO.Path]::GetFileNameWithoutExtension($Tex)
  Write-Host ""
  Write-Host "==> Building $base" -ForegroundColor Cyan
  Push-Location ([System.IO.Path]::GetDirectoryName($Tex))
  try {
    pdflatex `
      -synctex=1 `
      -interaction=nonstopmode `
      -file-line-error `
      -output-directory="$OutDir" `
      ([System.IO.Path]::GetFileName($Tex)) | Out-Null
  } finally {
    Pop-Location
  }
  Write-Host "    -> $OutDir\$base.pdf"
}

if ([string]::IsNullOrWhiteSpace($Target)) {
  $files = Get-ChildItem -Path $SrcDir -Filter "*.tex" -File
  if ($files.Count -eq 0) {
    Write-Error "No .tex files found in $SrcDir"
    exit 1
  }
  foreach ($f in $files) { Compile-One $f.FullName }
} else {
  if (Test-Path $Target -PathType Leaf) {
    $Tex = (Resolve-Path $Target).Path
  } elseif (Test-Path (Join-Path $SrcDir $Target) -PathType Leaf) {
    $Tex = (Resolve-Path (Join-Path $SrcDir $Target)).Path
  } elseif (Test-Path (Join-Path $SrcDir "$Target.tex") -PathType Leaf) {
    $Tex = (Resolve-Path (Join-Path $SrcDir "$Target.tex")).Path
  } else {
    Write-Error "Could not find: $Target (looked in $SrcDir)"
    exit 1
  }
  Compile-One $Tex
  $Pdf = Join-Path $OutDir "$([System.IO.Path]::GetFileNameWithoutExtension($Tex)).pdf"
  if (Test-Path $Pdf) { Start-Process $Pdf }
}

Write-Host ""
Write-Host "Done. Output: $OutDir\"
