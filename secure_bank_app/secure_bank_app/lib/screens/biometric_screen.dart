import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'home_screen.dart';

class BiometricScreen extends StatelessWidget {
  const BiometricScreen({super.key});

  Future<void> _authenticate(BuildContext context) async {
    final LocalAuthentication auth = LocalAuthentication();
    try {
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      final bool isDeviceSupported = await auth.isDeviceSupported();

      if (canAuthenticateWithBiometrics || isDeviceSupported) {
        bool authenticated = await auth.authenticate(
          localizedReason: 'لطفاً برای ورود به برنامه احراز هویت کنید',
          options: const AuthenticationOptions(
            biometricOnly: false, 
            stickyAuth: true,
          ),
        );

        if (authenticated && context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }
      } else {
        _showErrorSnackBar(context, "سنسور بیومتریک روی این دستگاه یافت نشد.");
      }
    } catch (e) {
      _showErrorSnackBar(context, "خطا در احراز هویت: $e");
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.fingerprint,
                size: 100,
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 30),
              const Text(
                "احراز هویت بیومتریک",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              const Text(
                "برای امنیت بیشتر، لطفا با اثر انگشت یا تشخیص چهره هویت خود را تایید کنید.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 50),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blueAccent,
                ),
                icon: const Icon(Icons.security, color: Colors.white),
                label: const Text("اسکن و ورود", style: TextStyle(fontSize: 18, color: Colors.white)),
                onPressed: () => _authenticate(context),
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                },
                child: const Text(
                  "رد شدن (مخصوص تست روی شبیه‌ساز)",
                  style: TextStyle(color: Colors.white54, decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
