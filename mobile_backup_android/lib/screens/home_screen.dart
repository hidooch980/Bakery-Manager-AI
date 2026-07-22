import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String role = 'EMPLOYEE';

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() {
    setState(() {
      role = AuthService.role();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Bakery Manager AI - $role'),
      ),

      body: ListView(
        children: [

          if(role == 'MANAGER')
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('داشبورد مدیر'),
            ),

          if(role == 'MANAGER' || role == 'SELLER')
            ListTile(
              leading: const Icon(Icons.sell),
              title: const Text('ثبت فروش'),
            ),

          if(role == 'MANAGER' || role == 'DOUGH')
            ListTile(
              leading: const Icon(Icons.factory),
              title: const Text('ثبت خمیر'),
            ),

          if(role == 'MANAGER' || role == 'DIVIDER')
            ListTile(
              leading: const Icon(Icons.scale),
              title: const Text('ثبت چانه'),
            ),

          const ListTile(
            leading: Icon(Icons.logout),
            title: Text('خروج'),
          ),

        ],
      ),
    );
  }
}
