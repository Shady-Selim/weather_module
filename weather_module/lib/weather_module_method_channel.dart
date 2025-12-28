import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'weather_module_platform_interface.dart';

/// An implementation of [WeatherModulePlatform] that uses method channels.
class MethodChannelWeatherModule extends WeatherModulePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('weather_module');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
