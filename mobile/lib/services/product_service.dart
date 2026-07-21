import 'api_service.dart';

class ProductService {

  static Future<List<dynamic>> getProducts() async {

    final result = await ApiService.getData('products');

    if (result is List) {
      return result;
    }

    return [];
  }
}
