
import 'package:flutter/material.dart';
import '../services/bakery_system_service.dart';
import '../services/holiday_service.dart';
import '../services/shift_service.dart';

class BakerySystemScreen extends StatefulWidget {
  const BakerySystemScreen({super.key});
  @override State<BakerySystemScreen> createState() => _BakerySystemScreenState();
}

class _BakerySystemScreenState extends State<BakerySystemScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;
  @override void initState() { super.initState(); _tab = TabController(length: 4, vsync: this); }
  @override void dispose() { _tab.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('\u0633\u0627\u0645\u0627\u0646\u0647 \u0646\u0627\u0646\u0648\u0627\u06cc\u06cc', style: TextStyle(fontWeight: FontWeight.bold)),
          bottom: const TabBar(tabs: [
            Tab(icon: Icon(Icons.store, size: 18), text: '\u0627\u0637\u0644\u0627\u0639\u0627\u062a'),
            Tab(icon: Icon(Icons.bakery_dining, size: 18), text: '\u0627\u0646\u0648\u0627\u0639 \u0646\u0627\u0646'),
            Tab(icon: Icon(Icons.inventory_2, size: 18), text: '\u0622\u0631\u062f'),
            Tab(icon: Icon(Icons.event_busy, size: 18), text: '\u062a\u0639\u0637\u06cc\u0644\u0627\u062a'),
          ]),
        ),
        body: TabBarView(children: [
          const _BakeryInfoTab(),
          const _BreadTypesTab(),
          const _FlourConfigTab(),
          _HolidayTab(),
        ]),
      ),
    );
  }
}

// تب \u0627\u0637\u0644\u0627\u0639\u0627\u062a \u0646\u0627\u0646\u0648\u0627\u06cc\u06cc
class _BakeryInfoTab extends StatefulWidget {
  const _BakeryInfoTab();
  @override State<_BakeryInfoTab> createState() => _BakeryInfoTabState();
}
class _BakeryInfoTabState extends State<_BakeryInfoTab> {
  final _name = TextEditingController();
  final _owner = TextEditingController();
  final _city = TextEditingController();
  final _address = TextEditingController();
  final _license = TextEditingController();
  final _phone = TextEditingController();
  final _price = TextEditingController();
  bool _loading = true, _saving = false;

  @override void initState() { super.initState(); _load(); }
  @override void dispose() { for(final c in [_name,_owner,_city,_address,_license,_phone,_price]) c.dispose(); super.dispose(); }

  Future<void> _load() async {
    final d = await BakerySystemService.load();
    setState(() {
      _name.text = d['bakeryName']?.toString() ?? '';
      _owner.text = d['ownerName']?.toString() ?? '';
      _city.text = d['city']?.toString() ?? '';
      _address.text = d['address']?.toString() ?? '';
      _license.text = d['license']?.toString() ?? '';
      _phone.text = d['phone']?.toString() ?? '';
      _price.text = d['breadPrice']?.toString() ?? '5000';
      _loading = false;
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final d = await BakerySystemService.load();
    d['bakeryName'] = _name.text.trim();
    d['ownerName'] = _owner.text.trim();
    d['city'] = _city.text.trim();
    d['address'] = _address.text.trim();
    d['license'] = _license.text.trim();
    d['phone'] = _phone.text.trim();
    d['breadPrice'] = int.tryParse(_price.text) ?? 5000;
    await BakerySystemService.save(d);
    setState(() => _saving = false);
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('\u0630\u062e\u06cc\u0631\u0647 \u0634\u062f'), backgroundColor: Colors.green));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _field(_name, '\u0646\u0627\u0645 \u0646\u0627\u0646\u0648\u0627\u06cc\u06cc *', Icons.store),
        _field(_owner, '\u0646\u0627\u0645 \u0645\u0627\u0644\u06a9', Icons.person_outline),
        _field(_city, '\u0634\u0647\u0631', Icons.location_city_outlined),
        _field(_address, '\u0622\u062f\u0631\u0633', Icons.location_on_outlined),
        _field(_phone, '\u062a\u0644\u0641\u0646', Icons.phone, isPhone: true),
        _field(_license, '\u067e\u0631\u0648\u0627\u0646\u0647', Icons.badge_outlined),
        const Divider(),
        _field(_price, '\u0642\u06cc\u0645\u062a \u0647\u0631 \u0646\u0627\u0646 (\u062a\u0648\u0645\u0627\u0646)', Icons.price_change, isNum: true),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: _saving ? null : _save,
          icon: const Icon(Icons.save), label: const Text('\u0630\u062e\u06cc\u0631\u0647'),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _field(TextEditingController c, String label, IconData icon, {bool isPhone = false, bool isNum = false}) =>
    Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        keyboardType: isPhone ? TextInputType.phone : isNum ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      ),
    );
}

