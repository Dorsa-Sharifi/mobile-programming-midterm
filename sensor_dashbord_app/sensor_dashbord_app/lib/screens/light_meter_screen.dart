import 'package:flutter/material.dart';
import 'package:light_sensor/light_sensor.dart';
import 'package:provider/provider.dart';
import '../theme_notifier.dart';

class LightMeterScreen extends StatelessWidget {
  const LightMeterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Light Meter")),
      body: StreamBuilder<int>(
        stream: LightSensor.luxStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(
              child: Text(
                "سنسور نور در شبیه‌ساز فعال یا یافت نشد",
                textAlign: TextAlign.center,
              ),
            );
          }

          int lux = snapshot.data!;
          
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Provider.of<ThemeNotifier>(context, listen: false).updateThemeBasedOnLux(lux.toDouble());
          });

          final isDark = lux < 80;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isDark ? Icons.nights_stay : Icons.wb_sunny, 
                  size: 100, 
                  color: Colors.amber
                ),
                const SizedBox(height: 20),
                Text(
                  "شدت نور: $lux LUX", 
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)
                ),
                const SizedBox(height: 10),
                Text(
                  isDark 
                      ? "تم خودکار فعال شده: تیره" 
                      : "تم خودکار فعال شده: روشن",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
