import 'dart:convert';
import 'package:http/http.dart' as http;

class DashboardService{

static const baseUrl='http://185.97.118.255:3001';

static Future weekly() async{

final r=await http.get(
Uri.parse('$baseUrl/dashboard/weekly')
);

if(r.statusCode==200){
return jsonDecode(r.body);
}

throw Exception('خطا در دریافت گزارش هفتگی');

}


static Future daily() async{

final r=await http.get(
Uri.parse('$baseUrl/dashboard/daily')
);

if(r.statusCode==200){
return jsonDecode(r.body);
}

throw Exception('خطا در گزارش روزانه');

}

}
