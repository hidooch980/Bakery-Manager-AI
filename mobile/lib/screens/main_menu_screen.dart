import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'seller_screen.dart';
import 'production_screen.dart';
import 'report_screen.dart';
import 'settings_screen.dart';

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
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            icon: Icon(Icons.dashboard),
            selectedIcon: Icon(Icons.dashboard),
            label: 'داشبورد',
          ),
          NavigationDestination(
            icon: Icon(Icons.point_of_sale),
            selectedIcon: Icon(Icons.point_of_sale),
            label: 'فروش',
          ),
          NavigationDestination(
            icon: Icon(Icons.bakery_dining),
            selectedIcon: Icon(Icons.bakery_dining),
            label: 'تولید',
          ),
          NavigationDestination(
            icon: Icon(Icons.assessment),
            selectedIcon: Icon(Icons.assessment),
            label: 'گزارشات',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            selectedIcon: Icon(Icons.settings),
            label: 'تنظیمات',
          ),
        ],
      ),
    );
  }
}
