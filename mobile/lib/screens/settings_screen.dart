import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تنظیمات'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.store),
            title: const Text('اطلاعات نانوایی'),
            subtitle: const Text('نام، شعبه و مشخصات'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('مدیریت کاربران'),
            subtitle: const Text('مدیر، فروشنده، خمیرگیر'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.cloud_sync),
            title: const Text('همگام‌سازی اطلاعات'),
            subtitle: const Text('ارسال اطلاعات به سرور'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('درباره برنامه'),
            subtitle: const Text('Bakery Manager AI'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
