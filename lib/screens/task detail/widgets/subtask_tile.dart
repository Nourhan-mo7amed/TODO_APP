import 'package:flutter/material.dart';

class SubtaskTile extends StatelessWidget {
  final Map<String, dynamic> subtask;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const SubtaskTile({
    super.key,
    required this.subtask,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = subtask['is_done'] == 1;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      color: Colors.white,
      shadowColor: Colors.grey.shade300,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: Checkbox(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          activeColor: const Color(0xFF5A189A),
          value: isDone,
          onChanged: (_) => onToggle(),
        ),
        title: Text(
          subtask['content'],
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: isDone ? Colors.grey : Colors.black87,
            decoration: isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
