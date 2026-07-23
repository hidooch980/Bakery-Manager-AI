import 'package:flutter/material.dart';
import '../services/dashboard_service.dart';
import 'daily_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  Map<String,dynamic> data = {};
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    final result = await DashboardService.dashboard();

    if (!mounted) return;

    setState(() {
      data = result;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('داشبورد مدیریت نانوایی'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: (){
              setState(() {
                loading = true;
              });
              loadDashboard();
            },
          )
        ],
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  const Text(
                    'خلاصه امروز',
                    style: TextStyle(
                      fontSize:24,
                      fontWeight:FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height:20),

                  DailyChart(
                    sales: double.tryParse('${data['sales'] ?? 0}') ?? 0,
                    production: double.tryParse('${data['production'] ?? 0}') ?? 0,
                  ),

                  const SizedBox(height:20),

                  Expanded(
                    child: GridView.count(
                      crossAxisCount:2,
                      crossAxisSpacing:12,
                      mainAxisSpacing:12,

                      children:[

                        _card(
                          'فروش امروز',
                          data['sales'],
                          Icons.point_of_sale,
                        ),

                        _card(
                          'تولید نان',
                          data['production'],
                          Icons.bakery_dining,
                        ),

                        _card(
                          'موجودی آرد',
                          data['flour'],
                          Icons.inventory,
                        ),

                        _card(
                          'صندوق',
                          data['cash'],
                          Icons.account_balance_wallet,
                        ),

                        _card(
                          'هزینه‌ها',
                          data['expenses'],
                          Icons.money_off,
                        ),

                        _card(
                          'سود امروز',
                          data['profit'],
                          Icons.trending_up,
                        ),

                      ],
                    ),
                  )

                ],
              ),
            ),
    );
  }


  Widget _card(String title,dynamic value,IconData icon){

    return Card(
      elevation:4,

      child: Column(
        mainAxisAlignment:MainAxisAlignment.center,

        children:[

          Icon(
            icon,
            size:40,
          ),

          const SizedBox(height:10),

          Text(
            title,
            style:const TextStyle(
              fontSize:17,
              fontWeight:FontWeight.bold,
            ),
          ),

          const SizedBox(height:8),

          Text(
            '${value ?? 0}',
            style:const TextStyle(
              fontSize:24,
            ),
          ),

        ],
      ),
    );
  }
}
