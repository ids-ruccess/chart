// lib/features/home/presentation/widgets/button_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/date_provider.dart';
import '../providers/home_provider.dart';

class ButtonWidget extends ConsumerWidget {
  const ButtonWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          // 예시: 날짜를 '2025-04-03'으로 변경하고, 업데이트

          if(ref.read(selectedDateProvider.notifier).state == '2025-04-03'){
            ref.read(selectedDateProvider.notifier).state = '2025-04-04';
          }else{
            ref.read(selectedDateProvider.notifier).state = '2025-04-03';
          }
          ref.read(homeProvider.notifier).updateListItems(ref.read(homeProvider).count + 1);
        },
        child: const Text('State Update'),
      ),
    );
  }
}