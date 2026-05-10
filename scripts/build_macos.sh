#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

python3 -m venv .venv
source .venv/bin/activate

python -m pip install -U pip
python -m pip install -e . pyinstaller

rm -rf build/macos build/macos-icon dist/macos

iconset="build/macos-icon/CodexPlusPlus.iconset"
icns="build/macos-icon/CodexPlusPlus.icns"
png="codex_session_delete/assets/codex-plus-plus.png"
mkdir -p "$iconset" dist

sips -z 16 16 "$png" --out "$iconset/icon_16x16.png" >/dev/null
sips -z 32 32 "$png" --out "$iconset/icon_16x16@2x.png" >/dev/null
sips -z 32 32 "$png" --out "$iconset/icon_32x32.png" >/dev/null
sips -z 64 64 "$png" --out "$iconset/icon_32x32@2x.png" >/dev/null
sips -z 128 128 "$png" --out "$iconset/icon_128x128.png" >/dev/null
sips -z 256 256 "$png" --out "$iconset/icon_128x128@2x.png" >/dev/null
sips -z 256 256 "$png" --out "$iconset/icon_256x256.png" >/dev/null
sips -z 512 512 "$png" --out "$iconset/icon_256x256@2x.png" >/dev/null
sips -z 512 512 "$png" --out "$iconset/icon_512x512.png" >/dev/null
sips -z 1024 1024 "$png" --out "$iconset/icon_512x512@2x.png" >/dev/null
iconutil -c icns "$iconset" -o "$icns"

python -m PyInstaller \
  --clean \
  --onefile \
  --windowed \
  --name CodexPlusPlus \
  --icon "$icns" \
  --distpath dist/macos \
  --workpath build/macos \
  --add-data "codex_session_delete/assets:codex_session_delete/assets" \
  --add-data "codex_session_delete/inject:codex_session_delete/inject" \
  codex_session_delete/__main__.py

codesign --force --deep --sign - dist/macos/CodexPlusPlus.app
ditto -c -k --keepParent dist/macos/CodexPlusPlus.app dist/CodexPlusPlus-macos.zip

echo "Built dist/macos/CodexPlusPlus.app"
echo "Packed dist/CodexPlusPlus-macos.zip"
