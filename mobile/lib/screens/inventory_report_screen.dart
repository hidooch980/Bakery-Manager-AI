import 'package:flutter/material.dart';
import '../services/inventory_service.dart';

class InventoryReportScreen extends StatelessWidget {
  const InventoryReportScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final items = InventoryService.getAll();

    return Scaffold(
      appBar: AppBar(
        title: const Text('گزارش موجودی انبار'),
      ),

      body: items.isEmpty
          ? const Center(
              child: Text('انبار خالی است'),
            )

          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,

              itemBuilder: (context, index) {

                final item = items[index];

                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.inventory),
                    title: Text(item['name']),
                    subtitle: Text(
                      '${item['quantity']} ${item['unit']}\n${item['date']}',
                    ),
                  ),
               
cd ~/projects/Bakery-Manager-AI && cat > mobile/lib/screens/inventory_report_screen.dart <<'EOF'
import 'package:flutter/material.dart';
import '../services/inventory_service.dart';

class InventoryReportScreen extends StatelessWidget {
  const InventoryReportScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final items = InventoryService.getAll();

    return Scaffold(
      appBar: AppBar(
        title: const Text('گزارش موجودی انبار'),
      ),

      body: items.isEmpty
          ? const Center(
              child: Text('انبار خالی است'),
            )

          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,

              itemBuilder: (context, index) {

                final item = items[index];

                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.inventory),
                    title: Text(item['name']),
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
