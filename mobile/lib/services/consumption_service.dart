class ConsumptionService {
  static final List<Map<String, dynamic>> records = [];

  static void add({
    required String item,
    required double quantity,
    required String unit,
  }) {
    records.add({
      'item': item,
      'quantity': quantity,
      'unit': unit,
      'date': DateTime.now().toString(),
    });
  }

  static List<Map<String, dynamic>> getAll() {
    return records;
  }
}
