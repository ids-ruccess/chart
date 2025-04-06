// lib/features/home/presentation/providers/chart_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/chart_data.dart';
import '../../domain/repositories/chart_repository_impl.dart';
import '../../domain/usecases/fetch_chart_data.dart';

// 차트 레파지토리 프로바이더
final chartRepositoryProvider = Provider<ChartRepositoryImpl>((ref) {
  return getIt<ChartRepositoryImpl>();
});

// 차트 데이터 프로바이더
final fetchChartDataProvider = FutureProvider<ChartData>((ref) async {
  final repository = ref.watch(chartRepositoryProvider);
  final fetchChartData = FetchChartData(repository);
  return await fetchChartData();
});

