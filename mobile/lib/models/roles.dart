class Roles {
  static const admin = 'ADMIN';
  static const manager = 'MANAGER';
  static const seller = 'SELLER';
  static const kneader = 'KNEADER';
  static const divider = 'DIVIDER';

  static const all = [
    admin,
    manager,
    seller,
    kneader,
    divider,
  ];

  static bool isManagement(String role) {
    return role == admin || role == manager;
  }
}
