import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class BarometerScreen extends StatefulWidget {
  const BarometerScreen({super.key});

  @override
  State<BarometerScreen> createState() => _BarometerScreenState();
}

class _BarometerScreenState extends State<BarometerScreen> {
  String _pressure = "Loading...";
  String _altitude = "Unknown";
  bool _isSensorSupported = true;

  @override
  void initState() {
    super.initState();
    barometerEventStream().listen(
      (BarometerEvent event) {
        if (mounted) {
          double pressureValue = event.pressure; // hPa
          
          double calculatedAlt = (44330 * (1 - math.pow((pressureValue / 1013.25), 1 / 5.255))).toDouble();
          
          // double displayAlt = math.max(0.0, calculatedAlt);
          double displayAlt = calculatedAlt;

          setState(() {
            _isSensorSupported = true;
            _pressure = "${pressureValue.toStringAsFixed(0)} hPa";
            _altitude = "${displayAlt.toStringAsFixed(0)} m";
          });
        }
      },
      onError: (e) {
        setState(() {
          _isSensorSupported = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Barometer & Altitude"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isSensorSupported ? Icons.cloud_queue : Icons.error_outline, 
                size: 100, 
                color: _isSensorSupported ? Colors.cyan : Colors.redAccent
              ),
              const SizedBox(height: 25),
              if (_isSensorSupported) ...[
                Text(
                  "Pressure: $_pressure", 
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold), 
                  textAlign: TextAlign.center
                ),
                const SizedBox(height: 15),
                Text(
                  "Estimated Altitude: $_altitude", 
                  style: const TextStyle(fontSize: 20, color: Colors.grey), 
                  textAlign: TextAlign.center
                ),
              ] else ...[
                const Text(
                  "این سنسور روی دستگاه شما پشتیبانی نمی‌شود.",
                  style: TextStyle(fontSize: 18, color: Colors.redAccent, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
