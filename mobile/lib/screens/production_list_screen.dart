import 'package:flutter/material.dart';
import '../services/production_service.dart';

class ProductionListScreen extends StatelessWidget {
  const ProductionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final records = ProductionService.getAll();

    return Scaffold(
      appBar: AppBar(
        title: const Text('گزارش تولید'),
      ),
      body: records.isEmpty
          ? const Center(
              child: Text('هنوز تولیدی ثبت نشده است'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: records.length,
              itemBuilder: (context, index) {
                final item = records[index];

                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.factory),
                    title: Text(
                      'خمیر: ${item['dough']} | چانه: ${item['pieces']}',
                    ),
                    subtitle: Text(
                      'نان تولیدی: ${item['bread']}\n${item['date']}',
                    ),
                  ),
                );
              },
            ),
    );
  }
}
