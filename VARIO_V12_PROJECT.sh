#!/data/data/com.termux/files/usr/bin/bash
set -e

PROJECT="$HOME/VarioWidget"
SRC="$PROJECT/VarioWidget"
BACKUP="$PROJECT/backup_v1.2"

echo "============================================================"
echo "              VARIO WIDGET v1.2 PROJECT"
echo "============================================================"

mkdir -p "$SRC"
mkdir -p "$BACKUP"

# ------------------------------------------------------------
# Backup
# ------------------------------------------------------------

for f in VarioWidget.swift VarioDataStore.swift VarioGauge.swift
do
    if [ -f "$SRC/$f" ]; then
        cp "$SRC/$f" "$BACKUP/$f"
        echo "BACKUP $f"
    fi
done

# ------------------------------------------------------------
# XcodeGen project description
# ------------------------------------------------------------

cat > "$PROJECT/project.yml" <<'YAML'
name: VarioWidget

options:
  bundleIdPrefix: com.pavel
  deploymentTarget:
    iOS: "17.0"

settings:
  base:
    SWIFT_VERSION: "5.9"
    TARGETED_DEVICE_FAMILY: "1,2"

targets:

  VarioWidget:
    type: application
    platform: iOS

    sources:
      - path: VarioWidget

    settings:
      PRODUCT_BUNDLE_IDENTIFIER: com.pavel.vario
      INFOPLIST_FILE: VarioWidget/Info.plist

    dependencies:
      - target: VarioWidgetExtension

  VarioWidgetExtension:
    type: app-extension
    platform: iOS

    sources:
      - path: VarioWidget

    settings:
      PRODUCT_BUNDLE_IDENTIFIER: com.pavel.vario.widget
      INFOPLIST_FILE: VarioWidget/WidgetInfo.plist

    dependencies: []
YAML

echo "OK   project.yml"

# ------------------------------------------------------------
# Main Info.plist
# ------------------------------------------------------------

cat > "$SRC/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC
"-//Apple//DTD PLIST 1.0//EN"
"https://www.apple.com/DTDs/PropertyList-1.0.dtd">

<plist version="1.0">
<dict>

    <key>CFBundleDisplayName</key>
    <string>VARIO</string>

    <key>CFBundleIdentifier</key>
    <string>com.pavel.vario</string>

    <key>CFBundlePackageType</key>
    <string>APPL</string>

    <key>CFBundleShortVersionString</key>
    <string>1.2</string>

    <key>CFBundleVersion</key>
    <string>12</string>

    <key>LSRequiresIPhoneOS</key>
    <true/>

</dict>
</plist>
PLIST

echo "OK   Info.plist"

# ------------------------------------------------------------
# Widget Info.plist
# ------------------------------------------------------------

cat > "$SRC/WidgetInfo.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC
"-//Apple//DTD PLIST 1.0//EN"
"https://www.apple.com/DTDs/PropertyList-1.0.dtd">

<plist version="1.0">
<dict>

    <key>CFBundleDisplayName</key>
    <string>VARIO Widget</string>

    <key>CFBundleIdentifier</key>
    <string>com.pavel.vario.widget</string>

    <key>CFBundlePackageType</key>
    <string>XPC!</string>

    <key>CFBundleShortVersionString</key>
    <string>1.2</string>

    <key>CFBundleVersion</key>
    <string>12</string>

    <key>NSExtension</key>
    <dict>

        <key>NSExtensionPointIdentifier</key>
        <string>com.apple.widgetkit-extension</string>

        <key>NSExtensionPrincipalClass</key>
        <string>$(PRODUCT_MODULE_NAME).VarioWidgetBundle</string>

    </dict>

</dict>
</plist>
PLIST

echo "OK   WidgetInfo.plist"

# ------------------------------------------------------------
# README
# ------------------------------------------------------------

cat > "$PROJECT/README.md" <<'MD'
# VARIO Widget

Version: 1.2

iOS WidgetKit project for the VARIO flight instrument.

## Features

