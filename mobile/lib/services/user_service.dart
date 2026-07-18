class UserService {

  static final List<Map<String, dynamic>> users = [
    {
      'name': 'مدیر',
      'role': 'manager',
    }
  ];

  static void add({
    required String name,
    required String role,
  }) {
    users.add({
      'name': name,
      'role': role,
    });
  }

  static List<Map<String, dynamic>> getAll() {
    return users;
  }

}
