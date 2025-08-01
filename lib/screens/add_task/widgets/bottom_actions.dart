import 'package:flutter/material.dart';

class AddTaskActions extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const AddTaskActions({
    super.key,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: onCancel,
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.red, fontSize: 18),
          ),
        ),
        ElevatedButton(
          onPressed: onSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5A189A),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            "Save",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
