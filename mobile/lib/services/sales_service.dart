import 'api_service.dart';

class SalesService {

  static final List<Map<String,dynamic>> records = [];

  static void save({
    required int bread,
    required int cash,
    required int card,
  }) {
    records.add({
      'bread': bread,
      'cash': cash,
      'card': card,
      'total': cash + card,
    });
  }

  static List<Map<String,dynamic>> getAll() {
    return records;
  }

  static Future<bool> createSale({
    required String productId,
    required int quantity,
  }) async {

    final result = await ApiService.postData(
      'sales',
      {
        "items": [
          {
            "productId": productId,
            "quantity": quantity
          }
        ]
      },
    );

    return result != null;
  }
}
