import 'dart:convert';
import 'package:http/http.dart' as http;
import 'storage_service.dart';

class ApiService{

static const String baseUrl='http://185.97.118.255:3000';


static Future<Map<String,String>> headers() async{

final token=await StorageService.getToken();

return {

'Content-Type':'application/json',

if(token!=null)
'Authorization':'Bearer $token'

};

}


static Future<bool> postData(
String endpoint,
Map<String,dynamic> data
) async{

try{

final response=await http.post(

Uri.parse('$baseUrl/$endpoint'),

headers:await headers(),

body:jsonEncode(data),

);

return response.statusCode>=200 &&
response.statusCode<300;


}catch(e){

return false;

}

}


static Future<dynamic> getData(
String endpoint
) async{

try{

final response=await http.get(

Uri.parse('$baseUrl/$endpoint'),

headers:await headers(),

);

if(response.statusCode==200){

return jsonDecode(response.body);

}

return null;


}catch(e){

return null;

}

}

}
