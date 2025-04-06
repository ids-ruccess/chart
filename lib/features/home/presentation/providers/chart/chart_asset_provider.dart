import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart' as svg;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dotImageProvider = FutureProvider<ui.Image>((ref) async {
  final String svgString = await rootBundle.loadString('assets/chart_meal_symbol.svg');
  final svg.DrawableRoot svgRoot =
  await svg.svg.fromSvgString(svgString, 'assets/chart_meal_symbol.svg');
  final ui.Picture picture = svgRoot.toPicture(size: const Size(25, 25));
  final ui.Image image = await picture.toImage(25, 25);
  return image;
});