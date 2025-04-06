import '../entities/chart_data.dart';
import '../repositories/chart_repository.dart';

// 비동기 작업을 수행하는 넘
class FetchChartData {
  final ChartRepository repository;
  FetchChartData(this.repository); // 이걸 인자로 받아서

  Future<ChartData> call() async {
    return await repository.getChartData(); // 이걸 해야함
  }
}