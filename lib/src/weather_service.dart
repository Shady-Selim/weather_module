import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service class for fetching weather data from wttr.in API
class WeatherService {
  /// Base URL for wttr.in API
  static const String _baseUrl = 'https://wttr.in';
  
  /// Default timeout duration for HTTP requests (10 seconds)
  static const Duration _timeout = Duration(seconds: 10);

  /// Creates a new instance of WeatherService
  WeatherService();

  /// Fetches today's temperature for the given city name
  /// 
  /// [cityName] - The name of the city (e.g., "London", "New York", "Tokyo")
  /// 
  /// Returns the current temperature in Celsius as a [double]
  /// 
  /// Throws [WeatherException] for error conditions (network errors, invalid city name, API errors, etc.)
  Future<double> getTodayTemperature(String cityName) async {
    if (cityName.trim().isEmpty) {
      throw WeatherException('City name cannot be empty');
    }

    try {
      // URL encode the city name and construct the API endpoint
      final encodedCityName = Uri.encodeComponent(cityName.trim());
      final url = Uri.parse('$_baseUrl/$encodedCityName?format=j1');

      // Make HTTP GET request with timeout
      final response = await http
          .get(url)
          .timeout(
        _timeout,
        onTimeout: () {
          throw WeatherException(
              'Request timeout: Could not fetch weather data within ${_timeout.inSeconds} seconds');
        },
      );

      // Check HTTP status code
      if (response.statusCode == 200) {
        try {
          // Parse JSON response
          final jsonData = json.decode(response.body) as Map<String, dynamic>;
          
          // Extract temperature from the nested structure
          // wttr.in format: current_condition[0].temp_C
          final currentCondition = jsonData['current_condition'] as List?;
          
          if (currentCondition == null || currentCondition.isEmpty) {
            throw WeatherException('Invalid API response: current_condition not found');
          }
          
          final condition = currentCondition[0] as Map<String, dynamic>;
          final tempC = condition['temp_C'];
          
          if (tempC == null) {
            throw WeatherException('Invalid API response: temperature not found');
          }
          
          // Convert to double (it might be String or int in the response)
          final temperature = double.tryParse(tempC.toString());
          
          if (temperature == null) {
            throw WeatherException('Invalid API response: temperature format is invalid');
          }
          
          return temperature;
        } catch (e) {
          if (e is WeatherException) {
            rethrow;
          }
          throw WeatherException('Failed to parse API response: ${e.toString()}');
        }
      } else if (response.statusCode == 404) {
        throw WeatherException('City not found: "$cityName"');
      } else {
        throw WeatherException(
            'API error: Received status code ${response.statusCode}');
      }
    } on WeatherException {
      rethrow;
    } on TimeoutException {
      throw WeatherException(
          'Request timeout: Could not fetch weather data within ${_timeout.inSeconds} seconds');
    } on http.ClientException catch (e) {
      throw WeatherException('Network error: ${e.message}');
    } catch (e) {
      throw WeatherException('Unexpected error: ${e.toString()}');
    }
  }
}

/// Custom exception class for weather-related errors
class WeatherException implements Exception {
  final String message;

  WeatherException(this.message);

  @override
  String toString() => 'WeatherException: $message';
}

