import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'weather_module_method_channel.dart';

abstract class WeatherModulePlatform extends PlatformInterface {
  /// Constructs a WeatherModulePlatform.
  WeatherModulePlatform() : super(token: _token);

  static final Object _token = Object();

  static WeatherModulePlatform _instance = MethodChannelWeatherModule();

  /// The default instance of [WeatherModulePlatform] to use.
  ///
  /// Defaults to [MethodChannelWeatherModule].
  static WeatherModulePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [WeatherModulePlatform] when
  /// they register themselves.
  static set instance(WeatherModulePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
