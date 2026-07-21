
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Shift {
  final String id;
  final String name;
  final String startTime;   // HH:mm
  final String endTime;
  final bool active;

  const Shift({required this.id, required this.name,
    required this.startTime, required this.endTime, this.active = true});

  Map<String,dynamic> toMap() => {
    'id': id, 'name': name, 'startTime': startTime,
    'endTime': endTime, 'active': active,
  };

  factory Shift.fromMap(Map<String,dynamic> m) => Shift(
    id: m['id'] ?? DateTime.now().toString(),
    name: m['name'] ?? '',
    startTime: m['startTime'] ?? '06:00',
    endTime: m['endTime'] ?? '14:00',
    active: m['active'] ?? true,
  );
}

class ShiftService {
  static const _key = 'bm_shifts_v4';

  static final List<Shift> _defaults = [
    Shift(id: 's1', name: '\u0635\u0628\u062d', startTime: '06:00', endTime: '14:00'),
    Shift(id: 's2', name: '\u0639\u0635\u0631', startTime: '14:00', endTime: '22:00'),
    Shift(id: 's3', name: '\u0634\u0628', startTime: '22:00', endTime: '06:00'),
  ];

  static Future<List<Shift>> list() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) {
      await save(_defaults);
      return _defaults;
    }
    try {
      final list = jsonDecode(raw) as List;
      return list.map((e) => Shift.fromMap(Map<String,dynamic>.from(e))).toList();
    } catch (_) { return _defaults; }
  }

  static Future<void> save(List<Shift> shifts) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(shifts.map((e) => e.toMap()).toList()));
  }

  static Future<void> add(Shift shift) async {
    final existing = await list();
    existing.add(shift);
    await save(existing);
  }

  static Future<void> remove(String id) async {
    final existing = await list();
    existing.removeWhere((s) => s.id == id);
    await save(existing);
  }

  static Future<Shift?> current() async {
    final now = DateTime.now();
    final h = now.hour;
    final m = now.minute;
    final current = h * 60 + m;
    final shifts = await list();
    for (final s in shifts) {
      if (!s.active) continue;
      final parts1 = s.startTime.split(':');
      final parts2 = s.endTime.split(':');
      final start = int.parse(parts1[0]) * 60 + int.parse(parts1[1]);
      final end   = int.parse(parts2[0]) * 60 + int.parse(parts2[1]);
      if (start <= end) {
        if (current >= start && current < end) return s;
      } else { // overnight
        if (current >= start || current < end) return s;
      }
    }
    return shifts.isNotEmpty ? shifts[0] : null;
  }
}
