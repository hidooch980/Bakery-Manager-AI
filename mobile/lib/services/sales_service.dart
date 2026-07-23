import 'api_service.dart';

class SalesService {
  static List<Map<String, dynamic>> _cache = [];

  static List<Map<String, dynamic>> getAll() {
    _refresh();
    return _cache;
  }

  static Future<void> _refresh() async {
    final data = await ApiService.getData('/sales');
    if (data is List) {
      _cache = data
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
  }

  static Future<bool> createSale({
    required String productId,
    required int quantity,
  }) async {
    try {
      final result = await ApiService.postData('/sales', {
        'items': [
          {'productId': productId, 'quantity': quantity},
        ],
      });
      await _refresh();
      return result != null;
    } catch (_) {
      return false;
    }
  }
}
