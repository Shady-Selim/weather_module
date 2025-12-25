#!/bin/bash

# Script to build AAR from Flutter module
# Make sure Flutter is installed and in your PATH

set -e

echo "🔨 Building AAR for weather_module..."

# Change to the android directory
cd android

# Clean previous builds
./gradlew clean

# Build the AAR
echo "📦 Building AAR..."
./gradlew :build

# The AAR will be located at:
# android/build/outputs/aar/build-release.aar
# or for debug:
# android/build/outputs/aar/build-debug.aar

echo ""
echo "✅ AAR build complete!"
echo ""
echo "📁 AAR files location:"
echo "   Debug: $(pwd)/build/outputs/aar/build-debug.aar"
echo "   Release: $(pwd)/build/outputs/aar/build-release.aar"
echo ""
echo "To build release AAR, run:"
echo "  cd android && ./gradlew assembleRelease"
echo ""

