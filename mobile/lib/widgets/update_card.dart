import '../services/github_apk_service.dart';
import 'package:flutter/material.dart';

class UpdateCard extends StatelessWidget {
  final bool available;
  final String version;
  final String apkUrl;
  const UpdateCard({
    super.key,
    this.available = false,
    this.version = "",
    this.apkUrl = "",
  });

  @override
  Widget build(BuildContext c) {
    return Card(
      child: ListTile(
        leading: Icon(
          available ? Icons.system_update : Icons.check_circle,
          color: available ? Colors.orange : Colors.green,
        ),
        title: Text(available ? "نسخه جدید موجود است" : "برنامه بروز است"),
        subtitle: Text(
          available ? "نسخه $version آماده دانلود" : "آخرین نسخه نصب شده",
        ),
        trailing: available
            ? ElevatedButton(
                onPressed: apkUrl.isEmpty
                    ? null
                    : () async {
                        final path = await GithubApkService.download(apkUrl);
                        if (path != null) {}
                      },
                child: const Text("دانلود"),
              )
            : null,
      ),
    );
  }
}
