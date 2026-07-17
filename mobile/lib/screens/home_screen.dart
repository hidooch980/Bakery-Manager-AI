import 'package:flutter/material.dart';
import '../services/user_service.dart';
class HomeScreen extends StatefulWidget{const HomeScreen({super.key});@override State<HomeScreen> createState()=>_HomeScreenState();}
class _HomeScreenState extends State<HomeScreen>{
String role='EMPLOYEE';
@override void initState(){super.initState();load();}
void load()async{role=await UserService.getRole();setState((){});}
@override Widget build(BuildContext c){return Scaffold(appBar:AppBar(title:Text('Bakery Manager AI - $role')),body:ListView(children:[
if(role=='ADMIN')ListTile(title:Text('داشبورد مدیر'),icon:Icon(Icons.dashboard)),
if(role=='ADMIN'||role=='SELLER')ListTile(title:Text('ثبت فروش'),icon:Icon(Icons.sell)),
if(role=='ADMIN'||role=='KNEADER')ListTile(title:Text('ثبت خمیر'),icon:Icon(Icons.factory)),
if(role=='ADMIN'||role=='DIVIDER')ListTile(title:Text('ثبت چانه'),icon:Icon(Icons.scale)),
ListTile(title:Text('خروج'),icon:Icon(Icons.logout))
]));}}
