// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'injection_container.dart';
import 'app.dart';

void main() async {
  // riverpod 주입
  final container = ProviderContainer();
  await setupInjection(container);

  runApp(ProviderScope(child: MyApp()));
}