- Vertical speed
- Altitude
- Pressure
- Temperature
- Battery
- CLIMB
- LEVEL
- DESCENT
- NO DATA
- LIVE / OFFLINE
- -5 ... +5 m/s gauge
- Small Widget
- Medium Widget

## Files

- VarioWidget.swift
- VarioDataStore.swift
- VarioGauge.swift

## Build

The project is prepared in Termux.

Final iOS compilation requires macOS + Xcode.

If XcodeGen is installed on the Mac:

    xcodegen generate

Then open:

    VarioWidget.xcodeproj

## Version

VARIO v1.2
MD

echo "OK   README.md"

# ------------------------------------------------------------
# Project manifest
# ------------------------------------------------------------

cat > "$PROJECT/PROJECT_INFO.txt" <<'TXT'
VARIO iOS WIDGET
=================

Version: 1.2

Bundle:
com.pavel.vario

Widget:
com.pavel.vario.widget

Minimum iOS:
17.0

Families:
systemSmall
systemMedium

Sources:
VarioWidget.swift
VarioDataStore.swift
VarioGauge.swift

Build environment:
Termux preparation
Final build: macOS + Xcode
TXT

echo "OK   PROJECT_INFO.txt"

# ------------------------------------------------------------
# Verification
# ------------------------------------------------------------

echo
echo "===== PROJECT CHECK ====="

FAIL=0

for f in \
    "$PROJECT/project.yml" \
    "$PROJECT/README.md" \
    "$PROJECT/PROJECT_INFO.txt" \
    "$SRC/VarioWidget.swift" \
    "$SRC/VarioDataStore.swift" \
    "$SRC/VarioGauge.swift" \
    "$SRC/Info.plist" \
    "$SRC/WidgetInfo.plist"
do

    if [ -f "$f" ]; then
        echo "OK   $(basename "$f")"
    else
        echo "FAIL $(basename "$f")"
        FAIL=1
    fi

done

echo
echo "===== XCODE CONFIG ====="

grep -q 'com.pavel.vario' \
    "$PROJECT/project.yml" \
    && echo "OK   Main bundle ID" \
    || { echo "FAIL Main bundle ID"; FAIL=1; }

grep -q 'com.pavel.vario.widget' \
    "$PROJECT/project.yml" \
    && echo "OK   Widget bundle ID" \
    || { echo "FAIL Widget bundle ID"; FAIL=1; }

grep -q 'iOS: "17.0"' \
    "$PROJECT/project.yml" \
    && echo "OK   iOS 17 target" \
    || { echo "FAIL iOS target"; FAIL=1; }

grep -q 'VarioWidgetExtension' \
    "$PROJECT/project.yml" \
    && echo "OK   Widget extension" \
    || { echo "FAIL Widget extension"; FAIL=1; }

echo
echo "===== SOURCE CHECK ====="

grep -q 'VarioGauge' \
    "$SRC/VarioWidget.swift" \
    && echo "OK   Gauge" \
    || { echo "FAIL Gauge"; FAIL=1; }

grep -q 'VarioLiveData' \
    "$SRC/VarioWidget.swift" \
    && echo "OK   Data model" \
    || { echo "FAIL Data model"; FAIL=1; }

grep -q 'systemSmall' \
    "$SRC/VarioWidget.swift" \
    && echo "OK   Small widget" \
    || { echo "FAIL Small widget"; FAIL=1; }

grep -q 'systemMedium' \
    "$SRC/VarioWidget.swift" \
    && echo "OK   Medium widget" \
    || { echo "FAIL Medium widget"; FAIL=1; }

echo
echo "===== FILE TREE ====="

find "$PROJECT" -maxdepth 2 -type f | sort

echo
echo "===== SOURCE SIZE ====="

wc -l \
    "$SRC/VarioWidget.swift" \
    "$SRC/VarioDataStore.swift" \
    "$SRC/VarioGauge.swift"

echo
echo "============================================================"

if [ "$FAIL" -eq 0 ]; then
    echo "       ✅ VARIO v1.2 PROJECT: PASS"
else
    echo "       ❌ VARIO v1.2 PROJECT: FAIL"
fi

echo "============================================================"

echo
echo "Project:"
echo "$PROJECT"
