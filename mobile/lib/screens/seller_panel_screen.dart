
import 'package:flutter/material.dart';
import '../services/seller_panel_service.dart';
import '../services/auth_service.dart';
import '../services/bakery_system_service.dart';
import '../services/shift_service.dart';

class SellerPanelScreen extends StatefulWidget {
  const SellerPanelScreen({super.key});
  @override State<SellerPanelScreen> createState() => _SellerPanelScreenState();
}

class _SellerPanelScreenState extends State<SellerPanelScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;
  Map<String,dynamic> _summary = {};
  List<Map<String,dynamic>> _recentSales = [];
  List<BreadType> _breadTypes = [];
  List<Shift> _shifts = [];
  String _currentShiftId = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 4, vsync: this);
    _load();
  }

  @override void dispose() { _tab.dispose(); super.dispose(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    final name = AuthService.name();
    final s = await SellerPanelService.summary(name);
    final sales = await SellerPanelService.sellerSales(name, onlyUnsettled: false);
    final bts = await BakerySystemService.loadBreadTypes();
    final shifts = await ShiftService.list();
    final cur = await ShiftService.current();
    setState(() {
      _summary = s;
      _recentSales = sales.take(30).toList();
      _breadTypes = bts.where((b) => b.active).toList();
      _shifts = shifts;
      _currentShiftId = cur?.id ?? (shifts.isNotEmpty ? shifts[0].id : '');
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: cs.surfaceContainerLowest,
        appBar: AppBar(
          title: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const Text('\u06a9\u0627\u0631\u062a\u0627\u0628\u0644 \u0641\u0631\u0648\u0634\u0646\u062f\u0647', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(AuthService.name(), style: TextStyle(fontSize: 12, color: cs.onSurface.withOpacity(0.6))),
          ]),
          actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _load)],
          bottom: TabBar(
            controller: _tab,
            tabs: const [
              Tab(icon: Icon(Icons.dashboard_outlined, size: 18), text: '\u062e\u0644\u0627\u0635\u0647'),
              Tab(icon: Icon(Icons.point_of_sale_outlined, size: 18), text: '\u0641\u0631\u0648\u0634 \u0646\u0642\u062f\u06cc'),
              Tab(icon: Icon(Icons.receipt_long_outlined, size: 18), text: '\u0646\u0633\u06cc\u0647/\u0645\u0646\u0632\u0644'),
              Tab(icon: Icon(Icons.warning_amber_outlined, size: 18), text: '\u06a9\u0633\u0631\u06cc'),
            ],
          ),
        ),
        body: _loading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(controller: _tab, children: [
              _SummaryTab(summary: _summary, recentSales: _recentSales),
              _SaleFormTab(type: SaleType.cash, breadTypes: _breadTypes, shiftId: _currentShiftId, onSaved: _load),
              _SaleFormTab(type: SaleType.credit, breadTypes: _breadTypes, shiftId: _currentShiftId, onSaved: _load),
              _ShortfallTab(shiftId: _currentShiftId, onSaved: _load),
            ]),
      ),
    );
  }
}

