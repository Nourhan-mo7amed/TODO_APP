import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/repositories/task_repository.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskRepository repository;

  TaskCubit({required this.repository}) : super(TaskInitial());

  Future<void> loadTasks() async {
    emit(TaskLoading());
    try {
      final tasks = await repository.getMainTasks();
      emit(TaskLoadedSuccess(tasks));
    } catch (e) {
      emit(TaskLoadedFailed(e.toString()));
    }
  }

  Future<void> addTask(String title, String? dueDate, String color) async {
    try {
      await repository.addMainTask(title, dueDate, color);
      await loadTasks();
    } catch (e) {
      emit(TaskLoadedFailed(e.toString()));
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await repository.deleteMainTask(taskId);
      await loadTasks();
    } catch (e) {
      emit(TaskLoadedFailed(e.toString()));
    }
  }

  Future<void> toggleFavorite(String taskId, bool isFav) async {
    try {
      await repository.toggleFavorite(taskId, isFav);
      await loadTasks();
    } catch (e) {
      emit(TaskLoadedFailed(e.toString()));
    }
  }

  Future<void> updateTaskTitle(String taskId, String title) async {
    try {
      await repository.updateTaskTitle(taskId, title);
      await loadTasks();
    } catch (e) {
      emit(TaskLoadedFailed(e.toString()));
    }
  }
}
