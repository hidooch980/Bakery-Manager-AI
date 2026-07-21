import 'package:flutter/material.dart';
import '../services/dashboard_service.dart';
import 'daily_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic> data = {};
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    final result = await DashboardService.dashboard();

    if (!mounted) return;

    setState(() {
      data = result is Map<String, dynamic> ? result : {};
      loading = false;
    });
  }

  num _today(String key) {
    final today = data['today'];
    if (today is Map && today[key] is num) return today[key] as num;
    if (data[key] is num) return data[key] as num;
    return num.tryParse('${data[key] ?? 0}') ?? 0;
  }

  num _inventory(String key) {
    final inventory = data['inventory'];
    if (inventory is Map && inventory[key] is num) return inventory[key] as num;
    if (data[key] is num) return data[key] as num;
    return num.tryParse('${data[key] ?? 0}') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final sales = _today('sales');
    final production = _today('production');
    final expenses = _today('expenses');
    final profit = _today('profit');
    final flour = _inventory('flour');

    return Scaffold(
      appBar: AppBar(
        title: const Text('داشبورد مدیریت نانوایی'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                loading = true;
              });
              loadDashboard();
            },
          )
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'خلاصه امروز',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  DailyChart(
                    sales: sales.toDouble(),
                    production: production.toDouble(),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      children: [
                        _card('فروش امروز', sales, Icons.point_of_sale),
                        _card('تولید نان', production, Icons.bakery_dining),
                        _card('موجودی آرد', flour, Icons.inventory),
                        _card('صندوق', data['cash'] ?? 0, Icons.account_balance_wallet),
                        _card('هزینه‌ها', expenses, Icons.money_off),
                        _card('سود امروز', profit, Icons.trending_up),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Widget _card(String title, dynamic value, IconData icon) {
    return Card(
      elevation: 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('$value', style: const TextStyle(fontSize: 24)),
        ],
      ),
    );
  }
}
