import 'api_service.dart';

class ProductionStandardService {
  static Future<Map<String, dynamic>> getStandard() async {
    // از ApiService استفاده می‌شود تا آدرس مرکزی و توکن احراز هویت اعمال شود
    final result = await ApiService.getData('production-standards');

    if (result is Map<String, dynamic>) {
      return result;
    }
    if (result is List && result.isNotEmpty && result.first is Map<String, dynamic>) {
      return result.first as Map<String, dynamic>;
    }

    throw Exception(ApiService.lastError.isNotEmpty
        ? ApiService.lastError
        : 'خطا در دریافت استاندارد تولید');
  }

  static Future<void> updateStandard(Map<String, dynamic> data) async {
    await ApiService.patchData('production-standards/1', data);
  }
}
