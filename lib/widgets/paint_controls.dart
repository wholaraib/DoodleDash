import 'package:flutter/material.dart';

class PaintControls extends StatelessWidget {
  final Color selectedColor;
  final double strokeWidth;
  final VoidCallback onSelectColor;
  final ValueChanged<double> onStrokeWidthChanged;
  final VoidCallback onClear;
  final bool canDraw;

  const PaintControls({
    Key? key,
    required this.selectedColor,
    required this.strokeWidth,
    required this.onSelectColor,
    required this.onStrokeWidthChanged,
    required this.onClear,
    required this.canDraw,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: canDraw ? onSelectColor : null,
          icon: Icon(Icons.color_lens, color: canDraw ? selectedColor : Colors.grey),
        ),
        Expanded(
          child: Slider(
            min: 1.0,
            max: 10.0,
            label: "Strokewidth $strokeWidth",
            activeColor: selectedColor,
            value: strokeWidth,
            onChanged: canDraw ? onStrokeWidthChanged : null,
          ),
        ),
        IconButton(
          onPressed: canDraw ? onClear : null,
          icon: Icon(Icons.layers_clear, color: canDraw ? selectedColor : Colors.grey),
        ),
      ],
    );
  }
}
