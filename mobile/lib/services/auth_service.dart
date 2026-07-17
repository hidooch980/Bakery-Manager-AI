import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService{

static const baseUrl='http://185.97.118.255:3001';

static Future login(String phone,String password) async{

final r=await http.post(
Uri.parse('$baseUrl/auth/login'),
headers:{
'Content-Type':'application/json'
},
body:jsonEncode({
'phone':phone,
'password':password
})
);

if(r.statusCode==200){
return jsonDecode(r.body);
}

throw Exception('ورود ناموفق');

}

}
