import 'package:flutter/material.dart';

class AddTaskDatePicker extends StatelessWidget {
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;

  const AddTaskDatePicker({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) onDateSelected(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: Color(0xFF5A189A), size: 28),
            const SizedBox(width: 12),
            Text(
              selectedDate == null
                  ? "Select due date"
                  : "${selectedDate!.toLocal()}".split(' ')[0],
            ),
          ],
        ),
      ),
    );
  }
}
