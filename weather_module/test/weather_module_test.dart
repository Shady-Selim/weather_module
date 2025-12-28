import 'package:flutter_test/flutter_test.dart';
import 'package:weather_module/weather_module.dart';
import 'package:weather_module/weather_module_platform_interface.dart';
import 'package:weather_module/weather_module_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockWeatherModulePlatform
    with MockPlatformInterfaceMixin
    implements WeatherModulePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final WeatherModulePlatform initialPlatform = WeatherModulePlatform.instance;

  test('$MethodChannelWeatherModule is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelWeatherModule>());
  });

  test('getPlatformVersion', () async {
    WeatherModule weatherModulePlugin = WeatherModule();
    MockWeatherModulePlatform fakePlatform = MockWeatherModulePlatform();
    WeatherModulePlatform.instance = fakePlatform;

    expect(await weatherModulePlugin.getPlatformVersion(), '42');
  });
}
