import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 전역적으로 관리하는 accessToken. 로그인 시 업데이트됨.
final accessTokenProvider = StateProvider<String?>((ref) => null);
