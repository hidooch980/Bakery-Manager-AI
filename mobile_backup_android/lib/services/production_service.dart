class ProductionService {
  static final List<Map<String, dynamic>> records = [];

  static void save({
    required int dough,
    required int pieces,
    required int bread,
  }) {
    records.add({
      'date': DateTime.now().toString(),
      'dough': dough,
      'pieces': pieces,
      'bread': bread,
    });
  }

  static List<Map<String, dynamic>> getAll() {
    return records;
  }
}
