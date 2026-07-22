import 'package:flutter/material.dart';

class UpdateProgressDialog extends StatelessWidget {
  final String text;
  const UpdateProgressDialog({super.key, this.text = "در حال دریافت آپدیت..."});

  @override
  Widget build(BuildContext c) {
    return AlertDialog(
      title: const Text("به‌روزرسانی"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 15),
          Text(text),
        ],
      ),
    );
  }
}
