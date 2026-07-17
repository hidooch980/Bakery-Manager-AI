import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductionService{

static const baseUrl='http://185.97.118.255:3001';

static Future create({
required int flourBags,
required double flourWeight,
required int doughCount,
required int breadCount,
required String shift,
required double doughWeight,
}) async{

final r=await http.post(
Uri.parse('$baseUrl/production'),
headers:{
'Content-Type':'application/json'
},
body:jsonEncode({
'flourBags':flourBags,
'flourWeight':flourWeight,
'doughCount':doughCount,
'breadCount':breadCount,
'shift':shift,
'doughWeight':doughWeight
})
);

if(r.statusCode==201 || r.statusCode==200){
return jsonDecode(r.body);
}

throw Exception('ثبت تولید ناموفق');

}

}
