#!/bin/bash

# Script to build AAR from Android library
set -e

echo "🔨 Building AAR for weather_module..."

# Check if gradlew exists, if not, create it
if [ ! -f "gradlew" ]; then
    echo "⚠️  Gradle wrapper not found. Creating..."
    # We'll need gradle installed for this
    gradle wrapper --gradle-version 7.5
fi

# Make gradlew executable
chmod +x gradlew

# Clean previous builds
echo "🧹 Cleaning previous builds..."
./gradlew clean

# Build the release AAR
echo "📦 Building release AAR..."
./gradlew assembleRelease

echo ""
echo "✅ AAR build complete!"
echo ""
echo "📁 AAR file location:"
echo "   $(pwd)/build/outputs/aar/build-release.aar"
echo ""
echo "To build debug AAR, run:"
echo "  ./gradlew assembleDebug"
echo ""

