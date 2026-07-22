import 'package:flutter/material.dart';

import '../screens/dashboard_screen.dart';
import '../screens/sales_screen.dart';
import '../screens/production_screen.dart';

class AppRouter {
  static Widget home(String role) {
    switch (role) {
      case 'MANAGER':
        return const DashboardScreen();

      case 'SELLER':
        return const SalesScreen();

      case 'DOUGH':
        return const ProductionScreen();

      case 'DIVIDER':
        return const ProductionScreen();

      default:
        return const DashboardScreen();
    }
  }
}
