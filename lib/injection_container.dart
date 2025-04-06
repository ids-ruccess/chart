import 'package:get_it/get_it.dart';
import 'core/api/dio_client.dart';
import 'features/home/data/datasources/chart_remote_datasource.dart';
import 'features/home/domain/repositories/chart_repository_impl.dart';
import 'features/home/domain/usecases/fetch_chart_data.dart';

final getIt = GetIt.instance;

Future<void> setupInjection() async {
  // DioClient 등록
  getIt.registerLazySingleton<DioClient>(
        () => DioClient(
      'https://api-qa.welda.co.kr',
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjYwMDAxMzk3LCJ1c2VyTmFtZSI6IuyWkeyEseyjvCIsIm5pY2tOYW1lIjoi7ISx7KO8IHFhIiwidXNlclR5cGUiOiJVIiwibm9kZUVudiI6InFhIiwiaWF0IjoxNzQzNzc0NTg3LCJleHAiOjE3NTIyNTc0NTg3fQ.ue_qRPkun1tnfbsD4WvaUadYmhmjoGXJduNCpw-nIrA',
    ),
  );

  // 차트 Remote DataSource 등록 (DioClient 사용)
  getIt.registerLazySingleton<ChartRemoteDataSource>(
        () => ChartRemoteDataSource(getIt<DioClient>()),
  );

  // 차트 Repository 등록
  getIt.registerLazySingleton<ChartRepositoryImpl>(
        () => ChartRepositoryImpl(getIt<ChartRemoteDataSource>()),
  );

  // FetchChartData UseCase 등록
  getIt.registerLazySingleton<FetchChartData>(
        () => FetchChartData(getIt<ChartRepositoryImpl>()),
  );
}