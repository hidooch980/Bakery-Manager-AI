
class AppRole {
  static const manager   = '\u0645\u062f\u06cc\u0631';
  static const seller    = '\u0641\u0631\u0648\u0634\u0646\u062f\u0647';
  static const doughCut  = '\u0686\u0627\u0646\u0647\u200c\u06af\u06cc\u0631';
  static const doughMix  = '\u062e\u0645\u06cc\u0631\u06af\u06cc\u0631';

  static const allRoles = [manager, seller, doughCut, doughMix];

  static bool isManager(String r)  => r == manager;
  static bool isSeller(String r)   => r == seller;
  static bool isDoughWorker(String r) => r == doughCut || r == doughMix;

  // آیا این نقش به داشبورد دسترسی دارد؟
  static bool hasDashboard(String r) => r == manager || r == seller;

  // تب‌های قابل دسترس هر نقش (ایندکس)
  // 0=داشبورد 1=فروش 2=تولید 3=آرد 4=هزینه 5=گزارش 6=AI 7=ویژه 8=تنظیمات
  static List<int> allowedTabs(String r) {
    switch (r) {
      case manager:  return [0, 1, 2, 3, 4, 5, 6, 7, 8];
      case seller:   return [0, 1];          // داشبورد(کارتابل) + فروش
      case doughCut: return [2, 3];          // تولید + آرد
      case doughMix: return [2, 3];          // تولید + آرد
      default:       return [1];
    }
  }

  static String roleLabel(String r) {
    switch (r) {
      case manager:  return '\u0645\u062f\u06cc\u0631 \u06a9\u0644';
      case seller:   return '\u0641\u0631\u0648\u0634\u0646\u062f\u0647';
      case doughCut: return '\u0686\u0627\u0646\u0647\u200c\u06af\u06cc\u0631';
      case doughMix: return '\u062e\u0645\u06cc\u0631\u06af\u06cc\u0631';
      default:       return r;
    }
  }

  static String roleIcon(String r) {
    switch (r) {
      case manager:  return '\u{1F451}';
      case seller:   return '\u{1F6D2}';
      case doughCut: return '\u2702\uFE0F';
      case doughMix: return '\u{1F33E}';
      default:       return '\u{1F464}';
    }
  }
}
