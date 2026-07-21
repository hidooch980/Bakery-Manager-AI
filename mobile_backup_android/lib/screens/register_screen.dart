import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/user_service.dart';

class RegisterScreen extends StatefulWidget {
  final UserService userService;

  const RegisterScreen({super.key, required this.userService});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final name = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();

  void register() {
    final ok = widget.userService.register(
      User(
        name: name.text,
        phone: phone.text,
        password: password.text,
        role: "MANAGER",
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok ? "ثبت نام مدیر انجام شد" : "این شماره قبلاً ثبت شده",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ثبت نام مدیر")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: "نام"),
            ),
            TextField(
              controller: phone,
              decoration: const InputDecoration(labelText: "شماره تلفن"),
            ),
            TextField(
              controller: password,
              obscureText: true,
              decoration: const InputDecoration(labelText: "رمز عبور"),
            ),
            ElevatedButton(
              onPressed: register,
              child: const Text("ثبت نام"),
            ),
          ],
        ),
      ),
    );
  }
}
