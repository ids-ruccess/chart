// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'injection_container.dart';
import 'app.dart';

void main() async {
  await setupInjection();
  runApp(ProviderScope(child: MyApp()));
}