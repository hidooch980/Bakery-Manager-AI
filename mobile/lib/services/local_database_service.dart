import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'bale_sync_service.dart';

class LocalDatabaseService {
  static const _salesKey = 'bm_sales';
  static const _productionKey = 'bm_production';
  static const _flourKey = 'bm_flour';
  static const _expensesKey = 'bm_expenses';
  static const _usersKey = 'bm_users';
  static const _settingsKey = 'bm_settings';
  static const _syncQueueKey = 'bm_sync_queue';

  static Future<List<Map<String, dynamic>>> _list(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    if (raw == null || raw.isEmpty) return [];
    final decoded = jsonDecode(raw);
    if (decoded is! List) return [];
    return decoded
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  static Future<void> _saveList(String key, List<Map<String, dynamic>> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(data));
  }

  static String _id() => DateTime.now().microsecondsSinceEpoch.toString();
  static String _now() => DateTime.now().toIso8601String();

  static Future<void> _queue(String type, Map<String, dynamic> payload) async {
    final q = await syncQueue();
    q.add({'id': _id(), 'type': type, 'payload': payload, 'createdAt': _now()});
    await _saveList(_syncQueueKey, q);
    // ارسال آنلاین رایگان به گروه مدیر در بله (در صورت فعال بودن)
    BaleSyncService.trySend(type, payload);
  }

  static Future<void> addSale({
    required String breadType,
    required int quantity,
    required int cash,
    required int card,
    required int debt,
    required String seller,
    String note = '',
  }) async {
    final item = {
      'id': _id(),
      'breadType': breadType,
      'quantity': quantity,
      'cash': cash,
      'card': card,
      'debt': debt,
      'total': cash + card + debt,
      'seller': seller,
      'note': note,
      'createdAt': _now(),
      'synced': false,
    };
    final data = await sales();
    data.insert(0, item);
    await _saveList(_salesKey, data);
    await _queue('sale', item);
  }

  static Future<void> addProduction({
    required String shift,
    required int flourBags,
    required double flourKg,
    required int dough,
    required int pieces,
    required int bread,
    required int waste,
    required String worker,
    String note = '',
  }) async {
    final item = {
      'id': _id(),
      'shift': shift,
      'flourBags': flourBags,
      'flourKg': flourKg,
      'dough': dough,
      'pieces': pieces,
      'bread': bread,
      'waste': waste,
      'worker': worker,
      'note': note,
      'efficiency': flourKg > 0 ? bread / flourKg : 0,
      'createdAt': _now(),
      'synced': false,
    };
    final data = await productions();
    data.insert(0, item);
    await _saveList(_productionKey, data);
    await _queue('production', item);
    await addFlourMovement(
      type: 'مصرف تولید',
      bagsIn: 0,
      bagsOut: flourBags,
      bagWeight: flourBags > 0 ? flourKg / flourBags : 40,
      note: 'مصرف آرد شیفت $shift',
      queue: false,
    );
  }

  static Future<void> addFlourMovement({
    required String type,
    required double bagsIn,
    required double bagsOut,
    required double bagWeight,
    String note = '',
    bool queue = true,
  }) async {
    final previous = await flourStockBags();
    final item = {
      'id': _id(),
      'type': type,
      'bagsIn': bagsIn,
      'bagsOut': bagsOut,
      'bagWeight': bagWeight,
      'kgIn': bagsIn * bagWeight,
      'kgOut': bagsOut * bagWeight,
      'stockAfter': previous + bagsIn - bagsOut,
      'note': note,
      'createdAt': _now(),
      'synced': false,
    };
    final data = await flourMovements();
    data.insert(0, item);
    await _saveList(_flourKey, data);
    if (queue) await _queue('flour', item);
  }

  static Future<void> addExpense({
    required String title,
    required int amount,
    required String category,
    bool paid = true,
    String note = '',
  }) async {
    final item = {
      'id': _id(),
      'title': title,
      'amount': amount,
      'category': category,
      'paid': paid,
      'note': note,
      'createdAt': _now(),
      'synced': false,
    };
    final data = await expenses();
    data.insert(0, item);
    await _saveList(_expensesKey, data);
    await _queue('expense', item);
  }

