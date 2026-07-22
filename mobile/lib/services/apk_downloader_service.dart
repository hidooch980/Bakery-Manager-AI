import 'package:open_filex/open_filex.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class ApkDownloaderService {
  static Future<String?> download(String url, Function(double) progress) async {
    try {
      final dir = await getExternalStorageDirectory();
      final path = "${dir!.path}/BakeryManagerAI-update.apk";
      await Dio().download(
        url,
        path,
        onReceiveProgress: (r, t) {
          if (t > 0) progress(r / t);
        },
      );
      await OpenFilex.open(path);
      return path;
    } catch (e) {
      return null;
    }
  }
}
