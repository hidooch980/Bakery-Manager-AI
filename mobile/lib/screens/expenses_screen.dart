import 'package:flutter/material.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {

  final titleController = TextEditingController();
  final amountController = TextEditingController();

  void saveExpense() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('هزینه ثبت شد'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ثبت هزینه'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'عنوان هزینه',
              ),
            ),

            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'مبلغ',
              ),
            ),

            const SizedBox(height:30),

            ElevatedButton(
              onPressed: saveExpense,
              child: const Text('ثبت هزینه'),
            )

          ],
        ),
      ),
    );
  }
}
