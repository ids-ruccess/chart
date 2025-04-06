import '../../data/datasources/chart_remote_datasource.dart';
import '../../domain/entities/chart_data.dart';
import '../../domain/repositories/chart_repository.dart';

class ChartRepositoryImpl implements ChartRepository {
  final ChartRemoteDataSource remoteDataSource;
  ChartRepositoryImpl(this.remoteDataSource);

  @override
  Future<ChartData> getChartData() async {
    return await remoteDataSource.fetchChartData();
  }
}