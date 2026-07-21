import 'package:flutter/material.dart';
import '../widgets/permission_guard.dart';
import '../services/production_service.dart';

class ProductionScreen extends StatefulWidget {
  const ProductionScreen({super.key});

  @override
  State<ProductionScreen> createState() => _ProductionScreenState();
}

class _ProductionScreenState extends State<ProductionScreen> {
  final doughController = TextEditingController();
  final pieceController = TextEditingController();
  final breadController = TextEditingController();

  void saveProduction() {
    ProductionService.save(
      dough: int.tryParse(doughController.text) ?? 0,
      pieces: int.tryParse(pieceController.text) ?? 0,
      bread: int.tryParse(breadController.text) ?? 0,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تولید امروز ثبت شد'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PermissionGuard(
      page:'production',
      child: Scaffold(
      appBar: AppBar(
        title: const Text('ثبت تولید'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: doughController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'تعداد خمیر',
              ),
            ),
            TextField(
              controller: pieceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'تعداد چانه',
              ),
            ),
            TextField(
              controller: breadController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'تعداد نان تولید شده',
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: saveProduction,
              child: const Text('ثبت تولید'),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
