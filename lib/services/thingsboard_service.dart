import 'package:thingsboard_client/thingsboard_client.dart';

class ThingsBoardService {
  final tbClient = ThingsboardClient('https://thingsboard.cloud');
  static const String deviceName = 'RENEWABLE ENERGY MONITERING'; // Change to your device's name

  Future<Map<String, List<TelemetryValue>>> fetchLatestTelemetry() async {
    // Login with tenant/customer credentials (NOT device token)
    await tbClient.login(LoginRequest('ay94994055@gmail.com', 'Ashutosh@thingsboard'));

    final device = await tbClient.getDeviceService().getDeviceByName(deviceName);
    if (device == null) throw Exception('Device not found');

    final keys = ['panel_voltage', 'battery_voltage', 'current', 'temperature', 'brightness'];
    final telemetry = await tbClient.getTelemetryService().getLatestTimeseries(device.id!.id!, keys);

    await tbClient.logout();
    return telemetry;
  }
}
