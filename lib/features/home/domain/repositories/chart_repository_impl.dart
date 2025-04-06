import '../../data/datasources/chart_remote_datasource.dart';
import '../../domain/entities/chart_data.dart';
import '../../domain/repositories/chart_repository.dart';

// 데이터: chart_repository_impl.dart
class ChartRepositoryImpl implements ChartRepository {
  final ChartRemoteDataSource remoteDataSource;
  ChartRepositoryImpl(this.remoteDataSource);

  @override
  Future<ChartData> getChartData(String date) async {
    return await remoteDataSource.fetchChartData(date);
  }
}