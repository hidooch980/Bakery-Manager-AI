import 'package:flutter/material.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {

  final titleController = TextEditingController();
  final amountController = TextEditingController();

  void saveExpense(){

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('هزینه ثبت شد'),
      ),
    );

    titleController.clear();
    amountController.clear();
  }


  @override
  Widget build(BuildContext context){

    return Scaffold(

      appBar: AppBar(
        title: const Text('ثبت هزینه'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Card(
          elevation:4,

          child:Padding(
            padding:const EdgeInsets.all(20),

            child:Column(
              children:[

                TextField(
                  controller:titleController,

                  decoration:const InputDecoration(
                    prefixIcon:Icon(Icons.description),
                    labelText:'عنوان هزینه',
                  ),
                ),

                const SizedBox(height:15),

                TextField(
                  controller:amountController,
                  keyboardType:TextInputType.number,

                  decoration:const InputDecoration(
                    prefixIcon:Icon(Icons.money),
                    labelText:'مبلغ',
                  ),
                ),

                const SizedBox(height:30),

                SizedBox(
                  width:double.infinity,

                  child:ElevatedButton.icon(
                    onPressed:saveExpense,

                    icon:const Icon(Icons.save),

                    label:const Text(
                      'ثبت هزینه',
                      style:TextStyle(fontSize:18),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
