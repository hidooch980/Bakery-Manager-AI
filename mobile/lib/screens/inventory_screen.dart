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

  void saveItem(){

    InventoryService.add(
      name: nameController.text,
      quantity: double.tryParse(quantityController.text) ?? 0,
      unit: unitController.text,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('مواد اولیه ثبت شد'),
      ),
    );

    nameController.clear();
    quantityController.clear();
    unitController.clear();
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(

      appBar: AppBar(
        title: const Text('انبار آرد و مواد اولیه'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Card(
          elevation:4,

          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              children:[

                TextField(
                  controller:nameController,

                  decoration:const InputDecoration(
                    prefixIcon:Icon(Icons.inventory),
                    labelText:'نام ماده',
                  ),
                ),

                const SizedBox(height:15),

                TextField(
                  controller:quantityController,
                  keyboardType:TextInputType.number,

                  decoration:const InputDecoration(
                    prefixIcon:Icon(Icons.scale),
                    labelText:'مقدار',
                  ),
                ),

                const SizedBox(height:15),

                TextField(
                  controller:unitController,

                  decoration:const InputDecoration(
                    prefixIcon:Icon(Icons.straighten),
                    labelText:'واحد (کیلو، لیتر...)',
                  ),
                ),

                const SizedBox(height:30),

                SizedBox(
                  width:double.infinity,

                  child:ElevatedButton.icon(
                    onPressed:saveItem,

                    icon:const Icon(Icons.save),

                    label:const Text(
                      'ثبت انبار',
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
