import 'package:flutter/material.dart';
import '../widgets/permission_guard.dart';
import '../services/storage_service.dart';
import 'bakery_info_screen.dart';
import 'users_screen.dart';
import 'update_settings_screen.dart';
import 'login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> logout(BuildContext context) async {
    await StorageService.clear();

    if (!context.mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PermissionGuard(
      page: 'manager',
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تنظیمات و مدیریت'),
        ),
        body: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.store),
              title: const Text('اطلاعات نانوایی'),
              subtitle: const Text('نام و مشخصات مجموعه'),
              trailing: const Icon(Icons.chevron_left),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const BakeryInfoScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('مدیریت کارکنان'),
              subtitle: const Text('مدیر و کارکنان نانوایی'),
              trailing: const Icon(Icons.chevron_left),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const UsersScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.system_update),
              title: const Text('بروزرسانی برنامه'),
              subtitle: const Text('بررسی و دریافت نسخه جدید'),
              trailing: const Icon(Icons.chevron_left),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const UpdateSettingsScreen(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text(
                'خروج از حساب',
                style: TextStyle(color: Colors.red),
              ),
              subtitle: const Text('خروج از حساب کاربری فعلی'),
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('خروج از حساب'),
                    content: const Text(
                      'آیا مطمئن هستید که می‌خواهید خارج شوید؟',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('انصراف'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('خروج'),
                      ),
                    ],
                  ),
                );

                if (confirm == true && context.mounted) {
                  await logout(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
