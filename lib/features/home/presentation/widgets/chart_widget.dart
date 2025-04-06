import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/chart_data.dart'; // Provider들이 등록된 파일
import '../providers/chart_provider.dart';

class ChartWidget extends ConsumerWidget {
  const ChartWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncChartData = ref.watch(fetchChartDataProvider);
    return asyncChartData.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) =>
          Center(child: Text('Error: $error')),
      data: (chartData) {
        final spots = chartData.glucoseData.asMap().entries.map(
              (entry) => FlSpot(
            entry.key.toDouble(),
            entry.value.glucose.toDouble(),
          ),
        ).toList();

        return Container(
          height: MediaQuery.of(context).size.height * 0.3,
          padding: const EdgeInsets.all(16),
          child: LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  barWidth: 4,
                  color: Colors.blue,
                  dotData: FlDotData(show: true),
                ),
              ],
              titlesData: FlTitlesData(
                leftTitles:
                AxisTitles(sideTitles: SideTitles(showTitles: true)),
                bottomTitles:
                AxisTitles(sideTitles: SideTitles(showTitles: true)),
              ),
              borderData: FlBorderData(show: true),
            ),
          ),
        );
      },
    );
  }
}