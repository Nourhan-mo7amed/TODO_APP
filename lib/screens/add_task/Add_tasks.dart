import 'package:flutter/material.dart';
import 'package:todo_app/screens/add_task/widgets/bottom_actions.dart';
import 'package:todo_app/screens/add_task/widgets/color_picker.dart';
import 'package:todo_app/screens/add_task/widgets/date_picker.dart';
import 'package:todo_app/screens/add_task/widgets/subtask_fields.dart';
import 'package:todo_app/screens/add_task/widgets/title_field.dart';
import '../../../data/Sqldb.dart';

class AddTaskBottomSheet extends StatefulWidget {
  final Function refreshTasks;
  const AddTaskBottomSheet({Key? key, required this.refreshTasks})
    : super(key: key);

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final List<TextEditingController> subtaskControllers = [];
  final Sqldb db = Sqldb();

  DateTime? selectedDate;
  Color selectedColor = const Color(0xFF5A189A);

  @override
  void initState() {
    super.initState();
    addSubtaskField();
  }

  void addSubtaskField() {
    setState(() => subtaskControllers.add(TextEditingController()));
  }

  void removeSubtaskField(int index) {
    setState(() => subtaskControllers.removeAt(index));
  }

  Future<void> saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    final mainTaskId = await db.insertMainTask(
      titleController.text.trim(),
      selectedDate?.toString().split(" ")[0],
      selectedColor.value.toRadixString(16),
    );

    for (var controller in subtaskControllers) {
      final text = controller.text.trim();
      if (text.isNotEmpty) {
        await db.insertSubTask(mainTaskId, text);
      }
    }

    widget.refreshTasks();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    titleController.dispose();
    for (var controller in subtaskControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Add New Task",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5A189A),
                  ),
                ),
                const SizedBox(height: 15),
                AddTaskTitleField(controller: titleController),
                const SizedBox(height: 15),
                AddTaskDatePicker(
                  selectedDate: selectedDate,
                  onDateSelected: (date) => setState(() => selectedDate = date),
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Select Color",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                AddTaskColorPicker(
                  selectedColor: selectedColor,
                  onColorSelected: (color) =>
                      setState(() => selectedColor = color),
                ),
                const SizedBox(height: 25),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Subtasks",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                AddTaskSubtasks(
                  subtaskControllers: subtaskControllers,
                  onRemove: removeSubtaskField,
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: addSubtaskField,
                    icon: const Icon(Icons.add, color: Color(0xFF5A189A)),
                    label: const Text(
                      "Add Subtask",
                      style: TextStyle(color: Color(0xFF5A189A)),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                AddTaskActions(
                  onCancel: () => Navigator.pop(context),
                  onSave: saveTask,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
