
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 선택된 날짜를 전역적으로 관리하는 StateProvider
final selectedDateProvider = StateProvider<String>((ref) => '2025-04-04');