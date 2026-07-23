import 'api_service.dart';

class ProductionStandardService {
  final _api = ApiService();

  Future<List<dynamic>> getAll() async {
    final data = await _api.getData('/production-standards');
    return data as List<dynamic>;
  }
}
