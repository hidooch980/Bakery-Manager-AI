import 'package:flutter/material.dart';
import '../services/expense_service.dart';

class ExpensesReportScreen extends StatelessWidget {
  const ExpensesReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final records = ExpenseService.getAll();

    int total = 0;

    for (final item in records) {
      total += item['amount'] as int;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('گزارش هزینه‌ها'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              title: const Text('مجموع هزینه‌ها'),
              trailing: Text('$total'),
            ),
          ),

          const SizedBox(height:10),

          ...records.map(
            (item) => Card(
              child: ListTile(
                leading: const Icon(Icons.money_off),
                title: Text(item['title']),
                subtitle: Text(item['date']),
                trailing: Text('${item['amount']}'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