class _SummaryTab extends StatelessWidget {
  final Map<String,dynamic> summary;
  final List<Map<String,dynamic>> recentSales;
  const _SummaryTab({required this.summary, required this.recentSales});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final cash = (summary['cash'] as num? ?? 0).toInt();
    final credit = (summary['credit'] as num? ?? 0).toInt();
    final home = (summary['home'] as num? ?? 0).toInt();
    final shortfall = (summary['shortfall'] as num? ?? 0).toInt();
    final total = (summary['total'] as num? ?? 0).toInt();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // کارت \u062cمع کل
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [cs.primary, cs.primary.withOpacity(0.7)]),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(children: [
            const Text('\u062c\u0645\u0639 \u0628\u062f\u0647\u06a9\u0627\u0631\u06cc \u0634\u0645\u0627', style: TextStyle(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 8),
            Text(_fmt(total), style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
            const Text('\u062a\u0648\u0645\u0627\u0646', style: TextStyle(color: Colors.white70, fontSize: 12)),
          ]),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.8,
          children: [
            _card('\u0646\u0642\u062f\u06cc', cash, Icons.payments_outlined, cs.primary),
            _card('\u0646\u0633\u06cc\u0647', credit, Icons.receipt_outlined, Colors.orange),
            _card('\u0645\u0646\u0632\u0644', home, Icons.home_outlined, Colors.blue),
            _card('\u06a9\u0633\u0631\u06cc', shortfall, Icons.warning_outlined, Colors.red),
          ],
        ),
        const SizedBox(height: 16),
        if (recentSales.isNotEmpty) ...[
          const Text('\u0622\u062e\u0631\u06cc\u0646 \u0641\u0631\u0648\u0634\u200c\u0647\u0627', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...recentSales.take(10).map((s) => _saleTile(context, s)),
        ],
      ],
    );
  }

  Widget _card(String label, int val, IconData icon, Color color) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: color.withOpacity(0.08),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: color.withOpacity(0.2)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: color, size: 20),
      const Spacer(),
      Text(_fmt(val), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color)),
      Text(label, style: const TextStyle(fontSize: 11)),
    ]),
  );

  Widget _saleTile(BuildContext ctx, Map<String,dynamic> s) {
    final type = s['type'] as String? ?? 'cash';
    final colors = {'cash': Colors.green, 'credit': Colors.orange, 'home': Colors.blue};
    final icons = {'cash': Icons.payments_outlined, 'credit': Icons.receipt_outlined, 'home': Icons.home_outlined};
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(ctx).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(children: [
        Icon(icons[type] ?? Icons.circle, color: colors[type], size: 18),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${s['breadType'] ?? ''} \u2014 ${s['quantity'] ?? 0} \u0639\u062f\u062f', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          if ((s['customerName'] ?? '').isNotEmpty)
            Text(s['customerName'], style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ])),
        Text(_fmt((s['amount'] as num? ?? 0).toInt()), style: TextStyle(color: colors[type], fontWeight: FontWeight.bold)),
      ]),
    );
  }
}

class _SaleFormTab extends StatefulWidget {
  final SaleType type;
  final List<BreadType> breadTypes;
  final String shiftId;
  final VoidCallback onSaved;
  const _SaleFormTab({required this.type, required this.breadTypes, required this.shiftId, required this.onSaved});
  @override State<_SaleFormTab> createState() => _SaleFormTabState();
}

class _SaleFormTabState extends State<_SaleFormTab> {
  final _qty = TextEditingController();
  final _customer = TextEditingController();
  final _address = TextEditingController();
  String? _selectedBread;
  bool _saving = false;
  int _price = 0;
  int _total = 0;

  @override void initState() {
    super.initState();
    if (widget.breadTypes.isNotEmpty) _selectedBread = widget.breadTypes.first.id;
    _loadPrice();
  }

  Future<void> _loadPrice() async {
    final p = await BakerySystemService.breadPrice();
    setState(() => _price = p);
  }

  void _calcTotal() {
    final q = int.tryParse(_qty.text) ?? 0;
    setState(() => _total = q * _price);
  }

  @override void dispose() { _qty.dispose(); _customer.dispose(); _address.dispose(); super.dispose(); }

