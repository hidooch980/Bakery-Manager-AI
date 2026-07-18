import 'user_service.dart';

class AuthService {

  static Map<String,dynamic>? currentUser;

  static bool login(String name) {

    for(final user in UserService.getAll()) {

      if(user['name'] == name) {
        currentUser = user;
        return true;
      }

    }

    return false;
  }

  static String role(){

    return currentUser?['role'] ?? '';

  }

}
