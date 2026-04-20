import 'package:flutter/material.dart';

class TouchPoints {
  Paint paint;
  Offset points;
  TouchPoints({required this.points, required this.paint});

  Map <String,dynamic> toMap() {
    return {
      'points': {'dx': '${points.dx}', 'dy': '${points.dy}'},
    };
  }
}