import 'package:flutter/material.dart';
import '../services/user_management_service.dart';
import '../services/api_service.dart';

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
  bool loading = false;
  bool loadingList = true;
  String error = '';
  List<dynamic> users = [];

  static const roleLabels = {
    'MANAGER': 'مدیر',
    'SELLER': 'فروشنده',
    'DOUGH_MAKER': 'خمیرگیر',
    'DOUGH_DIVIDER': 'چانه‌گیر',
    'ACCOUNTANT': 'حسابدار',
    'EMPLOYEE': 'کارمند',
  };

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    setState(() => loadingList = true);
    final list = await UserManagementService.getUsers();
    if (!mounted) return;
    setState(() {
      users = list;
      loadingList = false;
    });
  }

  Future<void> saveUser() async {
    if (nameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      setState(() => error = 'نام، موبایل و رمز عبور الزامی است');
      return;
    }

    setState(() {
      loading = true;
      error = '';
    });

    final ok = await UserManagementService.createUser(
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      password: passwordController.text,
      role: role,
    );

    if (!mounted) return;

    setState(() => loading = false);

    if (ok) {
      nameController.clear();
      phoneController.clear();
      passwordController.clear();
      await loadUsers();
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(const SnackBar(content: Text('کاربر با موفقیت ایجاد شد')));
    } else {
      setState(() => error = ApiService.lastError.isNotEmpty
          ? ApiService.lastError
          : 'خطا در ایجاد کاربر');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مدیریت کاربران')),
      body: RefreshIndicator(
        onRefresh: loadUsers,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'ایجاد کاربر جدید',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'نام کاربر'),
            ),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'شماره موبایل'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'رمز عبور'),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: role,
              decoration: const InputDecoration(labelText: 'نقش'),
              items: roleLabels.entries
                  .map(
                    (e) => DropdownMenuItem(value: e.key, child: Text(e.value)),
                  )
                  .toList(),
              onChanged: (v) => setState(() => role = v!),
            ),
            if (error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(error, style: const TextStyle(color: Colors.red)),
              ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: loading ? null : saveUser,
              child: loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('ایجاد کاربر'),
            ),
            const Divider(height: 32),
            const Text(
              'کاربران ثبت‌شده',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            if (loadingList)
              const Center(child: CircularProgressIndicator())
            else if (users.isEmpty)
              const Text('کاربری ثبت نشده است.')
            else
              ...users.map(
                (u) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(u['name'] ?? ''),
                    subtitle: Text(
                      '${u['phone'] ?? ''} • ${roleLabels[u['role']] ?? u['role'] ?? ''}',
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
