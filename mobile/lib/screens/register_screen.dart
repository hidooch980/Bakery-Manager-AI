import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final name = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();

  String role = 'MANAGER';
  String error = '';
  bool loading = false;

  Future<void> register() async {
    setState(() => loading = true);

    final ok = await AuthService.register(
      name.text,
      phone.text,
      password.text,
      role,
    );

    setState(() => loading = false);

    if (ok && mounted) {
      Navigator.pop(context);
    } else {
      setState(() => error = 'ثبت نام ناموفق بود');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ثبت نام کاربر')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: name, decoration: const InputDecoration(labelText: 'نام')),
            TextField(controller: phone, decoration: const InputDecoration(labelText: 'موبایل')),
            TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'رمز')),
            DropdownButton<String>(
              value: role,
              items: const [
                DropdownMenuItem(value: 'MANAGER', child: Text('مدیر')),
                DropdownMenuItem(value: 'SELLER', child: Text('فروشنده')),
                DropdownMenuItem(value: 'EMPLOYEE', child: Text('کارمند')),
              ],
              onChanged: (v) => setState(() => role = v!),
            ),
            Text(error),
            ElevatedButton(
              onPressed: loading ? null : register,
              child: const Text('ثبت'),
            )
          ],
        ),
      ),
    );
  }
}
