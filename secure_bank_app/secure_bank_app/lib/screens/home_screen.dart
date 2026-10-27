import 'package:flutter/material.dart';
import 'security_report_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("داشبورد بانکی"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.security),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SecurityReportScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: const Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text("موجودی کل حساب", style: TextStyle(fontSize: 16, color: Colors.grey)),
                    SizedBox(height: 10),
                    Text("\$12,450.00", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text("آخرین تراکنش‌ها", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    leading: Icon(Icons.arrow_downward, color: Colors.green),
                    title: Text("انتقال وجه از علی محمدی"),
                    subtitle: Text("دیروز"),
                    trailing: Text("+\$150", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  ListTile(
                    leading: Icon(Icons.arrow_upward, color: Colors.red),
                    title: Text("خرید از فروشگاه"),
                    subtitle: Text("۲ روز پیش"),
                    trailing: Text("-\$45", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
