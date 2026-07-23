import 'package:flutter/material.dart';

class UpdateCard extends StatelessWidget {
  final String version;
  final String? notes;
  final VoidCallback onUpdate;

  const UpdateCard({
    super.key,
    required this.version,
    this.notes,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.amber.shade50,
      child: ListTile(
        leading: const Icon(Icons.system_update, color: Colors.amber),
        title: Text('نسخه جدید $version موجود است'),
        subtitle: notes != null ? Text(notes!) : null,
        trailing: TextButton(
          onPressed: onUpdate,
          child: const Text('بروزرسانی'),
        ),
      ),
    );
  }
}
