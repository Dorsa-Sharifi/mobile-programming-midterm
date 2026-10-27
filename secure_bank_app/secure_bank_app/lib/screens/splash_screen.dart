import 'package:flutter/material.dart';
import '../services/security_service.dart';
import '../services/storage_service.dart'; 
import 'login_screen.dart';
import 'biometric_screen.dart'; 

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SecurityService _securityService = SecurityService();
  final StorageService _storageService = StorageService(); 
  String _statusMessage = "در حال بررسی امنیت سیستم...";
  bool _isSafe = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 2));
    Map<String, bool> integrity = await _securityService.checkDeviceIntegrity();
    
    if (integrity['isRooted'] == true || integrity['isEmulator'] == true) {
      setState(() {
        _isSafe = false;
        _statusMessage = "به دلیل ناامن بودن محیط اجرا (روت یا شبیه‌ساز)، امکان استفاده وجود ندارد.";
      });
    } else {
      await _handleNavigation(); 
    }
  }

  Future<void> _handleNavigation() async {
    if (!mounted) return;

    final token = await _storageService.getToken();

    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BiometricScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shield, size: 80, color: Colors.blueAccent),
              const SizedBox(height: 20),
              const Text("بانکداری امن", style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              if (_isSafe) const CircularProgressIndicator() else const Icon(Icons.error, color: Colors.red, size: 50),
              const SizedBox(height: 20),
              Text(_statusMessage, textAlign: TextAlign.center, style: TextStyle(color: _isSafe ? Colors.white70 : Colors.redAccent)),
              if (!_isSafe) ...[
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _handleNavigation, 
                  child: const Text("دور زدن محدودیت (برای تست روی شبیه‌ساز)"),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
