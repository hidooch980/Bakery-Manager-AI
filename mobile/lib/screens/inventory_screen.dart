import 'package:flutter/material.dart';
import '../services/inventory_service.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {

  final nameController = TextEditingController();
  final quantityController = TextEditingController();
  final unitController = TextEditingController();

  void saveItem() {
    InventoryService.add(
      name: nameController.text,
      quantity: double.tryParse(quantityController.text) ?? 0,
      unit: unitController.text,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('ماده اولیه ثبت شد'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ثبت مواد اولیه'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'نام کالا',
              ),
            ),

            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'مقدار',
              ),
            ),

            TextField(
              controller: unitController,
              decoration: const InputDecoration(
                labelText: 'واحد (کیلو، لیتر...)',
              ),
            ),

            const SizedBox(height:30),

            ElevatedButton(
              onPressed: saveItem,
              child: const Text('ثبت'),
            )
          ],
        ),
      ),
    );
  }
}
