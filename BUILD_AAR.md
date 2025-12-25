# Building AAR from Weather Module

## Prerequisites
- Android SDK installed
- Java JDK 8 or higher
- Gradle (will use wrapper if available)

## Quick Start

### Method 1: Using Gradle Wrapper (Recommended)

1. First, initialize Gradle wrapper (if not already present):
```bash
cd weather_module/android
gradle wrapper --gradle-version 7.5
```

2. Build the AAR:
```bash
cd weather_module/android
./gradlew assembleRelease
```

The AAR will be generated at:
- `android/build/outputs/aar/build-release.aar`

For debug version:
```bash
./gradlew assembleDebug
```
- `android/build/outputs/aar/build-debug.aar`

### Method 2: Using the Build Script

```bash
cd weather_module/android
./build_aar.sh
```

### Method 3: Using Flutter Build System

If you have Flutter installed:
```bash
cd weather_module
flutter pub get
cd android
flutter build aar
```

## Project Structure

```
weather_module/
├── android/
│   ├── build.gradle              # Main build configuration
│   ├── settings.gradle           # Gradle settings
│   ├── gradle.properties         # Gradle properties
│   ├── src/
│   │   └── main/
│   │       ├── AndroidManifest.xml
│   │       └── kotlin/
│   │           └── com/weathermodule/weather_module/
│   │               └── WeatherModulePlugin.kt
│   └── gradle/wrapper/           # Gradle wrapper files
└── lib/                          # Dart code (not included in AAR)
```

## Using the AAR in an Android Project

### Option 1: Local AAR File

1. Copy the AAR file to your Android project's `libs` directory:
   ```
   your-android-project/
   └── app/
       └── libs/
           └── build-release.aar (copy here)
   ```

2. Add to your `app/build.gradle`:
```gradle
android {
    ...
}

repositories {
    flatDir {
        dirs 'libs'
    }
}

dependencies {
    implementation(name: 'build-release', ext: 'aar')
    // Add Flutter embedding dependency
    implementation 'io.flutter:flutter_embedding:1.0.0'
}
```

### Option 2: Maven Repository

1. Publish to a Maven repository (local or remote)

2. Add dependency:
```gradle
repositories {
    maven {
        url uri('/path/to/repo')
    }
}

dependencies {
    implementation 'com.weathermodule:weather_module:1.0.0'
}
```

## Important Notes

⚠️ **Important**: This AAR contains the Android plugin bridge code only. The Dart implementation (in `lib/`) is not included in the AAR. 

- If using in a **Flutter app**: The Dart code is automatically included via the Flutter plugin system
- If using in a **native Android app**: You'll need to either:
  - Use Flutter's embedding to run Flutter code
  - Port the Dart weather service logic to Kotlin/Java

## Troubleshooting

### Gradle Wrapper Not Found
```bash
cd android
gradle wrapper --gradle-version 7.5
chmod +x gradlew
```

### Build Fails with SDK Errors
Make sure `compileSdkVersion` in `build.gradle` matches your installed SDK version.

### Flutter Dependencies Missing
If building as a standalone AAR, Flutter embedding dependencies are optional. The AAR will work as a basic Android library.
