
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BreadType {
  final String id;
  final String name;
  final double doughWeight;    // گرم — وزن چانه
  final double saleWeight;     // گرم — وزن نان پخته
  final double waterRatio;     // درصد آب (0.0-1.0)
  final bool active;

  const BreadType({
    required this.id,
    required this.name,
    required this.doughWeight,
    required this.saleWeight,
    required this.waterRatio,
    this.active = true,
  });

  /// تعداد چانه از هر کیسه آرد
  double doughsPerBag(double bagWeightGrams) {
    final doughMass = bagWeightGrams * (1 + waterRatio);
    return doughMass / doughWeight;
  }

  Map<String,dynamic> toMap() => {
    'id': id, 'name': name,
    'doughWeight': doughWeight, 'saleWeight': saleWeight,
    'waterRatio': waterRatio, 'active': active,
  };

  factory BreadType.fromMap(Map<String,dynamic> m) => BreadType(
    id: m['id'] ?? DateTime.now().toString(),
    name: m['name'] ?? '',
    doughWeight: (m['doughWeight'] as num?)?.toDouble() ?? 300,
    saleWeight: (m['saleWeight'] as num?)?.toDouble() ?? 250,
    waterRatio: (m['waterRatio'] as num?)?.toDouble() ?? 0.6,
    active: m['active'] ?? true,
  );
}

class BakerySystemService {
  static const _key = 'bm_system_v4';
  static const _breadKey = 'bm_bread_types_v4';

  static final List<BreadType> _defaults = [
    BreadType(id: 'sangak', name: '\u0633\u0646\u06af\u06a9', doughWeight: 350, saleWeight: 300, waterRatio: 0.60),
    BreadType(id: 'lavash', name: '\u0644\u0648\u0627\u0634', doughWeight: 150, saleWeight: 120, waterRatio: 0.55),
    BreadType(id: 'tafton', name: '\u062a\u0627\u0641\u062a\u0648\n', doughWeight: 250, saleWeight: 210, waterRatio: 0.58),
    BreadType(id: 'barbari', name: '\u0628\u0631\u0628\u0631\u06cc', doughWeight: 400, saleWeight: 340, waterRatio: 0.62),
  ];

  static Future<Map<String,dynamic>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return _defaultConfig();
    try { return Map<String,dynamic>.from(jsonDecode(raw)); }
    catch (_) { return _defaultConfig(); }
  }

  static Map<String,dynamic> _defaultConfig() => {
    'bakeryName': '\u0646\u0627\u0646\u0648\u0627\u06cc\u06cc',
    'ownerName': '',
    'city': '',
    'address': '',
    'license': '',
    'phone': '',
    'breadPrice': 5000,           // قیمت واحد نان (تومان)
    'bagWeightKg': 40,            // وزن هر کیسه آرد (کیلو)
    'minFlourBags': 5,            // حداقل موجودی آرد
    'period1Flour': 48,           // آرد تخصیصی دوره ۱
    'period2Flour': 48,           // آرد تخصیصی دوره ۲
    'period3Flour': 48,           // آرد تخصیصی دوره ۳
  };

  static Future<void> save(Map<String,dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(data));
  }

  static Future<List<BreadType>> loadBreadTypes() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_breadKey);
    if (raw == null) {
      await saveBreadTypes(_defaults);
      return _defaults;
    }
    try {
      final list = jsonDecode(raw) as List;
      return list.map((e) => BreadType.fromMap(Map<String,dynamic>.from(e))).toList();
    } catch (_) { return _defaults; }
  }

  static Future<void> saveBreadTypes(List<BreadType> types) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_breadKey, jsonEncode(types.map((e) => e.toMap()).toList()));
  }

  static Future<String> bakeryName() async {
    final d = await load();
    return d['bakeryName']?.toString() ?? '\u0646\u0627\u0646\u0648\u0627\u06cc\u06cc';
  }

  static Future<int> breadPrice() async {
    final d = await load();
    return (d['breadPrice'] as num?)?.toInt() ?? 5000;
  }

  static Future<double> bagWeightGrams() async {
    final d = await load();
    return ((d['bagWeightKg'] as num?)?.toDouble() ?? 40) * 1000;
  }
}
