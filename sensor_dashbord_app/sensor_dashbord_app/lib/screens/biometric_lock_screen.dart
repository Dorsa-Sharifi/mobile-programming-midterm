import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'sensor_dashboard.dart';

class BiometricLockScreen extends StatefulWidget {
  const BiometricLockScreen({super.key});

  @override
  State<BiometricLockScreen> createState() => _BiometricLockScreenState();
}

class _BiometricLockScreenState extends State<BiometricLockScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  String _status = "احراز هویت بیومتریک برای دسترسی به پنل نیاز است";

  @override
  void initState() {
    super.initState();
    _authenticate();
  }

  Future<void> _authenticate() async {
    try {
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      bool isDeviceSupported = await auth.isDeviceSupported();

      if (!canCheckBiometrics && !isDeviceSupported) {
        _navigateToDashboard();
        return;
      }

      bool authenticated = await auth.authenticate(
        localizedReason: 'برای باز کردن قفل داشبورد سنسورها هویت خود را تایید کنید',
      );

      if (authenticated) {
        _navigateToDashboard();
      } else {
        setState(() { _status = "فرآیند تایید هویت با شکست مواجه شد."; });
      }
    } catch (e) {
      setState(() { _status = "سنسور اثر انگشت روی این شبیه‌ساز یا دستگاه یافت نشد."; });
    }
  }



  void _navigateToDashboard() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const SensorDashboard()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.fingerprint, size: 100, color: Colors.blueAccent),
              const SizedBox(height: 25),
              Text(
                _status,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15, color: Colors.white70, height: 1.5),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: _authenticate,
                icon: const Icon(Icons.security),
                label: const Text("تلاش برای احراز هویت"),
                style: ElevatedButton.styleFrom(minimumSize: const Size(200, 45)),
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: _navigateToDashboard,
                child: const Text(
                  "ورود مستقیم (شبیه‌ساز / Bypass)",
                  style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
