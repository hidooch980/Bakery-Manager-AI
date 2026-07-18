class ExpenseService {
  static final List<Map<String, dynamic>> records = [];

  static void save({
    required String title,
    required int amount,
  }) {
    records.add({
      'date': DateTime.now().toString(),
      'title': title,
      'amount': amount,
    });
  }

  static List<Map<String, dynamic>> getAll() {
    return records;
  }
}
