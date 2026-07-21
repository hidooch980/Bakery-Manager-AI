class UpdateService {
  static const currentVersion = '1.0.0';

  static Future<bool> checkUpdate() async {
    // بعداً از سرور نسخه جدید گرفته می‌شود
    const latestVersion = '1.0.0';

    return latestVersion != currentVersion;
  }
}
