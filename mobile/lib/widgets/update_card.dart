import '../services/github_apk_service.dart';
import 'package:flutter/material.dart';

class UpdateCard extends StatelessWidget {
  final bool available;
  final String version;
  final String? apkUrl;

  const UpdateCard({
    super.key,
    this.available = false,
    this.version = '',
    this.apkUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('به‌روزرسانی')),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          child: ListTile(
            leading: Icon(
              available ? Icons.system_update : Icons.check_circle,
              color: available ? Colors.orange : Colors.green,
            ),
            title: Text(available ? 'نسخه جدید موجود است' : 'برنامه بروز است'),
            subtitle: Text(
              available ? 'نسخه $version آماده دانلود' : 'آخرین نسخه نصب شده',
            ),
            trailing: available && apkUrl != null
                ? ElevatedButton(
                    onPressed: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      final path = await GithubApkService.download(apkUrl!);
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(
                            path == null
                                ? 'دانلود ناموفق بود'
                                : 'دانلود شد؛ نصب را تأیید کنید',
                          ),
                        ),
                      );
                    },
                    child: const Text('دانلود'),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