  Future<void> _save() async {
    final qty = int.tryParse(_qty.text) ?? 0;
    if (qty <= 0 || _selectedBread == null) return;
    final bread = widget.breadTypes.firstWhere((b) => b.id == _selectedBread!);
    setState(() => _saving = true);
    await SellerPanelService.addSale(
      sellerName: AuthService.name(),
      breadType: bread.name,
      quantity: qty,
      amount: _total,
      type: widget.type,
      customerName: _customer.text.trim(),
      address: _address.text.trim(),
      shiftId: widget.shiftId,
    );
    _qty.clear(); _customer.clear(); _address.clear();
    setState(() { _saving = false; _total = 0; });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('\u0641\u0631\u0648\u0634 ${widget.type.label} \u062b\u0628\u062a \u0634\u062f'),
        backgroundColor: Colors.green,
      ));
    }
    widget.onSaved();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isCredit = widget.type == SaleType.credit;
    final isHome = widget.type == SaleType.home;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // نوع نان
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('\u0641\u0631\u0648\u0634 ${widget.type.label}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: cs.primary)),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedBread,
                decoration: const InputDecoration(labelText: '\u0646\u0648\u0639 \u0646\u0627\u0646', prefixIcon: Icon(Icons.bakery_dining)),
                items: widget.breadTypes.map((b) =>
                  DropdownMenuItem(value: b.id, child: Text(b.name))).toList(),
                onChanged: (v) => setState(() => _selectedBread = v),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _qty,
                keyboardType: TextInputType.number,
                onChanged: (_) => _calcTotal(),
                decoration: InputDecoration(
                  labelText: '\u062a\u0639\u062f\u0627\u062f',
                  prefixIcon: const Icon(Icons.numbers),
                  suffix: Text('\u00d7 ${_fmt(_price)} = ${_fmt(_total)} \u062a',
                    style: TextStyle(color: cs.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ),
              if (isCredit || isHome) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: _customer,
                  decoration: InputDecoration(
                    labelText: isHome ? '\u0646\u0627\u0645 \u062e\u0627\u0646\u0648\u0627\u0631' : '\u0646\u0627\u0645 \u0645\u0634\u062a\u0631\u06cc',
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                ),
              ],
              if (isHome) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: _address,
                  decoration: const InputDecoration(labelText: '\u0622\u062f\u0631\u0633', prefixIcon: Icon(Icons.location_on_outlined)),
                ),
              ],
              const SizedBox(height: 20),
              // خلاصه مبلغ
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const Text('\u0645\u0628\u0644\u063a \u0641\u0631\u0648\u0634:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('${_fmt(_total)} \u062a\u0648\u0645\u0627\u0646',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: cs.primary)),
                ]),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _saving ? null : _save,
                icon: _saving ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.check),
                label: Text('\u062b\u0628\u062a \u0641\u0631\u0648\u0634 ${widget.type.label}'),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

class _ShortfallTab extends StatefulWidget {
  final String shiftId;
  final VoidCallback onSaved;
  const _ShortfallTab({required this.shiftId, required this.onSaved});
  @override State<_ShortfallTab> createState() => _ShortfallTabState();
}

class _ShortfallTabState extends State<_ShortfallTab> {
  final _amount = TextEditingController();
  final _note = TextEditingController();
  bool _saving = false;
  @override void dispose() { _amount.dispose(); _note.dispose(); super.dispose(); }

  Future<void> _save() async {
    final amt = int.tryParse(_amount.text) ?? 0;
    if (amt <= 0) return;
    setState(() => _saving = true);
    await SellerPanelService.addShortfall(
      sellerName: AuthService.name(),
      amount: amt,
      shiftId: widget.shiftId,
      note: _note.text.trim(),
    );
    _amount.clear(); _note.clear();
    setState(() => _saving = false);
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('\u06a9\u0633\u0631\u06cc \u062b\u0628\u062a \u0634\u062f'), backgroundColor: Colors.orange));
    widget.onSaved();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('\u062b\u0628\u062a \u06a9\u0633\u0631\u06cc \u0635\u0646\u062f\u0648\u0642',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red)),
              const SizedBox(height: 16),
              TextField(
                controller: _amount,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: '\u0645\u0628\u0644\u063a \u06a9\u0633\u0631\u06cc (\u062a\u0648\u0645\u0627\u0646)', prefixIcon: Icon(Icons.money_off, color: Colors.red)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _note,
                decoration: const InputDecoration(labelText: '\u062f\u0644\u06cc\u0644 (\u0627\u062e\u062a\u06cc\u0627\u0631\u06cc)', prefixIcon: Icon(Icons.notes)),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _saving ? null : _save,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                icon: const Icon(Icons.warning_amber),
                label: const Text('\u062b\u0628\u062a \u06a9\u0633\u0631\u06cc'),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

String _fmt(int n) {
  final str = n.abs().toString();
  final buf = StringBuffer();
  for (int i = 0; i < str.length; i++) {
    if (i > 0 && (str.length - i) % 3 == 0) buf.write(',');
    buf.write(str[i]);
  }
  return n < 0 ? '-${buf.toString()}' : buf.toString();
}
