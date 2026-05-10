$ErrorActionPreference = "Stop"

$ProjectRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
Set-Location $ProjectRoot

python -m venv .venv
& ".\.venv\Scripts\python.exe" -m pip install -U pip
& ".\.venv\Scripts\python.exe" -m pip install -e . pyinstaller

Remove-Item -Recurse -Force "build\windows", "dist\windows" -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path "dist" | Out-Null

& ".\.venv\Scripts\python.exe" -m PyInstaller `
  --clean `
  --onefile `
  --noconsole `
  --name CodexPlusPlus `
  --distpath "dist\windows" `
  --workpath "build\windows" `
  --specpath "build\windows" `
  --icon "$ProjectRoot\codex_session_delete\assets\codex-plus-plus.ico" `
  --add-data "$ProjectRoot\codex_session_delete\assets;codex_session_delete\assets" `
  --add-data "$ProjectRoot\codex_session_delete\inject;codex_session_delete\inject" `
  "codex_session_delete\__main__.py"

$ZipPath = "dist\CodexPlusPlus-windows.zip"
Remove-Item -Force $ZipPath -ErrorAction SilentlyContinue
Compress-Archive -Path "dist\windows\CodexPlusPlus.exe" -DestinationPath $ZipPath

Write-Host "Built dist\windows\CodexPlusPlus.exe"
Write-Host "Packed dist\CodexPlusPlus-windows.zip"
