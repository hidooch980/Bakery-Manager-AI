
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

enum SaleType { cash, credit, home }

extension SaleTypeLabel on SaleType {
  String get label {
    switch (this) {
      case SaleType.cash:   return '\u0646\u0642\u062f\u06cc';
      case SaleType.credit: return '\u0646\u0633\u06cc\u0647';
      case SaleType.home:   return '\u0645\u0646\u0632\u0644';
    }
  }
  String get icon {
    switch (this) {
      case SaleType.cash:   return '\ud83d\udcb5';
      case SaleType.credit: return '\ud83d\udccb';
      case SaleType.home:   return '\ud83c\udfe0';
    }
  }
}

class SellerPanelService {
  static const _salesKey  = 'bm_seller_sales_v4';
  static const _debtKey   = 'bm_seller_debts_v4';
  static const _shortKey  = 'bm_seller_shorts_v4';
  static const _settleKey = 'bm_seller_settle_v4';

  static String _id() => DateTime.now().microsecondsSinceEpoch.toString();
  static String _now() => DateTime.now().toIso8601String();

  static Future<List<Map<String,dynamic>>> _list(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    if (raw == null) return [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return [];
      return decoded.whereType<Map>().map((e) => Map<String,dynamic>.from(e)).toList();
    } catch (_) { return []; }
  }

  static Future<void> _save(String key, List<Map<String,dynamic>> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(data));
  }

  // ثبت فروش (نقدی / نسیه / منزل)
  static Future<void> addSale({
    required String sellerName,
    required String breadType,
    required int quantity,
    required int amount,
    required SaleType type,
    String customerName = '',
    String address = '',
    String shiftId = '',
    String note = '',
  }) async {
    final data = await _list(_salesKey);
    data.insert(0, {
      'id': _id(), 'sellerName': sellerName,
      'breadType': breadType, 'quantity': quantity,
      'amount': amount, 'type': type.name,
      'customerName': customerName, 'address': address,
      'shiftId': shiftId, 'note': note,
      'settled': false, 'createdAt': _now(),
    });
    await _save(_salesKey, data);
  }

  // ثبت کسری صندوق
  static Future<void> addShortfall({
    required String sellerName,
    required int amount,
    required String shiftId,
    String note = '',
  }) async {
    final data = await _list(_shortKey);
    data.insert(0, {
      'id': _id(), 'sellerName': sellerName,
      'amount': amount, 'shiftId': shiftId,
      'note': note, 'settled': false, 'createdAt': _now(),
    });
    await _save(_shortKey, data);
  }

  // تسویه فروشنده
  static Future<void> settle({
    required String sellerName,
    required int cashPaid,
    required int creditCollected,
    required int homeCollected,
    String note = '',
  }) async {
    final data = await _list(_settleKey);
    // علامت‌گذاری فروش‌های تسویه‌نشده
    final sales = await _list(_salesKey);
    for (var s in sales) {
      if (s['sellerName'] == sellerName && s['settled'] == false) s['settled'] = true;
    }
    await _save(_salesKey, sales);
    final shorts = await _list(_shortKey);
    for (var s in shorts) {
      if (s['sellerName'] == sellerName && s['settled'] == false) s['settled'] = true;
    }
    await _save(_shortKey, shorts);
    data.insert(0, {
      'id': _id(), 'sellerName': sellerName,
      'cashPaid': cashPaid, 'creditCollected': creditCollected,
      'homeCollected': homeCollected, 'note': note, 'createdAt': _now(),
    });
    await _save(_settleKey, data);
  }

  // خلاصه حساب فروشنده
  static Future<Map<String,dynamic>> summary(String sellerName, {bool onlyUnsettled = true}) async {
    final sales  = await _list(_salesKey);
    final shorts = await _list(_shortKey);
    int cash = 0, credit = 0, home = 0, shortfall = 0;
    for (var s in sales) {
      if (s['sellerName'] != sellerName) continue;
      if (onlyUnsettled && s['settled'] == true) continue;
      final amt = (s['amount'] as num? ?? 0).toInt();
      switch (s['type']) {
        case 'cash':   cash   += amt; break;
        case 'credit': credit += amt; break;
        case 'home':   home   += amt; break;
      }
    }
    for (var s in shorts) {
      if (s['sellerName'] != sellerName) continue;
      if (onlyUnsettled && s['settled'] == true) continue;
      shortfall += (s['amount'] as num? ?? 0).toInt();
    }
    return {
      'cash': cash, 'credit': credit, 'home': home,
      'shortfall': shortfall,
      'total': cash + credit + home - shortfall,
    };
  }

  static Future<List<Map<String,dynamic>>> sellerSales(String name, {bool onlyUnsettled = false}) async {
    final all = await _list(_salesKey);
    return all.where((s) => s['sellerName'] == name && (!onlyUnsettled || s['settled'] == false)).toList();
  }

  static Future<List<Map<String,dynamic>>> settlements() => _list(_settleKey);
}
