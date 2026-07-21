import 'package:flutter/material.dart';
import '../services/sales_service.dart';

class SellerScreen extends StatefulWidget{
const SellerScreen({super.key});

@override
State<SellerScreen> createState()=>_SellerScreenState();
}


class _SellerScreenState extends State<SellerScreen>{

final amount=TextEditingController();


void save() async{

await SalesService.createSale({

"total":double.parse(amount.text),

});

amount.clear();

ScaffoldMessenger.of(context)
.showSnackBar(
const SnackBar(content:Text('فروش ثبت شد'))
);

}


@override
Widget build(BuildContext context){

return Scaffold(

appBar:AppBar(
title:const Text('صفحه فروشنده'),
),


body:Padding(

padding:const EdgeInsets.all(20),

child:Column(

children:[

TextField(
controller:amount,
keyboardType:TextInputType.number,
decoration:
const InputDecoration(
labelText:'مبلغ فروش'
),
),


const SizedBox(height:20),


ElevatedButton(
onPressed:save,
child:
const Text('ثبت فروش'),
)

],

),

),

);

}

}
