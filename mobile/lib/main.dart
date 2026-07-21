import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';
import 'screens/login_screen.dart';
import 'screens/stable_manager_screen.dart';
import 'services/update_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BakeryApp());
}

class BakeryApp extends StatelessWidget {
  const BakeryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bakery Manager AI',
      theme: ThemeData(colorSchemeSeed: Colors.orange, brightness: Brightness.light, useMaterial3: true, fontFamily: 'sans'),
      darkTheme: ThemeData(colorSchemeSeed: Colors.orange, brightness: Brightness.dark, useMaterial3: true, fontFamily: 'sans'),
      themeMode: ThemeMode.system,
      routes: {
        '/home': (_) => const StableManagerScreen(),
      },
      home: Builder(
        builder: (context) {
          UpdateManager.check(context);
          return UpgradeAlert(child: const LoginScreen());
        },
      ),
    );
  }
}
