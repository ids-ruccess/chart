import 'package:chart/core/provider/access_token_provider.dart';
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
                ref.read(accessTokenProvider.notifier).state =
                'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjYwMDAxMzk3LCJ1c2VyTmFtZSI6IuyWkeyEseyjvCIsIm5pY2tOYW1lIjoi7ISx7KO8IHFhIiwidXNlclR5cGUiOiJVIiwibm9kZUVudiI6InFhIiwiaWF0IjoxNzQzNzc0NTg3LCJleHAiOjE3NTIyNTc0NTg3fQ.ue_qRPkun1tnfbsD4WvaUadYmhmjoGXJduNCpw-nIrA';
              },
            ),
          );
        },
      ),
    );
  }
}