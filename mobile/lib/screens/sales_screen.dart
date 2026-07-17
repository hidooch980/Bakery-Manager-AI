import 'package:flutter/material.dart';

class SalesScreen extends StatelessWidget{

const SalesScreen({super.key});

@override
Widget build(BuildContext context){

return Scaffold(

appBar:AppBar(
title:const Text('فروش نانوایی'),
),

body:const Center(
child:Text(
'ثبت فروش روزانه\n\nنقدی\nکارتخوان\nبستانکاری مشتری',
textAlign:TextAlign.center,
style:TextStyle(fontSize:20),
),
),

);

}

}
