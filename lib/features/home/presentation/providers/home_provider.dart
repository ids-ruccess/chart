// lib/features/home/presentation/providers/home_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 홈 화면의 리스트 상태를 담는 클래스
class HomeState {
  final List<String> listItems;
  final int count;

  HomeState({
    required this.listItems,
    required this.count,
  });

  HomeState copyWith({List<String>? listItems, int? count}) {
    return HomeState(
      listItems: listItems ?? this.listItems,
      count: count ?? this.count,
    );
  }
}

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(HomeState(listItems: _generateListItems(), count: 0));

  static List<String> _generateListItems() {
    return List.generate(5, (index) => 'Item ${index + 1}');
  }

  /// 리스트 상태를 업데이트합니다.
  void updateListItems(int newCount) {
    final updatedList =
    _generateListItems().map((item) => '$item $newCount').toList();
    state = state.copyWith(listItems: updatedList, count: newCount);
  }
}

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier();
});