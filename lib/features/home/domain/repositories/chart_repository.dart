import '../entities/chart_data.dart';

abstract class ChartRepository {
  Future<ChartData> getChartData(String date);
}