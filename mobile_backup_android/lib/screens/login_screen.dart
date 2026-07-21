import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../routes/app_router.dart';

class LoginScreen extends StatefulWidget {
  final UserService userService;

  const LoginScreen({super.key, required this.userService});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phone = TextEditingController();
  final password = TextEditingController();

  void login() {
    final user = widget.userService.login(
      phone.text,
      password.text,
    );

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AppRouter.home(user.role),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("اطلاعات ورود اشتباه است"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ورود")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: phone,
              decoration: const InputDecoration(
                labelText: "شماره تلفن",
              ),
            ),
            TextField(
              controller: password,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "رمز عبور",
              ),
            ),
            ElevatedButton(
              onPressed: login,
              child: const Text("ورود"),
            ),
          ],
        ),
      ),
    );
  }
}
