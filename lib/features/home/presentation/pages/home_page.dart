import 'package:flutter/material.dart';
import '../providers/chart/chart_provider.dart';
import '../providers/date_provider.dart';
// import '../providers/home_provider.dart';
import '../widgets/chart/chart_widget.dart';
import '../widgets/list_widget.dart';
import '../widgets/button_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 선택된 날짜 구독
    final selectedDate = ref.watch(selectedDateProvider);
    // 선택된 날짜에 따른 차트 데이터 구독
    final asyncChartData = ref.watch(fetchChartDataProvider(selectedDate));
    // 홈의 리스트 상태 구독
    // final homeState = ref.watch(homeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('홈'),
      ),
      body: asyncChartData.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, st) => Center(child: Text('Error: $error')),
        data: (chartData) {
          return Column(
            children: [
              Text('Selected Date: $selectedDate'),
              // ChartWidget은 fetchChartDataProvider 결과(chartData)를 인자로 받습니다.
              const ChartWidget(),
              const SizedBox(height: 16),
              // ListWidget은 homeProvider의 리스트 상태를 표시합니다.
              const ListWidget(),
              // ButtonWidget: 버튼을 누르면 선택된 날짜 및 리스트 상태가 업데이트됩니다.
              const ButtonWidget(),
            ],
          );
        },
      ),
    );
  }
}