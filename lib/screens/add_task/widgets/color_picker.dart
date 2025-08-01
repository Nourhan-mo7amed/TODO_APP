import 'package:flutter/material.dart';

class AddTaskColorPicker extends StatelessWidget {
  final Color selectedColor;
  final Function(Color) onColorSelected;

  const AddTaskColorPicker({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    List<Color> colors = [
      Colors.indigo,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.blueGrey,
    ];

    return Wrap(
      spacing: 10,
      children: colors.map((color) {
        return GestureDetector(
          onTap: () => onColorSelected(color),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: color,
            child: selectedColor == color
                ? const Icon(Icons.check, color: Colors.white)
                : null,
          ),
        );
      }).toList(),
    );
  }
}
