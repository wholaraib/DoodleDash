import 'package:flutter/material.dart';
import 'package:doodledash/models/my_custom_painter.dart';
import 'package:doodledash/models/touch_points.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class PaintScreenControl extends StatelessWidget {
  final double width;
  final double height;
  final IO.Socket socket;
  final String roomName;
  final List<TouchPoints?> points;
  final StrokeCap strokeType;
  final Color selectedColor;
  final double strokeWidth;
  final double selectedOpacity;
  final bool canDraw;

  const PaintScreenControl({
    Key? key,
    required this.width,
    required this.height,
    required this.socket,
    required this.roomName,
    required this.points,
    required this.strokeType,
    required this.selectedColor,
    required this.strokeWidth,
    required this.selectedOpacity,
    required this.canDraw,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: GestureDetector(
        onPanUpdate: canDraw
            ? (details) {
                socket.emit('paint', {
                  'details': {
                    'dx': details.localPosition.dx,
                    'dy': details.localPosition.dy,
                  },
                  'roomName': roomName,
                });
              }
            : null,
        onPanStart: canDraw
            ? (details) {
                socket.emit('paint', {
                  'details': {
                    'dx': details.localPosition.dx,
                    'dy': details.localPosition.dy,
                  },
                  'roomName': roomName,
                });
              }
            : null,
        onPanEnd: canDraw
            ? (details) {
                socket.emit('paint', {'details': null, 'roomName': roomName});
              }
            : null,
        child: SizedBox.expand(
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: RepaintBoundary(
              child: CustomPaint(
                size: Size.infinite,
                painter: MyCustomPainter(points: points),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
