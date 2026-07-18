import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/dashboard_service.dart';
import '../widgets/weekly_chart.dart';
import 'settings_screen.dart';
import 'production_screen.dart';
import 'production_list_screen.dart';
import 'sales_screen.dart';
import 'sales_report_screen.dart';
import 'expenses_screen.dart';
import 'expenses_report_screen.dart';
import 'profit_report_screen.dart';
import 'inventory_screen.dart';
import 'inventory_report_screen.dart';
import 'consumption_screen.dart';
import 'consumption_report_screen.dart';

class DashboardScreen extends StatefulWidget{
const DashboardScreen({super.key});

@override
State<DashboardScreen> createState()=>_DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>{

  String role = '';


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
                icon:const Icon(Icons.remove_circle),
                onPressed:(){
                  Navigator.push(context, MaterialPageRoute(builder:(_)=>const ConsumptionScreen()));
                },
              ),
              IconButton(
                icon:const Icon(Icons.bar_chart),
                onPressed:(){
                  Navigator.push(context, MaterialPageRoute(builder:(_)=>const ConsumptionReportScreen()));
                },
              ),
              IconButton(
                icon:const Icon(Icons.inventory),
                onPressed:(){
                  Navigator.push(context, MaterialPageRoute(builder:(_)=>const InventoryScreen()));
                },
              ),
              IconButton(
                icon:const Icon(Icons.inventory_2),
                onPressed:(){
                  Navigator.push(context, MaterialPageRoute(builder:(_)=>const InventoryReportScreen()));
                },
              ),
              IconButton(
                icon:const Icon(Icons.account_balance),
                onPressed:(){
                  Navigator.push(context, MaterialPageRoute(builder:(_)=>const ProfitReportScreen()));
                },
              ),
              IconButton(
                icon:const Icon(Icons.money_off),
                onPressed:(){
                  Navigator.push(context, MaterialPageRoute(builder:(_)=>const ExpensesScreen()));
                },
              ),
              IconButton(
                icon:const Icon(Icons.analytics),
                onPressed:(){
                  Navigator.push(context, MaterialPageRoute(builder:(_)=>const ExpensesReportScreen()));
                },
              ),
              IconButton(
                icon:const Icon(Icons.point_of_sale),
                onPressed:(){
                  Navigator.push(context, MaterialPageRoute(builder:(_)=>const SalesScreen()));
                },
              ),
              IconButton(
                icon:const Icon(Icons.receipt_long),
                onPressed:(){
                  Navigator.push(context, MaterialPageRoute(builder:(_)=>const SalesReportScreen()));
                },
              ),
              IconButton(
                icon:const Icon(Icons.list_alt),
                onPressed:(){
                  Navigator.push(context, MaterialPageRoute(builder:(_)=>const ProductionListScreen()));
                },
              ),
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
