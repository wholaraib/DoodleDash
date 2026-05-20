import 'package:flutter/material.dart';
import 'dart:math';

class DoodleChampionsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> players;
  const DoodleChampionsScreen({Key? key, required this.players}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final winner = players.isNotEmpty ? players[0] : null;
    final second = players.length > 1 ? players[1] : null;
    final third = players.length > 2 ? players[2] : null;
    final others = players.length > 3 ? players.sublist(3) : [];
    final themeBlue = const Color(0xFF1565C0);
    final themeGold = const Color(0xFFFFC107);
    final themeSilver = const Color(0xFFB0BEC5);
    final themeBronze = const Color(0xFF8D6E63);
    final bgGrey = const Color(0xFFF5F6FA);

    return Scaffold(
      backgroundColor: bgGrey,
      body: Stack(
        children: [
          // Gradient background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFF5F6FA), Color(0xFFE3E9F6)],
                ),
              ),
            ),
          ),
          // Doodle decorations (low opacity)
          ..._buildDoodleDecorations(),
          // Main content
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    children: [
                      const SizedBox(height: 12),
                      // AppBar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1565C0)),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            const Expanded(
                              child: Text(
                                'Doodle Champions',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Color(0xFF1565C0),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            SizedBox(width: 48),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Center(
                        child: Text(
                          'Game Over • Great Match!',
                          style: TextStyle(
                            color: Color(0xFF90A4AE),
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      // Winner celebration
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: themeGold.withOpacity(0.25),
                                blurRadius: 32,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.emoji_events, size: 70, color: Color(0xFFFFC107)),
                        ),
                      ),
                      const SizedBox(height: 18),
                      // Main leaderboard card
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.07),
                                blurRadius: 18,
                                offset: const Offset(0, 8),
                              ),
                            ],
                            gradient: const LinearGradient(
                              colors: [Colors.white, Color(0xFFF5F6FA)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                            child: Column(
                              children: [
                                const Text(
                                  '🏆 Winners',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Color(0xFF1565C0),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                if (winner != null)
                                  _WinnerRow(player: winner, themeBlue: themeBlue, themeGold: themeGold),
                                if (second != null)
                                  _PlayerRow(
                                    player: second,
                                    rank: 2,
                                    color: themeSilver,
                                    medalIcon: Icons.emoji_events,
                                    isMedal: true,
                                  ),
                                if (third != null)
                                  _PlayerRow(
                                    player: third,
                                    rank: 3,
                                    color: themeBronze,
                                    medalIcon: Icons.emoji_events,
                                    isMedal: true,
                                  ),
                                ...others.asMap().entries.map((entry) {
                                  final idx = entry.key;
                                  final player = entry.value;
                                  return _PlayerRow(
                                    player: player,
                                    rank: idx + 4,
                                    color: Colors.grey[200]!,
                                    isMedal: false,
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24, left: 32, right: 32, top: 0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 6,
                        textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      icon: const Icon(Icons.home_rounded, size: 24),
                      label: const Text('Back to Home'),
                      onPressed: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDoodleDecorations() {
    return [
      Positioned(
        top: 60,
        left: 18,
        child: Opacity(
          opacity: 0.08,
          child: Icon(Icons.brush, size: 60, color: Colors.blueGrey[200]),
        ),
      ),
      Positioned(
        bottom: 80,
        right: 24,
        child: Opacity(
          opacity: 0.07,
          child: Icon(Icons.gesture, size: 70, color: Colors.blueGrey[100]),
        ),
      ),
      Positioned(
        top: 180,
        right: 60,
        child: Opacity(
          opacity: 0.06,
          child: Icon(Icons.edit, size: 50, color: Colors.blueGrey[100]),
        ),
      ),
    ];
  }
}

class _WinnerRow extends StatelessWidget {
  final Map<String, dynamic> player;
  final Color themeBlue;
  final Color themeGold;
  const _WinnerRow({required this.player, required this.themeBlue, required this.themeGold});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
      decoration: BoxDecoration(
        color: themeGold.withOpacity(0.18),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: themeGold.withOpacity(0.18),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
        border: Border.all(color: themeGold, width: 2),
      ),
      child: Row(
        children: [
          const Icon(Icons.emoji_events, color: Color(0xFFFFC107), size: 32),
          const SizedBox(width: 10),
          CircleAvatar(
            radius: 22,
            backgroundColor: themeBlue.withOpacity(0.12),
            child: Text(
              (player['name'] ?? '?').toString().isNotEmpty
                  ? (player['name'] ?? '?')[0].toUpperCase()
                  : '?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: themeBlue,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      player['name'] ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: themeBlue,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: themeGold,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: themeGold.withOpacity(0.18),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Text(
                        'WINNER',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Score:  ${player['score'] ?? '0'}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Color(0xFF795548),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayerRow extends StatelessWidget {
  final Map<String, dynamic> player;
  final int rank;
  final Color color;
  final IconData? medalIcon;
  final bool isMedal;
  const _PlayerRow({
    required this.player,
    required this.rank,
    required this.color,
    this.medalIcon,
    this.isMedal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Text(
            '#$rank',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF1565C0),
            ),
          ),
          const SizedBox(width: 10),
          if (isMedal && medalIcon != null)
            Icon(medalIcon, color: color == Color(0xFFB0BEC5) ? Color(0xFFB0BEC5) : color == Color(0xFF8D6E63) ? Color(0xFF8D6E63) : Colors.amber, size: 22),
          if (isMedal) const SizedBox(width: 6),
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white,
            child: Text(
              (player['name'] ?? '?').toString().isNotEmpty
                  ? (player['name'] ?? '?')[0].toUpperCase()
                  : '?',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Color(0xFF1565C0),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              player['name'] ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            player['score']?.toString() ?? '0',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: Color(0xFF1565C0),
            ),
          ),
        ],
      ),
    );
  }
}