// \u062a\u0628 \u0627\u0646\u0648\u0627\u0639 \u0646\u0627\u0646
class _BreadTypesTab extends StatefulWidget {
  const _BreadTypesTab();
  @override State<_BreadTypesTab> createState() => _BreadTypesTabState();
}
class _BreadTypesTabState extends State<_BreadTypesTab> {
  List<BreadType> _types = [];
  bool _loading = true;

  @override void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final t = await BakerySystemService.loadBreadTypes();
    setState(() { _types = t; _loading = false; });
  }

  Future<void> _addOrEdit([BreadType? existing]) async {
    final result = await showDialog<BreadType>(
      context: context,
      builder: (_) => _BreadTypeDialog(existing: existing),
    );
    if (result != null) {
      List<BreadType> updated;
      if (existing != null) {
        updated = _types.map((t) => t.id == result.id ? result : t).toList();
      } else {
        updated = [..._types, result];
      }
      await BakerySystemService.saveBreadTypes(updated);
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    if (_loading) return const Center(child: CircularProgressIndicator());
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _types.length,
            itemBuilder: (_, i) {
              final t = _types[i];
              final sys = t.doughsPerBag(40000);
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: t.active ? cs.primaryContainer : Colors.grey.shade200,
                    child: Icon(Icons.bakery_dining, color: t.active ? cs.primary : Colors.grey),
                  ),
                  title: Text(t.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    '\u0686\u0627\u0646\u0647: ${t.doughWeight.toInt()}\u06af | \u0622\u0628: ${(t.waterRatio*100).toInt()}\u066a | \u0633\u06cc\u0633\u062a\u0645/\u06a9\u06cc\u0633\u0647: ${sys.toInt()} \u0639\u062f\u062f',
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(icon: const Icon(Icons.edit, size: 18), onPressed: () => _addOrEdit(t)),
                    Switch(value: t.active, onChanged: (v) async {
                      final updated = _types.map((x) => x.id == t.id
                        ? BreadType(id:x.id,name:x.name,doughWeight:x.doughWeight,saleWeight:x.saleWeight,waterRatio:x.waterRatio,active:v)
                        : x).toList();
                      await BakerySystemService.saveBreadTypes(updated);
                      await _load();
                    }),
                  ]),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: () => _addOrEdit(),
            icon: const Icon(Icons.add),
            label: const Text('\u0627\u0641\u0632\u0648\u062f\u0646 \u0646\u0648\u0639 \u0646\u0627\u0646'),
          ),
        ),
      ],
    );
  }
}

class _BreadTypeDialog extends StatefulWidget {
  final BreadType? existing;
  const _BreadTypeDialog({this.existing});
  @override State<_BreadTypeDialog> createState() => _BreadTypeDialogState();
}
class _BreadTypeDialogState extends State<_BreadTypeDialog> {
  final _name = TextEditingController();
  final _dough = TextEditingController();
  final _sale = TextEditingController();
  final _water = TextEditingController();

  @override void initState() {
    super.initState();
    if (widget.existing != null) {
      _name.text = widget.existing!.name;
      _dough.text = widget.existing!.doughWeight.toString();
      _sale.text = widget.existing!.saleWeight.toString();
      _water.text = (widget.existing!.waterRatio * 100).toInt().toString();
    }
  }
  @override void dispose() { _name.dispose(); _dough.dispose(); _sale.dispose(); _water.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: Text(widget.existing == null ? '\u0646\u0648\u0639 \u0646\u0627\u0646 \u062c\u062f\u06cc\u062f' : '\u0648\u06cc\u0631\u0627\u06cc\u0634 \u0646\u0648\u0639 \u0646\u0627\u0646'),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: _name, decoration: const InputDecoration(labelText: '\u0646\u0627\u0645 \u0646\u0627\u0646')),
            const SizedBox(height: 10),
            TextField(controller: _dough, keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '\u0648\u0632\u0646 \u0686\u0627\u0646\u0647 (\u06af\u0631\u0645)', hintText: '350')),
            const SizedBox(height: 10),
            TextField(controller: _sale, keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '\u0648\u0632\u0646 \u0646\u0627\u0646 \u067e\u062e\u062a\u0647 (\u06af\u0631\u0645)', hintText: '300')),
            const SizedBox(height: 10),
            TextField(controller: _water, keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '\u062f\u0631\u0635\u062f \u0622\u0628 (\u0645\u062b\u0644\u0627\u064b 60)', hintText: '60')),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('\u0644\u063a\u0648')),
          ElevatedButton(onPressed: () {
            final bt = BreadType(
              id: widget.existing?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
              name: _name.text.trim(),
              doughWeight: double.tryParse(_dough.text) ?? 300,
              saleWeight: double.tryParse(_sale.text) ?? 250,
              waterRatio: (double.tryParse(_water.text) ?? 60) / 100,
            );
            Navigator.pop(context, bt);
          }, child: const Text('\u0630\u062e\u06cc\u0631\u0647')),
        ],
      ),
    );
  }
}

