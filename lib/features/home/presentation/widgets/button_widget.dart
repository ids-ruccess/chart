import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/home_provider.dart';

class ButtonWidget extends ConsumerWidget {
  const ButtonWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      // 버튼을 누르면 전체 홈 페이지 상태가 업데이트됩니다.
      child: ElevatedButton(
        onPressed: () {
          ref.read(homeProvider.notifier).updatePageState();
        },
        child: const Text('state update'),
      ),
    );
  }
}