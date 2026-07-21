
import 'package:flutter/material.dart';
import '../services/user_management_service.dart';
import '../services/shift_service.dart';
import '../services/role_service.dart';
import '../services/local_database_service.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});
  @override State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  List<ManagedUser> _users = [];
  List<Shift> _shifts = [];
  bool _loading = true;

  @override void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final users = await UserManagementService.list();
    final shifts = await ShiftService.list();
    setState(() { _users = users; _shifts = shifts; _loading = false; });
  }

  Future<void> _addOrEdit([ManagedUser? existing]) async {
    final result = await showDialog<ManagedUser>(
      context: context,
      builder: (_) => _UserDialog(existing: existing, shifts: _shifts),
    );
    if (result != null) {
      if (existing != null) {
        await UserManagementService.update(result);
        // \u0628\u0647\u200c\u0631\u0648\u0632\u0631\u0633\u0627\u0646\u06cc \u062f\u0631 \u067e\u0627\u06cc\u06af\u0627\u0647 \u0645\u062d\u0644\u06cc
        await LocalDatabaseService.updateUser(
          phone: result.phone, name: result.name,
          role: result.role, password: result.password,
        );
      } else {
        await UserManagementService.add(result);
        await LocalDatabaseService.addUser(
          name: result.name, phone: result.phone,
          password: result.password, role: result.role,
        );
      }
      await _load();
    }
  }

  Future<void> _delete(ManagedUser user) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('\u062d\u0630\u0641 \u06a9\u0627\u0631\u0628\u0631'),
          content: Text('\u0622\u06cc\u0627 \u0645\u06cc\u200c\u062e\u0648\u0627\u0647\u06cc\u062f "${user.name}" \u062d\u0630\u0641 \u0634\u0648\u062f\u061f'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('\u062e\u06cc\u0631')),
            ElevatedButton(onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('\u062d\u0630\u0641', style: TextStyle(color: Colors.white))),
          ],
        ),
      ),
    );
    if (ok == true) { await UserManagementService.remove(user.id); await _load(); }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('\u0645\u062f\u06cc\u0631\u06cc\u062a \u06a9\u0627\u0631\u0628\u0631\u0627\u0646', style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _load)],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _addOrEdit(),
          icon: const Icon(Icons.person_add),
          label: const Text('\u06a9\u0627\u0631\u0628\u0631 \u062c\u062f\u06cc\u062f'),
        ),
        body: _loading ? const Center(child: CircularProgressIndicator())
          : _users.isEmpty
            ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.group_outlined, size: 64, color: cs.outline),
                const SizedBox(height: 16),
                const Text('\u0647\u06cc\u0686 \u06a9\u0627\u0631\u0628\u0631\u06cc \u062b\u0628\u062a \u0646\u0634\u062f\u0647'),
              ]))
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                itemCount: _users.length,
                itemBuilder: (_, i) {
                  final u = _users[i];
                  final shift = _shifts.firstWhere((s) => s.id == u.shiftId, orElse: () => Shift(id:'',name:'\u2014',startTime:'',endTime:''));
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: CircleAvatar(
                        backgroundColor: _roleColor(u.role).withOpacity(0.15),
                        child: Text(AppRole.roleIcon(u.role), style: const TextStyle(fontSize: 20)),
                      ),
                      title: Text(u.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('${AppRole.roleLabel(u.role)} | ${u.phone}', style: const TextStyle(fontSize: 12)),
                        if (shift.name != '\u2014') Text('\u0634\u06cc\u0641\u062a: ${shift.name}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      ]),
                      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                        IconButton(icon: const Icon(Icons.edit_outlined, size: 20), onPressed: () => _addOrEdit(u)),
                        IconButton(icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red), onPressed: () => _delete(u)),
                      ]),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Color _roleColor(String r) {
    switch (r) {
      case AppRole.manager:  return Colors.orange;
      case AppRole.seller:   return Colors.blue;
      case AppRole.doughCut: return Colors.green;
      case AppRole.doughMix: return Colors.teal;
      default: return Colors.grey;
    }
  }
}

class _UserDialog extends StatefulWidget {
  final ManagedUser? existing;
  final List<Shift> shifts;
  const _UserDialog({this.existing, required this.shifts});
  @override State<_UserDialog> createState() => _UserDialogState();
}

class _UserDialogState extends State<_UserDialog> {
  final _name  = TextEditingController();
  final _phone = TextEditingController();
  final _pass  = TextEditingController();
  String _role = AppRole.seller;
  String _shiftId = '';
  bool _obscure = true;

  @override void initState() {
    super.initState();
    if (widget.existing != null) {
      _name.text = widget.existing!.name;
      _phone.text = widget.existing!.phone;
      _pass.text = widget.existing!.password;
      _role = widget.existing!.role;
      _shiftId = widget.existing!.shiftId;
    } else if (widget.shifts.isNotEmpty) {
      _shiftId = widget.shifts[0].id;
    }
  }
  @override void dispose() { _name.dispose(); _phone.dispose(); _pass.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(widget.existing == null ? '\u06a9\u0627\u0631\u0628\u0631 \u062c\u062f\u06cc\u062f' : '\u0648\u06cc\u0631\u0627\u06cc\u0634 \u06a9\u0627\u0631\u0628\u0631'),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: _name, decoration: const InputDecoration(labelText: '\u0646\u0627\u0645', prefixIcon: Icon(Icons.person_outline))),
            const SizedBox(height: 10),
            TextField(controller: _phone, keyboardType: TextInputType.phone, textDirection: TextDirection.ltr,
              decoration: const InputDecoration(labelText: '\u0634\u0645\u0627\u0631\u0647 \u0645\u0648\u0628\u0627\u06cc\u0644', prefixIcon: Icon(Icons.phone))),
            const SizedBox(height: 10),
            TextField(controller: _pass, obscureText: _obscure,
              decoration: InputDecoration(
                labelText: '\u0631\u0645\u0632 \u0639\u0628\u0648\u0631', prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscure = !_obscure)))),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _role,
              decoration: const InputDecoration(labelText: '\u0646\u0642\u0634', prefixIcon: Icon(Icons.badge_outlined)),
              items: AppRole.allRoles.map((r) => DropdownMenuItem(value: r,
                child: Text('${AppRole.roleIcon(r)} ${AppRole.roleLabel(r)}'))).toList(),
              onChanged: (v) => setState(() => _role = v ?? _role),
            ),
            if (widget.shifts.isNotEmpty) ...[
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: widget.shifts.any((s) => s.id == _shiftId) ? _shiftId : widget.shifts[0].id,
                decoration: const InputDecoration(labelText: '\u0634\u06cc\u0641\u062a', prefixIcon: Icon(Icons.schedule)),
                items: widget.shifts.map((s) => DropdownMenuItem(value: s.id, child: Text(s.name))).toList(),
                onChanged: (v) => setState(() => _shiftId = v ?? _shiftId),
              ),
            ],
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('\u0644\u063a\u0648')),
          ElevatedButton(onPressed: () {
            if (_name.text.isEmpty || _phone.text.isEmpty || _pass.text.isEmpty) return;
            Navigator.pop(context, ManagedUser(
              id: widget.existing?.id ?? UserManagementService.newId(),
              name: _name.text.trim(), phone: _phone.text.trim(),
              password: _pass.text, role: _role, shiftId: _shiftId,
              createdAt: widget.existing?.createdAt ?? UserManagementService.now(),
            ));
          }, child: const Text('\u0630\u062e\u06cc\u0631\u0647')),
        ],
      ),
    );
  }
}
