import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'storage_service.dart';

class AuthService {
  final String baseUrl = ApiConfig.baseUrl;
  final _storage = StorageService();

  Future<Map<String, dynamic>> login(String phone, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone, 'password': password}),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('ورود ناموفق بود');
    }

    final data = jsonDecode(utf8.decode(res.bodyBytes));
    await _storage.setAccessToken(data['access_token']);
    await _storage.setRefreshToken(data['refresh_token']);
    return data;
  }

  Future<String?> getAccessToken() => _storage.getAccessToken();

  Future<bool> refresh() async {
    final refreshToken = await _storage.getRefreshToken();
    if (refreshToken == null) return false;

    final res = await http.post(
      Uri.parse('$baseUrl/auth/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh_token': refreshToken}),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      await logout();
      return false;
    }

    final data = jsonDecode(utf8.decode(res.bodyBytes));
    await _storage.setAccessToken(data['access_token']);
    await _storage.setRefreshToken(data['refresh_token']);
    return true;
  }

  Future<void> logout() async {
    final refreshToken = await _storage.getRefreshToken();
    try {
      await http.post(
        Uri.parse('$baseUrl/auth/logout'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': refreshToken}),
      );
    } catch (_) {
      // ignore
    }
    await _storage.clear();
  }
}
