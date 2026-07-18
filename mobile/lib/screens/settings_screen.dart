import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تنظیمات')),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.store),
            title: Text('اطلاعات نانوایی'),
            subtitle: Text('نام و مشخصات نانوایی'),
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('مدیریت کاربران'),
            subtitle: Text('مدیر، فروشنده، خمیرگیر'),
          ),
          ListTile(
            leading: Icon(Icons.sync),
            title: Text('همگام سازی'),
            subtitle: Text('ارسال اطلاعات به سرور'),
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
