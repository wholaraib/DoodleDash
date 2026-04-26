import 'package:flutter/material.dart';

class PaintChat extends StatelessWidget {
  final List<Widget> textBlankWidget;
  final void Function(String) onRenderTextBlank;

  const PaintChat({
    required this.textBlankWidget,
    required this.onRenderTextBlank,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
  
      children: textBlankWidget);
  }
}
