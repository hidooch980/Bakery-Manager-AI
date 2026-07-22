import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../services/update_service.dart';
import '../services/github_apk_service.dart';

class UpdateSettingsScreen extends StatefulWidget {
  const UpdateSettingsScreen({super.key});

  @override
  State<UpdateSettingsScreen> createState() =>
      _UpdateSettingsScreenState();
}

class _UpdateSettingsScreenState extends State<UpdateSettingsScreen> {
  String currentVersion = '---';
  String status = 'برای بررسی آپدیت دکمه زیر را بزنید';
  bool loading = false;
  Map<String, dynamic>? release;

  @override
  void initState() {
    super.initState();
    loadVersion();
  }

  Future<void> loadVersion() async {
    final info = await PackageInfo.fromPlatform();

    if (!mounted) return;

    setState(() {
      currentVersion = info.version;
    });
  }

  Future<void> check() async {
    setState(() {
      loading = true;
      status = 'در حال بررسی نسخه جدید...';
    });

    try {
      final info = await PackageInfo.fromPlatform();
      final data = await UpdateService.check();

      if (!mounted) return;

      if (data == null) {
        setState(() {
          loading = false;
          release = null;
          status = 'نسخه شما بروز است';
        });
        return;
      }

      final latest =
          UpdateService.normalizeVersion(data['tag_name'].toString());

      if (UpdateService.isNewer(info.version, latest)) {
        setState(() {
          loading = false;
          release = data;
          status = 'نسخه جدید موجود است: $latest';
        });
      } else {
        setState(() {
          loading = false;
          release = null;
          status = 'نسخه شما بروز است';
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
        status = 'خطا در بررسی آپدیت';
      });
    }
  }

  Future<void> downloadUpdate() async {
    if (release == null) return;

    final url = UpdateService.getApkUrl(release!);

    if (url == null) {
      setState(() {
        status = 'فایل APK در Release پیدا نشد';
      });
      return;
    }

    setState(() {
      status = 'در حال دانلود نسخه جدید...';
    });

    final path = await GithubApkService.download(url);

    if (!mounted) return;

    setState(() {
      status = path == null
          ? 'دانلود آپدیت ناموفق بود'
          : 'دانلود انجام شد؛ نصب را تأیید کنید';
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasUpdate = release != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('به‌روزرسانی سیستم'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(
              Icons.system_update,
              size: 70,
            ),
            const SizedBox(height: 20),
            Text(
              'نسخه فعلی: $currentVersion',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              status,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : check,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text('بررسی آپدیت GitHub'),
              ),
            ),
            if (hasUpdate) ...[
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: downloadUpdate,
                  icon: const Icon(Icons.download),
                  label: const Text('دانلود و نصب نسخه جدید'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
