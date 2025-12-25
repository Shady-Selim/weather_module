# How to Run the Weather Module

## Prerequisites
- Flutter SDK installed (includes Dart)
- Internet connection (to access wttr.in API)

## Running the Example

1. Install dependencies:
```bash
cd weather_module
flutter pub get
```

2. Run the test script:
```bash
dart run test_module.dart
```

Or run the example:
```bash
dart run example/weather_example.dart
```

## Quick Test

You can also create a simple test in your own Flutter/Dart project:

```dart
import 'package:weather_module/weather_module.dart';

void main() async {
  final service = WeatherService();
  
  try {
    final temp = await service.getTodayTemperature('London');
    print('Temperature: ${temp}°C');
  } catch (e) {
    print('Error: $e');
  }
}
```

