import 'api_service.dart';

class SalesService {
  final _api = ApiService();

  Future<List<dynamic>> getAll() async {
    final data = await _api.getData('/sales');
    return data as List<dynamic>;
  }

  Future<void> create(String productId, int quantity) async {
    await _api.postData('/sales', {
      'items': [
        {'productId': productId, 'quantity': quantity},
      ],
    });
  }
}
