import 'dart:io';
import 'package:weather_module/weather_module.dart';

void main() async {
  print('🌤️  Weather Module Example\n');
  
  final service = WeatherService();
  
  // Test with different cities
  final cities = ['London', 'New York', 'Tokyo', 'Paris'];
  
  for (final city in cities) {
    try {
      print('Fetching temperature for $city...');
      final temperature = await service.getTodayTemperature(city);
      print('✅ $city: ${temperature.toStringAsFixed(1)}°C\n');
    } on WeatherException catch (e) {
      print('❌ Error for $city: ${e.message}\n');
    } catch (e) {
      print('❌ Unexpected error for $city: $e\n');
    }
    
    // Small delay between requests to be respectful to the API
    await Future.delayed(Duration(milliseconds: 500));
  }
  
  // Test error handling
  print('Testing error handling...');
  try {
    await service.getTodayTemperature('');
  } on WeatherException catch (e) {
    print('✅ Caught expected error: ${e.message}');
  }
  
  print('\n✨ Example completed!');
}

