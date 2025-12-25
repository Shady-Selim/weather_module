import 'dart:io';
import 'package:weather_module/weather_module.dart';

/// Simple test script to demonstrate the weather module
void main() async {
  print('🌤️  Weather Module Test\n');
  print('Testing the weather module with wttr.in API...\n');
  
  final service = WeatherService();
  
  // Test with London
  try {
    print('Fetching temperature for London...');
    final temperature = await service.getTodayTemperature('London');
    print('✅ Success! Current temperature in London: ${temperature.toStringAsFixed(1)}°C\n');
  } on WeatherException catch (e) {
    print('❌ Error: ${e.message}\n');
    exit(1);
  } catch (e) {
    print('❌ Unexpected error: $e\n');
    exit(1);
  }
  
  // Test error handling with empty city name
  print('Testing error handling with empty city name...');
  try {
    await service.getTodayTemperature('');
    print('❌ Should have thrown an error!');
    exit(1);
  } on WeatherException catch (e) {
    print('✅ Caught expected error: ${e.message}\n');
  }
  
  print('✨ All tests passed!');
  exit(0);
}

