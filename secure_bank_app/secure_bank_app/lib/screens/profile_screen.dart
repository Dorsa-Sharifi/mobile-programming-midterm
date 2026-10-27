import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final StorageService _storageService = StorageService();
  String _phoneNumber = "در حال بارگذاری...";

  @override
  void initState() {
    super.initState();
    _loadUserPhoneNumber();
  }

  Future<void> _loadUserPhoneNumber() async {
    try {
      String? savedPhone = await _storageService.getPhoneNumber();
      
      setState(() {
        if (savedPhone != null && savedPhone.isNotEmpty) {
          _phoneNumber = savedPhone;
        } else {
          _phoneNumber = "یافت نشد";
        }
      });
    } catch (e) {
      setState(() {
        _phoneNumber = "خطا در بارگذاری";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("اطلاعات حساب و پروفایل"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueGrey,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 20),
            _buildInfoCard(Icons.badge, "نام و نام خانوادگی", "کاربر تست بانک"),
            _buildInfoCard(Icons.credit_card, "شماره حساب امن", "IR12 0010 0000 0012 3456 7890"),
            _buildInfoCard(Icons.phone_android, "شماره همراه ارتباطی", _phoneNumber),
            const Spacer(),
            const Card(
              color: Colors.blueAccent,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.security, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      "این صفحه تحت حفاظت بومی سیستم‌عامل است.",
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        subtitle: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
