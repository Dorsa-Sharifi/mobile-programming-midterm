import 'dart:async';
import 'package:flutter/material.dart';
import 'package:proximity_sensor/proximity_sensor.dart';

class ProximityScreen extends StatefulWidget {
  const ProximityScreen({super.key});

  @override
  State<ProximityScreen> createState() => _ProximityScreenState();
}

class _ProximityScreenState extends State<ProximityScreen> {
  String _status = "در حال پایش سنسور نزدیکی...";
  bool _isNear = false;
  late StreamSubscription<dynamic> _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = ProximitySensor.events.listen((int event) {
      if (mounted) {
        setState(() {
          _isNear = (event > 0);
          _status = _isNear ? "جسم بسیار نزدیک است" : "جسم دور است";
        });
      }
    }, onError: (error) {
      setState(() {
        _status = "سنسور بر روی شبیه‌ساز پاسخ نمی‌دهد.";
      });
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Proximity")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isNear ? Icons.hearing : Icons.hearing_disabled, 
              size: 100, 
              color: _isNear ? Colors.red : Colors.purple
            ),
            const SizedBox(height: 25),
            Text(
              _status, 
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold), 
              textAlign: TextAlign.center
            ),
          ],
        ),
      ),
    );
  }
}
