class SalesService {
  static final List<Map<String, dynamic>> records = [];

  static void save({
    required int bread,
    required int cash,
    required int card,
  }) {
    records.add({
      'date': DateTime.now().toString(),
      'bread': bread,
      'cash': cash,
      'card': card,
      'total': cash + card,
    });
  }

  static List<Map<String, dynamic>> getAll() {
    return records;
  }
static Future createSale(Map data) async { return true; }
}
