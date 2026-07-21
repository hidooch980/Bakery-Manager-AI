import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppVersionService {
  static Future<String> version() async {
    final p = await PackageInfo.fromPlatform();
    return p.version;
  }

  static Future<void> saveCheck() async {
    final s = await SharedPreferences.getInstance();
    await s.setString("last_update_check", DateTime.now().toString());
  }

  static Future<String> lastCheck() async {
    final s = await SharedPreferences.getInstance();
    return s.getString("last_update_check") ?? "---";
  }
}
