import 'package:flutter/material.dart';
import '../services/report_service.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  Map data = {};

  @override
  void initState() {
    super.initState();
    load();
  }

  Future load() async {
    final r = await ReportService.daily();

    setState(() {
      data = r;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('گزارش روزانه')),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            Card(
              child: ListTile(
                title: const Text('تولید امروز'),
                subtitle: Text('${data['production'] ?? 0} عدد'),
              ),
            ),

            Card(
              child: ListTile(
                title: const Text('فروش امروز'),
                subtitle: Text('${data['sales'] ?? 0} تومان'),
              ),
            ),

            Card(
              child: ListTile(
                title: const Text('هزینه امروز'),
                subtitle: Text('${data['expenses'] ?? 0} تومان'),
              ),
            ),

            Card(
              child: ListTile(
                title: const Text('سود / زیان'),
                subtitle: Text('${data['profit'] ?? 0} تومان'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
