import 'api_service.dart';

class DashboardService {
  final _api = ApiService();

  Future<Map<String, dynamic>> getDaily() async {
    final data = await _api.getData('/dashboard/daily');
    return data as Map<String, dynamic>;
  }
}
