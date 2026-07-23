import 'package:package_info_plus/package_info_plus.dart';
import 'api_service.dart';

class UpdateManager {
  final _api = ApiService();

  Future<Map<String, dynamic>?> checkForUpdate() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final data = await _api.getData('/app-version/latest');
      final map = data as Map<String, dynamic>;

      if (map['version'] != info.version) {
        return map;
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
