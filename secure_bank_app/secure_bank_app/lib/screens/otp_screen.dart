import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import 'biometric_screen.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  const OtpScreen({super.key, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  final StorageService _storageService = StorageService();

  @override
  void initState() {
    super.initState();
    _simulateOtpAutoFill();
  }

  void _simulateOtpAutoFill() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _otpController.text = "123456";
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('کد تایید به طور خودکار وارد شد (Auto Fill)')),
        );
      }
    });
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text == "123456") {
      await _storageService.saveToken("secure_test_token_12345");
      
      await _storageService.savePhoneNumber(widget.phoneNumber);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BiometricScreen()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('کد تایید اشتباه است')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تایید کد پیامکی')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'کد ارسال شده به شماره ${widget.phoneNumber} را وارد کنید',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              '(شبیه‌سازی: کد ۱۲۳۴۵۶ بعد از ۲ ثانیه خودکار پر می‌شود)',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 6,
              style: const TextStyle(fontSize: 24, letterSpacing: 8),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                counterText: "",
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _verifyOtp,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('بررسی و تایید'),
            ),
          ],
        ),
      ),
    );
  }
}
