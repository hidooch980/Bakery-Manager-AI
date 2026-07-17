import 'package:shared_preferences/shared_preferences.dart';

class UserService{

static Future saveLogin(dynamic result) async{

final p=await SharedPreferences.getInstance();

await p.setString(
'token',
result['access_token']
);

await p.setString(
'role',
result['user']['role']
);

await p.setString(
'name',
result['user']['name']
);

}


static Future<String?> role() async{

final p=await SharedPreferences.getInstance();

return p.getString('role');

}


static Future logout() async{

final p=await SharedPreferences.getInstance();

await p.clear();

}

}
