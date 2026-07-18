import 'package:flutter/material.dart';
import '../services/dashboard_service.dart';
import '../widgets/weekly_chart.dart';
import 'settings_screen.dart';
import 'production_screen.dart';

class DashboardScreen extends StatefulWidget{
const DashboardScreen({super.key});

@override
State<DashboardScreen> createState()=>_DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>{

Map daily={};
List weekly=[];

@override
void initState(){
super.initState();
load();
}

Future load() async{

final d=await DashboardService.daily();
final w=await DashboardService.weekly();

setState((){
daily=d;
weekly=w;
});

}


Widget card(String title,dynamic value){

return Card(
child:ListTile(
title:Text(title),
subtitle:Text('$value'),
),
);

}


@override
Widget build(BuildContext context){

return Scaffold(

appBar:AppBar(
title:const Text('داشبورد مدیر'),
            actions:[
              IconButton(
                icon:const Icon(Icons.add_chart),
                onPressed:(){
                  Navigator.push(context, MaterialPageRoute(builder:(_)=>const ProductionScreen()));
                },
              ),
              IconButton(
                icon:const Icon(Icons.settings),
                onPressed:(){
                  Navigator.push(context, MaterialPageRoute(builder:(_)=>const SettingsScreen()));
                },
              ),
            ],
),

body:ListView(

padding:const EdgeInsets.all(16),

children:[

card('تولید امروز',daily['production'] ?? 0),

card('فروش امروز',daily['sales'] ?? 0),

card('هزینه امروز',daily['expenses'] ?? 0),

card('سود / زیان',daily['profit'] ?? 0),

const SizedBox(height:20),

if(weekly.isNotEmpty)
WeeklyChart(data:weekly),

],

),

);

}

}
