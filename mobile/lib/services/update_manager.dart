import 'package:flutter/material.dart';
import 'github_update_service.dart';
import 'update_service.dart';
import '../widgets/update_card.dart';

class UpdateManager {
  static Future<void> check(BuildContext context) async {
    final update = await GithubUpdateService.check();

    if (update != null && context.mounted) {
      final apkUrl = UpdateService.getApkUrl(update);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('نسخه جدید موجود است'),
          content: Text('نسخه ${update['tag_name']} آماده دانلود است'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('بعداً'),
            ),
            ElevatedButton(
              onPressed: apkUrl == null
                  ? null
                  : () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => UpdateCard(
                            available: true,
                            version: update['tag_name']?.toString() ?? '',
                            apkUrl: apkUrl,
                          ),
                        ),
                      );
                    },
              child: const Text('آپدیت'),
            ),
          ],
        ),
      );
    }
  }
}
