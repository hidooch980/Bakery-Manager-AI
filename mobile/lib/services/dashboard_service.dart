import 'api_service.dart';

class DashboardService {
  static Future<Map<String, dynamic>> dashboard() async {
    final result = await ApiService.getData('dashboard');
    return _normalize(result);
  }

  static Future<Map<String, dynamic>> daily() async {
    final result = await ApiService.getData('daily-report');
    return _normalize(result);
  }

  static Map<String, dynamic> _normalize(dynamic result) {
    if (result is! Map) {
      return {};
    }

    final map = Map<String, dynamic>.from(result);

    if (map.containsKey('today')) {
      final today = Map<String, dynamic>.from(map['today'] ?? {});
      final inventory = Map<String, dynamic>.from(map['inventory'] ?? {});
      return {
        'sales': today['sales'] ?? 0,
        'production': today['production'] ?? 0,
        'expenses': today['expenses'] ?? 0,
        'profit': today['profit'] ?? 0,
        'flour': inventory['flour'] ?? 0,
        'cash': today['cash'] ?? 0,
      };
    }

    if (map.containsKey('production') || map.containsKey('sellerDebt')) {
      final production = Map<String, dynamic>.from(map['production'] ?? {});
      final sales = Map<String, dynamic>.from(map['sales'] ?? {});
      return {
        'sales': sales['total'] ?? 0,
        'production': production['breadCount'] ?? 0,
        'expenses': map['expenses'] ?? 0,
        'profit': map['profit'] ?? 0,
        'flour': production['flourBags'] ?? 0,
        'cash': sales['cash'] ?? 0,
      };
    }

    return map;
  }
}
