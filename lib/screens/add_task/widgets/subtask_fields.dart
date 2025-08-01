import 'package:flutter/material.dart';

class AddTaskSubtasks extends StatelessWidget {
  final List<TextEditingController> subtaskControllers;
  final Function(int) onRemove;

  const AddTaskSubtasks({
    super.key,
    required this.subtaskControllers,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(subtaskControllers.length, (index) {
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: subtaskControllers[index],
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: "Subtask ${index + 1}",
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (subtaskControllers.length > 1)
                  IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () => onRemove(index),
                  ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        );
      }),
    );
  }
}
