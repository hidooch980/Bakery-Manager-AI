import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'storage_service.dart';

class ApiService {
  static String lastError = '';

  static String _resolve(String path) {
    if (path.startsWith('http')) return path;
    final p = path.startsWith('/') ? path : '/$path';
    return '${ApiConfig.baseUrl}$p';
  }

  static Future<Map<String, String>> _headers() async {
    final token = await StorageService.getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<dynamic> getData(String path) async {
    try {
      final res = await http.get(
        Uri.parse(_resolve(path)),
        headers: await _headers(),
      );
      return _handle(res);
    } catch (e) {
      lastError = 'خطا در اتصال به سرور';
      return null;
    }
  }

  static Future<dynamic> postData(String path, Map<String, dynamic> body) async {
    try {
      final res = await http.post(
        Uri.parse(_resolve(path)),
        headers: await _headers(),
        body: jsonEncode(body),
      );
      return _handle(res);
    } catch (e) {
      lastError = 'خطا در اتصال به سرور';
      return null;
    }
  }

  static Future<dynamic> patchData(String path, Map<String, dynamic> body) async {
    try {
      final res = await http.patch(
        Uri.parse(_resolve(path)),
        headers: await _headers(),
        body: jsonEncode(body),
      );
      return _handle(res);
    } catch (e) {
      lastError = 'خطا در اتصال به سرور';
      return null;
    }
  }

  static dynamic _handle(http.Response res) {
    if (res.statusCode >= 200 && res.statusCode < 300) {
      lastError = '';
      if (res.body.isEmpty) return null;
      return jsonDecode(utf8.decode(res.bodyBytes));
    }
    lastError = 'خطای سرور (${res.statusCode})';
    return null;
  }
}
