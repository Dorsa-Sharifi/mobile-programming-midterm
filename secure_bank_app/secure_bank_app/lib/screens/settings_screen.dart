import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import 'login_screen.dart';
import 'profile_screen.dart'; 

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final StorageService storageService = StorageService();
    await storageService.deleteToken();

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تنظیمات"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              leading: const Icon(Icons.person, color: Colors.blue),
              title: const Text("پروفایل کاربری"),
              subtitle: const Text("نمایش اطلاعات حساس حساب"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.notifications, color: Colors.blue),
              title: const Text("اطلاع‌رسانی‌ها"),
              subtitle: const Text("تنظیمات دریافت پیامک و هشدار"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تنظیمات اطلاع‌رسانی در حال حاضر فعال است.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            const Spacer(),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text(
                "خروج امن از حساب کاربری",
                style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onPressed: () => _logout(context),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
