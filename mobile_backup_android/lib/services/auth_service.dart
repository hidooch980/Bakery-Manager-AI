import 'user_service.dart';
import '../models/user.dart';

class AuthService {

  static User? currentUser;

  static bool login(String phone, String password) {

    final user = UserService().login(phone, password);

    if (user != null) {
      currentUser = user;
      return true;
    }

    return false;
  }

  static String role() {
    return currentUser?.role ?? '';
  }

  static User? user() {
    return currentUser;
  }
}
