import 'package:flutter/material.dart';

class EditTaskSheet extends StatelessWidget {
  final String currentTitle;
  final Function(String) onSave;

  const EditTaskSheet({
    super.key,
    required this.currentTitle,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: currentTitle);

    return Padding(
      padding: MediaQuery.of(context).viewInsets.add(const EdgeInsets.all(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Edit Task Title",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5A189A),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter new title',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton.icon(
            onPressed: () {
              final newTitle = controller.text.trim();
              if (newTitle.isNotEmpty) {
                onSave(newTitle);
                Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.save),
            label: const Text("Save"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5A189A),
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
