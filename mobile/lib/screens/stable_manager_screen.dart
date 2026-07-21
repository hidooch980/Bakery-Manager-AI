import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/local_database_service.dart';
import '../services/export_service.dart';
import '../services/storage_service.dart';
import 'login_screen.dart';
import '../services/bale_sync_service.dart';
import 'advanced_features_screen.dart';

class StableManagerScreen extends StatefulWidget {
  const StableManagerScreen({super.key});

  @override
  State<StableManagerScreen> createState() => _StableManagerScreenState();
}

class _StableManagerScreenState extends State<StableManagerScreen> {
  int index = 0;

  final pages = const [
    _DashboardTab(),
    _SalesTab(),
    _ProductionTab(),
    _FlourTab(),
    _ExpenseTab(),
    _ReportsTab(),
    _AiTab(),
    AdvancedFeaturesScreen(),
    _SettingsTab(),
  ];

  @override
  void initState() {
    super.initState();
    LocalDatabaseService.ensureDefaults();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: pages[index],
        bottomNavigationBar: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (v) => setState(() => index = v),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.dashboard), label: 'داشبورد'),
            NavigationDestination(icon: Icon(Icons.point_of_sale), label: 'فروش'),
            NavigationDestination(icon: Icon(Icons.bakery_dining), label: 'تولید'),
            NavigationDestination(icon: Icon(Icons.inventory), label: 'آرد'),
            NavigationDestination(icon: Icon(Icons.money_off), label: 'هزینه'),
            NavigationDestination(icon: Icon(Icons.assessment), label: 'گزارش'),
            NavigationDestination(icon: Icon(Icons.auto_awesome), label: 'AI'),
            NavigationDestination(icon: Icon(Icons.workspace_premium), label: 'ویژه'),
            NavigationDestination(icon: Icon(Icons.settings), label: 'تنظیمات'),
          ],
        ),
      ),
    );
  }
}

class _AppScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget>? actions;
  const _AppScaffold({required this.title, required this.child, this.actions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), actions: actions),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: child,
      ),
    );
  }
}

class _DashboardTab extends StatefulWidget {
  const _DashboardTab();
  @override
  State<_DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<_DashboardTab> {
  late Future<Map<String, dynamic>> future;
  @override
  void initState() {
    super.initState();
    future = LocalDatabaseService.dashboard();
  }

  @override
  Widget build(BuildContext context) {
    return _AppScaffold(
      title: 'داشبورد پایدار',
      actions: [IconButton(onPressed: () => setState(() => future = LocalDatabaseService.dashboard()), icon: const Icon(Icons.refresh))],
      child: FutureBuilder<Map<String, dynamic>>(
        future: future,
        builder: (context, snapshot) {
          final d = snapshot.data ?? {};
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _metric('فروش امروز', d['sales'], Icons.point_of_sale, Colors.green),
                  _metric('تولید نان', d['production'], Icons.bakery_dining, Colors.orange),
                  _metric('موجودی آرد', '${d['flourStock']} کیسه', Icons.inventory, Colors.blue),
                  _metric('هزینه‌ها', d['expenses'], Icons.money_off, Colors.red),
                  _metric('سود خالص', d['profit'], Icons.trending_up, Colors.purple),
                  _metric('در صف همگام‌سازی', d['syncQueue'], Icons.sync, Colors.teal),
                ],
              ),
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.account_circle),
                  title: Text('کاربر: ${AuthService.name()}'),
                  subtitle: Text('نقش: ${AuthService.role()}'),
                ),
              ),
              if ((d['flourStock'] as num) <= (d['minFlourBags'] as num))
                const Card(
                  color: Color(0xfffff3cd),
                  child: ListTile(
                    leading: Icon(Icons.warning, color: Colors.orange),
                    title: Text('هشدار کمبود آرد'),
                    subtitle: Text('موجودی آرد به حداقل تعیین‌شده رسیده است.'),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _metric(String title, dynamic value, IconData icon, Color color) {
    return SizedBox(
      width: 165,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('${value ?? 0}', style: const TextStyle(fontSize: 20)),
          ]),
        ),
      ),
    );
  }
}

