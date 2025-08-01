import 'package:flutter/material.dart';
import '../../../data/Sqldb.dart';

class AddSubTaskBottomSheet extends StatefulWidget {
  final int taskId;
  final Function onSubTaskAdded;

  const AddSubTaskBottomSheet({
    super.key,
    required this.taskId,
    required this.onSubTaskAdded,
  });

  @override
  State<AddSubTaskBottomSheet> createState() => _AddSubTaskSheet();
}

class _AddSubTaskSheet extends State<AddSubTaskBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  bool isLoading = false;

  void _addSubTask() async {
    if (_controller.text.trim().isEmpty) return;
    setState(() => isLoading = true);
    await Sqldb().insertSubTask(widget.taskId, _controller.text.trim());
    widget.onSubTaskAdded();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets.add(const EdgeInsets.all(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Add Subtask',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF5A189A),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Subtask title',
              filled: true,
              fillColor: Colors.grey[300],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: isLoading ? null : _addSubTask,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5A189A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.white,
                    ),
                  )
                : const Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
