import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'local_database_service.dart';

/// Offline-first business features for Bakery Manager AI 2.0.
class AdvancedFeaturesService {
  static const _customers='bm2_customers', _debts='bm2_debts', _payments='bm2_payments';
  static const _shifts='bm2_shifts', _branches='bm2_branches', _goals='bm2_goals';
  static const _security='bm2_security', _notifications='bm2_notifications';
  static String _id()=>DateTime.now().microsecondsSinceEpoch.toString();
  static String _now()=>DateTime.now().toIso8601String();

  static Future<List<Map<String,dynamic>>> _list(String key) async {
    final p=await SharedPreferences.getInstance(); final raw=p.getString(key);
    if(raw==null||raw.isEmpty)return [];
    final v=jsonDecode(raw); if(v is! List)return [];
    return v.whereType<Map>().map((e)=>Map<String,dynamic>.from(e)).toList();
  }
  static Future<void> _save(String key,List<Map<String,dynamic>> value) async {
    final p=await SharedPreferences.getInstance(); await p.setString(key,jsonEncode(value));
  }

  static Future<List<Map<String,dynamic>>> customers()=>_list(_customers);
  static Future<List<Map<String,dynamic>>> debts()=>_list(_debts);
  static Future<List<Map<String,dynamic>>> payments()=>_list(_payments);
  static Future<List<Map<String,dynamic>>> shifts()=>_list(_shifts);
  static Future<List<Map<String,dynamic>>> branches()=>_list(_branches);
  static Future<List<Map<String,dynamic>>> goals()=>_list(_goals);
  static Future<List<Map<String,dynamic>>> notifications()=>_list(_notifications);

  static Future<void> addCustomer(String name,String phone,int creditLimit) async {
    final a=await customers(); a.insert(0,{'id':_id(),'name':name,'phone':phone,'creditLimit':creditLimit,'createdAt':_now()}); await _save(_customers,a);
  }
  static Future<void> addDebt(String customerId,String customerName,int amount,String note) async {
    final a=await debts(); a.insert(0,{'id':_id(),'customerId':customerId,'customerName':customerName,'amount':amount,'remaining':amount,'note':note,'createdAt':_now()}); await _save(_debts,a);
    await addNotification('نسیه جدید','برای $customerName مبلغ $amount ثبت شد');
  }
  static Future<void> payDebt(String debtId,int amount) async {
    final a=await debts(); final i=a.indexWhere((x)=>x['id']==debtId); if(i<0)return;
    final before=(a[i]['remaining'] as num? ?? 0).toInt(); final paid=amount>before?before:amount;
    a[i]['remaining']=before-paid; await _save(_debts,a);
    final p=await payments(); p.insert(0,{'id':_id(),'debtId':debtId,'customerName':a[i]['customerName'],'amount':paid,'createdAt':_now()}); await _save(_payments,p);
  }
  static Future<int> totalReceivables() async => (await debts()).fold<int>(0,(s,e)=>s+(e['remaining'] as num? ?? 0).toInt());

  static Future<void> addShift(String employee,double hours,int rate,int bonus) async {
    final a=await shifts(); a.insert(0,{'id':_id(),'employee':employee,'hours':hours,'rate':rate,'bonus':bonus,'pay':(hours*rate).round()+bonus,'createdAt':_now()}); await _save(_shifts,a);
  }
  static Future<int> payrollTotal() async => (await shifts()).fold<int>(0,(s,e)=>s+(e['pay'] as num? ?? 0).toInt());

  static Future<void> addBranch(String name,String address,String manager) async {
    final a=await branches(); a.insert(0,{'id':_id(),'name':name,'address':address,'manager':manager,'active':true,'createdAt':_now()}); await _save(_branches,a);
  }
  static Future<void> addGoal(String title,int target) async {
    final a=await goals(); a.insert(0,{'id':_id(),'title':title,'target':target,'createdAt':_now()}); await _save(_goals,a);
  }
  static Future<double> goalProgress(Map<String,dynamic> goal) async {
    final d=await LocalDatabaseService.dashboard(); final target=(goal['target'] as num? ?? 1).toDouble(); return ((d['sales'] as num? ?? 0)/target).clamp(0,1).toDouble();
  }

  static Future<List<String>> smartAnomalies() async {
    final sales=await LocalDatabaseService.sales(); final prod=await LocalDatabaseService.productions(); final out=<String>[];
    if(sales.length>=3){final vals=sales.take(20).map((e)=>(e['total'] as num? ?? 0).toDouble()).toList(); final avg=vals.reduce((a,b)=>a+b)/vals.length; for(final e in sales.take(5)){final v=(e['total'] as num? ?? 0).toDouble(); if(avg>0&&(v>avg*2.5||v<avg*.2))out.add('فروش غیرعادی توسط ${e['seller']}: ${e['total']}');}}
    for(final e in prod.take(10)){final b=(e['bread'] as num? ?? 0).toDouble(), w=(e['waste'] as num? ?? 0).toDouble(); if(b>0&&w/b>.05)out.add('ضایعات غیرعادی شیفت ${e['shift']}: ${e['waste']}');}
    if(out.isEmpty)out.add('ناهنجاری مهمی در داده‌های اخیر شناسایی نشد.'); return out;
  }

