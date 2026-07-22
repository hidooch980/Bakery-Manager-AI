import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductionStandardService {
  static const baseUrl = "http://185.97.118.255:3000";

  static Future<Map<String, dynamic>> getStandard() async {
    final r = await http.get(Uri.parse("$baseUrl/production-standards"));
    return jsonDecode(r.body);
  }

  static Future<void> updateStandard(Map<String, dynamic> data) async {
    await http.patch(
      Uri.parse("$baseUrl/production-standards/1"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
  }
}
