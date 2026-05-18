import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WaitingLobbyScreen extends StatelessWidget {
  final String roomCode;
  final int playersLeft;
  final List<String>? players;

  const WaitingLobbyScreen({
    Key? key,
    required this.roomCode,
    required this.playersLeft,
    required this.players,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.hourglass_empty,
            size: 64,
            color: Color(0xFF1565C0),
          ),
          SizedBox(height: 24),
          // Show joined player names if available
          if (players != null && players!.isNotEmpty) ...[
            Text(
              'Players Joined:',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF1565C0),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Container(
              constraints: BoxConstraints(maxHeight: 120, minWidth: 120),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Color(0xFFF1F8FF),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Color(0xFFB3E5FC)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: players!.map((name) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Row(
                      children: [
                        Icon(Icons.person, size: 16, color: Color(0xFF1565C0)),
                        SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            name,
                            style: TextStyle(fontSize: 15, color: Color(0xFF1565C0)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  )).toList(),
                ),
              ),
            ),
            SizedBox(height: 18),
          ],
          // Room code display and copy
          Builder(
            builder: (context) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      await Clipboard.setData(ClipboardData(text: roomCode));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Room code copied to clipboard!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Room Code: ',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF1565C0),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            roomCode,
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF0D47A1),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.copy, size: 18, color: Color(0xFF1565C0)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Tap the code to copy',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 24),
          SafeArea(
            child: Text(
              'Waiting for $playersLeft more ${playersLeft > 1 ? 'players' : 'player'} to join...\nThe game will start soon!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: const Color.fromARGB(255, 93, 154, 185),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 32),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Color(0xFF1565C0),
            ),
          ),
        ],
      ),
    );
  }
}
