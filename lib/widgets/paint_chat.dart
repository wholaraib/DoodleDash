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
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      child: ListView.builder(
        controller: scrollController,
        shrinkWrap: true,
        itemCount: messages.length, // Replace with your actual message count
        itemBuilder: (context, index) {
          var message = messages[index].values;
          return ListTile(
            title: Text(
              message.elementAt(0),
              style: TextStyle(
                color: Colors.black,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              message.elementAt(1),
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          );
        },
      ),
    );
  }
}