  static Future<void> addUser({
    required String name,
    required String phone,
    required String password,
    required String role,
    bool active = true,
  }) async {
    final users = await appUsers();
    final idx = users.indexWhere((u) => u['phone'] == phone);
    final item = {
      'id': idx >= 0 ? users[idx]['id'] : _id(),
      'name': name,
      'phone': phone,
      'password': password,
      'role': role,
      'active': active,
      'createdAt': idx >= 0 ? users[idx]['createdAt'] : _now(),
    };
    if (idx >= 0) {
      users[idx] = item;
    } else {
      users.insert(0, item);
    }
    await _saveList(_usersKey, users);
  }

  static Future<Map<String, dynamic>?> loginLocal(String phone, String password) async {
    await ensureDefaults();
    final users = await appUsers();
    for (final user in users) {
      if (user['phone'] == phone && user['password'] == password && user['active'] != false) {
        return user;
      }
    }
    return null;
  }

  static Future<void> ensureDefaults() async {
    final users = await appUsers();
    if (users.isEmpty) {
      await addUser(
        name: 'مدیر نانوایی',
        phone: '09000000000',
        password: 'Admin@123',
        role: 'MANAGER',
      );
    }
    final settings = await appSettings();
    if (settings.isEmpty) {
      await saveSettings({
        'bakeryName': 'نانوایی من',
        'breadType': 'سنتی',
        'breadPrice': 5000,
        'bagWeight': 40,
        'minFlourBags': 5,
        'dailyCapacity': 3000,
        'standardDoughWeight': 0.85,
      });
    }
  }

