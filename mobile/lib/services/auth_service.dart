import 'api_service.dart';
import 'storage_service.dart';
import 'local_database_service.dart';

class AuthService {
  static String? _role;
  static String? _name;

  static Future<bool> login(String phone, String password) async {
    final result = await ApiService.postLogin('auth/login', {
      'phone': phone,
      'password': password,
    });

    if (result != null && result['access_token'] != null) {
      await StorageService.saveToken(result['access_token']);
      _role = result['user']?['role'] ?? 'MANAGER';
      _name = result['user']?['name'] ?? phone;
      return true;
    }

    final local = await LocalDatabaseService.loginLocal(phone, password);
    if (local != null) {
      await StorageService.saveToken('LOCAL_OFFLINE_TOKEN');
      _role = local['role']?.toString() ?? 'MANAGER';
      _name = local['name']?.toString() ?? phone;
      return true;
    }

    return false;
  }

  static Future<bool> register(String name, String phone, String password, String role) async {
    final result = await ApiService.postLogin('auth/register', {
      'name': name,
      'phone': phone,
      'password': password,
      'role': role,
    });

    if (result != null && result['id'] != null) return true;

    await LocalDatabaseService.addUser(
      name: name,
      phone: phone,
      password: password,
      role: role,
    );
    return true;
  }

  static String role() => _role ?? 'MANAGER';
  static String name() => _name ?? 'کاربر';
}
