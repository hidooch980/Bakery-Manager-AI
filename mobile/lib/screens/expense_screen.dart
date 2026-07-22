import '../services/expense_service.dart';
import 'package:flutter/material.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final title = TextEditingController();
  final amount = TextEditingController();
  final note = TextEditingController();

  String category = 'متفرقه';

  Future save() async {
    await ExpenseService.create({
      "title": title.text,
      "amount": int.parse(amount.text),
      "category": category,
      "note": note.text,
    });

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('هزینه ثبت شد')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ثبت هزینه')),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(labelText: 'عنوان هزینه'),
            ),

            TextField(
              controller: amount,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'مبلغ'),
            ),

            DropdownButton(
              value: category,
              items: [
                'آرد',
                'سوخت',
                'حقوق',
                'تعمیرات',
                'متفرقه',
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),

              onChanged: (v) {
                setState(() => category = v.toString());
              },
            ),

            TextField(
              controller: note,
              decoration: const InputDecoration(labelText: 'توضیح'),
            ),

            ElevatedButton(onPressed: save, child: const Text('ثبت هزینه')),
          ],
        ),
      ),
    );
  }
}
