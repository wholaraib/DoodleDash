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
    final themeBlue = const Color(0xFF1565C0);
    final themeLightBlue = const Color(0xFFE3F2FD);
    final themeGold = const Color(0xFFFFC107);
    final themeSilver = const Color(0xFFB0BEC5);
    final themeBronze = const Color(0xFF8D6E63);
    final themeGrey = const Color(0xFFF5F6FA);

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF5E92F3), Color(0xFFF5F6FA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Card(
          elevation: 12,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          color: Colors.white.withOpacity(0.97),
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [themeBlue, themeLightBlue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: themeBlue.withOpacity(0.18),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(18),
                  child: const Icon(
                    Icons.hourglass_top,
                    size: 54,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Waiting Lobby',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: themeBlue,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 18),
                // Show joined player avatars if available
                if (players != null && players!.isNotEmpty) ...[
                  Text(
                    'Players Joined',
                    style: TextStyle(
                      fontSize: 16,
                      color: themeBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 80, minWidth: 120),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: players!.map((name) {
                          final color = name.hashCode % 3 == 0
                              ? themeGold
                              : name.hashCode % 3 == 1
                                  ? themeSilver
                                  : themeBronze;
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundColor: color.withOpacity(0.18),
                                  child: Icon(Icons.person, color: color, size: 28),
                                ),
                                const SizedBox(height: 4),
                                SizedBox(
                                  width: 60,
                                  child: Text(
                                    name,
                                    style: TextStyle(fontSize: 13, color: themeBlue, fontWeight: FontWeight.w500),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
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
                              const SnackBar(
                                content: Text('Room code copied to clipboard!'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                            decoration: BoxDecoration(
                              color: themeLightBlue,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: themeBlue.withOpacity(0.18)),
                              boxShadow: [
                                BoxShadow(
                                  color: themeBlue.withOpacity(0.07),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.vpn_key, size: 20, color: Color(0xFF1565C0)),
                                const SizedBox(width: 8),
                                Text(
                                  roomCode,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Color(0xFF0D47A1),
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(Icons.copy, size: 18, color: themeBlue),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tap the code to copy',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
                SafeArea(
                  child: Text(
                    'Waiting for $playersLeft more ${playersLeft > 1 ? 'players' : 'player'} to join...\nThe game will start soon!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF5E92F3),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(themeBlue),
                  strokeWidth: 4.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
