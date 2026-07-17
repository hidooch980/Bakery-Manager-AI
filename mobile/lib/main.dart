import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';

void main(){runApp(const BakeryApp());}

class BakeryApp extends StatelessWidget{
const BakeryApp({super.key});
@override
Widget build(BuildContext context){
return MaterialApp(
debugShowCheckedModeBanner:false,
title:'Bakery Manager AI',
theme:ThemeData(primarySwatch:Colors.orange),
home:const DashboardScreen()
);
}
}