// \u062a\u0628 \u0622\u0631\u062f
class _FlourConfigTab extends StatefulWidget {
  const _FlourConfigTab();
  @override State<_FlourConfigTab> createState() => _FlourConfigTabState();
}
class _FlourConfigTabState extends State<_FlourConfigTab> {
  final _bagKg  = TextEditingController();
  final _minBag = TextEditingController();
  final _p1     = TextEditingController();
  final _p2     = TextEditingController();
  final _p3     = TextEditingController();
  bool _loading = true, _saving = false;

  @override void initState() { super.initState(); _load(); }
  @override void dispose() { for(final c in [_bagKg,_minBag,_p1,_p2,_p3]) c.dispose(); super.dispose(); }

  Future<void> _load() async {
    final d = await BakerySystemService.load();
    setState(() {
      _bagKg.text  = d['bagWeightKg']?.toString() ?? '40';
      _minBag.text = d['minFlourBags']?.toString() ?? '5';
      _p1.text     = d['period1Flour']?.toString() ?? '48';
      _p2.text     = d['period2Flour']?.toString() ?? '48';
      _p3.text     = d['period3Flour']?.toString() ?? '48';
      _loading = false;
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final d = await BakerySystemService.load();
    d['bagWeightKg']  = double.tryParse(_bagKg.text) ?? 40;
    d['minFlourBags'] = int.tryParse(_minBag.text) ?? 5;
    d['period1Flour'] = int.tryParse(_p1.text) ?? 48;
    d['period2Flour'] = int.tryParse(_p2.text) ?? 48;
    d['period3Flour'] = int.tryParse(_p3.text) ?? 48;
    await BakerySystemService.save(d);
    setState(() => _saving = false);
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('\u0630\u062e\u06cc\u0631\u0647 \u0634\u062f'), backgroundColor: Colors.green));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _sec('\u062a\u0646\u0638\u06cc\u0645\u0627\u062a \u0622\u0631\u062f', Icons.inventory_2_outlined, [
          _field(_bagKg, '\u0648\u0632\u0646 \u0647\u0631 \u06a9\u06cc\u0633\u0647 (\u06a9\u06cc\u0644\u0648\u06af\u0631\u0645)', Icons.scale),
          _field(_minBag, '\u062d\u062f\u0627\u0642\u0644 \u0645\u0648\u062c\u0648\u062f\u06cc \u0647\u0634\u062f\u0627\u0631 (\u06a9\u06cc\u0633\u0647)', Icons.warning_amber_outlined),
        ]),
        const SizedBox(height: 16),
        _sec('\u0622\u0631\u062f \u062a\u062e\u0635\u06cc\u0635\u06cc \u0647\u0631 \u062f\u0648\u0631\u0647 (\u06a9\u06cc\u0633\u0647)', Icons.date_range, [
          _field(_p1, '\u062f\u0648\u0631\u0647 \u06f1 (\u06f5 \u062a\u0627 \u06f1\u06f4)', Icons.looks_one_outlined),
          _field(_p2, '\u062f\u0648\u0631\u0647 \u06f2 (\u06f1\u06f5 \u062a\u0627 \u06f2\u06f4)', Icons.looks_two_outlined),
          _field(_p3, '\u062f\u0648\u0631\u0647 \u06f3 (\u06f2\u06f5 \u062a\u0627 \u06f4)', Icons.looks_3_outlined),
        ]),
        const SizedBox(height: 16),
        ElevatedButton.icon(onPressed: _saving ? null : _save, icon: const Icon(Icons.save), label: const Text('\u0630\u062e\u06cc\u0631\u0647')),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _sec(String title, IconData icon, List<Widget> children) => Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    elevation: 0,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Icon(icon, size: 18, color: Colors.orange), const SizedBox(width: 8), Text(title, style: const TextStyle(fontWeight: FontWeight.bold))]),
        const Divider(height: 20),
        ...children,
      ]),
    ),
  );

  Widget _field(TextEditingController c, String label, IconData icon) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextField(controller: c, keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon))),
  );
}

