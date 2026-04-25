import 'package:flutter/material.dart';
import 'package:doodledash/models/my_custom_painter.dart';
import 'package:doodledash/models/touch_points.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class PaintScreenControl extends StatelessWidget {
  final double width;
  final double height;
  final IO.Socket socket;
  final String roomName;
  final List<TouchPoints> points;
  final StrokeCap strokeType;
  final Color selectedColor;
  final double strokeWidth;
  final double selectedOpacity;

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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height * 0.55,
      child: GestureDetector(
        onPanUpdate: (details) {
          socket.emit('paint', {
            'details': {
              'dx': details.localPosition.dx,
              'dy': details.localPosition.dy,
            },
            'roomName': roomName,
          });
        },
        onPanStart: (details) {
          socket.emit('paint', {
            'details': {
              'dx': details.localPosition.dx,
              'dy': details.localPosition.dy,
            },
            'roomName': roomName,
          });
        },
        onPanEnd: (details) {
          socket.emit('paint', {'details': null, 'roomName': roomName});
        },
        child: SizedBox.expand(
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20)),
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
