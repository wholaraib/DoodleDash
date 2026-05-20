import 'package:flutter/material.dart';

class Leaderboard extends StatelessWidget {
  final List<Map<String, dynamic>> players;
  final String currentPlayerName;

  const Leaderboard({
    Key? key,
    required this.players,
    required this.currentPlayerName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.all(8),
      color: Colors.white,
      child: Container(
        width: 240,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.leaderboard, color: Color(0xFF1565C0), size: 26),
                SizedBox(width: 8),
                Text(
                  'Leaderboard',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xFF1565C0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ...players.asMap().entries.map((entry) {
              final idx = entry.key;
              final player = entry.value;
              final isCurrent = player['name'] == currentPlayerName;
              final isTop = idx == 0;
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? const Color(0xFFE3F2FD)
                          : isTop
                              ? const Color(0xFFFFF9C4)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: isCurrent
                          ? Border.all(color: Color(0xFF1565C0), width: 1.2)
                          : null,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    child: Row(
                      children: [
                        if (isTop)
                          const Padding(
                            padding: EdgeInsets.only(right: 6),
                            child: Icon(Icons.emoji_events, color: Color(0xFFFFC107), size: 20),
                          ),
                        Expanded(
                          child: Text(
                            player['name'] ?? '',
                            style: TextStyle(
                              fontWeight: isCurrent || isTop ? FontWeight.bold : FontWeight.normal,
                              color: isCurrent
                                  ? Color(0xFF1565C0)
                                  : isTop
                                      ? Color(0xFF795548)
                                      : Colors.black,
                              fontSize: 15,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          player['score']?.toString() ?? '0',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isCurrent
                                ? Color(0xFF1565C0)
                                : isTop
                                    ? Color(0xFF795548)
                                    : Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (idx != players.length - 1)
                    const Divider(height: 14, thickness: 0.7, color: Color(0xFFE0E0E0)),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
