
import 'package:flutter/material.dart';
import '../services/dough_worker_service.dart';
import '../services/bakery_system_service.dart';
import '../services/shift_service.dart';
import '../services/auth_service.dart';

class DoughWorkerScreen extends StatefulWidget {
  const DoughWorkerScreen({super.key});
  @override State<DoughWorkerScreen> createState() => _DoughWorkerScreenState();
}

class _DoughWorkerScreenState extends State<DoughWorkerScreen> {
  List<BreadType> _breadTypes = [];
  List<DoughRecord> _records = [];
  List<Shift> _shifts = [];
  String _shiftId = '';
  bool _loading = true;

  final _flourCtrl = TextEditingController();
  final _actualCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  String? _selectedBread;
  DoughRecord? _lastResult;
  bool _saving = false;

  @override void initState() { super.initState(); _load(); }
  @override void dispose() { _flourCtrl.dispose(); _actualCtrl.dispose(); _noteCtrl.dispose(); super.dispose(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    final bts = await BakerySystemService.loadBreadTypes();
    final recs = await DoughWorkerService.records();
    final shifts = await ShiftService.list();
    final cur = await ShiftService.current();
    setState(() {
      _breadTypes = bts.where((b) => b.active).toList();
      _records = recs.take(20).toList();
      _shifts = shifts;
      _shiftId = cur?.id ?? (shifts.isNotEmpty ? shifts[0].id : '');
      if (_selectedBread == null && _breadTypes.isNotEmpty) _selectedBread = _breadTypes.first.id;
      _loading = false;
    });
  }

  Future<void> _submit() async {
    final flour = double.tryParse(_flourCtrl.text) ?? 0;
    final actual = int.tryParse(_actualCtrl.text) ?? 0;
    if (flour <= 0 || actual <= 0 || _selectedBread == null) return;
    final bread = _breadTypes.firstWhere((b) => b.id == _selectedBread!);
    setState(() => _saving = true);
    final record = await DoughWorkerService.addRecord(
      workerName: AuthService.name(),
      breadType: bread,
      flourBagsUsed: flour,
      actualDoughs: actual,
      shiftId: _shiftId,
      note: _noteCtrl.text.trim(),
    );
    _flourCtrl.clear(); _actualCtrl.clear(); _noteCtrl.clear();
    setState(() { _saving = false; _lastResult = record; });
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: cs.surfaceContainerLowest,
        appBar: AppBar(
          title: const Text('\u06a9\u0627\u0631\u062a\u0627\u0628\u0644 \u0686\u0627\u0646\u0647\u200c\u06af\u06cc\u0631 / \u062e\u0645\u06cc\u0631\u06af\u06cc\u0631', style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _load)],
        ),
        body: _loading ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // فرم ثبت
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('\u062b\u0628\u062a \u0686\u0627\u0646\u0647', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: cs.primary)),
                      const SizedBox(height: 14),
                      // \u0634\u06cc\u0641\u062a
                      DropdownButtonFormField<String>(
                        value: _shifts.any((s) => s.id == _shiftId) ? _shiftId : null,
                        decoration: const InputDecoration(labelText: '\u0634\u06cc\u0641\u062a', prefixIcon: Icon(Icons.schedule)),
                        items: _shifts.map((s) => DropdownMenuItem(value: s.id, child: Text('${s.name} (${s.startTime})'))).toList(),
                        onChanged: (v) => setState(() => _shiftId = v ?? _shiftId),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _selectedBread,
                        decoration: const InputDecoration(labelText: '\u0646\u0648\u0639 \u0646\u0627\u0646', prefixIcon: Icon(Icons.bakery_dining)),
                        items: _breadTypes.map((b) => DropdownMenuItem(value: b.id,
                          child: Text('${b.name} (\u0686\u0627\u0646\u0647 ${b.doughWeight.toInt()}\u06af)'))).toList(),
                        onChanged: (v) => setState(() => _selectedBread = v),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _flourCtrl,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: '\u0622\u0631\u062f \u0645\u0635\u0631\u0641\u06cc (\u06a9\u06cc\u0633\u0647)',
                          prefixIcon: Icon(Icons.inventory_2_outlined),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _actualCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: '\u062a\u0639\u062f\u0627\u062f \u0686\u0627\u0646\u0647 \u062b\u0628\u062a\u200c\u0634\u062f\u0647',
                          prefixIcon: Icon(Icons.numbers),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _noteCtrl,
                        decoration: const InputDecoration(labelText: '\u062a\u0648\u0636\u06cc\u062d (\u0627\u062e\u062a\u06cc\u0627\u0631\u06cc)', prefixIcon: Icon(Icons.notes)),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _saving ? null : _submit,
                        icon: _saving ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.calculate),
                        label: const Text('\u0645\u062d\u0627\u0633\u0628\u0647 \u0648 \u062b\u0628\u062a'),
                      ),
                    ]),
                  ),
                ),
                // \u0646\u062a\u06cc\u062c\u0647 \u0622\u062e\u0631\u06cc\u0646 \u062b\u0628\u062a
                if (_lastResult != null) ...[
                  const SizedBox(height: 16),
                  _ResultCard(record: _lastResult!),
                ],
                // \u062a\u0627\u0631\u06cc\u062e\u0686\u0647
                if (_records.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text('\u0633\u0627\u0628\u0642\u0647', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ..._records.map((r) => _HistoryTile(record: r)),
                ],
              ],
            ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final DoughRecord record;
  const _ResultCard({required this.record});

  @override
  Widget build(BuildContext context) {
    final statusColor = record.status == 'green' ? Colors.green
      : record.status == 'yellow' ? Colors.orange : Colors.red;
    final statusText = record.status == 'green' ? '\u{1F7E2} \u0637\u0628\u06cc\u0639\u06cc'
      : record.status == 'yellow' ? '\u{1F7E1} \u0642\u0627\u0628\u0644 \u0642\u0628\u0648\u0644' : '\u{1F534} \u0647\u0634\u062f\u0627\u0631';
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.analytics_outlined, color: statusColor),
          const SizedBox(width: 8),
          Text('\u0646\u062a\u06cc\u062c\u0647 \u0645\u062d\u0627\u0633\u0628\u0647', style: TextStyle(fontWeight: FontWeight.bold, color: statusColor)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: statusColor.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
            child: Text(statusText, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ]),
        const Divider(height: 20),
        _row('\u0622\u0631\u062f \u0645\u0635\u0631\u0641\u06cc', '${record.flourBagsUsed} \u06a9\u06cc\u0633\u0647'),
        _row('\u0648\u0632\u0646 \u062e\u0645\u06cc\u0631', '${(record.bagWeightGrams * record.flourBagsUsed * (1 + record.waterRatioUsed)).toInt()} \u06af\u0631\u0645'),
        _row('\u0686\u0627\u0646\u0647 \u0633\u06cc\u0633\u062a\u0645\u0627\u062a\u06cc\u06a9', '${record.systematicDoughs} \u0639\u062f\u062f', bold: true),
        _row('\u0686\u0627\u0646\u0647 \u062b\u0628\u062a\u200c\u0634\u062f\u0647', '${record.actualDoughs} \u0639\u062f\u062f', bold: true),
        const Divider(height: 16),
        _row('\u0627\u062e\u062a\u0644\u0627\u0641', '${record.diff} \u0639\u062f\u062f (${record.diffPercent.toStringAsFixed(1)}\u066a)',
          color: statusColor, bold: true),
        _row('\u0645\u0639\u0627\u062f\u0644 \u0622\u0631\u062f', '${(record.diff * record.doughWeightGrams / 1000).toStringAsFixed(1)} \u06a9\u06cc\u0644\u0648', color: Colors.grey),
      ]),
    );
  }

  Widget _row(String label, String val, {Color? color, bool bold = false}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
      Text(val, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal, color: color, fontSize: 13)),
    ]),
  );
}

class _HistoryTile extends StatelessWidget {
  final DoughRecord record;
  const _HistoryTile({required this.record});
  @override Widget build(BuildContext context) {
    final color = record.status == 'green' ? Colors.green : record.status == 'yellow' ? Colors.orange : Colors.red;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border(right: BorderSide(color: color, width: 4)),
      ),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${record.breadTypeName} \u2014 ${record.flourBagsUsed} \u06a9\u06cc\u0633\u0647',
            style: const TextStyle(fontWeight: FontWeight.w600)),
          Text('\u0633\u06cc\u0633\u062a\u0645: ${record.systematicDoughs} | \u062b\u0628\u062a: ${record.actualDoughs} | \u0627\u062e\u062a\u0644\u0627\u0641: ${record.diff}',
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ])),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Text('${record.diffPercent.toStringAsFixed(1)}\u066a', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
        ),
      ]),
    );
  }
}
