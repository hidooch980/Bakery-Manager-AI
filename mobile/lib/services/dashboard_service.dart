import 'api_service.dart';

class DashboardService {
  static Future<dynamic> dashboard() async {
    return await ApiService.getData('dashboard');
  }

  static Future<dynamic> daily() async {
    return await ApiService.getData('dashboard/daily');
  }
}
