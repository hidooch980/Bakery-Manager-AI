/// تنظیمات مرکزی آدرس API
///
/// مقدار پیش‌فرض را می‌توان هنگام build تغییر داد:
/// flutter build apk --dart-define=API_BASE_URL=http://YOUR_SERVER:3000
class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://185.97.118.255:3000',
  );
}
