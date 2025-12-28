
import 'weather_module_platform_interface.dart';

class WeatherModule {
  Future<String?> getPlatformVersion() {
    return WeatherModulePlatform.instance.getPlatformVersion();
  }
}
