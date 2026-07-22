import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'services/update_manager.dart';

void main() {
  runApp(const BakeryApp());
}

class BakeryApp extends StatelessWidget {
  const BakeryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bakery Manager AI',
      theme: ThemeData(primarySwatch: Colors.orange),
      routes: {
        '/home': (_) => const DashboardScreen(),
      },
      home: Builder(builder: (context) { UpdateManager.check(context); return UpgradeAlert(child: const LoginScreen()); }),
    );
  }
}
