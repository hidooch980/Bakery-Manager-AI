import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'seller_screen.dart';
import 'production_screen.dart';
import 'report_screen.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    DashboardScreen(),
    SellerScreen(),
    ProductionScreen(),
    ReportScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مدیریت نانوایی'),
        centerTitle: true,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            selectedIcon: Icon(Icons.home),
            label: 'داشبورد',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart),
            selectedIcon: Icon(Icons.shopping_cart),
            label: 'فروش',
          ),
          NavigationDestination(
            icon: Icon(Icons.build),
            selectedIcon: Icon(Icons.build),
            label: 'تولید',
          ),
          NavigationDestination(
            icon: Icon(Icons.list),
            selectedIcon: Icon(Icons.list),
            label: 'گزارشات',
          ),
        ],
      ),
    }
  }
}
