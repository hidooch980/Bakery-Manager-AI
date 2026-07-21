
import 'holiday_service.dart';

class SalesPeriod {
  final int number;    // 1, 2, 3
  final DateTime start;
  final DateTime end;
  final String label;

  const SalesPeriod({required this.number, required this.start, required this.end, required this.label});
}

class PeriodService {
  /// دوره ۱: ۵ تا ۱۴ | دوره ۲: ۱۵ تا ۲۴ | دوره ۳: ۲۵ تا ۴ ماه بعد
  static List<SalesPeriod> periodsForMonth(int year, int month) {
    final p1Start = DateTime(year, month, 5);
    final p1End   = DateTime(year, month, 14);
    final p2Start = DateTime(year, month, 15);
    final p2End   = DateTime(year, month, 24);
    final p3Start = DateTime(year, month, 25);
    final nextMonth = month == 12 ? 1 : month + 1;
    final nextYear  = month == 12 ? year + 1 : year;
    final p3End   = DateTime(nextYear, nextMonth, 4);

    return [
      SalesPeriod(number: 1, start: p1Start, end: p1End,
        label: '\u062f\u0648\u0631\u0647 \u06f1 (\u06f5 \u062a\u0627 \u06f1\u06f4)'),
      SalesPeriod(number: 2, start: p2Start, end: p2End,
        label: '\u062f\u0648\u0631\u0647 \u06f2 (\u06f1\u06f5 \u062a\u0627 \u06f2\u06f4)'),
      SalesPeriod(number: 3, start: p3Start, end: p3End,
        label: '\u062f\u0648\u0631\u0647 \u06f3 (\u06f2\u06f5 \u062a\u0627 \u06f4)'),
    ];
  }

  static SalesPeriod currentPeriod() {
    final now = DateTime.now();
    final periods = periodsForMonth(now.year, now.month);
    // دوره ۳ ماه قبل هم ممکنه جاری باشه
    final prevMonth = now.month == 1 ? 12 : now.month - 1;
    final prevYear  = now.month == 1 ? now.year - 1 : now.year;
    final prevPeriods = periodsForMonth(prevYear, prevMonth);
    final p3prev = prevPeriods[2];
    if (!now.isBefore(p3prev.start) && !now.isAfter(p3prev.end)) return p3prev;
    for (final p in periods) {
      if (!now.isBefore(p.start) && !now.isAfter(p.end)) return p;
    }
    return periods[0];
  }

  static int periodNumber(DateTime date) {
    final day = date.day;
    if (day >= 5 && day <= 14) return 1;
    if (day >= 15 && day <= 24) return 2;
    return 3; // 25 به بعد یا 1-4
  }

  static Future<double> dailyFlourAllocation(int periodNum, double totalFlour, int year, int month) async {
    final periods = periodsForMonth(year, month);
    if (periodNum < 1 || periodNum > 3) return 0;
    final p = periods[periodNum - 1];
    final working = await HolidayService.workingDays(p.start, p.end);
    if (working == 0) return totalFlour;
    return totalFlour / working;
  }
}
