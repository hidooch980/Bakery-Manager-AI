import 'dart:convert';
import 'package:http/http.dart' as http;

class UpdateService {
  static const String api =
      'https://api.github.com/repos/hidooch980/Bakery-Manager-AI/releases/latest';

  static Future<Map<String, dynamic>?> check() async {
    try {
      final response = await http.get(
        Uri.parse(api),
        headers: {
          'Accept': 'application/vnd.github+json',
        },
      );

      if (response.statusCode != 200) {
        return null;
      }

      final data = jsonDecode(response.body);

      if (data['draft'] == true || data['prerelease'] == true) {
        return null;
      }

      return data;
    } catch (_) {
      return null;
    }
  }

  static String normalizeVersion(String version) {
    return version.trim().replaceFirst(RegExp(r'^v'), '');
  }

  static bool isNewer(String current, String latest) {
    final currentParts = normalizeVersion(current)
        .split('.')
        .map((e) => int.tryParse(e) ?? 0)
        .toList();

    final latestParts = normalizeVersion(latest)
        .split('.')
        .map((e) => int.tryParse(e) ?? 0)
        .toList();

    while (currentParts.length < 3) {
      currentParts.add(0);
    }

    while (latestParts.length < 3) {
      latestParts.add(0);
    }

      for (int i = 0; i < 3; i++) {
        if (latestParts[i] > currentParts[i]) {
          return true;
        }
        if (latestParts[i] < currentParts[i]) {
          return false;
        }
      }
      return false;
    }

  static String? getApkUrl(Map<String, dynamic> release) {
    final assets = release['assets'];

    if (assets is! List) {
      return null;
    }

    for (final asset in assets) {
      final name = asset['name']?.toString().toLowerCase() ?? '';

      if (name.endsWith('.apk')) {
        return asset['browser_download_url']?.toString();
      }
    }

    return null;
  }
}
