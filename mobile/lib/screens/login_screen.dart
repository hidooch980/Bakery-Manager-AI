import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final user = TextEditingController();
  final pass = TextEditingController();

  void login() {

    if(AuthService.login(user.text)) {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
        ),
      );

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('کاربر پیدا نشد'),
        ),
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ورود مدیر')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: user,
              decoration: const InputDecoration(labelText:'نام کاربری'),
            ),
            TextField(
              controller: pass,
              obscureText:true,
              decoration: const InputDecoration(labelText:'رمز عبور'),
            ),
            const SizedBox(height:20),
            ElevatedButton(
              onPressed: login,
              child: const Text('ورود'),
            )
          ],
        ),
      ),
    );
  }
}
