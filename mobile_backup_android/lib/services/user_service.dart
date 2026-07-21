import '../models/user.dart';

class UserService {
  static final UserService instance = UserService._internal();

  factory UserService() {
    return instance;
  }

  UserService._internal();

  final List<User> _users = [];

  void add(User user) {
    _users.add(user);
  }

  bool register(User user) {
    if (_users.any((u) => u.phone == user.phone)) {
      return false;
    }
    _users.add(user);
    return true;
  }

  User? login(String phone, String password) {
    for (final user in _users) {
      if (user.phone == phone && user.password == password) {
        return user;
      }
    }
    return null;
  }

  List<User> getAll() {
    return _users;
  }

  String getRole() {
    if (_users.isNotEmpty) {
      return _users.first.role;
    }
    return "MANAGER";
  }
}
