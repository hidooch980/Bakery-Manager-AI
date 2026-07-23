class PermissionService {
  static const Map<String, List<String>> rolePermissions = {
    'ADMIN': ['*'],
    'MANAGER': [
      'sales',
      'production',
      'expenses',
      'products',
      'employees',
      'analytics',
    ],
    'SELLER': ['sales'],
    'DOUGH_MAKER': ['production'],
    'ACCOUNTANT': ['expenses', 'inventory', 'cashbox'],
  };

  static bool canAccess(String role, String feature) {
    final perms = rolePermissions[role];
    if (perms == null) return false;
    return perms.contains('*') || perms.contains(feature);
  }
}
