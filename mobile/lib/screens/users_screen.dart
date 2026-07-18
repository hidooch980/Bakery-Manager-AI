import 'package:flutter/material.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مدیریت کاربران'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: const Text('مدیر'),
              subtitle: const Text('دسترسی کامل'),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.point_of_sale),
              title: const Text('فروشنده'),
              subtitle: const Text('ثبت فروش'),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.blender),
              title: const Text('خمیرگیر'),
              subtitle: const Text('ثبت تولید خمیر'),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.work),
              title: const Text('چانه‌گیر'),
              subtitle: const Text('ثبت چانه تولیدی'),
            ),
          ),
        ],
      ),
    );
  }
}
