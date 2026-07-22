import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  static String? _role;

  static Future<bool> login(String phone, String password) async {
    final result = await ApiService.postLogin("auth/login", {
      "phone": phone,
      "password": password,
    });

    if (result != null && result["access_token"] != null) {
      await StorageService.saveToken(result["access_token"]);

      _role = result["user"]?["role"] ?? "MANAGER";
      await StorageService.saveRole(_role!);

      return true;
    }

    return false;
  }

  static Future<bool> register(String name, String phone, String password, String role) async {
    final result = await ApiService.postLogin("auth/register", {
      "name": name,
      "phone": phone,
      "password": password,
      "role": role,
    });

    return result != null && result["id"] != null;
  }

  static String role() {
    return _role ?? "MANAGER";
  }

  static Future<String> loadRole() async {
    _role = await StorageService.getRole() ?? "MANAGER";
    return _role!;
  }
}
