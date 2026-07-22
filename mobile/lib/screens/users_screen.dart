import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/user.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  String role = 'SELLER';

  final service = UserService();

  void saveUser() {
    service.add(
      User(
        name: nameController.text,
        phone: phoneController.text,
        password: passwordController.text,
        role: role,
      ),
    );

    setState(() {});

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('کاربر ایجاد شد')));
  }

  @override
  Widget build(BuildContext context) {
    final users = service.getAll();

    return Scaffold(
      appBar: AppBar(title: const Text('مدیریت کاربران')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'نام کاربر'),
          ),

          TextField(
            controller: phoneController,
            decoration: const InputDecoration(labelText: 'شماره تلفن'),
          ),

          TextField(
            controller: passwordController,
            decoration: const InputDecoration(labelText: 'رمز عبور'),
          ),

          DropdownButton<String>(
            value: role,
            items: const [
              DropdownMenuItem(value: 'MANAGER', child: Text('مدیر')),
              DropdownMenuItem(value: 'SELLER', child: Text('فروشنده')),
              DropdownMenuItem(value: 'DOUGH', child: Text('خمیرگیر')),
              DropdownMenuItem(value: 'DIVIDER', child: Text('چانه‌گیر')),
            ],
            onChanged: (v) {
              setState(() {
                role = v!;
              });
            },
          ),

          ElevatedButton(onPressed: saveUser, child: const Text('ایجاد کاربر')),

          const Divider(),

          ...users.map(
            (u) => Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: Text(u.name),
                subtitle: Text(u.role),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
