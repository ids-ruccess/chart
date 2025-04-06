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

// 차트 데이터 프로바이더: date를 인자로 받도록 FutureProvider.family 사용
final fetchChartDataProvider = FutureProvider.family<ChartData, String>((ref, date) async {
  final fetchChartData = getIt<FetchChartData>(); // 인자 없이 DI된 인스턴스 가져오기
  return await fetchChartData(date); // 가져온 인스턴스를 호출할 때 인자(date) 전달
});