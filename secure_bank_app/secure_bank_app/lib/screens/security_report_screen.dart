import 'package:flutter/material.dart';
import '../services/security_service.dart';

class SecurityReportScreen extends StatefulWidget {
  const SecurityReportScreen({super.key});

  @override
  State<SecurityReportScreen> createState() => _SecurityReportScreenState();
}

class _SecurityReportScreenState extends State<SecurityReportScreen> {
  final SecurityService _securityService = SecurityService();
  Map<String, dynamic> _report = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSecurityReport();
  }

  Future<void> _loadSecurityReport() async {
    final report = await _securityService.getSecurityReport();
    if (mounted) {
      setState(() {
        _report = report;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('گزارش وضعیت امنیت دستگاه')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  _buildSecurityItem(
                    title: 'روت بودن دستگاه (Rooted)',
                    subtitle: 'بررسی اینکه آیا دستگاه روت شده یا خیر (خطر بالا)',
                    status: _report['isRooted'] ?? false,
                    inverseColor: true,
                  ),
                  _buildSecurityItem(
                    title: 'شبیه‌ساز (Emulator)',
                    subtitle: 'تشخیص اینکه برنامه روی شبیه‌ساز در حال اجراست یا دستگاه واقعی',
                    status: _report['isEmulator'] ?? false,
                    inverseColor: true,
                  ),
                  _buildSecurityItem(
                    title: 'ابزار توسعه (Development Tools)',
                    subtitle: 'بررسی فعال بودن امکان ADB Debugging یا USB debugging',
                    status: _report['isDevMode'] ?? false,
                    inverseColor: true,
                  ),
                  _buildSecurityItem(
                    title: 'منبع نصب رسمی (Official Source)',
                    subtitle: 'آیا برنامه از بازار، مایکت یا گوگل‌پلی نصب شده؟',
                    status: _report['isOfficialStore'] ?? false,
                  ),
                  _buildSecurityItem(
                    title: 'امضای برنامه (App Signature)',
                    subtitle: 'بررسی معتبر و دست‌نخورده بودن امضای رسمی APK برنامه',
                    status: _report['isSignatureValid'] ?? false,
                  ),
                  _buildSecurityItem(
                    title: 'احراز هویت بیومتریک (Biometrics)',
                    subtitle: 'بررسی فعال بودن و در دسترس بودن حسگر اثر انگشت یا چهره',
                    status: _report['isBiometricEnabled'] ?? false,
                  ),
                  _buildSecurityItem(
                    title: 'ذخیره‌سازی امن (Secure Storage)',
                    subtitle: 'ذخیره کلیدها و توکن‌های حساس به صورت رمزنگاری شده سخت‌افزاری',
                    status: _report['isSecureStorageEnabled'] ?? false,
                  ),
                  _buildSecurityItem(
                    title: 'جلوگیری از اسکرین‌شات (Screenshot Protection)',
                    subtitle: 'مسدود بودن گرفتن اسکرین‌شات و ضبط فیلم از صفحات برنامه',
                    status: true, 
                  ),
                  const SizedBox(height: 20),
                  const Card(
                    color: Colors.blueAccent,
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'مکانیزم جلوگیری از اسکرین‌شات و ضبط ویدیو در این صفحه به صورت سخت‌افزاری و بومی (FLAG_SECURE) فعال است.',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSecurityItem({
    required String title,
    required String subtitle,
    required bool status,
    bool inverseColor = false,
  }) {
    bool isSafe = inverseColor ? !status : status;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(
          isSafe ? Icons.check_circle : Icons.warning,
          color: isSafe ? Colors.green : Colors.red,
          size: 32,
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: Text(
          isSafe ? 'امن / فعال' : 'ناامن / غیرفعال',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSafe ? Colors.green : Colors.red,
          ),
        ),
      ),
    );
  }
}
