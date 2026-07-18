import 'package:flutter/material.dart';

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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تولید امروز ثبت شد'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
