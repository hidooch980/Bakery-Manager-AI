import 'api_service.dart';

class ReportService {
  final _api = ApiService();

  Future<Map<String, dynamic>> getDailyReport() async {
    final data = await _api.getData('/daily-report');
    return data as Map<String, dynamic>;
  }
}
