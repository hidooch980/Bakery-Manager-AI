import 'package:flutter/material.dart';
import '../services/sales_service.dart';

class SalesReportScreen extends StatelessWidget {
  const SalesReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final records = SalesService.getAll();

    int totalCash = 0;
    int totalCard = 0;
    int totalBread = 0;

    for (final item in records) {
      totalCash += item['cash'] as int;
      totalCard += item['card'] as int;
      totalBread += item['bread'] as int;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('گزارش فروش روزانه')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              title: const Text('تعداد نان فروخته شده'),
              trailing: Text('$totalBread'),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('فروش نقدی'),
              trailing: Text('$totalCash'),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('کارتخوان'),
              trailing: Text('$totalCard'),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('مجموع فروش'),
              trailing: Text('${totalCash + totalCard}'),
            ),
          ),
        ],
      ),
    );
  }
}
