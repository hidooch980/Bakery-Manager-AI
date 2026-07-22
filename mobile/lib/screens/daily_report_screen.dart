import 'package:flutter/material.dart';
import '../services/dashboard_service.dart';

class DailyReportScreen extends StatefulWidget {
  const DailyReportScreen({super.key});

  @override
  State<DailyReportScreen> createState() => _DailyReportScreenState();
}

class _DailyReportScreenState extends State<DailyReportScreen> {
  dynamic data;

  @override
  void initState() {
    super.initState();

    load();
  }

  void load() async {
    final result = await DashboardService.daily();

    setState(() {
      data = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('گزارش روزانه مدیر')),

      body: data == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                children: [
                  Card(
                    child: ListTile(
                      title: const Text('فروش امروز'),
                      trailing: Text('${data['sales'] ?? 0}'),
                    ),
                  ),

                  Card(
                    child: ListTile(
                      title: const Text('تولید امروز'),
                      trailing: Text('${data['production'] ?? 0}'),
                    ),
                  ),

                  Card(
                    child: ListTile(
                      title: const Text('هزینه امروز'),
                      trailing: Text('${data['expenses'] ?? 0}'),
                    ),
                  ),

                  Card(
                    child: ListTile(
                      title: const Text('سود تقریبی'),
                      trailing: Text('${data['profit'] ?? 0}'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
