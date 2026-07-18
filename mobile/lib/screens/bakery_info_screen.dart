import 'package:flutter/material.dart';

class BakeryInfoScreen extends StatelessWidget {
  const BakeryInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اطلاعات نانوایی'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'نام نانوایی',
              ),
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'نام مدیر',
              ),
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'شماره تماس',
              ),
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'آدرس',
              ),
            ),
            const SizedBox(height:20),
            ElevatedButton(
              onPressed: () {},
              child: const Text('ذخیره'),
            )
          ],
        ),
      ),
    );
  }
}
