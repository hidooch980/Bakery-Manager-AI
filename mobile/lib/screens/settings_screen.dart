import 'package:flutter/material.dart';
import 'users_screen.dart';
import 'bakery_info_screen.dart';
import 'users_screen.dart';
import 'production_settings_screen.dart';

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
            leading: Icon(Icons.store),
            title: Text('اطلاعات نانوایی'),
            subtitle: Text('نام و مشخصات مجموعه'),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('مدیریت کاربران'),
            subtitle: Text('مدیر و کارکنان'),
          ),
          ListTile(
            leading: Icon(Icons.backup),
            title: Text('پشتیبان‌گیری'),
            subtitle: Text('ذخیره اطلاعات'),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('درباره برنامه'),
            subtitle: Text('Bakery Manager AI'),
          ),
        ],
      ),
    );
  }
}
