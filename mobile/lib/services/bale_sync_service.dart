import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// ارسال آنلاین رایگان رویدادها به گروه مدیر در پیام‌رسان بله.
/// بدون نیاز به سرور اختصاصی: فقط یک ربات رایگان بله و اینترنت گوشی.
class BaleSyncService {
  static const _cfgKey = 'bm2_bale_cfg';
  static const _pendingKey = 'bm2_bale_pending';

  static Future<Map<String, dynamic>> config() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString(_cfgKey);
    if (raw == null || raw.isEmpty) return {};
    final v = jsonDecode(raw);
    return v is Map ? Map<String, dynamic>.from(v) : {};
  }

  static Future<void> saveConfig({
    required String token,
    required String chatId,
    bool enabled = true,
  }) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(
        _cfgKey, jsonEncode({'token': token, 'chatId': chatId, 'enabled': enabled}));
  }

  static String _format(String type, Map<String, dynamic> x) {
    switch (type) {
      case 'sale':
        return '🍞 فروش جدید\nفروشنده: ${x['seller']}\nنوع: ${x['breadType']} | تعداد: ${x['quantity']}\nنقد: ${x['cash']} | کارت: ${x['card']} | نسیه: ${x['debt']}\nجمع: ${x['total']} تومان\nزمان: ${x['createdAt']}';
      case 'production':
        return '🥖 تولید جدید\nمسئول: ${x['worker']} | شیفت: ${x['shift']}\nکیسه آرد: ${x['flourBags']} | خمیر: ${x['dough']} | چانه: ${x['pieces']}\nنان: ${x['bread']} | ضایعات: ${x['waste']}\nزمان: ${x['createdAt']}';
      case 'flour':
        return '🌾 گردش آرد\nنوع: ${x['type']}\nورودی: ${x['bagsIn']} | خروجی: ${x['bagsOut']}\nموجودی بعد: ${x['stockAfter']} کیسه\nزمان: ${x['createdAt']}';
      case 'expense':
        return '💸 هزینه جدید\nعنوان: ${x['title']}\nمبلغ: ${x['amount']} تومان | دسته: ${x['category']}\nزمان: ${x['createdAt']}';
    }
    return 'رویداد $type: ${jsonEncode(x)}';
  }

  static Future<bool> _post(String token, String chatId, String text) async {
    try {
      final res = await http
          .post(Uri.parse('https://tapi.bale.ai/bot$token/sendMessage'),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({'chat_id': chatId, 'text': text}))
          .timeout(const Duration(seconds: 10));
      return res.statusCode >= 200 && res.statusCode < 300;
    } catch (_) {
      return false;
    }
  }

  static Future<void> _addPending(String type, Map<String, dynamic> payload) async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString(_pendingKey);
    final list = (raw == null || raw.isEmpty) ? <dynamic>[] : (jsonDecode(raw) as List);
    list.add({'type': type, 'payload': payload});
    await p.setString(_pendingKey, jsonEncode(list));
  }

  /// تلاش برای ارسال یک رویداد؛ در صورت قطعی اینترنت در صف محلی می‌ماند.
  static Future<void> trySend(String type, Map<String, dynamic> payload) async {
    final c = await config();
    final token = '${c['token'] ?? ''}';
    final chat = '${c['chatId'] ?? ''}';
    if (c['enabled'] != true || token.isEmpty || chat.isEmpty) return;
    final ok = await _post(token, chat, _format(type, payload));
    if (!ok) await _addPending(type, payload);
  }

  /// ارسال دوباره پیام‌های مانده در صف؛ تعداد باقی‌مانده را برمی‌گرداند.
  static Future<int> flushPending() async {
    final c = await config();
    final token = '${c['token'] ?? ''}';
    final chat = '${c['chatId'] ?? ''}';
    final p = await SharedPreferences.getInstance();
    final raw = p.getString(_pendingKey);
    final list = (raw == null || raw.isEmpty) ? <dynamic>[] : (jsonDecode(raw) as List);
    final remaining = <dynamic>[];
    for (final e in list) {
      final m = Map<String, dynamic>.from(e as Map);
      final ok = token.isNotEmpty &&
          chat.isNotEmpty &&
          await _post(token, chat,
              _format('${m['type']}', Map<String, dynamic>.from(m['payload'] as Map)));
      if (!ok) remaining.add(m);
    }
    await p.setString(_pendingKey, jsonEncode(remaining));
    return remaining.length;
  }

  static Future<bool> testMessage() async {
    final c = await config();
    final token = '${c['token'] ?? ''}';
    final chat = '${c['chatId'] ?? ''}';
    if (token.isEmpty || chat.isEmpty) return false;
    return _post(token, chat, 'اتصال ربات بله برقرار است ✅');
  }
}
