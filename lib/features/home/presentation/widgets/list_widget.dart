import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/home_provider.dart';

class ListWidget extends ConsumerWidget {
  const ListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listItems = ref.watch(homeProvider).listItems;

    return Expanded(
      child: ListView.builder(
        itemCount: listItems.length,
        itemBuilder: (context, index) {
          final item = listItems[index];
          return ListTile(
            title: Text(item),
            // 오른쪽 버튼: 눌렀을 때 차트 데이터를 새로고침
            trailing: IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
              },
            ),
          );
        },
      ),
    );
  }
}