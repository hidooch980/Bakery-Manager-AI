import 'api_service.dart';

class ProductionStandardService {
  static Future<Map<String, dynamic>> getStandard() async {
    final result = await ApiService.getData('production-standards');
    if (result is Map<String, dynamic>) return result;
    return {};
  }

  static Future<void> updateStandard(Map<String, dynamic> data) async {
    await ApiService.patchData('production-standards/1', data);
  }
}
