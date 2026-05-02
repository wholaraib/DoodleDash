import 'package:flutter/material.dart';

class PaintChat extends StatelessWidget {
  const PaintChat({
    super.key,
    required this.scrollController,
    required this.messages,
  });

  final ScrollController scrollController;
  final List<Map> messages;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        var message = messages[index];
        return ListTile(
          title: Text(
            message['playerName'] ?? 'Unknown',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            message['message'] ?? '',
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
        );
      },
    );
  }
}
