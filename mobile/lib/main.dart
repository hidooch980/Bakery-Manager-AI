import 'package:flutter/material.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/sales/sales_screen.dart';
import 'screens/production/production_screen.dart';
import 'screens/inventory/inventory_screen.dart';
import 'screens/purchases/purchases_screen.dart';

void main() => runApp(const BakeryApp());

class BakeryApp extends StatelessWidget {
  const BakeryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bakery Manager AI',
      theme: ThemeData(
        colorSchemeSeed: Colors.orange,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends Stateful
cd ~/projects/Bakery-Manager-AI/mobile && cat > lib/main.dart <<'EOF'
import 'package:flutter/material.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/sales/sales_screen.dart';
import 'screens/production/production_screen.dart';
import 'screens/inventory/inventory_screen.dart';
import 'screens/purchases/purchases_screen.dart';

void main() => runApp(const BakeryApp());

class BakeryApp extends StatelessWidget {
  const BakeryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bakery Manager AI',
      theme: ThemeData(
        colorSchemeSeed: Colors.orange,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;

  final pages = const [
    DashboardScreen(),
    SalesScreen(),
    ProductionScreen(),
    InventoryScreen(),
    PurchasesScreen(),
  ];

  final titles = const [
    'داشبورد',
    'فروش',
    'تولید',
    'انبار',
    'خریدها',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(titles[index])),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child:
cd ~/projects/Bakery-Manager-AI/mobile && cat > lib/main.dart <<'EOF'
import 'package:flutter/material.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/sales/sales_screen.dart';
import 'screens/production/production_screen.dart';
import 'screens/inventory/inventory_screen.dart';
import 'screens/purchases/purchases_screen.dart';

void main() => runApp(const BakeryApp());

class BakeryApp extends StatelessWidget {
  const BakeryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bakery Manager AI',
      theme: ThemeData(
        colorSchemeSeed: Colors.orange,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;

  final pages = const [
    DashboardScreen(),
    SalesScreen(),
    ProductionScreen(),
    InventoryScreen(),
    PurchasesScreen(),
  ];

  final titles = const [
    'داشبورد',
    'فروش',
    'تولید',
    'انبار',
    'خریدها',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(titles[index])),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Center(
                child: Text(
                  'Bakery Manager AI',
                  style: TextStyle(fontSize: 22),
                ),
              ),
            ),
            for (int i = 0; i < titles.length; i++)
              ListTile(
                title: Text(titles[i]),
                onTap: () {
                  setState(() => index = i);
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'داشبورد'),
          NavigationDestination(icon: Icon(Icons.point_of_sale), label: 'فروش'),
          NavigationDestination(icon: Icon(Icons.bakery_dining), label: 'تولید'),
          NavigationDestination(icon: Icon(Icons.inventory), label: 'انبار'),
          NavigationDestination(icon: Icon(Icons.shopping_cart), label: 'خرید'),
        ],
        onDestinationSelected: (i) => setState(() => index = i),
      ),
    );
  }
}
