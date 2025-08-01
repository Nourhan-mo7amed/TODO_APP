import 'package:flutter/material.dart';
import 'package:todo_app/screens/add_task/Add_tasks.dart';
import 'package:todo_app/screens/home/widgets/home_app_bar.dart';
import 'package:todo_app/screens/home/widgets/task_item.dart';
import '../../data/Sqldb.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Sqldb db = Sqldb();
  final TextEditingController _searchController = TextEditingController();

  bool isSearching = false;
  String searchText = '';

  @override
  void initState() {
    super.initState();
  }

  Future<List<Map<String, dynamic>>> getMainTasks() async =>
      await db.getMainTasks();

  Future<void> _refreshTasks() async => setState(() {});

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(
        isSearching: isSearching,
        searchController: _searchController,
        onSearchChanged: (value) {
          setState(() {
            searchText = value.toLowerCase();
          });
        },
        onToggleSearch: () {
          setState(() {
            if (isSearching) {
              _searchController.clear();
              searchText = "";
            }
            isSearching = !isSearching;
          });
        },
      ),
      body: FutureBuilder(
        future: getMainTasks(),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final mainTasks = snapshot.data!
              .where(
                (task) =>
                    (task['title'] ?? '').toLowerCase().contains(searchText),
              )
              .toList();

          if (mainTasks.isEmpty) {
            return const Center(
              child: Text(
                "No tasks yet",
                style: TextStyle(color: Colors.black26, fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: mainTasks.length,
            itemBuilder: (context, index) => TaskItem(
              task: mainTasks[index],
              db: db,
              onRefresh: _refreshTasks,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => AddTaskBottomSheet(refreshTasks: _refreshTasks),
          );
        },
        backgroundColor: const Color(0xFF5A189A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
