import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class StepCounterScreen extends StatefulWidget {
  const StepCounterScreen({super.key});

  @override
  State<StepCounterScreen> createState() => _StepCounterScreenState();
}

class _StepCounterScreenState extends State<StepCounterScreen> {
  StreamSubscription<UserAccelerometerEvent>? _accelerometerSubscription;
  int _steps = 2345; 
  double _magnitudePrevious = 0.0;

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  void _startListening() {
    _accelerometerSubscription = userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      if (!mounted) return;

      double magnitude = double.parse((event.x * event.x + event.y * event.y + event.z * event.z).toStringAsFixed(2));
      
      double delta = magnitude - _magnitudePrevious;
      _magnitudePrevious = magnitude;

      if (delta.abs() > 8.0) { 
        setState(() {
          _steps++;
        });
      }
    });
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Step Counter")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.directions_walk, size: 120, color: Colors.blueAccent),
            const SizedBox(height: 20),
            const Text(
              "تعداد قدم‌های ثبت‌شده:", 
              style: TextStyle(fontSize: 16, color: Colors.grey)
            ),
            const SizedBox(height: 10),
            Text(
              "$_steps",
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            const SizedBox(height: 30),
            const Card(
              margin: EdgeInsets.all(16),
              color: Colors.blueGrey,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  "راهنمای تست: در پنل Extended Controls شبیه‌ساز، به بخش Virtual Sensors رفته و شکل سه بعدی گوشی را سریع بچرخانید یا تکان دهید تا قدم‌ها شمرده شوند.",
                  style: TextStyle(color: Colors.white, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