  static Future<int> seasonalForecast() async {
    final sales=await LocalDatabaseService.sales(); if(sales.isEmpty)return 0;
    final byDay=<int,List<int>>{}; for(final e in sales){final d=DateTime.tryParse('${e['createdAt']}'); if(d!=null)byDay.putIfAbsent(d.weekday,()=>[]).add((e['quantity'] as num? ?? 0).toInt());}
    final tomorrow=DateTime.now().add(const Duration(days:1)).weekday; final same=byDay[tomorrow]??sales.take(14).map((e)=>(e['quantity'] as num? ?? 0).toInt()).toList();
    if(same.isEmpty)return 0; var base=same.reduce((a,b)=>a+b)/same.length; if(tomorrow==4||tomorrow==5)base*=1.12; return base.round();
  }

  static Future<String> askManager(String q) async {
    final d=await LocalDatabaseService.dashboard(); final text=q.trim();
    if(text.contains('سود'))return 'سود خالص امروز ${d['profit']} تومان است.';
    if(text.contains('فروش'))return 'فروش امروز ${d['sales']} تومان در ${d['salesCount']} ثبت است.';
    if(text.contains('آرد'))return 'موجودی آرد ${d['flourStock']} کیسه است.';
    if(text.contains('هزینه'))return 'هزینه امروز ${d['expenses']} تومان است.';
    if(text.contains('تولید')||text.contains('فردا'))return 'تولید ثبت‌شده ${d['production']} عدد و پیشنهاد فردا ${await seasonalForecast()} عدد است.';
    return 'می‌توانید درباره فروش، سود، هزینه، آرد یا تولید فردا سؤال کنید.';
  }

  static Future<void> addNotification(String title,String body) async {final a=await notifications();a.insert(0,{'id':_id(),'title':title,'body':body,'read':false,'createdAt':_now()});await _save(_notifications,a);}
  static Future<void> saveSecurity({String? pin,bool? biometric}) async {final p=await SharedPreferences.getInstance();final old=jsonDecode(p.getString(_security)??'{}') as Map;final v=Map<String,dynamic>.from(old);if(pin!=null)v['pin']=pin;if(biometric!=null)v['biometric']=biometric;await p.setString(_security,jsonEncode(v));}
  static Future<Map<String,dynamic>> security() async {final p=await SharedPreferences.getInstance();return Map<String,dynamic>.from(jsonDecode(p.getString(_security)??'{}'));}

  static Future<String> createBackup() async {
    final data={'version':2,'createdAt':_now(),'core':await LocalDatabaseService.exportSnapshot(),'customers':await customers(),'debts':await debts(),'payments':await payments(),'shifts':await shifts(),'branches':await branches(),'goals':await goals()};
    final dir=await getApplicationDocumentsDirectory();final f=File('${dir.path}/bakery_backup_${DateTime.now().millisecondsSinceEpoch}.json');await f.writeAsString(const JsonEncoder.withIndent('  ').convert(data));return f.path;
  }
  static Future<void> restoreBackup(String json) async {
    final d=jsonDecode(json) as Map<String,dynamic>;if(d['core'] is Map)await LocalDatabaseService.restoreSnapshot(Map<String,dynamic>.from(d['core']));
    for(final pair in [(_customers,'customers'),(_debts,'debts'),(_payments,'payments'),(_shifts,'shifts'),(_branches,'branches'),(_goals,'goals')]){final v=d[pair.$2];if(v is List)await _save(pair.$1,v.whereType<Map>().map((e)=>Map<String,dynamic>.from(e)).toList());}
  }

  static Future<void> mergeBackup(String json) async {
    final d=jsonDecode(json) as Map<String,dynamic>;
    final core=d['core'] is Map?Map<String,dynamic>.from(d['core'] as Map):d;
    await LocalDatabaseService.mergeSnapshot(core);
  }

  static Future<String> receiptText(Map<String,dynamic> sale) async {final s=await LocalDatabaseService.appSettings();return '${s['bakeryName']??'نانوایی'}\nرسید فروش\nنوع نان: ${sale['breadType']}\nتعداد: ${sale['quantity']}\nمبلغ: ${sale['total']} تومان\nتاریخ: ${sale['createdAt']}';}
}
