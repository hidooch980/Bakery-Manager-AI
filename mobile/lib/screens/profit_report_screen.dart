import '../services/expense_service.dart';
import 'package:flutter/material.dart';
import '../services/sales_service.dart';

class ProfitReportScreen extends StatelessWidget {
  const ProfitReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int sales = 0;
    int expenses = 0;

    for (final item in SalesService.getAll()) {
      sales += item['total'] as int;
    }

    for (final item in ExpenseService.getAll()) {
      expenses += item['amount'] as int;
    }

    final profit = sales - expenses;

    return Scaffold(
      appBar: AppBar(title: const Text('گزارش سود و زیان')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: const Text('فروش کل'),
                trailing: Text('$sales'),
              ),
            ),

            Card(
              child: ListTile(
                title: const Text('هزینه کل'),
                trailing: Text('$expenses'),
              ),
            ),

            Card(
              child: ListTile(
                title: const Text('سود خالص'),
                trailing: Text('$profit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