  static Future<void> saveSettings(Map<String, dynamic> settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, jsonEncode(settings));
  }

  static Future<Map<String, dynamic>> appSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_settingsKey);
    if (raw == null || raw.isEmpty) return {};
    final decoded = jsonDecode(raw);
    return decoded is Map ? Map<String, dynamic>.from(decoded) : {};
  }

  static Future<List<Map<String, dynamic>>> sales() => _list(_salesKey);
  static Future<void> saveSales(List<Map<String, dynamic>> data) => _saveList(_salesKey, data);
  static Future<List<Map<String, dynamic>>> productions() => _list(_productionKey);
  static Future<List<Map<String, dynamic>>> flourMovements() => _list(_flourKey);
  static Future<List<Map<String, dynamic>>> expenses() => _list(_expensesKey);
  static Future<List<Map<String, dynamic>>> appUsers() => _list(_usersKey);
  static Future<List<Map<String, dynamic>>> syncQueue() => _list(_syncQueueKey);

  static bool _isToday(Map<String, dynamic> item) {
    final raw = item['createdAt']?.toString();
    if (raw == null) return false;
    final dt = DateTime.tryParse(raw);
    if (dt == null) return false;
    final now = DateTime.now();
    return dt.year == now.year && dt.month == now.month && dt.day == now.day;
  }

  static Future<double> flourStockBags() async {
    final data = await flourMovements();
    double total = 0;
    for (final item in data.reversed) {
      total += (item['bagsIn'] as num? ?? 0).toDouble();
      total -= (item['bagsOut'] as num? ?? 0).toDouble();
    }
    return total;
  }

  static Future<Map<String, dynamic>> dashboard() async {
    await ensureDefaults();
    final allSales = await sales();
    final allProductions = await productions();
    final allExpenses = await expenses();
    final settings = await appSettings();

    final todaySales = allSales.where(_isToday).toList();
    final todayProductions = allProductions.where(_isToday).toList();
    final todayExpenses = allExpenses.where(_isToday).toList();

    final salesTotal = todaySales.fold<num>(0, (s, e) => s + (e['total'] as num? ?? 0));
    final cash = todaySales.fold<num>(0, (s, e) => s + (e['cash'] as num? ?? 0));
    final card = todaySales.fold<num>(0, (s, e) => s + (e['card'] as num? ?? 0));
    final debt = todaySales.fold<num>(0, (s, e) => s + (e['debt'] as num? ?? 0));
    final bread = todayProductions.fold<num>(0, (s, e) => s + (e['bread'] as num? ?? 0));
    final waste = todayProductions.fold<num>(0, (s, e) => s + (e['waste'] as num? ?? 0));
    final flourKg = todayProductions.fold<num>(0, (s, e) => s + (e['flourKg'] as num? ?? 0));
    final expensesTotal = todayExpenses.fold<num>(0, (s, e) => s + (e['amount'] as num? ?? 0));
    final flourStock = await flourStockBags();

    return {
      'sales': salesTotal,
      'cash': cash,
      'card': card,
      'debt': debt,
      'production': bread,
      'waste': waste,
      'flourKg': flourKg,
      'expenses': expensesTotal,
      'profit': salesTotal - expensesTotal,
      'flourStock': flourStock,
      'minFlourBags': settings['minFlourBags'] ?? 5,
      'syncQueue': (await syncQueue()).length,
      'salesCount': todaySales.length,
    };
  }

  static Future<List<String>> aiRecommendations() async {
    final d = await dashboard();
    final recs = <String>[];
    final flourStock = (d['flourStock'] as num).toDouble();
    final minFlour = (d['minFlourBags'] as num).toDouble();
    final production = (d['production'] as num).toDouble();
    final sales = (d['sales'] as num).toDouble();
    final expenses = (d['expenses'] as num).toDouble();
    final waste = (d['waste'] as num).toDouble();
    final flourKg = (d['flourKg'] as num).toDouble();

    if (flourStock <= minFlour) {
      recs.add('موجودی آرد پایین است؛ خرید آرد را در اولویت قرار دهید.');
    }
    if (production == 0) {
      recs.add('امروز هنوز تولیدی ثبت نشده است.');
    }
    if (sales == 0) {
      recs.add('امروز هنوز فروشی ثبت نشده است.');
    }
    if (expenses > sales && sales > 0) {
      recs.add('هزینه‌های امروز از فروش بیشتر است؛ هزینه‌ها بررسی شوند.');
    }
    if (production > 0 && waste / production > 0.05) {
      recs.add('ضایعات تولید بیش از ۵٪ است؛ وزن چانه و فرآیند پخت بررسی شود.');
    }
    if (flourKg > 0 && production / flourKg < 8) {
      recs.add('بازده تولید نسبت به آرد مصرفی پایین است.');
    }
    if (recs.isEmpty) {
      recs.add('وضعیت امروز عادی است؛ داده‌ها منظم ثبت شده‌اند.');
    }
    return recs;
  }

  static Future<int> forecastTomorrowBread() async {
    final allSales = await sales();
    if (allSales.isEmpty) return 0;
    final recent = allSales.take(7).toList();
    final totalQty = recent.fold<num>(0, (s, e) => s + (e['quantity'] as num? ?? 0));
    return (totalQty / recent.length * 1.1).round();
  }

  static Future<Map<String, dynamic>> exportSnapshot() async => {
    'sales': await sales(), 'productions': await productions(),
    'flour': await flourMovements(), 'expenses': await expenses(),
    'users': await appUsers(), 'settings': await appSettings(),
    'syncQueue': await syncQueue(),
  };

  static Future<void> restoreSnapshot(Map<String, dynamic> data) async {
    List<Map<String,dynamic>> rows(String key) => (data[key] is List)
      ? (data[key] as List).whereType<Map>().map((e)=>Map<String,dynamic>.from(e)).toList() : [];
    await _saveList(_salesKey, rows('sales')); await _saveList(_productionKey, rows('productions'));
    await _saveList(_flourKey, rows('flour')); await _saveList(_expensesKey, rows('expenses'));
    await _saveList(_usersKey, rows('users')); await _saveList(_syncQueueKey, rows('syncQueue'));
    if(data['settings'] is Map) await saveSettings(Map<String,dynamic>.from(data['settings']));
  }

  /// ادغام بکاپ گوشی دیگر بدون حذف داده‌های فعلی (بر اساس id).
  static Future<void> mergeSnapshot(Map<String, dynamic> data) async {
    List<Map<String, dynamic>> rows(String key) => (data[key] is List)
        ? (data[key] as List).whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList()
        : [];
    Future<void> mergeInto(String storeKey, List<Map<String, dynamic>> incoming) async {
      final current = await _list(storeKey);
      final ids = current.map((e) => '${e['id']}').toSet();
      for (final item in incoming) {
        if (!ids.contains('${item['id']}')) current.add(item);
      }
      current.sort((a, b) => '${b['createdAt']}'.compareTo('${a['createdAt']}'));
      await _saveList(storeKey, current);
    }
    await mergeInto(_salesKey, rows('sales'));
    await mergeInto(_productionKey, rows('productions'));
    await mergeInto(_flourKey, rows('flour'));
    await mergeInto(_expensesKey, rows('expenses'));
  }

  static Future<void> clearDemoData() async {
    await _saveList(_salesKey, []);
    await _saveList(_productionKey, []);
    await _saveList(_flourKey, []);
    await _saveList(_expensesKey, []);
    await _saveList(_syncQueueKey, []);
  }
}
