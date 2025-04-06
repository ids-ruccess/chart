import 'package:flutter/material.dart';
import '../widgets/chart_widget.dart';
import '../widgets/list_widget.dart';
import '../widgets/button_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('홈'),
      ),
      body: Column(
        children: const [
          ChartWidget(),

          SizedBox(height: 16),
          // 리스트 위젯: 차트 아래, 남은 영역을 채움
          ListWidget(),
          // 버튼 위젯: 하단에 위치하여 전체 상태 업데이트
          ButtonWidget(),
        ],
      ),
    );
  }
}