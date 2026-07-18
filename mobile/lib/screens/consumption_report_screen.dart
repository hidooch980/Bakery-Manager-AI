import 'package:flutter/material.dart';
import '../services/consumption_service.dart';

class ConsumptionReportScreen extends StatelessWidget {
  const ConsumptionReportScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final records = ConsumptionService.getAll();

    return Scaffold(
      appBar: AppBar(
        title: const Text('گزارش مصرف مواد'),
      ),

      body: records.isEmpty
          ? const Center(
              child: Text('مصرفی ثبت نشده است'),
            )

          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: records.length,

              itemBuilder: (context, index) {

                final item = records[index];

                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.remove_circle),
                    title: Text(item['item']),
                    subtitle: Text(
                      '${item['quantity']} ${item['unit']}\n${item['date']}',
                    ),
                  ),
                );
              },
            ),
    );
  }
}
