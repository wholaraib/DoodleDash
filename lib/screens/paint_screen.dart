import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/room_data.dart';

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
  Map<String, dynamic>? dataOfRoom;

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
        print("ROOM DATA RECEIVED");
        print(roomData);
        setState(() {
          dataOfRoom = Map<String, dynamic>.from(roomData);
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

    _socket.onDisconnect((_) {
      print('Disconnected from server');
    });

    _socket.connect(); // connect LAST, after listeners are registered
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        
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
