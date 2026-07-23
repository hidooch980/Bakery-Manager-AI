import 'api_service.dart';

class UserManagementService {
  static Future<List<dynamic>> getUsers() async {
    final res = await ApiService.getData('/users');
    if (res is List) return res;
    return [];
  }

  static Future<bool> createUser({
    required String name,
    required String phone,
    required String password,
    required String role,
  }) async {
    final res = await ApiService.postData('/users', {
      'name': name,
      'phone': phone,
      'password': password,
      'role': role,
    });
    return res != null;
  }

  static Future<bool> updateUser(
    String id, {
    String? name,
    String? role,
    String? password,
  }) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (role != null) body['role'] = role;
    if (password != null && password.isNotEmpty) body['password'] = password;

    final res = await ApiService.patchData('/users/$id', body);
    return res != null;
  }
}
