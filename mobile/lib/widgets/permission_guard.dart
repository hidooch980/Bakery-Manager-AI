import 'package:flutter/material.dart';
import '../services/permission_service.dart';

class PermissionGuard extends StatelessWidget {

  final String page;
  final Widget child;

  const PermissionGuard({
    super.key,
    required this.page,
    required this.child,
  });


  @override
  Widget build(BuildContext context) {

    if(PermissionService.canAccess(page)) {

      return child;

    }

    return const Scaffold(
      body: Center(
        child: Text(
          'دسترسی مجاز نیست',
          style: TextStyle(fontSize:20),
        ),
      ),
    );

  }
}
