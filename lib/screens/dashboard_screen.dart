import 'package:flutter/material.dart';
import '../services/thingsboard_service.dart'; // adjust path if needed

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, List<TelemetryValue>>? telemetry;
  bool isLoading = true;
  final tbService = ThingsBoardService();

  @override
  void initState() {
    super.initState();
    fetchTelemetry();
  }

  Future<void> fetchTelemetry() async {
    setState(() => isLoading = true);
    telemetry = await tbService.fetchLatestTelemetry();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("EcoVisionPro Dashboard")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : telemetry == null
              ? Center(child: Text("Failed to load data."))
              : RefreshIndicator(
                  onRefresh: fetchTelemetry,
                  child: ListView(
                    padding: EdgeInsets.all(24),
                    children: [
                      Text("Panel Voltage: ${telemetry?['panel_voltage']?.first.value ?? '--'} V"),
                      Text("Battery Voltage: ${telemetry?['battery_voltage']?.first.value ?? '--'} V"),
                      Text("Current: ${telemetry?['current']?.first.value ?? '--'} A"),
                      Text("Temperature: ${telemetry?['temperature']?.first.value ?? '--'} °C"),
                      Text("Brightness: ${telemetry?['brightness']?.first.value ?? '--'} %"),
                    ],
                  ),
                ),
    );
  }
}
