import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 홈 화면의 전체 상태를 담는 클래스
class HomeState {
  final List<double> chartData;
  final List<String> listItems;

  HomeState({
    required this.chartData,
    required this.listItems,
  });

  HomeState copyWith({
    List<double>? chartData,
    List<String>? listItems,
  }) {
    return HomeState(
      chartData: chartData ?? this.chartData,
      listItems: listItems ?? this.listItems,
    );
  }
}

/// HomeNotifier는 HomeState를 관리하며, 차트 새로고침과 전체 업데이트 기능을 제공합니다.
class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier()
      : super(HomeState(
    chartData: _generateChartData(),
    listItems: _generateListItems(),
  ));

  // 예시로 랜덤한 차트 데이터를 생성합니다.
  static List<double> _generateChartData() {
    return List.generate(7, (_) => (Random().nextDouble() * 4) + 1);
  }

  // 예시로 리스트 항목을 생성합니다.
  static List<String> _generateListItems() {
    return List.generate(5, (index) => 'Item ${index + 1}');
  }

  /// 차트 데이터만 새로고침합니다.
  void refreshChart() {
    state = state.copyWith(chartData: _generateChartData());
  }

  /// 전체 페이지의 상태를 업데이트합니다.
  void updatePageState() {
    // 예시: 차트와 리스트 모두 새로운 데이터를 생성합니다.
    state = HomeState(
      chartData: _generateChartData(),
      listItems: _generateListItems().map((item) => '$item updated').toList(),
    );
  }
}

/// 홈 전용 Provider – HomeNotifier 를 전역적으로 공유합니다.
final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier();
});