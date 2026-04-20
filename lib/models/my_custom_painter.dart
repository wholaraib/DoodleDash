import 'package:doodledash/models/touch_points.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class MyCustomPainter extends CustomPainter {
  MyCustomPainter({required this.points});

  final List<TouchPoints?> points;
  final List<Offset> offsetPoints = [];

  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()..color = Colors.white;
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, background);
    canvas.clipRect(rect);

    for (int i = 0; i < points.length - 1; i++) {
      final currentPoint = points[i];
      final nextPoint = points[i + 1];

      if (currentPoint != null && nextPoint != null) {
        canvas.drawLine(
          currentPoint.points,
          nextPoint.points,
          currentPoint.paint,
        );
      } else if (currentPoint != null && nextPoint == null) {
        offsetPoints
          ..clear()
          ..add(currentPoint.points);

        canvas.drawPoints(
          ui.PointMode.points,
          offsetPoints,
          currentPoint.paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant MyCustomPainter oldDelegate) => true;
}
