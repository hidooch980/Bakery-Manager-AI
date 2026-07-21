import 'dart:io';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'local_database_service.dart';

class ExportService {
  static String _csvEscape(Object? value) {
    final text = (value ?? '').toString().replaceAll('"', '""');
    return '"$text"';
  }

  static String _toCsv(List<Map<String, dynamic>> rows) {
    if (rows.isEmpty) return 'empty\n';
    final keys = rows.expand((e) => e.keys).toSet().toList();
    final buffer = StringBuffer();
    buffer.writeln(keys.map(_csvEscape).join(','));
    for (final row in rows) {
      buffer.writeln(keys.map((k) => _csvEscape(row[k])).join(','));
    }
    return buffer.toString();
  }

  static Future<String?> exportAll() async {
    try {
      final dir = await getExternalStorageDirectory();
      if (dir == null) return null;
      final folder = Directory('${dir.path}/BakeryManagerAI');
      if (!await folder.exists()) await folder.create(recursive: true);
      final date = DateTime.now().toIso8601String().replaceAll(':', '-');
      final file = File('${folder.path}/bakery-report-$date.csv');

      final sections = <String>[
        'SALES',
        _toCsv(await LocalDatabaseService.sales()),
        '\nPRODUCTION',
        _toCsv(await LocalDatabaseService.productions()),
        '\nFLOUR',
        _toCsv(await LocalDatabaseService.flourMovements()),
        '\nEXPENSES',
        _toCsv(await LocalDatabaseService.expenses()),
      ];
      await file.writeAsString(sections.join('\n'));
      await OpenFilex.open(file.path);
      return file.path;
    } catch (_) {
      return null;
    }
  }
}
