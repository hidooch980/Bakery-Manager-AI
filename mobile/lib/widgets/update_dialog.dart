import 'package:flutter/material.dart';
import '../services/apk_downloader_service.dart';

class UpdateDialog extends StatefulWidget {
  final Map data;
  const UpdateDialog({super.key, required this.data});
  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  double progress = 0;

  @override
  Widget build(BuildContext c) {
    return AlertDialog(
      title: const Text("نسخه جدید موجود است"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.data["name"] ?? "Update"),
          LinearProgressIndicator(value: progress),
          Text("${(progress * 100).toInt()}%"),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            final url = widget.data["assets"][0]["browser_download_url"];
            await ApkDownloaderService.download(url, (p) {
              setState(() => progress = p);
            });
          },
          child: const Text("دانلود و نصب"),
        ),
      ],
    );
  }
}
