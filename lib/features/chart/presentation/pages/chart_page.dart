import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartPage extends StatelessWidget {
  const ChartPage({super.key});

  // 예시 데이터
  List<FlSpot> get _spots => [
    const FlSpot(0, 1),
    const FlSpot(1, 1.5),
    const FlSpot(2, 1.4),
    const FlSpot(3, 3.4),
    const FlSpot(4, 2),
    const FlSpot(5, 2.2),
    const FlSpot(6, 1.8),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('차트'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: _spots,
                isCurved: true,
                barWidth: 4,
                // colors: [Colors.blue],
                dotData: FlDotData(show: true),
              ),
            ],
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true),
              ),
            ),
            borderData: FlBorderData(show: true),
          ),
        ),
      ),
    );
  }
}