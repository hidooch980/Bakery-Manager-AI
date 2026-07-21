import 'package:flutter/material.dart';
import '../services/product_service.dart';
import '../services/sales_service.dart';

class SellerScreen extends StatefulWidget {
  const SellerScreen({super.key});

  @override
  State<SellerScreen> createState() => _SellerScreenState();
}

class _SellerScreenState extends State<SellerScreen> {

  List products = [];
  dynamic selectedProduct;
  final quantity = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final result = await ProductService.getProducts();

    if (!mounted) return;

    setState(() {
      products = result;
    });
  }


  Future<void> save() async {

    if (selectedProduct == null) return;

    final ok = await SalesService.createSale(
      productId: selectedProduct['id'],
      quantity: int.tryParse(quantity.text) ?? 1,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok ? 'فروش ثبت شد' : 'خطا در ثبت فروش',
        ),
      ),
    );

    quantity.clear();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text('صفحه فروشنده'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            DropdownButtonFormField(
              initialValue: selectedProduct,

              items: products.map((p){

                return DropdownMenuItem(
                  value: p,
                  child: Text(p['name']),
                );

              }).toList(),

              onChanged: (v){

                setState(() {
                  selectedProduct = v;
                });

              },

              decoration: const InputDecoration(
                labelText: 'انتخاب نان',
              ),
            ),


            TextField(
              controller: quantity,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'تعداد',
              ),
            ),


            const SizedBox(height:20),


            ElevatedButton(
              onPressed: save,
              child: const Text('ثبت فروش'),
            )

          ],
        ),
      ),
    );
  }
}
