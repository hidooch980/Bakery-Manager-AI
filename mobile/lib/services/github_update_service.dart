import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

class GithubUpdateService {
  static const repo = 'hidooch980/Bakery-Manager-AI';

  static Future<Map<String, dynamic>?> check() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final current = _parseVersion(info.version);

      final res = await http.get(
        Uri.parse('https://api.github.com/repos/$repo/releases/latest'),
      );

      if (res.statusCode != 200) return null;

      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final tag = data['tag_name']?.toString() ?? '';
      final latestVersion = tag.replaceFirst(RegExp(r'^v'), '');
      final latest = _parseVersion(latestVersion);

      if (_isNewer(latest, current)) {
        return data;
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  static List<int> _parseVersion(String version) {
    final clean = version.split('+').first;
    return clean
        .split('.')
        .map((part) => int.tryParse(part) ?? 0)
        .toList();
  }

  static bool _isNewer(List<int> latest, List<int> current) {
    final length = latest.length > current.length
        ? latest.length
        : current.length;

    for (var i = 0; i < length; i++) {
      final latestPart = i < latest.length ? latest[i] : 0;
      final currentPart = i < current.length ? current[i] : 0;

      if (latestPart > currentPart) return true;
      if (latestPart < currentPart) return false;
    }

    return false;
  }
}
