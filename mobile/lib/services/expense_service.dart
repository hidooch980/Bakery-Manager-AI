import 'dart:convert';
import 'package:http/http.dart' as http;

class ExpenseService{

static const baseUrl='http://185.97.118.255:3001';

static Future create({
required String title,
required double amount,
String? category,
String? note,
}) async{

final r=await http.post(
Uri.parse('$baseUrl/expenses'),
headers:{
'Content-Type':'application/json'
},
body:jsonEncode({
'title':title,
'amount':amount,
'category':category,
'note':note
})
);

if(r.statusCode==201 || r.statusCode==200){
return jsonDecode(r.body);
}

throw Exception('ثبت هزینه ناموفق');

}

}
