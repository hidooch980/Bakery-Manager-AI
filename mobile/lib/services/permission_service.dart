import 'auth_service.dart';

class PermissionService {

  static bool canAccess(String page) {

    final role = AuthService.role();

    if(role == 'manager') {
      return true;
    }

    if(role == 'seller' && page == 'sales') {
      return true;
    }

    if((role == 'dough_worker' || role == 'divider')
        && page == 'production') {
      return true;
    }

    return false;
  }

}
