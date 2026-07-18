import 'package:flutter/material.dart';

class ProductionSettingsScreen extends StatelessWidget {
  const ProductionSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تنظیمات تولید'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'وزن استاندارد چانه (گرم)',
              ),
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'تعداد نان هر خمیر',
              ),
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'نوع نان',
              ),
            ),
            const SizedBox(height:20),
            ElevatedButton(
              onPressed: () {},
              child: const Text('ذخیره تنظیمات'),
            )
          ],
        ),
      ),
    );
  }
}
