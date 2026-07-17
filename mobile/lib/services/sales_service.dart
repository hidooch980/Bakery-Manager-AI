import 'dart:convert';
import 'package:http/http.dart' as http;

class SalesService{

static const baseUrl='http://185.97.118.255:3001';

static Future create({
required double amount,
required String type,
}) async{

final r=await http.post(
Uri.parse('$baseUrl/sales'),
headers:{
'Content-Type':'application/json'
},
body:jsonEncode({
'total':amount,
'type':type
})
);

return jsonDecode(r.body);

}

}