// \u062a\u0628 \u062a\u0639\u0637\u06cc\u0644\u0627\u062a
class _HolidayTab extends StatefulWidget {
  @override State<_HolidayTab> createState() => _HolidayTabState();
}
class _HolidayTabState extends State<_HolidayTab> {
  final now = DateTime.now();
  late int _year, _month;
  List<String> _holidays = [];
  bool _loading = true;

  @override void initState() {
    super.initState();
    _year = now.year; _month = now.month;
    _load();
  }

  Future<void> _load() async {
    final h = await HolidayService.getMonthHolidays(_year, _month);
    setState(() { _holidays = List<String>.from(h); _loading = false; });
  }

  String _fmt(DateTime d) => HolidayService.formatDate(d);

  Future<void> _toggleDay(DateTime day) async {
    final key = _fmt(day);
    setState(() {
      if (_holidays.contains(key)) _holidays.remove(key);
      else _holidays.add(key);
    });
    await HolidayService.saveMonthHolidays(_year, _month, _holidays);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final daysInMonth = DateTime(_year, _month + 1, 0).day;
    final workingDays = daysInMonth - _holidays.length;
    if (_loading) return const Center(child: CircularProgressIndicator());
    return Column(
      children: [
        // \u0646\u0627\u0648\u06cc\u06af\u06cc\u0634\u0646 \u0645\u0627\u0647
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: cs.surfaceContainerHighest,
          child: Row(children: [
            IconButton(icon: const Icon(Icons.chevron_right), onPressed: () {
              setState(() { if (_month == 1) { _month = 12; _year--; } else _month--; });
              _load();
            }),
            Expanded(child: Center(child: Text(
              '${_monthName(_month)} $_year',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ))),
            IconButton(icon: const Icon(Icons.chevron_left), onPressed: () {
              setState(() { if (_month == 12) { _month = 1; _year++; } else _month++; });
              _load();
            }),
          ]),
        ),
        // \u062e\u0644\u0627\u0635\u0647
        Container(
          padding: const EdgeInsets.all(12),
          color: cs.primaryContainer,
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _stat('\u06a9\u0644 \u0631\u0648\u0632', '$daysInMonth', cs.primary),
            _stat('\u062a\u0639\u0637\u06cc\u0644', '${_holidays.length}', Colors.red),
            _stat('\u06a9\u0627\u0631\u06cc', '$workingDays', Colors.green),
          ]),
        ),
        // \u0631\u0648\u0632\u0647\u0627
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7, crossAxisSpacing: 4, mainAxisSpacing: 4,
            ),
            itemCount: daysInMonth,
            itemBuilder: (_, i) {
              final day = DateTime(_year, _month, i + 1);
              final key = _fmt(day);
              final isHoliday = _holidays.contains(key);
              return GestureDetector(
                onTap: () => _toggleDay(day),
                child: Container(
                  decoration: BoxDecoration(
                    color: isHoliday ? Colors.red.shade100 : cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: isHoliday ? Colors.red : cs.outline.withOpacity(0.3)),
                  ),
                  child: Center(
                    child: Text('${i + 1}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isHoliday ? Colors.red : null,
                        fontSize: 13,
                      )),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text('\u0628\u0631\u0627\u06cc \u062a\u0639\u0637\u06cc\u0644/\u06a9\u0627\u0631\u06cc \u06a9\u0631\u062f\u0646 \u0631\u0648\u0632 \u0631\u0648\u06cc \u0622\u0646 \u0636\u0631\u0628\u0647 \u0628\u0632\u0646\u06cc\u062f',
            style: TextStyle(color: cs.onSurface.withOpacity(0.5), fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _stat(String label, String val, Color color) => Column(children: [
    Text(val, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: color)),
    Text(label, style: const TextStyle(fontSize: 11)),
  ]);

  String _monthName(int m) {
    const names = ['\u0698\u0627\u0646\u0648\u06cc\u0647','\u0641\u0648\u0631\u06cc\u0647','\u0645\u0627\u0631\u0633','\u0622\u0648\u0631\u06cc\u0644','\u0645\u0647','\u0698\u0648\u0626\u0646','\u0698\u0648\u0626\u06cc\u0647','\u0627\u0648\u062a','\u0633\u067e\u062a\u0627\u0645\u0628\u0631','\u0627\u06a9\u062a\u0628\u0631','\u0646\u0648\u0627\u0645\u0628\u0631','\u062f\u0633\u0627\u0645\u0628\u0631'];
    return names[m - 1];
  }
}
