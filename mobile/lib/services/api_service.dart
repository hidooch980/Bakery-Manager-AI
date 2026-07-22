import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'storage_service.dart';

class ApiService {
  static String lastError = '';
  static const String baseUrl = 'http://185.97.118.255:3000';

  static Future<Map<String, String>> headers() async {
    final token = await StorageService.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  static Future<dynamic> postLogin(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;
      if (response.statusCode >= 200 && response.statusCode < 300) {
        lastError = '';
        return body;
      }
      lastError = body is Map && body['message'] != null ? body['message'].toString() : 'HTTP ${response.statusCode}';
      debugPrint('API error ${response.statusCode}: ${response.body}');
      return null;
    } catch (e) {
      lastError = 'Connection Error: $e';
      debugPrint('API error: $e');
      return null;
    }
  }

  static Future<dynamic> postData(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: await headers(),
        body: jsonEncode(data),
      );
      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;
      if (response.statusCode >= 200 && response.statusCode < 300) {
        lastError = '';
        return body;
      }
      lastError = body is Map && body['message'] != null ? body['message'].toString() : 'HTTP ${response.statusCode}';
      debugPrint('API error ${response.statusCode}: ${response.body}');
      return null;
    } catch (e) {
      lastError = 'Connection Error: $e';
      debugPrint('API error: $e');
      return null;
    }
  }

  static Future<dynamic> getData(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: await headers(),
      );
      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;
      if (response.statusCode >= 200 && response.statusCode < 300) {
        lastError = '';
        return body;
      }
      lastError = body is Map && body['message'] != null ? body['message'].toString() : 'HTTP ${response.statusCode}';
      debugPrint('API error ${response.statusCode}: ${response.body}');
      return null;
    } catch (e) {
      lastError = 'Connection Error: $e';
      debugPrint('API error: $e');
      return null;
    }
  }
}
