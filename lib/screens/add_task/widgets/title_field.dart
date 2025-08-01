import 'package:flutter/material.dart';

class AddTaskTitleField extends StatelessWidget {
  final TextEditingController controller;

  const AddTaskTitleField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: "Task title...",
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
      validator: (value) =>
          (value == null || value.trim().isEmpty) ? 'Title is required' : null,
    );
  }
}
