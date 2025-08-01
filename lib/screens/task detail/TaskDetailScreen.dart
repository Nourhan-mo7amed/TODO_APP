import 'package:flutter/material.dart';
import 'package:todo_app/data/sqldb.dart';
import 'widgets/s/edit_task_sheet.dart';
import 'widgets/s/subtask_tile.dart';

class TaskDetailScreen extends StatefulWidget {
  final int taskId;
  final String taskTitle;

  const TaskDetailScreen({
    super.key,
    required this.taskId,
    required this.taskTitle,
  });

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final db = Sqldb();
  bool updated = false;
  late String taskTitle;

  @override
  void initState() {
    super.initState();
    taskTitle = widget.taskTitle;
  }

  void _showEditTaskSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => EditTaskSheet(
        currentTitle: taskTitle,
        onSave: (newTitle) async {
          await db.updateData(
            "UPDATE main_tasks SET title = ? WHERE id = ?",
            [newTitle, widget.taskId],
          );
          setState(() {
            taskTitle = newTitle;
            updated = true;
          });
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> getSubTasks() =>
      db.getSubTasks(widget.taskId);

  Future<void> toggleDone(int id, bool current) async {
    await db.updateSubTaskDone(id, !current);
    updated = true;
    setState(() {});
  }

  Future<void> deleteSubTask(int id) async {
    await db.deleteSubTask(id);
    updated = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, updated);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF5A189A),
          elevation: 9,
          title: Text(
            taskTitle,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _showEditTaskSheet,
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 255, 255, 255),
                Color.fromARGB(62, 53, 14, 92),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: getSubTasks(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final subtasks = snapshot.data!;
              if (subtasks.isEmpty) {
                return const Center(
                  child: Text(
                    "No subtasks yet",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: subtasks.length,
                itemBuilder: (context, index) {
                  final sub = subtasks[index];
                  return SubtaskTile(
                    subtask: sub,
                    onToggle: () => toggleDone(sub['id'], sub['is_done'] == 1),
                    onDelete: () => deleteSubTask(sub['id']),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
