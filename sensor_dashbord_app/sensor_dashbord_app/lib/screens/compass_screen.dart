import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';

class CompassScreen extends StatelessWidget {
  const CompassScreen({super.key});

  String _getDirection(double heading) {
    double adjustedHeading = (heading % 360 + 360) % 360;

    if (adjustedHeading >= 337.5 || adjustedHeading < 22.5) return 'N';
    if (adjustedHeading >= 22.5 && adjustedHeading < 67.5) return 'NE';
    if (adjustedHeading >= 67.5 && adjustedHeading < 112.5) return 'E';
    if (adjustedHeading >= 112.5 && adjustedHeading < 157.5) return 'SE';
    if (adjustedHeading >= 157.5 && adjustedHeading < 202.5) return 'S';
    if (adjustedHeading >= 202.5 && adjustedHeading < 247.5) return 'SW';
    if (adjustedHeading >= 247.5 && adjustedHeading < 292.5) return 'W';
    return 'NW';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Compass")),
      body: StreamBuilder<CompassEvent>(
        stream: FlutterCompass.events,
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text("خطا: ${snapshot.error}"));
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

          double? direction = snapshot.data?.heading;
          if (direction == null) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "سنسور قطب‌نما (Magnetometer) در این شبیه‌ساز لود نشده یا وجود ندارد.",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _getDirection(direction), 
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${direction.toStringAsFixed(1)}°', 
                    style: const TextStyle(fontSize: 18, color: Colors.blueAccent),
                  ),
                  const SizedBox(height: 30),
                  Transform.rotate(
                    angle: (direction * (math.pi / 180) * -1),
                    child: Image.asset(
                      'assets/compass_dial.png',
                      height: 230, 
                      errorBuilder: (c, e, s) => const Icon(Icons.explore, size: 180, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}