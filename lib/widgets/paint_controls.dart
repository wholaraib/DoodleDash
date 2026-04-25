import 'package:flutter/material.dart';

class PaintControls extends StatelessWidget {
  final Color selectedColor;
  final double strokeWidth;
  final VoidCallback onSelectColor;
  final ValueChanged<double> onStrokeWidthChanged;
  final VoidCallback onClear;

  const PaintControls({
    Key? key,
    required this.selectedColor,
    required this.strokeWidth,
    required this.onSelectColor,
    required this.onStrokeWidthChanged,
    required this.onClear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onSelectColor,
          icon: Icon(Icons.color_lens, color: selectedColor),
        ),
        Expanded(
          child: Slider(
            min: 1.0,
            max: 10.0,
            label: "Strokewidth $strokeWidth",
            activeColor: selectedColor,
            value: strokeWidth,
            onChanged: onStrokeWidthChanged,
          ),
        ),
        IconButton(
          onPressed: onClear,
          icon: Icon(Icons.layers_clear, color: selectedColor),
        ),
      ],
    );
  }
}
