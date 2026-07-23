import 'api_service.dart';

class ReportService {
  static Future<Map<String, dynamic>> daily() async {
    final data = await ApiService.getData('/daily-report');
    if (data is Map<String, dynamic>) return data;
    return {};
  }
}
