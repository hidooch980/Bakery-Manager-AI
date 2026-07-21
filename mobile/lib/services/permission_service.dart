import 'auth_service.dart';

class PermissionService {
  static bool canAccess(String page) {
    final role = AuthService.role().toUpperCase();
    final normalizedPage = page.toLowerCase();

    if (role == 'MANAGER' || role == 'ADMIN') {
      return true;
    }

    if (role == 'SELLER' && normalizedPage == 'sales') {
      return true;
    }

    if ((role == 'DOUGH' || role == 'DOUGH_MAKER') &&
        normalizedPage == 'production') {
      return true;
    }

    if ((role == 'DIVIDER' || role == 'DOUGH_DIVIDER') &&
        normalizedPage == 'production') {
      return true;
    }

    return false;
  }
}
