import 'api_service.dart';

class DashboardService {
  static Future<Map<String, dynamic>> dashboard() async {
    final data = await ApiService.getData('/dashboard/daily');
    if (data is Map<String, dynamic>) return data;
    return {};
  }

  static Future<Map<String, dynamic>> daily() => dashboard();
}
