import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DailyChart extends StatelessWidget {
  final double sales;
  final double production;

  const DailyChart({super.key, required this.sales, required this.production});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 300,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BarChart(
            BarChartData(
              titlesData: FlTitlesData(),
              barGroups: [
                BarChartGroupData(
                  x: 0,
                  barRods: [BarChartRodData(toY: sales, width: 30)],
                ),
                BarChartGroupData(
                  x: 1,
                  barRods: [BarChartRodData(toY: production, width: 30)],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
