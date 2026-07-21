import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'storage_service.dart';

class ApiService {
  static String lastError = '';
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://185.97.118.255:3000',
  );

  static Future<Map<String, String>> headers() async {
    final token = await StorageService.getToken();

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  static dynamic _decode(http.Response response) {
    if (response.body.isEmpty) return null;
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  static String _messageFromResponse(http.Response response) {
    try {
      final body = _decode(response);
      if (body is Map && body['message'] != null) {
        final message = body['message'];
        if (message is List) return message.join('\n');
        return message.toString();
      }
    } catch (_) {}
    return 'خطای سرور (${response.statusCode})';
  }

  static Future<dynamic> postLogin(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    return postData(endpoint, data, authorized: false);
  }

  static Future<dynamic> postData(
    String endpoint,
    Map<String, dynamic> data, {
    bool authorized = true,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: authorized
            ? await headers()
            : {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        lastError = '';
        return _decode(response);
      }

      lastError = _messageFromResponse(response);
    } catch (e) {
      lastError = 'خطا در اتصال به سرور';
      debugPrint('API POST error: $e');
    }

    return null;
  }

  static Future<dynamic> patchData(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/$endpoint'),
        headers: await headers(),
        body: jsonEncode(data),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        lastError = '';
        return _decode(response);
      }

      lastError = _messageFromResponse(response);
    } catch (e) {
      lastError = 'خطا در اتصال به سرور';
      debugPrint('API PATCH error: $e');
    }

    return null;
  }

  static Future<dynamic> getData(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: await headers(),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        lastError = '';
        return _decode(response);
      }

      lastError = _messageFromResponse(response);
    } catch (e) {
      lastError = 'خطا در اتصال به سرور';
      debugPrint('API GET error: $e');
    }

    return null;
  }
}
