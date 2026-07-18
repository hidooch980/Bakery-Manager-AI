import 'package:flutter/material.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {

  final cashController = TextEditingController();
  final cardController = TextEditingController();
  final breadController = TextEditingController();

  void saveSale() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('فروش امروز ثبت شد'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ثبت فروش'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: breadController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'تعداد نان فروخته شده',
              ),
            ),

            TextField(
              controller: cashController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'فروش نقدی',
              ),
            ),

            TextField(
              controller: cardController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'کارتخوان',
              ),
            ),

            const SizedBox(height:30),

            ElevatedButton(
              onPressed: saveSale,
              child: const Text('ثبت فروش'),
            )

          ],
        ),
      ),
    );
  }
}
