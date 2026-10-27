import 'package:flutter/material.dart';
import 'package:shake/shake.dart';
import '../widgets/parallax_background.dart';
import 'compass_screen.dart';
import 'map_screen.dart';
import 'light_meter_screen.dart';
import 'step_counter_screen.dart';
import 'proximity_screen.dart';
import 'barometer_screen.dart';
import 'nfc_reader_screen.dart';

class SensorDashboard extends StatefulWidget {
  const SensorDashboard({super.key});

  @override
  State<SensorDashboard> createState() => _SensorDashboardState();
}

class _SensorDashboardState extends State<SensorDashboard> {
  late ShakeDetector detector;

  @override
  void initState() {
    super.initState();
    detector = ShakeDetector.autoStart(
      onPhoneShake: (event) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('شبیه‌سازی لرزش: لرزش شدید تشخیص داده شد!'),
            backgroundColor: Colors.teal,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      shakeThresholdGravity: 1.3,
    );
  }

  @override
  void dispose() {
    detector.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ParallaxBackground(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            const SliverAppBar(
              title: Text(
                "Sensor Dashboard",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
            )
          ],
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildCard(context, "Compass", Icons.explore, () => const CompassScreen()),
                _buildCard(context, "GPS Map", Icons.map, () => const MapScreen()),
                _buildCard(context, "Light", Icons.light_mode, () => const LightMeterScreen()),
                _buildCard(context, "Step Counter", Icons.directions_walk, () => const StepCounterScreen()),
                _buildCard(context, "Proximity", Icons.sensor_window, () => const ProximityScreen()),
                _buildCard(context, "Barometer", Icons.compress, () => const BarometerScreen()),
                _buildCard(context, "NFC", Icons.nfc, () => const NFCReaderScreen()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, IconData icon, Widget Function() builder) {
    return Card(
      color: Colors.black.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Colors.white10),
      ),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => builder())),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blueAccent),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
