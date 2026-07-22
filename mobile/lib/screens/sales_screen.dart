import 'package:flutter/material.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {

  final breadController = TextEditingController();
  final priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ثبت فروش نان'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            TextField(
              controller: breadController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'تعداد نان',
              ),
            ),

            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'مبلغ فروش',
              ),
            ),

            const SizedBox(height:20),

            ElevatedButton(
              onPressed: () {

              },
              child: const Text('ثبت فروش'),
            ),

          ],
        ),
      ),
    );
  }
}
