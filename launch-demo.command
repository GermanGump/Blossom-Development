#!/bin/bash
# Launch Blossom Hubs demo in iPhone 17 Pro Simulator
# Called from the pitch deck's "Greenlight Blossom Hubs" button

PROJECT_DIR="/Users/nsimpson/Documents/GitHub/Blossom-Development/BlossomHubs"
PROJECT="$PROJECT_DIR/BlossomHubs.xcodeproj"
SCHEME="BlossomHubs"
SIMULATOR="iPhone 17 Pro"

echo "🌸 Launching Blossom Hubs Demo..."
echo ""

# Boot simulator if not already running
echo "→ Booting simulator ($SIMULATOR)..."
xcrun simctl boot "$SIMULATOR" 2>/dev/null || true
open -a Simulator

# Build and run
echo "→ Building BlossomHubs..."
xcodebuild \
    -project "$PROJECT" \
    -scheme "$SCHEME" \
    -destination "platform=iOS Simulator,name=$SIMULATOR" \
    -configuration Debug \
    build 2>&1 | tail -5

echo ""
echo "→ Installing and launching app..."

# Find the built app
BUILD_DIR=$(xcodebuild -project "$PROJECT" -scheme "$SCHEME" -showBuildSettings 2>/dev/null | grep " BUILT_PRODUCTS_DIR" | awk '{print $3}')
APP_PATH="$BUILD_DIR/BlossomHubs.app"

if [ -d "$APP_PATH" ]; then
    xcrun simctl install booted "$APP_PATH"
    xcrun simctl launch booted "$(defaults read "$APP_PATH/Info.plist" CFBundleIdentifier 2>/dev/null || echo 'com.blossom.BlossomHubs')"
    echo ""
    echo "✅ Blossom Hubs is running!"
else
    echo "⚠️  Build product not found, falling back to xcodebuild run..."
    xcodebuild \
        -project "$PROJECT" \
        -scheme "$SCHEME" \
        -destination "platform=iOS Simulator,name=$SIMULATOR" \
        -configuration Debug \
        run 2>&1 | tail -3
fi

echo ""
echo "Press any key to close this window..."
read -n 1
