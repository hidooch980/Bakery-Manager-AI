import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class GithubApkService {
  static Future<String?> download(String url) async {
    try {
      final dir = await getExternalStorageDirectory();
      if (dir == null) return null;

      final file = File('${dir.path}/BakeryManagerAI-update.apk');

      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        return null;
      }

      await file.writeAsBytes(response.bodyBytes);

      await OpenFilex.open(
        file.path,
        type: 'application/vnd.android.package-archive',
      );

      return file.path;
    } catch (_) {
      return null;
    }
  }
}
