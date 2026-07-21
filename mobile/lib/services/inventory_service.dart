class InventoryService {
  static final List<Map<String, dynamic>> items = [];

  static void add({
    required String name,
    required double quantity,
    required String unit,
  }) {
    items.add({
      'name': name,
      'quantity': quantity,
      'unit': unit,
      'date': DateTime.now().toString(),
    });
  }

  static List<Map<String, dynamic>> getAll() {
    return items;
  }
}
