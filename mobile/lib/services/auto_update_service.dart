
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AutoUpdateService {
  static const _repoOwner = 'hidooch980';
  static const _repoName  = 'Bakery-Manager-AI';
  static const _apiUrl    = 'https://api.github.com/repos/$_repoOwner/$_repoName/releases/latest';
  static const _skipKey   = 'bm_skip_version';

  static Future<Map<String,dynamic>?> checkUpdate() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final current = _parseVersion(info.version);
      final res = await http.get(Uri.parse(_apiUrl),
        headers: {'Accept': 'application/vnd.github.v3+json'}).timeout(const Duration(seconds: 10));
      if (res.statusCode != 200) return null;
      final data = jsonDecode(res.body);
      final tag = (data['tag_name'] as String? ?? '').replaceAll('v', '');
      final latest = _parseVersion(tag);
      if (_isNewer(latest, current)) {
        final assets = data['assets'] as List? ?? [];
        String? apkUrl;
        for (final a in assets) {
          if ((a['name'] as String).endsWith('.apk')) { apkUrl = a['browser_download_url']; break; }
        }
        return {
          'version': tag,
          'notes': data['body'] ?? '',
          'apkUrl': apkUrl,
          'currentVersion': info.version,
        };
      }
    } catch (_) {}
    return null;
  }

  static Future<bool> shouldShow(String version) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_skipKey) != version;
  }

  static Future<void> skipVersion(String version) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_skipKey, version);
  }

  static Future<void> downloadAndInstall(
    String url,
    ValueNotifier<double> progress,
    BuildContext context,
  ) async {
    try {
      final dir = await getExternalStorageDirectory() ?? await getTemporaryDirectory();
      final file = File('${dir.path}/bakery_update.apk');
      final req = http.Client();
      final request = http.Request('GET', Uri.parse(url));
      final response = await req.send(request);
      final total = response.contentLength ?? 0;
      int received = 0;
      final sink = file.openWrite();
      await for (final chunk in response.stream) {
        sink.add(chunk);
        received += chunk.length;
        if (total > 0) progress.value = received / total;
      }
      await sink.close();
      progress.value = 1.0;
      await OpenFilex.open(file.path);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('\u062e\u0637\u0627 \u062f\u0631 \u062f\u0627\u0646\u0644\u0648\u062f: $e'), backgroundColor: Colors.red));
      }
    }
  }

  static List<int> _parseVersion(String v) {
    try { return v.split('.').map(int.parse).toList(); } catch (_) { return [0,0,0]; }
  }

  static bool _isNewer(List<int> latest, List<int> current) {
    for (int i = 0; i < 3; i++) {
      final l = i < latest.length ? latest[i] : 0;
      final c = i < current.length ? current[i] : 0;
      if (l > c) return true;
      if (l < c) return false;
    }
    return false;
  }
}

/// \u0646\u0645\u0627\u06cc\u0634 \u062f\u06cc\u0627\u0644\u0648\u06af \u0627\u067e\u062f\u06cc\u062a
Future<void> showUpdateDialog(BuildContext context, Map<String,dynamic> info) async {
  final skip = await AutoUpdateService.shouldShow(info['version']);
  if (!skip || !context.mounted) return;
  final progress = ValueNotifier<double>(0);
  bool downloading = false;
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => Directionality(
      textDirection: TextDirection.rtl,
      child: StatefulBuilder(
        builder: (ctx, setSt) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(children: [
            Icon(Icons.system_update, color: Theme.of(ctx).colorScheme.primary),
            const SizedBox(width: 8),
            const Text('\u0646\u0633\u062e\u0647 \u062c\u062f\u06cc\u062f \u0645\u0648\u062c\u0648\u062f \u0627\u0633\u062a!'),
          ]),
          content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            RichText(text: TextSpan(
              style: DefaultTextStyle.of(ctx).style,
              children: [
                TextSpan(text: '\u0646\u0633\u062e\u0647 \u0641\u0639\u0644\u06cc: ', style: const TextStyle(color: Colors.grey)),
                TextSpan(text: info['currentVersion'], style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            )),
            const SizedBox(height: 4),
            RichText(text: TextSpan(
              style: DefaultTextStyle.of(ctx).style,
              children: [
                TextSpan(text: '\u0646\u0633\u062e\u0647 \u062c\u062f\u06cc\u062f: ', style: const TextStyle(color: Colors.grey)),
                TextSpan(text: info['version'], style: TextStyle(color: Theme.of(ctx).colorScheme.primary, fontWeight: FontWeight.bold)),
              ],
            )),
            if ((info['notes'] as String).isNotEmpty) ...[
              const SizedBox(height: 10),
              const Text('\u062a\u063a\u06cc\u06cc\u0631\u0627\u062a:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(height: 4),
              Text(info['notes'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
            if (downloading) ...[
              const SizedBox(height: 16),
              ValueListenableBuilder<double>(
                valueListenable: progress,
                builder: (_, v, __) => Column(children: [
                  LinearProgressIndicator(value: v < 1.0 ? v : null, minHeight: 8,
                    borderRadius: BorderRadius.circular(4)),
                  const SizedBox(height: 6),
                  Text(v < 1.0 ? '${(v*100).toInt()}\u066a \u062f\u0627\u0646\u0644\u0648\u062f...'
                    : '\u062f\u0631 \u062d\u0627\u0644 \u0646\u0635\u0628...', style: const TextStyle(fontSize: 12)),
                ]),
              ),
            ],
          ]),
          actions: downloading ? [] : [
            TextButton(
              onPressed: () async {
                await AutoUpdateService.skipVersion(info['version']);
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: const Text('\u0628\u0639\u062f\u0627\u064b'),
            ),
            ElevatedButton.icon(
              onPressed: info['apkUrl'] == null ? null : () async {
                setSt(() => downloading = true);
                await AutoUpdateService.downloadAndInstall(
                  info['apkUrl']!, progress, ctx);
              },
              icon: const Icon(Icons.download),
              label: const Text('\u0628\u0647\u200c\u0631\u0648\u0632\u0631\u0633\u0627\u0646\u06cc'),
            ),
          ],
        ),
      ),
    ),
  );
}
