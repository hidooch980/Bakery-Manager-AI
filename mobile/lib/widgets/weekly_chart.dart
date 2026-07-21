import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class WeeklyChart extends StatelessWidget {
  final List data;

  const WeeklyChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,

      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                data.length,
                (i) => FlSpot(i.toDouble(), (data[i]['sales'] ?? 0).toDouble()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
