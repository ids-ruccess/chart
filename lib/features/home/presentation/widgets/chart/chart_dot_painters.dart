import 'dart:ui' as ui;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomDotPainter extends FlDotPainter {
  final ui.Image image;
  final double radius;

  CustomDotPainter({required this.image, this.radius = 14});

  @override
  void paint(Canvas canvas, FlSpot spot, double percent, Color barColor,
      double radius, {required Color strokeColor, required double strokeWidth}) {
    final double size = this.radius * 2;
    final Paint paint = Paint();
    final Rect destRect =
    Rect.fromCenter(center: Offset.zero, width: size, height: size);
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      destRect,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomDotPainter oldDelegate) {
    return oldDelegate.image != image || oldDelegate.radius != radius;
  }

  @override
  void draw(Canvas canvas, FlSpot spot, Offset offsetInCanvas) {
    canvas.save();
    canvas.translate(offsetInCanvas.dx, offsetInCanvas.dy);
    paint(canvas, spot, 0.0, mainColor, radius,
        strokeColor: Colors.white, strokeWidth: 2);
    canvas.restore();
  }

  @override
  FlDotPainter lerp(FlDotPainter a, FlDotPainter b, double t) {
    if (a is CustomDotPainter && b is CustomDotPainter) {
      return CustomDotPainter(
        image: t < 0.5 ? a.image : b.image,
        radius: a.radius + (b.radius - a.radius) * t,
      );
    }
    return this;
  }
  @override
  Size getSize(FlSpot spot) => Size(radius * 2, radius * 2);

  @override
  Color get mainColor => Colors.blue;

  @override
  List<Object?> get props => [image, radius];
}

class EmptyDotPainter extends FlDotPainter {
  @override
  void paint(Canvas canvas, FlSpot spot, double percent, Color barColor,
      double radius, {required Color strokeColor, required double strokeWidth}) {}

  @override
  bool shouldRepaint(covariant EmptyDotPainter oldDelegate) => false;

  @override
  Size getSize(FlSpot spot) => Size.zero;

  @override
  FlDotPainter lerp(FlDotPainter a, FlDotPainter b, double t) => this;

  @override
  Color get mainColor => Colors.transparent;

  @override
  List<Object?> get props => [];

  @override
  void draw(Canvas canvas, FlSpot spot, Offset offsetInCanvas) {}
}