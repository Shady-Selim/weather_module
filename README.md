# Weather Module

A simple Flutter package that fetches today's temperature for a given city name using the free [wttr.in](https://wttr.in) API service. No API key required!

## Features

- ✅ No API key or registration required
- ✅ Simple city name input (e.g., "London", "New York", "Tokyo")
- ✅ Returns temperature in Celsius
- ✅ Comprehensive error handling
- ✅ Built with pure Dart (no platform-specific code)

## Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  weather_module:
    path: ./weather_module  # or use git/published version
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic Example

```dart
import 'package:weather_module/weather_module.dart';

void main() async {
  final service = WeatherService();
  
  try {
    final temperature = await service.getTodayTemperature("London");
    print('Current temperature in London: ${temperature}°C');
  } catch (e) {
    print('Error: $e');
  }
}
```

### Error Handling

The package throws `WeatherException` for various error conditions:

```dart
import 'package:weather_module/weather_module.dart';

void main() async {
  final service = WeatherService();
  
  try {
    final temperature = await service.getTodayTemperature("London");
    print('Temperature: ${temperature}°C');
  } on WeatherException catch (e) {
    // Handle weather-specific errors
    print('Weather error: ${e.message}');
  } catch (e) {
    // Handle other errors
    print('Unexpected error: $e');
  }
}
```

### Common Error Scenarios

- **Empty city name**: `WeatherException: City name cannot be empty`
- **City not found**: `WeatherException: City not found: "InvalidCity"`
- **Network error**: `WeatherException: Network error: ...`
- **Request timeout**: `WeatherException: Request timeout: ...`
- **Invalid API response**: `WeatherException: Invalid API response: ...`

## API Details

This package uses the [wttr.in](https://wttr.in) weather service, which:
- Is completely free and requires no API key
- Provides weather data for cities worldwide
- Returns data in JSON format when using `?format=j1`
- Uses Celsius temperature units

## Examples

```dart
// Single city
final temp = await service.getTodayTemperature("New York");

// Cities with spaces or special characters
final temp1 = await service.getTodayTemperature("São Paulo");
final temp2 = await service.getTodayTemperature("New Delhi");

// Error handling for invalid cities
try {
  final temp = await service.getTodayTemperature("NonExistentCity12345");
} on WeatherException catch (e) {
  print('Could not get temperature: ${e.message}');
}
```

## License

This package is provided as-is for educational and development purposes.

## Credits

Weather data provided by [wttr.in](https://wttr.in) - a community-supported weather service.

