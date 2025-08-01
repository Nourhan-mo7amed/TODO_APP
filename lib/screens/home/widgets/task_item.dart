import 'package:flutter/material.dart';
import 'package:todo_app/screens/task%20detail/TaskDetailScreen.dart';
import 'package:todo_app/screens/home/widgets/AddSubTask.dart';
import '../../../data/Sqldb.dart';

class TaskItem extends StatelessWidget {
  final Map<String, dynamic> task;
  final Sqldb db;
  final VoidCallback onRefresh;

  const TaskItem({
    super.key,
    required this.task,
    required this.db,
    required this.onRefresh,
  });

  Widget _buildProgressBar(double percent) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: LinearProgressIndicator(
        value: percent,
        backgroundColor: Colors.grey[300],
        color: Colors.pinkAccent,
        minHeight: 8,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: db.getSubTasks(task['id']),
      builder: (context, snapshotSubs) {
        final subtasks = snapshotSubs.data ?? [];
        final done = subtasks.where((s) => s['is_done'] == 1).length;
        final percent = subtasks.isEmpty ? 0.0 : done / subtasks.length;

        return GestureDetector(
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TaskDetailScreen(
                  taskId: task['id'],
                  taskTitle: task['title'],
                ),
              ),
            );
            if (result == true) onRefresh();
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Color(
                int.parse(task['color'] ?? 'FF2196F3', radix: 16),
              ).withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Color(int.parse(task['color'] ?? 'FF2196F3', radix: 20)),
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.book_outlined, color: Colors.pinkAccent),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        task['title'],
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (task['is_favorite'] == 1)
                      const Icon(Icons.favorite, color: Colors.pinkAccent),
                    PopupMenuButton<String>(
                      onSelected: (val) async {
                        if (val == 'delete') {
                          await db.deleteMainTask(task['id']);
                          onRefresh();
                        } else if (val == 'add_item') {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            builder: (_) => AddSubTaskBottomSheet(
                              taskId: task['id'],
                              onSubTaskAdded: onRefresh,
                            ),
                          );
                        } else if (val == 'toggle_fav') {
                          final isFav = task['is_favorite'] == 1;
                          await db.toggleFavorite(task['id'], !isFav);
                          onRefresh();
                        }
                      },
                      icon: Icon(Icons.more_vert, color: Colors.grey[800]),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          value: 'toggle_fav',
                          child: Row(
                            children: [
                              Icon(
                                task['is_favorite'] == 1
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.pink,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                task['is_favorite'] == 1
                                    ? 'Unfavorite'
                                    : 'Favorite',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'add_item',
                          child: Row(
                            children: const [
                              Icon(Icons.add, color: Color(0xFF5A189A)),
                              SizedBox(width: 10),
                              Text('Add Item', style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: const [
                              Icon(
                                Icons.delete_outline,
                                color: Colors.redAccent,
                              ),
                              SizedBox(width: 10),
                              Text('Delete', style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  "${subtasks.length} items",
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                _buildProgressBar(percent),
                const SizedBox(height: 6),
                Text(
                  "${(percent * 100).toInt()}%",
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
