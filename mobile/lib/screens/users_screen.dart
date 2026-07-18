import 'package:flutter/material.dart';
import '../services/user_service.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {

  final nameController = TextEditingController();

  String role = 'seller';

  void saveUser() {

    UserService.add(
      name: nameController.text,
      role: role,
    );

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('کاربر ایجاد شد'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final users = UserService.getAll();

    return Scaffold(
      appBar: AppBar(
        title: const Text('مدیریت کاربران'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText:'نام کاربر',
            ),
          ),

          DropdownButton<String>(
            value: role,
            items: const [
              DropdownMenuItem(
                value:'manager',
                child:Text('مدیر'),
              ),
              DropdownMenuItem(
                value:'seller',
                child:Text('فروشنده'),
              ),
              DropdownMenuItem(
                value:'dough_worker',
                child:Text('خمیرگیر'),
              ),
              DropdownMenuItem(
                value:'divider',
                child:Text('چانه‌گیر'),
              ),
            ],
            onChanged:(v){
              setState(() {
                role=v!;
              });
            },
          ),

          ElevatedButton(
            onPressed: saveUser,
            child: const Text('ایجاد کاربر'),
          ),

          const Divider(),

          ...users.map(
            (u)=>Card(
              child:ListTile(
                leading:const Icon(Icons.person),
                title:Text(u['name']),
                subtitle:Text(u['role']),
              ),
            ),
          )

        ],
      ),
    );
  }
}
