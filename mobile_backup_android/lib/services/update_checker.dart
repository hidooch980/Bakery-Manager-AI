import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateChecker {
  static const String api =
      'https://api.github.com/repos/hidooch980/Bakery-Manager-AI/releases/latest';

  static Future<void> check(BuildContext context) async {
    try {
      final info = await PackageInfo.fromPlatform();
      final current = info.version;

      final response = await http.get(Uri.parse(api));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final latest = data['tag_name']
            .toString()
            .replaceAll('v', '');

        final apkUrl = data['assets'][0]['browser_download_url'];

        if (latest != current && context.mounted) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('نسخه جدید موجود است'),
              content: Text(
                'نسخه $latest آماده دانلود است.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    launchUrl(
                      Uri.parse(apkUrl),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  child: const Text('دانلود'),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Update check error: $e');
    }
  }
}
