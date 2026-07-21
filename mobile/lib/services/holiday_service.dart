
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HolidayService {
  static const _key = 'bm_holidays_v4';

  /// ذخیره تعطیلات ماه: لیستی از روزهای تعطیل
  /// key مثلاً: "2024-08" → ["2024-08-02","2024-08-09",...]
  static Future<void> saveMonthHolidays(int year, int month, List<String> dates) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    final Map<String,dynamic> all = raw != null ? Map<String,dynamic>.from(jsonDecode(raw)) : {};
    all['$year-${month.toString().padLeft(2,'0')}'] = dates;
    await prefs.setString(_key, jsonEncode(all));
  }

  static Future<List<String>> getMonthHolidays(int year, int month) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    final all = Map<String,dynamic>.from(jsonDecode(raw));
    final key = '$year-${month.toString().padLeft(2,'0')}';
    final list = all[key];
    if (list == null) return [];
    return List<String>.from(list);
  }

  /// روزهای کاری یک بازه
  static Future<int> workingDays(DateTime start, DateTime end) async {
    final holidays = await getMonthHolidays(start.year, start.month);
    // اگه بازه از دو ماه است هر دو ماه را بخوان
    Set<String> allHolidays = {...holidays};
    if (end.month != start.month) {
      final h2 = await getMonthHolidays(end.year, end.month);
      allHolidays.addAll(h2);
    }
    int count = 0;
    for (var d = start; !d.isAfter(end); d = d.add(const Duration(days: 1))) {
      final key = '${d.year}-${d.month.toString().padLeft(2,'0')}-${d.day.toString().padLeft(2,'0')}';
      if (!allHolidays.contains(key)) count++;
    }
    return count;
  }

  static bool isHoliday(String date, List<String> holidays) => holidays.contains(date);

  static String formatDate(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2,'0')}-${d.day.toString().padLeft(2,'0')}';
}
