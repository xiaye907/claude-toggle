#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
APP_NAME="ClaudeToggle"
APP_DIR="${PROJECT_DIR}/${APP_NAME}.app"
SRC="${SCRIPT_DIR}/src"
BUILD="${SCRIPT_DIR}/build"

echo "=== Building ${APP_NAME} ==="

# Kill running instance
pkill -x ClaudeToggle 2>/dev/null || true
sleep 0.3

# Clean
rm -rf "${APP_DIR}" "${BUILD}"
mkdir -p "${BUILD}"

# --- Step 1: Generate app icon ---
echo "[1/3] Generating app icon..."
swiftc -framework Cocoa -O \
    "${SRC}/GenerateIcon.swift" \
    -o "${BUILD}/generate-icon"
"${BUILD}/generate-icon" "${BUILD}"

# --- Step 2: Compile app ---
echo "[2/3] Compiling..."
swiftc -framework Cocoa -O \
    "${SRC}/ClaudeToggle.swift" \
    -o "${BUILD}/${APP_NAME}"

# --- Step 3: Assemble .app bundle ---
echo "[3/3] Packaging .app..."
mkdir -p "${APP_DIR}/Contents/MacOS"
mkdir -p "${APP_DIR}/Contents/Resources"

cp "${BUILD}/${APP_NAME}"    "${APP_DIR}/Contents/MacOS/"
cp "${SRC}/Info.plist"       "${APP_DIR}/Contents/"
cp "${BUILD}/AppIcon.icns"   "${APP_DIR}/Contents/Resources/"

# Remove quarantine
xattr -cr "${APP_DIR}" 2>/dev/null || true

# Cleanup
rm -rf "${BUILD}"

echo ""
echo "✅ ${APP_DIR}"
echo ""
echo "双击启动 → 顶栏盾牌图标"
echo "开机自启 → 系统设置 → 通用 → 登录项"
