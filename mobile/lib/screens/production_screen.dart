import 'package:flutter/material.dart';
import '../services/production_service.dart';

class ProductionScreen extends StatefulWidget{
const ProductionScreen({super.key});

@override
State<ProductionScreen> createState()=>_ProductionScreenState();
}

class _ProductionScreenState extends State<ProductionScreen>{

final flourBags=TextEditingController(text:'2');
final flourWeight=TextEditingController(text:'80');
final doughCount=TextEditingController(text:'500');
final breadCount=TextEditingController(text:'500');
final doughWeight=TextEditingController(text:'0.85');

String shift='صبح';

Future save() async{

await ProductionService.create(
flourBags:int.parse(flourBags.text),
flourWeight:double.parse(flourWeight.text),
doughCount:int.parse(doughCount.text),
breadCount:int.parse(breadCount.text),
shift:shift,
doughWeight:double.parse(doughWeight.text),
);

if(!mounted)return;

ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(content:Text('تولید ثبت شد'))
);

}

Widget field(String t,TextEditingController c){
return TextField(
controller:c,
keyboardType:TextInputType.number,
decoration:InputDecoration(labelText:t),
);
}

@override
Widget build(BuildContext context){

return Scaffold(
appBar:AppBar(title:const Text('ثبت تولید')),

body:Padding(
padding:const EdgeInsets.all(16),

child:Column(
children:[

field('تعداد کیسه آرد',flourBags),
field('وزن آرد',flourWeight),
field('تعداد چانه',doughCount),
field('تعداد نان',breadCount),
field('وزن چانه',doughWeight),

DropdownButton(
value:shift,
items:[
'صبح','ظهر','شب'
].map((e)=>DropdownMenuItem(
value:e,
child:Text(e),
)).toList(),
onChanged:(v){
setState(()=>shift=v.toString());
},
),

ElevatedButton(
onPressed:save,
child:const Text('ثبت تولید'),
)

],

),

),

);

}

}
