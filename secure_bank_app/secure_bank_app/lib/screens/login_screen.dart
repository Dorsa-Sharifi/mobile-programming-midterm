import 'package:flutter/material.dart';
import 'otp_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final phoneController = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text("ورود")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: "شماره موبایل", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (phoneController.text.isNotEmpty) {
                  const mockOtp = "123456";
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("کد تایید آزمایشی: $mockOtp")),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OtpScreen(phoneNumber: phoneController.text),
                    ),
                  );
                }
              },
              child: const Text("ارسال کد تایید"),
            )
          ],
        ),
      ),
    );
  }
}
