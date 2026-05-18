import 'dart:async';

import 'package:doodledash/models/touch_points.dart';
import 'package:doodledash/widgets/paint_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'waiting_lobby_screen.dart';
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
  List<TouchPoints?> points = [];
  StrokeCap strokeType = StrokeCap.round;
  Color selectedColor = Colors.black;
  double strokeWidth = 2.0;
  Opacity selectedOpacity = Opacity(opacity: 1.0);
  List<Widget> textBlankWidget = [];
  final ScrollController _scrollController = ScrollController();
  final List<Map> messages = [];
  final TextEditingController textController = TextEditingController();
  int guessedUserCounter = 0;
  int _start = 60;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    connect();
  }

  void renderTextBlank(String text) {
    textBlankWidget.clear();
    for (int i = 0; i < text.length; i++) {
      textBlankWidget.add(
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text('_', style: TextStyle(fontSize: 30)),
        ),
      );
    }
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer time) {
      if (_start == 0) {
        _socket.emit('change-turn', {'roomName': widget.roomData.roomName});
        setState(() {
          time.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
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
          print(roomData['word']);
          renderTextBlank(roomData['word']);
          roomState = Map<String, dynamic>.from(roomData);
        });
        if (roomData['isJoin'] != true) {
          startTimer();
        }
      });

      if (widget.screenType == ScreenType.create) {
        _socket.emit('create-game', widget.roomData.toMap());
      } else if (widget.screenType == ScreenType.join) {
        _socket.emit('join-game', widget.roomData.toMap());
      }
    });

    _socket.on('points', (point) {
      if (point['details'] == null) {
        setState(() {
          points.add(null);
        });
      } else {
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
      print('Color changed received: $colorData');
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

    _socket.on('new-message', (messageData) {
      setState(() {
        messages.add(Map<String, dynamic>.from(messageData));
        guessedUserCounter = messageData['guessedUserCounter'];
      });
      if (guessedUserCounter == roomState?['players']?.length - 1) {
        _socket.emit('change-turn', {'roomName': widget.roomData.roomName});
      }
      // Auto-scroll to bottom after new message
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          // Add a small delay on web to ensure rendering is complete
          Future.delayed(const Duration(milliseconds: 50), () {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          });
        }
      });
    });

    _socket.on("change-turn", (roomData) {
      String oldWord = roomState?['word'];
      showDialog(
        context: context,
        builder: (context) {
          Future.delayed(const Duration(seconds: 3), () {
            setState(() {
              roomState = Map<String, dynamic>.from(roomData);
              renderTextBlank(roomState?['word']);
              guessedUserCounter = 0;
              points.clear();
              _start = 60;
            });
            Navigator.of(context).pop();
            _timer.cancel();
            startTimer();
          });
          return AlertDialog(title: Center(child: Text('Word was $oldWord')));
        },
      );
    });

    _socket.onDisconnect((_) {
      print('Disconnected from server');
    });

    _socket.connect();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    // Determine if it's the user's turn to draw
    final playerName = widget.roomData.toMap()['playerName'];
    final isDrawingPlayer =
        roomState != null && roomState?['turn']?['name'] == playerName;

    void selectColor() {
      if (isDrawingPlayer) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Select Color'),
            content: SingleChildScrollView(
              child: BlockPicker(
                pickerColor: selectedColor,
                onColorChanged: (color) {
                  print('Selected color: $color');
                  final String valueString = color.value.toRadixString(16);
                  print('color value string $valueString');
                  final Map<String, dynamic> map = {
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
                child: const Text(
                  'Close',
                  style: TextStyle(color: Color(0xFF1565C0)),
                ),
              ),
            ],
          ),
        );
      }
    }

    // Check if enough players have joined
    final bool canStart = roomState != null && roomState?['isJoin'] != true;
    final int playersLeft = roomState != null && roomState?['players'] != null
      ? (roomState?['roomSize']) - ((roomState?['players'] as List).length)
      : 0;
    final String roomCode = widget.roomData.roomName;
      final List<String> joinedPlayers = roomState != null && roomState?['players'] != null
        ? List<String>.from(roomState?['players'].map((p) => p['name'] ?? '').where((n) => n != null && n != ''))
        : [];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: !canStart
          ? WaitingLobbyScreen(
              roomCode: roomCode,
              playersLeft: playersLeft,
                players: joinedPlayers,
            )
          : SafeArea(
              child: Column(
                children: [
                  Expanded(
                    flex: 6,
                    child: PaintScreenControl(
                      width: width,
                      height: height,
                      socket: _socket,
                      roomName: widget.roomData.roomName,
                      points: points,
                      strokeType: strokeType,
                      selectedColor: selectedColor,
                      strokeWidth: strokeWidth,
                      selectedOpacity: selectedOpacity.opacity,
                      canDraw: isDrawingPlayer,
                    ),
                  ),
                  PaintControls(
                    selectedColor: selectedColor,
                    strokeWidth: strokeWidth,
                    onSelectColor: selectColor,
                    canDraw: isDrawingPlayer,
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
                  isDrawingPlayer
                      ? Container(
                          margin: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            (roomState?['word'])?.toUpperCase() ?? '',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF1565C0),
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: textBlankWidget,
                          ),
                        ),
                  Expanded(
                    flex: 3,
                    child: PaintChat(
                      scrollController: _scrollController,
                      messages: messages,
                    ),
                  ),
                  if (!isDrawingPlayer)
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      child: TextField(
                        controller: textController,
                        onSubmitted: (value) {
                          final messageText = value.trim();
                          if (messageText.isEmpty) return;
                          final roomWord = roomState?['word']?.toString();

                          final Map<String, dynamic> map = {
                            'username': playerName,
                            'message': messageText,
                            'word': roomWord,
                            'roomName': widget.roomData.roomName,
                            'guessedUserCounter': guessedUserCounter,
                            'totalTime': 60,
                            'timeTaken': 60 - _start,
                          };

                          _socket.emit('send-message', map);
                          textController.clear();

                          if (_scrollController.hasClients) {
                            _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent + 60,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          }
                        },
                        autocorrect: false,
                        decoration: InputDecoration(
                          hintText: 'Your guess',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[400],
                            fontWeight: FontWeight.w400,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(
                              color: Color(0xFF1565C0),
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        textInputAction: TextInputAction.done,
                      ),
                    )
                  else
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      child: Text(
                        "You are drawing! Wait for others to guess.",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                ],
              ),
            ),
      floatingActionButton: canStart
          ? Container(
              margin: const EdgeInsets.only(bottom: 60),
              child: FloatingActionButton(
                onPressed: () {},
                elevation: 7,
                backgroundColor: Colors.white,
                child: Text(
                  '$_start',
                  style: TextStyle(color: Colors.black, fontSize: 22),
                ),
              ),
            )
          : null,
    );
  }

  @override
  void dispose() {
    textController.dispose();
    _scrollController.dispose();
    _socket.dispose();
    super.dispose();
  }
}

class ScreenType {
  static const String create = 'create';
  static const String join = 'join';
}
