// lib/features/home/presentation/providers/chart_provider.dart
import 'package:chart/features/home/domain/repositories/chart_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/chart_data.dart';
import '../../domain/usecases/fetch_chart_data.dart';

// 차트 레파지토리 프로바이더
final chartRepositoryProvider = Provider<ChartRepository>((ref) {
  return getIt<ChartRepository>();
});

// 차트 데이터 프로바이더
final fetchChartDataProvider = FutureProvider<ChartData>((ref) async {
  final fetchChartData = getIt<FetchChartData>(); // DI된 인스턴스를 사용
  return await fetchChartData();
});

