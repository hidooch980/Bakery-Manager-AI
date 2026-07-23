import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'api_service.dart';

class UpdateManager {
  static Future<void> check(BuildContext context) async {
    try {
      final info = await PackageInfo.fromPlatform();
      final data = await ApiService.getData('/app-version/latest');

      if (data is Map &&
          data['version'] != null &&
          data['version'] != info.version) {
        if (!context.mounted) return;

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('نسخه جدید موجود است'),
            content: Text('نسخه ${data['version']} در دسترس است.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('باشه'),
              ),
            ],
          ),
        );
      }
    } catch (_) {
      // نادیده گرفتن خطا در بررسی بروزرسانی
    }
  }
}
