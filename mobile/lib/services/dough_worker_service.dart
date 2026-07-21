
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'bakery_system_service.dart';

class DoughRecord {
  final String id;
  final String workerName;
  final String breadTypeId;
  final String breadTypeName;
  final double flourBagsUsed;
  final double bagWeightGrams;
  final double doughWeightGrams;
  final double waterRatioUsed;
  final int systematicDoughs;   // سیستماتیک
  final int actualDoughs;       // ثبت‌شده
  final int diff;               // اختلاف
  final double diffPercent;
  final String status;          // green/yellow/red
  final String shiftId;
  final String note;
  final String createdAt;

  const DoughRecord({
    required this.id, required this.workerName,
    required this.breadTypeId, required this.breadTypeName,
    required this.flourBagsUsed, required this.bagWeightGrams,
    required this.doughWeightGrams, required this.waterRatioUsed,
    required this.systematicDoughs, required this.actualDoughs,
    required this.diff, required this.diffPercent, required this.status,
    required this.shiftId, required this.note, required this.createdAt,
  });

  Map<String,dynamic> toMap() => {
    'id': id, 'workerName': workerName, 'breadTypeId': breadTypeId,
    'breadTypeName': breadTypeName, 'flourBagsUsed': flourBagsUsed,
    'bagWeightGrams': bagWeightGrams, 'doughWeightGrams': doughWeightGrams,
    'waterRatioUsed': waterRatioUsed, 'systematicDoughs': systematicDoughs,
    'actualDoughs': actualDoughs, 'diff': diff, 'diffPercent': diffPercent,
    'status': status, 'shiftId': shiftId, 'note': note, 'createdAt': createdAt,
  };

  factory DoughRecord.fromMap(Map<String,dynamic> m) => DoughRecord(
    id: m['id'] ?? '', workerName: m['workerName'] ?? '',
    breadTypeId: m['breadTypeId'] ?? '', breadTypeName: m['breadTypeName'] ?? '',
    flourBagsUsed: (m['flourBagsUsed'] as num?)?.toDouble() ?? 0,
    bagWeightGrams: (m['bagWeightGrams'] as num?)?.toDouble() ?? 40000,
    doughWeightGrams: (m['doughWeightGrams'] as num?)?.toDouble() ?? 300,
    waterRatioUsed: (m['waterRatioUsed'] as num?)?.toDouble() ?? 0.6,
    systematicDoughs: (m['systematicDoughs'] as num?)?.toInt() ?? 0,
    actualDoughs: (m['actualDoughs'] as num?)?.toInt() ?? 0,
    diff: (m['diff'] as num?)?.toInt() ?? 0,
    diffPercent: (m['diffPercent'] as num?)?.toDouble() ?? 0,
    status: m['status'] ?? 'green',
    shiftId: m['shiftId'] ?? '', note: m['note'] ?? '',
    createdAt: m['createdAt'] ?? '',
  );
}

class DoughWorkerService {
  static const _key = 'bm_dough_records_v4';

  static String _id() => DateTime.now().microsecondsSinceEpoch.toString();
  static String _now() => DateTime.now().toIso8601String();

  static Future<List<DoughRecord>> records() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list.map((e) => DoughRecord.fromMap(Map<String,dynamic>.from(e))).toList();
    } catch (_) { return []; }
  }

  /// محاسبه و ثبت چانه
  static Future<DoughRecord> addRecord({
    required String workerName,
    required BreadType breadType,
    required double flourBagsUsed,
    required int actualDoughs,
    required String shiftId,
    String note = '',
  }) async {
    final bagGrams = await BakerySystemService.bagWeightGrams();
    final doughMass = bagGrams * (1 + breadType.waterRatio) * flourBagsUsed;
    final systematic = (doughMass / breadType.doughWeight).round();
    final diff = systematic - actualDoughs;
    final pct = systematic > 0 ? (diff.abs() / systematic * 100) : 0.0;
    final status = pct < 1.0 ? 'green' : pct < 3.0 ? 'yellow' : 'red';

    final record = DoughRecord(
      id: _id(), workerName: workerName,
      breadTypeId: breadType.id, breadTypeName: breadType.name,
      flourBagsUsed: flourBagsUsed, bagWeightGrams: bagGrams,
      doughWeightGrams: breadType.doughWeight, waterRatioUsed: breadType.waterRatio,
      systematicDoughs: systematic, actualDoughs: actualDoughs,
      diff: diff, diffPercent: pct, status: status,
      shiftId: shiftId, note: note, createdAt: _now(),
    );

    final existing = await records();
    existing.insert(0, record);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(existing.map((e) => e.toMap()).toList()));
    return record;
  }
}
