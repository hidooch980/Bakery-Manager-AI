import 'auth_service.dart';

class PermissionService {
  static const Map<String, List<String>> rolePermissions = {
    'ADMIN': ['*'],
    'MANAGER': ['*'],
    'SELLER': ['sales', 'seller'],
    'DOUGH_MAKER': ['production'],
    'ACCOUNTANT': ['expenses', 'inventory', 'cashbox'],
  };

  static bool canAccess(String page) {
    final role = AuthService.role();
    final perms = rolePermissions[role];
    if (perms == null) return false;
    return perms.contains('*') || perms.contains(page);
  }
}
