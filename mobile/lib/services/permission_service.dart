import 'auth_service.dart';

class PermissionService {
  static bool canAccess(String page) {
    final role = AuthService.role().toUpperCase();

    if (role == 'MANAGER' || role == 'ADMIN') {
      return true;
    }

    if (role == 'SELLER' && page == 'sales') {
      return true;
    }

    if ((role == 'DOUGH' || role == 'DOUGH_MAKER' || role == 'DIVIDER') && page == 'production') {
      return true;
    }

    return false;
  }
}
