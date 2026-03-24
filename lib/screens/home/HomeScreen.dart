import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubits/auth/auth_cubit.dart';
import 'package:todo_app/cubits/tasks/task_cubit.dart';
import 'package:todo_app/repositories/auth_repository.dart';
import 'package:todo_app/screens/add_task/Add_tasks.dart';
import 'package:todo_app/screens/auth/LoginScreen.dart';
import 'package:todo_app/screens/home/widgets/home_app_bar.dart';
import 'package:todo_app/screens/home/widgets/task_item.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  late AuthCubit _authCubit;
  late AuthRepository _authRepository;
  String username = '';

  bool isSearching = false;
  String searchText = '';

  @override
  void initState() {
    super.initState();
    _authRepository = AuthRepository();
    _authCubit = AuthCubit(repository: _authRepository);
    // Load tasks using the TaskCubit from the app level
    context.read<TaskCubit>().loadTasks();
    _loadUsername();
  }

  void _loadUsername() async {
    try {
      final name = await _authRepository.getStoredUsername();
      setState(() {
        username = name ?? '';
      });
    } catch (e) {
      debugPrint('Error loading username: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _authCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>.value(
      value: _authCubit,
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthLoggedOut) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            );
          } else if (state is AuthLoggedIn) {
            // Reload username when user logs in
            _loadUsername();
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: HomeAppBar(
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
            username: username,
          ),
          body: BlocBuilder<TaskCubit, TaskState>(
            builder: (context, state) {
              if (state is TaskLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is TaskLoadedFailed) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: ${state.error}',
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.read<TaskCubit>().loadTasks(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (state is TaskLoadedSuccess) {
                final mainTasks = state.tasks
                    .where(
                      (task) => (task['title'] ?? '')
                          .toLowerCase()
                          .contains(searchText),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: mainTasks.length,
                  itemBuilder: (context, index) => TaskItem(
                    task: mainTasks[index],
                    onRefresh: () => context.read<TaskCubit>().loadTasks(),
                  ),
                );
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => AddTaskBottomSheet(
                  refreshTasks: () => context.read<TaskCubit>().loadTasks(),
                ),
              );
            },
            backgroundColor: const Color(0xFF5A189A),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
