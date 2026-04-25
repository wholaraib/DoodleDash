import 'package:doodledash/models/touch_points.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/room_data.dart';
import '../widgets/paint_controls.dart';
import '../widgets/paint_screen_control.dart';

class PaintScreen extends StatefulWidget {
  const PaintScreen({
    super.key,
    required this.screenType,
    required this.roomData,
  });

  final String screenType;
  final RoomData roomData;

  @override
  State<PaintScreen> createState() => _PaintScreenState();
}

class _PaintScreenState extends State<PaintScreen> {
  late IO.Socket _socket;
  Map<String, dynamic>? roomState;
  List<TouchPoints> points = [];
  StrokeCap strokeType = StrokeCap.round;
  Color selectedColor = Colors.black;
  double strokeWidth = 2.0;
  Opacity selectedOpacity = Opacity(opacity: 1.0);
  // double opacity = 1;

  @override
  void initState() {
    super.initState();
    connect();
  }

  static const String _serverUrl = 'http://localhost:3000';

  // Socket.io client connection
  void connect() {
    _socket = IO.io(_serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket.onConnect((_) {
      print('Connected to socket server');

      _socket.on('room-updated', (roomData) {
        setState(() {
          roomState = Map<String, dynamic>.from(roomData);
        });
        if (roomData['isJoin'] != true) {
          // start the timer
        }
      });

      if (widget.screenType == ScreenType.create) {
        _socket.emit('create-game', widget.roomData.toMap());
      } else if (widget.screenType == ScreenType.join) {
        _socket.emit('join-game', widget.roomData.toMap());
      }
    });

    _socket.on('points', (point) {
      if (point['details'] != null) {
        setState(() {
          points.add(
            TouchPoints(
              points: Offset(
                (point['details']['dx']).toDouble(),
                (point['details']['dy']).toDouble(),
              ),
              paint: Paint()
                ..strokeCap = strokeType
                ..isAntiAlias = true
                ..color = selectedColor.withAlpha(
                  (selectedOpacity.opacity * 255).toInt(),
                )
                ..strokeWidth = strokeWidth,
            ),
          );
        });
      }
    });

    _socket.on('color-changed', (colorData) {
      print("Color changed received: $colorData");
      setState(() {
        selectedColor = Color(int.parse(colorData['color'], radix: 16));
      });
    });

    _socket.on('canvas-cleared', (_) {
      setState(() {
        points.clear();
      });
    });

    _socket.on('stroke-width-changed', (data) {
      setState(() {
        strokeWidth = data['strokeWidth'].toDouble();
      });
    });

    _socket.onDisconnect((_) {
      print('Disconnected from server');
    });

    _socket.connect(); // connect LAST, after listeners are registered
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    void selectColor() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Select Color"),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) {
                print("Selected color: $color");
                String valueString = color.value.toRadixString(16);
                print("color value string $valueString");
                Map map = {
                  'color': valueString,
                  'roomName': widget.roomData.roomName,
                };
                _socket.emit('color-change', map);
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Close", style: TextStyle(color: Color(0xFF1565C0))),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              PaintScreenControl(
                width: width,
                height: height,
                socket: _socket,
                roomName: widget.roomData.roomName,
                points: points,
                strokeType: strokeType,
                selectedColor: selectedColor,
                strokeWidth: strokeWidth,
                selectedOpacity: selectedOpacity.opacity,
              ),
              PaintControls(
                selectedColor: selectedColor,
                strokeWidth: strokeWidth,
                onSelectColor: selectColor,
                onStrokeWidthChanged: (double value) {
                  setState(() {
                    strokeWidth = value;
                  });
                  _socket.emit('stroke-width-change', {
                    'strokeWidth': value,
                    'roomName': widget.roomData.roomName,
                  });
                },
                onClear: () {
                  setState(() {
                    points.clear();
                  });
                  _socket.emit('clear-canvas', {
                    'roomName': widget.roomData.roomName,
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _socket.dispose();
    super.dispose();
  }
}

class ScreenType {
  static const String create = "create";
  static const String join = "join";
}
