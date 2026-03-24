import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/repositories/task_repository.dart';

part 'subtask_state.dart';

class SubTaskCubit extends Cubit<SubTaskState> {
  final TaskRepository repository;

  SubTaskCubit({required this.repository}) : super(SubTaskInitial());

  Future<void> loadSubTasks(String taskId) async {
    emit(SubTaskLoading());
    try {
      final subTasks = await repository.getSubTasks(taskId);
      emit(SubTaskLoadedSuccess(subTasks));
    } catch (e) {
      emit(SubTaskLoadedFailed(e.toString()));
    }
  }

  Future<void> addSubTask(String taskId, String content) async {
    try {
      await repository.addSubTask(taskId, content);
      await loadSubTasks(taskId);
    } catch (e) {
      emit(SubTaskLoadedFailed(e.toString()));
    }
  }

  Future<void> toggleSubTaskDone(
      String taskId, String subTaskId, bool isDone) async {
    try {
      await repository.toggleSubTaskDone(taskId, subTaskId, isDone);
      await loadSubTasks(taskId);
    } catch (e) {
      emit(SubTaskLoadedFailed(e.toString()));
    }
  }

  Future<void> deleteSubTask(String taskId, String subTaskId) async {
    try {
      await repository.deleteSubTask(taskId, subTaskId);
      await loadSubTasks(taskId);
    } catch (e) {
      emit(SubTaskLoadedFailed(e.toString()));
    }
  }
}
