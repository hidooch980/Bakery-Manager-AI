import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  static String _cachedRole = 'EMPLOYEE';

  static String role() => _cachedRole;

  static Future<bool> login(String phone, String password) async {
    try {
      final res = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone, 'password': password}),
      );

      if (res.statusCode != 200 && res.statusCode != 201) {
        ApiService.lastError = 'شماره موبایل یا رمز عبور اشتباه است';
        return false;
      }

      final data = jsonDecode(utf8.decode(res.bodyBytes));
      await StorageService.setAccessToken(data['access_token']);
      await StorageService.setRefreshToken(data['refresh_token']);

      final user = data['user'];
      final role = (user is Map ? user['role'] : null) ?? data['role'] ?? 'EMPLOYEE';
      _cachedRole = role;
      await StorageService.setRole(role);

      ApiService.lastError = '';
      return true;
    } catch (e) {
      ApiService.lastError = 'خطا در اتصال به سرور';
      return false;
    }
  }

  static Future<bool> register(
    String name,
    String phone,
    String password,
    String role,
  ) async {
    try {
      final res = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'phone': phone,
          'password': password,
          'role': role,
        }),
      );
      return res.statusCode == 200 || res.statusCode == 201;
    } catch (_) {
      return false;
    }
  }

  static Future<String?> getAccessToken() => StorageService.getAccessToken();

  static Future<bool> refresh() async {
    final refreshToken = await StorageService.getRefreshToken();
    if (refreshToken == null) return false;

    final res = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/auth/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh_token': refreshToken}),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      await logout();
      return false;
    }

    final data = jsonDecode(utf8.decode(res.bodyBytes));
    await StorageService.setAccessToken(data['access_token']);
    await StorageService.setRefreshToken(data['refresh_token']);
    return true;
  }

  static Future<void> logout() async {
    final refreshToken = await StorageService.getRefreshToken();
    try {
      await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/logout'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': refreshToken}),
      );
    } catch (_) {
      // ignore
    }
    await StorageService.clear();
  }
}
