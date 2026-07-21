
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ManagedUser {
  final String id;
  final String name;
  final String phone;
  final String password;
  final String role;
  final String shiftId;
  final bool active;
  final String createdAt;

  const ManagedUser({required this.id, required this.name, required this.phone,
    required this.password, required this.role, this.shiftId = '', this.active = true, required this.createdAt});

  Map<String,dynamic> toMap() => {
    'id': id, 'name': name, 'phone': phone, 'password': password,
    'role': role, 'shiftId': shiftId, 'active': active, 'createdAt': createdAt,
  };

  factory ManagedUser.fromMap(Map<String,dynamic> m) => ManagedUser(
    id: m['id'] ?? '', name: m['name'] ?? '', phone: m['phone'] ?? '',
    password: m['password'] ?? '', role: m['role'] ?? '\u0641\u0631\u0648\u0634\u0646\u062f\u0647',
    shiftId: m['shiftId'] ?? '', active: m['active'] ?? true,
    createdAt: m['createdAt'] ?? '',
  );
}

class UserManagementService {
  static const _key = 'bm_managed_users_v4';

  static Future<List<ManagedUser>> list() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    try {
      final data = jsonDecode(raw) as List;
      return data.map((e) => ManagedUser.fromMap(Map<String,dynamic>.from(e))).toList();
    } catch (_) { return []; }
  }

  static Future<void> _save(List<ManagedUser> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(users.map((e) => e.toMap()).toList()));
  }

  static Future<void> add(ManagedUser user) async {
    final users = await list();
    users.insert(0, user);
    await _save(users);
    // همچنین به لیست کاربران محلی اضافه می‌شود
  }

  static Future<void> update(ManagedUser user) async {
    final users = await list();
    final idx = users.indexWhere((u) => u.id == user.id);
    if (idx >= 0) { users[idx] = user; await _save(users); }
  }

  static Future<void> remove(String id) async {
    final users = await list();
    users.removeWhere((u) => u.id == id);
    await _save(users);
  }

  static String newId() => DateTime.now().microsecondsSinceEpoch.toString();
  static String now() => DateTime.now().toIso8601String();
}