class _SalesTab extends StatefulWidget { const _SalesTab(); @override State<_SalesTab> createState() => _SalesTabState(); }
class _SalesTabState extends State<_SalesTab> {
  // 0=خرده‌فروشی  1=فروش به مدرسه
  int _mode = 0;
  final breadType = TextEditingController(text: 'سنتی');
  final quantity = TextEditingController();
  final cash = TextEditingController();
  final card = TextEditingController();
  final debt = TextEditingController();
  final seller = TextEditingController(text: AuthService.name());
  final note = TextEditingController();
  // فیلدهای اختصاصی فروش مدرسه
  final schoolName = TextEditingController();
  final schoolContact = TextEditingController();
  final schoolAddress = TextEditingController();
  final schoolQty = TextEditingController();
  final schoolPrice = TextEditingController();
  final schoolPaid = TextEditingController();

  Future<void> _saveRetail() async {
    await LocalDatabaseService.addSale(
      breadType: breadType.text.trim().isEmpty ? 'سنتی' : breadType.text.trim(),
      quantity: int.tryParse(quantity.text) ?? 0,
      cash: int.tryParse(cash.text) ?? 0,
      card: int.tryParse(card.text) ?? 0,
      debt: int.tryParse(debt.text) ?? 0,
      seller: seller.text.trim(),
      note: note.text.trim(),
    );
    if (!mounted) return;
    quantity.clear(); cash.clear(); card.clear(); debt.clear(); note.clear();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('فروش ثبت شد')));
    setState(() {});
  }

  Future<void> _saveSchool() async {
    final qty = int.tryParse(schoolQty.text) ?? 0;
    final price = int.tryParse(schoolPrice.text) ?? 0;
    final paid = int.tryParse(schoolPaid.text) ?? 0;
    final total = qty * price;
    final remaining = total - paid;
    await LocalDatabaseService.addSale(
      breadType: 'مدرسه - ${breadType.text.trim().isEmpty ? "سنتی" : breadType.text.trim()}',
      quantity: qty,
      cash: paid,
      card: 0,
      debt: remaining < 0 ? 0 : remaining,
      seller: seller.text.trim(),
      note: 'مدرسه: ${schoolName.text.trim()} | تماس: ${schoolContact.text.trim()} | آدرس: ${schoolAddress.text.trim()}',
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('فروش به ${schoolName.text.trim()} ثبت شد | مانده: $remaining تومان'),
    ));
    schoolQty.clear(); schoolPrice.clear(); schoolPaid.clear();
    setState(() {});
  }

  @override Widget build(BuildContext context) {
    return _AppScaffold(
      title: 'ثبت فروش کامل',
      child: ListView(padding: const EdgeInsets.all(16), children: [
        // سوئیچ حالت فروش
        Card(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: const Text('خرده‌فروشی'),
                  selected: _mode == 0,
                  avatar: const Icon(Icons.storefront, size: 18),
                  onSelected: (_) => setState(() => _mode = 0),
                ),
                const SizedBox(width: 12),
                ChoiceChip(
                  label: const Text('فروش به مدرسه'),
                  selected: _mode == 1,
                  avatar: const Icon(Icons.school, size: 18),
                  onSelected: (_) => setState(() => _mode = 1),
                ),
                const SizedBox(width: 12),
                ChoiceChip(
                  label: const Text('تسویه مدارس'),
                  selected: _mode == 2,
                  avatar: const Icon(Icons.account_balance_wallet, size: 18),
                  onSelected: (_) => setState(() => _mode = 2),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (_mode == 0) ...[
          _field(breadType, 'نوع نان'),
          _field(quantity, 'تعداد نان', number: true),
          _field(cash, 'مبلغ نقدی', number: true),
          _field(card, 'مبلغ کارت‌خوان', number: true),
          _field(debt, 'نسیه', number: true),
          _field(seller, 'نام فروشنده'),
          _field(note, 'توضیحات'),
          const SizedBox(height: 12),
          ElevatedButton.icon(onPressed: _saveRetail, icon: const Icon(Icons.save), label: const Text('ثبت فروش')),
        ] else ...[
          // فروش به مدرسه
          Card(
            color: const Color(0xffe3f2fd),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(children: [
                const ListTile(
                  leading: Icon(Icons.school, color: Colors.blue),
                  title: Text('فروش به مدرسه'),
                  subtitle: Text('مبلغ کل = تعداد × قیمت واحد | مانده به‌صورت نسیه ثبت می‌شود'),
                  contentPadding: EdgeInsets.zero,
                ),
              ]),
            ),
          ),
          _field(schoolName, 'نام مدرسه'),
          _field(schoolContact, 'شماره تماس مسئول'),
          _field(schoolAddress, 'آدرس مدرسه'),
          _field(breadType, 'نوع نان'),
          _field(schoolQty, 'تعداد نان', number: true),
          _field(schoolPrice, 'قیمت واحد (تومان)', number: true),
          _field(schoolPaid, 'مبلغ پرداخت‌شده (تومان)', number: true),
          _field(seller, 'نام فروشنده'),
          // نمایش خلاصه محاسبه
          ValueListenableBuilder(
            valueListenable: schoolQty,
            builder: (_, __, ___) => ValueListenableBuilder(
              valueListenable: schoolPrice,
              builder: (_, __, ___) => ValueListenableBuilder(
                valueListenable: schoolPaid,
                builder: (_, __, ___) {
                  final qty = int.tryParse(schoolQty.text) ?? 0;
                  final price = int.tryParse(schoolPrice.text) ?? 0;
                  final paid = int.tryParse(schoolPaid.text) ?? 0;
                  final total = qty * price;
                  final remaining = total - paid;
                  if (qty == 0 && price == 0) return const SizedBox();
                  return Card(
                    color: remaining > 0 ? const Color(0xfffff3cd) : const Color(0xffd4edda),
                    child: Padding(padding: const EdgeInsets.all(12), child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('جمع کل: $total تومان', style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('پرداخت‌شده: $paid تومان'),
                        Text(remaining > 0 ? 'مانده نسیه: $remaining تومان' : 'تسویه کامل ✅',
                          style: TextStyle(color: remaining > 0 ? Colors.orange : Colors.green, fontWeight: FontWeight.bold)),
                      ],
                    )),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _saveSchool,
            icon: const Icon(Icons.school),
            label: const Text('ثبت فروش به مدرسه'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
          ),
        ],
        if (_mode == 2) ...[
          _SchoolSettlementWidget(onSettled: () => setState(() {})),
        ] else ...[
        const Divider(),
        const Text('آخرین فروش‌ها', style: TextStyle(fontWeight: FontWeight.bold)),
        FutureBuilder(future: LocalDatabaseService.sales(), builder: (context, snapshot) {
          final rows = snapshot.data ?? [];
          return Column(children: rows.take(12).map((e) {
            final isSchool = '${e['breadType']}'.startsWith('مدرسه');
            return Card(
              color: isSchool ? const Color(0xffe3f2fd) : null,
              child: ListTile(
                leading: Icon(isSchool ? Icons.school : Icons.storefront, color: isSchool ? Colors.blue : Colors.orange),
                title: Text('${e['breadType']} - ${e['quantity']} عدد'),
                subtitle: Text('کل: ${e['total']} | نقد: ${e['cash']} | کارت: ${e['card']} | نسیه: ${e['debt']}'),
              ),
            );
          }).toList());
        }),
        ],
      ]),
    );
  }
}

// ───────────────────────────── تسویه مدارس ─────────────────────────────
class _SchoolSettlementWidget extends StatefulWidget {
  final VoidCallback onSettled;
  const _SchoolSettlementWidget({required this.onSettled});
  @override State<_SchoolSettlementWidget> createState() => _SchoolSettlementWidgetState();
}
class _SchoolSettlementWidgetState extends State<_SchoolSettlementWidget> {
  final _payCtrl = TextEditingController();

  /// فروش‌های مدرسه‌ای که بدهی دارند
  Future<List<Map<String, dynamic>>> _schoolDebts() async {
    final all = await LocalDatabaseService.sales();
    return all
        .where((e) =>
            '${e['breadType']}'.startsWith('مدرسه') &&
            (e['debt'] as num? ?? 0) > 0)
        .toList();
  }

  /// ثبت پرداخت جزئی یا کامل برای یک ردیف فروش
  Future<void> _settle(Map<String, dynamic> sale, int amount) async {
    final debt = (sale['debt'] as num? ?? 0).toInt();
    final pay = amount > debt ? debt : amount;
    final remaining = debt - pay;
    // به‌روزرسانی رکورد فروش اصلی
    final all = await LocalDatabaseService.sales();
    final idx = all.indexWhere((e) => e['id'] == sale['id']);
    if (idx >= 0) {
      all[idx]['debt'] = remaining;
      all[idx]['cash'] = (all[idx]['cash'] as num? ?? 0).toInt() + pay;
      all[idx]['total'] = (all[idx]['cash'] as num).toInt() +
          (all[idx]['card'] as num? ?? 0).toInt();
      await LocalDatabaseService.saveSales(all);
    }
    // ارسال به بله
    await BaleSyncService.trySend('school_settle', {
      'school': sale['note'],
      'breadType': sale['breadType'],
      'paid': pay,
      'remaining': remaining,
      'createdAt': DateTime.now().toIso8601String(),
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(remaining == 0
            ? 'تسویه کامل شد ✅'
            : '$pay تومان دریافت شد | مانده: $remaining تومان'),
      ));
      widget.onSettled();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _schoolDebts(),
      builder: (context, snapshot) {
        final debts = snapshot.data ?? [];
        final totalDebt = debts.fold<int>(0, (s, e) => s + (e['debt'] as num? ?? 0).toInt());
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Card(
              color: totalDebt > 0 ? const Color(0xfffff3cd) : const Color(0xffd4edda),
              child: ListTile(
                leading: Icon(
                  totalDebt > 0 ? Icons.warning_amber : Icons.check_circle,
                  color: totalDebt > 0 ? Colors.orange : Colors.green,
                ),
                title: const Text('جمع کل بدهی مدارس'),
                trailing: Text(
                  '$totalDebt تومان',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: totalDebt > 0 ? Colors.orange.shade800 : Colors.green,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            if (debts.isEmpty)
              const Card(
                child: ListTile(
                  leading: Icon(Icons.school, color: Colors.green),
                  title: Text('هیچ بدهی معوق وجود ندارد ✅'),
                  subtitle: Text('تمام مدارس تسویه هستند'),
                ),
              )
            else
              ...debts.map((sale) {
                final debt = (sale['debt'] as num? ?? 0).toInt();
                final total = (sale['total'] as num? ?? 0).toInt();
                // نام مدرسه را از فیلد note بخوان
                final noteStr = '${sale['note'] ?? ''}';
                final schoolLine = noteStr.split('|').firstWhere(
                    (p) => p.trim().startsWith('مدرسه:'),
                    orElse: () => 'مدرسه: نامشناخته');
                final schoolName = schoolLine.replaceFirst('مدرسه:', '').trim();
                final contactLine = noteStr.split('|').firstWhere(
                    (p) => p.trim().startsWith('تماس:'),
                    orElse: () => '');
                final contact = contactLine.replaceFirst('تماس:', '').trim();
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.school, color: Colors.blue, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                schoolName,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                        if (contact.isNotEmpty) Text('تماس: $contact', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 4),
                        Row(children: [
                          Expanded(child: Text('تعداد: ${sale['quantity']} عدد | جمع کل: $total تومان')),
                        ]),
                        const SizedBox(height: 2),
                        Text('بدهی باقی‌مانده: $debt تومان',
                          style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                        Text('تاریخ: ${(sale['createdAt'] ?? '').toString().substring(0, 10)}',
                          style: const TextStyle(fontSize: 11, color: Colors.grey)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _payCtrl,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'مبلغ دریافتی',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () async {
                                final amt = int.tryParse(_payCtrl.text) ?? 0;
                                if (amt <= 0) return;
                                await _settle(sale, amt);
                                _payCtrl.clear();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('ثبت‌پرداخت'),
                            ),
                            const SizedBox(width: 6),
                            OutlinedButton(
                              onPressed: () => _settle(sale, debt),
                              style: OutlinedButton.styleFrom(foregroundColor: Colors.green),
                              child: const Text('تسویه کامل'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
          ],
        );
      },
    );
  }
}

class _ProductionTab extends StatefulWidget { const _ProductionTab(); @override State<_ProductionTab> createState() => _ProductionTabState(); }
class _ProductionTabState extends State<_ProductionTab> {
  final shift = TextEditingController(text: 'صبح'); final bags = TextEditingController(); final kg = TextEditingController(); final dough = TextEditingController(); final pieces = TextEditingController(); final bread = TextEditingController(); final waste = TextEditingController(); final worker = TextEditingController(text: AuthService.name()); final note = TextEditingController();
  Future<void> save() async { await LocalDatabaseService.addProduction(shift: shift.text, flourBags: int.tryParse(bags.text) ?? 0, flourKg: double.tryParse(kg.text) ?? ((int.tryParse(bags.text) ?? 0) * 40), dough: int.tryParse(dough.text) ?? 0, pieces: int.tryParse(pieces.text) ?? 0, bread: int.tryParse(bread.text) ?? 0, waste: int.tryParse(waste.text) ?? 0, worker: worker.text, note: note.text); if (!mounted) return; bags.clear(); kg.clear(); dough.clear(); pieces.clear(); bread.clear(); waste.clear(); note.clear(); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تولید ثبت شد و آرد مصرفی از انبار کم شد'))); setState(() {}); }
  @override Widget build(BuildContext context) => _AppScaffold(title: 'ثبت تولید کامل', child: ListView(padding: const EdgeInsets.all(16), children: [_field(shift,'شیفت'), _field(bags,'تعداد کیسه آرد', number:true), _field(kg,'وزن آرد م��رفی کیلوگرم', number:true), _field(dough,'تعداد خمیر', number:true), _field(pieces,'تعداد چانه', number:true), _field(bread,'تعداد نان تولیدی', number:true), _field(waste,'ضایعات', number:true), _field(worker,'مسئول تولید'), _field(note,'توضیحات'), const SizedBox(height:12), ElevatedButton.icon(onPressed: save, icon: const Icon(Icons.save), label: const Text('ثبت تولید')), const Divider(), FutureBuilder(future: LocalDatabaseService.productions(), builder:(context,snapshot){ final rows=snapshot.data??[]; return Column(children: rows.take(10).map((e)=>Card(child:ListTile(title:Text('شیفت ${e['shift']} - ${e['bread']} نان'), subtitle: Text('آرد: ${e['flourBags']} کیسه | ضایعات: ${e['waste']} | بازده: ${((e['efficiency'] as num?) ?? 0).toStringAsFixed(2)}')))).toList());})]));
}

class _FlourTab extends StatefulWidget { const _FlourTab(); @override State<_FlourTab> createState() => _FlourTabState(); }
class _FlourTabState extends State<_FlourTab> { final type = TextEditingController(text:'خرید'); final inBags=TextEditingController(); final outBags=TextEditingController(); final weight=TextEditingController(text:'40'); final note=TextEditingController(); Future<void> save() async { await LocalDatabaseService.addFlourMovement(type: type.text, bagsIn: double.tryParse(inBags.text)??0, bagsOut: double.tryParse(outBags.text)??0, bagWeight: double.tryParse(weight.text)??40, note: note.text); if(!mounted)return; inBags.clear(); outBags.clear(); note.clear(); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('گردش آرد ثبت شد'))); setState((){});} @override Widget build(BuildContext context)=>_AppScaffold(title:'کنترل آرد و انبار', child: ListView(padding: const EdgeInsets.all(16), children:[FutureBuilder(future: LocalDatabaseService.flourStockBags(), builder:(c,s)=>Card(child:ListTile(leading: const Icon(Icons.inventory), title: Text('موجودی فعلی: ${s.data?.toStringAsFixed(1) ?? '0'} کیسه')))), _field(type,'نوع عملیات'), _field(inBags,'ورودی کیسه', number:true), _field(outBags,'خروجی کیسه', number:true), _field(weight,'وزن هر کیسه', number:true), _field(note,'توضیحات'), ElevatedButton.icon(onPressed: save, icon: const Icon(Icons.save), label: const Text('ثبت گردش آرد')), const Divider(), FutureBuilder(future: LocalDatabaseService.flourMovements(), builder:(context,snapshot){ final rows=snapshot.data??[]; return Column(children: rows.take(12).map((e)=>Card(child:ListTile(title:Text('${e['type']} | موجودی بعد: ${e['stockAfter']}'), subtitle:Text('ورودی ${e['bagsIn']} / خروجی ${e['bagsOut']} کیسه')))).toList());})])); }

class _ExpenseTab extends StatefulWidget { const _ExpenseTab(); @override State<_ExpenseTab> createState()=>_ExpenseTabState(); }
class _ExpenseTabState extends State<_ExpenseTab> { final title=TextEditingController(); final amount=TextEditingController(); final category=TextEditingController(text:'عمومی'); final note=TextEditingController(); Future<void> save() async { await LocalDatabaseService.addExpense(title: title.text, amount: int.tryParse(amount.text)??0, category: category.text, note: note.text); if(!mounted)return; title.clear(); amount.clear(); note.clear(); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('هزینه ثبت شد'))); setState((){});} @override Widget build(BuildContext context)=>_AppScaffold(title:'ثبت هزینه‌ها', child: ListView(padding: const EdgeInsets.all(16), children:[_field(title,'عنوان هزینه'), _field(amount,'مبلغ', number:true), _field(category,'دسته‌بندی'), _field(note,'توضیحات'), ElevatedButton.icon(onPressed: save, icon: const Icon(Icons.save), label: const Text('ثبت هزینه')), const Divider(), FutureBuilder(future: LocalDatabaseService.expenses(), builder:(context,snapshot){ final rows=snapshot.data??[]; return Column(children: rows.take(12).map((e)=>Card(child:ListTile(title:Text('${e['title']} - ${e['amount']}'), subtitle:Text('${e['category']} | ${e['note']}')))).toList());})])); }

class _ReportsTab extends StatefulWidget { const _ReportsTab(); @override State<_ReportsTab> createState()=>_ReportsTabState(); }
class _ReportsTabState extends State<_ReportsTab> { @override Widget build(BuildContext context)=>_AppScaffold(title:'گزارش و خروجی', actions:[IconButton(onPressed:() async { final path=await ExportService.exportAll(); if(context.mounted){ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(path==null?'خروجی ناموفق بود':'فایل گزارش ساخته شد')));}}, icon: const Icon(Icons.file_download))], child: FutureBuilder(future: LocalDatabaseService.dashboard(), builder:(context,snapshot){ final d=snapshot.data??{}; return ListView(padding: const EdgeInsets.all(16), children:[_report('فروش کل امروز', d['sales']), _report('نقد', d['cash']), _report('کارت‌خوان', d['card']), _report('نسیه', d['debt']), _report('تولید', d['production']), _report('ضایعات', d['waste']), _report('هزینه‌ها', d['expenses']), _report('سود خالص', d['profit']), _report('موجودی آرد', '${d['flourStock']} کیسه'), const SizedBox(height:12), ElevatedButton.icon(onPressed:() async { final path=await ExportService.exportAll(); if(context.mounted){ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(path==null?'خروجی ناموفق بود':'خروجی CSV آماده شد')));}}, icon: const Icon(Icons.table_chart), label: const Text('خروجی CSV برای حسابداری'))]);})); Widget _report(String t,dynamic v)=>Card(child:ListTile(title:Text(t), trailing:Text('${v??0}', style: const TextStyle(fontWeight: FontWeight.bold)))); }

class _AiTab extends StatelessWidget { const _AiTab(); @override Widget build(BuildContext context)=>_AppScaffold(title:'دستیار هوشمند AI', child: FutureBuilder<List<Object>>(future: Future.wait<Object>([LocalDatabaseService.aiRecommendations(), LocalDatabaseService.forecastTomorrowBread()]), builder:(context,snapshot){ if(!snapshot.hasData)return const Center(child:CircularProgressIndicator()); final recs = (snapshot.data![0] as List).cast<String>(); final forecast = snapshot.data![1]; return ListView(padding: const EdgeInsets.all(16), children:[Card(color: const Color(0xffe8f4ff), child:ListTile(leading: const Icon(Icons.auto_awesome), title: const Text('پیش‌بینی تولید فردا'), subtitle: Text(forecast==0?'داده کافی برای پیش‌بینی وجود ندارد':'پیشنهاد تولید: حدود $forecast عدد نان'))), const SizedBox(height:8), const Text('هشدارها و پیشنهادها', style: TextStyle(fontWeight: FontWeight.bold, fontSize:18)), ...recs.map((r)=>Card(child:ListTile(leading: const Icon(Icons.tips_and_updates), title: Text(r))))]);})); }

class _SettingsTab extends StatefulWidget { const _SettingsTab(); @override State<_SettingsTab> createState()=>_SettingsTabState(); }
class _SettingsTabState extends State<_SettingsTab> { final bakery=TextEditingController(); final bread=TextEditingController(); final price=TextEditingController(); final bag=TextEditingController(); final min=TextEditingController(); final capacity=TextEditingController(); @override void initState(){ super.initState(); _load(); } Future<void> _load() async { final s=await LocalDatabaseService.appSettings(); bakery.text='${s['bakeryName']??'نانوایی من'}'; bread.text='${s['breadType']??'سنتی'}'; price.text='${s['breadPrice']??5000}'; bag.text='${s['bagWeight']??40}'; min.text='${s['minFlourBags']??5}'; capacity.text='${s['dailyCapacity']??3000}'; if(mounted)setState((){});} Future<void> save() async { await LocalDatabaseService.saveSettings({'bakeryName':bakery.text,'breadType':bread.text,'breadPrice':int.tryParse(price.text)??5000,'bagWeight':double.tryParse(bag.text)??40,'minFlourBags':double.tryParse(min.text)??5,'dailyCapacity':int.tryParse(capacity.text)??3000,'standardDoughWeight':0.85}); if(!mounted)return; ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تنظیمات ذخیره شد')));} Future<void> logout(BuildContext context) async { await StorageService.clear(); if(!context.mounted)return; Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder:(_)=>const LoginScreen()), (r)=>false);} @override Widget build(BuildContext context)=>_AppScaffold(title:'تنظیمات و مدیریت', child: ListView(padding: const EdgeInsets.all(16), children:[_field(bakery,'نام نانوایی'), _field(bread,'نوع نان پیش‌فرض'), _field(price,'قیمت هر نان', number:true), _field(bag,'وزن هر کیسه آرد', number:true), _field(min,'حداقل موجودی آرد', number:true), _field(capacity,'ظرفیت تولید روزانه', number:true), ElevatedButton.icon(onPressed: save, icon: const Icon(Icons.save), label: const Text('ذخیره تنظیمات')), const Divider(), ListTile(leading: const Icon(Icons.people), title: const Text('کاربر پیش‌فرض آفلاین'), subtitle: const Text('09000000000 / Admin@123')), ListTile(leading: const Icon(Icons.delete_forever, color: Colors.red), title: const Text('پاک کردن داده‌های عملیاتی'), onTap:() async { await LocalDatabaseService.clearDemoData(); if(context.mounted){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('داده‌ها پاک شد')));} }), ListTile(leading: const Icon(Icons.logout), title: const Text('خروج'), onTap:()=>logout(context))])); }

Widget _field(TextEditingController c, String label, {bool number=false}) => Padding(padding: const EdgeInsets.only(bottom: 10), child: TextField(controller: c, keyboardType: number ? TextInputType.number : TextInputType.text, decoration: InputDecoration(labelText: label, border: const OutlineInputBorder())));
